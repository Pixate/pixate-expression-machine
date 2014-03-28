//
//  PXInstructionDisassembler.m
//  Protostyle
//
//  Created by Kevin Lindsey on 3/8/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXInstructionDisassembler.h"
#import "PXPushValueInstruction.h"

@implementation PXInstructionDisassembler

- (NSString *)disassembleInstruction:(PXExpressionInstruction *)instruction
{
    switch (instruction.type)
    {
        case EM_INSTRUCTION_BREAK:
            return @"break";
            
        // arrays

        case EM_INSTRUCTION_ARRAY_CREATE:
            return (_useShortForm) ? @"]" : @"createArray";

        case EM_INSTRUCTION_ARRAY_CREATE_WITH_COUNT:
            return (_useShortForm)
                ? [NSString stringWithFormat:@"](%d)", instruction.uintValue]
                : [NSString stringWithFormat:@"createArray(%d)", instruction.uintValue];

        case EM_INSTRUCTION_ARRAY_GET_ELEMENT:
            return @"getElement";

        case EM_INSTRUCTION_ARRAY_GET_ELEMENT_AT_INDEX:
            return [NSString stringWithFormat:@"getElement(%d)", instruction.uintValue];

        // objects

        case EM_INSTRUCTION_OBJECT_CREATE:
            return (_useShortForm) ? @"]}" : @"createObject";

        case EM_INSTRUCTION_OBJECT_CREATE_WITH_COUNT:
            return (_useShortForm)
                ? [NSString stringWithFormat:@"]}(%d)", instruction.uintValue]
                : [NSString stringWithFormat:@"createObject(%d)", instruction.uintValue];

        case EM_INSTRUCTION_OBJECT_GET_PROPERTY:
            return (_useShortForm) ? @"." : @"getProperty";

        case EM_INSTRUCTION_OBJECT_GET_PROPERTY_NAME:
            return (_useShortForm)
                ? [NSString stringWithFormat:@".'%@'", instruction.stringValue]
                : [NSString stringWithFormat:@"getProperty('%@')", instruction.stringValue];

        // functions

        case EM_INSTRUCTION_FUNCTION_APPLY:
            return (_useShortForm) ? @"<" : @"apply";

        case EM_INSTRUCTION_FUNCTION_APPLY_NAME:
            return (_useShortForm)
                ? [NSString stringWithFormat:@"<'%@'", instruction.stringValue]
                : [NSString stringWithFormat:@"apply('%@')", instruction.stringValue];

        case EM_INSTRUCTION_FUNCTION_INVOKE:
            return (_useShortForm) ? @">" : @"invoke";

        case EM_INSTRUCTION_FUNCTION_INVOKE_WITH_COUNT:
            return (_useShortForm)
                ? [NSString stringWithFormat:@">(%d)", instruction.uintValue]
                : [NSString stringWithFormat:@"invoke(%d)", instruction.uintValue];

        case EM_INSTRUCTION_FUNCTION_INVOKE_NAME:
            return (_useShortForm)
                ? [NSString stringWithFormat:@">'%@'", instruction.stringValue]
                : [NSString stringWithFormat:@"invoke('%@')", instruction.stringValue];

        case EM_INSTRUCTION_FUNCTION_INVOKE_NAME_WITH_COUNT:
            return (_useShortForm)
                ? [NSString stringWithFormat:@">'%@'(%d)", instruction.stringValue, instruction.uintValue]
                : [NSString stringWithFormat:@"invoke('%@', %d)", instruction.stringValue, instruction.uintValue];

        // blocks

        case EM_INSTRUCTION_BLOCK_EXECUTE:
            return @"exec";

        // stack

        case EM_INSTRUCTION_STACK_POP:
            return @"pop";

        case EM_INSTRUCTION_STACK_PUSH:
        {
            PXPushValueInstruction *pushInstruction = (PXPushValueInstruction *)instruction;
            
            return (_useShortForm)
                ? pushInstruction.value.description
                : [NSString stringWithFormat:@"push(%@)", pushInstruction.value.description];
        }

        case EM_INSTRUCTION_STACK_PUSH_GLOBAL:
            return @"push(global)";

        case EM_INSTRUCTION_STACK_SWAP:
            return @"swap";

        case EM_INSTRUCTION_STACK_DUPLICATE:
            return @"dup";

        // scope

        case EM_INSTRUCTION_SCOPE_GET_SYMBOL:
            return (_useShortForm) ? @"^" : @"getSymbol";

        case EM_INSTRUCTION_SCOPE_GET_SYMBOL_NAME:
            return (_useShortForm)
                ? [NSString stringWithFormat:@"^'%@'", instruction.stringValue]
                : [NSString stringWithFormat:@"getSymbol('%@')", instruction.stringValue];

        case EM_INSTRUCTION_SCOPE_SET_SYMBOL:
            return (_useShortForm) ? @"^=" : @"setSymbol";

        case EM_INSTRUCTION_SCOPE_SET_SYMBOL_NAME:
            return (_useShortForm)
                ? [NSString stringWithFormat:@"^='%@'", instruction.stringValue]
                : [NSString stringWithFormat:@"setSymbol('%@')", instruction.stringValue];

        // math

        case EM_INSTRUCTION_MATH_ADDITION:
            return @"add";
            break;

        case EM_INSTRUCTION_MATH_SUBTRACTION:
            return @"sub";
            break;

        case EM_INSTRUCTION_MATH_MULTIPLICATION:
            return @"mul";
            break;

        case EM_INSTRUCTION_MATH_DIVISION:
            return @"div";
            break;

        case EM_INSTRUCTION_MATH_NEGATE:
            return @"neg";
            break;

        // boolean

        case EM_INSTRUCTION_BOOLEAN_AND:
            return @"and";
            break;

        case EM_INSTRUCTION_BOOLEAN_OR:
            return @"or";
            break;

        case EM_INSTRUCTION_BOOLEAN_NOT:
            return @"not";
            break;

        // comparisons

        case EM_INSTRUCTION_COMPARISON_LESS_THAN:
            return @"lt";
            break;

        case EM_INSTRUCTION_COMPARISON_LESS_THAN_EQUAL:
            return @"le";
            break;

        case EM_INSTRUCTION_COMPARISON_EQUAL:
            return @"eq";
            break;

        case EM_INSTRUCTION_COMPARISON_NOT_EQUAL:
            return @"ne";
            break;

        case EM_INSTRUCTION_COMPARISON_GREATER_THAN_EQUAL:
            return @"ge";
            break;

        case EM_INSTRUCTION_COMPARISON_GREATER_THAN:
            return @"gt";
            break;

        // flow
            
        case EM_INSTRUCTION_FLOW_IF:
            return @"if";
            
        case EM_INSTRUCTION_FLOW_IF_ELSE:
            return @"ifelse";
            
        default:
            NSLog(@"Unknown instruction type: %ld", (long) instruction.type);
            return @"";
    }
}

@end
