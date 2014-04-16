//
//  PXExecuteFile.m
//  Protostyle
//
//  Created by Kevin Lindsey on 3/27/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExecuteFileCommand.h"
#import "PXExpressionAssembler.h"
#import "PXExpressionParser.h"
#import "PXExpressionUnit.h"
#import "PXExpressionEnvironment.h"

@implementation PXExecuteFileCommand

#pragma mark - Initializers

- (id)initWithFilename:(NSString *)filename
{
    if (self = [super init])
    {
        _filename = filename;
    }

    return self;
}

#pragma mark - PXCommand Implementation

- (BOOL)executeWithContext:(PXCommandContext *)context
{
    if (_filename.length > 0)
    {
        NSLog(@"file = %@\n", _filename);

        // get file name
        NSString *filepath = [_filename stringByExpandingTildeInPath];

        // get string content of file
        NSError *err = nil;
        NSString *source = [NSString stringWithContentsOfFile:filepath
                                                     encoding:NSUTF8StringEncoding
                                                        error:&err];

        if (source.length > 0)
        {
            NSString *ext = [filepath pathExtension];
            PXExpressionUnit *unit = nil;

            if ([ext isEqualToString:@"em"])
            {
                PXExpressionParser *parser = [[PXExpressionParser alloc] init];

                unit = [parser compileString:source];
            }
            else if ([ext isEqualToString:@"ema"])
            {
                PXExpressionAssembler *parser = [[PXExpressionAssembler alloc] init];

                unit = [parser assembleString:source];
            }
            else
            {
                NSLog(@"Unrecognized file extension: '%@'", ext);
            }

            if (unit != nil)
            {
                // grab execution environment
                PXExpressionEnvironment *env = context.env;

                // save reference to unit in case other commands want to use it
                context.unit = unit;

                // execute
                [env executeUnit:unit];

                // return result
                id<PXExpressionValue> value = [env popValue];

                // show top of stack
                NSLog(@"%@", value);
            }
        }
    };

    return YES;
}

@end
