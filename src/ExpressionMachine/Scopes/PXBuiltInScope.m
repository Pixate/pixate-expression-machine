//
//  PXBuiltInScope.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXBuiltInScope.h"
#import "PXBuiltInSource.h"

#import "PXCosFunction.h"
#import "PXPowerFunction.h"
#import "PXSinFunction.h"
#import "PXSquareRootFunction.h"

#import "PXLogFunction.h"
#import "PXShowTopFunction.h"

#import "PXExpressionAssembler.h"
#import "PXExpressionParser.h"
#import "PXExpressionUnit.h"

@implementation PXBuiltInScope

static id<PXExpressionScope> EMA_SCOPE;
static id<PXExpressionScope> EM_SCOPE;

#pragma mark - Initializers

- (id)init
{
    if (self = [super init])
    {
        // math functions
        [self setValue:[[PXSinFunction alloc] init] forSymbolName:@"sin"];
        [self setValue:[[PXCosFunction alloc] init] forSymbolName:@"cos"];
        [self setValue:[[PXPowerFunction alloc] init] forSymbolName:@"pow"];

        id<PXExpressionFunction> squareRoot = [[PXSquareRootFunction alloc] init];
        [self setValue:squareRoot forSymbolName:@"sqrt"];
        [self setValue:squareRoot forSymbolName:@"√"];


        [self setValue:[[PXLogFunction alloc] init] forSymbolName:@"log"];
        [self setValue:[[PXShowTopFunction alloc] init] forSymbolName:@"showTop"];

        [self setValue:self forSymbolName:@"this"];

        // copy em- and ema-defined built-ins
        if (EMA_SCOPE == nil)
        {
            EMA_SCOPE = [self scopeFromEmaString:[PXBuiltInSource emaSource]];
        }
        if (EM_SCOPE == nil)
        {
            EM_SCOPE = [self scopeFromEmString:[PXBuiltInSource emSource]];
        }
        
        [self copySymbolsFromScope:EMA_SCOPE];
        [self copySymbolsFromScope:EM_SCOPE];
    }

    return self;
}

#pragma mark - Methods

- (id<PXExpressionScope>)scopeFromEmString:(NSString *)source
{
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] initWithGlobalScope:self];

    // process built-in expression file
    PXExpressionParser *parser = [[PXExpressionParser alloc] init];
    PXExpressionUnit *unit = [parser compileString:source];
    [env executeUnit:unit];

    return unit.scope;
}

- (id<PXExpressionScope>)scopeFromEmaString:(NSString *)source
{
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] initWithGlobalScope:self];

    // process built-in assembly file
    PXExpressionAssembler *assembler = [[PXExpressionAssembler alloc] init];
    PXExpressionUnit *unit = [assembler assembleString:source];
    [env executeUnit:unit];

    return unit.scope;
}

#pragma mark - PXExpressionValue Implementation

- (PXExpressionValueType)valueType
{
    return PX_VALUE_TYPE_OBJECT;
}

- (BOOL)booleanValue
{
    return YES;
}

- (NSString *)stringValue
{
    return @"[value Object]";
}

- (double)doubleValue
{
    return NAN;
}

#pragma mark - PXExpressionObject Implementation

- (NSArray *)propertyNames
{
    return [self symbolNames];
}

- (NSArray *)propertyValues
{
    NSMutableArray *result = [[NSMutableArray alloc] init];

    [self.symbolNames enumerateObjectsUsingBlock:^(id<PXExpressionValue> value, NSUInteger idx, BOOL *stop) {
        [result addObject:value];
    }];

    return [result copy];
}

- (id<PXExpressionValue>)valueForPropertyName:(NSString *)name
{
    return [self valueForSymbolName:name];
}

- (void)setValue:(id<PXExpressionValue>)value forPropertyName:(NSString *)name
{
    [self setValue:value forSymbolName:name];
}

@end
