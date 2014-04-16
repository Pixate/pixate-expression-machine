//
//  PXStringProperty.m
//  pixate-freestyle
//
//  Created by Kevin Lindsey on 4/16/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXStringProperty.h"
#import "PXStringValue.h"
#import "PXUndefinedValue.h"

typedef NSString * (*StringGetterImp)(id object, SEL selector);
typedef void (*StringSetterImp)(id object, SEL selector, NSString *value);

@interface PXStringProperty ()
@property (nonatomic) SEL getterSelector;
@property (nonatomic) StringGetterImp getterImp;
@property (nonatomic) SEL setterSelector;
@property (nonatomic) StringSetterImp setterImp;
@end

@implementation PXStringProperty

#pragma mark - Initializers

- (id)initWithInstance:(id)instance getterName:(NSString *)getterName setterName:(NSString *)setterName
{
    return [self initWithInstance:instance
                   getterSelector:NSSelectorFromString(getterName)
                   setterSelector:NSSelectorFromString(setterName)];
}

- (id)initWithInstance:(id)instance getterSelector:(SEL)getterSelector setterSelector:(SEL)setterSelector
{
    if (self = [super init])
    {
        _getterSelector = getterSelector;
        _setterSelector = setterSelector;

        if (_getterSelector != NULL && [instance respondsToSelector:_getterSelector])
        {
            _getterImp = (StringGetterImp) [instance methodForSelector:_getterSelector];
        }

        if (_setterSelector != NULL && [instance respondsToSelector:_setterSelector])
        {
            _setterImp = (StringSetterImp) [instance methodForSelector:_setterSelector];
        }
    }

    return self;
}

#pragma mark - Methods

- (NSString *)getWithObject:(id)object
{
    return (_getterImp) ? (*_getterImp)(object, _getterSelector) : nil;
}

- (void)setValue:(NSString *)value withObject:(id)object
{
    if (_setterImp)
    {
        (*_setterImp)(object, _setterSelector, value);
    }
}

#pragma mark - PXExpressionProperty Implementation

- (id<PXExpressionValue>)getExpressionValueFromObject:(id)object
{
    NSString *result = (_getterImp) ? (*_getterImp)(object, _getterSelector) : nil;

    return (result != nil) ? [[PXStringValue alloc] initWithString:result] : [PXUndefinedValue undefined];
}

- (void)setExpressionValue:(id<PXExpressionValue>)value onObject:(id)object
{
    if (_setterImp)
    {
        (*_setterImp)(object, _setterSelector, value.stringValue);
    }
}

@end
