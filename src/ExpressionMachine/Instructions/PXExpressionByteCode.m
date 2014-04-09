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

static PXInstructionDisassembler *SHORT_DISASSEMBLER;
static PXInstructionDisassembler *DISASSEMBLER;

#pragma mark - Initializers

+ (void)initialize
{
    if (SHORT_DISASSEMBLER == nil)
    {
        SHORT_DISASSEMBLER = [[PXInstructionDisassembler alloc] init];
        SHORT_DISASSEMBLER.useShortForm = YES;
    }
    if (DISASSEMBLER == nil)
    {
        DISASSEMBLER = [[PXInstructionDisassembler alloc] init];
    }
}

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
    NSMutableArray *lines = [[NSMutableArray alloc] init];

    [_instructions enumerateObjectsUsingBlock:^(PXExpressionInstruction *instruction, NSUInteger idx, BOOL *stop) {
        [lines addObject:[SHORT_DISASSEMBLER disassembleInstruction:instruction]];
    }];

    return [lines componentsJoinedByString:@" "];
}

#pragma mark - Overrides

- (NSString *)description
{
    NSMutableArray *lines = [[NSMutableArray alloc] init];

    [_instructions enumerateObjectsUsingBlock:^(PXExpressionInstruction *instruction, NSUInteger idx, BOOL *stop) {
        [lines addObject:[DISASSEMBLER disassembleInstruction:instruction]];
    }];

    return [lines componentsJoinedByString:@"\n"];
}

@end
