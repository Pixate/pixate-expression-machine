//
//  PXEasingTests.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/11/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PXExpressionEnvironment.h"
#import "PXExpressionScope.h"
#import "PXEasing.h"
#import "PXArrayValue.h"
#import "PXDoubleValue.h"
#import "PXExpressionFunction.h"
#import "PXUndefinedValue.h"

#import "PXInstructionProcessor.h"
#import "PXInstructionCounter.h"

@interface PXEasingTests : XCTestCase

@end

@implementation PXEasingTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)assertEasingName:(NSString *)name type:(EasingType)type
{
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
    id<PXExpressionScope> scope = [env globalScope];
    id<PXExpressionValue> item = [scope valueForSymbolName:name];

    XCTAssertTrue(item.valueType == PX_VALUE_TYPE_FUNCTION, @"Expected a function for '%@'", name);
    id<PXExpressionFunction> function = (id<PXExpressionFunction>) item;

    for (int i = 0; i <= 10; i++)
    {
        double t = i / 10.0;

        PXArrayValue *array = [[PXArrayValue alloc] init];
        id<PXExpressionValue> invocationObject = [PXUndefinedValue undefined];

        [array pushValue:[[PXDoubleValue alloc] initWithDouble:t]];

        [function invokeWithEnvironment:env invocationObject:invocationObject args:array];

        id<PXExpressionValue> result = [env popValue];
        double expected = (double) [PXEasing easeType:type t:t];

        XCTAssertEqualWithAccuracy(result.doubleValue, expected, 1e-6, @"Expected %g but got %g at t = %g", expected, result.doubleValue, t);
    }
}

#pragma mark - Linear easing
- (void)testLinearEasing
{
    [self assertEasingName:@"linear" type:LinearEasing];
}

#pragma mark - Quad easings

- (void)testQuadInEasing
{
    [self assertEasingName:@"quadraticIn" type:EaseInQuadEasing];
}

- (void)testQuadOutEasing
{
    [self assertEasingName:@"quadraticOut" type:EaseOutQuadEasing];
}

- (void)testQuadInOutEasing
{
    [self assertEasingName:@"quadraticInOut" type:EaseInOutQuadEasing];
}

- (void)testQuadInAndBackEasing
{
    [self assertEasingName:@"quadraticInAndBack" type:EaseInAndBackQuadEasing];
}

- (void)testQuadOutAndBackEasing
{
    [self assertEasingName:@"quadraticOutAndBack" type:EaseOutAndBackQuadEasing];
}

#pragma mark - Cubic easings

- (void)testCubicInEasing
{
    [self assertEasingName:@"cubicIn" type:EaseInCubicEasing];
}

- (void)testCubicOutEasing
{
    [self assertEasingName:@"cubicOut" type:EaseOutCubicEasing];
}

- (void)testCubicInOutEasing
{
    [self assertEasingName:@"cubicInOut" type:EaseInOutCubicEasing];
}

#pragma mark - Quartic easings

- (void)testQuarticInEasing
{
    [self assertEasingName:@"quarticIn" type:EaseInQuartEasing];
}

- (void)testQuarticOutEasing
{
    [self assertEasingName:@"quarticOut" type:EaseOutQuartEasing];
}

- (void)testQuarticInOutEasing
{
    [self assertEasingName:@"quarticInOut" type:EaseInOutQuartEasing];
}

#pragma mark - Quintic easings

- (void)testQuinticInEasing
{
    [self assertEasingName:@"quinticIn" type:EaseInQuintEasing];
}

- (void)testQuinticOutEasing
{
    [self assertEasingName:@"quinticOut" type:EaseOutQuintEasing];
}

- (void)testQuinticInOutEasing
{
    [self assertEasingName:@"quinticInOut" type:EaseInOutQuintEasing];
}

#pragma mark - Sine easings

- (void)testSineInEasing
{
    [self assertEasingName:@"sineIn" type:EaseInSine];
}

- (void)testSineOutEasing
{
    [self assertEasingName:@"sineOut" type:EaseOutSine];
}

- (void)testSineInOutEasing
{
    [self assertEasingName:@"sineInOut" type:EaseInOutSine];
}

#pragma mark - Exponential easings

- (void)testExponentialInEasing
{
    [self assertEasingName:@"exponentialIn" type:EaseInExpo];
}

- (void)testExponentialOutEasing
{
    [self assertEasingName:@"exponentialOut" type:EaseOutExpo];
}

- (void)testExponentialInOutEasing
{
    [self assertEasingName:@"exponentialInOut" type:EaseInOutExpo];
}

#pragma mark - Circular easings

- (void)testCircularInEasing
{
    [self assertEasingName:@"circularIn" type:EaseInCirc];
}

- (void)testCircularOutEasing
{
    [self assertEasingName:@"circularOut" type:EaseOutCirc];
}

- (void)testCircularInOutEasing
{
    [self assertEasingName:@"circularInOut" type:EaseInOutCirc];
}

#pragma mark - Elastic easings

- (void)testElasticInEasing
{
    [self assertEasingName:@"elasticIn" type:EaseInElastic];
}

- (void)testElasticOutEasing
{
    [self assertEasingName:@"elasticOut" type:EaseOutElastic];
}

- (void)testElasticInOutEasing
{
    [self assertEasingName:@"elasticInOut" type:EaseInOutElastic];
}

#pragma mark - Back easings

- (void)testBackInEasing
{
    [self assertEasingName:@"backIn" type:EaseInBack];
}

- (void)testBackOutEasing
{
    [self assertEasingName:@"backOut" type:EaseOutBack];
}

- (void)testBackInOutEasing
{
    [self assertEasingName:@"backInOut" type:EaseInOutBack];
}

#pragma mark - Bounce easings

- (void)testBounceInEasing
{
    [self assertEasingName:@"bounceIn" type:EaseInBounce];
}

- (void)testBounceOutEasing
{
    [self assertEasingName:@"bounceOut" type:EaseOutBounce];
}

- (void)testBounceInOutEasing
{
    [self assertEasingName:@"bounceInOut" type:EaseInOutBounce];
}

#pragma mark - Performance test

- (void)testEM
{
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
    PXInstructionProcessor *processor = [PXExpressionEnvironment processor];

    if ([processor isKindOfClass:[PXInstructionCounter class]])
    {
        PXInstructionCounter *counter = (PXInstructionCounter *)processor;

        [counter reset];
    }

    id<PXExpressionScope> scope = [env globalScope];
    id<PXExpressionValue> item = [scope valueForSymbolName:@"bounceInOut"];
    id<PXExpressionFunction> function = (id<PXExpressionFunction>) item;

    NSDate *start = [NSDate date];

    for (int i = 0; i < 1000; i++) {
        for (int j = 0; j <= 10; j++) {
            double t = j / 10.0;

            PXArrayValue *array = [[PXArrayValue alloc] init];
            id<PXExpressionValue> invocationObject = [PXUndefinedValue undefined];

            [array pushValue:[[PXDoubleValue alloc] initWithDouble:t]];

            [function invokeWithEnvironment:env invocationObject:invocationObject args:array];

            [env popValue];
        }
    }

    NSTimeInterval diff = [start timeIntervalSinceNow];

    NSLog(@"EM time = %g", diff);

    if ([processor isKindOfClass:[PXInstructionCounter class]])
    {
        PXInstructionCounter *counter = (PXInstructionCounter *)processor;

        [counter dump];
    }
}

- (void)testObjc
{
    NSDate *start = [NSDate date];

    for (int i = 0; i < 1e6; i++) {
        for (int j = 0; j <= 10; j++) {
            double t = j / 10.0;

            [PXEasing easeType:EaseInOutBounce t:t];
        }
    }

    NSTimeInterval diff = [start timeIntervalSinceNow];

    NSLog(@"objc time = %g", diff);
}

@end
