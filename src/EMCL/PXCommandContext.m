//
//  PXExecutionContext.m
//  Protostyle
//
//  Created by Kevin Lindsey on 3/27/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXCommandContext.h"

@implementation PXCommandContext

- (id)init
{
    if (self = [super init])
    {
        _env = [[PXExpressionEnvironment alloc] init];
    }

    return self;
}

@end
