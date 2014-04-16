//
//  PXCommandExecutor.m
//  Protostyle
//
//  Created by Kevin Lindsey on 3/27/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXCommandExecutor.h"
#import "PXSwitch.h"
#import "PXExecuteFileSwitch.h"
#import "PXDisassembleSwitch.h"
#import "PXCommand.h"

@interface PXCommandExecutor ()
@property (nonatomic, strong) NSMutableArray *commands;
@property (nonatomic, strong) NSMutableDictionary *switches;
@end

@implementation PXCommandExecutor

#pragma mark - Initializers

- (id)init
{
    if (self = [super init])
    {
        _commands = [[NSMutableArray alloc] init];
        _switches = [[NSMutableDictionary alloc] init];

        [self setupSwitches];
    }

    return self;
}

#pragma mark - Methods

- (void)processArgs:(NSArray *)args
{
    uint index = 0;

    while (index < args.count)
    {
        NSString *switchName = args[index++];
        id<PXSwitch> theSwitch = [_switches objectForKey:switchName];

        if (theSwitch != nil)
        {
            if ([theSwitch processArgs:args atIndex:&index])
            {
                id<PXCommand> command = [theSwitch createCommand];

                if (command != nil)
                {
                    [_commands addObject:command];
                }
            }
            else
            {
                NSLog(@"An error occurred while processing '%@'", switchName);
                index = (uint) args.count;
            }
        }
        else if (index < args.count)
        {
            NSLog(@"Urecognized switch: '%@'", switchName);
            [self usage];
            index = (uint) args.count;
        }
        else
        {
            // handle any non-switch item
        }
    }

    if (args.count == 0)
    {
        [self usage];
    }
}

- (void)run
{
    PXCommandContext *context = [[PXCommandContext alloc] init];

    [_commands enumerateObjectsUsingBlock:^(id<PXCommand> command, NSUInteger idx, BOOL *stop) {
        if ([command executeWithContext:context] == NO)
        {
            NSLog(@"An error occurred while executing %@", command);
            *stop = YES;
        }
    }];
}

- (void)usage
{
    printf("usage: em <options>+\n\n");

    NSArray *switches = [_switches allKeys];
    NSArray *sortedNames = [switches sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
        return [a compare:b];
    }];

    [sortedNames enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        if ([key hasPrefix:@"--"] == NO)
        {
            id<PXSwitch> aSwitch = [_switches objectForKey:key];
            NSString *message = [NSString stringWithFormat:@"%@\n  %@\n  %@", aSwitch.displayName, [aSwitch.switchNames componentsJoinedByString:@", "], aSwitch.shortDescription];

            printf("%s\n\n", [message cStringUsingEncoding:NSUTF8StringEncoding]);
        }
    }];
}

- (void)addSwitch:(id<PXSwitch>)aSwitch;
{
    [aSwitch.switchNames enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
        [_switches setObject:aSwitch forKey:name];
    }];
}

- (void)setupSwitches
{
    [self addSwitch:[[PXExecuteFileSwitch alloc] init]];
    [self addSwitch:[[PXDisassembleSwitch alloc] init]];
}

@end
