//
//  PXExpressionValueTests.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/28/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionValueAssertions.h"

#import "PXExpressionParser.h"
#import "PXExpressionEnvironment.h"
#import "PXScope.h"
#import "PXSquareFunction.h"

#import "PXArrayValue.h"
#import "PXBooleanValue.h"
#import "PXDoubleValue.h"
#import "PXMarkValue.h"
#import "PXObjectValue.h"
#import "PXStringValue.h"

@interface PXExpressionValueTests : PXExpressionValueAssertions

@end

@implementation PXExpressionValueTests

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

#pragma mark - Array Tests

- (void)testEmptyArrayValue
{
    PXArrayValue *array = [[PXArrayValue alloc] init];

    XCTAssertTrue(array.booleanValue, @"Empty arrays should be truthy");
    XCTAssertTrue([array.stringValue isEqualToString:@"[]"], @"Expected '[]'");
    XCTAssertTrue(isnan(array.doubleValue), @"Expected NaN");
}

- (void)testArrayValue
{
    PXArrayValue *array = [[PXArrayValue alloc] init];

    [array pushValue:[[PXBooleanValue alloc] initWithBoolean:YES]];
    [array pushValue:[[PXDoubleValue alloc] initWithDouble:10.5]];
    [array pushValue:[[PXStringValue alloc] initWithString:@"hello"]];

    XCTAssertTrue(array.booleanValue, @"Empty arrays should be truthy");
    XCTAssertTrue([array.stringValue isEqualToString:@"[true, 10.5, 'hello']"], @"Expected \"[true, 10.5, 'hello']\"");
    XCTAssertTrue(isnan(array.doubleValue), @"Expected NaN");
}

- (void)testArrayEveryAllTrue
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"[2, 4, 6, 8, 10].every(func(a) { a < 11 })";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertBooleanValue:[env popValue] expected:YES];
}

- (void)testArrayEverySomeTrue
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"[2, 4, 6, 8, 10].every(func(a) { a < 7 })";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertBooleanValue:[env popValue] expected:NO];
}

- (void)testArrayEveryAllFalse
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"[2, 4, 6, 8, 10].every(func(a) { a < 2 })";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertBooleanValue:[env popValue] expected:NO];
}

- (void)testArrayFilter
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"[10, 2, 8, 4, 12, 6].filter(func(a) { a < 7 })";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertArrayValue:[env popValue] expected:@[ @2, @4, @6 ]];
}

- (void)testArrayForEach
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"[1, 2, 3].forEach(func(a) { a })";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertDoubleValue:[env popValue] expected:3.0];
    [self assertDoubleValue:[env popValue] expected:2.0];
    [self assertDoubleValue:[env popValue] expected:1.0];
}

- (void)testArrayJoin
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"['abc','def','ghi'].join('; ')";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertStringValue:[env popValue] expected:@"abc; def; ghi"];
}

- (void)testArrayJoinOneElement
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"['abc'].join('; ')";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertStringValue:[env popValue] expected:@"abc"];
}

- (void)testArrayJoinMissingDelimiter
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"['abc','def','ghi'].join()";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertStringValue:[env popValue] expected:@"abcdefghi"];
}

- (void)testArrayMap
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"[1, 2, 3].map(square)";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    // setup scope
    PXScope *scope = [[PXScope alloc] init];
    [scope setValue:[[PXSquareFunction alloc] init] forSymbolName:@"square"];

    // execute expression
    [env pushScope:scope];
    [env executeUnit:unit];
    [env popScope];

    id<PXExpressionValue> result = [env popValue];

    [self assertArrayValue:result expected:@[ @1, @4, @9 ]];
}

- (void)testArrayPop
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"[1, 2, 3].pop()";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertDoubleValue:[env popValue] expected:3.0];
}

- (void)testArrayPush
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"sym ary = [1, 2, 3]; ary.push(4); ary";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertArrayValue:[env popValue] expected:@[ @1, @2, @3, @4 ]];
}

- (void)testArrayReduce
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"[1, 2, 3].reduce(func(a, b) { a + b }, 0)";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    id<PXExpressionValue> result = [env popValue];

    [self assertDoubleValue:result expected:6.0];
}

- (void)testArrayReverse
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"sym ary = [1, 2, 3]; ary.reverse(); ary";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertArrayValue:[env popValue] expected:@[ @3, @2, @1 ]];
}

- (void)testArrayShift
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"[1, 2, 3].shift()";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertDoubleValue:[env popValue] expected:1.0];
}

- (void)testArrayUnShift
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"sym ary = [1, 2, 3]; ary.unshift(0); ary";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertArrayValue:[env popValue] expected:@[ @0, @1, @2, @3 ]];
}

- (void)testArraySomeAllTrue
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"[2, 4, 6, 8, 10].some(func(a) { a < 11 })";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertBooleanValue:[env popValue] expected:YES];
}

- (void)testArraySomeSomeTrue
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"[2, 4, 6, 8, 10].some(func(a) { a < 7 })";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertBooleanValue:[env popValue] expected:YES];
}

- (void)testArraySomeAllFalse
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"[2, 4, 6, 8, 10].some(func(a) { a < 2 })";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertBooleanValue:[env popValue] expected:NO];
}

- (void)testArrayLength
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"[1, 2, 3].length()";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertDoubleValue:[env popValue] expected:3.0];
}

#pragma mark - Object Tests

- (void)testEmptyObjectValue
{
    PXObjectValue *object = [[PXObjectValue alloc] init];

    XCTAssertTrue(object.booleanValue, @"Empty objects should be truthy");
    XCTAssertTrue([object.stringValue isEqualToString:@"{}"], @"Expected '{}'");
    XCTAssertTrue(isnan(object.doubleValue), @"Expected NaN");
}

- (void)testObjectValue
{
    PXObjectValue *object = [[PXObjectValue alloc] init];
    NSString *expectedString = [@[
        @"{",
        @"  'boolean': true,",
        @"  'double': 10.5,",
        @"  'string': 'hello'",
        @"}"
    ] componentsJoinedByString:@"\n"];

    [object setValue:[[PXBooleanValue alloc] initWithBoolean:YES] forPropertyName:@"boolean"];
    [object setValue:[[PXDoubleValue alloc] initWithDouble:10.5] forPropertyName:@"double"];
    [object setValue:[[PXStringValue alloc] initWithString:@"hello"] forPropertyName:@"string"];

    XCTAssertTrue(object.booleanValue, @"Objects should be truthy");
    XCTAssertTrue([object.stringValue isEqualToString:expectedString], @"Expected \"%@\"", expectedString);
    XCTAssertTrue(isnan(object.doubleValue), @"Expected NaN");
}

- (void)testObjectValueReversed
{
    PXObjectValue *object = [[PXObjectValue alloc] init];
    NSString *expectedString = [@[
        @"{",
        @"  'string': 'hello',",
        @"  'double': 10.5,",
        @"  'boolean': true",
        @"}"
    ] componentsJoinedByString:@"\n"];

    [object setValue:[[PXBooleanValue alloc] initWithBoolean:YES] forPropertyName:@"boolean"];
    [object setValue:[[PXDoubleValue alloc] initWithDouble:10.5] forPropertyName:@"double"];
    [object setValue:[[PXStringValue alloc] initWithString:@"hello"] forPropertyName:@"string"];
    
    [object reverse];
    
    XCTAssertTrue(object.booleanValue, @"Objects should be truthy");
    XCTAssertTrue([object.stringValue isEqualToString:expectedString], @"Expected \"%@\"", expectedString);
    XCTAssertTrue(isnan(object.doubleValue), @"Expected NaN");
}

- (void)testObjectConcat
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"sym obj = { a:2, b:4, c:6 }; obj.concat({ d:8, e:10, f:12 }); obj";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    id<PXExpressionValue> result = [env popValue];

    NSString *resultString = result.description;
    NSString *expected = @"{'a': 2, 'b': 4, 'c': 6, 'd': 8, 'e': 10, 'f': 12}";

    XCTAssertTrue([expected isEqualToString:resultString], @"Expected %@ but found %@", expected, resultString);
}

- (void)testObjectForEach
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"sym ary = []; { a:2, b:4, c:6 }.forEach(func(k,v) { ary.push(v) }); ary";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertArrayValue:[env popValue] expected:@[ @2, @4, @6 ]];
}

- (void)testObjectKeys
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"{ a:2, b:4, c:6 }.keys()";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertArrayValue:[env popValue] expectedStrings:@[ @"a", @"b", @"c" ]];
}

- (void)testObjectLength
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"{ a:1, b:2, c:3 }.length()";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertDoubleValue:[env popValue] expected:3.0];
}

- (void)testObjectPush
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"sym obj = { a:2, b:4, c:6 }; obj.push('d', 8); obj";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    id<PXExpressionValue> result = [env popValue];

    NSString *resultString = result.description;
    NSString *expected = @"{'a': 2, 'b': 4, 'c': 6, 'd': 8}";

    XCTAssertTrue([expected isEqualToString:resultString], @"Expected %@ but found %@", expected, resultString);
}

- (void)testObjectReverse
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"sym obj = { a:2, b:4, c:6 }; obj.reverse(); obj";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    id<PXExpressionValue> result = [env popValue];

    XCTAssertTrue(result.valueType == PX_VALUE_TYPE_OBJECT, @"Expected an object return value");

    PXObjectValue *object = (PXObjectValue *)result;
    NSArray *names = object.propertyNames;

    XCTAssertTrue([names[0] isEqualToString:@"c"], @"Expected first property to be 'c', but was %@", names[0]);
    XCTAssertTrue([names[1] isEqualToString:@"b"], @"Expected first property to be 'b', but was %@", names[1]);
    XCTAssertTrue([names[2] isEqualToString:@"a"], @"Expected first property to be 'a', but was %@", names[2]);
}

- (void)testObjectUnshift
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"sym obj = { b:4, c:6 }; obj.unshift('a', 2); obj";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    id<PXExpressionValue> result = [env popValue];

    NSString *resultString = result.description;
    NSString *expected = @"{'a': 2, 'b': 4, 'c': 6}";

    XCTAssertTrue([expected isEqualToString:resultString], @"Expected %@ but found %@", expected, resultString);
}

- (void)testObjectValues
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"{ a:2, b:4, c:6 }.values()";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertArrayValue:[env popValue] expected:@[ @2, @4, @6 ]];
}

#pragma mark - Primitive Types Tests

- (void)testBooleanValue
{
    PXBooleanValue *boolean = [[PXBooleanValue alloc] initWithBoolean:YES];

    XCTAssertTrue(boolean.booleanValue, @"Expected true");
    XCTAssertTrue([boolean.stringValue isEqualToString:@"true"], @"Expected 'true'");
    XCTAssertTrue(boolean.doubleValue == 1.0, @"Expected 1.0");
}

- (void)testDoubleValue
{
    PXDoubleValue *number = [[PXDoubleValue alloc] initWithDouble:10.5];

    XCTAssertTrue(number.booleanValue, @"Expected true");
    XCTAssertTrue([number.stringValue isEqualToString:@"10.5"], @"Expected '10.5'");
    XCTAssertTrue(number.doubleValue == 10.5, @"Expected 10.5");
}

- (void)testZero
{
    PXDoubleValue *number = [[PXDoubleValue alloc] initWithDouble:0.0];

    XCTAssertTrue(number.booleanValue == NO, @"Expected false");
    XCTAssertTrue([number.stringValue isEqualToString:@"0"], @"Expected '0'");
    XCTAssertTrue(number.doubleValue == 0.0, @"Expected 0");
}

- (void)testMark
{
    PXMarkValue *mark = [PXMarkValue mark];

    XCTAssertTrue(mark.booleanValue, @"Expected true");
    XCTAssertTrue([mark.stringValue isEqualToString:@"mark"], @"Expected 'mark'");
    XCTAssertTrue(isnan(mark.doubleValue), @"Expected NaN");
}

#pragma mark - String Tests

- (void)testEmptyString
{
    PXStringValue *string = [[PXStringValue alloc] initWithString:@""];

    XCTAssertTrue(string.booleanValue == false, @"Expected false");
    XCTAssertTrue([string.stringValue isEqualToString:@""], @"Expected an empty string");
    XCTAssertTrue([string.description isEqualToString:@"''"], @"Expected ''");
    XCTAssertTrue(string.doubleValue == 0.0, @"Expected 0");
}

- (void)testString
{
    PXStringValue *string = [[PXStringValue alloc] initWithString:@"10.5"];

    XCTAssertTrue(string.booleanValue, @"Expected true");
    XCTAssertTrue([string.stringValue isEqualToString:@"10.5"], @"Expected '10.5'");
    XCTAssertTrue([string.description isEqualToString:@"'10.5'"], @"Expected '10.5'");
    XCTAssertTrue(string.doubleValue == 10.5, @"Expected 10.5");
}

- (void)testString2
{
    PXStringValue *string = [[PXStringValue alloc] initWithString:@"hello"];

    XCTAssertTrue(string.booleanValue, @"Expected true");
    XCTAssertTrue([string.stringValue isEqualToString:@"hello"], @"Expected 'hello'");
    XCTAssertTrue([string.description isEqualToString:@"'hello'"], @"Expected 'hello'");
    XCTAssertTrue(string.doubleValue == 0.0, @"Expected 0.0");
}

- (void)testStringLength
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"'hello'.length()";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertDoubleValue:[env popValue] expected:5.0];
}

- (void)testStringSubstring
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"'hello'.substring(1, 3)";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertStringValue:[env popValue] expected:@"ell"];
}

- (void)testStringIndex
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    NSString *source = @"'hello'[1]";
    PXExpressionUnit *unit = [parser compileString:source];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    [env executeUnit:unit];

    [self assertStringValue:[env popValue] expected:@"e"];
}

@end
