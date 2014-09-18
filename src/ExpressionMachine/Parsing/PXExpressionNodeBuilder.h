//
//  PXExpressionNodeBuilder.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/26/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionNode.h"
#import "PXGenericNode.h"
#import "PXBlockNode.h"

@interface PXExpressionNodeBuilder : NSObject

- (PXBlockNode *)createBlockNode;
- (PXGenericNode *)createBooleanNode:(BOOL)booleanValue;
- (PXGenericNode *)createFunctionDefinitionNode:(NSString *)name
                                                parameters:(NSArray *)parameters
                                                      body:(PXBlockNode *)body;
- (PXGenericNode *)createNullNode;
- (PXGenericNode *)createNumberNode:(double)doubleValue;
- (PXGenericNode *)createParameterNode:(NSString *)name defaultValue:(id<PXExpressionNode>)defaultValue;
- (PXGenericNode *)createStringNode:(NSString *)stringValue;
- (PXGenericNode *)createUndefinedNode;

- (PXGenericNode *)createAdditionNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs;
- (PXGenericNode *)createSubtractionNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs;
- (PXGenericNode *)createMultiplicationNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs;
- (PXGenericNode *)createDivisionNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs;
- (PXGenericNode *)createModulusNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs;
- (PXGenericNode *)createLogicalAndNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs;
- (PXGenericNode *)createLogicalOrNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs;
- (PXGenericNode *)createLessThanNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs;
- (PXGenericNode *)createLessThanOrEqualNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs;
- (PXGenericNode *)createEqualNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs;
- (PXGenericNode *)createNotEqualNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs;
- (PXGenericNode *)createGreaterThanOrEqualNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs;
- (PXGenericNode *)createGreaterThanNode:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs;

- (PXGenericNode *)createArrayNode:(NSArray *)elements;
- (PXGenericNode *)createGetPropertyNode:(id<PXExpressionNode>)lhs withStringName:(NSString *)name;
- (PXGenericNode *)createGetPropertyNode:(id<PXExpressionNode>)lhs withName:(id<PXExpressionNode>)name;
- (PXGenericNode *)createIdentifierNode:(NSString *)stringValue;
- (PXGenericNode *)createInvokeNode:(id<PXExpressionNode>)lhs arguments:(NSArray *)args;
- (PXGenericNode *)createKeyValueNode:(NSString *)key value:(id<PXExpressionNode>)value;
- (PXGenericNode *)createObjectNode:(NSArray *)keyValuePairs;
- (PXGenericNode *)createSymbolNodeWithName:(NSString *)name;
- (PXGenericNode *)createSymbolNodeWithName:(NSString *)name value:(id<PXExpressionNode>)value;
- (PXGenericNode *)createThisNode;

- (PXGenericNode *)createGetElementNode:(id<PXExpressionNode>)lhs withIndex:(id<PXExpressionNode>)index;
- (PXGenericNode *)createLogicalNotNode:(id<PXExpressionNode>)expression;
- (PXGenericNode *)createNegateNode:(id<PXExpressionNode>)expression;

- (PXGenericNode *)createIfNode;
- (PXGenericNode *)createIfNode:(id<PXExpressionNode>)condition trueBlock:(PXBlockNode *)trueBlock;
- (PXGenericNode *)createIfNode:(id<PXExpressionNode>)condition
                      trueBlock:(PXBlockNode *)trueBlock
                     falseBlock:(PXBlockNode *)falseBlock;
- (PXGenericNode *)createApplyNode;
- (PXGenericNode *)createApplyNodeWithName:(NSString *)name;
- (PXGenericNode *)createCreateArrayNode;
- (PXGenericNode *)createCreateArrayNodeCount:(uint)count;
- (PXGenericNode *)createCreateObjectNode;
- (PXGenericNode *)createCreateObjectNodeCount:(uint)count;
- (PXGenericNode *)createDuplicateNode;
- (PXGenericNode *)createExecuteNode;
- (PXGenericNode *)createGetElementNode;
- (PXGenericNode *)createGetElementNodeCount:(uint)count;
- (PXGenericNode *)createGetPropertyNode;
- (PXGenericNode *)createGetPropertyNodeWithName:(NSString *)name;
- (PXGenericNode *)createGetSymbolNode;
- (PXGenericNode *)createGetSymbolNodeWithName:(NSString *)name;
- (PXGenericNode *)createPushGlobalNode;
- (PXGenericNode *)createIfElseNode;
- (PXGenericNode *)createInvokeNode;
- (PXGenericNode *)createInvokeNodeCount:(uint)count;
- (PXGenericNode *)createInvokeNodeWithName:(NSString *)name;
- (PXGenericNode *)createInvokeNodeWithName:(NSString *)name count:(uint)count;
- (PXGenericNode *)createPopNode;
- (PXGenericNode *)createPushMarkNode;
- (PXGenericNode *)createPushStringNode:(NSString *)stringValue;
- (PXGenericNode *)createSwapNode;
- (PXGenericNode *)createAddNode;
- (PXGenericNode *)createSubtractNode;
- (PXGenericNode *)createMultiplyNode;
- (PXGenericNode *)createDivideNode;
- (PXGenericNode *)createModulusNode;
- (PXGenericNode *)createAndNode;
- (PXGenericNode *)createOrNode;
- (PXGenericNode *)createNotNode;
- (PXGenericNode *)createLessThanNode;
- (PXGenericNode *)createLessThanOrEqualNode;
- (PXGenericNode *)createEqualNode;
- (PXGenericNode *)createNotEqualNode;
- (PXGenericNode *)createGreaterThanOrEqualNode;
- (PXGenericNode *)createGreaterThanNode;
- (PXGenericNode *)createSetSymbolNode;
- (PXGenericNode *)createSetSymbolNodeWithName:(NSString *)name;

@end
