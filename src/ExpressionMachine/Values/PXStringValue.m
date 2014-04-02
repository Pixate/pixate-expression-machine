//
//  PXStringValue.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXStringValue.h"

@implementation PXStringValue
{
    NSString *_stringValue;
}

#pragma mark - Initializers

- (id)initWithString:(NSString *)stringValue
{
    if (self = [super initWithValueType:PX_VALUE_TYPE_STRING])
    {
        _stringValue = stringValue;
    }

    return self;
}

#pragma mark - Getters

- (BOOL)booleanValue
{
    return _stringValue.length > 0;
}

- (NSString *)stringValue
{
    return _stringValue;
}

- (double)doubleValue
{
    return [_stringValue doubleValue];
}

#pragma mark - Overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"'%@'", _stringValue];
}

@end
