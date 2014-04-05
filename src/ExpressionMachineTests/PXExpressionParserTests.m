//
//  PXExpressionParserTests.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/26/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionValueAssertions.h"
#import "PXExpressionParser.h"
#import "PXExpressionNodeUtils.h"
#import "PXExpressionEnvironment.h"

@interface PXExpressionParserTests : PXExpressionValueAssertions

@end

@implementation PXExpressionParserTests

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

- (PXExpressionUnit *)compileString:(NSString *)source
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];

    return [parser compileString:source];
}

- (void)assertResult:(NSString *)expected fromSource:(NSString *)source
{
    PXExpressionUnit *unit = [self compileString:source];
    NSString *result = [PXExpressionNodeUtils descriptionForNode:unit.ast];

    XCTAssertTrue([expected isEqualToString:result], @"Expected:\n%@\nBut got:\n%@", expected, result);
}

- (id<PXExpressionValue>)valueFromExecutingString:(NSString *)source
{
    // compile
    PXExpressionUnit *unit = [self compileString:source];

    // execute
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
    [env executeUnit:unit];

    // return result
    return [env popValue];
}

#pragma mark - Primitive Tests

- (void)testIdentifier
{
    NSString *expected = @"abc";

    [self assertResult:expected fromSource:@"abc"];
}

- (void)testNumber
{
    NSString *expected = @"10.5";

    [self assertResult:expected fromSource:@"10.5"];
}

- (void)testTrue
{
    NSString *expected = @"true";

    [self assertResult:expected fromSource:@"true"];
}

- (void)testFalse
{
    NSString *expected = @"false";

    [self assertResult:expected fromSource:@"false"];
}

#pragma mark - Relation Tests

- (void)testEquals
{
    NSString *expected = [@[
        @"==",
        @"  abc",
        @"  10.5"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"abc == 10.5"];
}

- (void)testEquals2
{
    NSString *expected = [@[
        @"==",
        @"  <",
        @"    abc",
        @"    10.5",
        @"  >",
        @"    def",
        @"    10.5"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"abc < 10.5 == def > 10.5"];
}

- (void)testLessThan
{
    NSString *expected = [@[
        @"<",
        @"  abc",
        @"  10.5"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"abc < 10.5"];
}

- (void)testLessThanOrEqual
{
    NSString *expected = [@[
        @"<=",
        @"  abc",
        @"  10.5"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"abc <= 10.5"];
}

- (void)testGreaterThan
{
    NSString *expected = [@[
        @">",
        @"  abc",
        @"  10.5"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"abc > 10.5"];
}

- (void)testGreaterThanOrEqual
{
    NSString *expected = [@[
        @">=",
        @"  abc",
        @"  10.5"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"abc >= 10.5"];
}

#pragma mark - Mathematical operator tests

- (void)testAddition
{
    NSString *expected = [@[
        @"+",
        @"  abc",
        @"  10.5"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"abc + 10.5"];
}

- (void)testAddition2
{
    NSString *expected = [@[
        @"+",
        @"  +",
        @"    abc",
        @"    *",
        @"      10.5",
        @"      def",
        @"  5.25"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"abc + 10.5 * def + 5.25"];
}

- (void)testSubtraction
{
    NSString *expected = [@[
        @"-",
        @"  abc",
        @"  10.5"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"abc - 10.5"];
}

- (void)testMultiplication
{
    NSString *expected = [@[
        @"*",
        @"  abc",
        @"  10.5"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"abc * 10.5"];
}

- (void)testDivision
{
    NSString *expected = [@[
        @"/",
        @"  abc",
        @"  10.5"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"abc / 10.5"];
}

- (void)testNegation
{
    NSString *expected = [@[
        @"-10.5"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"-10.5"];
}

- (void)testNegation2
{
    NSString *expected = [@[
        @"*",
        @"  -8",
        @"  t"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"-8 * t"];
}

- (void)testNegation3
{
    NSString *expected = [@[
        @"-",
        @"  +",
        @"    5",
        @"    3"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"-(5 + 3)"];
}

- (void)testSubtractionWithNegation
{
    NSString *expected = [@[
        @"-",
        @"  10.5",
        @"  -8.5"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"10.5 - -8.5"];
}

#pragma mark - Function tests

- (void)testEmptyFunctionCall
{
    NSString *expected = @"'run'()";

    [self assertResult:expected fromSource:@"run()"];
}

- (void)testFunctionCall
{
    NSString *expected = [@[
        @"'abs'()",
        @"  10.5"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"abs(10.5)"];
}

- (void)testFunctionCall2
{
    NSString *expected = [@[
        @"'decide'()",
        @"  +",
        @"    abc",
        @"    10.5",
        @"  <",
        @"    def",
        @"    5.25",
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"decide(abc + 10.5, def < 5.25)"];
}

#pragma mark - Scope Tests

- (void)testSetSymbol
{
    NSString *expected = [@[
        @"sym",
        @"  def"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"sym def"];
}

- (void)testSetSymbolImplementation
{
    NSString *source = @"sym hello";

    // compile
    PXExpressionUnit *unit = [self compileString:source];

    // execute
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
    [env executeUnit:unit];

    id<PXExpressionScope> scope = unit.scope;
    id<PXExpressionValue> value = [scope valueForSymbolName:@"hello"];

    XCTAssertNotNil(value, @"expected value to be defined");
    XCTAssertTrue(value.valueType == PX_VALUE_TYPE_UNDEFINED, @"expected 'hello' to be undefined");
}

- (void)testSetSymbolWithValue
{
    NSString *expected = [@[
        @"sym",
        @"  def",
        @"  10"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"sym def = 10"];
}

- (void)testSetSymbolWithValueImplementation
{
    NSString *source = @"sym hello = 10";

    // compile
    PXExpressionUnit *unit = [self compileString:source];

    // execute
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
    [env executeUnit:unit];

    id<PXExpressionScope> scope = unit.scope;

    [self assertDoubleValue:[scope valueForSymbolName:@"hello"] expected:10.0];
}

#pragma mark - Object Tests

- (void)testCreateObject
{
    NSString *expected = [@[
        @"{}",
        @"  'boolean'",
        @"  true",
        @"  'double'",
        @"  1"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"{ boolean: true, 'double': 1.0 }"];
}

- (void)testGetProperty
{
    NSString *expected = [@[
        @".",
        @"  abc",
        @"  'def'"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"abc.def"];
}

- (void)testGetProperty2
{
    NSString *expected = [@[
        @".",
        @"  abc",
        @"  def"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"abc{def}"];
}

- (void)testInvokeAndGetProperty
{
    NSString *expected = [@[
        @".",
        @"  'abc'()",
        @"  'def'"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"abc().def"];
}

#pragma mark - Array Tests

- (void)testCreateArray
{
    NSString *expected = [@[
        @"[]",
        @"  0",
        @"  true"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"[0, true]"];
}

- (void)testGetElement
{
    NSString *expected = [@[
        @"getElement",
        @"  abc",
        @"  3"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"abc[3]"];
}

#pragma mark - Jelly Expressions

- (void)testHalfWayCondition
{
    NSString *expected = [@[
        @">",
        @"  dy",
        @"  threshold"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"dy > threshold"];
}

- (void)testBehindT
{
    NSString *expected = [@[
        @"'abs'()",
        @"  /",
        @"    dy",
        @"    max_distance"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"abs(dy / max_distance)"];
}

- (void)testMainT
{
    NSString *expected = [@[
        @"/",
        @"  dy",
        @"  max_distance"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"dy / max_distance"];
}

- (void)testEndCondition
{
    NSString *expected = [@[
        @"<=",
        @"  dy",
        @"  75"
    ] componentsJoinedByString:@"\n"];

    [self assertResult:expected fromSource:@"dy <= 75"];
}

#pragma mark - Function tests

- (void)testFunction
{
    NSString *source = [@[
        @"func lerp(start, end, t=0.5) {",
        @"  start + (end - start) * t",
        @"}",
        @"",
        @"lerp(0, 100)"
    ] componentsJoinedByString:@"\n"];

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertDoubleValue:result expected:50.0];
}

- (void)testFunctionInObject
{
    NSString *source = [@[
        @"sym obj = {",
        @"  count: func() {",
        @"    5",
        @"  }",
        @"}",
        @"",
        @"obj.count()"
    ] componentsJoinedByString:@"\n"];

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertDoubleValue:result expected:5.0];
}

- (void)testFunctionInObjectWithThisReference
{
    NSString *source = [@[
        @"sym obj = {",
        @"  number: 5,",
        @"  count: func() {",
        @"    this.number + 5",
        @"  }",
        @"}",
        @"",
        @"obj.count()"
    ] componentsJoinedByString:@"\n"];

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertDoubleValue:result expected:10.0];
}

- (void)testThisGlobalFunction
{
    NSString *source = @"this.min(5, 10)";

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertDoubleValue:result expected:5.0];
}

- (void)testFunctionInNestedObject
{
    NSString *source = [@[
        @"sym easing = {",
        @"  in: {",
        @"    linear: func() {",
        @"      5",
        @"    }",
        @"  }",
        @"}",
        @"",
        @"easing.in.linear()"
    ] componentsJoinedByString:@"\n"];

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertDoubleValue:result expected:5.0];
}

#pragma mark - Flow tests

- (void)testIf
{
    NSString *source = [@[
        @"if (4 < 5) {",
        @"  1",
        @"}"
    ] componentsJoinedByString:@"\n"];

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertDoubleValue:result expected:1.0];
}

- (void)testIfElse
{
    NSString *source = [@[
        @"if (5 < 4) {",
        @"  0",
        @"}",
        @"else {",
        @"  1",
        @"}"
    ] componentsJoinedByString:@"\n"];

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertDoubleValue:result expected:1.0];
}

- (void)testElsif
{
    NSString *source = [@[
        @"if (5 < 4) {",
        @"  0",
        @"}",
        @"elsif (5 < 3) {",
        @"  1",
        @"}",
        @"else {",
        @"  2",
        @"}"
    ] componentsJoinedByString:@"\n"];

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertDoubleValue:result expected:2.0];
}

- (void)testConditional
{
    NSString *source = @"(5 < 4) ? 0 : 1";

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertDoubleValue:result expected:1.0];
}

#pragma mark - Byte code generation tests that don't belong here

- (void)testSnapshot
{
    NSString *source = [ @[
        @"func snapshot() {",
        @"sym obj = arguments.shift();",
        @"sym keys = (arguments.length() == 0) ? obj.keys() : arguments;",
        @"sym result = {};",
        @"",
        @"keys.forEach(func(key) {",
        @"    result.push(key, obj{key});",
        @"});",
        @"",
        @"result;",
        @"}",
        @"snapshot({a:1,b:2,c:3}, 'a', 'c');"
    ] componentsJoinedByString:@"\n"];
    NSString *expected = @"{'a': 1, 'c': 3}";

    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    XCTAssertTrue([expected isEqualToString:result.description], @"Exected '%@' but found '%@'", expected, result.description);
}

@end
