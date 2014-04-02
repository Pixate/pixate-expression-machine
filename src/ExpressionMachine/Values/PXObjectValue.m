//
//  PXObjectValue.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXObjectValue.h"

#import "PXExpressionEnvironment.h"

#import "PXBooleanValue.h"
#import "PXStringValue.h"
#import "PXDoubleValue.h"
#import "PXMarkValue.h"
#import "PXUndefinedValue.h"

#import "PXObjectForEachMethod.h"
#import "PXObjectKeysMethod.h"
#import "PXObjectLengthMethod.h"
#import "PXObjectReverseMethod.h"
#import "PXObjectValuesMethod.h"

@implementation PXObjectValue
{
    NSMutableOrderedSet *_propertyNames;
    NSMutableDictionary *_properties;
}

#pragma mark - Static Methods

static NSDictionary *METHODS;

+ (void)initialize
{
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        METHODS = @{
            @"forEach": [[PXObjectForEachMethod alloc] init],
            @"keys": [[PXObjectKeysMethod alloc] init],
            @"length": [[PXObjectLengthMethod alloc] init],
            @"reverse": [[PXObjectReverseMethod alloc] init],
            @"values": [[PXObjectValuesMethod alloc] init]
        };
    });
}

+ (PXObjectValue *)objectFromEnvironment:(PXExpressionEnvironment *)env
{
    // collect args
    PXObjectValue *object = [[PXObjectValue alloc] init];

    // grab all arguments from the stack so we clean it up properly
    id<PXExpressionValue> value = [env popValue];
    id<PXExpressionValue> key = [env popValue];
    id<PXExpressionValue> mark = [PXMarkValue mark];

    while (key != nil && value != nil && key != mark)
    {
        [object setValue:value forPropertyName:key.stringValue];

        value = [env popValue];
        key = [env popValue];
    }

    // items come in reversed, so reverse to correct order
    [object reverse];

    return object;
}

+ (PXObjectValue *)objectFromEnvironment:(PXExpressionEnvironment *)env withCount:(uint)count
{
    // collect args
    PXObjectValue *object = [[PXObjectValue alloc] init];

    // grab all arguments from the stack so we clean it up properly
    for (uint i = 0; i < count; i++)
    {
        id<PXExpressionValue> value = [env popValue];
        id<PXExpressionValue> key = [env popValue];

        [object setValue:value forPropertyName:key.stringValue];
    }

    // items come in reversed, so reverse to correct order
    [object reverse];
    
    return object;
}

#pragma mark - Initializers

- (id)init
{
    if (self = [super initWithValueType:PX_VALUE_TYPE_OBJECT])
    {
        _propertyNames = [[NSMutableOrderedSet alloc] init];
        _properties = [[NSMutableDictionary alloc] init];
    }

    return self;
}

#pragma mark - Getters

- (uint)length
{
    return (uint)_propertyNames.count;
}

- (NSArray *)propertyNames
{
    return [_propertyNames array];
}

- (NSArray *)propertyValues
{
    NSMutableArray *result = [[NSMutableArray alloc] init];

    [_propertyNames enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
        [result addObject:[_properties objectForKey:propertyName]];
    }];

    return [result copy];
}

#pragma mark - Methods

- (void)setValue:(id<PXExpressionValue>)value forPropertyName:(NSString *)name
{
    if (name.length > 0)
    {
        if ([_propertyNames containsObject:name] == false)
        {
            [_propertyNames addObject:name];
        }

        _properties[name] = value;
    }
}

- (void)setBooleanValue:(BOOL)value forPropertyName:(NSString *)name
{
    [self setValue:[[PXBooleanValue alloc] initWithBoolean:value] forPropertyName:name];
}

- (void)setStringValue:(NSString *)value forPropertyName:(NSString *)name
{
    [self setValue:[[PXStringValue alloc] initWithString:value] forPropertyName:name];
}

- (void)setDoubleValue:(double)value forPropertyName:(NSString *)name
{
    [self setValue:[[PXDoubleValue alloc] initWithDouble:value] forPropertyName:name];
}

- (id<PXExpressionValue>)valueForPropertyName:(NSString *)name
{
    id<PXExpressionFunction> method = [METHODS objectForKey:name];

    if (method != nil)
    {
        return method;
    }
    else if ([_propertyNames containsObject:name])
    {
        return _properties[name];
    }
    else
    {
        return [PXUndefinedValue undefined];
    }
}

- (void)reverse
{
    _propertyNames = [NSMutableOrderedSet orderedSetWithOrderedSet:[_propertyNames reversedOrderedSet]];
}

#pragma mark - Overrides

- (NSString *)stringValue
{
    if (_properties.count > 0)
    {
        NSMutableArray *parts = [[NSMutableArray alloc] init];

        // NOTE: This does not indent nested objects and doesn't detect cycles (will loop indefinitely)

        [_propertyNames enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
            id<PXExpressionValue> value = _properties[name];

            [parts addObject:[NSString stringWithFormat:@"  '%@': %@", name, value.description]];
        }];

        return [NSString stringWithFormat:@"{\n%@\n}", [parts componentsJoinedByString:@",\n"]];
    }
    else
    {
        return @"{}";
    }
}

- (NSString *)description
{
    NSMutableArray *parts = [[NSMutableArray alloc] init];

    [_propertyNames enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
        id<PXExpressionValue> value = _properties[name];

        [parts addObject:[NSString stringWithFormat:@"'%@': %@", name, value.description]];
    }];

    return [NSString stringWithFormat:@"{%@}", [parts componentsJoinedByString:@", "]];
}

@end
