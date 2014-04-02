//
//  PXDoubleValue.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXDoubleValue.h"

@implementation PXDoubleValue
{
    double _doubleValue;
}

#pragma mark - Initializers

- (id)initWithDouble:(double)doubleValue
{
    if (self = [super initWithValueType:PX_VALUE_TYPE_DOUBLE])
    {
        _doubleValue = doubleValue;
    }

    return self;
}

#pragma mark - Getters

- (NSString *)stringValue
{
    return [NSString stringWithFormat:@"%g", _doubleValue];
}

- (double)doubleValue
{
    return _doubleValue;
}

@end
