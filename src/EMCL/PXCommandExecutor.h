//
//  PXCommandExecutor.h
//  Protostyle
//
//  Created by Kevin Lindsey on 3/27/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXCommandExecutor : NSObject

- (void)processArgs:(NSArray *)args;
- (void)run;

@end
