//
//  PXInstructionProcessor.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/8/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXExpressionInstruction.h"
#import "PXExpressionEnvironment.h"

@interface PXInstructionProcessor : NSObject

- (void)processInstructions:(NSArray *)instructions withEnvironment:(PXExpressionEnvironment *)env;
- (void)processInstruction:(PXExpressionInstruction *)instruction withEnvironment:(PXExpressionEnvironment *)env;

@end
