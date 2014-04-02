//
//  PXNullValue.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/1/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXNullValue.h"

@implementation PXNullValue

#pragma mark - Static Methods

+ (PXNullValue *)null
{
    static PXNullValue *null;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        null = [[PXNullValue alloc] init];
    });

    return null;
}

#pragma mark - Initializers

- (id)init
{
    return [self initWithValueType:PX_VALUE_TYPE_NULL];
}

- (NSString *)stringValue
{
    return @"null";
}

@end
