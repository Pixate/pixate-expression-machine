//
//  PXExpressionByteCode.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PXExpressionEnvironment;
@class PXInstructionProcessor;

@interface PXExpressionByteCode : NSObject

@property (nonatomic, strong, readonly) NSArray *instructions;

- (id)initWithInstructions:(NSArray *)instructions;

- (NSString *)shortDescription;

@end
