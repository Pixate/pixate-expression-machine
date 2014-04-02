//
//  PXExpressionValueAssertions.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/6/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionValueAssertions.h"

#import "PXExpressionEnvironment.h"
#import "PXArrayValue.h"
#import "PXObjectValue.h"

@implementation PXExpressionValueAssertions

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

#pragma mark - Custom Assertions

- (void)assertBuiltInFunction:(NSString *)name
{
    // execute expression
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
    id<PXExpressionValue> f = [env getSymbol:name];

    XCTAssertNotNil(f, "Expected a non-nil result");
    XCTAssertTrue(f.valueType == PX_VALUE_TYPE_FUNCTION, @"Expected value to be a function");
}

- (void)assertBooleanValue:(id<PXExpressionValue>)value expected:(BOOL)expected
{
    XCTAssertNotNil(value, "Expected a non-nil result");
    XCTAssertTrue(value.valueType == PX_VALUE_TYPE_BOOLEAN, @"Expected value to be a boolean");
    XCTAssertTrue(value.booleanValue == expected, @"Expected result value to be '%d' but was '%d'", expected, value.booleanValue);
}

- (void)assertDoubleValue:(id<PXExpressionValue>)value expected:(double)expected
{
    XCTAssertNotNil(value, "Expected a non-nil result");
    XCTAssertTrue(value.valueType == PX_VALUE_TYPE_DOUBLE, @"Expected value to be a double");
    XCTAssertTrue(value.doubleValue == expected, @"Expected double value to be '%f' but was '%f'", expected, value.doubleValue);
}

- (void)assertStringValue:(id<PXExpressionValue>)value expected:(NSString *)expected
{
    XCTAssertNotNil(value, "Expected a non-nil result");
    XCTAssertTrue(value.valueType == PX_VALUE_TYPE_STRING, @"Expected value to be a string");
    XCTAssertTrue([value.stringValue isEqualToString:expected], "Expected string value '%@' but was '%@'", expected, value.stringValue);
}

- (void)assertArrayValue:(id<PXExpressionValue>)value expected:(NSArray *)expected
{
    XCTAssertNotNil(value, "Expected a non-nil result");
    XCTAssertTrue(value.valueType == PX_VALUE_TYPE_ARRAY, @"Expected value to be an array");

    PXArrayValue *array = (PXArrayValue *)value;

    XCTAssertTrue(array.length == expected.count, @"Expected array to have %lu elements, but it had %d", (unsigned long)expected.count, array.length);

    [expected enumerateObjectsUsingBlock:^(NSNumber *target, NSUInteger idx, BOOL *stop) {
        id<PXExpressionValue> elem = [array valueForIndex:(uint)idx];

        [self assertDoubleValue:elem expected:[target doubleValue]];
    }];
}

- (void)assertArrayValue:(id<PXExpressionValue>)value expectedStrings:(NSArray *)expected
{
    XCTAssertNotNil(value, "Expected a non-nil result");
    XCTAssertTrue(value.valueType == PX_VALUE_TYPE_ARRAY, @"Expected value to be an array");

    PXArrayValue *array = (PXArrayValue *)value;

    XCTAssertTrue(array.length == expected.count, @"Expected array to have %lu elements, but it had %d", (unsigned long)expected.count, array.length);

    [expected enumerateObjectsUsingBlock:^(NSString *target, NSUInteger idx, BOOL *stop) {
        id<PXExpressionValue> elem = [array valueForIndex:(uint)idx];

        [self assertStringValue:elem expected:target];
    }];
}

- (void)assertObjectValue:(id<PXExpressionValue>)value expected:(NSDictionary *)expected
{
    XCTAssertNotNil(value, "Expected a non-nil result");
    XCTAssertTrue(value.valueType == PX_VALUE_TYPE_OBJECT, @"Expected value to be an object");

    id<PXExpressionObject> object = (PXObjectValue *)value;

    XCTAssertTrue(object.length == expected.count, @"Expected object to have %lu elements, but it had %d", (unsigned long) expected.count, object.length);

    [expected enumerateKeysAndObjectsUsingBlock:^(NSString *key, id target, BOOL *stop) {
        id<PXExpressionValue> test = [object valueForPropertyName:key];

        if ([target isKindOfClass:[NSNumber class]])
        {
            [self assertDoubleValue:test expected:[target doubleValue]];
        }
        else if ([target isKindOfClass:[NSString class]])
        {
            [self assertStringValue:test expected:target];
        }
        else
        {
            XCTFail(@"Unsupported type when asserting object properties: %@", [target class]);
        }
    }];
}

@end
