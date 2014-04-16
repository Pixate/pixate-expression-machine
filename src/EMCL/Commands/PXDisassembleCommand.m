//
//  PXDisassembleCommand.m
//  Protostyle
//
//  Created by Kevin Lindsey on 4/1/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXDisassembleCommand.h"

@implementation PXDisassembleCommand

- (BOOL)executeWithContext:(PXCommandContext *)context
{
    PXExpressionUnit *unit = context.unit;

    if (unit != nil)
    {
        NSLog(@"\n%@", unit.description);
    }

    return YES;
}

@end
