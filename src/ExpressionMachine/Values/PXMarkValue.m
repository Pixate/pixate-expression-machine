//
//  PXMarkValue.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/28/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXMarkValue.h"

@implementation PXMarkValue

#pragma mark - Static Methods

static PXMarkValue *INSTANCE;

+ (void)initialize
{
    if (INSTANCE == nil)
    {
        INSTANCE = [[PXMarkValue alloc] init];
    }
}

+ (PXMarkValue *)mark
{
    return INSTANCE;
}

#pragma mark - Initializers

- (id)init
{
    return [self initWithValueType:PX_VALUE_TYPE_MARK];
}

#pragma mark - Overrides

- (NSString *)stringValue
{
    return @"mark";
}

@end
