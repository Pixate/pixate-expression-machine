//
//  PXByteCodeFunction.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/28/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXByteCodeFunction.h"
#import "PXExpressionUnit.h"
#import "PXScope.h"
#import "PXUndefinedValue.h"
#import "PXExpressionByteCode.h"
#import "PXExpressionNodeUtils.h"
#import "PXParameter.h"

@interface PXByteCodeFunction ()
@property (nonatomic, strong) PXScope *scope;
@end
@implementation PXByteCodeFunction

#pragma mark - Initializers

- (id)initWithUnit:(PXExpressionUnit *)unit
{
    return [self initWithUnit:unit parameters:nil];
}

- (id)initWithUnit:(PXExpressionUnit *)unit parameters:(NSArray *)parameters
{
    if (self = [super init])
    {
        _unit = unit;
        _parameters = parameters;
        _scope = [[PXScope alloc] init];
    }

    return self;
}

#pragma mark - Overrides

- (void)invokeWithEnvironment:(PXExpressionEnvironment *)env
             invocationObject:(id<PXExpressionValue>)invocationObject
                         args:(id<PXExpressionArray>)args
{
    if (_unit)
    {
        // add parameters and default values
        [_parameters enumerateObjectsUsingBlock:^(PXParameter *parameter, NSUInteger idx, BOOL *stop) {
            if (idx < args.length)
            {
                [_scope setValue:[args valueForIndex:(uint)idx] forSymbolName:parameter.name];
            }
            else
            {
                [_scope setValue:parameter.defaultValue forSymbolName:parameter.name];
            }
        }];

        // add arguments to scope
        [_scope setValue:args forSymbolName:@"arguments"];

        // add invocation object to scope
        [_scope setValue:invocationObject forSymbolName:@"this"];

        // push scope
        [env pushScope:_scope];

        // execute code
        [env executeUnit:_unit];

        // pop scope
        [env popScope];
        [_scope removeAllSymbols];
    }
}

- (NSString *)description
{
    NSMutableArray *parts = [[NSMutableArray alloc] init];

    // add declaration
    [parts addObject:[self declaration]];

    // add short assembly instructions
    [parts addObject:_unit.byteCode.description];

    // close body
    [parts addObject:@"}"];

    return [parts componentsJoinedByString:@" "];
}

- (NSString *)longDescription
{
    NSMutableArray *parts = [[NSMutableArray alloc] init];

    // add declaration
    [parts addObject:[self declaration]];

    // show byte code, indented one tab stop
    NSArray *lines = [_unit.byteCode.description componentsSeparatedByString:@"\n"];

    [lines enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {
        [parts addObject:[NSString stringWithFormat:@"  %@", line]];
    }];

    // close body
    [parts addObject:@"}"];

    return [parts componentsJoinedByString:@"\n"];
}

- (NSString *)declaration
{
    // Create list of parameters with default values
    NSMutableArray *params = [[NSMutableArray alloc] init];

    [_parameters enumerateObjectsUsingBlock:^(PXParameter *parameter, NSUInteger idx, BOOL *stop) {
        [params addObject:parameter.description];
    }];

    // build declaration
    return [NSString stringWithFormat:@"func(%@) {", [params componentsJoinedByString:@","]];
}

@end
