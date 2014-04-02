//
//  PXExpressionEnvironment.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXExpressionScope.h"
#import "PXExpressionValue.h"

@class PXExpressionByteCode;
@class PXExpressionUnit;
@class PXInstructionProcessor;

@interface PXExpressionEnvironment : NSObject

@property (nonatomic, strong, readonly) id<PXExpressionScope> globalScope;
@property (nonatomic, strong, readonly) id<PXExpressionValue> globalObject;

/**
 *  This setter should not be used and has been made available for advance usage only.
 *  The pushScope and popScope methods should be used to maintain the scope chain. However,
 *  there are cases where the scope tree is relatively static. In those situations it may
 *  make sense to wire up the scope tree and then simply activate the current scope via
 *  this setter.
 */
@property (nonatomic, strong) id<PXExpressionScope> currentScope;

+ (PXInstructionProcessor *)processor;

- (id)initWithGlobalScope:(id<PXExpressionScope>)globalScope;

- (void)reset;
- (void)executeByteCode:(PXExpressionByteCode *)byteCode;
- (void)executeUnit:(PXExpressionUnit *)unit;

- (void)pushValue:(id<PXExpressionValue>)value;
- (void)pushBoolean:(BOOL)booleanValue;
- (void)pushDouble:(double)doubleValue;
- (void)pushString:(NSString *)stringValue;
- (void)pushNullValue;
- (void)pushUndefinedValue;
- (void)pushGlobal;
- (id<PXExpressionValue>)popValue;
- (NSArray *)popCount:(NSUInteger)count;
- (void)duplicateValue;
- (void)swapValues;
- (id<PXExpressionValue>)peek;

- (void)pushScope:(id<PXExpressionScope>)scope;
- (id<PXExpressionScope>)popScope;
- (id<PXExpressionValue>)getSymbol:(NSString *)name;
- (void)setValue:(id<PXExpressionValue>)value forSymbol:(NSString *)symbol;

- (void)logMessage:(NSString *)message;

#if DEBUG
- (NSString *)stackDescription;
#endif

@end
