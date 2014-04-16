//
//  PXPropertyTestClass.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/14/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionExports.h"

@protocol PXTestExports <PXExpressionExports>

@property (nonatomic) double count;
@property (nonatomic) NSString *name;

@end

@interface PXPropertyTestClass : NSObject <PXTestExports>

@end
