//
//  PXDoubleProperty.h
//  Protostyle
//
//  Created by Kevin Lindsey on 3/14/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXDoubleProperty : NSObject

- (id)initWithInstance:(id)instance getterName:(NSString *)getterName setterName:(NSString *)setterName;
- (id)initWithInstance:(id)instance getterSelector:(SEL)getterSelector setterSelector:(SEL)setterSelector;

- (double)getWithObject:(id)object;
- (void)setValue:(double)value withObject:(id)object;

@end
