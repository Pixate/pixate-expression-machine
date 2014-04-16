//
//  PXExpressionValue.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef NS_ENUM
#define NS_ENUM(type, name) type name; enum
#endif

typedef NS_ENUM(NSInteger, PXExpressionValueType)
{
    PX_VALUE_TYPE_UNKNOWN,

    PX_VALUE_TYPE_BOOLEAN,
    PX_VALUE_TYPE_DOUBLE,
    PX_VALUE_TYPE_STRING,
    PX_VALUE_TYPE_ARRAY,
    PX_VALUE_TYPE_OBJECT,
    PX_VALUE_TYPE_FUNCTION,

    PX_VALUE_TYPE_NULL,
    PX_VALUE_TYPE_UNDEFINED,

    PX_VALUE_TYPE_BLOCK,
    PX_VALUE_TYPE_MARK
};

@protocol PXExpressionValue <NSObject>

@property (nonatomic, readonly) PXExpressionValueType valueType;
@property (nonatomic, readonly) BOOL booleanValue;
@property (nonatomic, strong, readonly) NSString *stringValue;
@property (nonatomic, readonly) double doubleValue;

@end
