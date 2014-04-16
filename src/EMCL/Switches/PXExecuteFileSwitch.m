//
//  PXExecuteFileSwitch.m
//  Protostyle
//
//  Created by Kevin Lindsey on 3/27/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExecuteFileSwitch.h"
#import "PXExecuteFileCommand.h"

@implementation PXExecuteFileSwitch

- (id<PXCommand>)createCommand
{
    return [[PXExecuteFileCommand alloc] initWithFilename:_filename];
}

- (NSString *)displayName
{
    return @"Execute File";
}

- (NSString *)shortDescription
{
    return @"Specify a file to load, parse, and execute";
}

- (NSString *)longDescription
{
    return self.shortDescription;
}

- (NSArray *)switchNames
{
    return @[ @"-e", @"--execute-file" ];
}

- (BOOL)processArgs:(NSArray *)arg atIndex:(uint *)index
{
    BOOL result = NO;

    if (*index < arg.count)
    {
        _filename = arg[(*index)++];
        result = YES;
    }

    return result;
}

@end
