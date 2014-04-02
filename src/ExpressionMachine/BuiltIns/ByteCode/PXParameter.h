//
//  PXParameter.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/3/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXExpressionValue.h"

@interface PXParameter : NSObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) id<PXExpressionValue> defaultValue;

- (id)initWithName:(NSString *)name defaultValue:(id<PXExpressionValue>)defaultValue;

@end
