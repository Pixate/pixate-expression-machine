//
//  PXExpressionNodeCompiler.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/26/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionNodeCompiler.h"
#import "PXByteCodeBuilder.h"
#import "PXExpressionUnit.h"
#import "PXExpressionLexemeType.h"

#import "PXGenericNode.h"
#import "PXBlockNode.h"

#import "PXByteCodeFunction.h"
#import "PXBooleanValue.h"
#import "PXDoubleValue.h"
#import "PXNullValue.h"
#import "PXParameter.h"
#import "PXStringValue.h"
#import "PXUndefinedValue.h"

@implementation PXExpressionNodeCompiler

static NSIndexSet *PRIMITIVES;

#pragma mark - Static Methods

+ (void)initialize
{
    if (PRIMITIVES == nil)
    {
        NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];
        [set addIndex:EM_BOOLEAN];
        [set addIndex:EM_NULL];
        [set addIndex:EM_NUMBER];
        [set addIndex:EM_STRING];
        [set addIndex:EM_UNDEFINED];
        PRIMITIVES = [set copy];
    };
}

#pragma mark - Methods

- (PXExpressionByteCode *)compileNode:(id<PXExpressionNode>)node withScope:(id<PXExpressionScope>)scope
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    [self emitInstructionsForNode:node builder:builder scope:scope];

    return builder.byteCode;
}

- (void)emitInstructionsForNode:(id<PXExpressionNode>)node
                        builder:(PXByteCodeBuilder *)builder
                          scope:(id<PXExpressionScope>)scope
{
    switch (node.type)
    {
        case EM_IDENTIFIER:
        {
            PXGenericNode *em = (PXGenericNode *)node;

            [builder addGetSymbolInstructionWithName:em.stringValue];
            break;
        }

        case EM_NUMBER:
        {
            PXGenericNode *number = (PXGenericNode *)node;
            [builder addPushDoubleInstruction:number.doubleValue];
            break;
        }

        case EM_FUNC:
        {
            PXGenericNode *func = (PXGenericNode *)node;
            PXByteCodeBuilder *compiler = [[PXByteCodeBuilder alloc] init];

            [self emitInstructionsForNode:func.nodeValue builder:compiler scope:scope];

            // TODO: determine scope value
            PXExpressionUnit *unit = [[PXExpressionUnit alloc] initWithByteCode:compiler.byteCode scope:nil ast:func];

            // create parameters
            NSMutableArray *buffer = [[NSMutableArray alloc] init];

            [func.arrayValue enumerateObjectsUsingBlock:^(PXGenericNode *parameter, NSUInteger idx, BOOL *stop) {
                id<PXExpressionValue> value;

                if ([PRIMITIVES containsIndex:parameter.nodeValue.type])
                {
                    value = [self getValueForNode:parameter.nodeValue];
                }
                else
                {
                    value = [PXUndefinedValue undefined];

                    NSLog(@"Unrecognized default value node type: %@", [parameter.nodeValue class]);
                }

                [buffer addObject:[[PXParameter alloc] initWithName:parameter.stringValue defaultValue:value]];
            }];

            NSArray *parameters = [NSArray arrayWithArray:buffer];

            // create function
            PXByteCodeFunction *function = [[PXByteCodeFunction alloc] initWithUnit:unit parameters:parameters];

            if (func.stringValue.length > 0)
            {
                [scope setValue:function forSymbolName:func.stringValue];
            }
            else
            {
                [builder addPushFunctionInstruction:function];
            }
            break;
        }

        case EM_LT:
            [builder addLessThanInstruction];
            break;

        case EM_LE:
            [builder addLessThanEqualInstruction];
            break;

        case EM_EQ:
            [builder addEqualInstruction];
            break;

        case EM_NE:
            [builder addNotEqualInstruction];
            break;

        case EM_GE:
            [builder addGreaterThanEqualInstruction];
            break;

        case EM_GT:
            [builder addGreaterThanInstruction];
            break;

        case EM_NOT:
            [builder addNotInstruction];
            break;

        case EM_OR:
            [builder addOrInstruction];
            break;

        case EM_AND:
            [builder addAndInstruction];
            break;

        case EM_THIS:
            [builder addGetSymbolInstructionWithName:@"this"];
            break;

        case EM_NULL:
            [builder addPushNullInstruction];
            break;

        case EM_UNDEFINED:
            [builder addPushUndefinedInstruction];
            break;

        case EM_IF:
        {
            PXGenericNode *ifNode = (PXGenericNode *)node;
            PXByteCodeBuilder *blockBuilder = [[PXByteCodeBuilder alloc] init];

            if (ifNode.nodeValue != nil)
            {
                // emit condition
                [self emitInstructionsForNode:ifNode.nodeValue builder:builder scope:scope];

                // emit true block
                [self emitInstructionsForNode:ifNode.nodeValue2 builder:blockBuilder scope:scope];
                [builder addPushBlockInstruction:blockBuilder.byteCode];

                if (ifNode.nodeValue3 != nil)
                {
                    [blockBuilder reset];
                    [self emitInstructionsForNode:ifNode.nodeValue3 builder:blockBuilder scope:scope];
                    [builder addPushBlockInstruction:blockBuilder.byteCode];

                    [builder addIfElseInstruction];
                }
                else
                {
                    [builder addIfInstruction];
                }
            }
            else
            {
                [builder addIfInstruction];
            }
            break;
        }

        case EM_SYM:
        {
            PXGenericNode *em = (PXGenericNode *)node;

            if (em.nodeValue != nil)
            {
                [self emitInstructionsForNode:em.nodeValue builder:builder scope:scope];
            }
            else
            {
                [builder addPushUndefinedInstruction];
            }

            [builder addSetSymbolInstructionWithName:em.stringValue];
            break;
        }

        case EM_LPAREN:
        {
            PXGenericNode *em = (PXGenericNode *)node;

            // evaluate each argument
            [em.arrayValue enumerateObjectsUsingBlock:^(id<PXExpressionNode> arg, NSUInteger idx, BOOL *stop) {
                [self emitInstructionsForNode:arg builder:builder scope:scope];
            }];

            // invoke the function
            if (em.nodeValue.type == EM_IDENTIFIER)
            {
                PXGenericNode *identifier = (PXGenericNode *)em.nodeValue;

                // invocation
                [builder addInvokeFunctionInstructionWithName:identifier.stringValue count:(uint)em.arrayValue.count];
            }
            else if (em.nodeValue.type == EM_DOT)
            {
                PXGenericNode *getProperty = (PXGenericNode *)em.nodeValue;

                // emit lhs of the dotted name. This is the invocation object
                [self emitInstructionsForNode:getProperty.nodeValue builder:builder scope:scope];

                // Copy invocation object and get rhs of the dotted name
                [builder addDuplicateInstruction];
                [builder addGetPropertyInstructionWithName:getProperty.stringValue];

                // emit invocation
                [builder addInvokeFunctionInstructionWithCount:(uint)em.arrayValue.count];
            }
            else
            {
                // TODO: only allow function-expression, this, get-property, and get-element
                [self emitInstructionsForNode:em.nodeValue builder:builder scope:scope];
                [builder addPushUndefinedInstruction];
                [builder addInvokeFunctionInstructionWithCount:(uint)em.arrayValue.count];
            }
            break;
        }

        case EM_LCURLY:
        {
            PXBlockNode *block = (PXBlockNode *)node;

            if (block.blockValue)
            {
                PXByteCodeBuilder *blockBuilder = [[PXByteCodeBuilder alloc] init];

                [block.nodes enumerateObjectsUsingBlock:^(id<PXExpressionNode> child, NSUInteger idx, BOOL *stop) {
                    [self emitInstructionsForNode:child builder:blockBuilder scope:scope];
                }];

                [builder addPushBlockInstruction:blockBuilder.byteCode];
            }
            else
            {
                [block.nodes enumerateObjectsUsingBlock:^(id<PXExpressionNode> child, NSUInteger idx, BOOL *stop) {
                    [self emitInstructionsForNode:child builder:builder scope:scope];
                }];
            }
            break;
        }

        case EM_LBRACKET:
        {
            PXGenericNode *get = (PXGenericNode *)node;

            [self emitInstructionsForNode:get.nodeValue builder:builder scope:scope];

            // TODO: detect expressions that are constants, like "1 + 2"
            if (get.nodeValue2.type == EM_NUMBER)
            {
                PXGenericNode *index = get.nodeValue2;

                [builder addGetElementInstructionWithIndex:(uint) index.doubleValue];
            }
            else
            {
                [self emitInstructionsForNode:get.nodeValue2 builder:builder scope:scope];
                [builder addGetElementInstruction];
            }

            break;
        }

        case EM_RBRACKET:
        {
            PXGenericNode *em = (PXGenericNode *)node;

            [em.arrayValue enumerateObjectsUsingBlock:^(id<PXExpressionNode> element, NSUInteger idx, BOOL *stop) {
                [self emitInstructionsForNode:element builder:builder scope:scope];
            }];

            [builder addCreateArrayInstructionWithCount:(uint)em.arrayValue.count];
            break;
        }

        case EM_RCURLY:
        {
            PXGenericNode *em = (PXGenericNode *)node;

            [em.arrayValue enumerateObjectsUsingBlock:^(id<PXExpressionNode> keyValue, NSUInteger idx, BOOL *stop) {
                [self emitInstructionsForNode:keyValue builder:builder scope:scope];
            }];

            [builder addCreateObjectInstructionWithCount:(uint)em.arrayValue.count];
            break;
        }

        case EM_LESS_THAN:
        {
            PXGenericNode *binary = (PXGenericNode *)node;
            [self emitInstructionsForNode:binary.nodeValue builder:builder scope:scope];
            [self emitInstructionsForNode:binary.nodeValue2 builder:builder scope:scope];
            [builder addLessThanInstruction];
            break;
        }

        case EM_LESS_THAN_EQUAL:
        {
            PXGenericNode *binary = (PXGenericNode *)node;
            [self emitInstructionsForNode:binary.nodeValue builder:builder scope:scope];
            [self emitInstructionsForNode:binary.nodeValue2 builder:builder scope:scope];
            [builder addLessThanEqualInstruction];
            break;
        }

        case EM_EQUAL:
        {
            PXGenericNode *binary = (PXGenericNode *)node;
            [self emitInstructionsForNode:binary.nodeValue builder:builder scope:scope];
            [self emitInstructionsForNode:binary.nodeValue2 builder:builder scope:scope];
            [builder addEqualInstruction];
            break;
        }

        case EM_NOT_EQUAL:
        {
            PXGenericNode *binary = (PXGenericNode *)node;
            [self emitInstructionsForNode:binary.nodeValue builder:builder scope:scope];
            [self emitInstructionsForNode:binary.nodeValue2 builder:builder scope:scope];
            [builder addNotEqualInstruction];
            break;
        }

        case EM_GREATER_THAN_EQUAL:
        {
            PXGenericNode *binary = (PXGenericNode *)node;
            [self emitInstructionsForNode:binary.nodeValue builder:builder scope:scope];
            [self emitInstructionsForNode:binary.nodeValue2 builder:builder scope:scope];
            [builder addGreaterThanEqualInstruction];
            break;
        }

        case EM_GREATER_THAN:
        {
            PXGenericNode *binary = (PXGenericNode *)node;
            [self emitInstructionsForNode:binary.nodeValue builder:builder scope:scope];
            [self emitInstructionsForNode:binary.nodeValue2 builder:builder scope:scope];
            [builder addGreaterThanInstruction];
            break;
        }

        case EM_LOGICAL_NOT:
        {
            PXGenericNode *unary = (PXGenericNode *)node;
            [self emitInstructionsForNode:unary.nodeValue builder:builder scope:scope];
            [builder addNotInstruction];
            break;
        }

        case EM_LOGICAL_OR:
        {
            PXGenericNode *binary = (PXGenericNode *)node;
            [self emitInstructionsForNode:binary.nodeValue builder:builder scope:scope];
            [self emitInstructionsForNode:binary.nodeValue2 builder:builder scope:scope];
            [builder addOrInstruction];
            break;
        }

        case EM_LOGICAL_AND:
        {
            PXGenericNode *binary = (PXGenericNode *)node;
            [self emitInstructionsForNode:binary.nodeValue builder:builder scope:scope];
            [self emitInstructionsForNode:binary.nodeValue2 builder:builder scope:scope];
            [builder addAndInstruction];
            break;
        }

        case EM_PLUS:
        {
            PXGenericNode *binary = (PXGenericNode *)node;
            [self emitInstructionsForNode:binary.nodeValue builder:builder scope:scope];
            [self emitInstructionsForNode:binary.nodeValue2 builder:builder scope:scope];
            [builder addAddInstruction];
            break;
        }

        case EM_MINUS:
        {
            PXGenericNode *binary = (PXGenericNode *)node;
            [self emitInstructionsForNode:binary.nodeValue builder:builder scope:scope];
            [self emitInstructionsForNode:binary.nodeValue2 builder:builder scope:scope];
            [builder addSubtractInstruction];
            break;
        }

        case EM_TIMES:
        {
            PXGenericNode *binary = (PXGenericNode *)node;
            [self emitInstructionsForNode:binary.nodeValue builder:builder scope:scope];
            [self emitInstructionsForNode:binary.nodeValue2 builder:builder scope:scope];
            [builder addMultiplyInstruction];
            break;
        }

        case EM_DIVIDE:
        {
            PXGenericNode *binary = (PXGenericNode *)node;
            [self emitInstructionsForNode:binary.nodeValue builder:builder scope:scope];
            [self emitInstructionsForNode:binary.nodeValue2 builder:builder scope:scope];
            [builder addDivideInstruction];
            break;
        }
            
        case EM_MODULUS:
        {
            PXGenericNode *binary = (PXGenericNode *)node;
            [self emitInstructionsForNode:binary.nodeValue builder:builder scope:scope];
            [self emitInstructionsForNode:binary.nodeValue2 builder:builder scope:scope];
            [builder addModulusInstruction];
            break;
        }

        case EM_DOT:
        {
            PXGenericNode *em = (PXGenericNode *)node;

            [self emitInstructionsForNode:em.nodeValue builder:builder scope:scope];

            if (em.stringValue.length > 0)
            {
                // EM case
                [builder addGetPropertyInstructionWithName:em.stringValue];
            }
            else
            {
                // Ema case
                [self emitInstructionsForNode:em.nodeValue2 builder:builder scope:scope];
                [builder addGetPropertyInstruction];
            }
            break;
        }

        case EM_COLON:
        {
            PXGenericNode *em = (PXGenericNode *)node;

            [builder addPushStringInstruction:em.stringValue];
            [self emitInstructionsForNode:em.nodeValue builder:builder scope:scope];
            break;
        }

        case EM_STRING:
        {
            PXGenericNode *string = (PXGenericNode *)node;
            [builder addPushStringInstruction:string.stringValue];
            break;
        }

        case EMA_APPLY:
        {
            PXGenericNode *ema = (PXGenericNode *)node;

            if (ema.stringValue.length > 0)
            {
                [builder addApplyInstructionWithName:ema.stringValue];
            }
            else
            {
                [builder addApplyInstruction];
            }
            break;
        }

        case EMA_CREATE_ARRAY:
        {
            PXGenericNode *ema = (PXGenericNode *)node;

            if (ema.uintValue > 0)
            {
                [builder addCreateArrayInstructionWithCount:ema.uintValue];
            }
            else
            {
                [builder addCreateArrayInstruction];
            }
            break;
        }

        case EMA_CREATE_OBJECT:
        {
            PXGenericNode *ema = (PXGenericNode *)node;

            if (ema.uintValue > 0)
            {
                [builder addCreateObjectInstructionWithCount:ema.uintValue];
            }
            else
            {
                [builder addCreateObjectInstruction];
            }
            break;
        }

        case EMA_DUP:
            [builder addDuplicateInstruction];
            break;

        case EMA_EXEC:
            [builder addExecuteInstruction];
            break;

        case EMA_GET_ELEMENT:
        {
            PXGenericNode *ema = (PXGenericNode *)node;

            if (ema.uintValue != UINT_MAX)
            {
                [builder addGetElementInstructionWithIndex:ema.uintValue];
            }
            else
            {
                [builder addGetElementInstruction];
            }
            break;
        }

        case EMA_GET_PROPERTY:
        {
            PXGenericNode *ema = (PXGenericNode *)node;

            if (ema.stringValue.length > 0)
            {
                [builder addGetPropertyInstructionWithName:ema.stringValue];
            }
            else
            {
                [builder addGetPropertyInstruction];
            }
            break;
        }

        case EMA_GET_SYMBOL:
        {
            PXGenericNode *ema = (PXGenericNode *)node;

            if (ema.stringValue.length > 0)
            {
                [builder addGetSymbolInstructionWithName:ema.stringValue];
            }
            else
            {
                [builder addGetSymbolInstruction];
            }
            break;
        }

        case EMA_GLOBAL:
            [builder addPushGlobal];
            break;

        case EMA_IF_ELSE:
            [builder addIfElseInstruction];
            break;

        case EMA_INVOKE:
        {
            PXGenericNode *ema = (PXGenericNode *)node;

            if (ema.stringValue.length > 0)
            {
                if (ema.uintValue > 0)
                {
                    [builder addInvokeFunctionInstructionWithName:ema.stringValue count:ema.uintValue];
                }
                else
                {
                    [builder addInvokeFunctionInstructionWithName:ema.stringValue];
                }
            }
            else if (ema.uintValue > 0)
            {
                [builder addInvokeFunctionInstructionWithCount:ema.uintValue];
            }
            else
            {
                [builder addInvokeFunctionInstruction];
            }
            break;
        }

        case EMA_POP:
            [builder addPopInstruction];
            break;

        case EMA_SET_SYMBOL:
        {
            PXGenericNode *ema = (PXGenericNode *)node;

            if (ema.stringValue.length > 0)
            {
                [builder addSetSymbolInstructionWithName:ema.stringValue];
            }
            else
            {
                [builder addSetSymbolInstruction];
            }
            break;
        }

        case EMA_SWAP:
            [builder addSwapInstruction];
            break;

        case EMA_ADD:
            [builder addAddInstruction];
            break;

        case EMA_SUB:
            [builder addSubtractInstruction];
            break;

        case EMA_MUL:
            [builder addMultiplyInstruction];
            break;

        case EMA_DIV:
            [builder addDivideInstruction];
            break;
            
        case EMA_MOD:
            [builder addModulusInstruction];
            break;

        case EMA_NEG:
        {
            PXGenericNode *unary = (PXGenericNode *)node;
            [self emitInstructionsForNode:unary.nodeValue builder:builder scope:scope];
            [builder addNegateInstruction];
            break;
        }

        case EMA_MARK:
            [builder addPushMarkInstruction];
            break;

        case EM_BOOLEAN:
        {
            PXGenericNode *boolean = (PXGenericNode *)node;
            [builder addPushBooleanInstruction:boolean.booleanValue];
            break;
        }

        case EM_PARAMETER:
            // no-op
            break;
    }
}

- (id<PXExpressionValue>)getValueForNode:(id<PXExpressionNode>)node
{
    id<PXExpressionValue> result = nil;
    PXGenericNode *primitive = (PXGenericNode *)node;

    switch (node.type)
    {
        case EM_BOOLEAN:
            result = [[PXBooleanValue alloc] initWithBoolean:primitive.booleanValue];
            break;

        case EM_NULL:
            result = [PXNullValue null];
            break;

        case EM_NUMBER:
            result = [[PXDoubleValue alloc] initWithDouble:primitive.doubleValue];
            break;

        case EM_STRING:
            result = [[PXStringValue alloc] initWithString:primitive.stringValue];
            break;

        case EM_UNDEFINED:
            result = [PXUndefinedValue undefined];
            break;

        default:
            NSLog(@"Unrecognized primitive node type: %d", node.type);
    }

    return result;
}

- (BOOL)isSimpleGetter:(PXGenericNode *)node
{
    BOOL result = NO;

    while (node.type == EM_DOT)
    {
        if (node.nodeValue.type == EM_IDENTIFIER)
        {
            result = YES;
            break;
        }
        else if (node.nodeValue.type != EM_DOT)
        {
            break;
        }
        else
        {
            node = node.nodeValue;
        }
    }

    return result;
}

@end
