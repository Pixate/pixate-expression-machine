//
//  PXScope.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXScope.h"
#import "PXScriptManager.h"
#import "PXExpressionValue.h"
//#import "PXBehaviorProtocol.h"

@interface PXScope ()
@property (nonatomic, strong) NSMutableDictionary *symbols;
@end

@implementation PXScope

#pragma mark - Initializers

- (id)init
{
    if (self = [super init])
    {
        _symbols = [[NSMutableDictionary alloc] init];
    }

    return self;
}

#pragma mark - Getters

- (uint)length
{
    return (uint) _symbols.count;
}

- (NSArray *)symbolNames
{
    return [_symbols allKeys];
}

#pragma mark - Methods

- (void)copySymbolsFromScope:(id<PXExpressionScope>)scope
{
    [scope.symbolNames enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
        [self setValue:[scope valueForSymbolName:name] forSymbolName:name];
    }];
}


#pragma mark - PXExpressionScope Implementation

- (id<PXExpressionValue>)localValueForSymbolName:(NSString *)name
{
    return _symbols[name];
}

- (void)setValue:(id<PXExpressionValue>)value forSymbolName:(NSString *)name
{
    // TODO: Warn about nil values or convert to 'null' or 'undefined' value?
    if (value != nil && name.length > 0)
    {
        _symbols[name] = value;
    }
}

- (void)removeAllSymbols
{
    [_symbols removeAllObjects];
}

- (void)removeSymbolName:(NSString *)name
{
    [_symbols removeObjectForKey:name];
}

#pragma mark - Overrides

- (NSString *)description
{
    NSMutableArray *parts = [[NSMutableArray alloc] init];

    [_symbols enumerateKeysAndObjectsUsingBlock:^(NSString *key, id<PXExpressionValue> value, BOOL *stop) {
        if ([@"this" isEqualToString:key] == false)
        {
            [parts addObject:[NSString stringWithFormat:@" '%@': %@", key, value.stringValue]];
        }
    }];

    return [NSString stringWithFormat:@"{\n  %@\n}", [parts componentsJoinedByString:@"\n  "]];
}

@end
