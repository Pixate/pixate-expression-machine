//
//  PXExpressionNode.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXByteCodeBuilder.h"
#import "PXExpressionScope.h"

@protocol PXExpressionNode <NSObject>

@property (nonatomic, readonly) int type;

@end
