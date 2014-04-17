//
//  PXExpressionEnvironment.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 2/25/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionEnvironment.h"

#import "PXInstructionCounter.h"
#import "PXInstructionProcessor.h"
#import "PXExpressionByteCode.h"
#import "PXExpressionUnit.h"

#import "PXBuiltInScope.h"
#import "PXBooleanValue.h"
#import "PXDoubleValue.h"
#import "PXStringValue.h"
#import "PXNullValue.h"
#import "PXUndefinedValue.h"

@interface PXExpressionEnvironment ()
@property (nonatomic, strong) NSMutableArray *stack;
@property (nonatomic, strong) id<PXExpressionScope> globalScope;
@property (nonatomic, strong) id<PXExpressionValue> globalObject;
@end

@implementation PXExpressionEnvironment

#pragma mark - Static Methods

+ (PXInstructionProcessor *)processor
{
    // NOTE: not using dispatch_once so this will compile under GNUstep
    static PXInstructionProcessor *PROCESSOR;

    @synchronized(self)
    {
        if (PROCESSOR == nil)
        {
            PROCESSOR = [[PXInstructionProcessor alloc] init];
        }
    }

    return PROCESSOR;
}

#pragma mark - Initializers

- (id)init
{
    return [self initWithGlobalScope:nil];
}

- (id)initWithGlobalScope:(id<PXExpressionScope>)globalScope
{
    if (self = [super init])
    {
        _stack = [[NSMutableArray alloc] init];
        _currentScope = (globalScope != nil) ? globalScope : [[PXBuiltInScope alloc] init];
        _globalScope = _currentScope;
        _globalObject = ([_globalScope conformsToProtocol:@protocol(PXExpressionObject)])
            ? (id<PXExpressionObject>) _globalScope
            : [PXUndefinedValue undefined];
    }

    return self;
}

#pragma mark - Compile and Execution Methods

- (void)reset
{
    // clear the stack
    [_stack removeAllObjects];

    // reset the scope chain
    id<PXExpressionScope> scope = [self popScope];

    while (scope != nil)
    {
        scope = [self popScope];
    }
}

- (void)executeByteCode:(PXExpressionByteCode *)byteCode
{
    PXInstructionProcessor *processor = [[self class] processor];

    [processor processInstructions:byteCode.instructions withEnvironment:self];
}

- (void)executeUnit:(PXExpressionUnit *)unit
{
    if (unit.scope != nil)
    {
        [self pushScope:unit.scope];
    }

    //[self executeByteCode:unit.byteCode];
    [self executeByteCode:unit.optimizedByteCode];

    if (unit.scope != nil)
    {
        [self popScope];
    }
}

#pragma mark - Stack Methods

- (void)pushValue:(id<PXExpressionValue>)value
{
    if (value == nil)
    {
#if DEBUG
        [self logMessage:@"Tried to push nil to the value stack. Using PXNullValue in its place"];
#endif
        value = [PXNullValue null];
    }

    [_stack addObject:value];
}

- (void)pushBoolean:(BOOL)booleanValue
{
    [self pushValue:[[PXBooleanValue alloc] initWithBoolean:booleanValue]];
}

- (void)pushDouble:(double)doubleValue
{
    [self pushValue:[[PXDoubleValue alloc] initWithDouble:doubleValue]];
}

- (void)pushString:(NSString *)stringValue
{
    [self pushValue:[[PXStringValue alloc] initWithString:stringValue]];
}

- (void)pushNullValue
{
    [self pushValue:[PXNullValue null]];
}

- (void)pushUndefinedValue
{
    [self pushValue:[PXUndefinedValue undefined]];
}

- (void)pushGlobal
{
    [self pushValue:self.globalObject];
}

- (id<PXExpressionValue>)popValue
{
    id<PXExpressionValue> result = nil;

    if (_stack.count > 0)
    {
        result = [_stack lastObject];
        [_stack removeLastObject];
    }

    return result;
}

- (NSArray *)popCount:(NSUInteger)count
{
    count = MIN(count, _stack.count);

    NSRange range = NSMakeRange(_stack.count - count, count);
    NSArray *result = [_stack subarrayWithRange:range];

    [_stack removeObjectsInRange:range];

    return result;
}

- (void)duplicateValue
{
    if (_stack.count > 0)
    {
        [_stack addObject:[_stack lastObject]];
    }
}

- (void)swapValues
{
    NSUInteger count = _stack.count;

    if (count > 1)
    {
        [_stack exchangeObjectAtIndex:count - 1 withObjectAtIndex:count - 2];
    }
}

- (id<PXExpressionValue>)peek
{
    return [_stack lastObject];
}

#pragma mark - Scope Methods

- (void)pushScope:(id<PXExpressionScope>)scope
{
    if (scope != nil)
    {
        // make sure this scope isn't already in the scope chain
        BOOL present = NO;
        id<PXExpressionScope> candidate = _currentScope;

        while (candidate != nil)
        {
            if (scope == candidate)
            {
                NSLog(@"Scope already exists in scope chain: %@", scope);
                present = YES;
                break;
            }
            else
            {
                candidate = candidate.parentScope;
            }
        }

        if (present == NO)
        {
            scope.parentScope = _currentScope;
            _currentScope = scope;
        }
    }
}

- (id<PXExpressionScope>)popScope
{
    id<PXExpressionScope> result = nil;

    if (_currentScope != _globalScope)
    {
        result = _currentScope;
        _currentScope = _currentScope.parentScope;
        result.parentScope = nil;
    }

    return result;
}

- (id<PXExpressionValue>)getSymbol:(NSString *)name
{
    return [_currentScope valueForSymbolName:name];
}

- (void)setValue:(id<PXExpressionValue>)value forSymbol:(NSString *)symbol
{
    [_currentScope setValue:value forSymbolName:symbol];
}

#pragma mark - Debug Helpers

- (void)logMessage:(NSString *)message
{
    // TODO: Allow log output destination to be customized
    NSLog(@"%@", message);
}

#if DEBUG

- (NSString *)stackDescription
{
    NSMutableArray *parts = [[NSMutableArray alloc] init];

    [_stack enumerateObjectsUsingBlock:^(id<PXExpressionValue> item, NSUInteger idx, BOOL *stop) {
        [parts addObject:item.description];
    }];

    return [parts componentsJoinedByString:@" "];
}

#endif

@end
