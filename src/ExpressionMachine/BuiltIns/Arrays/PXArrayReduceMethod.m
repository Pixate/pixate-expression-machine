//
//  PXArrayReduceMethod.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXArrayReduceMethod.h"
#import "PXArrayValue.h"
#import "PXDoubleValue.h"

@implementation PXArrayReduceMethod

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    id<PXExpressionValue> item = [args valueForIndex:0];
    id<PXExpressionValue> first = [args valueForIndex:1];

    if (item.valueType == PX_VALUE_TYPE_FUNCTION && invocationObject.valueType == PX_VALUE_TYPE_ARRAY)
    {
        id<PXExpressionFunction> function = (id<PXExpressionFunction>)item;
        id<PXExpressionArray> array = (id<PXExpressionArray>)invocationObject;
        __block id<PXExpressionValue> result = first;

        [array.elements enumerateObjectsUsingBlock:^(id<PXExpressionValue> value, NSUInteger idx, BOOL *stop) {
            PXArrayValue *args = [[PXArrayValue alloc] init];

            [args pushValue:result];
            [args pushValue:value];
            [args pushValue:[[PXDoubleValue alloc] initWithDouble:(double) idx]];

            [function invokeWithEnvironment:env invocationObject:invocationObject args:args];

            result = [env popValue];
        }];

        [env pushValue:result];
    }
    else
    {
        [env logMessage:@"The reduce method expects an array as the invocation object with a function and first-value arguments"];
    }
}

@end
