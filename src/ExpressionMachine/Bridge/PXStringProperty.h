//
//  PXStringProperty.h
//  pixate-freestyle
//
//  Created by Kevin Lindsey on 4/16/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXStringProperty : NSString

- (id)initWithInstance:(id)instance getterName:(NSString *)getterName setterName:(NSString *)setterName;
- (id)initWithInstance:(id)instance getterSelector:(SEL)getterSelector setterSelector:(SEL)setterSelector;

- (NSString *)getWithObject:(id)object;
- (void)setValue:(NSString *)value withObject:(id)object;

@end
