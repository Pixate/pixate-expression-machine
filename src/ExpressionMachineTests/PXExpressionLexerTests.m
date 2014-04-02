//
//  PXExpressionLexerTests.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/26/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PXExpressionLexeme.h"
#import "PXExpressionLexemeType.h"

void expr_lexer_set_source(NSString *source, BOOL forEma);
PXExpressionLexeme *expr_lexer_get_lexeme();
void expr_lexer_delete_buffer();

@interface PXExpressionLexerTests : XCTestCase

@end

@implementation PXExpressionLexerTests

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

- (void)assertType:(int)type forSource:(NSString *)source
{
    expr_lexer_set_source(source, NO);
    PXExpressionLexeme *lexeme = expr_lexer_get_lexeme();
    expr_lexer_delete_buffer();

    XCTAssertEqual(type, lexeme.type);
    XCTAssertTrue([source isEqualToString:lexeme.text]);
}

- (void)testIdentifier
{
    [self assertType:EM_IDENTIFIER forSource:@"abc"];
}

- (void)testZero
{
    [self assertType:EM_NUMBER forSource:@"0"];
}

- (void)testInteger
{
    [self assertType:EM_NUMBER forSource:@"10"];
}

- (void)testDouble
{
    [self assertType:EM_NUMBER forSource:@"10.5"];
}

- (void)testTrue
{
    [self assertType:EM_TRUE forSource:@"true"];
}

- (void)testFalse
{
    [self assertType:EM_FALSE forSource:@"false"];
}

- (void)testThis
{
    [self assertType:EM_THIS forSource:@"this"];
}

- (void)testNull
{
    [self assertType:EM_NULL forSource:@"null"];
}

- (void)testUndefined
{
    [self assertType:EM_UNDEFINED forSource:@"undefined"];
}

- (void)testLParen
{
    [self assertType:EM_LPAREN forSource:@"("];
}

- (void)testRParen
{
    [self assertType:EM_RPAREN forSource:@")"];
}

- (void)testLBracket
{
    [self assertType:EM_LBRACKET forSource:@"["];
}

- (void)testRBracket
{
    [self assertType:EM_RBRACKET forSource:@"]"];
}

- (void)testLessThan
{
    [self assertType:EM_LESS_THAN forSource:@"<"];
}

- (void)testLessThanEqual
{
    [self assertType:EM_LESS_THAN_EQUAL forSource:@"<="];
}

- (void)testEqual
{
    [self assertType:EM_EQUAL forSource:@"=="];
}

- (void)testNotEqual
{
    [self assertType:EM_NOT_EQUAL forSource:@"!="];
}

- (void)testGreaterThanEqual
{
    [self assertType:EM_GREATER_THAN_EQUAL forSource:@">="];
}

- (void)testGreaterThan
{
    [self assertType:EM_GREATER_THAN forSource:@">"];
}

- (void)testLt
{
    [self assertType:EM_LT forSource:@"lt"];
}

- (void)testLe
{
    [self assertType:EM_LE forSource:@"le"];
}

- (void)testEq
{
    [self assertType:EM_EQ forSource:@"eq"];
}

- (void)testNe
{
    [self assertType:EM_NE forSource:@"ne"];
}

- (void)testGe
{
    [self assertType:EM_GE forSource:@"ge"];
}

- (void)testGt
{
    [self assertType:EM_GT forSource:@"gt"];
}

- (void)testLogicalNot
{
    [self assertType:EM_LOGICAL_NOT forSource:@"!"];
}

- (void)testLogicalAnd
{
    [self assertType:EM_LOGICAL_AND forSource:@"&&"];
}

- (void)testLogicalOr
{
    [self assertType:EM_LOGICAL_OR forSource:@"||"];
}

- (void)testNot
{
    [self assertType:EM_NOT forSource:@"not"];
}

- (void)testAnd
{
    [self assertType:EM_AND forSource:@"and"];
}

- (void)testOr
{
    [self assertType:EM_OR forSource:@"or"];
}

- (void)testPlus
{
    [self assertType:EM_PLUS forSource:@"+"];
}

- (void)testMinus
{
    [self assertType:EM_MINUS forSource:@"-"];
}

- (void)testTimes
{
    [self assertType:EM_TIMES forSource:@"*"];
}

- (void)testDivide
{
    [self assertType:EM_DIVIDE forSource:@"/"];
}

- (void)testDot
{
    [self assertType:EM_DOT forSource:@"."];
}

- (void)testComma
{
    [self assertType:EM_COMMA forSource:@","];
}

- (void)testAssign
{
    [self assertType:EM_ASSIGN forSource:@"="];
}

- (void)testDoubleQuotedString
{
    [self assertType:EM_STRING forSource:@"\"hello\""];
}

- (void)testSingleQuotedString
{
    [self assertType:EM_STRING forSource:@"'hello'"];
}

- (void)testIf
{
    [self assertType:EM_IF forSource:@"if"];
}

- (void)testElse
{
    [self assertType:EM_ELSE forSource:@"else"];
}

- (void)testElsif
{
    [self assertType:EM_ELSIF forSource:@"elsif"];
}

- (void)testError
{
    [self assertType:EM_ERROR forSource:@"#"];
}

@end
