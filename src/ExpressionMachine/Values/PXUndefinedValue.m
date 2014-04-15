//
//  PXUndefinedValue.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/1/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXUndefinedValue.h"

@implementation PXUndefinedValue

#pragma mark - Static Methods

static PXUndefinedValue *INSTANCE;

+ (void)initialize
{
    if (INSTANCE == nil)
    {
        INSTANCE = [[PXUndefinedValue alloc] init];
    }
}

+ (PXUndefinedValue *)undefined
{
    return INSTANCE;
}

#pragma mark - Initializers

- (id)init
{
    return [self initWithValueType:PX_VALUE_TYPE_UNDEFINED];
}

#pragma mark - Getters

- (NSString *)stringValue
{
    return @"undefined";
}

@end
