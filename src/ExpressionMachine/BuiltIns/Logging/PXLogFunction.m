//
//  PXLogFunction.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/16/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXLogFunction.h"
#import "PXExpressionArray.h"

@implementation PXLogFunction

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    if (args.length > 0)
    {
        [args.elements enumerateObjectsUsingBlock:^(id<PXExpressionValue> item, NSUInteger idx, BOOL *stop) {
            [env logMessage:item.stringValue];
        }];
    }
}

@end
