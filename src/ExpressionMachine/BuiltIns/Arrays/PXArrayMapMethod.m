//
//  PXArrayMapMethod.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXArrayMapMethod.h"
#import "PXArrayValue.h"
#import "PXDoubleValue.h"

@implementation PXArrayMapMethod

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    id<PXExpressionValue> item = [args valueForIndex:0];

    if (item.valueType == PX_VALUE_TYPE_FUNCTION && invocationObject.valueType == PX_VALUE_TYPE_ARRAY)
    {
        id<PXExpressionFunction> function = (id<PXExpressionFunction>)item;
        id<PXExpressionArray> array = (id<PXExpressionArray>)invocationObject;
        PXArrayValue *result = [[PXArrayValue alloc] init];

        [array.elements enumerateObjectsUsingBlock:^(id<PXExpressionValue> value, NSUInteger idx, BOOL *stop) {
            PXArrayValue *args = [[PXArrayValue alloc] init];

            [args pushValue:value];
            [args pushValue:[[PXDoubleValue alloc] initWithDouble:(double) idx]];

            [function invokeWithEnvironment:env invocationObject:invocationObject args:args];

            [result pushValue:[env popValue]];
        }];

        [env pushValue:result];
    }
    else
    {
        [env logMessage:@"The map method expects an array as the invocation object with a function argument"];
    }
}

@end
