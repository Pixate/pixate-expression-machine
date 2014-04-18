//
//  PXExpressionPropertyTests.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/14/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionValueAssertions.h"
#import "PXObjectValueWrapper.h"
#import "PXPropertyTestClass.h"
#import "PXDoubleValue.h"
#import "PXStringValue.h"

@interface PXExpressionPropertyTests : PXExpressionValueAssertions

@end

@implementation PXExpressionPropertyTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Manual Setup Tests

- (void)testDoubleGetter
{
    PXPropertyTestClass *object = [[PXPropertyTestClass alloc] init];
    PXObjectValueWrapper *wrapper = [[PXObjectValueWrapper alloc] initWithObject:object];
    NSString *encoding = [NSString stringWithCString:@encode(double) encoding:NSUTF8StringEncoding];

    [wrapper addGetterSelector:@selector(count) setterSelector:@selector(setCount:) forName:@"count" withEncoding:encoding];

    id<PXExpressionValue> result = [wrapper valueForPropertyName:@"count"];

    [self assertDoubleValue:result expected:7.0];
}

- (void)testDoubleSetter
{
    PXPropertyTestClass *object = [[PXPropertyTestClass alloc] init];
    PXObjectValueWrapper *wrapper = [[PXObjectValueWrapper alloc] initWithObject:object];
    NSString *encoding = [NSString stringWithCString:@encode(double) encoding:NSUTF8StringEncoding];

    [wrapper addGetterSelector:@selector(count) setterSelector:@selector(setCount:) forName:@"count" withEncoding:encoding];

    [wrapper setValue:[[PXDoubleValue alloc] initWithDouble:10.5] forPropertyName:@"count"];
    id<PXExpressionValue> result = [wrapper valueForPropertyName:@"count"];

    [self assertDoubleValue:result expected:10.5];
}

- (void)testStringGetter
{
    PXPropertyTestClass *object = [[PXPropertyTestClass alloc] init];
    PXObjectValueWrapper *wrapper = [[PXObjectValueWrapper alloc] initWithObject:object];
    NSString *encoding = [NSString stringWithCString:@encode(NSString) encoding:NSUTF8StringEncoding];

    [wrapper addGetterSelector:@selector(name) setterSelector:@selector(setName:) forName:@"name" withEncoding:encoding];

    id<PXExpressionValue> result = [wrapper valueForPropertyName:@"name"];

    [self assertStringValue:result expected:@"testing"];
}

- (void)testStringSetter
{
    PXPropertyTestClass *object = [[PXPropertyTestClass alloc] init];
    PXObjectValueWrapper *wrapper = [[PXObjectValueWrapper alloc] initWithObject:object];
    NSString *encoding = [NSString stringWithCString:@encode(NSString) encoding:NSUTF8StringEncoding];

    [wrapper addGetterSelector:@selector(name) setterSelector:@selector(setName:) forName:@"name" withEncoding:encoding];

    [wrapper setValue:[[PXStringValue alloc] initWithString:@"hello"] forPropertyName:@"name"];
    id<PXExpressionValue> result = [wrapper valueForPropertyName:@"name"];

    [self assertStringValue:result expected:@"hello"];
}

#pragma mark - Automatic Setup Tests

- (void)testDoubleGetterAutoWrapped
{
    PXPropertyTestClass *object = [[PXPropertyTestClass alloc] init];
    PXObjectValueWrapper *wrapper = [[PXObjectValueWrapper alloc] initWithObject:object];
    [wrapper addExports];

    id<PXExpressionValue> result = [wrapper valueForPropertyName:@"count"];

    [self assertDoubleValue:result expected:7.0];
}

- (void)testDoubleSetterAutoWrapped
{
    PXPropertyTestClass *object = [[PXPropertyTestClass alloc] init];
    PXObjectValueWrapper *wrapper = [[PXObjectValueWrapper alloc] initWithObject:object];
    [wrapper addExports];

    [wrapper setValue:[[PXDoubleValue alloc] initWithDouble:10.5] forPropertyName:@"count"];
    id<PXExpressionValue> result = [wrapper valueForPropertyName:@"count"];

    [self assertDoubleValue:result expected:10.5];
}

- (void)testStringGetterAutoWrapped
{
    PXPropertyTestClass *object = [[PXPropertyTestClass alloc] init];
    PXObjectValueWrapper *wrapper = [[PXObjectValueWrapper alloc] initWithObject:object];
    [wrapper addExports];

    id<PXExpressionValue> result = [wrapper valueForPropertyName:@"name"];

    [self assertStringValue:result expected:@"testing"];
}

- (void)testStringSetterAutoWrapped
{
    PXPropertyTestClass *object = [[PXPropertyTestClass alloc] init];
    PXObjectValueWrapper *wrapper = [[PXObjectValueWrapper alloc] initWithObject:object];
    [wrapper addExports];

    [wrapper setValue:[[PXStringValue alloc] initWithString:@"hello"] forPropertyName:@"name"];
    id<PXExpressionValue> result = [wrapper valueForPropertyName:@"name"];

    [self assertStringValue:result expected:@"hello"];
}

@end
