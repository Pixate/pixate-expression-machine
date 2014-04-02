//
//  PXExpressionAssembler.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/28/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXParserBase.h"
#import "PXExpressionUnit.h"

@interface PXExpressionAssembler : PXParserBase

- (PXExpressionUnit *)assembleString:(NSString *)source;

@end
