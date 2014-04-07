//
//  PXExpressionAssemblerTests.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/28/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionValueAssertions.h"
#import "PXExpressionEnvironment.h"
#import "PXExpressionAssembler.h"
#import "PXExpressionUnit.h"
#import "PXExpressionByteCode.h"

@interface PXExpressionAssemblerTests : PXExpressionValueAssertions

@end

@implementation PXExpressionAssemblerTests

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

- (PXExpressionUnit *)assembleString:(NSString *)source
{
    PXExpressionAssembler *parser = [[PXExpressionAssembler alloc] init];

    return [parser assembleString:source];
}

- (id<PXExpressionValue>)valueFromExecutingString:(NSString *)source
{
    // compile
    PXExpressionUnit *unit = [self assembleString:source];

    // execute
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
    [env executeUnit:unit];

    // return result
    return [env popValue];
}

- (void)assertSource:(NSString *)source
{
    [self assertSource:source withResult:source];
}

- (void)assertSource:(NSString *)source withResult:(NSString *)result
{
    PXExpressionUnit *unit = [self assembleString:source];
    PXExpressionByteCode *code = unit.byteCode;

    XCTAssertTrue([result isEqualToString:code.description], @"Expected\n%@\nbut found\n%@", result, code.description);
}

#pragma mark - Stack Tests

- (void)testPushTrue
{
    [self assertSource:@"push(true)"];
}

- (void)testPushTrueShortcut
{
    [self assertSource:@"true" withResult:@"push(true)"];
}

- (void)testPushFalse
{
    [self assertSource:@"push(false)"];
}

- (void)testPushFalseShortcut
{
    [self assertSource:@"false" withResult:@"push(false)"];
}

- (void)testPushString
{
    [self assertSource:@"push('hello')"];
}

- (void)testPushStringShortcut
{
    [self assertSource:@"'hello'" withResult:@"push('hello')"];
}

- (void)testPushDouble
{
    [self assertSource:@"push(10.5)"];
}

- (void)testPushDoubleShortcut
{
    [self assertSource:@"10.5" withResult:@"push(10.5)"];
}

- (void)testPushMark
{
    [self assertSource:@"push(mark)"];
}

- (void)testPushMarkShortcut
{
    [self assertSource:@"mark" withResult:@"push(mark)"];
}

- (void)testPushMarkShortcut2
{
    [self assertSource:@"[" withResult:@"push(mark)"];
}

- (void)testDup
{
    [self assertSource:@"dup"];
}

- (void)testSwap
{
    [self assertSource:@"swap"];
}

#pragma mark - Function Tests

- (void)testInvoke
{
    [self assertSource:@"invoke"];
}

- (void)testInvokeShortcut
{
    [self assertSource:@">" withResult:@"invoke"];
}

- (void)testInvokeWithCount
{
    [self assertSource:@"invoke(2)"];
}

- (void)testInvokeWithCountShortcut
{
    [self assertSource:@">(2)" withResult:@"invoke(2)"];
}

- (void)testInvokeName
{
    [self assertSource:@"invoke('hello')"];
}

- (void)testInvokeNameWithCount
{
    [self assertSource:@"invoke('hello', 2)"];
}

- (void)testInvokeNameShortcut
{
    [self assertSource:@">hello" withResult:@"invoke('hello')"];
}

- (void)testInvokeNameShortcutWithCount
{
    [self assertSource:@">hello(2)" withResult:@"invoke('hello', 2)"];
}

- (void)testInvokeNameShortcut2
{
    [self assertSource:@">'hello'" withResult:@"invoke('hello')"];
}

- (void)testInvokeNameShortcutWithCount2
{
    [self assertSource:@">'hello'(2)" withResult:@"invoke('hello', 2)"];
}

#pragma mark - Scope Tests

- (void)testGetSymbol
{
    [self assertSource:@"getSymbol"];
}

- (void)testGetSymbolName
{
    [self assertSource:@"getSymbol('hello')"];
}

- (void)testGetSymbolNames
{
    [self assertSource:@"getSymbol('abc')\ngetSymbol('def')"];
}

- (void)testGetSymbolNameShortcut
{
    [self assertSource:@"^hello" withResult:@"getSymbol('hello')"];
}

- (void)testGetSymbolNameShortcut2
{
    [self assertSource:@"^'hello'" withResult:@"getSymbol('hello')"];
}

- (void)testSetSymbol
{
    [self assertSource:@"setSymbol"];
}

- (void)testSetSymbolName
{
    [self assertSource:@"setSymbol('hello')"];
}

- (void)testSetSymbolShortcut
{
    [self assertSource:@"^=" withResult:@"setSymbol"];
}

- (void)testSetSymbolNameShortcut
{
    [self assertSource:@"^=hello" withResult:@"setSymbol('hello')"];
}

- (void)testSetSymbolImplementation
{
    NSString *source = @"'hello' 10 setSymbol";

    // compile
    PXExpressionUnit *unit = [self assembleString:source];

    // execute
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
    [env executeUnit:unit];

    id<PXExpressionScope> scope = unit.scope;

    [self assertDoubleValue:[scope valueForSymbolName:@"hello"] expected:10.0];
}

- (void)testSetSymbolNameImplementation
{
    NSString *source = @"10 setSymbol(hello)";

    // compile
    PXExpressionUnit *unit = [self assembleString:source];

    // execute
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
    [env executeUnit:unit];

    id<PXExpressionScope> scope = unit.scope;

    [self assertDoubleValue:[scope valueForSymbolName:@"hello"] expected:10.0];
}

- (void)testSetSymbolShortcutImplementation
{
    NSString *source = @"'hello' 10 ^=";

    // compile
    PXExpressionUnit *unit = [self assembleString:source];

    // execute
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
    [env executeUnit:unit];

    id<PXExpressionScope> scope = unit.scope;

    [self assertDoubleValue:[scope valueForSymbolName:@"hello"] expected:10.0];
}

- (void)testSetSymbolNameShortcutImplementation
{
    NSString *source = @"10 ^=hello";

    // compile
    PXExpressionUnit *unit = [self assembleString:source];

    // execute
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
    [env executeUnit:unit];

    id<PXExpressionScope> scope = unit.scope;

    [self assertDoubleValue:[scope valueForSymbolName:@"hello"] expected:10.0];
}

#pragma mark - Array Tests

- (void)testCreateArray
{
    [self assertSource:@"createArray"];
}

- (void)testCreateArrayWithCount
{
    [self assertSource:@"createArray(2)"];
}

- (void)testCreateArrayShortcut
{
    [self assertSource:@"]" withResult:@"createArray"];
}

- (void)testCreateArrayShortcutWithCount
{
    [self assertSource:@"](2)" withResult:@"createArray(2)"];
}

- (void)testCreateArrayImplementation
{
    NSString *source = @"[ 0 1 2 3 createArray";

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertArrayValue:result expected:@[@0.0, @1.0, @2.0, @3.0]];
}

- (void)testCreateArrayWithCountImplementation
{
    NSString *source = @"0 1 2 3 createArray(4)";

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertArrayValue:result expected:@[@0.0, @1.0, @2.0, @3.0]];
}

- (void)testCreateArrayShortcutImplementation
{
    NSString *source = @"[ 0 1 2 3 ]";

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertArrayValue:result expected:@[@0.0, @1.0, @2.0, @3.0]];
}

- (void)testCreateArrayShortcutWithCountImplementation
{
    NSString *source = @"0 1 2 3 ](4)";

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertArrayValue:result expected:@[@0.0, @1.0, @2.0, @3.0]];
}

- (void)testGetElement
{
    [self assertSource:@"getElement"];
}

- (void)testGetElementImplementation
{
    NSString *source = @"[ 0 1 2 3 ] 3 getElement";

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertDoubleValue:result expected:3.0];
}

- (void)testGetElementWithIndex
{
    [self assertSource:@"getElement(0)"];
}

- (void)testGetElementWithIndexImplementation
{
    NSString *source = @"[ 0 1 2 3 ] getElement(3)";

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertDoubleValue:result expected:3.0];
}

#pragma mark - Object Tests

- (void)testCreateObject
{
    [self assertSource:@"createObject"];
}

- (void)testCreateObjectWithCount
{
    [self assertSource:@"createObject(3)"];
}

- (void)testCreateObjectShortcut
{
    [self assertSource:@"]}" withResult:@"createObject"];
}

- (void)testCreateObjectShortcutWithCount
{
    [self assertSource:@"]}(3)" withResult:@"createObject(3)"];
}

- (void)testCreateObjectImplementation
{
    NSString *source = @"{[ 'abc' 0 'def' 1 'ghi' 2 'jkl' 3 createObject";

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertObjectValue:result expected:@{@"abc": @0.0, @"def": @1.0, @"ghi": @2.0, @"jkl": @3.0}];
}

- (void)testCreateObjectWithCountImplementation
{
    NSString *source = @"'abc' 0 'def' 1 'ghi' 2 'jkl' 3 createObject(4)";

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertObjectValue:result expected:@{@"abc": @0.0, @"def": @1.0, @"ghi": @2.0, @"jkl": @3.0}];
}

- (void)testCreateObjectShortcutImplementation
{
    NSString *source = @"{[ 'abc' 0 'def' 1 'ghi' 2 'jkl' 3 ]}";

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertObjectValue:result expected:@{@"abc": @0.0, @"def": @1.0, @"ghi": @2.0, @"jkl": @3.0}];
}

- (void)testCreateObjectShortcutWithCountImplementation
{
    NSString *source = @"'abc' 0 'def' 1 'ghi' 2 'jkl' 3 ]}(4)";

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertObjectValue:result expected:@{@"abc": @0.0, @"def": @1.0, @"ghi": @2.0, @"jkl": @3.0}];
}

- (void)testGetProperty
{
    [self assertSource:@"getProperty"];
}

- (void)testGetPropertyName
{
    [self assertSource:@"getProperty('hello')"];
}

- (void)testGetPropertyNames
{
    [self assertSource:@"getProperty('abc')\ngetProperty('def')"];
}

- (void)testGetPropertyNameShortcut
{
    [self assertSource:@".hello" withResult:@"getProperty('hello')"];
}

- (void)testGetPropertyNameShortcut2
{
    [self assertSource:@".'hello'" withResult:@"getProperty('hello')"];
}

- (void)testGetPropertyImplementation
{
    NSString *source = @"{[ 'abc' 0 'def' 1 'ghi' 2 'jkl' 3 ]} 'def' getProperty";

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertDoubleValue:result expected:1.0];
}

- (void)testGetPropertyNameImplementation
{
    NSString *source = @"{[ 'abc' 0 'def' 1 'ghi' 2 'jkl' 3 ]} getProperty(def)";

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertDoubleValue:result expected:1.0];
}

- (void)testGetPropertyNameShortcutImplementation
{
    NSString *source = @"{[ 'abc' 0 'def' 1 'ghi' 2 'jkl' 3 ]} .def";

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertDoubleValue:result expected:1.0];
}

#pragma mark - Math Tests

- (void)testAdd
{
    [self assertSource:@"add"];
}

- (void)testSub
{
    [self assertSource:@"sub"];
}

- (void)testMul
{
    [self assertSource:@"mul"];
}

- (void)testDiv
{
    [self assertSource:@"div"];
}

#pragma mark - Boolean Operator Tests

- (void)testAnd
{
    [self assertSource:@"and"];
}

- (void)testOr
{
    [self assertSource:@"or"];
}

- (void)testNot
{
    [self assertSource:@"not"];
}

#pragma mark - Comparison Operator Tests

- (void)testLt
{
    [self assertSource:@"lt"];
}

- (void)testLe
{
    [self assertSource:@"le"];
}

- (void)testEq
{
    [self assertSource:@"eq"];
}

- (void)testNe
{
    [self assertSource:@"ne"];
}

- (void)testGe
{
    [self assertSource:@"ge"];
}

- (void)testGt
{
    [self assertSource:@"gt"];
}

#pragma mark - Jelly Expressions

- (void)testHalfWayCondition
{
    // dy > threshold
    NSString *source = [@[
        @"push(mark)",
        @"getSymbol('dy')",
        @"getSymbol('threshold')",
        @"invoke('>')"
    ] componentsJoinedByString:@"\n"];

    [self assertSource:source];
}

- (void)testHalfWayCondition2
{
    NSString *source = [@[
        @"getSymbol('dy')",
        @"getSymbol('threshold')",
        @"invoke('>', 2)"
    ] componentsJoinedByString:@"\n"];

    // dy > threshold
    [self assertSource:source];
}

- (void)testHalfWayConditionShortcuts
{
    // dy > threshold
    NSString *expected = [@[
       @"getSymbol('dy')",
       @"getSymbol('threshold')",
       @"gt"
    ] componentsJoinedByString:@"\n"];

    [self assertSource:@"^dy ^threshold gt" withResult:expected];
}

- (void)testBehindT
{
    NSString *source = [ @[
        @"push(mark)",
        @"push(mark)",
        @"getSymbol('dy')",
        @"getSymbol('max_distance')",
        @"invoke('/')",
        @"invoke('abs')"
    ] componentsJoinedByString:@"\n"];

    // abs(dy / max_distance)
    [self assertSource:source];
}

- (void)testBehindT2
{
    // abs(dy / max_distance)
    NSString *source = [@[
        @"getSymbol('dy')",
        @"getSymbol('max_distance')",
        @"invoke('/', 2)",
        @"invoke('abs', 1)"
    ] componentsJoinedByString:@"\n"];

    [self assertSource:source];
}

- (void)testBehindTShortcuts
{
    // abs(dy / max_distance)
    NSString *expected = [@[
        @"push(mark)",
        @"push(mark)",
        @"getSymbol('dy')",
        @"getSymbol('max_distance')",
        @"invoke('/')",
        @"invoke('abs')"
    ] componentsJoinedByString:@"\n"];

    [self assertSource:@"[ [ ^dy ^max_distance >'/' >abs" withResult:expected];
}

- (void)testBehindTShortcuts2
{
    // abs(dy / max_distance)
    NSString *expected = [@[
        @"getSymbol('dy')",
        @"getSymbol('max_distance')",
        @"invoke('/', 2)",
        @"invoke('abs', 1)"
    ] componentsJoinedByString:@"\n"];

    [self assertSource:@"^dy ^max_distance >'/'(2) >abs(1)" withResult:expected];
}

- (void)testMainT
{
    // dy / max_distance
    NSString *source = [@[
        @"push(mark)",
        @"getSymbol('dy')",
        @"getSymbol('max_distance')",
        @"invoke('/')"
    ] componentsJoinedByString:@"\n"];

    [self assertSource:source];
}

- (void)testMainT2
{
    // dy / max_distance
    NSString *source = [@[
        @"getSymbol('dy')",
        @"getSymbol('max_distance')",
        @"invoke('/', 2)"
    ] componentsJoinedByString:@"\n"];

    [self assertSource:source];
}

- (void)testMainTShortcut
{
    // dy / max_distance
    NSString *expected = [@[
        @"push(mark)",
        @"getSymbol('dy')",
        @"getSymbol('max_distance')",
        @"invoke('/')"
    ] componentsJoinedByString:@"\n"];

    [self assertSource:@"[ ^dy ^max_distance >'/'" withResult:expected];
}

- (void)testMainTShortcut2
{
    // dy / max_distance
    NSString *expected = [@[
        @"getSymbol('dy')",
        @"getSymbol('max_distance')",
        @"invoke('/', 2)"
    ] componentsJoinedByString:@"\n"];

    [self assertSource:@"^dy ^max_distance >'/'(2)" withResult:expected];
}

- (void)testEndCondition
{
    // dy <= 75
    [self assertSource: [@[
        @"push(mark)",
        @"getSymbol('dy')",
        @"push(75)",
        @"invoke('<=')"
    ] componentsJoinedByString:@"\n"]];
}

- (void)testEndCondition2
{
    // dy <= 75
    [self assertSource: [@[
        @"getSymbol('dy')",
        @"push(75)",
        @"invoke('<=', 2)"
    ] componentsJoinedByString:@"\n"]];
}

- (void)testEndConditionShortcut
{
    // dy <= 75
    NSString *expected = [@[
        @"getSymbol('dy')",
        @"push(75)",
        @"le"
    ] componentsJoinedByString:@"\n"];

    [self assertSource:@"^dy 75 le" withResult:expected];
}

#pragma mark - Function Tests

- (void)testFunction
{
    NSString *source = [@[
        @"asmfunc lerp(start, end, t=0.5) {",
        // start + (end - start) * t
        @"  ^start ^end ^start sub",
        @"  ^t mul",
        @"  add",
        @"}",
        @"",
        @"0 100 >lerp(2)"
    ] componentsJoinedByString:@"\n"];

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertDoubleValue:result expected:50.0];
}

#pragma mark - Flow Tests

- (void)testIf
{
    NSString *source = [@[
        @"if (4 5 lt) {",
        @"  1",
        @"}"
    ] componentsJoinedByString:@"\n"];

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertDoubleValue:result expected:1.0];
}

- (void)testIf2
{
    NSString *source = [@[
        @"4 5 lt",
        @"{1}",
        @"if"
    ] componentsJoinedByString:@"\n"];

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertDoubleValue:result expected:1.0];
}

- (void)testIfElse
{
    NSString *source = [@[
        @"if (5 4 <) {",
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

- (void)testIfElse2
{
    NSString *source = [@[
        @"5 4 <",
        @"{0}",
        @"{1}",
        @"ifelse"
    ] componentsJoinedByString:@"\n"];

    // grab result
    id<PXExpressionValue> result = [self valueFromExecutingString:source];

    // make assertions
    [self assertDoubleValue:result expected:1.0];
}

@end
