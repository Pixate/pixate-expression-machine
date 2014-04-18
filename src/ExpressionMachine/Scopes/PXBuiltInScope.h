//
//  PXBuiltInScope.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXScope.h"
#import "PXExpressionObject.h"

@interface PXBuiltInScope : PXScope <PXExpressionObject>

- (id<PXExpressionScope>)scopeFromEmaString:(NSString *)source;
- (id<PXExpressionScope>)scopeFromEmString:(NSString *)source;

@end
