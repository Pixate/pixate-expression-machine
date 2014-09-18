//
//  PXByteCodeBuilder.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/27/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionObject.h"
#import "PXExpressionFunction.h"

@class PXExpressionInstruction;
@class PXExpressionByteCode;
@class PXExpressionUnit;

@interface PXByteCodeBuilder : NSObject

@property (nonatomic, strong, readonly) PXExpressionByteCode *byteCode;
@property (nonatomic, strong, readonly) PXExpressionByteCode *optimizedByteCode;

- (void)reset;

- (void)addInstruction:(PXExpressionInstruction *)instruction;

- (void)addPushBooleanInstruction:(BOOL)booleanValue;
- (void)addPushStringInstruction:(NSString *)stringValue;
- (void)addPushDoubleInstruction:(double)doubleValue;
- (void)addPushObjectInstruction:(id<PXExpressionObject>)objectValue;
- (void)addPushBlockInstruction:(PXExpressionByteCode *)byteCodeValue;
- (void)addPushFunctionInstruction:(id<PXExpressionFunction>)function;
- (void)addPushNullInstruction;
- (void)addPushUndefinedInstruction;
- (void)addPushMarkInstruction;
- (void)addPushGlobal;
- (void)addPopInstruction;
- (void)addSwapInstruction;
- (void)addDuplicateInstruction;

- (void)addAddInstruction;
- (void)addSubtractInstruction;
- (void)addMultiplyInstruction;
- (void)addDivideInstruction;
- (void)addModulusInstruction;
- (void)addNegateInstruction;

- (void)addAndInstruction;
- (void)addOrInstruction;
- (void)addNotInstruction;

- (void)addLessThanInstruction;
- (void)addLessThanEqualInstruction;
- (void)addEqualInstruction;
- (void)addNotEqualInstruction;
- (void)addGreaterThanEqualInstruction;
- (void)addGreaterThanInstruction;

- (void)addCreateArrayInstruction;
- (void)addCreateArrayInstructionWithCount:(uint)count;
- (void)addGetElementInstruction;
- (void)addGetElementInstructionWithIndex:(uint)index;

- (void)addCreateObjectInstruction;
- (void)addCreateObjectInstructionWithCount:(uint)count;
- (void)addGetPropertyInstruction;
- (void)addGetPropertyInstructionWithName:(NSString *)propertyName;

- (void)addGetSymbolInstruction;
- (void)addGetSymbolInstructionWithName:(NSString *)symbolName;
- (void)addSetSymbolInstruction;
- (void)addSetSymbolInstructionWithName:(NSString *)symbolName;

- (void)addInvokeFunctionInstruction;
- (void)addInvokeFunctionInstructionWithCount:(uint)count;
- (void)addInvokeFunctionInstructionWithName:(NSString *)functionName;
- (void)addInvokeFunctionInstructionWithName:(NSString *)functionName count:(uint)count;
- (void)addApplyInstruction;
- (void)addApplyInstructionWithName:(NSString *)name;
- (void)addExecuteInstruction;

- (void)addIfInstruction;
- (void)addIfElseInstruction;

- (void)addGetSymbol:(NSString *)symbol property:(NSString *)property;
- (void)addInvokeSymbol:(NSString *)symbol property:(NSString *)property withCount:(uint)count;

- (PXExpressionUnit *)compileExpression:(NSString *)expression;
- (PXExpressionUnit *)compileAssembly:(NSString *)assembly;

@end
