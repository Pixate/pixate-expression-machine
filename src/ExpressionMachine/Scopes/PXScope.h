//
//  PXScope.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXScopeBase.h"

@interface PXScope : PXScopeBase

@property (nonatomic, readonly) uint length;

- (void)copySymbolsFromScope:(id<PXExpressionScope>)scope;

@end
