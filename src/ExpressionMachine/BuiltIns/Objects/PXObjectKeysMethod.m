//
//  PXObjectKeysMethod.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 4/2/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXObjectKeysMethod.h"
#import "PXObjectValue.h"
#import "PXArrayValue.h"
#import "PXStringValue.h"

@implementation PXObjectKeysMethod

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    // NOTE: only object values are required to be ordered, so we test for that type specifically. We could add reverse
    // to the PXExpressionObject and have non-ordered objects basically ignore the call.
    if ([invocationObject isKindOfClass:[PXObjectValue class]])
    {
        PXObjectValue *object = (PXObjectValue *)invocationObject;
        PXArrayValue *result = [[PXArrayValue alloc] init];

        [object.propertyNames enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
            [result pushValue:[[PXStringValue alloc] initWithString:propertyName]];
        }];

        [env pushValue:result];
    }
    else
    {
        // Only show a message if this was called on a non-object type
        if (invocationObject.valueType != PX_VALUE_TYPE_OBJECT)
        {
            [env logMessage:@"The keys method expects an object as the invocation object"];
        }
    }
}

@end
