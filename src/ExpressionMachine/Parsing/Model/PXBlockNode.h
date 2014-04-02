//
//  PXBlockNode.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/2/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionNode.h"

@interface PXBlockNode : NSObject <PXExpressionNode>

@property (nonatomic, strong, readonly) NSArray *nodes;
@property (nonatomic, getter=isBlockValue) BOOL blockValue;

- (void)addNode:(id<PXExpressionNode>)node;

@end
