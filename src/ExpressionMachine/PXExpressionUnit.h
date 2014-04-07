//
//  PXExpressionUnit.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/2/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXExpressionScope.h"
#import "PXExpressionNode.h"

@class PXExpressionByteCode;

@interface PXExpressionUnit : NSObject

@property (nonatomic, strong, readonly) PXExpressionByteCode *byteCode;
@property (nonatomic, strong, readonly) PXExpressionByteCode *optimizedByteCode;
@property (nonatomic, strong, readonly) id<PXExpressionScope> scope;
@property (nonatomic, strong, readonly) id<PXExpressionNode> ast;

- (id)initWithByteCode:(PXExpressionByteCode *)byteCode;
- (id)initWithByteCode:(PXExpressionByteCode *)byteCode scope:(id<PXExpressionScope>)scope;
- (id)initWithByteCode:(PXExpressionByteCode *)byteCode scope:(id<PXExpressionScope>)scope ast:(id<PXExpressionNode>)ast;

@end
