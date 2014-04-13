//
//  PXByteCodeOptimizerTests.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 4/7/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PXByteCodeBuilder.h"
#import "PXExpressionByteCode.h"
#import "PXObjectValue.h"
#import "PXBlockValue.h"
#import "PXSquareFunction.h"

@interface PXByteCodeOptimizerTests : XCTestCase

@end

@implementation PXByteCodeOptimizerTests

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

#pragma mark Push optimizations

- (void)testPushOnce
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    [builder addPushBooleanInstruction:YES];

    PXExpressionByteCode *byteCode = builder.optimizedByteCode;
    NSString *expected = @"push(true)";

    XCTAssertTrue([expected isEqualToString:byteCode.description], @"Expected\n%@\nbut found\n%@", expected, byteCode.description);
}

- (void)testPushAll
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    // create object
    PXObjectValue *object = [[PXObjectValue alloc] init];
    [object setStringValue:@"value" forPropertyName:@"key"];

    // create block
    PXByteCodeBuilder *builder2 = [[PXByteCodeBuilder alloc] init];
    [builder2 addPushBooleanInstruction:NO];

    [builder addPushBooleanInstruction:YES];
    [builder addPushStringInstruction:@"hello"];
    [builder addPushDoubleInstruction:10.0];
    [builder addPushObjectInstruction:object];
    [builder addPushBlockInstruction:builder2.byteCode];
    [builder addPushFunctionInstruction:[[PXSquareFunction alloc] init]];
    [builder addPushNullInstruction];
    [builder addPushUndefinedInstruction];
    [builder addPushMarkInstruction];

    PXExpressionByteCode *byteCode = builder.optimizedByteCode;
    NSString *values = [ @[
        @"true",
        @"'hello'",
        @"10",
        @"{'key': 'value'}",
        @"{ false }",
        @"func(x=0) { getSymbol('x')\ngetSymbol('x')\nmul }",
        @"null",
        @"undefined",
        @"mark"
    ] componentsJoinedByString:@", "];
    NSString *expected = [NSString stringWithFormat:@"push(%@)", values];

    XCTAssertTrue([expected isEqualToString:byteCode.description], @"Expected\n%@\nbut found\n%@", expected, byteCode.description);
}

#pragma mark - Get symbol optimizations

- (void)testGetSymbolNameOnce
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    [builder addGetSymbolInstructionWithName:@"hello"];

    PXExpressionByteCode *byteCode = builder.optimizedByteCode;
    NSString *expected = @"getSymbol('hello')";

    XCTAssertTrue([expected isEqualToString:byteCode.description], @"Expected\n%@\nbut found\n%@", expected, byteCode.description);
}

- (void)testGetSymbolNameTwice
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    [builder addGetSymbolInstructionWithName:@"hello"];
    [builder addGetSymbolInstructionWithName:@"world"];

    PXExpressionByteCode *byteCode = builder.optimizedByteCode;
    NSString *expected = @"getSymbol('hello', 'world')";

    XCTAssertTrue([expected isEqualToString:byteCode.description], @"Expected\n%@\nbut found\n%@", expected, byteCode.description);
}

- (void)testGetSymbolNameThrice
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    [builder addGetSymbolInstructionWithName:@"well"];
    [builder addGetSymbolInstructionWithName:@"hello"];
    [builder addGetSymbolInstructionWithName:@"world"];

    PXExpressionByteCode *byteCode = builder.optimizedByteCode;
    NSString *expected = @"getSymbol('well', 'hello', 'world')";

    XCTAssertTrue([expected isEqualToString:byteCode.description], @"Expected\n%@\nbut found\n%@", expected, byteCode.description);
}

#pragma mark - Get property optimizations

- (void)testGetPropertyNameOnce
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    [builder addGetPropertyInstructionWithName:@"hello"];

    PXExpressionByteCode *byteCode = builder.optimizedByteCode;
    NSString *expected = @"getProperty('hello')";

    XCTAssertTrue([expected isEqualToString:byteCode.description], @"Expected\n%@\nbut found\n%@", expected, byteCode.description);
}

- (void)testGetPropertyNameTwice
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    [builder addGetPropertyInstructionWithName:@"hello"];
    [builder addGetPropertyInstructionWithName:@"world"];

    PXExpressionByteCode *byteCode = builder.optimizedByteCode;
    NSString *expected = @"getProperty('hello', 'world')";

    XCTAssertTrue([expected isEqualToString:byteCode.description], @"Expected\n%@\nbut found\n%@", expected, byteCode.description);
}

- (void)testGetPropertyNameThrice
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    [builder addGetPropertyInstructionWithName:@"well"];
    [builder addGetPropertyInstructionWithName:@"hello"];
    [builder addGetPropertyInstructionWithName:@"world"];

    PXExpressionByteCode *byteCode = builder.optimizedByteCode;
    NSString *expected = @"getProperty('well', 'hello', 'world')";

    XCTAssertTrue([expected isEqualToString:byteCode.description], @"Expected\n%@\nbut found\n%@", expected, byteCode.description);
}

- (void)testGetSymbolGetPropertyOnce
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    [builder addGetSymbolInstructionWithName:@"hello"];
    [builder addGetPropertyInstructionWithName:@"world"];

    PXExpressionByteCode *byteCode = builder.optimizedByteCode;
    NSString *expected = @"getSymbolProperty('hello', 'world')";

    XCTAssertTrue([expected isEqualToString:byteCode.description], @"Expected\n%@\nbut found\n%@", expected, byteCode.description);
}

- (void)testGetSymbolGetPropertyTwice
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    [builder addGetSymbolInstructionWithName:@"well"];
    [builder addGetPropertyInstructionWithName:@"hello"];
    [builder addGetPropertyInstructionWithName:@"world"];

    PXExpressionByteCode *byteCode = builder.optimizedByteCode;
    NSString *expected = @"getSymbolProperty('well', 'hello', 'world')";

    XCTAssertTrue([expected isEqualToString:byteCode.description], @"Expected\n%@\nbut found\n%@", expected, byteCode.description);
}

- (void)testGetSymbolTwiceGetPropertyOnce
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    [builder addGetSymbolInstructionWithName:@"A"];
    [builder addGetSymbolInstructionWithName:@"hello"];
    [builder addGetPropertyInstructionWithName:@"world"];

    PXExpressionByteCode *byteCode = builder.optimizedByteCode;
    NSString *expected = @"getSymbol('A')\ngetSymbolProperty('hello', 'world')";

    XCTAssertTrue([expected isEqualToString:byteCode.description], @"Expected\n%@\nbut found\n%@", expected, byteCode.description);
}

- (void)testGetSymbolThriceGetPropertyOnce
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    [builder addGetSymbolInstructionWithName:@"A"];
    [builder addGetSymbolInstructionWithName:@"B"];
    [builder addGetSymbolInstructionWithName:@"hello"];
    [builder addGetPropertyInstructionWithName:@"world"];

    PXExpressionByteCode *byteCode = builder.optimizedByteCode;
    NSString *expected = @"getSymbol('A', 'B')\ngetSymbolProperty('hello', 'world')";

    XCTAssertTrue([expected isEqualToString:byteCode.description], @"Expected\n%@\nbut found\n%@", expected, byteCode.description);
}

- (void)testSetSymbolGetSymbol
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    [builder addSetSymbolInstructionWithName:@"A"];
    [builder addGetSymbolInstructionWithName:@"A"];

    PXExpressionByteCode *byteCode = builder.optimizedByteCode;
    NSString *expected = @"dup\nsetSymbol('A')";

    XCTAssertTrue([expected isEqualToString:byteCode.description], @"Expected\n%@\nbut found\n%@", expected, byteCode.description);
}

#pragma mark - Invoke function with count optimizations

- (void)testInvokeWithCount
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    [builder addGetSymbolInstructionWithName:@"a"];
    [builder addDuplicateInstruction];
    [builder addGetPropertyInstructionWithName:@"b"];
    [builder addInvokeFunctionInstructionWithCount:0];

    PXExpressionByteCode *byteCode = builder.optimizedByteCode;
    NSString *expected = @"invokeSymbolProperty('a', 'b', 0)";

    XCTAssertTrue([expected isEqualToString:byteCode.description], @"Expected\n%@\nbut found\n%@", expected, byteCode.description);
}

- (void)testInvokeWithCount2
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    [builder addGetSymbolInstructionWithName:@"a"];
    [builder addGetPropertyInstructionWithName:@"b"];
    [builder addGetPropertyInstructionWithName:@"c"];
    [builder addDuplicateInstruction];
    [builder addGetPropertyInstructionWithName:@"d"];
    [builder addInvokeFunctionInstructionWithCount:0];

    PXExpressionByteCode *byteCode = builder.optimizedByteCode;
    NSString *expected = @"invokeSymbolProperty('a', 'b', 'c', 'd', 0)";

    XCTAssertTrue([expected isEqualToString:byteCode.description], @"Expected\n%@\nbut found\n%@", expected, byteCode.description);
}

- (void)testInvokeWithCount3
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    [builder addGetSymbol:@"a" property:@"b"];
    [builder addInvokeFunctionInstructionWithCount:0];

    PXExpressionByteCode *byteCode = builder.optimizedByteCode;
    NSString *expected = @"invokeSymbolProperty('a', 'b', 0)";

    XCTAssertTrue([expected isEqualToString:byteCode.description], @"Expected\n%@\nbut found\n%@", expected, byteCode.description);
}

- (void)testInvokeWithCount4
{
    PXByteCodeBuilder *builder = [[PXByteCodeBuilder alloc] init];

    // ary.push(v)
    [builder addGetSymbolInstructionWithName:@"v"];
    [builder addGetSymbolInstructionWithName:@"ary"];
    [builder addDuplicateInstruction];
    [builder addGetPropertyInstructionWithName:@"push"];
    [builder addInvokeFunctionInstructionWithCount:1];

    PXExpressionByteCode *byteCode = builder.optimizedByteCode;
    NSString *expected = @"getSymbol('v')\ninvokeSymbolProperty('ary', 'push', 1)";

    XCTAssertTrue([expected isEqualToString:byteCode.description], @"Expected\n%@\nbut found\n%@", expected, byteCode.description);
}

@end
