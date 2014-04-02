//
//  PXByteCodeFunction.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/28/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXFunctionValueBase.h"

@class PXExpressionUnit;

@interface PXByteCodeFunction : PXFunctionValueBase

@property (nonatomic, strong, readonly) PXExpressionUnit *unit;
@property (nonatomic, strong, readonly) NSArray *parameters;

- (id)initWithUnit:(PXExpressionUnit *)unit;
- (id)initWithUnit:(PXExpressionUnit *)unit parameters:(NSArray *)parameters;

- (NSString *)longDescription;

@end
