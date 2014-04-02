//
//  PXObjectValueWrapper.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/14/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionObject.h"

@interface PXObjectValueWrapper : NSObject <PXExpressionObject>

- (id)initWithObject:(id)object;

- (void)addExports;
- (void)addProperties:(NSArray *)propertyNames;
- (void)addProperty:(NSString *)propertyName;
- (void)addGetterSelector:(SEL)getterSelector
           setterSelector:(SEL)setterSelector
                  forName:(NSString *)name
                 withType:(PXExpressionValueType)type;

@end
