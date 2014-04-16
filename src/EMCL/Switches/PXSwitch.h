//
//  PXSwitch.h
//  Protostyle
//
//  Created by Kevin Lindsey on 3/27/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXCommand.h"

@protocol PXSwitch <NSObject>

@property (nonatomic, strong, readonly) NSString *displayName;
@property (nonatomic, strong, readonly) NSString *shortDescription;
@property (nonatomic, strong, readonly) NSString *longDescription;
@property (nonatomic, strong, readonly) NSArray *switchNames;

- (id<PXCommand>)createCommand;
- (BOOL)processArgs:(NSArray *)arg atIndex:(uint *)index;

@end
