//
//  PXParameter.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/3/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXParameter.h"

@implementation PXParameter

#pragma mark - Initializers

- (id)initWithName:(NSString *)name defaultValue:(id<PXExpressionValue>)defaultValue
{
    if (self = [super init])
    {
        _name = name;
        _defaultValue = defaultValue;
    }

    return self;
}

#pragma mark - Overrides

- (NSString *)description
{
    if (_defaultValue.valueType == PX_VALUE_TYPE_UNDEFINED)
    {
        return _name;
    }
    else
    {
        return [NSString stringWithFormat:@"%@=%@", _name, _defaultValue.description];
    }
}

@end
