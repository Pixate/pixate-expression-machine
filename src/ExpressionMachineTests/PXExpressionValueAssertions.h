//
//  PXExpressionValueAssertions.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/6/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PXExpressionValue.h"

@interface PXExpressionValueAssertions : XCTestCase

- (void)assertBuiltInFunction:(NSString *)name;
- (void)assertBooleanValue:(id<PXExpressionValue>)value expected:(BOOL)expected;
- (void)assertDoubleValue:(id<PXExpressionValue>)value expected:(double)expected;
- (void)assertStringValue:(id<PXExpressionValue>)value expected:(NSString *)expected;
- (void)assertArrayValue:(id<PXExpressionValue>)value expected:(NSArray *)expected;
- (void)assertArrayValue:(id<PXExpressionValue>)value expectedStrings:(NSArray *)expected;
- (void)assertObjectValue:(id<PXExpressionValue>)value expected:(NSDictionary *)expected;

@end
