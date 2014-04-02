//
//  PXBooleanValue.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXBooleanValue.h"

@implementation PXBooleanValue
{
    BOOL _booleanValue;
}

#pragma mark - Initializers

- (id)initWithBoolean:(BOOL)booleanValue
{
    if (self = [super initWithValueType:PX_VALUE_TYPE_BOOLEAN])
    {
        _booleanValue = booleanValue;
    }

    return self;
}

#pragma mark - Getters

- (BOOL)booleanValue
{
    return _booleanValue;
}

- (NSString *)stringValue
{
    return (_booleanValue) ? @"true" : @"false";
}

- (double)doubleValue
{
    return (_booleanValue) ? 1.0 : 0.0;
}

@end
