//
//  PXDoubleProperty.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/14/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionProperty.h"

@interface PXDoubleProperty : NSObject <PXExpressionProperty>

- (double)getWithObject:(id)object;
- (void)setValue:(double)value withObject:(id)object;

@end
