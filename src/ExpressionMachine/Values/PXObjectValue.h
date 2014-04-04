//
//  PXObjectValue.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionValueBase.h"
#import "PXExpressionObject.h"

@class PXExpressionEnvironment;

@interface PXObjectValue : PXExpressionValueBase <PXExpressionObject>

+ (PXObjectValue *)objectFromEnvironment:(PXExpressionEnvironment *)env;
+ (PXObjectValue *)objectFromEnvironment:(PXExpressionEnvironment *)env withCount:(uint)count;

- (void)setBooleanValue:(BOOL)value forPropertyName:(NSString *)name;
- (void)setStringValue:(NSString *)value forPropertyName:(NSString *)name;
- (void)setDoubleValue:(double)value forPropertyName:(NSString *)name;

- (void)concatenateObject:(id<PXExpressionObject>)object;
- (void)pushValue:(id<PXExpressionValue>)value forPropertyName:(NSString *)key;
- (void)unshiftValue:(id<PXExpressionValue>)value forPropertyName:(NSString *)key;
- (void)reverse;

@end
