//
//  PXExecutionContext.h
//  Protostyle
//
//  Created by Kevin Lindsey on 3/27/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionEnvironment.h"
#import "PXExpressionUnit.h"

@interface PXCommandContext : NSObject

@property (nonatomic, strong, readonly) PXExpressionEnvironment *env;
@property (nonatomic, strong) NSString *inputFile;
@property (nonatomic, strong) PXExpressionUnit *unit;

@end
