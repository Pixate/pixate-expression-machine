//
//  PXUndefinedValue.m
//  Protostyle
//
//  Created by Kevin Lindsey on 3/1/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXUndefinedValue.h"

@implementation PXUndefinedValue

#pragma mark - Static Methods

+ (PXUndefinedValue *)undefined
{
    static PXUndefinedValue *undefined;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        undefined = [[PXUndefinedValue alloc] init];
    });

    return undefined;
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
