//
//  PXExpressionScope.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXExpressionValue.h"

@protocol PXExpressionScope <NSObject>

@property (nonatomic, strong) id<PXExpressionScope> parentScope;
@property (nonatomic, strong, readonly) NSArray *symbolNames;

- (id<PXExpressionValue>)localValueForSymbolName:(NSString *)name;
- (id<PXExpressionValue>)valueForSymbolName:(NSString *)name;

- (void)setValue:(id<PXExpressionValue>)value forSymbolName:(NSString *)name;
- (void)setBooleanValue:(BOOL)value forSymbolName:(NSString *)name;
- (void)setStringValue:(NSString *)value forSymbolName:(NSString *)name;
- (void)setDoubleValue:(double)value forSymbolName:(NSString *)name;

- (void)removeSymbolName:(NSString *)name;
- (void)removeAllSymbols;

@end
