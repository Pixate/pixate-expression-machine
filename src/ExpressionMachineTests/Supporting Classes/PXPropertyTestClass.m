//
//  PXPropertyTestClass.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/14/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXPropertyTestClass.h"

@implementation PXPropertyTestClass

@synthesize count = _count;
@synthesize name = _name;

- (id)init
{
    if (self = [super init])
    {
        // set some defaults for testing
        _name = @"testing";
        _count = _name.length;
    }

    return self;
}

@end
