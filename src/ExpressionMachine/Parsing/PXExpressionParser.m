//
//  PXExpressionParser.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/26/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionParser.h"

#import "PXExpressionLexeme.h"
#import "PXExpressionLexemeType.h"
#import "PXExpressionNodeBuilder.h"

#import "PXExpressionNodeCompiler.h"
#import "PXScope.h"

void expr_lexer_set_source(NSString *source, BOOL forEma);
PXExpressionLexeme *expr_lexer_get_lexeme();
void expr_lexer_delete_buffer();

@interface PXExpressionParser ()
@property (nonatomic, strong) PXScope *currentScope;
@property (nonatomic, strong, readonly) NSString *strippedString;
@end

@implementation PXExpressionParser

static NSIndexSet *LOGICAL_OR_SET;
static NSIndexSet *LOGICAL_AND_SET;
static NSIndexSet *EQUALITY_OPERATORS_SET;
static NSIndexSet *RELATIONAL_OPERATORS_SET;
static NSIndexSet *MULTIPLICATIVE_OPERATORS_SET;
static NSIndexSet *ADDITIVE_OPERATORS_SET;
static NSIndexSet *PREFIX_OPERATORS_SET;
static NSIndexSet *SIMPLE_TYPE_SET;
static NSIndexSet *ACCESSOR_SET;
static PXExpressionNodeBuilder *NODE_BUILDER;

+ (void)initialize
{
    if (LOGICAL_OR_SET == nil)
    {
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        [set addIndex:EM_LOGICAL_OR];
        [set addIndex:EM_OR];
        LOGICAL_OR_SET = [[NSIndexSet alloc] initWithIndexSet:set];
    }
    if (LOGICAL_AND_SET == nil)
    {
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        [set addIndex:EM_LOGICAL_AND];
        [set addIndex:EM_AND];
        LOGICAL_AND_SET = [[NSIndexSet alloc] initWithIndexSet:set];
    }
    if (EQUALITY_OPERATORS_SET == nil)
    {
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        [set addIndex:EM_EQUAL];
        [set addIndex:EM_NOT_EQUAL];
        [set addIndex:EM_EQ];
        [set addIndex:EM_NE];
        EQUALITY_OPERATORS_SET = [[NSIndexSet alloc] initWithIndexSet:set];
    }
    if (RELATIONAL_OPERATORS_SET == nil)
    {
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        [set addIndex:EM_LESS_THAN];
        [set addIndex:EM_LESS_THAN_EQUAL];
        [set addIndex:EM_GREATER_THAN_EQUAL];
        [set addIndex:EM_GREATER_THAN];
        [set addIndex:EM_LT];
        [set addIndex:EM_LE];
        [set addIndex:EM_GE];
        [set addIndex:EM_GT];
        RELATIONAL_OPERATORS_SET = [[NSIndexSet alloc] initWithIndexSet:set];
    }
    if (MULTIPLICATIVE_OPERATORS_SET == nil)
    {
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        [set addIndex:EM_TIMES];
        [set addIndex:EM_DIVIDE];
        [set addIndex:EM_MODULUS];
        MULTIPLICATIVE_OPERATORS_SET = [[NSIndexSet alloc] initWithIndexSet:set];
    }
    if (ADDITIVE_OPERATORS_SET == nil)
    {
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        [set addIndex:EM_PLUS];
        [set addIndex:EM_MINUS];
        ADDITIVE_OPERATORS_SET = [[NSIndexSet alloc] initWithIndexSet:set];
    }
    if (PREFIX_OPERATORS_SET == nil)
    {
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        [set addIndex:EM_LOGICAL_NOT];
        [set addIndex:EM_NOT];
        [set addIndex:EM_MINUS];
        PREFIX_OPERATORS_SET = [[NSIndexSet alloc] initWithIndexSet:set];
    }
    if (SIMPLE_TYPE_SET == nil)
    {
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        [set addIndex:EM_NUMBER];
        [set addIndex:EM_TRUE];
        [set addIndex:EM_FALSE];
        [set addIndex:EM_STRING];
        [set addIndex:EM_NULL];
        [set addIndex:EM_UNDEFINED];
        SIMPLE_TYPE_SET = [[NSIndexSet alloc] initWithIndexSet:set];
    }
    if (ACCESSOR_SET == nil)
    {
        NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
        [set addIndex:EM_DOT];
        [set addIndex:EM_LBRACKET];
        [set addIndex:EM_LCURLY];
        ACCESSOR_SET = [[NSIndexSet alloc] initWithIndexSet:set];
    }
    if (NODE_BUILDER == nil)
    {
        NODE_BUILDER = [[PXExpressionNodeBuilder alloc] init];
    }
}

#pragma mark - Begin parsing

- (PXExpressionUnit *)compileString:(NSString *)source
{
    PXBlockNode *block = [NODE_BUILDER createBlockNode];

    // setup initial scope
    _currentScope = [[PXScope alloc] init];

    // setup source on lexer and prime lexeme pump
    expr_lexer_set_source((source != nil) ? source : @"", NO);
    [self advance];

    // parse
    @try
    {
        while (currentLexeme != nil && currentLexeme.type != 0)
        {
            PXExpressionLexeme *startLexeme = currentLexeme;

            [block addNode:[self parseStatement]];

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

- (id<PXExpressionNode>)parseStatement
{
    id<PXExpressionNode> result = nil;

    if ([self isType:EM_FUNC])
    {
        // parse function into current scope
        result = [self parseFunctionAsDeclaration:YES];
    }
    else if ([self isType:EM_IF])
    {
        result = [self parseIf];
    }
    else if ([self isType:EM_SYM])
    {
        result = [self parseSym];

        // handle optional semicolon
        [self advanceIfIsType:EM_SEMICOLON];
    }
    else
    {
        result = [self parseExpression];

        // handle optional semicolon
        [self advanceIfIsType:EM_SEMICOLON];
    }

    return result;
}

- (id<PXExpressionNode>)parseFunctionAsDeclaration:(BOOL)isDeclaration
{
    [self assertTypeAndAdvance:EM_FUNC];

    // grab function name
    NSString *name = nil;

    if (isDeclaration)
    {
        name = [self getName];
    }

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
    PXBlockNode *body = [self parseStatementBlock];

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

- (id<PXExpressionNode>)parseStatementBlock
{
    PXBlockNode *result = [NODE_BUILDER createBlockNode];

    // '{'
    [self assertTypeAndAdvance:EM_LCURLY];

    while (currentLexeme != nil && currentLexeme.type != 0 && currentLexeme.type != EM_RCURLY)
    {
        id<PXExpressionNode> expression = [self parseStatement];

        [result addNode:expression];
    }

    // '}'
    [self assertTypeAndAdvance:EM_RCURLY];

    return result;
}

- (id<PXExpressionNode>)parseIf
{
    id<PXExpressionNode> result = nil;

    // assert 'if'
    [self assertTypeAndAdvance:EM_IF];

    if ([self isType:EM_LPAREN])
    {
        // advance over '('
        [self advance];

        // parse condition
        PXBlockNode *condition = [self parseExpression];

        // assert ')'
        [self assertTypeAndAdvance:EM_RPAREN];

        // parse true block
        PXBlockNode *trueBlock = [self parseStatementBlock];
        PXBlockNode *falseBlock = nil;

        if ([self isType:EM_ELSIF])
        {
            falseBlock = [self parseElsif];
        }
        else if ([self isType:EM_ELSE])
        {
            // advance over 'else'
            [self advance];

            falseBlock = [self parseStatementBlock];
        }

        result = [NODE_BUILDER createIfNode:condition trueBlock:trueBlock falseBlock:falseBlock];
    }
    else
    {
        result = [NODE_BUILDER createIfNode];
    }

    return result;
}

- (id<PXExpressionNode>)parseElsif
{
    NSMutableArray *conditions = [[NSMutableArray alloc] init];
    NSMutableArray *trueBlocks = [[NSMutableArray alloc] init];
    __block PXBlockNode *falseBlock = nil;

    while ([self isType:EM_ELSIF])
    {
        // advance over 'elsif'
        [self advance];

        // advance over '('
        [self advance];

        // parse condition
        [conditions insertObject:[self parseExpression] atIndex:0];

        // assert ')'
        [self assertTypeAndAdvance:EM_RPAREN];

        [trueBlocks insertObject:[self parseStatementBlock] atIndex:0];
    }

    if ([self isType:EM_ELSE])
    {
        // advance over 'else'
        [self advance];

        falseBlock = [self parseStatementBlock];
    }

    [conditions enumerateObjectsUsingBlock:^(id<PXExpressionNode> condition, NSUInteger idx, BOOL *stop) {
        id<PXExpressionNode> trueBlock = trueBlocks[idx];

        // create if-else
        id<PXExpressionNode> ifNode = [NODE_BUILDER createIfNode:condition trueBlock:trueBlock falseBlock:falseBlock];

        // create new false block with this if-else
        falseBlock = [NODE_BUILDER createBlockNode];

        [falseBlock addNode:ifNode];
    }];

    return falseBlock.nodes[0];
}

- (id<PXExpressionNode>)parseSym
{
    id<PXExpressionNode> result = nil;

    // assert 'sym'
    [self assertTypeAndAdvance:EM_SYM];

    NSString *name = [self getName];

    if (name.length == 0)
    {
        [self errorWithMessage:@"Expected an IDENTIFIER or STRING as a symbol name"];
    }

    if ([self isType:EM_ASSIGN])
    {
        // advance over '='
        [self advance];

        // get value
        id<PXExpressionNode> value = [self parseExpression];

        result = [NODE_BUILDER createSymbolNodeWithName:name value:value];
    }
    else
    {
        result = [NODE_BUILDER createSymbolNodeWithName:name];
    }

    return result;
}

- (id<PXExpressionNode>)parseExpression
{
    return [self parseConditional];
}

- (id<PXExpressionNode>)parseConditional
{
    id<PXExpressionNode> result = [self parseLogicalOrExpression];

    if ([self isType:EM_QUESTION])
    {
        // advance over '?'
        [self advance];

        PXBlockNode *trueBlock = [NODE_BUILDER createBlockNode];
        [trueBlock addNode:[self parseConditional]];

        [self assertTypeAndAdvance:EM_COLON];

        PXBlockNode *falseBlock = [NODE_BUILDER createBlockNode];
        [falseBlock addNode:[self parseConditional]];

        result = [NODE_BUILDER createIfNode:result trueBlock:trueBlock falseBlock:falseBlock];
    }

    return result;
}

- (id<PXExpressionNode>)parseLogicalOrExpression
{
    id<PXExpressionNode> result = [self parseLogicalAndExpression];

    while ([self isInTypeSet:LOGICAL_OR_SET])
    {
        // advance over '||' or 'or'
        [self advance];

        id<PXExpressionNode> rhs = [self parseLogicalAndExpression];

        result = [NODE_BUILDER createLogicalOrNode:result rhs:rhs];
    }

    return result;
}

- (id<PXExpressionNode>)parseLogicalAndExpression
{
    id<PXExpressionNode> result = [self parseEqualityExpression];

    while ([self isInTypeSet:LOGICAL_AND_SET])
    {
        // advance over '&&' or 'and'
        [self advance];

        id<PXExpressionNode> rhs = [self parseLogicalAndExpression];

        result = [NODE_BUILDER createLogicalAndNode:result rhs:rhs];
    }

    return result;
}

- (id<PXExpressionNode>)parseEqualityExpression
{
    id<PXExpressionNode> result = [self parseRelationalExpression];

    if ([self isInTypeSet:EQUALITY_OPERATORS_SET])
    {
        int operator = currentLexeme.type;

        // advance over '==', 'eq', '!=', or 'ne'
        [self advance];

        id<PXExpressionNode> rhs = [self parseRelationalExpression];

        switch (operator)
        {
            case EM_EQUAL:
            case EM_EQ:
                result = [NODE_BUILDER createEqualNode:result rhs:rhs];
                break;

            case EM_NOT_EQUAL:
            case EM_NE:
                result = [NODE_BUILDER createNotEqualNode:result rhs:rhs];
                break;

            default:
                [self errorWithMessage:@"Unrecognized equality operator type"];
                break;
        }
    }

    return result;
}

- (id<PXExpressionNode>)parseRelationalExpression
{
    id<PXExpressionNode> result = [self parseAdditiveExpression];

    if ([self isInTypeSet:RELATIONAL_OPERATORS_SET])
    {
        int operator = currentLexeme.type;

        // advance over operator
        [self advance];

        id<PXExpressionNode> rhs = [self parseAdditiveExpression];

        switch (operator)
        {
            case EM_LESS_THAN:
            case EM_LT:
                result = [NODE_BUILDER createLessThanNode:result rhs:rhs];
                break;

            case EM_LESS_THAN_EQUAL:
            case EM_LE:
                result = [NODE_BUILDER createLessThanOrEqualNode:result rhs:rhs];
                break;

            case EM_GREATER_THAN_EQUAL:
            case EM_GE:
                result = [NODE_BUILDER createGreaterThanOrEqualNode:result rhs:rhs];
                break;

            case EM_GREATER_THAN:
            case EM_GT:
                result = [NODE_BUILDER createGreaterThanNode:result rhs:rhs];
                break;

            default:
                [self errorWithMessage:@"Unrecognized relational operator"];
                break;
        }
    }

    return result;
}

- (id<PXExpressionNode>)parseAdditiveExpression
{
    id<PXExpressionNode> result = [self parseMultipicativeExpression];

    while ([self isInTypeSet:ADDITIVE_OPERATORS_SET])
    {
        int operator = currentLexeme.type;

        // advance over operator
        [self advance];

        id<PXExpressionNode> rhs = [self parseMultipicativeExpression];

        switch (operator)
        {
            case EM_PLUS:
                result = [NODE_BUILDER createAdditionNode:result rhs:rhs];
                break;

            case EM_MINUS:
                result = [NODE_BUILDER createSubtractionNode:result rhs:rhs];
                break;

            default:
                [self errorWithMessage:@"Unrecognized addition operator"];
                break;
        }
    }

    return result;
}

- (id<PXExpressionNode>)parseMultipicativeExpression
{
    id<PXExpressionNode> result = [self parseUnaryExpression];

    while ([self isInTypeSet:MULTIPLICATIVE_OPERATORS_SET])
    {
        int operator = currentLexeme.type;

        // advance over operator
        [self advance];

        id<PXExpressionNode> rhs = [self parseUnaryExpression];

        switch (operator)
        {
            case EM_TIMES:
                result = [NODE_BUILDER createMultiplicationNode:result rhs:rhs];
                break;

            case EM_DIVIDE:
                result = [NODE_BUILDER createDivisionNode:result rhs:rhs];
                break;
                
            case EM_MODULUS:
                result = [NODE_BUILDER createModulusNode:result rhs:rhs];
                break;

            default:
                [self errorWithMessage:@"Unrecognized multiplication operator"];
                break;
        }
    }

    return result;
}

- (id<PXExpressionNode>)parseUnaryExpression
{
    NSMutableArray *operatorStack = [[NSMutableArray alloc] init];

    while ([self isInTypeSet:PREFIX_OPERATORS_SET])
    {
        [operatorStack addObject:currentLexeme];

        // advance over '!', 'not', or '-'
        [self advance];
    }

    // grab expression
    id<PXExpressionNode> currentNode = [self parseInvocationExpression];

    // now nest in function invocations
    while (operatorStack.count > 0)
    {
        PXExpressionLexeme *lexeme = [operatorStack lastObject];

        [operatorStack removeLastObject];

        switch (lexeme.type)
        {
            case EM_LOGICAL_NOT:
            case EM_NOT:
                currentNode = [NODE_BUILDER createLogicalNotNode:currentNode];
                break;

            case EM_MINUS:
                if (currentNode.type == EM_NUMBER)
                {
                    PXGenericNode *number = (PXGenericNode *)currentNode;

                    currentNode = [NODE_BUILDER createNumberNode:-number.doubleValue];
                }
                else
                {
                    currentNode = [NODE_BUILDER createNegateNode:currentNode];
                }
                break;

            default:
                [self errorWithMessage:@"Unrecognized unary operator"];
        }
    }

    return currentNode;
}

- (id<PXExpressionNode>)parseInvocationExpression
{
    id<PXExpressionNode> result = [self parseMember];

    // TODO: should be 'while'
    if ([self isType:EM_LPAREN])
    {
        // advance over '('
        [self advance];

        // process args
        NSMutableArray *args = [[NSMutableArray alloc] init];

        if ([self isType:EM_RPAREN] == false)
        {
            // parse first arg
            [args addObject:[self parseExpression]];

            while ([self isType:EM_COMMA])
            {
                // advance over ','
                [self advance];

                // parse next arg
                [args addObject:[self parseExpression]];
            }
        }

        // advance over required ')'
        [self assertTypeAndAdvance:EM_RPAREN];

        result = [NODE_BUILDER createInvokeNode:result arguments:args];
    }

    return [self parseAccessorsWithNode:result];
}

- (id<PXExpressionNode>)parseMember
{
    id<PXExpressionNode> result = nil;

    if ([self isType:EM_FUNC])
    {
        result = [self parseFunctionAsDeclaration:NO];
    }
    else
    {
        result = [self parsePrimary];
    }

    return [self parseAccessorsWithNode:result];
}

- (id<PXExpressionNode>)parseAccessorsWithNode:(id<PXExpressionNode>)node
{
    id<PXExpressionNode> result = node;

    while ([self isInTypeSet:ACCESSOR_SET])
    {
        switch (currentLexeme.type)
        {
            case EM_DOT:
                // advance over '.'
                [self advance];

                // get property name
                [self assertType:EM_IDENTIFIER];
                result = [NODE_BUILDER createGetPropertyNode:result withStringName:currentLexeme.text];

                // advance over identifier
                [self advance];
                break;

            case EM_LBRACKET:
            {
                // advance over '['
                [self advance];

                id<PXExpressionNode> index = [self parseExpression];

                // assert ']'
                [self assertTypeAndAdvance:EM_RBRACKET];

                result = [NODE_BUILDER createGetElementNode:result withIndex:index];
                break;
            }

            case EM_LCURLY:
            {
                 // advance over '{'
                [self advance];

                id<PXExpressionNode> property = [self parseExpression];

                // assert '}'
                [self assertTypeAndAdvance:EM_RCURLY];

                result = [NODE_BUILDER createGetPropertyNode:result withName:property];
                break;
            }

            default:
                [self errorWithMessage:@"Unrecognized member token. Expected DOT or LBRACKET"];
        }
    }

    return result;
}

- (id<PXExpressionNode>)parsePrimary
{
    id<PXExpressionNode> result = nil;

    switch (currentLexeme.type)
    {
        case EM_IDENTIFIER:
            result = [NODE_BUILDER createIdentifierNode:currentLexeme.text];

            // advance over identifier
            [self advance];
            break;

        case EM_THIS:
            result = [NODE_BUILDER createThisNode];

            // advance over 'this'
            [self advance];
            break;

        case EM_LPAREN:
            // advance over '('
            [self advance];

            result = [self parseExpression];

            // advance over require ')'
            [self assertTypeAndAdvance:EM_RPAREN];
            break;

        case EM_LBRACKET:
        {
            // advance over '['
            [self advance];

            NSMutableArray *elements = nil;

            if ([self isType:EM_RBRACKET] == false)
            {
                elements = [[NSMutableArray alloc] init];

                // add element
                [elements addObject:[self parseExpression]];

                while ([self isType:EM_COMMA])
                {
                    // advance over ','
                    [self advance];

                    // add element
                    [elements addObject:[self parseExpression]];
                }
            }

            // assert ']'
            [self assertTypeAndAdvance:EM_RBRACKET];

            result = [NODE_BUILDER createArrayNode:[elements copy]];
            break;
        }

        case EM_LCURLY:
        {
            // advance over '{'
            [self advance];

            // collect key values
            NSMutableArray *keyValues = nil;

            if ([self isType:EM_RCURLY] == false)
            {
                keyValues = [[NSMutableArray alloc] init];

                // add first key/value
                [keyValues addObject:[self parseKeyValue]];

                while ([self isType:EM_COMMA])
                {
                    // advance over ','
                    [self advance];

                    // add key/value
                    [keyValues addObject:[self parseKeyValue]];
                }
            }

            // assert '}'
            [self assertTypeAndAdvance:EM_RCURLY];

            result = [NODE_BUILDER createObjectNode:[keyValues copy]];
            break;
        }

        default:
            if ([self isInTypeSet:SIMPLE_TYPE_SET])
            {
                result = [self parseSimpleType];
            }
            else
            {
                [self errorWithMessage:@"Unknown primary type. Expected IDENTIFIER, NUMBER, T, F, STRING, or LPAREN"];
            }
    }

    return result;
}

- (id<PXExpressionNode>)parseKeyValue
{
    // grab key
    NSString *key = [self getName];

    // assert ":"
    [self assertTypeAndAdvance:EM_COLON];

    // grab value
    id<PXExpressionNode> value = [self parseExpression];

    // return result
    return [NODE_BUILDER createKeyValueNode:key value:value];
}

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
            [self errorWithMessage:@"Unknown simple type. Expected NUMBER, TRUE, FALSE, STRING, NULL, or UNDEFINED"];
    }

    return result;
}

#pragma mark - Helper methods

- (id<PXLexeme>)advance
{
    return currentLexeme = expr_lexer_get_lexeme();
}

- (NSString *)lexemeNameFromType:(int)type
{
    PXExpressionLexeme *lexeme = [[PXExpressionLexeme alloc] initWithType:type text:nil];

    return lexeme.name;
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
        // NOTE: strippedString advances for us
        result = self.strippedString;
    }
    else
    {
        [self errorWithMessage:@"Expected an IDENTIFIER or STRING"];
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

@end
