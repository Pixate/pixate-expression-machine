//
//  PXPropertyTestClass.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/14/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXPropertyTestClass.h"

@interface PXPropertyTestClass ()
@property (nonatomic) double length;
@property (nonatomic) NSString *name;
@end

@implementation PXPropertyTestClass

- (id)init
{
    if (self = [super init])
    {
        // set some defaults for testing
        _name = @"testing";
        _length = _name.length;
    }

    return self;
}

@end
