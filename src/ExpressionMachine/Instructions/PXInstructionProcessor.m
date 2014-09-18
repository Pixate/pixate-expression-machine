//
//  PXInstructionProcessor.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/8/14.
//  Copyright (c) 2014 Pixate: Inc. All rights reserved.
//

#import "PXInstructionProcessor.h"
#import "PXExpressionInstructionType.h"
#import "PXPushValueInstruction.h"
#import "PXInstructionDisassembler.h"

#import "PXArrayValue.h"
#import "PXBlockValue.h"
#import "PXDoubleValue.h"
#import "PXObjectValue.h"
#import "PXUndefinedValue.h"

#import "PXExpressionFunction.h"
#import "PXExpressionObject.h"

@implementation PXInstructionProcessor

- (void)processInstructions:(NSArray *)instructions withEnvironment:(PXExpressionEnvironment *)env
{
    typedef void (*InstructionProcessor)(id object, SEL selector, PXExpressionInstruction *instruction, PXExpressionEnvironment *environment);

    static SEL runnerSelector;
    static InstructionProcessor runner;
    static PXInstructionDisassembler *disassembler;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        runnerSelector = @selector(processInstruction:withEnvironment:);
        runner = (InstructionProcessor) [self methodForSelector:runnerSelector];
        disassembler = [[PXInstructionDisassembler alloc] init];
    });

    [instructions enumerateObjectsUsingBlock:^(PXExpressionInstruction *instruction, NSUInteger idx, BOOL *stop) {
        // TODO: runtime errors
        //NSLog(@"%@", [disassembler disassembleInstruction:instruction]);
        // [processor processInstruction:instruction withEnvironment:env];
        runner(self, runnerSelector, instruction, env);
        //NSLog(@"stack: %@", [env stackDescription]);
    }];
}

- (void)processInstruction:(PXExpressionInstruction *)instruction withEnvironment:(PXExpressionEnvironment *)env
{
    switch (instruction.type)
    {
        case EM_INSTRUCTION_BREAK:
            NSLog(@"break!");
            break;

#pragma mark Arrays

        case EM_INSTRUCTION_ARRAY_CREATE:
            [env pushValue:[PXArrayValue arrayFromEnvironment:env]];
            break;

        case EM_INSTRUCTION_ARRAY_CREATE_WITH_COUNT:
            [env pushValue:[PXArrayValue arrayFromEnvironment:env withCount:instruction.uintValue]];
            break;

        case EM_INSTRUCTION_ARRAY_GET_ELEMENT:
        {
            id<PXExpressionValue> index = [env popValue];
            id<PXExpressionValue> item = [env popValue];
            id<PXExpressionValue> result = [PXUndefinedValue undefined];

            if (index.valueType == PX_VALUE_TYPE_DOUBLE && [item conformsToProtocol:@protocol(PXExpressionArray)])
            {
                id<PXExpressionArray> array = (id<PXExpressionArray>)item;

                result = [array valueForIndex:(uint)index.doubleValue];
            }

            [env pushValue:result];

            break;
        }

        case EM_INSTRUCTION_ARRAY_GET_ELEMENT_AT_INDEX:
        {
            id<PXExpressionValue> item = [env popValue];
            id<PXExpressionValue> result = [PXUndefinedValue undefined];

            if ([item conformsToProtocol:@protocol(PXExpressionArray)])
            {
                id<PXExpressionArray> array = (id<PXExpressionArray>)item;

                result = [array valueForIndex:instruction.uintValue];
            }

            [env pushValue:result];

            break;
        }

#pragma mark Objects

        case EM_INSTRUCTION_OBJECT_CREATE:
            [env pushValue:[PXObjectValue objectFromEnvironment:env]];
            break;

        case EM_INSTRUCTION_OBJECT_CREATE_WITH_COUNT:
            [env pushValue:[PXObjectValue objectFromEnvironment:env withCount:instruction.uintValue]];
            break;

        case EM_INSTRUCTION_OBJECT_GET_PROPERTY:
        {
            id<PXExpressionValue> name = [env popValue];
            id<PXExpressionValue> item = [env popValue];
            id<PXExpressionValue> result = [PXUndefinedValue undefined];

            if ([item conformsToProtocol:@protocol(PXExpressionObject)])
            {
                id<PXExpressionObject> object = (id<PXExpressionObject>)item;

                result = [object valueForPropertyName:name.stringValue];
            }

            [env pushValue:result];

            break;
        }

        case EM_INSTRUCTION_OBJECT_GET_PROPERTY_NAME:
        {
            id<PXExpressionValue> item = [env popValue];
            id<PXExpressionValue> result = [PXUndefinedValue undefined];

            if ([item conformsToProtocol:@protocol(PXExpressionObject)])
            {
                __block id<PXExpressionObject> object = (id<PXExpressionObject>)item;

                if (instruction.stringValue != nil)
                {
                    result = [object valueForPropertyName:instruction.stringValue];
                }
                else
                {
                    [instruction.stringValues enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
                        id<PXExpressionValue> value = [object valueForPropertyName:name];

                        if ([value conformsToProtocol:@protocol(PXExpressionObject)])
                        {
                            object = (id<PXExpressionObject>)value;
                        }
                        else
                        {
                            object = nil;
                            *stop = YES;
                        }
                    }];

                    result = (object != nil) ? object : [PXUndefinedValue undefined];
                }
            }

            [env pushValue:result];

            break;
        }

#pragma mark Functions

        case EM_INSTRUCTION_FUNCTION_APPLY:
        {
            id<PXExpressionValue> item = [env popValue];
            id<PXExpressionValue> invocationObject = [env popValue];
            id<PXExpressionValue> args = [env popValue];

            if (item.valueType == PX_VALUE_TYPE_FUNCTION && args.valueType == PX_VALUE_TYPE_ARRAY)
            {
                id<PXExpressionFunction> function = (id<PXExpressionFunction>)item;
                id<PXExpressionArray> array = (id<PXExpressionArray>)args;

                [function invokeWithEnvironment:env invocationObject:invocationObject args:array];
            }
            else
            {
                [env logMessage:@"apply expects a function followed by an array on the stack"];
            }

            break;
        }

        case EM_INSTRUCTION_FUNCTION_APPLY_NAME:
        {
            id<PXExpressionValue> item = [env getSymbol:instruction.stringValue];
            id<PXExpressionValue> invocationObject = env.globalObject;
            id<PXExpressionValue> args = [env popValue];

            if (item.valueType == PX_VALUE_TYPE_FUNCTION && args.valueType == PX_VALUE_TYPE_ARRAY)
            {
                id<PXExpressionFunction> function = (id<PXExpressionFunction>)item;
                id<PXExpressionArray> array = (id<PXExpressionArray>)args;

                [function invokeWithEnvironment:env invocationObject:invocationObject args:array];
            }
            else
            {
                [env logMessage:@"apply expects a function followed by an array on the stack"];
            }

            break;
        }

        case EM_INSTRUCTION_FUNCTION_INVOKE:
        {
            id<PXExpressionValue> item = [env popValue];
            id<PXExpressionValue> invocationObject = [env popValue];
            PXArrayValue *args = [PXArrayValue arrayFromEnvironment:env];

            // execute function, if we can
            if (item.valueType == PX_VALUE_TYPE_FUNCTION)
            {
                id<PXExpressionFunction> function = (id<PXExpressionFunction>) item;

                [function invokeWithEnvironment:env invocationObject:invocationObject args:args];
            }

            break;
        }

        case EM_INSTRUCTION_FUNCTION_INVOKE_WITH_COUNT:
        {
            id<PXExpressionValue> item = [env popValue];
            id<PXExpressionValue> invocationObject = [env popValue];
            PXArrayValue *args = [PXArrayValue arrayFromEnvironment:env withCount:instruction.uintValue];

            // execute function, if we can
            if (item.valueType == PX_VALUE_TYPE_FUNCTION)
            {
                id<PXExpressionFunction> function = (id<PXExpressionFunction>) item;

                [function invokeWithEnvironment:env invocationObject:invocationObject args:args];
            }

            break;
        }

        case EM_INSTRUCTION_FUNCTION_INVOKE_NAME:
        {
            id<PXExpressionValue> item = [env getSymbol:instruction.stringValue];
            id<PXExpressionValue> invocationObject = env.globalObject;
            PXArrayValue *args = [PXArrayValue arrayFromEnvironment:env];

            // execute function, if we can
            if (item.valueType == PX_VALUE_TYPE_FUNCTION)
            {
                id<PXExpressionFunction> function = (id<PXExpressionFunction>) item;

                [function invokeWithEnvironment:env invocationObject:invocationObject args:args];
            }

            break;
        }

        case EM_INSTRUCTION_FUNCTION_INVOKE_NAME_WITH_COUNT:
        {
            id<PXExpressionValue> item = [env getSymbol:instruction.stringValue];
            id<PXExpressionValue> invocationObject = env.globalObject;
            PXArrayValue *args = [PXArrayValue arrayFromEnvironment:env withCount:instruction.uintValue];

            // execute function, if we can
            if (item.valueType == PX_VALUE_TYPE_FUNCTION)
            {
                id<PXExpressionFunction> function = (id<PXExpressionFunction>) item;

                [function invokeWithEnvironment:env invocationObject:invocationObject args:args];
            }

            break;
        }

#pragma mark Blocks

        case EM_INSTRUCTION_BLOCK_EXECUTE:
        {
            // grab block
            id<PXExpressionValue> item = [env popValue];

            // execute block, if we can
            if (item.valueType == PX_VALUE_TYPE_BLOCK)
            {
                PXBlockValue *block = (PXBlockValue *)item;

                [env executeByteCode:block.byteCodeValue];
            }

            break;
        }

#pragma mark Stack

        case EM_INSTRUCTION_STACK_POP:
            [env popValue];
            break;

        case EM_INSTRUCTION_STACK_PUSH:
        {
            typedef void (*PushValue)(id object, SEL cmd, id<PXExpressionValue> value);
            static SEL pushSelector;
            static PushValue pushImp;

            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                pushSelector = @selector(pushValue:);
                pushImp = (PushValue)[env methodForSelector:pushSelector];
            });

            PXPushValueInstruction *pushInstruction = (PXPushValueInstruction *)instruction;

            if (pushInstruction.value != nil)
            {
                pushImp(env, pushSelector, pushInstruction.value);
                // [env pushValue:pushInstruction.value];
            }
            else
            {
                [pushInstruction.values enumerateObjectsUsingBlock:^(id<PXExpressionValue> value, NSUInteger idx, BOOL *stop) {
                    pushImp(env, pushSelector, value);
                }];
            }
            break;
        }

        case EM_INSTRUCTION_STACK_PUSH_GLOBAL:
            [env pushGlobal];
            break;

        case EM_INSTRUCTION_STACK_SWAP:
            [env swapValues];
            break;

        case EM_INSTRUCTION_STACK_DUPLICATE:
            [env duplicateValue];
            break;

#pragma mark Scope

        case EM_INSTRUCTION_SCOPE_GET_SYMBOL:
        {
            id<PXExpressionValue> value = [env popValue];

            [env pushValue:[env getSymbol:value.stringValue]];
            break;
        }

        case EM_INSTRUCTION_SCOPE_GET_SYMBOL_NAME:
        {
            if (instruction.stringValue != nil)
            {
                [env pushValue:[env getSymbol:instruction.stringValue]];
            }
            else
            {
                [instruction.stringValues enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
                    [env pushValue:[env getSymbol:name]];
                }];
            }
            break;
        }

        case EM_INSTRUCTION_SCOPE_SET_SYMBOL:
        {
            id<PXExpressionValue> value = [env popValue];
            id<PXExpressionValue> name = [env popValue];

            [env setValue:value forSymbol:name.stringValue];
            break;
        }

        case EM_INSTRUCTION_SCOPE_SET_SYMBOL_NAME:
        {
            id<PXExpressionValue> value = [env popValue];

            [env setValue:value forSymbol:instruction.stringValue];
            break;
        }

#pragma mark Math
        case EM_INSTRUCTION_MATH_ADDITION:
            [env pushDouble:[env popValue].doubleValue + [env popValue].doubleValue];
            break;

        case EM_INSTRUCTION_MATH_SUBTRACTION:
        {
            id<PXExpressionValue> b = [env popValue];
            id<PXExpressionValue> a = [env popValue];

            [env pushDouble:a.doubleValue - b.doubleValue];
            break;
        }

        case EM_INSTRUCTION_MATH_MULTIPLICATION:
            [env pushDouble:[env popValue].doubleValue * [env popValue].doubleValue];
            break;

        case EM_INSTRUCTION_MATH_DIVISION:
        {
            id<PXExpressionValue> b = [env popValue];
            id<PXExpressionValue> a = [env popValue];

            if (b.doubleValue == 0.0)
            {
                [env pushDouble:NAN];
            }
            else
            {
                [env pushDouble:a.doubleValue / b.doubleValue];
            }
            break;
        }
            
        case EM_INSTRUCTION_MATH_MODULUS:
        {
            id<PXExpressionValue> b = [env popValue];
            id<PXExpressionValue> a = [env popValue];
            
            if (b.doubleValue == 0.0)
            {
                [env pushDouble:NAN];
            }
            else
            {
                [env pushDouble:(NSInteger)(a.doubleValue) % (NSInteger)(b.doubleValue)];
            }
            break;
        }

        case EM_INSTRUCTION_MATH_NEGATE:
            [env pushDouble:-[env popValue].doubleValue];
            break;

#pragma mark Boolean
        case EM_INSTRUCTION_BOOLEAN_AND:
        {
            BOOL b = [env popValue].booleanValue;
            BOOL a = [env popValue].booleanValue;
            [env pushBoolean:a && b];
            break;
        }

        case EM_INSTRUCTION_BOOLEAN_OR:
        {
            BOOL b = [env popValue].booleanValue;
            BOOL a = [env popValue].booleanValue;
            [env pushBoolean:a || b];
            break;
        }

        case EM_INSTRUCTION_BOOLEAN_NOT:
            [env pushBoolean:![env popValue].booleanValue];
            break;

#pragma mark Comparisons
        case EM_INSTRUCTION_COMPARISON_LESS_THAN:
        {
            id<PXExpressionValue> b = [env popValue];
            id<PXExpressionValue> a = [env popValue];

            [env pushBoolean:a.doubleValue < b.doubleValue];
            break;
        }

        case EM_INSTRUCTION_COMPARISON_LESS_THAN_EQUAL:
        {
            id<PXExpressionValue> b = [env popValue];
            id<PXExpressionValue> a = [env popValue];

            [env pushBoolean:a.doubleValue <= b.doubleValue];
            break;
        }

        case EM_INSTRUCTION_COMPARISON_EQUAL:
        {
            id<PXExpressionValue> b = [env popValue];
            id<PXExpressionValue> a = [env popValue];

            [env pushBoolean:a.doubleValue == b.doubleValue];
            break;
        }

        case EM_INSTRUCTION_COMPARISON_NOT_EQUAL:
        {
            id<PXExpressionValue> b = [env popValue];
            id<PXExpressionValue> a = [env popValue];

            [env pushBoolean:a.doubleValue != b.doubleValue];
            break;
        }

        case EM_INSTRUCTION_COMPARISON_GREATER_THAN_EQUAL:
        {
            id<PXExpressionValue> b = [env popValue];
            id<PXExpressionValue> a = [env popValue];

            [env pushBoolean:a.doubleValue >= b.doubleValue];
            break;
        }

        case EM_INSTRUCTION_COMPARISON_GREATER_THAN:
        {
            id<PXExpressionValue> b = [env popValue];
            id<PXExpressionValue> a = [env popValue];

            [env pushBoolean:a.doubleValue > b.doubleValue];
            break;
        }

#pragma mark Flow

        case EM_INSTRUCTION_FLOW_IF:
        {
            id<PXExpressionValue> trueBlock = [env popValue];
            id<PXExpressionValue> condition = [env popValue];

            if (condition.booleanValue && trueBlock.valueType == PX_VALUE_TYPE_BLOCK)
            {
                PXBlockValue *block = (PXBlockValue *)trueBlock;

                [env executeByteCode:block.byteCodeValue];
            }

            break;
        }

        case EM_INSTRUCTION_FLOW_IF_ELSE:
        {
            id<PXExpressionValue> falseBlock = [env popValue];
            id<PXExpressionValue> trueBlock = [env popValue];
            id<PXExpressionValue> condition = [env popValue];

            if (condition.booleanValue)
            {
                if (trueBlock.valueType == PX_VALUE_TYPE_BLOCK)
                {
                    PXBlockValue *block = (PXBlockValue *)trueBlock;

                    [env executeByteCode:block.byteCodeValue];
                }
            }
            else
            {
                if (falseBlock.valueType == PX_VALUE_TYPE_BLOCK)
                {
                    PXBlockValue *block = (PXBlockValue *)falseBlock;

                    [env executeByteCode:block.byteCodeValue];
                }
            }

            break;
        }

#pragma mark Mix

        case EM_INSTRUCTION_MIX_GET_SYMBOL_PROPERTY:
        {
            // lookup symbol
            id<PXExpressionValue> item = [env getSymbol:instruction.stringValue];
            __block id<PXExpressionValue> result = [PXUndefinedValue undefined];

            if ([item conformsToProtocol:@protocol(PXExpressionObject)])
            {
                __block id<PXExpressionObject> object = (id<PXExpressionObject>)item;

                // lookup properties
                [instruction.stringValues enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
                    id<PXExpressionValue> value = [object valueForPropertyName:name];

                    if (idx == instruction.stringValues.count - 1)
                    {
                        result = value;
                        *stop = YES;
                    }
                    else if ([value conformsToProtocol:@protocol(PXExpressionObject)])
                    {
                        object = (id<PXExpressionObject>)value;
                    }
                    else
                    {
                        object = nil;
                        *stop = YES;
                    }
                }];
            }

            [env pushValue:result];
            break;
        }

        case EM_INSTRUCTION_MIX_INVOKE_SYMBOL_PROPERTY_WITH_COUNT:
        {
            // lookup symbol
            id<PXExpressionValue> item = [env getSymbol:instruction.stringValue];

            if ([item conformsToProtocol:@protocol(PXExpressionObject)])
            {
                __block id<PXExpressionObject> object = (id<PXExpressionObject>)item;
                __block id<PXExpressionObject> invocationObject = nil;
                __block id<PXExpressionFunction> function = nil;

                // lookup properties
                [instruction.stringValues enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
                    id<PXExpressionValue> value = [object valueForPropertyName:name];

                    if ([value conformsToProtocol:@protocol(PXExpressionObject)])
                    {
                        invocationObject = object;
                        object = (id<PXExpressionObject>)value;
                    }
                    else if (idx == instruction.stringValues.count - 1 && value.valueType == PX_VALUE_TYPE_FUNCTION)
                    {
                        invocationObject = object;
                        object = nil;
                        function = (id<PXExpressionFunction>)value;
                        *stop = YES;
                    }
                    else
                    {
                        invocationObject = nil;
                        object = nil;
                        *stop = YES;
                    }
                }];

                // invoke function
                PXArrayValue *args = [PXArrayValue arrayFromEnvironment:env withCount:instruction.uintValue];

                // execute function, if we can
                if (function)
                {
                    [function invokeWithEnvironment:env invocationObject:invocationObject args:args];
                }
            }
            break;
        }

        default:
            NSLog(@"Unknown instruction type: %lu", (unsigned long)instruction.type);
    }
}

@end
