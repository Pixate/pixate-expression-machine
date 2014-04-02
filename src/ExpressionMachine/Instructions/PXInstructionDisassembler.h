//
//  PXInstructionDisassembler.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/8/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionInstruction.h"

@interface PXInstructionDisassembler : NSObject

@property (nonatomic) BOOL useShortForm;

- (NSString *)disassembleInstruction:(PXExpressionInstruction *)instruction;

@end
