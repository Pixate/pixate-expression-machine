//
//  PXExpressionProperty.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 4/16/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionValue.h"

@protocol PXExpressionProperty <NSObject>

- (id)initWithInstance:(id)instance getterName:(NSString *)getterName setterName:(NSString *)setterName;
- (id)initWithInstance:(id)instance getterSelector:(SEL)getterSelector setterSelector:(SEL)setterSelector;

- (id<PXExpressionValue>)getExpressionValueFromObject:(id)object;
- (void)setExpressionValue:(id<PXExpressionValue>)value onObject:(id)object;

@end
