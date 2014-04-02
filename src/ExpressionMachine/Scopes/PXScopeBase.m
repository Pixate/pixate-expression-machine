//
//  PXScopeBase.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXScopeBase.h"
#import "PXExpressionValue.h"
#import "PXBooleanValue.h"
#import "PXStringValue.h"
#import "PXDoubleValue.h"
#import "PXUndefinedValue.h"

@implementation PXScopeBase

@synthesize parentScope;

#pragma mark - PXExpressionScope Implementation

- (void)setValue:(id<PXExpressionValue>)value forSymbolName:(NSString *)name
{
    // TODO: throw exception? Subclasses need to override this method
}

- (void)setBooleanValue:(BOOL)value forSymbolName:(NSString *)name
{
    [self setValue:[[PXBooleanValue alloc] initWithBoolean:value] forSymbolName:name];
}

- (void)setStringValue:(NSString *)value forSymbolName:(NSString *)name
{
    [self setValue:[[PXStringValue alloc] initWithString:value] forSymbolName:name];
}

- (void)setDoubleValue:(double)value forSymbolName:(NSString *)name
{
    [self setValue:[[PXDoubleValue alloc] initWithDouble:value] forSymbolName:name];
}

- (id<PXExpressionValue>)localValueForSymbolName:(NSString *)name
{
    // TODO: throw exception? Subclasses need to override
    return nil;
}

- (NSArray *)symbolNames
{
    // TODO: throw exception? Subclasses need to override
    return nil;
}

- (id<PXExpressionValue>)valueForSymbolName:(NSString *)name
{
    id<PXExpressionScope> currentScope = self;
    id<PXExpressionValue> result = nil;

    while (result == nil && currentScope != nil)
    {
        result = [currentScope localValueForSymbolName:name];
        currentScope = currentScope.parentScope;
    }

    return (result != nil) ? result : [PXUndefinedValue undefined];
}

- (void)removeSymbolName:(NSString *)name
{
    // Subclasses need to override this method
}

- (void)removeAllSymbols
{
    // Subclasses need to override this method
}

@end
