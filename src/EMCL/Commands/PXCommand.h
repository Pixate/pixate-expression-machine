//
//  PXExpressionCommand.h
//  Protostyle
//
//  Created by Kevin Lindsey on 3/27/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXCommandContext.h"

@protocol PXCommand <NSObject>

- (BOOL)executeWithContext:(PXCommandContext *)context;

@end
