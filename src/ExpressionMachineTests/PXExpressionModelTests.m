//
//  PXExpressionModelTests.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PXExpressionNodeCompiler.h"
#import "PXExpressionByteCode.h"
#import "PXExpressionLexemeType.h"

#import "PXGenericNode.h"

@interface PXExpressionModelTests : XCTestCase

@end

@implementation PXExpressionModelTests

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

- (void)testIdentifierNode
{
    PXGenericNode *node = [[PXGenericNode alloc] initWithType:EM_IDENTIFIER stringValue:@"abc"];
    PXExpressionNodeCompiler *compiler = [[PXExpressionNodeCompiler alloc] init];
    NSString *expected = @"getSymbol('abc')";

    // grab byte code
    PXExpressionByteCode *code = [compiler compileNode:node withScope:nil];

    XCTAssertTrue([expected isEqualToString:code.description]);
}

- (void)testNumberNode
{
    PXGenericNode *node = [[PXGenericNode alloc] initWithType:EM_NUMBER doubleValue:10.5];
    PXExpressionNodeCompiler *compiler = [[PXExpressionNodeCompiler alloc] init];
    NSString *expected = @"push(10.5)";

    // grab byte code
    PXExpressionByteCode *code = [compiler compileNode:node withScope:nil];

    XCTAssertTrue([expected isEqualToString:code.description]);
}

- (void)testStringNode
{
    PXGenericNode *node = [[PXGenericNode alloc] initWithType:EM_STRING stringValue:@"hello"];
    PXExpressionNodeCompiler *compiler = [[PXExpressionNodeCompiler alloc] init];
    NSString *expected = @"push('hello')";

    // grab byte code
    PXExpressionByteCode *code = [compiler compileNode:node withScope:nil];

    XCTAssertTrue([expected isEqualToString:code.description]);
}

- (void)testGetPropertyNode
{
    PXGenericNode *lhs = [[PXGenericNode alloc] initWithType:EM_IDENTIFIER stringValue:@"abc"];
    PXGenericNode *node = [[PXGenericNode alloc] initWithType:EM_DOT nodeValue:lhs stringValue:@"def"];
    PXExpressionNodeCompiler *compiler = [[PXExpressionNodeCompiler alloc] init];
    NSString *expected = @"getSymbol('abc')\ngetProperty('def')";

    // grab byte code
    PXExpressionByteCode *code = [compiler compileNode:node withScope:nil];

    XCTAssertTrue([expected isEqualToString:code.description], @"Expected\n%@\nbut found\n%@\n", expected, code.description);
}

- (void)testInvocationNode
{
    NSArray *args = @[ [[PXGenericNode alloc] initWithType:EM_NUMBER doubleValue:-10.5] ];
    PXGenericNode *name = [[PXGenericNode alloc] initWithType:EM_IDENTIFIER stringValue:@"abs"];
    PXGenericNode *node = [[PXGenericNode alloc] initWithType:EM_LPAREN nodeValue:name arrayValue:args];
    PXExpressionNodeCompiler *compiler = [[PXExpressionNodeCompiler alloc] init];
    NSString *expected = [@[
        @"push(-10.5)",
        @"invoke('abs', 1)"
    ] componentsJoinedByString:@"\n"];

    // grab byte code
    PXExpressionByteCode *code = [compiler compileNode:node withScope:nil];

    XCTAssertTrue([expected isEqualToString:code.description]);
}

- (void)testConditionalNode
{
    PXGenericNode *lhs = [[PXGenericNode alloc] initWithType:EM_NUMBER doubleValue:5.0];
    PXGenericNode *rhs = [[PXGenericNode alloc] initWithType:EM_NUMBER doubleValue:3.0];
    PXGenericNode *name = [[PXGenericNode alloc] initWithType:EM_IDENTIFIER stringValue:@"<"];
    PXGenericNode *node = [[PXGenericNode alloc] initWithType:EM_LPAREN nodeValue:name arrayValue:@[lhs, rhs]];
    PXExpressionNodeCompiler *compiler = [[PXExpressionNodeCompiler alloc] init];
    NSString *expected = [@[
        @"push(5)",
        @"push(3)",
        @"invoke('<', 2)"
    ] componentsJoinedByString:@"\n"];

    // grab byte code
    PXExpressionByteCode *code = [compiler compileNode:node withScope:nil];

    XCTAssertTrue([expected isEqualToString:code.description]);
}

- (void)testConditionalNode2
{
    PXGenericNode *lhs = [[PXGenericNode alloc] initWithType:EM_NUMBER doubleValue:5.0];
    PXGenericNode *rhs = [[PXGenericNode alloc] initWithType:EM_NUMBER doubleValue:3.0];
    PXGenericNode *name = [[PXGenericNode alloc] initWithType:EM_IDENTIFIER stringValue:@"lt"];
    PXGenericNode *node = [[PXGenericNode alloc] initWithType:EM_LPAREN nodeValue:name arrayValue:@[lhs, rhs]];
    PXExpressionNodeCompiler *compiler = [[PXExpressionNodeCompiler alloc] init];
    NSString *expected = [@[
        @"push(5)",
        @"push(3)",
        @"invoke('lt', 2)"
    ] componentsJoinedByString:@"\n"];

    // grab byte code
    PXExpressionByteCode *code = [compiler compileNode:node withScope:nil];

    XCTAssertTrue([expected isEqualToString:code.description]);
}

#pragma mark - Jelly Expressions

- (void)testHalfWayCondition
{
    // dy > threshold
    PXGenericNode *lhs = [[PXGenericNode alloc] initWithType:EM_IDENTIFIER stringValue:@"dy"];
    PXGenericNode *rhs = [[PXGenericNode alloc] initWithType:EM_IDENTIFIER stringValue:@"threshold"];
    PXGenericNode *name = [[PXGenericNode alloc] initWithType:EM_IDENTIFIER stringValue:@">"];
    PXGenericNode *node = [[PXGenericNode alloc] initWithType:EM_LPAREN nodeValue:name arrayValue:@[lhs, rhs]];
    PXExpressionNodeCompiler *compiler = [[PXExpressionNodeCompiler alloc] init];
    NSString *expected = [@[
        @"getSymbol('dy')",
        @"getSymbol('threshold')",
        @"invoke('>', 2)"
    ] componentsJoinedByString:@"\n"];

    // grab byte code
    PXExpressionByteCode *code = [compiler compileNode:node withScope:nil];

    XCTAssertTrue([expected isEqualToString:code.description]);
}

- (void)testBehindT
{
    // abs(dy / max_distance)
    PXGenericNode *lhs = [[PXGenericNode alloc] initWithType:EM_IDENTIFIER stringValue:@"dy"];
    PXGenericNode *rhs = [[PXGenericNode alloc] initWithType:EM_IDENTIFIER stringValue:@"max_distance"];
    PXGenericNode *name = [[PXGenericNode alloc] initWithType:EM_IDENTIFIER stringValue:@"/"];
    PXGenericNode *division = [[PXGenericNode alloc] initWithType:EM_LPAREN nodeValue:name arrayValue:@[lhs, rhs]];
    name = [[PXGenericNode alloc] initWithType:EM_IDENTIFIER stringValue:@"abs"];
    PXGenericNode *node = [[PXGenericNode alloc] initWithType:EM_LPAREN nodeValue:name arrayValue:@[division]];
    PXExpressionNodeCompiler *compiler = [[PXExpressionNodeCompiler alloc] init];
    NSString *expected = [@[
        @"getSymbol('dy')",
        @"getSymbol('max_distance')",
        @"invoke('/', 2)",
        @"invoke('abs', 1)"
    ] componentsJoinedByString:@"\n"];

    // grab byte code
    PXExpressionByteCode *code = [compiler compileNode:node withScope:nil];

    XCTAssertTrue([expected isEqualToString:code.description]);
}

- (void)testMainT
{
    // dy / max_distance
    PXGenericNode *lhs = [[PXGenericNode alloc] initWithType:EM_IDENTIFIER stringValue:@"dy"];
    PXGenericNode *rhs = [[PXGenericNode alloc] initWithType:EM_IDENTIFIER stringValue:@"max_distance"];
    PXGenericNode *name = [[PXGenericNode alloc] initWithType:EM_IDENTIFIER stringValue:@"/"];
    PXGenericNode *node = [[PXGenericNode alloc] initWithType:EM_LPAREN nodeValue:name arrayValue:@[lhs, rhs]];
    PXExpressionNodeCompiler *compiler = [[PXExpressionNodeCompiler alloc] init];
    NSString *expected = [@[
        @"getSymbol('dy')",
        @"getSymbol('max_distance')",
        @"invoke('/', 2)"
    ] componentsJoinedByString:@"\n"];

    // grab byte code
    PXExpressionByteCode *code = [compiler compileNode:node withScope:nil];

    XCTAssertTrue([expected isEqualToString:code.description]);
}

- (void)testEndCondition
{
    // dy <= 75
    PXGenericNode *lhs = [[PXGenericNode alloc] initWithType:EM_IDENTIFIER stringValue:@"dy"];
    PXGenericNode *name = [[PXGenericNode alloc] initWithType:EM_IDENTIFIER stringValue:@"<="];
    PXGenericNode *rhs = [[PXGenericNode alloc] initWithType:EM_NUMBER doubleValue:75.0];
    PXGenericNode *node = [[PXGenericNode alloc] initWithType:EM_LPAREN nodeValue:name arrayValue:@[lhs, rhs]];
    PXExpressionNodeCompiler *compiler = [[PXExpressionNodeCompiler alloc] init];
    NSString *expected = [@[
        @"getSymbol('dy')",
        @"push(75)",
        @"invoke('<=', 2)"
    ] componentsJoinedByString:@"\n"];

    // grab byte code
    PXExpressionByteCode *code = [compiler compileNode:node withScope:nil];
    
    XCTAssertTrue([expected isEqualToString:code.description]);
}

@end
