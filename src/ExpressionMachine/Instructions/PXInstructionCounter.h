//
//  PXInstructionCounter.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/22/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXInstructionProcessor.h"

@interface PXInstructionCounter : PXInstructionProcessor

- (void)reset;
- (void)dump;

@end
