//
//  PXExpressionInstruction.h
//  Protostyle
//
//  Created by Kevin Lindsey on 3/8/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXExpressionInstructionType.h"

@interface PXExpressionInstruction : NSObject

@property (nonatomic, readonly) PXExpressionInstructionType type;
@property (nonatomic, strong, readonly) NSString *stringValue;
@property (nonatomic, readonly) uint uintValue;

- (id)initWithType:(PXExpressionInstructionType)type;
- (id)initWithType:(PXExpressionInstructionType)type stringValue:(NSString *)stringValue;
- (id)initWithType:(PXExpressionInstructionType)type uint:(uint)uintValue;
- (id)initWithType:(PXExpressionInstructionType)type stringValue:(NSString *)stringValue uint:(uint)uintValue;

@end
