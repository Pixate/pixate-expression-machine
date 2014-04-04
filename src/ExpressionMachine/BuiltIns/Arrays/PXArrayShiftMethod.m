//
//  PXArrayShiftMethod.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXArrayShiftMethod.h"
#import "PXArrayValue.h"

@implementation PXArrayShiftMethod

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    if (invocationObject.valueType == PX_VALUE_TYPE_ARRAY)
    {
        PXArrayValue *array = (PXArrayValue *)invocationObject;

        [env pushValue:[array shiftValue]];
    }
    else
    {
        [env logMessage:@"The shift method expects an array as the invocation object"];
    }
}

@end
