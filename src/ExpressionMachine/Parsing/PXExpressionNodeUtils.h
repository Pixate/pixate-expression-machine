//
//  PXExpressionNodeUtils.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/26/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXExpressionNode.h"

@interface PXExpressionNodeUtils : NSObject

+ (NSString *)descriptionForNode:(id<PXExpressionNode>)node;

@end
