//
//  PXEmNode.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXGenericNode.h"

@implementation PXGenericNode

@synthesize type = _type;

#pragma mark - Initializers

- (id)initWithType:(int)type
{
    if (self = [super init])
    {
        _type = type;
    }

    return self;
}

- (id)initWithType:(int)type arrayValue:(NSArray *)arrayValue
{
    return [self initWithType:type nodeValue:nil arrayValue:arrayValue stringValue:nil];
}

- (id)initWithType:(int)type stringValue:(NSString *)stringValue
{
    return [self initWithType:type nodeValue:nil arrayValue:nil stringValue:stringValue];
}

- (id)initWithType:(int)type booleanValue:(BOOL)booleanValue
{
    if (self = [self initWithType:type])
    {
        _booleanValue = booleanValue;
    }

    return self;
}

- (id)initWithType:(int)type doubleValue:(double)doubleValue
{
    if (self = [self initWithType:type])
    {
        _doubleValue = doubleValue;
    }

    return self;
}


- (id)initWithType:(int)type nodeValue:(id<PXExpressionNode>)nodeValue
{
    return [self initWithType:type nodeValue:nodeValue arrayValue:nil stringValue:nil];
}

- (id)initWithType:(int)type uintValue:(uint)uintValue
{
    if (self = [self initWithType:type])
    {
        _uintValue = uintValue;
    }

    return self;
}

- (id)initWithType:(int)type stringValue:(NSString *)stringValue uintValue:(uint)uintValue
{
    if (self = [self initWithType:type])
    {
        _stringValue = stringValue;
        _uintValue = uintValue;
    }

    return self;
}

- (id)initWithType:(int)type nodeValue:(id<PXExpressionNode>)nodeValue stringValue:(NSString *)stringValue
{
    return [self initWithType:type nodeValue:nodeValue arrayValue:nil stringValue:stringValue];
}

- (id)initWithType:(int)type nodeValue:(id<PXExpressionNode>)nodeValue arrayValue:(NSArray *)arrayValue
{
    return [self initWithType:type nodeValue:nodeValue arrayValue:arrayValue stringValue:nil];
}

- (id)initWithType:(int)type nodeValue:(id<PXExpressionNode>)nodeValue arrayValue:(NSArray *)arrayValue stringValue:(NSString *)stringValue
{
    if (self = [self initWithType:type])
    {
        _nodeValue = nodeValue;
        _arrayValue = arrayValue;
        _stringValue = stringValue;
    }

    return self;
}

- (id)initWithType:(int)type lhs:(id<PXExpressionNode>)lhs rhs:(id<PXExpressionNode>)rhs
{
    if (self = [self initWithType:type])
    {
        _nodeValue = lhs;
        _nodeValue2 = rhs;
    }

    return self;
}

- (id)initWithType:(int)type
         condition:(id<PXExpressionNode>)condition
         trueBlock:(id<PXExpressionNode>)trueBlock
        falseBlock:(id<PXExpressionNode>)falseBlock
{
    if (self = [self initWithType:type])
    {
        _nodeValue = condition;
        _nodeValue2 = trueBlock;
        _nodeValue3 = falseBlock;
    }

    return self;
}

@end
