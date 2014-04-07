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

#pragma mark - Initializers

- (id)init
{
    if (self = [super init])
    {
        static id<PXExpressionScope> emaScope;
        static id<PXExpressionScope> emScope;
        static dispatch_once_t onceToken;

        dispatch_once(&onceToken, ^{
            PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] initWithGlobalScope:[[PXScope alloc] init]];

            // process built-in assembly file
            PXExpressionAssembler *assembler = [[PXExpressionAssembler alloc] init];
            PXExpressionUnit *unit = [assembler assembleString:[PXBuiltInSource emaSource]];
            [env executeUnit:unit];
            emaScope = unit.scope;

            // process built-in expression file
            PXExpressionParser *parser = [[PXExpressionParser alloc] init];
            unit = [parser compileString:[PXBuiltInSource emSource]];
            [env executeUnit:unit];
            emScope = unit.scope;
        });

        // copy em- and ema-defined built-ins
        [self copySymbolsFromScope:emaScope];
        [self copySymbolsFromScope:emScope];

        // math operators
        [self setValue:[[PXSinFunction alloc] init] forSymbolName:@"sin"];
        [self setValue:[[PXCosFunction alloc] init] forSymbolName:@"cos"];
        [self setValue:[[PXPowerFunction alloc] init] forSymbolName:@"pow"];

        id<PXExpressionFunction> squareRoot = [[PXSquareRootFunction alloc] init];
        [self setValue:squareRoot forSymbolName:@"sqrt"];
        [self setValue:squareRoot forSymbolName:@"√"];


        [self setValue:[[PXLogFunction alloc] init] forSymbolName:@"log"];
        [self setValue:[[PXShowTopFunction alloc] init] forSymbolName:@"showTop"];

        [self setValue:self forSymbolName:@"this"];
    }

    return self;
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
