//
//  PXExpressionPropertyTests.m
//  Protostyle
//
//  Created by Kevin Lindsey on 3/14/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PXObjectValueWrapper.h"
#import "PXPropertyTestClass.h"
#import "PXDoubleValue.h"

@interface PXExpressionPropertyTests : XCTestCase

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

- (void)testDoubleGetter
{
    PXPropertyTestClass *object = [[PXPropertyTestClass alloc] init];
    PXObjectValueWrapper *wrapper = [[PXObjectValueWrapper alloc] initWithObject:object];

    [wrapper addGetterSelector:@selector(length) setterSelector:@selector(setLength:) forName:@"length" withType:PX_VALUE_TYPE_DOUBLE];

    id<PXExpressionValue> result = [wrapper valueForPropertyName:@"length"];

    NSLog(@"result = %@", result);
}

- (void)testDoubleSetter
{
    PXPropertyTestClass *object = [[PXPropertyTestClass alloc] init];
    PXObjectValueWrapper *wrapper = [[PXObjectValueWrapper alloc] initWithObject:object];

    [wrapper addGetterSelector:@selector(length) setterSelector:@selector(setLength:) forName:@"length" withType:PX_VALUE_TYPE_DOUBLE];

    [wrapper setValue:[[PXDoubleValue alloc] initWithDouble:10.5] forPropertyName:@"length"];
    id<PXExpressionValue> result = [wrapper valueForPropertyName:@"length"];

    NSLog(@"result = %@", result);
}

@end
