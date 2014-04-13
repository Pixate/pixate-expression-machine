//
//  PXByteCodeOptimizer.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 4/5/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXByteCodeOptimizer.h"
#import "PXExpressionInstruction.h"
#import "PXPushValueInstruction.h"

@implementation PXByteCodeOptimizer
{
    NSMutableSet *branchTargets_;
}

- (PXExpressionByteCode *)optimizeByteCode:(PXExpressionByteCode *)byteCode
{
    NSArray *instructions = [self optimizeInstructions:byteCode.instructions];

    return [[PXExpressionByteCode alloc] initWithInstructions:instructions];
}

- (NSArray *)optimizeInstructions:(NSArray *)instructions
{
    NSMutableArray *result = [[NSMutableArray alloc] init];

    // tag branch targets
    branchTargets_ = [[NSMutableSet alloc] init];

    [instructions enumerateObjectsUsingBlock:^(PXExpressionInstruction *instruction, NSUInteger idx, BOOL *stop) {

        switch (instruction.type)
        {
            case EM_INSTRUCTION_BRANCH:
            case EM_INSTRUCTION_BRANCH_IF_TRUE:
            case EM_INSTRUCTION_BRANCH_IF_FALSE:
                [branchTargets_ addObject:[instructions objectAtIndex:idx + instruction.intValue + 1]];
                break;

            default:
                break;
        }
    }];

    [instructions enumerateObjectsUsingBlock:^(PXExpressionInstruction *instruction, NSUInteger idx, BOOL *stop) {
        PXExpressionInstruction *last = [result lastObject];

        if ([branchTargets_ containsObject:instruction])
        {
            [result addObject:instruction];
            return;
        }

        instruction = [instruction copy];

        // handle push
        switch (instruction.type)
        {
            case EM_INSTRUCTION_STACK_PUSH:
                if (last.type == EM_INSTRUCTION_STACK_PUSH)
                {
                    PXPushValueInstruction *currentPush = (PXPushValueInstruction *)instruction;
                    PXPushValueInstruction *lastPush = (PXPushValueInstruction *)last;

                    [lastPush pushValue:currentPush.value];
                }
                else
                {
                    [result addObject:instruction];
                }
                break;

            case EM_INSTRUCTION_SCOPE_GET_SYMBOL_NAME:
                if (last.type == EM_INSTRUCTION_SCOPE_GET_SYMBOL_NAME)
                {
                    [last pushStringValue:instruction.stringValue];
                }
                else if (last.type == EM_INSTRUCTION_SCOPE_SET_SYMBOL_NAME && [last.stringValue isEqualToString:instruction.stringValue])
                {
                    [result removeLastObject];
                    [result addObject:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_STACK_DUPLICATE]];
                    [result addObject:last];
                }
                else
                {
                    [result addObject:instruction];
                }
                break;

            case EM_INSTRUCTION_OBJECT_GET_PROPERTY_NAME:
                switch (last.type)
                {
                    case EM_INSTRUCTION_OBJECT_GET_PROPERTY_NAME:
                    case EM_INSTRUCTION_MIX_GET_SYMBOL_PROPERTY:
                        [last pushStringValue:instruction.stringValue];
                        break;

                    case EM_INSTRUCTION_SCOPE_GET_SYMBOL_NAME:
                    {
                        NSString *symbol = (last.stringValue.length > 0) ? last.stringValue : [last popStringValue];
                        PXExpressionInstruction *getSymbolProperty = [[PXExpressionInstruction alloc]
                                                                      initWithType:EM_INSTRUCTION_MIX_GET_SYMBOL_PROPERTY
                                                                      stringValue:symbol];

                        [getSymbolProperty pushStringValue:instruction.stringValue preservingStringValue:YES];

                        if (last.stringValue.length > 0)
                        {
                            [result removeLastObject];
                        }
                        [result addObject:getSymbolProperty];
                        break;
                    }

                    default:
                        [result addObject:instruction];
                        break;
                }
                break;

            case EM_INSTRUCTION_FUNCTION_INVOKE_WITH_COUNT:
                if (last.type == EM_INSTRUCTION_OBJECT_GET_PROPERTY_NAME)
                {
                    if (result.count > 2)
                    {
                        PXExpressionInstruction *backTwo = [result objectAtIndex:result.count - 2];

                        if (backTwo.type == EM_INSTRUCTION_STACK_DUPLICATE)
                        {
                            // let next if-block handle things for us
                            PXExpressionInstruction *backThree = [result objectAtIndex:result.count - 3];

                            if (backThree.type == EM_INSTRUCTION_MIX_GET_SYMBOL_PROPERTY)
                            {
                                PXExpressionInstruction *invoke = [[PXExpressionInstruction alloc]
                                                                   initWithType:EM_INSTRUCTION_MIX_INVOKE_SYMBOL_PROPERTY_WITH_COUNT
                                                                   stringValue:backThree.stringValue uint:instruction.uintValue];

                                [backThree.stringValues enumerateObjectsUsingBlock:^(NSString *value, NSUInteger idx, BOOL *stop) {
                                    [invoke pushStringValue:value preservingStringValue:YES];
                                }];

                                [invoke pushStringValue:last.stringValue];

                                [result removeLastObject];  // getPropertyName
                                [result removeLastObject];  // dup
                                [result removeLastObject];  // getSymbolProperty
                                [result addObject:invoke];
                            }
                            else if (backThree.type == EM_INSTRUCTION_SCOPE_GET_SYMBOL_NAME)
                            {
                                NSString *symbol = (backThree.stringValue.length > 0) ? backThree.stringValue : [backThree popStringValue];
                                PXExpressionInstruction *invoke = [[PXExpressionInstruction alloc]
                                                                   initWithType:EM_INSTRUCTION_MIX_INVOKE_SYMBOL_PROPERTY_WITH_COUNT
                                                                   stringValue:symbol uint:instruction.uintValue];

                                [invoke pushStringValue:last.stringValue preservingStringValue:YES];

                                [result removeLastObject];  // getPropertyName
                                [result removeLastObject];  // dup
                                if (backThree.stringValue.length > 0)
                                {
                                    [result removeLastObject];  // getSymbolName
                                }

                                [result addObject:invoke];
                            }
                            else
                            {
                                [result addObject:instruction];
                            }
                        }
                    }
                    else
                    {
                        [result addObject:instruction];
                    }
                }
                else if (last.type == EM_INSTRUCTION_MIX_GET_SYMBOL_PROPERTY)
                {
                    PXExpressionInstruction *invoke = [[PXExpressionInstruction alloc]
                                                       initWithType:EM_INSTRUCTION_MIX_INVOKE_SYMBOL_PROPERTY_WITH_COUNT
                                                       stringValue:last.stringValue uint:instruction.uintValue];

                    [last.stringValues enumerateObjectsUsingBlock:^(NSString *value, NSUInteger idx, BOOL *stop) {
                        [invoke pushStringValue:value preservingStringValue:YES];
                    }];

                    [result removeLastObject];
                    [result addObject:invoke];
                }
                else
                {
                    [result addObject:instruction];
                }
                break;

            default:
                [result addObject:instruction];
                break;
        }
    }];

    return [result copy];
}

@end
