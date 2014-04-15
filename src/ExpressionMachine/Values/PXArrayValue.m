//
//  PXArrayValue.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/27/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXArrayValue.h"

#import "PXExpressionEnvironment.h"

#import "PXMarkValue.h"
#import "PXUndefinedValue.h"

#import "PXArrayEveryMethod.h"
#import "PXArrayFilterMethod.h"
#import "PXArrayForEachMethod.h"
#import "PXArrayJoinMethod.h"
#import "PXArrayLengthMethod.h"
#import "PXArrayMapMethod.h"
#import "PXArrayPopMethod.h"
#import "PXArrayPushMethod.h"
#import "PXArrayReduceMethod.h"
#import "PXArrayReverseMethod.h"
#import "PXArrayShiftMethod.h"
#import "PXArraySomeMethod.h"
#import "PXArrayUnshiftMethod.h"

@implementation PXArrayValue
{
    NSMutableArray *_elements;
}

#pragma mark - Static Methods

static NSDictionary *METHODS;

+ (void)initialize
{
    if (METHODS == nil)
    {
        METHODS = @{
            @"every": [[PXArrayEveryMethod alloc] init],
            @"filter": [[PXArrayFilterMethod alloc] init],
            @"forEach": [[PXArrayForEachMethod alloc] init],
            @"join": [[PXArrayJoinMethod alloc] init],
            @"length": [[PXArrayLengthMethod alloc] init],
            @"map": [[PXArrayMapMethod alloc] init],
            @"pop": [[PXArrayPopMethod alloc] init],
            @"push": [[PXArrayPushMethod alloc] init],
            @"reduce": [[PXArrayReduceMethod alloc] init],
            @"reverse": [[PXArrayReverseMethod alloc] init],
            @"shift": [[PXArrayShiftMethod alloc] init],
            @"some": [[PXArraySomeMethod alloc] init],
            @"unshift": [[PXArrayUnshiftMethod alloc] init]
        };
    };
}

+ (PXArrayValue *)arrayFromEnvironment:(PXExpressionEnvironment *)env
{
    // collect args
    PXArrayValue *array = [[PXArrayValue alloc] init];

    // grab all arguments from the stack so we clean it up properly
    id<PXExpressionValue> item = [env popValue];
    id<PXExpressionValue> mark = [PXMarkValue mark];

    while (item != nil && item != mark)
    {
        [array pushValue:item];
        item = [env popValue];
    }

    // items come in reversed, so reverse to correct order
    [array reverse];

    return array;
}

+ (PXArrayValue *)arrayFromEnvironment:(PXExpressionEnvironment *)env withCount:(uint)count
{
    // NOTE: Surprisingly, this code is faster then using -[PXExpressionEnvironment popCount:]

    // collect args
    PXArrayValue *array = [[PXArrayValue alloc] init];

    // grab all arguments from the stack so we clean it up properly
    for (uint i = 0; i < count; i++)
    {
        id<PXExpressionValue> item = [env popValue];

        [array pushValue:item];
    }

    // items come in reversed, so reverse to correct order
    [array reverse];

    return array;
}

#pragma mark - Initializers

- (id)init
{
    if (self = [super initWithValueType:PX_VALUE_TYPE_ARRAY])
    {
        _elements = [[NSMutableArray alloc] init];
    }

    return self;
}

#pragma mark - Getters

- (uint)length
{
    return (uint)_elements.count;
}

- (NSArray *)elements
{
    return [NSArray arrayWithArray:_elements];
}

#pragma mark - Methods

- (id<PXExpressionValue>)valueForIndex:(int)index
{
    // TODO: allow negative values to access from the end of the array
    return (0 <= index && index < _elements.count)
        ? [_elements objectAtIndex:index]
        : [PXUndefinedValue undefined];
}

- (void)setValue:(id<PXExpressionValue>)value forIndex:(int)index
{
    // TODO: allow negative values to set values from the end of the array
    if (value != nil)
    {
        // NOTE: objc will append the value if index is equal to the array's length
        [_elements setObject:value atIndexedSubscript:index];
    }
}

- (void)pushValue:(id<PXExpressionValue>)value
{
    if (value != nil)
    {
        [_elements addObject:value];
    }
}

- (id<PXExpressionValue>)popValue
{
    id<PXExpressionValue> result = nil;

    if (_elements.count > 0)
    {
        result = [_elements lastObject];
        [_elements removeLastObject];
    }

    return result;
}

- (id<PXExpressionValue>)shiftValue
{
    id<PXExpressionValue> result = nil;

    if (_elements.count > 0)
    {
        result = [_elements objectAtIndex:0];
        [_elements removeObjectAtIndex:0];
    }

    return result;
}

- (void)unshiftValue:(id<PXExpressionValue>)value
{
    if (value != nil)
    {
        [_elements insertObject:value atIndex:0];
    }
}

- (void)reverse
{
    if (_elements.count > 1)
    {
        uint startIndex = 0;
        uint endIndex = (uint)_elements.count - 1;

        while (startIndex < endIndex)
        {
            id<PXExpressionValue> start = [_elements objectAtIndex:startIndex];
            id<PXExpressionValue> end = [_elements objectAtIndex:endIndex];

            [_elements setObject:end atIndexedSubscript:startIndex];
            [_elements setObject:start atIndexedSubscript:endIndex];

            startIndex++;
            endIndex--;
        }
    }
}

#pragma mark - PXExpressionObject Implementation

- (NSArray *)propertyNames
{
    // TODO: Should we return methods name here?
    return nil;
}

- (NSArray *)propertyValues
{
    // TODO: Should we return methods here?
    return nil;
}

- (id<PXExpressionValue>)valueForPropertyName:(NSString *)name
{
    id<PXExpressionFunction> method = [METHODS objectForKey:name];

    return (method != nil) ? method : [PXUndefinedValue undefined];
}

- (void)setValue:(id<PXExpressionValue>)value forPropertyName:(NSString *)name
{
    // ignore
}

#pragma mark - Overrides

- (NSString *)stringValue
{
    NSMutableArray *parts = [[NSMutableArray alloc] init];

    [_elements enumerateObjectsUsingBlock:^(id<PXExpressionValue> item, NSUInteger idx, BOOL *stop) {
        [parts addObject:item.description];
    }];

    return [NSString stringWithFormat:@"[%@]", [parts componentsJoinedByString:@", "]];
}

@end
