//
//  PXEmaLexerTests.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/28/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PXExpressionLexeme.h"
#import "PXExpressionLexemeType.h"

void expr_lexer_set_source(NSString *source, BOOL forEma);
PXExpressionLexeme *expr_lexer_get_lexeme();
void expr_lexer_delete_buffer();

@interface PXEmaLexerTests : XCTestCase

@end

@implementation PXEmaLexerTests

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
    expr_lexer_set_source(source, YES);
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

- (void)testPush
{
    [self assertType:EMA_PUSH forSource:@"push"];
}

- (void)testGetSymbol
{
    [self assertType:EMA_GET_SYMBOL forSource:@"getSymbol"];
}

- (void)testSetSymbol
{
    [self assertType:EMA_SET_SYMBOL forSource:@"setSymbol"];
}

- (void)testGetElement
{
    [self assertType:EMA_GET_ELEMENT forSource:@"getElement"];
}

- (void)testGetProperty
{
    [self assertType:EMA_GET_PROPERTY forSource:@"getProperty"];
}

- (void)testInvoke
{
    [self assertType:EMA_INVOKE forSource:@"invoke"];
}

- (void)testTrue
{
    [self assertType:EM_TRUE forSource:@"true"];
}

- (void)testFalse
{
    [self assertType:EM_FALSE forSource:@"false"];
}

- (void)testMark
{
    [self assertType:EMA_MARK forSource:@"mark"];
}

- (void)testApply
{
    [self assertType:EMA_APPLY forSource:@"apply"];
}

- (void)testExec
{
    [self assertType:EMA_EXEC forSource:@"exec"];
}

- (void)testFunc
{
    [self assertType:EMA_FUNC forSource:@"asmfunc"];
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

- (void)testLCurly
{
    [self assertType:EM_LCURLY forSource:@"{"];
}

- (void)testRCurly
{
    [self assertType:EM_RCURLY forSource:@"}"];
}

- (void)testLBracket
{
    [self assertType:EM_LBRACKET forSource:@"["];
}

- (void)testRBracket
{
    [self assertType:EM_RBRACKET forSource:@"]"];
}

- (void)testLCurlyBracket
{
    [self assertType:EMA_LCURLY_BRACKET forSource:@"{["];
}

- (void)testRBracketCurly
{
    [self assertType:EMA_RBRACKET_CURLY forSource:@"]}"];
}

- (void)testComma
{
    [self assertType:EM_COMMA forSource:@","];
}

- (void)testDot
{
    [self assertType:EM_DOT forSource:@"."];
}

- (void)testCaret
{
    [self assertType:EMA_CARET forSource:@"^"];
}

-(void)testCaretAssign
{
    [self assertType:EMA_CARET_ASSIGN forSource:@"^="];
}

- (void)testLessThan
{
    [self assertType:EM_LESS_THAN forSource:@"<"];
}

- (void)testGreaterThan
{
    [self assertType:EM_GREATER_THAN forSource:@">"];
}

- (void)testDoubleQuotedString
{
    [self assertType:EM_STRING forSource:@"\"hello\""];
}

- (void)testSingleQuotedString
{
    [self assertType:EM_STRING forSource:@"'hello'"];
}

- (void)testAdd
{
    [self assertType:EMA_ADD forSource:@"add"];
}

- (void)testSub
{
    [self assertType:EMA_SUB forSource:@"sub"];
}

- (void)testMul
{
    [self assertType:EMA_MUL forSource:@"mul"];
}

- (void)testDiv
{
    [self assertType:EMA_DIV forSource:@"div"];
}

- (void)testAnd
{
    [self assertType:EM_AND forSource:@"and"];
}

- (void)testOr
{
    [self assertType:EM_OR forSource:@"or"];
}

- (void)testNot
{
    [self assertType:EM_NOT forSource:@"not"];
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

@end
