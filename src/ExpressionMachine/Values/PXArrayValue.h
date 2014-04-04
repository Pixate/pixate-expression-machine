//
//  PXArrayValue.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/27/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionValueBase.h"
#import "PXExpressionArray.h"
#import "PXExpressionObject.h"

@class PXExpressionEnvironment;

@interface PXArrayValue : PXExpressionValueBase <PXExpressionArray, PXExpressionObject>

+ (PXArrayValue *)arrayFromEnvironment:(PXExpressionEnvironment *)env;
+ (PXArrayValue *)arrayFromEnvironment:(PXExpressionEnvironment *)env withCount:(uint)count;

- (void)pushValue:(id<PXExpressionValue>)value;
- (id<PXExpressionValue>)popValue;
- (id<PXExpressionValue>)shiftValue;
- (void)unshiftValue:(id<PXExpressionValue>)value;
- (void)reverse;

@end
