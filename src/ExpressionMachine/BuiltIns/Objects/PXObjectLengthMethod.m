//
//  PXObjectLengthMethod.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXObjectLengthMethod.h"
#import "PXExpressionObject.h"

@implementation PXObjectLengthMethod

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    if (invocationObject.valueType == PX_VALUE_TYPE_OBJECT)
    {
        id<PXExpressionObject> object = (id<PXExpressionObject>)invocationObject;

        [env pushDouble:(double)object.length];
    }
    else
    {
        [env logMessage:@"The length property expects an object as the invocation object"];
    }
}

@end
