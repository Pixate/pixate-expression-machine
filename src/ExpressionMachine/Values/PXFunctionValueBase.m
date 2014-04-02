//
//  PXFunctionValueBase.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXFunctionValueBase.h"
#import "PXExpressionEnvironment.h"
#import "PXExpressionArray.h"

@implementation PXFunctionValueBase

#pragma mark - Initializers

- (id)init
{
    return [self initWithValueType:PX_VALUE_TYPE_FUNCTION];
}

#pragma mark - PXFunctionValue Implementation

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    // NOTE: subclasses will override this method
}

@end
