//
//  PXExpressionObject.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/12/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionValue.h"

@protocol PXExpressionObject <PXExpressionValue>

@property (nonatomic, readonly) uint length;
@property (nonatomic, strong, readonly) NSArray *propertyNames;
@property (nonatomic, strong, readonly) NSArray *propertyValues;

- (void)setValue:(id<PXExpressionValue>)value forPropertyName:(NSString *)name;
- (id<PXExpressionValue>)valueForPropertyName:(NSString *)name;

@end
