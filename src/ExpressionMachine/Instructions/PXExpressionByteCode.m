//
//  PXExpressionByteCode.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionByteCode.h"
#import "PXExpressionInstruction.h"
#import "PXInstructionDisassembler.h"
#import "PXExpressionEnvironment.h"

@interface PXExpressionByteCode ()
@property (nonatomic, strong) NSArray *instructions;
@end

@implementation PXExpressionByteCode

#pragma mark - Initializers

- (id)initWithInstructions:(NSArray *)instructions
{
    if (self = [super init])
    {
        _instructions = instructions;
    }

    return self;
}

#pragma mark - Methods

- (NSString *)shortDescription
{
    static PXInstructionDisassembler *disassembler;
    static dispatch_once_t onceToken;
    NSMutableArray *lines = [[NSMutableArray alloc] init];

    dispatch_once(&onceToken, ^{
        disassembler = [[PXInstructionDisassembler alloc] init];
        disassembler.useShortForm = YES;
    });

    [_instructions enumerateObjectsUsingBlock:^(PXExpressionInstruction *instruction, NSUInteger idx, BOOL *stop) {
        [lines addObject:[disassembler disassembleInstruction:instruction]];
    }];

    return [lines componentsJoinedByString:@" "];
}

#pragma mark - Overrides

- (NSString *)description
{
    static PXInstructionDisassembler *disassembler;
    static dispatch_once_t onceToken;
    NSMutableArray *lines = [[NSMutableArray alloc] init];

    dispatch_once(&onceToken, ^{
        disassembler = [[PXInstructionDisassembler alloc] init];
    });

    [_instructions enumerateObjectsUsingBlock:^(PXExpressionInstruction *instruction, NSUInteger idx, BOOL *stop) {
        [lines addObject:[disassembler disassembleInstruction:instruction]];
    }];

    return [lines componentsJoinedByString:@"\n"];
}

@end
