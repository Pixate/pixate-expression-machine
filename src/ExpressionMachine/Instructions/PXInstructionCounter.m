//
//  PXInstructionCounter.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/22/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXInstructionCounter.h"
#include <mach/mach.h>
#include <mach/mach_time.h>

@interface PXInstructionCounter ()
@property (nonatomic) int *counts;
@property (nonatomic) uint64_t *times;
@property (nonatomic) uint64_t blockTime;
@end

@implementation PXInstructionCounter

#pragma mark - Initializers

- (id)init
{
    if (self = [super init])
    {
        int max_count = EM_INSTRUCTION_LAST;
        _counts = calloc(max_count, sizeof(int));
        _times = calloc(max_count, sizeof(uint64_t));
    }

    return self;
}

- (void)dealloc
{
    free(_counts);
}

#pragma mark - Methods

- (void)reset
{
    for (int i = 0; i < EM_INSTRUCTION_LAST; i++)
    {
        _counts[i] = 0;
        _times[i] = 0;
    }
}

- (void)dump
{
    static mach_timebase_info_data_t timebaseInfo;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mach_timebase_info(&timebaseInfo);
    });

    for (int i = 0; i < EM_INSTRUCTION_LAST; i++)
    {
        int count = _counts[i];

        if (count > 0)
        {
            uint64_t time = _times[i];
            double millis = (double) (time * timebaseInfo.numer) / (double) (timebaseInfo.denom * 1e6);

            PXExpressionInstruction *instruction = [[PXExpressionInstruction alloc] initWithType:i];

            NSLog(@"%@: %d, %llu, %lg", instruction.description, count, time, millis);
        }
    }
}

#pragma mark - Overrides

- (void)processInstructions:(NSArray *)instructions withEnvironment:(PXExpressionEnvironment *)env
{
    uint64_t start;
    uint64_t end;

    start = mach_absolute_time();
    [super processInstructions:instructions withEnvironment:env];
    end = mach_absolute_time();

    _blockTime = end - start;
}

- (void)processInstruction:(PXExpressionInstruction *)instruction withEnvironment:(PXExpressionEnvironment *)env
{
    _counts[instruction.type]++;

    uint64_t start;
    uint64_t end;
    uint64_t elapsed;

    start = mach_absolute_time();
    
    [super processInstruction:instruction withEnvironment:env];

    end = mach_absolute_time();
    elapsed = end - start;

    switch (instruction.type)
    {
        case EM_INSTRUCTION_FUNCTION_INVOKE_NAME_WITH_COUNT:
        case EM_INSTRUCTION_FLOW_IF_ELSE:
            elapsed -= _blockTime;
            break;

        default:
            // Do nothing
            break;
    }

    _times[instruction.type] += elapsed;
}

@end
