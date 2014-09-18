//
//  PXExpressionAssembler.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/28/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionAssembler.h"

#import "PXExpressionLexeme.h"
#import "PXExpressionLexemeType.h"
#import "PXExpressionNodeBuilder.h"
#import "PXBlockNode.h"

#import "PXExpressionNodeCompiler.h"
#import "PXScope.h"

void expr_lexer_set_source(NSString *source, BOOL forEma);
PXExpressionLexeme *expr_lexer_get_lexeme();
void expr_lexer_delete_buffer();

@interface PXExpressionAssembler ()
@property (nonatomic, strong) PXScope *currentScope;
@property (nonatomic, strong, readonly) NSString *trimmedString;
@end

@implementation PXExpressionAssembler

static NSIndexSet *CREATE_ARRAY_SET;
static NSIndexSet *CREATE_OBJECT_SET;
static PXExpressionNodeBuilder *NODE_BUILDER;

+ (void)initialize
{
    if (CREATE_ARRAY_SET == nil)
    {
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        [set addIndex:EMA_CREATE_ARRAY];
        [set addIndex:EM_RBRACKET];
        CREATE_ARRAY_SET = [[NSIndexSet alloc] initWithIndexSet:set];
    }
    if (CREATE_OBJECT_SET == nil)
    {
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        [set addIndex:EMA_CREATE_OBJECT];
        [set addIndex:EMA_RBRACKET_CURLY];
        CREATE_OBJECT_SET = [[NSIndexSet alloc] initWithIndexSet:set];
    }
    if (NODE_BUILDER == nil)
    {
        NODE_BUILDER = [[PXExpressionNodeBuilder alloc] init];
    }
}

- (PXExpressionUnit *)assembleString:(NSString *)source
{
    PXBlockNode *block = [NODE_BUILDER createBlockNode];

    // setup initial scope
    _currentScope = [[PXScope alloc] init];

    // setup source on lexer and prime lexeme pump
    expr_lexer_set_source((source != nil) ? source : @"", YES);
    [self advance];

    // parse
    @try
    {
        while (currentLexeme != nil && currentLexeme.type != 0)
        {
            PXExpressionLexeme *startLexeme = currentLexeme;

            if ([self isType:EMA_FUNC])
            {
                [block addNode:[self parseFunctionDeclaration]];
            }
            else
            {
                [block addNode:[self parseInstruction]];
            }

            if (startLexeme == currentLexeme)
            {
                [self errorWithMessage:@"Parser was unable to process the current lexeme. Aborting to prevent an infinite loop"];
            }
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"The following exception occurred during parsing: %@", exception);
    }
    @finally
    {
        expr_lexer_delete_buffer();
    }

    PXExpressionNodeCompiler *compiler = [[PXExpressionNodeCompiler alloc] init];
    PXExpressionByteCode *byteCode = [compiler compileNode:block withScope:_currentScope];

    return [[PXExpressionUnit alloc] initWithByteCode:byteCode scope:_currentScope ast:block];
}

- (id<PXExpressionNode>)parseFunctionDeclaration
{
    [self assertTypeAndAdvance:EMA_FUNC];

    // grab function name
    NSString *name = [self getName];

    // '('
    [self assertTypeAndAdvance:EM_LPAREN];

    // comma-delimited list
    NSMutableArray *parameters = nil;

    if ([self isType:EM_IDENTIFIER])
    {
        parameters = [[NSMutableArray alloc] init];

        // add parameter
        [parameters addObject:[self parseParameter]];

        while ([self isType:EM_COMMA])
        {
            // advance over ','
            [self advance];

            // add parameter
            [parameters addObject:[self parseParameter]];
        }
    }

    // ')'
    [self assertTypeAndAdvance:EM_RPAREN];

    // expressions
    PXBlockNode *body = [self parseInstructionBlock];

    return [NODE_BUILDER createFunctionDefinitionNode:name parameters:parameters body:body];
}

- (id<PXExpressionNode>)parseParameter
{
    [self assertType:EM_IDENTIFIER];

    // grab namne
    NSString *name = currentLexeme.text;
    [self advance];

    // get default value
    id<PXExpressionNode> defaultValue;

    if ([self isType:EM_ASSIGN])
    {
        [self advance];
        defaultValue = [self parseSimpleType];
    }
    else
    {
        defaultValue = [NODE_BUILDER createUndefinedNode];
    }

    return [NODE_BUILDER createParameterNode:name defaultValue:defaultValue];
}

- (id<PXExpressionNode>)parseInstructionBlock
{
    PXBlockNode *result = [NODE_BUILDER createBlockNode];

    // '{'
    [self assertTypeAndAdvance:EM_LCURLY];

    while (currentLexeme != nil && currentLexeme.type != EM_EOF && currentLexeme.type != EM_RCURLY)
    {
        id<PXExpressionNode> expression = [self parseInstruction];

        [result addNode:expression];
    }

    // '}'
    [self assertTypeAndAdvance:EM_RCURLY];

    return result;
}

- (id<PXExpressionNode>)parseInstruction
{
    id<PXExpressionNode> result = nil;

    switch (currentLexeme.type)
    {
        case EMA_APPLY:
            result = [self parseApply];
            break;

        case EMA_EXEC:
            result = [NODE_BUILDER createExecuteNode];
            break;

        case EMA_INVOKE:
            result = [self parseInvoke];
            break;

        // array and object methods
        case EMA_GET_ELEMENT:
            result = [self parseGetElement];
            break;

        case EMA_GET_PROPERTY:
            result = [self parseGetProperty];
            break;

        case EMA_GET_SYMBOL:
            result = [self parseGetSymbol];
            break;

        case EMA_SET_SYMBOL:
            result = [self parseSetSymbol];
            break;

        case EMA_PUSH:
            result = [self parsePush];
            break;

            // push shortcuts
        case EM_TRUE:
        case EM_FALSE:
        case EM_STRING:
        case EM_NUMBER:
        case EM_NULL:
        case EM_UNDEFINED:
        case EMA_MARK:
        case EM_LBRACKET:
        case EMA_LCURLY_BRACKET:
            result = [self parseValue];
            break;

        // scopes
        case EMA_GLOBAL:
            result = [NODE_BUILDER createPushGlobalNode];
            [self advance];
            break;

        case EMA_DUP:
            result = [NODE_BUILDER createDuplicateNode];
            [self advance];
            break;

        case EMA_SWAP:
            result = [NODE_BUILDER createSwapNode];
            [self advance];
            break;

        // math
        case EMA_ADD:
            result = [NODE_BUILDER createAddNode];
            [self advance];
            break;

        case EMA_SUB:
            result = [NODE_BUILDER createSubtractNode];
            [self advance];
            break;

        case EMA_MUL:
            result = [NODE_BUILDER createMultiplyNode];
            [self advance];
            break;

        case EMA_DIV:
            result = [NODE_BUILDER createDivideNode];
            [self advance];
            break;
            
        case EMA_MOD:
            result = [NODE_BUILDER createModulusNode];
            [self advance];
            break;

        // boolean logic
        case EM_AND:
            result = [NODE_BUILDER createAndNode];
            [self advance];
            break;

        case EM_OR:
            result = [NODE_BUILDER createOrNode];
            [self advance];
            break;

        case EM_NOT:
            result = [NODE_BUILDER createNotNode];
            [self advance];
            break;

        // comparison
        case EM_LT:
            result = [NODE_BUILDER createLessThanNode];
            [self advance];
            break;

        case EM_LE:
            result = [NODE_BUILDER createLessThanOrEqualNode];
            [self advance];
            break;

        case EM_EQ:
            result = [NODE_BUILDER createEqualNode];
            [self advance];
            break;

        case EM_NE:
            result = [NODE_BUILDER createNotEqualNode];
            [self advance];
            break;

        case EM_GE:
            result = [NODE_BUILDER createGreaterThanOrEqualNode];
            [self advance];
            break;

        case EM_GT:
            result = [NODE_BUILDER createGreaterThanNode];
            [self advance];
            break;

        // flow
        case EMA_IF_ELSE:
            result = [NODE_BUILDER createIfElseNode];
            [self advance];
            break;

        case EMA_CREATE_ARRAY:
        case EM_RBRACKET:
            result = [self parseCreateArray];
            break;

        case EMA_CREATE_OBJECT:
        case EMA_RBRACKET_CURLY:
            result = [self parseCreateObject];
            break;

        case EM_DOT:
            result = [self parseGetPropertyShortcut];
            break;

        case EMA_CARET:
            result = [self parseGetSymbolShortcut];
            break;

        case EMA_CARET_ASSIGN:
            result = [self parseSetSymbolShortcut];
            break;

        case EM_LESS_THAN:
            result = [self parseApplyShortcut];
            break;

        case EM_GREATER_THAN:
            result = [self parseInvokeShortcut];
            break;

        case EM_IF:
            result = [self parseIf];
            break;

        case EM_LCURLY:
        {
            PXBlockNode *block = [self parseInstructionBlock];

            block.blockValue = YES;

            result = block;
            break;
        }

        default:
            [self errorWithMessage:@"Unrecognized token for start of statement"];
    }

    return result;
}

- (id<PXExpressionNode>)parsePush
{
    id<PXExpressionNode> result = nil;

    [self assertTypeAndAdvance:EMA_PUSH];

    // '('
    [self assertTypeAndAdvance:EM_LPAREN];

    // parse value
    result = [self parseValue];

    // ')'
    [self assertTypeAndAdvance:EM_RPAREN];

    return result;
}

- (id<PXExpressionNode>)parseValue
{
    id<PXExpressionNode> result = nil;

    // value
    switch (currentLexeme.type)
    {
        case EM_TRUE:
            result = [NODE_BUILDER createBooleanNode:YES];
            [self advance];
            break;

        case EM_FALSE:
            result = [NODE_BUILDER createBooleanNode:NO];
            [self advance];
            break;

        case EM_STRING:
        {
            result = [NODE_BUILDER createStringNode:self.trimmedString];
            [self advance];
            break;
        }

        case EM_NUMBER:
            result = [NODE_BUILDER createNumberNode:[currentLexeme.text doubleValue]];
            [self advance];
            break;

        case EM_NULL:
            result = [NODE_BUILDER createNullNode];
            [self advance];
            break;

        case EM_UNDEFINED:
            result = [NODE_BUILDER createUndefinedNode];
            [self advance];
            break;

        case EMA_MARK:
        case EM_LBRACKET:
        case EMA_LCURLY_BRACKET:
            result = [NODE_BUILDER createPushMarkNode];
            [self advance];
            break;

        case EMA_GLOBAL:
            result = [NODE_BUILDER createPushGlobalNode];
            [self advance];
            break;

        default:
            [self errorWithMessage:@"Unsupport push parameter type"];
    }

    return result;
}

- (id<PXExpressionNode>)parseCreateArray
{
    id<PXExpressionNode> result = nil;

    [self assertTypeInSet:CREATE_ARRAY_SET];
    [self advance];

    if ([self isType:EM_LPAREN])
    {
        // advance over '('
        [self advance];

        // grab number
        [self assertType:EM_NUMBER];
        uint count = [currentLexeme.text intValue];
        result = [NODE_BUILDER createCreateArrayNodeCount:count];
        [self advance];

        // advance over ')'
        [self assertTypeAndAdvance:EM_RPAREN];
    }
    else
    {
        result = [NODE_BUILDER createCreateArrayNode];
    }

    return result;
}

- (id<PXExpressionNode>)parseCreateObject
{
    id<PXExpressionNode> result = nil;

    [self assertTypeInSet:CREATE_OBJECT_SET];
    [self advance];

    if ([self isType:EM_LPAREN])
    {
        // advance over '('
        [self advance];

        // grab number
        [self assertType:EM_NUMBER];
        uint count = [currentLexeme.text intValue];
        result = [NODE_BUILDER createCreateObjectNodeCount:count];
        [self advance];

        // advance over ')'
        [self assertTypeAndAdvance:EM_RPAREN];
    }
    else
    {
        result = [NODE_BUILDER createCreateObjectNode];
    }

    return result;
}

- (id<PXExpressionNode>)parseGetSymbol
{
    id<PXExpressionNode> result = nil;

    [self assertTypeAndAdvance:EMA_GET_SYMBOL];

    // parse optional symbol name
    if ([self isType:EM_LPAREN])
    {
        // advance over '('
        [self advance];

        // grab name
        NSString *name = [self getName];

        if (name != nil)
        {
            result = [NODE_BUILDER createGetSymbolNodeWithName:name];
        }
        else
        {
            [self errorWithMessage:@"Expected a STRING or IDENTIFER after CARET"];
        }

        [self assertTypeAndAdvance:EM_RPAREN];
    }
    else
    {
        result = [NODE_BUILDER createGetSymbolNode];
    }

    return result;
}

- (id<PXExpressionNode>)parseSetSymbol
{
    id<PXExpressionNode> result = nil;

    [self assertTypeAndAdvance:EMA_SET_SYMBOL];

    // parse optional symbol name
    if ([self isType:EM_LPAREN])
    {
        // advance over '('
        [self advance];

        // grab name
        NSString *name = [self getName];

        if (name != nil)
        {
            result = [NODE_BUILDER createSetSymbolNodeWithName:name];
        }
        else
        {
            [self errorWithMessage:@"Expected a STRING or IDENTIFER after CARET"];
        }

        [self assertTypeAndAdvance:EM_RPAREN];
    }
    else
    {
        result = [NODE_BUILDER createSetSymbolNode];
    }

    return result;
}

- (id<PXExpressionNode>)parseGetSymbolShortcut
{
    id<PXExpressionNode> result = nil;

    [self assertTypeAndAdvance:EMA_CARET];

    // grab name
    NSString *name = [self getName];

    if (name != nil)
    {
        result = [NODE_BUILDER createGetSymbolNodeWithName:name];
    }
    else
    {
        result = [NODE_BUILDER createGetSymbolNode];
    }

    return result;
}

- (id<PXExpressionNode>)parseSetSymbolShortcut
{
    id<PXExpressionNode> result = nil;

    [self assertTypeAndAdvance:EMA_CARET_ASSIGN];

    // grab name
    NSString *name = [self getName];

    if (name != nil)
    {
        result = [NODE_BUILDER createSetSymbolNodeWithName:name];
    }
    else
    {
        result = [NODE_BUILDER createSetSymbolNode];
    }

    return result;
}

- (id<PXExpressionNode>)parseGetElement
{
    id<PXExpressionNode> result = nil;

    [self assertTypeAndAdvance:EMA_GET_ELEMENT];

    // parse optional property name
    if ([self isType:EM_LPAREN])
    {
        // advance over '('
        [self advance];

        // grab number
        if ([self isType:EM_NUMBER])
        {
            uint count = [currentLexeme.text intValue];

            result = [NODE_BUILDER createGetElementNodeCount:count];

            // advance over number
            [self advance];
        }
        else
        {
            [self errorWithMessage:@"Expected a NUMBER after LPAREN"];
        }

        [self assertTypeAndAdvance:EM_RPAREN];
    }
    else
    {
        result = [NODE_BUILDER createGetElementNode];
    }

    return result;
}

- (id<PXExpressionNode>)parseGetProperty
{
    id<PXExpressionNode> result = nil;

    [self assertTypeAndAdvance:EMA_GET_PROPERTY];

    // parse optional property name
    if ([self isType:EM_LPAREN])
    {
        // advance over '('
        [self advance];

        // grab name
        NSString *name = [self getName];

        if (name != nil)
        {
            result = [NODE_BUILDER createGetPropertyNodeWithName:name];
        }
        else
        {
            [self errorWithMessage:@"Expected a STRING or IDENTIFER after LPAREN"];
        }

        [self assertTypeAndAdvance:EM_RPAREN];
    }
    else
    {
        result = [NODE_BUILDER createGetPropertyNode];
    }

    return result;
}

- (id<PXExpressionNode>)parseGetPropertyShortcut
{
    id<PXExpressionNode> result = nil;

    // advance over '.'
    [self assertTypeAndAdvance:EM_DOT];

    // grab name
    NSString *name = [self getName];

    if (name != nil)
    {
        result = [NODE_BUILDER createGetPropertyNodeWithName:name];
    }
    else
    {
        result = [NODE_BUILDER createGetPropertyNode];
    }

    return result;
}

- (id<PXExpressionNode>)parseInvoke
{
    id<PXExpressionNode> result = nil;

    [self assertTypeAndAdvance:EMA_INVOKE];

    // parse optional function name
    if ([self isType:EM_LPAREN])
    {
        // advance over '('
        [self advance];

        // grab name
        NSString *name = [self getName];

        if (name != nil)
        {
            if ([self isType:EM_COMMA])
            {
                // advance over ','
                [self advance];

                // grab number
                [self assertType:EM_NUMBER];
                uint count = [currentLexeme.text intValue];
                result = [NODE_BUILDER createInvokeNodeWithName:name count:count];
                [self advance];
            }
            else
            {
                result = [NODE_BUILDER createInvokeNodeWithName:name];
            }
        }
        else
        {
            if ([self isType:EM_NUMBER])
            {
                uint count = [currentLexeme.text intValue];
                result = [NODE_BUILDER createInvokeNodeCount:count];
                [self advance];
            }
            else
            {
                [self errorWithMessage:@"Expected a STRING, IDENTIFER, or NUMBER after LPAREN"];
            }
        }

        [self assertTypeAndAdvance:EM_RPAREN];
    }
    else
    {
        result = [NODE_BUILDER createInvokeNode];
    }

    return result;
}

- (id<PXExpressionNode>)parseInvokeShortcut
{
    id<PXExpressionNode> result = nil;

    [self assertTypeAndAdvance:EM_GREATER_THAN];

    // grab name
    NSString *name = [self getName];

    if (name != nil)
    {
        if ([self isType:EM_LPAREN])
        {
            // advance over '('
            [self advance];

            // grab number
            [self assertType:EM_NUMBER];
            uint count = [currentLexeme.text intValue];
            result = [NODE_BUILDER createInvokeNodeWithName:name count:count];
            [self advance];

            // advance over ')'
            [self assertTypeAndAdvance:EM_RPAREN];
        }
        else
        {
            result = [NODE_BUILDER createInvokeNodeWithName:name];
        }
    }
    else if ([self isType:EM_LPAREN])
    {
        // advance over '('
        [self advance];

        // grab number
        [self assertType:EM_NUMBER];
        uint count = [currentLexeme.text intValue];
        result = [NODE_BUILDER createInvokeNodeCount:count];
        [self advance];

        // advance over ')'
        [self assertTypeAndAdvance:EM_RPAREN];
    }
    else
    {
        result = [NODE_BUILDER createInvokeNode];
    }

    return result;
}

- (id<PXExpressionNode>)parseApply
{
    id<PXExpressionNode> result = nil;

    [self assertTypeAndAdvance:EMA_APPLY];

    if ([self isType:EM_LPAREN])
    {
        // advance over '('
        [self advance];

        // grab name
        NSString *name = [self getName];
        result = [NODE_BUILDER createApplyNodeWithName:name];

        // advance over ')'
        [self assertTypeAndAdvance:EM_RPAREN];
    }
    else
    {
        result = [NODE_BUILDER createApplyNode];
    }

    return result;
}

- (id<PXExpressionNode>)parseApplyShortcut
{
    id<PXExpressionNode> result = nil;

    [self assertTypeAndAdvance:EM_LESS_THAN];

    // grab name
    NSString *name = [self getName];

    if (name != nil)
    {
        result = [NODE_BUILDER createApplyNodeWithName:name];
    }
    else
    {
        result = [NODE_BUILDER createApplyNode];
    }

    return result;
}

- (id<PXExpressionNode>)parseIf
{
    id<PXExpressionNode> result = nil;

    // assert 'if'
    [self assertTypeAndAdvance:EM_IF];

    if ([self isType:EM_LPAREN])
    {
        // assert '('
        [self assertTypeAndAdvance:EM_LPAREN];

        // parse condition
        PXBlockNode *condition = [[PXBlockNode alloc] init];

        while (currentLexeme != nil && currentLexeme.type != EM_EOF && currentLexeme.type != EM_RPAREN)
        {
            id<PXExpressionNode> instruction = [self parseInstruction];

            [condition addNode:instruction];
        }

        // assert ')'
        [self assertTypeAndAdvance:EM_RPAREN];

        // parse true block
        PXBlockNode *trueBlock = [self parseInstructionBlock];
        PXBlockNode *falseBlock = nil;

        if ([self isType:EM_ELSE])
        {
            // advance over 'else'
            [self advance];

            falseBlock = [self parseInstructionBlock];
        }

        result = [NODE_BUILDER createIfNode:condition trueBlock:trueBlock falseBlock:falseBlock];
    }
    else
    {
        result = [NODE_BUILDER createIfNode];
    }

    return result;
}

#pragma mark - Helper methods

- (id<PXExpressionNode>)parseSimpleType
{
    id<PXExpressionNode> result = nil;

    switch (currentLexeme.type)
    {
        case EM_NUMBER:
            result = [NODE_BUILDER createNumberNode:[currentLexeme.text doubleValue]];

            // advance over number
            [self advance];
            break;

        case EM_TRUE:
            result = [NODE_BUILDER createBooleanNode:YES];

            // advance over 'true'
            [self advance];
            break;

        case EM_FALSE:
            result = [NODE_BUILDER createBooleanNode:NO];

            // advance over 'false'
            [self advance];
            break;

        case EM_STRING:
            result = [NODE_BUILDER createStringNode:self.strippedString];
            break;

        case EM_NULL:
            result = [NODE_BUILDER createNullNode];

            // advance over 'null'
            [self advance];
            break;

        case EM_UNDEFINED:
            result = [NODE_BUILDER createUndefinedNode];

            // advance over 'undefined'
            [self advance];
            break;

        default:
            [self errorWithMessage:@"Unknown simple type. Expted NUMBER, T, F, or STRING"];
    }

    return result;
}

- (NSString *)strippedString
{
    NSString *result = nil;

    if ([self isType:EM_STRING])
    {
        NSString *string = currentLexeme.text;

        result = [string substringWithRange:NSMakeRange(1, string.length - 2)];

        // advance over string
        [self advance];
    }

    return result;
}

- (id<PXLexeme>)advance
{
    return currentLexeme = expr_lexer_get_lexeme();
}

- (NSString *)trimmedString
{
    NSString *string = currentLexeme.text;

    return[string substringWithRange:NSMakeRange(1, string.length - 2)];
}

- (NSString *)getName
{
    NSString *result = nil;

    if ([self isType:EM_IDENTIFIER])
    {
        result = currentLexeme.text;
        [self advance];
    }
    else if ([self isType:EM_STRING])
    {
        result = self.trimmedString;
        [self advance];
    }

    return result;
}

@end
