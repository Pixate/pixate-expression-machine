//
//  PXBlockValue.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/4/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionValueBase.h"
#import "PXExpressionByteCode.h"

@interface PXBlockValue : PXExpressionValueBase

@property (nonatomic, strong, readonly) PXExpressionByteCode *byteCodeValue;

- (id)initWithByteCode:(PXExpressionByteCode *)byteCodeValue;

@end
