//
//  PXStringValue.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionValueBase.h"
#import "PXExpressionObject.h"
#import "PXExpressionArray.h"

@interface PXStringValue : PXExpressionValueBase <PXExpressionObject, PXExpressionArray>

- (id)initWithString:(NSString *)stringValue;

@end
