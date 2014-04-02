//
//  PXExpressionNodeCompiler.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/26/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionByteCode.h"
#import "PXExpressionNode.h"
#import "PXExpressionScope.h"

@interface PXExpressionNodeCompiler : NSObject

- (PXExpressionByteCode *)compileNode:(id<PXExpressionNode>)node withScope:(id<PXExpressionScope>)scope;

@end
