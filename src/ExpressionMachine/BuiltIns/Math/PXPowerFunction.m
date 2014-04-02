//
//  PXPowerFunction.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/10/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXPowerFunction.h"

@implementation PXPowerFunction

#pragma mark - PXFunctionValue Implementation

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    double base = (args.length > 0) ? [args valueForIndex:0].doubleValue : 0.0;
    double exponent = (args.length > 1) ? [args valueForIndex:1].doubleValue : 0.0;

    [env pushDouble:pow(base, exponent)];
}

@end
