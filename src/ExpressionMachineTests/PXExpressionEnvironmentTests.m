//
//  PXExpressionEnvironmentTests.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionValueAssertions.h"

#import "PXByteCodeBuilder.h"
#import "PXExpressionByteCode.h"
#import "PXExpressionEnvironment.h"
#import "PXScope.h"

#import "PXBooleanValue.h"
#import "PXBlockValue.h"
#import "PXExpressionValue.h"
#import "PXMarkValue.h"
#import "PXObjectValue.h"
#import "PXSquareFunction.h"

@interface PXExpressionEnvironmentTests : PXExpressionValueAssertions

@end

@implementation PXExpressionEnvironmentTests

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

- (id<PXExpressionValue>)valueFromExecutingBuilder:(PXByteCodeBuilder *)builder
{
    // grab byte code
    PXExpressionByteCode *code = builder.byteCode;

    // execute expression
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
    [env executeByteCode:code];

    // check result
    return [env popValue];
}

#pragma mark - stack operations

- (void)testPushBoolean
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushBooleanInstruction:YES];

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    [self assertBooleanValue:value expected:YES];
}

- (void)testPushString
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushStringInstruction:@"hello"];

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    [self assertStringValue:value expected:@"hello"];
}

- (void)testPushDouble
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushDoubleInstruction:10.5];

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    [self assertDoubleValue:value expected:10.5];
}

- (void)testPushObject
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    PXObjectValue *object = [[PXObjectValue alloc] init];
    [expr addPushObjectInstruction:object];

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    XCTAssertNotNil(value, "Expected a non-nil result");
    XCTAssertTrue(value.valueType == PX_VALUE_TYPE_OBJECT, @"Expected value to be an object");
    XCTAssertTrue(value == object, "Expected object to be the pushed object");
}

- (void)testPushMark
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushMarkInstruction];

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    XCTAssertNotNil(value, "Expected a non-nil result");
    XCTAssertTrue(value == [PXMarkValue mark], "Expected object to be a marker");
}

#pragma mark - built-ins

- (void)testAbsBuiltIn
{
    [self assertBuiltInFunction:@"abs"];
}

- (void)testSinBuiltIn
{
    [self assertBuiltInFunction:@"sin"];
}

- (void)testCosBuiltIn
{
    [self assertBuiltInFunction:@"cos"];
}

- (void)testPowBuiltIn
{
    [self assertBuiltInFunction:@"pow"];
}

- (void)testSqrtBuiltIn
{
    [self assertBuiltInFunction:@"sqrt"];
}

- (void)testSqrtBuiltIn2
{
    [self assertBuiltInFunction:@"√"];
}

#pragma mark - built-in functionality

- (void)assertBinaryOperator:(NSString *)op withA:(double)a b:(double)b result:(double)result
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushMarkInstruction];
    [expr addPushDoubleInstruction:a];
    [expr addPushDoubleInstruction:b];

    if ([@"+" isEqualToString:op])
    {
        [expr addAddInstruction];
    }
    else if ([@"-" isEqualToString:op])
    {
        [expr addSubtractInstruction];
    }
    else if ([@"*" isEqualToString:op])
    {
        [expr addMultiplyInstruction];
    }
    else if ([@"/" isEqualToString:op])
    {
        [expr addDivideInstruction];
    }
    else
    {
        XCTFail(@"Unsupported binary operator: %@", op);
    }

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    [self assertDoubleValue:value expected:result];
}

- (void)assertConditionOperator:(NSString *)op withA:(double)a b:(double)b result:(BOOL)result
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushMarkInstruction];
    [expr addPushDoubleInstruction:a];
    [expr addPushDoubleInstruction:b];

    if ([@"<" isEqualToString:op])
    {
        [expr addLessThanInstruction];
    }
    else if ([@"<=" isEqualToString:op])
    {
        [expr addLessThanEqualInstruction];
    }
    else if ([@"==" isEqualToString:op])
    {
        [expr addEqualInstruction];
    }
    else if ([@"!=" isEqualToString:op])
    {
        [expr addNotEqualInstruction];
    }
    else if ([@">=" isEqualToString:op])
    {
        [expr addGreaterThanEqualInstruction];
    }
    else if ([@">" isEqualToString:op])
    {
        [expr addGreaterThanInstruction];
    }
    else
    {
        XCTFail(@"Unsupported conditional operator: %@", op);
    }

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    [self assertBooleanValue:value expected:result];
}

- (void)assertLogicalOperator:(NSString *)op withA:(BOOL)a b:(BOOL)b result:(BOOL)result
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushMarkInstruction];
    [expr addPushBooleanInstruction:a];
    [expr addPushBooleanInstruction:b];

    if ([@"&&" isEqualToString:op])
    {
        [expr addAndInstruction];
    }
    else if ([@"||" isEqualToString:op])
    {
        [expr addOrInstruction];
    }
    else
    {
        XCTFail(@"Unsupported binary operator: %@", op);
    }

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    [self assertBooleanValue:value expected:result];
}

- (void)assertMathOperator:(NSString *)op withValue:(double)arg result:(double)result
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushDoubleInstruction:arg];
    [expr addInvokeFunctionInstructionWithName:op count:1];

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    [self assertDoubleValue:value expected:result];
}

- (void)testAdd
{
    [self assertBinaryOperator:@"+" withA:1.0 b:2.0 result:3.0];
}

- (void)testSubtract
{
    [self assertBinaryOperator:@"-" withA:1.0 b:2.0 result:-1.0];
}

- (void)testMultiply
{
    [self assertBinaryOperator:@"*" withA:2.0 b:3.0 result:6.0];
}

- (void)testDivide
{
    [self assertBinaryOperator:@"/" withA:10.0 b:5.0 result:2.0];
}

- (void)testLessThan
{
    [self assertConditionOperator:@"<" withA:2.0 b:3.0 result:YES];
    [self assertConditionOperator:@"<" withA:2.0 b:2.0 result:NO];
    [self assertConditionOperator:@"<" withA:3.0 b:2.0 result:NO];
}

- (void)testLessThanOrEqual
{
    [self assertConditionOperator:@"<=" withA:2.0 b:3.0 result:YES];
    [self assertConditionOperator:@"<=" withA:2.0 b:2.0 result:YES];
    [self assertConditionOperator:@"<=" withA:3.0 b:2.0 result:NO];
}

- (void)testEqual
{
    [self assertConditionOperator:@"==" withA:2.0 b:3.0 result:NO];
    [self assertConditionOperator:@"==" withA:2.0 b:2.0 result:YES];
    [self assertConditionOperator:@"==" withA:3.0 b:2.0 result:NO];
}

- (void)testNotEqual
{
    [self assertConditionOperator:@"!=" withA:2.0 b:3.0 result:YES];
    [self assertConditionOperator:@"!=" withA:2.0 b:2.0 result:NO];
    [self assertConditionOperator:@"!=" withA:3.0 b:2.0 result:YES];
}

- (void)testGreaterThanOrEqual
{
    [self assertConditionOperator:@">=" withA:2.0 b:3.0 result:NO];
    [self assertConditionOperator:@">=" withA:2.0 b:2.0 result:YES];
    [self assertConditionOperator:@">=" withA:3.0 b:2.0 result:YES];
}

- (void)testGreaterThan
{
    [self assertConditionOperator:@">" withA:2.0 b:3.0 result:NO];
    [self assertConditionOperator:@">" withA:2.0 b:2.0 result:NO];
    [self assertConditionOperator:@">" withA:3.0 b:2.0 result:YES];
}

- (void)testAbs
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushDoubleInstruction:-10.5];
    [expr addInvokeFunctionInstructionWithName:@"abs" count:1];

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    [self assertDoubleValue:value expected:10.5];
}

- (void)testMin
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushDoubleInstruction:1.5];
    [expr addPushDoubleInstruction:0.5];
    [expr addInvokeFunctionInstructionWithName:@"min" count:2];

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    [self assertDoubleValue:value expected:0.5];
}

- (void)testMax
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushDoubleInstruction:1.5];
    [expr addPushDoubleInstruction:0.5];
    [expr addInvokeFunctionInstructionWithName:@"max" count:2];

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    [self assertDoubleValue:value expected:1.5];
}

- (void)testClampNumberTooLow
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushDoubleInstruction:-1.5];
    [expr addInvokeFunctionInstructionWithName:@"clamp" count:1];

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    [self assertDoubleValue:value expected:0.0];
}

- (void)testClampNumberTooHigh
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushDoubleInstruction:1.5];
    [expr addInvokeFunctionInstructionWithName:@"clamp" count:1];

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    [self assertDoubleValue:value expected:1.0];
}

- (void)testNormalize
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushDoubleInstruction:75];
    [expr addPushDoubleInstruction:0];
    [expr addPushDoubleInstruction:100];
    [expr addInvokeFunctionInstructionWithName:@"normalize" count:3];

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    [self assertDoubleValue:value expected:0.75];
}

- (void)testGetProperty
{
    // build object
    PXObjectValue *object = [[PXObjectValue alloc] init];
    [object setBooleanValue:YES forPropertyName:@"boolean"];

    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushObjectInstruction:object];
    [expr addGetPropertyInstructionWithName:@"boolean"];

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    [self assertBooleanValue:value expected:YES];
}

- (void)testGetElement
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushBooleanInstruction:YES];
    [expr addCreateArrayInstructionWithCount:1];
    [expr addGetElementInstructionWithIndex:0];

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    [self assertBooleanValue:value expected:YES];
}

- (void)testLogicalNot
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushMarkInstruction];
    [expr addPushBooleanInstruction:NO];
    [expr addNotInstruction];

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    [self assertBooleanValue:value expected:YES];
}

- (void)testLogicalAnd
{
    [self assertLogicalOperator:@"&&" withA:NO b:NO result:NO];
    [self assertLogicalOperator:@"&&" withA:NO b:YES result:NO];
    [self assertLogicalOperator:@"&&" withA:YES b:NO result:NO];
    [self assertLogicalOperator:@"&&" withA:YES b:YES result:YES];
}

- (void)testLogicalOr
{
    [self assertLogicalOperator:@"||" withA:NO b:NO result:NO];
    [self assertLogicalOperator:@"||" withA:NO b:YES result:YES];
    [self assertLogicalOperator:@"||" withA:YES b:NO result:YES];
    [self assertLogicalOperator:@"||" withA:YES b:YES result:YES];
}

//- (void)testExec
//{
//    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];
//
//    // do some simple math
//    [builder addPushDoubleInstruction:10.0];
//    [builder addPushDoubleInstruction:20.0];
//    [builder addInvokeFunctionInstructionWithName:@"+" count:2];
//
//    // grab byte code
//    PXExpressionByteCode *blockCode = builder.byteCode;
//
//    // create block value
//    PXBlockValue *block = [[PXBlockValue alloc] initWithByteCode:blockCode];
//
//    // create byte to call block
//    [builder reset];
//    [builder addExecuteInstruction];
//
//    // grab byte code
//    PXExpressionByteCode *code = builder.byteCode;
//
//    // execute
//    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
//    [env pushValue:block];
//    [env executeByteCode:code];
//
//    // check result
//    id<PXExpressionValue> result = [env popValue];
//
//    // make assertions
//    [self assertDoubleValue:result expected:30.0];
//}

- (void)testPop
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    // push a couple of values
    [builder addPushDoubleInstruction:10.0];
    [builder addPushDoubleInstruction:20.0];

    // pop one
    [builder addPopInstruction];

    // grab byte code
    PXExpressionByteCode *code = builder.byteCode;

    // execute expression
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
    [env executeByteCode:code];

    // check result
    id<PXExpressionValue> result1 = [env popValue];
    id<PXExpressionValue> result2 = [env popValue];

    // make assertions
    [self assertDoubleValue:result1 expected:10.0];

    XCTAssertNil(result2, @"Did not expect any more values on the stack");
}

- (void)testSwap
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    // push a couple of values
    [builder addPushDoubleInstruction:10.0];
    [builder addPushDoubleInstruction:20.0];

    // pop one
    [builder addSwapInstruction];

    // grab byte code
    PXExpressionByteCode *code = builder.byteCode;

    // execute expression
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
    [env executeByteCode:code];

    // check result
    id<PXExpressionValue> result1 = [env popValue];
    id<PXExpressionValue> result2 = [env popValue];

    // make assertions
    [self assertDoubleValue:result1 expected:10.0];
    [self assertDoubleValue:result2 expected:20.0];
}

- (void)testSin
{
    [self assertMathOperator:@"sin" withValue:M_PI_2 result:1.0];
}

- (void)testCos
{
    [self assertMathOperator:@"cos" withValue:0.0 result:1.0];
}

- (void)testPow
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushDoubleInstruction:2.0];
    [expr addPushDoubleInstruction:4.0];
    [expr addInvokeFunctionInstructionWithName:@"pow" count:2];

    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];

    [self assertDoubleValue:value expected:16.0];
}

- (void)testSqrt
{
    [self assertMathOperator:@"√" withValue:25.0 result:5.0];
}

#pragma mark - Scope Tests

- (void)testNestedScope
{
    PXScope *global = [[PXScope alloc] init];
    [global setDoubleValue:1.0 forSymbolName:@"a"];

    PXScope *function = [[PXScope alloc] init];
    [function setDoubleValue:2.0 forSymbolName:@"b"];

    function.parentScope = global;

    id<PXExpressionValue> a = [function valueForSymbolName:@"a"];
    id<PXExpressionValue> b = [function valueForSymbolName:@"b"];

    [self assertDoubleValue:a expected:1.0];
    [self assertDoubleValue:b expected:2.0];
}

- (void)testShadowedSymbol
{
    PXScope *global = [[PXScope alloc] init];
    [global setDoubleValue:1.0 forSymbolName:@"a"];

    PXScope *function = [[PXScope alloc] init];
    [function setDoubleValue:2.0 forSymbolName:@"a"];

    function.parentScope = global;

    id<PXExpressionValue> a = [function valueForSymbolName:@"a"];

    [self assertDoubleValue:a expected:2.0];
}

#pragma mark - special division tests

- (void)testDivideZero
{
    [self assertBinaryOperator:@"/" withA:0.0 b:5.0 result:0.0];
}

- (void)testDivideByZero
{
    // build compiled expression
    PXByteCodeBuilder *expr = [[PXByteCodeBuilder alloc] init];
    [expr addPushDoubleInstruction:5.0];
    [expr addPushDoubleInstruction:0.0];
    [expr addDivideInstruction];
    
    // check result
    id<PXExpressionValue> value = [self valueFromExecutingBuilder:expr];
    
    XCTAssertTrue(isnan(value.doubleValue), @"expected NaN");
}

#pragma mark - Jelly Expressions

- (PXExpressionEnvironment *)makeJellyMachine
{
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];

    // create gesture scope
    PXScope *gesture = [[PXScope alloc] init];
    [gesture setDoubleValue:10.0 forSymbolName:@"sx"];
    [gesture setDoubleValue:20.0 forSymbolName:@"sy"];
    [gesture setDoubleValue:30.0 forSymbolName:@"cx"];
    [gesture setDoubleValue:40.0 forSymbolName:@"cy"];
    [gesture setDoubleValue:50.0 forSymbolName:@"dx"];
    [gesture setDoubleValue:210.0 forSymbolName:@"dy"];
    [env pushScope:gesture];

    // create gesture body scope
    PXScope *gestureBody = [[PXScope alloc] init];
    [gestureBody setDoubleValue:200.0 forSymbolName:@"threshold"];
    [gestureBody setDoubleValue:300.0 forSymbolName:@"max_distance"];
    [gestureBody setDoubleValue:750.0 forSymbolName:@"offscreen"];
    [env pushScope:gestureBody];

    return env;
}

- (void)testHalfWayCondition
{
    PXByteCodeBuilder *compiler = [[PXByteCodeBuilder alloc] init];
    PXExpressionUnit *unit = [compiler compileExpression:@"dy > threshold"];

    PXExpressionEnvironment *env = [self makeJellyMachine];
    [env executeUnit:unit];

    id<PXExpressionValue> value = [env popValue];

    [self assertBooleanValue:value expected:YES];
}

- (void)testBehindT
{
    PXByteCodeBuilder *compiler = [[PXByteCodeBuilder alloc] init];
    PXExpressionUnit *unit = [compiler compileExpression:@"abs(dy / max_distance)"];

    PXExpressionEnvironment *env = [self makeJellyMachine];
    [env executeUnit:unit];

    id<PXExpressionValue> value = [env popValue];

    [self assertDoubleValue:value expected:(210.0 / 300.0)];
}

- (void)testMainT
{
    PXByteCodeBuilder *compiler = [[PXByteCodeBuilder alloc] init];
    PXExpressionUnit *unit = [compiler compileExpression:@"dy / max_distance"];

    PXExpressionEnvironment *env = [self makeJellyMachine];
    [env executeUnit:unit];

    id<PXExpressionValue> value = [env popValue];

    [self assertDoubleValue:value expected:(210.0 / 300.0)];
}

- (void)testEndCondition
{
    PXByteCodeBuilder *compiler = [[PXByteCodeBuilder alloc] init];
    PXExpressionUnit *unit = [compiler compileExpression:@"dy <= 75"];

    PXExpressionEnvironment *env = [self makeJellyMachine];
    [env executeUnit:unit];

    id<PXExpressionValue> value = [env popValue];

    [self assertBooleanValue:value expected:NO];
}

@end
