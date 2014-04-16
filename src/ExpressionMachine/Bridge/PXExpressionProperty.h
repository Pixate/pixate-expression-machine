//
//  PXExpressionProperty.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 4/16/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionValue.h"

@protocol PXExpressionProperty <NSObject>

- (id<PXExpressionValue>)getExpressionValueFromObject:(id)object;
- (void)setExpressionValue:(id<PXExpressionValue>)value onObject:(id)object;

@end
