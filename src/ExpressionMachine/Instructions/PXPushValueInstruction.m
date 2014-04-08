//
//  PXPushValueInstruction.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXPushValueInstruction.h"
#import "PXExpressionInstructionType.h"
#import "PXBooleanValue.h"
#import "PXStringValue.h"
#import "PXDoubleValue.h"
#import "PXBlockValue.h"

@implementation PXPushValueInstruction
{
    NSMutableArray *values_;
}

#pragma mark - Static methods

+ (PXPushValueInstruction *)expressionValue:(id<PXExpressionValue>)value
{
    return [[PXPushValueInstruction alloc] initWithExpressionValue:value];
}

+ (PXPushValueInstruction *)booleanValue:(BOOL)booleanValue
{
    return [[PXPushValueInstruction alloc] initWithBoolean:booleanValue];
}

+ (PXPushValueInstruction *)stringValue:(NSString *)stringValue
{
    return [[PXPushValueInstruction alloc] initWithString:stringValue];
}

+ (PXPushValueInstruction *)doubleValue:(double)doubleValue
{
    return [[PXPushValueInstruction alloc] initWithDouble:doubleValue];
}

+ (PXPushValueInstruction *)blockValue:(PXExpressionByteCode *)byteCodeValue
{
    return [[PXPushValueInstruction alloc] initWithByteCode:byteCodeValue];
}

#pragma mark - Initializers

- (id)initWithExpressionValue:(id<PXExpressionValue>)value
{
    if (self = [super initWithType:EM_INSTRUCTION_STACK_PUSH])
    {
        _value = value;
    }

    return self;
}

- (id)initWithBoolean:(BOOL)booleanValue
{
    PXBooleanValue *value = [[PXBooleanValue alloc] initWithBoolean:booleanValue];

    return [self initWithExpressionValue:value];
}

- (id)initWithString:(NSString *)stringValue
{
    PXStringValue *value = [[PXStringValue alloc] initWithString:stringValue];

    return [self initWithExpressionValue:value];
}

- (id)initWithDouble:(double)doubleValue
{
    PXDoubleValue *value = [[PXDoubleValue alloc] initWithDouble:doubleValue];

    return [self initWithExpressionValue:value];
}

- (id)initWithByteCode:(PXExpressionByteCode *)byteCode
{
    PXBlockValue *value = [[PXBlockValue alloc] initWithByteCode:byteCode];

    return [self initWithExpressionValue:value];
}

#pragma mark - Getters

- (NSArray *)values
{
    return [values_ copy];
}

#pragma mark - Methods

- (void)pushValue:(id<PXExpressionValue>)value
{
    if (values_ == nil)
    {
        values_ = [[NSMutableArray alloc] init];

        if (_value != nil)
        {
            [values_ addObject:_value];
            _value = nil;
        }
    }

    [values_ addObject:value];
}

#pragma mark - NSCopying Implementation

- (id)copyWithZone:(NSZone *)zone
{
    PXPushValueInstruction *result = [[PXPushValueInstruction alloc] initWithType:EM_INSTRUCTION_STACK_PUSH];

    result->_value = _value;
    result->values_ = (values_ != nil) ? [NSMutableArray arrayWithArray:values_] : nil;

    return result;
}

@end
