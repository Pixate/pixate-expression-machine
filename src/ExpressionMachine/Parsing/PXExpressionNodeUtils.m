//
//  PXExpressionNodeUtils.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/26/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionNodeUtils.h"

#import "PXExpressionLexemeType.h"
#import "PXSourceWriter.h"

#import "PXGenericNode.h"
#import "PXBlockNode.h"

@implementation PXExpressionNodeUtils

+ (NSString *)descriptionForNode:(id<PXExpressionNode>)node
{
    PXSourceWriter *writer = [[PXSourceWriter alloc] init];

    [self descriptionForNode:node withWriter:writer];

    NSString *result = writer.description;

    return [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (void)descriptionForNode:(id<PXExpressionNode>)node withWriter:(PXSourceWriter *)writer
{
    if (node.type == EM_LCURLY)
    {
        PXBlockNode *block = (PXBlockNode *)node;

        if (block.isBlockValue)
        {
            [writer printIndent];
            [writer printWithNewLine:@"{"];
            [writer increaseIndent];
        }

        [block.nodes enumerateObjectsUsingBlock:^(id<PXExpressionNode> node, NSUInteger idx, BOOL *stop) {
            [self descriptionForNode:node withWriter:writer];
        }];

        if (block.isBlockValue)
        {
            [writer decreaseIndent];
            [writer printIndent];
            [writer printWithNewLine:@"}"];
        }
    }
    else if (node.type == EM_IF)
    {
        PXGenericNode *ifNode = (PXGenericNode *)node;

        [writer printIndent];
        [writer printWithNewLine:@"if"];

        if (ifNode.nodeValue != nil)
        {
            [writer increaseIndent];
            [self descriptionForNode:ifNode.nodeValue withWriter:writer];

            // open block
            [writer printIndent];
            [writer printWithNewLine:@"{"];
            [writer increaseIndent];

            // emit true block
            [self descriptionForNode:ifNode.nodeValue2 withWriter:writer];

            // close block
            [writer decreaseIndent];
            [writer printIndent];
            [writer printWithNewLine:@"}"];

            // false block
            if (ifNode.nodeValue3 != nil)
            {
                // open block
                [writer printIndent];
                [writer printWithNewLine:@"{"];
                [writer increaseIndent];

                // emit false block
                [self descriptionForNode:ifNode.nodeValue3 withWriter:writer];

                // close block
                [writer decreaseIndent];
                [writer printIndent];
                [writer printWithNewLine:@"}"];
            }
            
            [writer decreaseIndent];
        }
    }
    else
    {
        PXGenericNode *ast = (PXGenericNode *)node;
        NSString *name = nil;

        if (ast.type != EM_PARAMETER)
        {
            [writer printIndent];
        }

        switch (ast.type)
        {
            case EM_IDENTIFIER:
                [writer printWithNewLine:ast.stringValue];
                break;

            case EM_NUMBER:
                [writer printWithNewLine:[NSString stringWithFormat:@"%g", ast.doubleValue]];
                break;

            case EM_FUNC:
            {
                [writer print:ast.stringValue];

                // args
                [writer print:@"("];
                [ast.arrayValue enumerateObjectsUsingBlock:^(PXGenericNode *parameter, NSUInteger idx, BOOL *stop) {
                    if (idx > 0)
                    {
                        [writer print:@","];
                    }

                    [writer print:[self descriptionForNode:parameter]];
                }];
                [writer printWithNewLine:@")"];

                // body
                [writer increaseIndent];
                [self descriptionForNode:ast.nodeValue withWriter:writer];
                [writer decreaseIndent];
                break;
            }

            case EM_LT:
                name = @"lt";
                break;

            case EM_LE:
                name = @"le";
                break;

            case EM_EQ:
                name = @"eq";
                break;

            case EM_NE:
                name = @"ne";
                break;

            case EM_GE:
                name = @"ge";
                break;

            case EM_GT:
                name = @"gt";
                break;

            case EM_NOT:
                name = @"not";
                break;

            case EM_OR:
                name = @"or";
                break;

            case EM_AND:
                name = @"and";
                break;

            case EM_THIS:
                [writer printWithNewLine:@"this"];
                break;

            case EM_NULL:
                [writer printWithNewLine:@"null"];
                break;

            case EM_UNDEFINED:
                [writer printWithNewLine:@"undefined"];
                break;

            case EM_SYM:
                [writer printWithNewLine:@"sym"];

                [writer increaseIndent];
                [writer printIndent];
                [writer printWithNewLine:ast.stringValue];

                if (ast.nodeValue != nil)
                {
                    [self descriptionForNode:ast.nodeValue withWriter:writer];
                }

                [writer decreaseIndent];
                break;

            case EM_LPAREN:
            {
                if ([ast.nodeValue isKindOfClass:[PXGenericNode class]] && [(PXGenericNode *)ast.nodeValue type] == EM_IDENTIFIER)
                {
                    PXGenericNode *identifier = (PXGenericNode *)ast.nodeValue;

                    [writer printWithNewLine:[NSString stringWithFormat:@"'%@'()", identifier.stringValue]];
                    [writer increaseIndent];
                }
                else
                {
                    [writer printWithNewLine:@">()"];
                    [writer increaseIndent];
                    [self descriptionForNode:ast.nodeValue withWriter:writer];
                }

                [ast.arrayValue enumerateObjectsUsingBlock:^(id<PXExpressionNode> arg, NSUInteger idx, BOOL *stop) {
                    [self descriptionForNode:arg withWriter:writer];
                }];

                [writer decreaseIndent];
                break;
            }

            case EM_LBRACKET:
                name = @"getElement";
                break;

            case EM_RBRACKET:
                [writer printWithNewLine:@"[]"];

                if (ast.arrayValue.count > 0)
                {
                    [writer increaseIndent];
                    [ast.arrayValue enumerateObjectsUsingBlock:^(id<PXExpressionNode> element, NSUInteger idx, BOOL *stop) {
                        [self descriptionForNode:element withWriter:writer];
                    }];
                    [writer decreaseIndent];
                }
                break;

            case EM_RCURLY:
            {
                [writer printWithNewLine:@"{}"];

                if (ast.arrayValue.count > 0)
                {
                    [writer increaseIndent];
                    [ast.arrayValue enumerateObjectsUsingBlock:^(id<PXExpressionNode> keyValue, NSUInteger idx, BOOL *stop) {
                        [self descriptionForNode:keyValue withWriter:writer];
                    }];
                    [writer decreaseIndent];
                }
                break;
            }

            case EM_LESS_THAN:
                name = @"<";
                break;

            case EM_LESS_THAN_EQUAL:
                name = @"<=";
                break;

            case EM_EQUAL:
                name = @"==";
                break;

            case EM_NOT_EQUAL:
                name = @"!=";
                break;

            case EM_GREATER_THAN_EQUAL:
                name = @">=";
                break;

            case EM_GREATER_THAN:
                name = @">";
                break;

            case EM_LOGICAL_NOT:
                [writer printWithNewLine:@"!"];

                [writer increaseIndent];
                [self descriptionForNode:ast.nodeValue withWriter:writer];

                [writer decreaseIndent];
                break;

            case EM_LOGICAL_OR:
                name = @"||";
                break;

            case EM_LOGICAL_AND:
                name = @"&&";
                break;

            case EM_PLUS:
                name = @"+";
                break;

            case EM_MINUS:
                name = @"-";
                break;

            case EM_TIMES:
                name = @"*";
                break;

            case EM_DIVIDE:
                name = @"/";
                break;
                
            case EM_MODULUS:
                name = @"%";
                break;

            case EM_DOT:
                [writer printWithNewLine:@"."];
                [writer increaseIndent];

                [self descriptionForNode:ast.nodeValue withWriter:writer];

                if (ast.stringValue.length > 0)
                {
                    [writer printIndent];
                    [writer print:@"'"];
                    [writer print:ast.stringValue];
                    [writer printWithNewLine:@"'"];
                }
                else
                {
                    [self descriptionForNode:ast.nodeValue2 withWriter:writer];
                }
                
                [writer decreaseIndent];
                break;

            case EM_COLON:
                [writer print:@"'"];
                [writer print:ast.stringValue];
                [writer printWithNewLine:@"'"];

                [self descriptionForNode:ast.nodeValue withWriter:writer];
                break;

            case EM_STRING:
                [writer printWithNewLine:[NSString stringWithFormat:@"'%@'", ast.stringValue]];
                break;

            case EMA_APPLY:
                if (ast.stringValue.length > 0)
                {
                    [writer printWithNewLine:[NSString stringWithFormat:@"apply('%@')", ast.stringValue]];
                }
                else
                {
                    [writer printWithNewLine:@"apply"];
                }
                break;

            case EMA_CREATE_ARRAY:
                if (ast.uintValue > 0)
                {
                    [writer printWithNewLine:[NSString stringWithFormat:@"createArray(%d)", ast.uintValue]];
                }
                else
                {
                    [writer printWithNewLine:@"createArray"];
                }
                break;

            case EMA_CREATE_OBJECT:
                if (ast.uintValue > 0)
                {
                    [writer printWithNewLine:[NSString stringWithFormat:@"createObject(%d)", ast.uintValue]];
                }
                else
                {
                    [writer printWithNewLine:@"createObject"];
                }
                break;

            case EMA_DUP:
                name = @"dup";
                break;

            case EMA_EXEC:
                name = @"exec";
                break;
                
            case EMA_GET_ELEMENT:
                if (ast.uintValue != UINT_MAX)
                {
                    [writer printWithNewLine:[NSString stringWithFormat:@"getElement(%d)", ast.uintValue]];
                }
                else
                {
                    [writer printWithNewLine:@"getElement"];
                }
                break;

            case EMA_GET_PROPERTY:
                if (ast.stringValue.length > 0)
                {
                    [writer printWithNewLine:[NSString stringWithFormat:@"getProperty('%@')", ast.stringValue]];
                }
                else
                {
                    [writer printWithNewLine:@"getProperty"];
                }
                break;

            case EMA_GET_SYMBOL:
                if (ast.stringValue.length > 0)
                {
                    [writer printWithNewLine:[NSString stringWithFormat:@"getSymbol('%@')", ast.stringValue]];
                }
                else
                {
                    [writer printWithNewLine:@"getSymbol"];
                }
                break;

            case EMA_GLOBAL:
                name = @"global";
                break;

            case EMA_IF_ELSE:
                name = @"ifelse";
                break;

            case EMA_INVOKE:
                if (ast.stringValue.length > 0)
                {
                    if (ast.uintValue > 0)
                    {
                        [writer printWithNewLine:[NSString stringWithFormat:@"invoke('%@', %d)", ast.stringValue, ast.uintValue]];
                    }
                    else
                    {
                        [writer printWithNewLine:[NSString stringWithFormat:@"invoke('%@')", ast.stringValue]];
                    }
                }
                else if (ast.uintValue > 0)
                {
                    [writer printWithNewLine:[NSString stringWithFormat:@"invoke(%d)", ast.uintValue]];
                }
                else
                {
                    [writer printWithNewLine:@"invoke"];
                }
                break;

            case EMA_POP:
                name = @"pop";
                break;

            case EMA_SET_SYMBOL:
                if (ast.stringValue.length > 0)
                {
                    [writer printWithNewLine:[NSString stringWithFormat:@"setSymbol('%@')", ast.stringValue]];
                }
                else
                {
                    [writer printWithNewLine:@"setSymbol"];
                }
                break;

            case EMA_SWAP:
                name = @"swap";
                break;

            case EMA_ADD:
                name = @"add";
                break;

            case EMA_SUB:
                name = @"sub";
                break;

            case EMA_MUL:
                name = @"mul";
                break;

            case EMA_DIV:
                name = @"div";
                break;
                
            case EMA_MOD:
                name = @"mod";
                break;
                
            case EMA_NEG:
                [writer printWithNewLine:@"-"];

                [writer increaseIndent];
                [self descriptionForNode:ast.nodeValue withWriter:writer];

                [writer decreaseIndent];
                break;

            case EMA_MARK:
                name = @"mark";
                break;

            case EM_BOOLEAN:
            {
                NSString *text = (ast.booleanValue) ? @"true" : @"false";

                [writer printWithNewLine:[NSString stringWithFormat:@"%@", text]];
                break;
            }

            case EM_PARAMETER:
            {
                id<PXExpressionNode> defaultValue = ast.nodeValue;

                [writer print:ast.stringValue];

                if (defaultValue.type != EM_UNDEFINED)
                {
                    [writer print:@"="];
                    [writer print:[self descriptionForNode:defaultValue]];
                }
                break;
            }

            default:
                NSLog(@"Unrecognized EM node type: %d", ast.type);
        }

        if (name.length > 0)
        {
            [writer printWithNewLine:name];

            if (ast.nodeValue != nil && ast.nodeValue2 != nil)
            {
                [writer increaseIndent];
                [self descriptionForNode:ast.nodeValue withWriter:writer];
                [self descriptionForNode:ast.nodeValue2 withWriter:writer];

                [writer decreaseIndent];
            }
        }
    }
}

@end
