//
//  PXEmNode.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionNode.h"

@interface PXGenericNode : NSObject <PXExpressionNode>

@property (nonatomic, strong, readonly) NSArray *arrayValue;
@property (nonatomic, strong, readonly) id<PXExpressionNode> nodeValue;
@property (nonatomic, strong, readonly) id<PXExpressionNode> nodeValue2;
@property (nonatomic, strong, readonly) id<PXExpressionNode> nodeValue3;
@property (nonatomic, readonly) BOOL booleanValue;
@property (nonatomic, readonly) double doubleValue;
@property (nonatomic, strong, readonly) NSString *stringValue;
@property (nonatomic, readonly) uint uintValue;

- (id)initWithType:(int)type;
- (id)initWithType:(int)type arrayValue:(NSArray *)arrayValue;
- (id)initWithType:(int)type booleanValue:(BOOL)booleanValue;
- (id)initWithType:(int)type doubleValue:(double)doubleValue;
- (id)initWithType:(int)type stringValue:(NSString *)stringValue;
- (id)initWithType:(int)type nodeValue:(id<PXExpressionNode>)nodeValue;
- (id)initWithType:(int)type uintValue:(uint)uintValue;
- (id)initWithType:(int)type stringValue:(NSString *)stringValue uintValue:(uint)uintValue;
- (id)initWithType:(int)type nodeValue:(id<PXExpressionNode>)nodeValue stringValue:(NSString *)stringValue;
- (id)initWithType:(int)type nodeValue:(id<PXExpressionNode>)nodeValue arrayValue:(NSArray *)arrayValue;
- (id)initWithType:(int)type nodeValue:(id<PXExpressionNode>)nodeValue arrayValue:(NSArray *)arrayValue stringValue:(NSString *)stringValue;
- (id)initWithType:(int)type lhs:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs;
- (id)initWithType:(int)type
         condition:(id<PXExpressionNode>)condition
         trueBlock:(id<PXExpressionNode>)trueBlock
        falseBlock:(id<PXExpressionNode>)falseBlock;

@end
