//
//  PXExpressionNodeBuilder.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/26/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionNodeBuilder.h"
#import "PXExpressionLexemeType.h"

@implementation PXExpressionNodeBuilder

#pragma mark - Common Nodes

- (PXBlockNode *)createBlockNode
{
    return [[PXBlockNode alloc] init];
}

- (PXGenericNode *)createBooleanNode:(BOOL)booleanValue
{
    return [[PXGenericNode alloc] initWithType:EM_BOOLEAN booleanValue:booleanValue];
}

- (PXGenericNode *)createFunctionDefinitionNode:(NSString *)name
                                                parameters:(NSArray *)parameters
                                                      body:(PXBlockNode *)body
{
    return [[PXGenericNode alloc] initWithType:EM_FUNC nodeValue:body arrayValue:parameters stringValue:name];
}

- (PXGenericNode *)createNullNode
{
    return [[PXGenericNode alloc] initWithType:EM_NULL];
}

- (PXGenericNode *)createNumberNode:(double)doubleValue
{
    return [[PXGenericNode alloc] initWithType:EM_NUMBER doubleValue:doubleValue];
}

- (PXGenericNode *)createParameterNode:(NSString *)name defaultValue:(id<PXExpressionNode>)defaultValue
{
    return [[PXGenericNode alloc] initWithType:EM_PARAMETER nodeValue:defaultValue stringValue:name];
}

- (PXGenericNode *)createStringNode:(NSString *)stringValue
{
    return [[PXGenericNode alloc] initWithType:EM_STRING stringValue:stringValue];
}

- (PXGenericNode *)createUndefinedNode
{
    return [[PXGenericNode alloc] initWithType:EM_UNDEFINED];
}

#pragma mark - Em Nodes

- (PXGenericNode *)createAdditionNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs
{
    return [[PXGenericNode alloc] initWithType:EM_PLUS lhs:lhs rhs:rhs];
}

- (PXGenericNode *)createSubtractionNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs
{
    return [[PXGenericNode alloc] initWithType:EM_MINUS lhs:lhs rhs:rhs];
}

- (PXGenericNode *)createMultiplicationNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs
{
    return [[PXGenericNode alloc] initWithType:EM_TIMES lhs:lhs rhs:rhs];
}

- (PXGenericNode *)createDivisionNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs
{
    return [[PXGenericNode alloc] initWithType:EM_DIVIDE lhs:lhs rhs:rhs];
}

- (PXGenericNode *)createModulusNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs
{
    return [[PXGenericNode alloc] initWithType:EM_MODULUS lhs:lhs rhs:rhs];
}

- (PXGenericNode *)createLogicalAndNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs
{
    return [[PXGenericNode alloc] initWithType:EM_LOGICAL_AND lhs:lhs rhs:rhs];
}

- (PXGenericNode *)createLogicalOrNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs
{
    return [[PXGenericNode alloc] initWithType:EM_LOGICAL_OR lhs:lhs rhs:rhs];
}

- (PXGenericNode *)createLessThanNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs
{
    return [[PXGenericNode alloc] initWithType:EM_LESS_THAN lhs:lhs rhs:rhs];
}

- (PXGenericNode *)createLessThanOrEqualNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs
{
    return [[PXGenericNode alloc] initWithType:EM_LESS_THAN_EQUAL lhs:lhs rhs:rhs];
}

- (PXGenericNode *)createEqualNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs
{
    return [[PXGenericNode alloc] initWithType:EM_EQUAL lhs:lhs rhs:rhs];
}

- (PXGenericNode *)createNotEqualNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs
{
    return [[PXGenericNode alloc] initWithType:EM_NOT_EQUAL lhs:lhs rhs:rhs];
}

- (PXGenericNode *)createGreaterThanOrEqualNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs
{
    return [[PXGenericNode alloc] initWithType:EM_GREATER_THAN_EQUAL lhs:lhs rhs:rhs];
}

- (PXGenericNode *)createGreaterThanNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs
{
    return [[PXGenericNode alloc] initWithType:EM_GREATER_THAN lhs:lhs rhs:rhs];
}

- (PXGenericNode *)createArrayNode:(NSArray *)elements
{
    return [[PXGenericNode alloc] initWithType:EM_RBRACKET arrayValue:elements];
}

- (PXGenericNode *)createGetPropertyNode:(id<PXExpressionNode>)lhs withStringName:(NSString *)name
{
    return [[PXGenericNode alloc] initWithType:EM_DOT nodeValue:lhs stringValue:name];
}

- (PXGenericNode *)createGetPropertyNode:(id<PXExpressionNode>)lhs withName:(id<PXExpressionNode>)name
{
    return [[PXGenericNode alloc] initWithType:EM_DOT lhs:lhs rhs:name];
}

- (PXGenericNode *)createIdentifierNode:(NSString *)stringValue
{
    return [[PXGenericNode alloc] initWithType:EM_IDENTIFIER stringValue:stringValue];
}

- (PXGenericNode *)createInvokeNode:(id<PXExpressionNode>)lhs arguments:(NSArray *)args
{
    return [[PXGenericNode alloc] initWithType:EM_LPAREN nodeValue:lhs arrayValue:args];
}

- (PXGenericNode *)createKeyValueNode:(NSString *)key value:(id<PXExpressionNode>)value
{
    return [[PXGenericNode alloc] initWithType:EM_COLON nodeValue:value stringValue:key];
}

- (PXGenericNode *)createObjectNode:(NSArray *)keyValuePairs
{
    return [[PXGenericNode alloc] initWithType:EM_RCURLY arrayValue:keyValuePairs];
}

- (PXGenericNode *)createSymbolNodeWithName:(NSString *)name
{
    return [[PXGenericNode alloc] initWithType:EM_SYM stringValue:name];
}

- (PXGenericNode *)createSymbolNodeWithName:(NSString *)name value:(id<PXExpressionNode>)value
{
    return [[PXGenericNode alloc] initWithType:EM_SYM nodeValue:value stringValue:name];
}

- (PXGenericNode *)createThisNode
{
    return [[PXGenericNode alloc] initWithType:EM_THIS];
}

- (PXGenericNode *)createGetElementNode:(id<PXExpressionNode>)lhs withIndex:(id<PXExpressionNode>)index
{
    return [[PXGenericNode alloc] initWithType:EM_LBRACKET lhs:lhs rhs:index];
}

- (PXGenericNode *)createLogicalNotNode:(id<PXExpressionNode>)expression
{
    return [[PXGenericNode alloc] initWithType:EM_LOGICAL_NOT nodeValue:expression];
}

- (PXGenericNode *)createNegateNode:(id<PXExpressionNode>)expression
{
    return [[PXGenericNode alloc] initWithType:EMA_NEG nodeValue:expression];
}

#pragma mark - Ema Nodes

- (PXGenericNode *)createIfNode
{
    return [[PXGenericNode alloc] initWithType:EM_IF];
}

- (PXGenericNode *)createIfNode:(id<PXExpressionNode>)condition trueBlock:(PXBlockNode *)trueBlock
{
    return [[PXGenericNode alloc] initWithType:EM_IF condition:condition trueBlock:trueBlock falseBlock:nil];
}

- (PXGenericNode *)createIfNode:(id<PXExpressionNode>)condition
                      trueBlock:(PXBlockNode *)trueBlock
                     falseBlock:(PXBlockNode *)falseBlock
{
    return [[PXGenericNode alloc] initWithType:EM_IF condition:condition trueBlock:trueBlock falseBlock:falseBlock];
}

- (PXGenericNode *)createApplyNode
{
    return [[PXGenericNode alloc] initWithType:EMA_APPLY];
}

- (PXGenericNode *)createApplyNodeWithName:(NSString *)name
{
    return [[PXGenericNode alloc] initWithType:EMA_APPLY stringValue:name];
}

- (PXGenericNode *)createCreateArrayNode
{
    return [[PXGenericNode alloc] initWithType:EMA_CREATE_ARRAY];
}

- (PXGenericNode *)createCreateArrayNodeCount:(uint)count
{
    return [[PXGenericNode alloc] initWithType:EMA_CREATE_ARRAY uintValue:count];
}

- (PXGenericNode *)createCreateObjectNode
{
    return [[PXGenericNode alloc] initWithType:EMA_CREATE_OBJECT];
}

- (PXGenericNode *)createCreateObjectNodeCount:(uint)count
{
    return [[PXGenericNode alloc] initWithType:EMA_CREATE_OBJECT uintValue:count];
}

- (PXGenericNode *)createDuplicateNode
{
    return [[PXGenericNode alloc] initWithType:EMA_DUP];
}

- (PXGenericNode *)createExecuteNode
{
    return [[PXGenericNode alloc] initWithType:EMA_EXEC];
}

- (PXGenericNode *)createGetElementNode
{
    return [[PXGenericNode alloc] initWithType:EMA_GET_ELEMENT uintValue:UINT_MAX];
}

- (PXGenericNode *)createGetElementNodeCount:(uint)count
{
    return [[PXGenericNode alloc] initWithType:EMA_GET_ELEMENT uintValue:count];
}

- (PXGenericNode *)createGetPropertyNode
{
    return [[PXGenericNode alloc] initWithType:EMA_GET_PROPERTY];
}

- (PXGenericNode *)createGetPropertyNodeWithName:(NSString *)name
{
    return [[PXGenericNode alloc] initWithType:EMA_GET_PROPERTY stringValue:name];
}

- (PXGenericNode *)createGetSymbolNode
{
    return [[PXGenericNode alloc] initWithType:EMA_GET_SYMBOL];
}

- (PXGenericNode *)createGetSymbolNodeWithName:(NSString *)name
{
    return [[PXGenericNode alloc] initWithType:EMA_GET_SYMBOL stringValue:name];
}

- (PXGenericNode *)createPushGlobalNode
{
    return [[PXGenericNode alloc] initWithType:EMA_GLOBAL];
}

- (PXGenericNode *)createIfElseNode
{
    return [[PXGenericNode alloc] initWithType:EMA_IF_ELSE];
}

- (PXGenericNode *)createInvokeNode
{
    return [[PXGenericNode alloc] initWithType:EMA_INVOKE];
}

- (PXGenericNode *)createInvokeNodeCount:(uint)count
{
    return [[PXGenericNode alloc] initWithType:EMA_INVOKE uintValue:count];
}

- (PXGenericNode *)createInvokeNodeWithName:(NSString *)name
{
    return [[PXGenericNode alloc] initWithType:EMA_INVOKE stringValue:name];
}

- (PXGenericNode *)createInvokeNodeWithName:(NSString *)name count:(uint)count
{
    return [[PXGenericNode alloc] initWithType:EMA_INVOKE stringValue:name uintValue:count];
}

- (PXGenericNode *)createPopNode
{
    return [[PXGenericNode alloc] initWithType:EMA_POP];
}

- (PXGenericNode *)createPushMarkNode
{
    return [[PXGenericNode alloc] initWithType:EMA_MARK];
}

- (PXGenericNode *)createPushStringNode:(NSString *)stringValue
{
    return [[PXGenericNode alloc] initWithType:EM_STRING stringValue:stringValue];
}

- (PXGenericNode *)createSwapNode
{
    return [[PXGenericNode alloc] initWithType:EMA_SWAP];
}

- (PXGenericNode *)createAddNode
{
    return [[PXGenericNode alloc] initWithType:EMA_ADD];
}

- (PXGenericNode *)createSubtractNode
{
    return [[PXGenericNode alloc] initWithType:EMA_SUB];
}

- (PXGenericNode *)createMultiplyNode
{
    return [[PXGenericNode alloc] initWithType:EMA_MUL];
}

- (PXGenericNode *)createDivideNode
{
    return [[PXGenericNode alloc] initWithType:EMA_DIV];
}

- (PXGenericNode *)createModulusNode
{
    return [[PXGenericNode alloc] initWithType:EMA_MOD];
}

- (PXGenericNode *)createAndNode
{
    return [[PXGenericNode alloc] initWithType:EM_AND];
}

- (PXGenericNode *)createOrNode
{
    return [[PXGenericNode alloc] initWithType:EM_OR];
}

- (PXGenericNode *)createNotNode
{
    return [[PXGenericNode alloc] initWithType:EM_NOT];
}

- (PXGenericNode *)createLessThanNode
{
    return [[PXGenericNode alloc] initWithType:EM_LT];
}

- (PXGenericNode *)createLessThanOrEqualNode
{
    return [[PXGenericNode alloc] initWithType:EM_LE];
}

- (PXGenericNode *)createEqualNode
{
    return [[PXGenericNode alloc] initWithType:EM_EQ];
}

- (PXGenericNode *)createNotEqualNode
{
    return [[PXGenericNode alloc] initWithType:EM_NE];
}

- (PXGenericNode *)createGreaterThanOrEqualNode
{
    return [[PXGenericNode alloc] initWithType:EM_GE];
}

- (PXGenericNode *)createGreaterThanNode
{
    return [[PXGenericNode alloc] initWithType:EM_GT];
}

- (PXGenericNode *)createSetSymbolNode
{
    return [[PXGenericNode alloc] initWithType:EMA_SET_SYMBOL];
}

- (PXGenericNode *)createSetSymbolNodeWithName:(NSString *)name
{
    return [[PXGenericNode alloc] initWithType:EMA_SET_SYMBOL stringValue:name];
}

@end
