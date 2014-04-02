//
//  PXBlockNode.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/2/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXBlockNode.h"
#import "PXExpressionLexemeType.h"

@implementation PXBlockNode
{
    NSMutableArray *_nodes;
}

@synthesize type = _type;

#pragma mark - Initializers

- (id)init
{
    if (self = [super init])
    {
        _type = EM_LCURLY;
        _nodes = [[NSMutableArray alloc] init];
    }

    return self;
}

#pragma mark - Getters

- (NSArray *)nodes
{
    return [NSArray arrayWithArray:_nodes];
}

#pragma mark - Methods

- (void)addNode:(id<PXExpressionNode>)node
{
    if (node != nil)
    {
        [_nodes addObject:node];
    }
}

@end
