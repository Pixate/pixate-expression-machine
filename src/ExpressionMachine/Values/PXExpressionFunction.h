//
//  PXFunctionValue.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionValue.h"
#import "PXExpressionEnvironment.h"
#import "PXExpressionArray.h"

@protocol PXExpressionFunction <PXExpressionValue>

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args;

@end
