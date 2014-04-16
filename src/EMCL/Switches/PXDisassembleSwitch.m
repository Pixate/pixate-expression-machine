//
//  PXDisassembleSwitch.m
//  Protostyle
//
//  Created by Kevin Lindsey on 4/1/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXDisassembleSwitch.h"
#import "PXDisassembleCommand.h"

@implementation PXDisassembleSwitch

- (id<PXCommand>)createCommand
{
    return [[PXDisassembleCommand alloc] init];
}

- (NSString *)displayName
{
    return @"Disassemble Unit";
}

- (NSString *)shortDescription
{
    return @"Dump the unit for the last compiled file";
}

- (NSString *)longDescription
{
    return self.shortDescription;
}

-(NSArray *)switchNames
{
    return @[ @"-d", @"--disassemble" ];
}

- (BOOL)processArgs:(NSArray *)arg atIndex:(uint *)index
{
    return YES;
}

@end
