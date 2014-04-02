//
//  PXArrayLengthMethod.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXArrayLengthMethod.h"

@implementation PXArrayLengthMethod

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    if (invocationObject.valueType == PX_VALUE_TYPE_ARRAY)
    {
        id<PXExpressionArray> array = (id<PXExpressionArray>)invocationObject;

        [env pushDouble:(double)array.length];
    }
    else
    {
        [env logMessage:@"The length property expects an array as the invocation object"];
    }
}

@end
