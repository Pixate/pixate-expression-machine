//
//  PXStringProperty.h
//  pixate-freestyle
//
//  Created by Kevin Lindsey on 4/16/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionProperty.h"

@interface PXStringProperty : NSObject <PXExpressionProperty>

- (NSString *)getWithObject:(id)object;
- (void)setValue:(NSString *)value withObject:(id)object;

@end
