//
//  PXShowResultFunction.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/20/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXShowTopFunction.h"

@implementation PXShowTopFunction

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    // TODO: allow the user to specify how many items on the stack to display
    id<PXExpressionValue> item = [env peek];

    if (item != nil)
    {
        if (args.length > 0)
        {
            id<PXExpressionValue> prefix = [args valueForIndex:0];
            NSString *message = [NSString stringWithFormat:@"%@%@", prefix.stringValue, item.stringValue];

            [env logMessage:message];
        }
        else
        {
            [env logMessage:item.stringValue];
        }
    }
    else
    {
        [env logMessage:@"<empty-stack>"];
    }
}

@end
