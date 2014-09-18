//
//  PXExpressionLexemeType.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/26/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#ifndef YYTOKENTYPE
# define YYTOKENTYPE

enum yytokentype {
    EM_EOF = 0,
    EM_ERROR = 258,

    EM_IDENTIFIER,
    EM_NUMBER,

    EM_FUNC,

    EM_LT,
    EM_LE,
    EM_EQ,
    EM_NE,
    EM_GE,
    EM_GT,

    EM_NOT,
    EM_OR,
    EM_AND,
    EM_TRUE,
    EM_FALSE,
    EM_THIS,

    EM_NULL,
    EM_UNDEFINED,

    EM_IF,
    EM_ELSE,
    EM_ELSIF,
    EM_SYM,

    EM_LPAREN,
    EM_RPAREN,
    EM_LBRACKET,
    EM_RBRACKET,
    EM_LCURLY,
    EM_RCURLY,

    EM_LESS_THAN,
    EM_LESS_THAN_EQUAL,
    EM_EQUAL,
    EM_NOT_EQUAL,
    EM_GREATER_THAN_EQUAL,
    EM_GREATER_THAN,

    EM_LOGICAL_NOT,
    EM_LOGICAL_OR,
    EM_LOGICAL_AND,

    EM_PLUS,
    EM_MINUS,
    EM_TIMES,
    EM_DIVIDE,
    EM_MODULUS,

    EM_QUESTION,
    EM_DOT,
    EM_COMMA,
    EM_SEMICOLON,
    EM_COLON,
    EM_ASSIGN,

    EM_STRING,

    // EMA Tokens
    EMA_APPLY,
    EMA_CREATE_ARRAY,
    EMA_CREATE_OBJECT,
    EMA_DUP,
    EMA_EXEC,
    EMA_FUNC,
    EMA_GET_ELEMENT,
    EMA_GET_PROPERTY,
    EMA_GET_SYMBOL,
    EMA_GLOBAL,
    EMA_IF_ELSE,
    EMA_INVOKE,
    EMA_POP,
    EMA_PUSH,
    EMA_SET_SYMBOL,
    EMA_SWAP,

    EMA_ADD,
    EMA_SUB,
    EMA_MUL,
    EMA_DIV,
    EMA_MOD,
    EMA_NEG,

    EMA_MARK,

    EMA_LCURLY_BRACKET,
    EMA_RBRACKET_CURLY,

    EMA_CARET,
    EMA_CARET_ASSIGN,

    // Virtual Tokens - for AST nodes
    EM_BOOLEAN,
    EM_PARAMETER
};

#endif
