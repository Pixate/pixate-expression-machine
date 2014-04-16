//
//  PXDoubleProperty.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/14/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXDoubleProperty.h"
#import "PXDoubleValue.h"

typedef double (*DoubleGetterImp)(id object, SEL selector);
typedef void (*DoubleSetterImp)(id object, SEL selector, double value);

@interface PXDoubleProperty ()
@property (nonatomic) SEL getterSelector;
@property (nonatomic) DoubleGetterImp getterImp;
@property (nonatomic) SEL setterSelector;
@property (nonatomic) DoubleSetterImp setterImp;
@end

@implementation PXDoubleProperty

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
            _getterImp = (DoubleGetterImp) [instance methodForSelector:_getterSelector];
        }

        if (_setterSelector != NULL && [instance respondsToSelector:_setterSelector])
        {
            _setterImp = (DoubleSetterImp) [instance methodForSelector:_setterSelector];
        }
    }

    return self;
}

#pragma mark - Methods

- (double)getWithObject:(id)object
{
    return (_getterImp) ? (*_getterImp)(object, _getterSelector) : 0.0;
}

- (void)setValue:(double)value withObject:(id)object
{
    if (_setterImp)
    {
        (*_setterImp)(object, _setterSelector, value);
    }
}

#pragma mark - PXExpressionProperty Implementation

- (id<PXExpressionValue>)getExpressionValueFromObject:(id)object
{
    double result = (_getterImp) ? (*_getterImp)(object, _getterSelector) : 0.0;

    return [[PXDoubleValue alloc] initWithDouble:result];
}

- (void)setExpressionValue:(id<PXExpressionValue>)value onObject:(id)object
{
    if (_setterImp)
    {
        (*_setterImp)(object, _setterSelector, value.doubleValue);
    }
}

@end
