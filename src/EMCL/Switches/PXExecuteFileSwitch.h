//
//  PXExecuteFileSwitch.h
//  Protostyle
//
//  Created by Kevin Lindsey on 3/27/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXSwitch.h"

@interface PXExecuteFileSwitch : NSObject <PXSwitch>

@property (nonatomic, strong, readonly) NSString *filename;

@end
