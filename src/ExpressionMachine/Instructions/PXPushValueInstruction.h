//
//  PXPushValueInstruction.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionInstruction.h"
#import "PXExpressionValue.h"
#import "PXBlockValue.h"

@interface PXPushValueInstruction : PXExpressionInstruction <NSCopying>

+ (PXPushValueInstruction *)expressionValue:(id<PXExpressionValue>)value;
+ (PXPushValueInstruction *)booleanValue:(BOOL)booleanValue;
+ (PXPushValueInstruction *)stringValue:(NSString *)stringValue;
+ (PXPushValueInstruction *)doubleValue:(double)doubleValue;
+ (PXPushValueInstruction *)blockValue:(PXExpressionByteCode *)byteCodeValue;

@property (nonatomic, strong, readonly) id<PXExpressionValue> value;
@property (nonatomic, strong, readonly) NSArray *values;

- (id)initWithExpressionValue:(id<PXExpressionValue>)value;
- (id)initWithBoolean:(BOOL)booleanValue;
- (id)initWithString:(NSString *)stringValue;
- (id)initWithDouble:(double)doubleValue;
- (id)initWithByteCode:(PXExpressionByteCode *)byteCode;

- (void)pushValue:(id<PXExpressionValue>)value;

@end
