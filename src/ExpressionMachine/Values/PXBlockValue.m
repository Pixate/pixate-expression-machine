//
//  PXBlockValue.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/4/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXBlockValue.h"

@implementation PXBlockValue
{
    PXExpressionByteCode *_byteCode;
}

#pragma mark - Initializers

- (id)initWithByteCode:(PXExpressionByteCode *)byteCodeValue
{
    if (self = [super initWithValueType:PX_VALUE_TYPE_BLOCK])
    {
        _byteCode = byteCodeValue;
    }

    return self;
}

#pragma mark - Getters

- (PXExpressionByteCode *)byteCodeValue
{
    return _byteCode;
}

#pragma mark - Overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"{ %@ }", _byteCode.shortDescription];
}

@end
