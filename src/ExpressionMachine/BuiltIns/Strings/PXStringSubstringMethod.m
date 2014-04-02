//
//  PXStringSubstringMethod.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 4/2/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXStringSubstringMethod.h"
#import "PXStringValue.h"

@implementation PXStringSubstringMethod

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    id<PXExpressionValue> offset = [args valueForIndex:0];
    id<PXExpressionValue> length = [args valueForIndex:1];

    if (invocationObject.valueType == PX_VALUE_TYPE_STRING)
    {
        PXStringValue *string = (PXStringValue *)invocationObject;
        NSRange range = NSMakeRange((NSUInteger)offset.doubleValue, (NSUInteger)length.doubleValue);

        [env pushString:[string.stringValue substringWithRange:range]];
    }
    else
    {
        [env logMessage:@"The substring method expects a string as the invocation object"];
    }
}

@end
