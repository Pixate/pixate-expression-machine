//
//  PXExpressionParser.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/26/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXParserBase.h"
#import "PXExpressionUnit.h"

@interface PXExpressionParser : PXParserBase

- (PXExpressionUnit *)compileString:(NSString *)source;

@end
