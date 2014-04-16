//
//  PXExecuteFile.h
//  Protostyle
//
//  Created by Kevin Lindsey on 3/27/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXCommand.h"

@interface PXExecuteFileCommand : NSObject <PXCommand>

@property (nonatomic, strong, readonly) NSString *filename;

- (id)initWithFilename:(NSString *)filename;

@end
