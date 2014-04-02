//
//  PXStringLengthMethod.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 4/2/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXStringLengthMethod.h"
#import "PXStringValue.h"

@implementation PXStringLengthMethod

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    if (invocationObject.valueType == PX_VALUE_TYPE_STRING)
    {
        PXStringValue *string = (PXStringValue *)invocationObject;

        [env pushDouble:(double)string.length];
    }
    else
    {
        [env logMessage:@"The length method expects a string as the invocation object"];
    }
}

@end
