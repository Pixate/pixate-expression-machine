//
//  PXSquareFunction.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/1/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXSquareFunction.h"
#import "PXExpressionAssembler.h"
#import "PXExpressionUnit.h"
#import "PXParameter.h"
#import "PXDoubleValue.h"

@implementation PXSquareFunction

// NOTE: This is for testing only and will likely be removed

- (id)init
{
    // parse assembly into a unit
    PXExpressionAssembler *assembler = [[PXExpressionAssembler alloc] init];
    NSString *source = @"^x ^x mul";
    PXExpressionUnit *unit = [assembler assembleString:source];

    // build parameter list
    NSArray *parameters = @[
        [[PXParameter alloc] initWithName:@"x" defaultValue:[[PXDoubleValue alloc] initWithDouble:0.0]]
    ];

    // init
    return [self initWithUnit:unit parameters:parameters];
}

@end
