    //
//  PXObjectValueWrapper.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/14/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXObjectValueWrapper.h"
#import <objc/runtime.h>

#import "PXDoubleProperty.h"
#import "PXStringProperty.h"

#import "PXBooleanValue.h"
#import "PXDoubleValue.h"
#import "PXStringValue.h"
#import "PXArrayValue.h"
#import "PXObjectValue.h"
#import "PXUndefinedValue.h"
#import "PXFunctionValueBase.h"

#import "PXExpressionProperty.h"

@interface PXObjectValueWrapper ()
@property (nonatomic, strong, readonly) id object;
@property (nonatomic, strong, readonly) NSMutableDictionary *properties;
@end

@implementation PXObjectValueWrapper

#pragma mark - Initializers

- (id)init
{
    return [self initWithObject:self];
}

- (id)initWithObject:(id)object
{
    if (self = [super init])
    {
        _object = object;
        _properties = [[NSMutableDictionary alloc] init];
    }

    return self;
}

#pragma mark - Methods

- (void)addExports
{
    Class c = [_object class];
    Protocol *protocol = NULL;

    unsigned int protocolCount;
    __unsafe_unretained Protocol **protocols = class_copyProtocolList(c, &protocolCount);

    for (unsigned int i = 0; i < protocolCount && protocol == NULL; i++)
    {
        Protocol *candidate = protocols[i];

        unsigned int adoptedProtocolCount;
        __unsafe_unretained Protocol **adoptedProtocols = protocol_copyProtocolList(candidate, &adoptedProtocolCount);

        for (unsigned int j = 0; j < adoptedProtocolCount; j++)
        {
            Protocol *adopted = adoptedProtocols[j];
            NSString *name = [NSString stringWithCString:protocol_getName(adopted) encoding:NSUTF8StringEncoding];

            if ([name isEqualToString:@"PXExpressionExports"])
            {
                protocol = candidate;
                break;
            }
        }

        free(adoptedProtocols);
    }

    free(protocols);

    if (protocol != NULL)
    {
        unsigned int propertyCount;
        objc_property_t *properties = protocol_copyPropertyList(protocol, &propertyCount);

        for (unsigned int i = 0; i < propertyCount; i++)
        {
            [self addObjcProperty:properties[i]];
        }

        free(properties);
    }
}

- (void)addProperties:(NSArray *)propertyNames
{
    [propertyNames enumerateObjectsUsingBlock:^(NSString *propertyName, NSUInteger idx, BOOL *stop) {
        [self addProperty:propertyName];
    }];
}

- (void)addProperty:(NSString *)propertyName
{
    Class c = [_object class];
    objc_property_t property = NULL;

    // find property
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(c, &outCount);

    for (unsigned int i = 0; i < outCount; i++)
    {
        objc_property_t candidate = properties[i];
        NSString *name = [NSString stringWithCString:property_getName(candidate) encoding:NSUTF8StringEncoding];

        if ([name isEqualToString:propertyName])
        {
            property = candidate;
            break;
        }
    }

    free(properties);

    [self addObjcProperty:property];
}

- (void)addGetterSelector:(SEL)getterSelector
           setterSelector:(SEL)setterSelector
                  forName:(NSString *)name
                 withType:(PXExpressionValueType)type
{
    if (name.length > 0)
    {
        switch (type)
        {
            case PX_VALUE_TYPE_DOUBLE:
            {
                PXDoubleProperty *property =
                    [[PXDoubleProperty alloc] initWithInstance:_object
                                                getterSelector:getterSelector
                                                setterSelector:setterSelector];

                [_properties setObject:property forKey:name];
                break;
            }

            case PX_VALUE_TYPE_STRING:
            {
                PXStringProperty *property =
                    [[PXStringProperty alloc] initWithInstance:_object
                                               getterSelector:getterSelector
                                               setterSelector:setterSelector];

                [_properties setObject:property forKey:name];
                break;
            }
                
            default:
                NSLog(@"Unsupported value type: %lu", (unsigned long)type);
                break;
        }
    }
}

#pragma mark - PXExpressionObject Implementation

- (uint)length
{
    return (uint)_properties.count;
}

- (NSArray *)propertyNames
{
    return [_properties allKeys];
}

- (NSArray *)propertyValues
{
    NSMutableArray *result = [[NSMutableArray alloc] init];

    [self.propertyNames enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [result addObject:[self valueForPropertyName:key]];
    }];

    return [result copy];
}

- (id<PXExpressionValue>)valueForPropertyName:(NSString *)name
{
    id<PXExpressionValue> candidate = [super valueForPropertyName:name];

    if ([candidate isKindOfClass:[PXFunctionValueBase class]])
    {
        return candidate;
    }
    else
    {
        id<PXExpressionProperty> property = [_properties objectForKey:name];

        return [property getExpressionValueFromObject:_object];
    }
}

- (void)setValue:(id<PXExpressionValue>)value forPropertyName:(NSString *)name
{
    PXDoubleProperty *property = [_properties objectForKey:name];

    [property setExpressionValue:value onObject:_object];
}

#pragma mark - Helper functions

- (void)addObjcProperty:(objc_property_t)property
{
    if (property != NULL)
    {
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        NSString *attributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        NSString *getterName = propertyName;
        NSString *setterName = [NSString stringWithFormat:@"set%@%@:", [[propertyName substringToIndex:1] uppercaseString], [propertyName substringFromIndex:1]];
        SEL getter = NSSelectorFromString(getterName);
        SEL setter = NSSelectorFromString(setterName);

        // TODO: actually parse attributes so we can get read-only, getter/setter names, etc.
        if ([attributes hasPrefix:@"Td"])
        {
            [self addGetterSelector:getter setterSelector:setter forName:propertyName withType:PX_VALUE_TYPE_DOUBLE];
        }
        else if ([attributes hasPrefix:@"T@\"NSString\""])
        {
            [self addGetterSelector:getter setterSelector:setter forName:propertyName withType:PX_VALUE_TYPE_STRING];
        }
    }
}

@end
