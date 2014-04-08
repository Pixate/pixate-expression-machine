//
//  PXExpressionInstruction.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/8/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionInstruction.h"

@implementation PXExpressionInstruction
{
    NSMutableArray *stringValues_;
}

#pragma mark - Initializers

- (id)initWithType:(PXExpressionInstructionType)type
{
    return [self initWithType:type stringValue:nil uint:0];
}
- (id)initWithType:(PXExpressionInstructionType)type stringValue:(NSString *)stringValue
{
    return [self initWithType:type stringValue:stringValue uint:0];
}

- (id)initWithType:(PXExpressionInstructionType)type uint:(uint)uintValue
{
    return [self initWithType:type stringValue:nil uint:uintValue];
}

- (id)initWithType:(PXExpressionInstructionType)type stringValue:(NSString *)stringValue uint:(uint)uintValue
{
    if (self = [super init])
    {
        _type = type;
        _stringValue = stringValue;
        _uintValue = uintValue;
    }

    return self;
}

- (id)initWithType:(PXExpressionInstructionType)type intValue:(int)intValue
{
    if (self = [super init])
    {
        _type = type;
        _intValue = intValue;
    }

    return self;
}

#pragma mark - Methods

- (void)pushStringValue:(NSString *)stringValue
{
    [self pushStringValue:stringValue preservingStringValue:NO];
}

- (void)pushStringValue:(NSString *)stringValue preservingStringValue:(BOOL)preserve
{
    if (stringValues_ == nil)
    {
        stringValues_ = [[NSMutableArray alloc] init];

        if (preserve == NO && _stringValue != nil)
        {
            [stringValues_ addObject:_stringValue];
            _stringValue = nil;
        }
    }

    [stringValues_ addObject:stringValue];
}

- (NSString *)popStringValue
{
    NSString *result = nil;

    if (stringValues_.count > 0)
    {
        result = [stringValues_ lastObject];
        [stringValues_ removeLastObject];
    }

    return result;
}

#pragma mark - Getters

- (NSArray *)stringValues
{
    return [stringValues_ copy];
}

#pragma mark - Overrides

- (NSString *)description
{
    switch (_type)
    {
        case EM_INSTRUCTION_BREAK: return @"BREAK";

        // arrays
        case EM_INSTRUCTION_ARRAY_CREATE: return @"ARRAY_CREATE";
        case EM_INSTRUCTION_ARRAY_CREATE_WITH_COUNT: return @"ARRAY_CREATE_WITH_COUNT";
        case EM_INSTRUCTION_ARRAY_GET_ELEMENT: return @"ARRAY_GET_ELEMENT";
        case EM_INSTRUCTION_ARRAY_GET_ELEMENT_AT_INDEX: return @"ARRAY_GET_ELEMENT_AT_INDEX";

        // objects
        case EM_INSTRUCTION_OBJECT_CREATE: return @"OBJECT_CREATE";
        case EM_INSTRUCTION_OBJECT_CREATE_WITH_COUNT: return @"OBJECT_CREATE_WITH_COUNT";
        case EM_INSTRUCTION_OBJECT_GET_PROPERTY: return @"OBJECT_GET_PROPERTY";
        case EM_INSTRUCTION_OBJECT_GET_PROPERTY_NAME: return @"OBJECT_GET_PROPERTY_NAME";

        // functions
        case EM_INSTRUCTION_FUNCTION_APPLY: return @"FUNCTION_APPLY";
        case EM_INSTRUCTION_FUNCTION_APPLY_NAME: return @"FUNCTION_APPLY_NAME";
        case EM_INSTRUCTION_FUNCTION_INVOKE: return @"FUNCTION_INVOKE";
        case EM_INSTRUCTION_FUNCTION_INVOKE_WITH_COUNT: return @"FUNCTION_INVOKE_WITH_COUNT";
        case EM_INSTRUCTION_FUNCTION_INVOKE_NAME: return @"FUNCTION_INVOKE_NAME";
        case EM_INSTRUCTION_FUNCTION_INVOKE_NAME_WITH_COUNT: return @"FUNCTION_INVOKE_NAME_WITH_COUNT";

        // blocks
        case EM_INSTRUCTION_BLOCK_EXECUTE: return @"BLOCK_EXECUTE";

        // stack
        case EM_INSTRUCTION_STACK_POP: return @"STACK_POP";
        case EM_INSTRUCTION_STACK_PUSH: return @"STACK_PUSH";
        case EM_INSTRUCTION_STACK_PUSH_GLOBAL: return @"STACK_PUSH_GLOBAL";
        case EM_INSTRUCTION_STACK_SWAP: return @"STACK_SWAP";
        case EM_INSTRUCTION_STACK_DUPLICATE: return @"STACK_DUPLICATE";

        // scope
        case EM_INSTRUCTION_SCOPE_GET_SYMBOL: return @"SCOPE_GET_SYMBOL";
        case EM_INSTRUCTION_SCOPE_GET_SYMBOL_NAME: return @"SCOPE_GET_SYMBOL_NAME";
        case EM_INSTRUCTION_SCOPE_SET_SYMBOL: return @"SCOPE_SET_SYMBOL";
        case EM_INSTRUCTION_SCOPE_SET_SYMBOL_NAME: return @"SCOPE_SET_SYMBOL_NAME";

        // math
        case EM_INSTRUCTION_MATH_ADDITION: return @"MATH_ADDITION";
        case EM_INSTRUCTION_MATH_SUBTRACTION: return @"MATH_SUBTRACTION";
        case EM_INSTRUCTION_MATH_MULTIPLICATION: return @"MATH_MULTIPLICATION";
        case EM_INSTRUCTION_MATH_DIVISION: return @"MATH_DIVISION";
        case EM_INSTRUCTION_MATH_NEGATE: return @"MATH_NEGATE";

        // boolean
        case EM_INSTRUCTION_BOOLEAN_AND: return @"BOOLEAN_AND";
        case EM_INSTRUCTION_BOOLEAN_OR: return @"BOOLEAN_OR";
        case EM_INSTRUCTION_BOOLEAN_NOT: return @"BOOLEAN_NOT";

        // comparisons
        case EM_INSTRUCTION_COMPARISON_LESS_THAN: return @"COMPARISON_LESS_THAN";
        case EM_INSTRUCTION_COMPARISON_LESS_THAN_EQUAL: return @"COMPARISON_LESS_THAN_EQUAL";
        case EM_INSTRUCTION_COMPARISON_EQUAL: return @"COMPARISON_EQUAL";
        case EM_INSTRUCTION_COMPARISON_NOT_EQUAL: return @"COMPARISON_NOT_EQUAL";
        case EM_INSTRUCTION_COMPARISON_GREATER_THAN_EQUAL: return @"COMPARISON_GREATER_THAN_EQUAL";
        case EM_INSTRUCTION_COMPARISON_GREATER_THAN: return @"COMPARISON_GREATER_THAN";

        // flow
        case EM_INSTRUCTION_FLOW_IF: return @"FLOW_IF";
        case EM_INSTRUCTION_FLOW_IF_ELSE: return @"FLOW_IF_ELSE";
        case EM_INSTRUCTION_BRANCH: return @"BRANCH";
        case EM_INSTRUCTION_BRANCH_IF_TRUE: return @"BRANCH_IF_TRUE";
        case EM_INSTRUCTION_BRANCH_IF_FALSE: return @"BRANCH_IF_FALSE";

        // mix
        case EM_INSTRUCTION_MIX_GET_SYMBOL_PROPERTY: return @"GET_SYMBOL_PROPERTY";
        case EM_INSTRUCTION_MIX_INVOKE_SYMBOL_PROPERTY_WITH_COUNT: return @"INVOKE_SYMBOL_PROPERTY_WITH_COUNT";

        default:
            return [NSString stringWithFormat:@"Unknown instruction type: %ld", (long) _type];
    }
}

#pragma mark - NSCopying Implementation

- (id)copyWithZone:(NSZone *)zone
{
    PXExpressionInstruction *result = [[PXExpressionInstruction alloc] init];

    result->_type = _type;
    result->_stringValue = _stringValue;
    result->stringValues_ = (stringValues_ != nil) ? [NSMutableArray arrayWithArray:stringValues_] : nil;
    result->_uintValue = _uintValue;
    result->_intValue = _intValue;

    return result;
}

@end
