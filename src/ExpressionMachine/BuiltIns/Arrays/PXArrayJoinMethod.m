//
//  PXArrayJoinMethod.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 4/2/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXArrayJoinMethod.h"

@implementation PXArrayJoinMethod

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    id<PXExpressionValue> item = [args valueForIndex:0];

    if (invocationObject.valueType == PX_VALUE_TYPE_ARRAY)
    {
        NSString *delimiter = (item.valueType == PX_VALUE_TYPE_UNDEFINED) ? @"" : item.stringValue;
        id<PXExpressionArray> array = (id<PXExpressionArray>)invocationObject;
        NSMutableArray *result = [[NSMutableArray alloc] init];

        [array.elements enumerateObjectsUsingBlock:^(id<PXExpressionValue> value, NSUInteger idx, BOOL *stop) {
            [result addObject:value.stringValue];
        }];

        [env pushString:[result componentsJoinedByString:delimiter]];
    }
    else
    {
        [env logMessage:@"The join method expects an array as the invocation object"];
    }
}

@end
