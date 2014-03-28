//
//  PXPushValueInstruction.m
//  Protostyle
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
    id<PXExpressionValue> _value;
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

@end
