//
//  PXAnimationManager.h
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 1/29/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXExpressionEnvironment.h"
#import "PXExpressionValue.h"

@interface PXScriptManager : NSObject

@property (nonatomic, strong, readonly) id<PXExpressionScope> globalScope;

+ (instancetype)sharedInstance;

- (id<PXExpressionValue>)evaluate:(NSString *)script withCurrentScope:(id<PXExpressionScope>)scope;
- (id<PXExpressionValue>)evaluate:(NSString *)script withScopes:(NSArray *)scopes;

@end
