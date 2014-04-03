//
//  PXExpressionArray.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/12/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionValue.h"

@protocol PXExpressionArray <PXExpressionValue>

@property (nonatomic, strong, readonly) NSArray *elements;
@property (nonatomic, readonly) uint length;

- (void)setValue:(id<PXExpressionValue>)value forIndex:(int)index;
- (id<PXExpressionValue>)valueForIndex:(int)index;

@end
