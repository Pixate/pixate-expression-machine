//
//  PXExpressionValueBase.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXExpressionValue.h"

@interface PXExpressionValueBase : NSObject <PXExpressionValue>

- (id)initWithValueType:(PXExpressionValueType)type;

@end
