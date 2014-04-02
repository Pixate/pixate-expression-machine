//
//  PXDoubleValue.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXExpressionValueBase.h"

@interface PXDoubleValue : PXExpressionValueBase

- (id)initWithDouble:(double)doubleValue;

@end
