//
//  PXObjectForEachMethod.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXObjectForEachMethod.h"
#import "PXExpressionObject.h"
#import "PXArrayValue.h"
#import "PXDoubleValue.h"
#import "PXStringValue.h"

@implementation PXObjectForEachMethod

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    id<PXExpressionValue> item = [args valueForIndex:0];

    if (item.valueType == PX_VALUE_TYPE_FUNCTION && invocationObject.valueType == PX_VALUE_TYPE_OBJECT)
    {
        id<PXExpressionFunction> function = (id<PXExpressionFunction>)item;
        id<PXExpressionObject> object = (id<PXExpressionObject>)invocationObject;

        [object.propertyNames enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
            id<PXExpressionValue> value = [object valueForPropertyName:key];
            PXArrayValue *args = [[PXArrayValue alloc] init];

            [args pushValue:[[PXStringValue alloc] initWithString:key]];
            [args pushValue:value];
            [args pushValue:[[PXDoubleValue alloc] initWithDouble:(double) idx]];

            [function invokeWithEnvironment:env invocationObject:invocationObject args:args];
        }];
    }
    else
    {
        [env logMessage:@"The forEach method expects an object as the invocation object with a function argument"];
    }
}

@end
