//
//  PXObjectPushMethod.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 4/4/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXObjectPushMethod.h"
#import "PXObjectValue.h"

@implementation PXObjectPushMethod

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    if (invocationObject.valueType == PX_VALUE_TYPE_OBJECT)
    {
        PXObjectValue *object = (PXObjectValue *)invocationObject;

        uint count = args.length - (args.length % 2);

        for (uint i = 0; i < count; i += 2)
        {
            id<PXExpressionValue> key = [args valueForIndex:i];
            id<PXExpressionValue> value = [args valueForIndex:i + 1];

            [object pushValue:value forPropertyName:key.stringValue];
        }
    }
    else
    {
        [env logMessage:@"The push method expects an object as the invocation object"];
    }
}

@end
