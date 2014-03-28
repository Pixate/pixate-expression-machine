//
//  PXArrayPushMethod.m
//  Protostyle
//
//  Created by Kevin Lindsey on 3/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXArrayPushMethod.h"

@implementation PXArrayPushMethod

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    if (invocationObject.valueType == PX_VALUE_TYPE_ARRAY)
    {
        id<PXExpressionArray> array = (id<PXExpressionArray>)invocationObject;

        [args.elements enumerateObjectsUsingBlock:^(id<PXExpressionValue> value, NSUInteger idx, BOOL *stop) {
            [array pushValue:value];
        }];
    }
    else
    {
        [env logMessage:@"The push method expects an array as the invocation object"];
    }
}

@end
