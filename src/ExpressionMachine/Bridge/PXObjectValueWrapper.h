//
//  PXObjectValueWrapper.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/14/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXObjectValue.h"
#import "PXExpressionProperty.h"

@interface PXObjectValueWrapper : PXObjectValue

@property (nonatomic, weak, readonly) id object;

+ (void)addPropertyClass:(Class)class forEncoding:(NSString *)encoding;

- (id)initWithObject:(id)object;

- (void)addExports;
- (void)addProperties:(NSArray *)propertyNames;
- (void)addProperty:(NSString *)propertyName;
- (void)addGetterSelector:(SEL)getterSelector
           setterSelector:(SEL)setterSelector
                  forName:(NSString *)name
             withEncoding:(NSString *)encoding;

@end
