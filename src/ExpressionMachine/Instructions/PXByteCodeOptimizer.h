//
//  PXByteCodeOptimizer.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 4/5/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PXExpressionByteCode;

@interface PXByteCodeOptimizer : NSObject

- (PXExpressionByteCode *)optimizeByteCode:(PXExpressionByteCode *)byteCode;

@end
