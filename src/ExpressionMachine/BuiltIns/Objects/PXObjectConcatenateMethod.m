//
//  PXObjectConcatenateMethod.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 4/4/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXObjectConcatenateMethod.h"
#import "PXObjectValue.h"

@implementation PXObjectConcatenateMethod

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    if (invocationObject.valueType == PX_VALUE_TYPE_OBJECT)
    {
        PXObjectValue *object = (PXObjectValue *)invocationObject;

        [args.elements enumerateObjectsUsingBlock:^(id<PXExpressionValue> obj, NSUInteger idx, BOOL *stop) {
            if (obj.valueType == PX_VALUE_TYPE_OBJECT)
            {
                [object concatenateObject:(id<PXExpressionObject>)obj];
            }
            else
            {
                NSString *message = [NSString stringWithFormat:@"Skipping non-object value in call to Object.concat at index %u", (unsigned int) idx];

                [env logMessage:message];
            }
        }];
    }
    else
    {
        [env logMessage:@"The push method expects an object as the invocation object"];
    }
}

@end
