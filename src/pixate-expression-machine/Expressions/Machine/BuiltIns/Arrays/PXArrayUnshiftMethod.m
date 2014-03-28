//
//  PXArrayUnshiftMethod.m
//  Protostyle
//
//  Created by Kevin Lindsey on 3/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXArrayUnshiftMethod.h"

@implementation PXArrayUnshiftMethod

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    if (invocationObject.valueType == PX_VALUE_TYPE_ARRAY)
    {
        id<PXExpressionArray> array = (id<PXExpressionArray>)invocationObject;

        [env pushValue:[array unshiftValue]];
    }
    else
    {
        [env logMessage:@"The unshift method expects an array as the invocation object"];
    }
}

@end
