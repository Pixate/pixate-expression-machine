//
//  PXExpressionValueBase.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionValueBase.h"

@implementation PXExpressionValueBase

@synthesize valueType = _valueType;

#pragma mark - Initializers

- (id)initWithValueType:(PXExpressionValueType)type
{
    if (self = [super init])
    {
        _valueType = type;
    }

    return self;
}

- (BOOL)booleanValue
{
    switch (_valueType)
    {
        case PX_VALUE_TYPE_NULL:
        case PX_VALUE_TYPE_UNDEFINED:
        case PX_VALUE_TYPE_UNKNOWN:
            return NO;

        case PX_VALUE_TYPE_DOUBLE:
            return (self.doubleValue != 0.0);

        default:
            return YES;
    }
}

- (NSString *)stringValue
{
    switch (_valueType)
    {
        case PX_VALUE_TYPE_BOOLEAN:
            return @"[value Boolean]";

        case PX_VALUE_TYPE_DOUBLE:
            return @"[value Double]";

        case PX_VALUE_TYPE_STRING:
            return @"[value String]";

        case PX_VALUE_TYPE_ARRAY:
            return @"[value Array]";

        case PX_VALUE_TYPE_OBJECT:
            return @"[value Object]";

        case PX_VALUE_TYPE_FUNCTION:
            return @"[value Function]";

        case PX_VALUE_TYPE_NULL:
            return @"[value Null]";

        case PX_VALUE_TYPE_UNDEFINED:
            return @"[value Undefined]";

        case PX_VALUE_TYPE_BLOCK:
            return @"[value Block]";

        case PX_VALUE_TYPE_MARK:
            return @"[value Mark]";

        case PX_VALUE_TYPE_UNKNOWN:
        default:
            return @"<unknown>";
    }
}

- (double)doubleValue
{
    return NAN;
}

#pragma mark - Overrides

- (NSString *)description
{
    return self.stringValue;
}

@end
