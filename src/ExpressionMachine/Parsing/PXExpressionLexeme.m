//
//  PXExpressionLexeme.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/26/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionLexeme.h"
#import "PXExpressionLexemeType.h"

@implementation PXExpressionLexeme

@synthesize type = _type;
@synthesize text = _text;
@synthesize value = _value;
@synthesize range = _range;

#pragma mark - Initializers

- (id)initWithType:(int)type text:(NSString *)text
{
    if (self = [super init])
    {
        _type = type;
        _text = text;
    }

    return self;
}

- (NSString *)description
{
    NSString *spaces = [_text stringByReplacingOccurrencesOfString:@" " withString:@"."];
    NSString *tabs = [spaces stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];

    return [NSString stringWithFormat:@"[%@:%d]~%@~", self.name, _type, tabs];
}

- (NSString *)name
{
    switch (_type)
    {
        case EM_EOF: return @"EOF";
        case EM_ERROR: return @"ERROR";

        case EM_IDENTIFIER: return @"IDENTIFIER";
        case EM_NUMBER: return @"NUMBER";

        case EM_FUNC: return @"FUNC";

        case EM_LT: return @"LT";
        case EM_LE: return @"LE";
        case EM_EQ: return @"EQ";
        case EM_NE: return @"NE";
        case EM_GE: return @"GE";
        case EM_GT: return @"GT";

        case EM_NOT: return @"NOT";
        case EM_OR: return @"OR";
        case EM_AND: return @"AND";
        case EM_TRUE: return @"TRUE";
        case EM_FALSE: return @"FALSE";
        case EM_THIS: return @"THIS";

        case EM_NULL: return @"NULL";
        case EM_UNDEFINED: return @"UNDEFINED";

        case EM_IF: return @"IF";
        case EM_ELSE: return @"ELSE";
        case EM_ELSIF: return @"ELSIF";
        case EM_SYM: return @"SYM";

        case EM_LPAREN: return @"LPAREN";
        case EM_RPAREN: return @"RPAREN";
        case EM_LBRACKET: return @"LBRACKET";
        case EM_RBRACKET: return @"RBRACKET";
        case EM_LCURLY: return @"LCURLY";
        case EM_RCURLY: return @"RCURLY";

        case EM_LESS_THAN: return @"LESS_THAN";
        case EM_LESS_THAN_EQUAL: return @"LESS_THAN_EQUAL";
        case EM_EQUAL: return @"EQUAL";
        case EM_NOT_EQUAL: return @"NOT_EQUAL";
        case EM_GREATER_THAN_EQUAL: return @"GREATER_THAN_EQUAL";
        case EM_GREATER_THAN: return @"GREATER_THAN";

        case EM_LOGICAL_NOT: return @"LOGICAL_NOT";
        case EM_LOGICAL_OR: return @"LOGICAL_OR";
        case EM_LOGICAL_AND: return @"LOGICAL_AND";

        case EM_PLUS: return @"PLUS";
        case EM_MINUS: return @"MINUS";
        case EM_TIMES: return @"TIMES";
        case EM_DIVIDE: return @"DIVIDE";
        case EM_MODULUS: return @"MODULUS";

        case EM_QUESTION: return @"QUESTION";
        case EM_DOT: return @"DOT";
        case EM_COMMA: return @"COMMA";
        case EM_SEMICOLON: return @"SEMICOLON";
        case EM_COLON: return @"COLON";
        case EM_ASSIGN: return @"ASSIGN";

        case EM_STRING: return @"STRING";

        // EMA

        case EMA_APPLY: return @"APPLY";
        case EMA_CREATE_ARRAY: return @"CREATE_ARRAY";
        case EMA_CREATE_OBJECT: return @"CREATE_OBJECT";
        case EMA_DUP: return @"DUP";
        case EMA_EXEC: return @"EXEC";
        case EMA_FUNC: return @"FUNC";
        case EMA_GET_ELEMENT: return @"GET_ELEMENT";
        case EMA_GET_PROPERTY: return @"GET_PROPERTY";
        case EMA_GET_SYMBOL: return @"GET_SYMBOL";
        case EMA_GLOBAL: return @"GLOBAL";
        case EMA_IF_ELSE: return @"IF_ELSE";
        case EMA_INVOKE: return @"INVOKE";
        case EMA_POP: return @"POP";
        case EMA_PUSH: return @"PUSH";
        case EMA_SET_SYMBOL: return @"SET_SYMBOL";
        case EMA_SWAP: return @"SWAP";

        case EMA_ADD: return @"ADD";
        case EMA_SUB: return @"SUB";
        case EMA_MUL: return @"MUL";
        case EMA_DIV: return @"DIV";
        case EMA_MOD: return @"MOD";
        case EMA_NEG: return @"NEG";

        case EMA_MARK: return @"MARK";

        case EMA_LCURLY_BRACKET: return @"LCURLY_BRACKET";
        case EMA_RBRACKET_CURLY: return @"RBRACKET_CURLY";

        case EMA_CARET: return @"CARET";
        case EMA_CARET_ASSIGN: return @"CARET_ASSIGN";

        default: return @"<unknown>";
    }
}

- (void)setFlag:(int)type
{
}

- (void)clearFlag:(int)type
{
}

- (BOOL)flagIsSet:(int)type
{
    return NO;
}

@end
