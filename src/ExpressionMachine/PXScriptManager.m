//
//  PXScriptManager.m
//  Protostyle
//
//  Created by Kevin Lindsey on 1/29/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXScriptManager.h"
#import "PXByteCodeBuilder.h"
#import "PXExpressionUnit.h"

@interface PXScriptManager ()
@property (nonatomic, strong) PXExpressionEnvironment *environment;
@property (nonatomic, strong) PXByteCodeBuilder *compiler;
@property (nonatomic, strong) NSCache *scriptCache;
@end

@implementation PXScriptManager

#pragma mark - Static Methods

+ (PXScriptManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    static PXScriptManager *manager;

    dispatch_once(&onceToken, ^{
        manager = [[PXScriptManager alloc] init];
    });

    return manager;
}

#pragma mark - Initializers

- (id)init
{
    if (self = [super init])
    {
        _environment = [[PXExpressionEnvironment alloc] init];
        _compiler = [[PXByteCodeBuilder alloc] init];
        _scriptCache = [[NSCache alloc] init];
        [_scriptCache setCountLimit:100];
    }

    return self;
}

#pragma mark - Getters

- (id<PXExpressionScope>)globalScope
{
    return _environment.globalScope;
}

#pragma mark - Methods

- (id<PXExpressionValue>)evaluate:(NSString *)script withCurrentScope:(id<PXExpressionScope>)scope
{
    id<PXExpressionScope> savedScope = nil;

    if (scope != nil)
    {
        savedScope = _environment.currentScope;
        _environment.currentScope = scope;
    }

    id<PXExpressionValue> result = [self evaluate:script withScopes:nil];

    if (scope != nil)
    {
        _environment.currentScope = savedScope;
    }

    return result;
}

- (id<PXExpressionValue>)evaluate:(NSString *)script withScopes:(NSArray *)scopes
{
    id<PXExpressionValue> result = nil;

    if (script.length > 0)
    {
        PXExpressionUnit *unit = [_scriptCache objectForKey:script];

        if (unit == nil)
        {
            // compile expression
            unit = [_compiler compileExpression:script];

            // cache for potential later use
            [_scriptCache setObject:unit forKey:script];
        }

        if (unit != nil)
        {
            // setup scopes
            [scopes enumerateObjectsUsingBlock:^(id<PXExpressionScope> scope, NSUInteger idx, BOOL *stop) {
                [_environment pushScope:scope];
            }];

            @try {
                // run byte code
                [unit executeWithEnvironment:_environment];

                // grab result
                result = [_environment popValue];
            }
            @catch (NSException *exception) {
                NSString *message = [NSString stringWithFormat:@"An exception occurred while running the following script:\n%@\n\nExcption:\n%@", script, exception];

                [_environment logMessage:message];
            }

            // tear down scopes
            for (int i = 0; i < scopes.count; i++)
            {
                [_environment popScope];
            }
        }

//        NSLog(@"%@ => %@", script, result.stringValue);
    }


    return result;
}

@end
