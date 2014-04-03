//
//  PXArrayPopMethod.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXArrayPopMethod.h"
#import "PXArrayValue.h"

@implementation PXArrayPopMethod

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    if (invocationObject.valueType == PX_VALUE_TYPE_ARRAY)
    {
        PXArrayValue *array = (PXArrayValue *)invocationObject;

        [env pushValue:[array popValue]];
    }
    else
    {
        [env logMessage:@"The pop method expects an array as the invocation object"];
    }
}

@end
