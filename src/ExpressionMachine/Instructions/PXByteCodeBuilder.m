//
//  PXByteCodeBuilder.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/27/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXByteCodeBuilder.h"

#import "PXBlockValue.h"
#import "PXMarkValue.h"
#import "PXNullValue.h"
#import "PXUndefinedValue.h"

#import "PXExpressionUnit.h"
#import "PXExpressionByteCode.h"

#import "PXExpressionInstruction.h"
#import "PXPushValueInstruction.h"
#import "PXExpressionInstructionType.h"

#import "PXExpressionAssembler.h"
#import "PXExpressionNode.h"
#import "PXExpressionParser.h"
#import "PXByteCodeOptimizer.h"

@interface PXByteCodeBuilder ()
@property (nonatomic, strong) NSMutableArray *instructions;
@end

@implementation PXByteCodeBuilder

#pragma mark - Initializers

- (id)init
{
    if (self = [super init])
    {
        _instructions = [[NSMutableArray alloc] init];
    }

    return self;
}

#pragma mark - Getters

- (PXExpressionByteCode *)byteCode
{
    return [[PXExpressionByteCode alloc] initWithInstructions:[_instructions copy]];
}

- (PXExpressionByteCode *)optimizedByteCode
{
    PXByteCodeOptimizer *optimizer = [[PXByteCodeOptimizer alloc] init];

    return [optimizer optimizeByteCode:self.byteCode];
}

#pragma mark - Reset

- (void)reset
{
    [_instructions removeAllObjects];
}

#pragma mark - General add/replace methods

- (void)addInstruction:(PXExpressionInstruction *)instruction
{
    if (instruction != nil)
    {
        [_instructions addObject:instruction];
    }
}

#pragma mark - Stack manipulation add methods

- (void)addPushBooleanInstruction:(BOOL)booleanValue
{
    [self addInstruction:[PXPushValueInstruction booleanValue:booleanValue]];
}

- (void)addPushStringInstruction:(NSString *)stringValue
{
    [self addInstruction:[PXPushValueInstruction stringValue:stringValue]];
}

- (void)addPushDoubleInstruction:(double)doubleValue
{
    [self addInstruction:[PXPushValueInstruction doubleValue:doubleValue]];
}

- (void)addPushObjectInstruction:(id<PXExpressionObject>)objectValue
{
    [self addInstruction:[PXPushValueInstruction expressionValue:objectValue]];
}

- (void)addPushBlockInstruction:(PXExpressionByteCode *)byteCodeValue
{
    [self addInstruction:[PXPushValueInstruction blockValue:byteCodeValue]];
}

- (void)addPushFunctionInstruction:(id<PXExpressionFunction>)function
{
    [self addInstruction:[PXPushValueInstruction expressionValue:function]];
}

- (void)addPushNullInstruction
{
    [self addInstruction:[PXPushValueInstruction expressionValue:[PXNullValue null]]];
}

- (void)addPushUndefinedInstruction
{
    [self addInstruction:[PXPushValueInstruction expressionValue:[PXUndefinedValue undefined]]];
}

- (void)addPushMarkInstruction
{
    [self addInstruction:[PXPushValueInstruction expressionValue:[PXMarkValue mark]]];
}

- (void)addPushGlobal
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_STACK_PUSH_GLOBAL]];
}

- (void)addPopInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_STACK_POP]];
}

- (void)addSwapInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_STACK_SWAP]];
}

- (void)addDuplicateInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_STACK_DUPLICATE]];
}

#pragma mark - Math operator instructions

- (void)addAddInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_MATH_ADDITION]];
}

- (void)addSubtractInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_MATH_SUBTRACTION]];
}

- (void)addMultiplyInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_MATH_MULTIPLICATION]];
}

- (void)addDivideInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_MATH_DIVISION]];
}

- (void)addModulusInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_MATH_MODULUS]];
}

- (void)addNegateInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_MATH_NEGATE]];
}

#pragma mark - Boolean operator instructions

- (void)addAndInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_BOOLEAN_AND]];
}

- (void)addOrInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_BOOLEAN_OR]];
}

- (void)addNotInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_BOOLEAN_NOT]];
}

#pragma mark - Comparison operator instructions

- (void)addLessThanInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_COMPARISON_LESS_THAN]];
}

- (void)addLessThanEqualInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_COMPARISON_LESS_THAN_EQUAL]];
}

- (void)addEqualInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_COMPARISON_EQUAL]];
}

- (void)addNotEqualInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_COMPARISON_NOT_EQUAL]];
}

- (void)addGreaterThanEqualInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_COMPARISON_GREATER_THAN_EQUAL]];
}

- (void)addGreaterThanInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_COMPARISON_GREATER_THAN]];
}

#pragma mark - Array add methods

- (void)addCreateArrayInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_ARRAY_CREATE]];
}

- (void)addCreateArrayInstructionWithCount:(uint)count
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_ARRAY_CREATE_WITH_COUNT uint:count]];
}

- (void)addGetElementInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_ARRAY_GET_ELEMENT]];
}

- (void)addGetElementInstructionWithIndex:(uint)index
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_ARRAY_GET_ELEMENT_AT_INDEX uint:index]];
}

#pragma mark - Property add methods

- (void)addCreateObjectInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_OBJECT_CREATE]];
}

- (void)addCreateObjectInstructionWithCount:(uint)count
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_OBJECT_CREATE_WITH_COUNT uint:count]];
}

- (void)addGetPropertyInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_OBJECT_GET_PROPERTY]];
}

- (void)addGetPropertyInstructionWithName:(NSString *)propertyName
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_OBJECT_GET_PROPERTY_NAME stringValue:propertyName]];
}

#pragma mark - Scope add methods

- (void)addGetSymbolInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_SCOPE_GET_SYMBOL]];
}

- (void)addGetSymbolInstructionWithName:(NSString *)symbolName
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_SCOPE_GET_SYMBOL_NAME stringValue:symbolName]];
}

- (void)addSetSymbolInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_SCOPE_SET_SYMBOL]];
}

- (void)addSetSymbolInstructionWithName:(NSString *)symbolName
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_SCOPE_SET_SYMBOL_NAME stringValue:symbolName]];
}

#pragma mark - Invoke add methods

- (void)addInvokeFunctionInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_FUNCTION_INVOKE]];
}

- (void)addInvokeFunctionInstructionWithCount:(uint)count
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_FUNCTION_INVOKE_WITH_COUNT uint:count]];
}

- (void)addInvokeFunctionInstructionWithName:(NSString *)functionName
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_FUNCTION_INVOKE_NAME stringValue:functionName]];
}

- (void)addInvokeFunctionInstructionWithName:(NSString *)functionName count:(uint)count
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_FUNCTION_INVOKE_NAME_WITH_COUNT stringValue:functionName uint:count]];
}

- (void)addApplyInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_FUNCTION_APPLY]];
}

- (void)addApplyInstructionWithName:(NSString *)name
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_FUNCTION_APPLY_NAME stringValue:name]];
}

- (void)addExecuteInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_BLOCK_EXECUTE]];
}

#pragma mark - Flow control add methods

- (void)addIfInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_FLOW_IF]];
}

- (void)addIfElseInstruction
{
    [self addInstruction:[[PXExpressionInstruction alloc] initWithType:EM_INSTRUCTION_FLOW_IF_ELSE]];
}

#pragma mark - Mixed instruction add methods

- (void)addGetSymbol:(NSString *)symbol property:(NSString *)property
{
    PXExpressionInstruction *get = [[PXExpressionInstruction alloc]
                                    initWithType:EM_INSTRUCTION_MIX_GET_SYMBOL_PROPERTY stringValue:symbol];

    [get pushStringValue:property preservingStringValue:YES];

    [self addInstruction:get];
}

- (void)addInvokeSymbol:(NSString *)symbol property:(NSString *)property withCount:(uint)count
{
    PXExpressionInstruction *invoke = [[PXExpressionInstruction alloc]
                                       initWithType:EM_INSTRUCTION_MIX_INVOKE_SYMBOL_PROPERTY_WITH_COUNT
                                       stringValue:symbol
                                       uint:count];

    [invoke pushStringValue:property preservingStringValue:YES];

    [self addInstruction:invoke];
}

#pragma mark - Compiler

- (PXExpressionUnit *)compileExpression:(NSString *)expression
{
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];

    return [parser compileString:expression];
}

- (PXExpressionUnit *)compileAssembly:(NSString *)assembly
{
    PXExpressionAssembler *assembler = [[PXExpressionAssembler alloc] init];

    return [assembler assembleString:assembly];
}

@end
