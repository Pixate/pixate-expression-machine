//
//  PXMarkValue.m
//  Protostyle
//
//  Created by Kevin Lindsey on 2/28/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXMarkValue.h"

@implementation PXMarkValue

#pragma mark - Static Methods

+ (PXMarkValue *)mark
{
    static PXMarkValue *mark;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        mark = [[PXMarkValue alloc] init];
    });

    return mark;
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
