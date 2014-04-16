//
//  PXStringValue.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXStringValue.h"
#import "PXStringLengthMethod.h"
#import "PXStringSubstringMethod.h"
#import "PXUndefinedValue.h"

@implementation PXStringValue
{
    NSString *_stringValue;
}

#pragma mark - Static Methods

static NSDictionary *METHODS;

+ (void)initialize
{
    if (METHODS == nil)
    {
        METHODS = @{
            @"length": [[PXStringLengthMethod alloc] init],
            @"substring": [[PXStringSubstringMethod alloc] init]
        };
    }
}

#pragma mark - Initializers

- (id)initWithString:(NSString *)stringValue
{
    if (self = [super initWithValueType:PX_VALUE_TYPE_STRING])
    {
        _stringValue = stringValue;
    }

    return self;
}

#pragma mark - Getters

- (BOOL)booleanValue
{
    return _stringValue.length > 0;
}

- (NSString *)stringValue
{
    return _stringValue;
}

- (double)doubleValue
{
    return [_stringValue doubleValue];
}

#pragma mark - PXExpressionObject Implementation

- (uint)length
{
    return (uint) _stringValue.length;
}

- (NSArray *)propertyNames
{
    return nil;
}

- (NSArray *)propertyValues
{
    return nil;
}

- (void)setValue:(id<PXExpressionValue>)value forPropertyName:(NSString *)name
{
    // ignore
}

- (id<PXExpressionValue>)valueForPropertyName:(NSString *)name
{
    id<PXExpressionFunction> method = [METHODS objectForKey:name];

    return (method != nil) ? method : [PXUndefinedValue undefined];
}

#pragma mark - PXExressionArray Implementation

- (NSArray *)elements
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:_stringValue.length];

    for (NSUInteger i = 0; i < _stringValue.length; i++)
    {
        NSString *c = [_stringValue substringWithRange:NSMakeRange(i, 1)];

        [result addObject:c];
    }

    return result;
}

-(void)setValue:(id<PXExpressionValue>)value forIndex:(int)index
{
    NSMutableString *string = [NSMutableString stringWithString:_stringValue];

    [string replaceCharactersInRange:NSMakeRange(index, 1) withString:value.stringValue];

    _stringValue = [string copy];
}

- (id<PXExpressionValue>)valueForIndex:(int)index
{
    return [[PXStringValue alloc] initWithString:[_stringValue substringWithRange:NSMakeRange(index, 1)]];
}

#pragma mark - Overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"'%@'", _stringValue];
}

@end
