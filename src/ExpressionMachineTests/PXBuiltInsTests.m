//
//  PXBuiltInsTests.m
//  pixate-expression-machine
//
//  Created by Kevin Lindsey on 3/1/14.
//  Copyright (c) 2014 Pixate, Inc. All rights reserved.
//

#import "PXExpressionValueAssertions.h"
#import "PXSquareFunction.h"
#import "PXExpressionEnvironment.h"
#import "PXExpressionAssembler.h"
#import "PXExpressionParser.h"
#import "PXExpressionUnit.h"

@interface PXBuiltInsTests : PXExpressionValueAssertions

@end

@implementation PXBuiltInsTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

#pragma mark - Math tests

- (void)assertDouble:(double)expected forSource:(NSString *)source
{
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
    PXExpressionParser *compiler = [[PXExpressionParser alloc] init];
    PXExpressionUnit *unit = [compiler compileString:source];

    [env executeUnit:unit];
    id<PXExpressionValue> result = [env popValue];

    [self assertDoubleValue:result expected:expected];
}

- (void)testNormalize
{
    [self assertDouble:0.5 forSource:@"normalize(50, 0, 100)"];
}

- (void)testNormalizeWithClamp
{
    [self assertDouble:1.0 forSource:@"normalize(150, 0, 100, true)"];
}

- (void)testLerp
{
    [self assertDouble:25.0 forSource:@"lerp(0, 100, 0.25)"];
}

- (void)testMap
{
    [self assertDouble:200.0 forSource:@"map(25, 0, 100, 100, 500)"];
}

- (void)testMapWithClamp
{
    [self assertDouble:500.0 forSource:@"map(125, 0, 100, 100, 500, true)"];
}

- (void)testSquare
{
    PXSquareFunction *square = [[PXSquareFunction alloc] init];
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
    PXExpressionAssembler *assembler = [[PXExpressionAssembler alloc] init];
    PXExpressionUnit *unit = [assembler assembleString:@">(1)"];

    [env pushDouble:3.0];
    [env pushGlobal];
    [env pushValue:square];
    [env executeUnit:unit];

    id<PXExpressionValue> result = [env popValue];

    XCTAssertNotNil(result, @"Expected a result after calling the square function");
    XCTAssertTrue(result.valueType == PX_VALUE_TYPE_DOUBLE, @"Expected a double value result");
    XCTAssertTrue(result.doubleValue == 9.0, @"Expected 9");
}

#pragma mark - Shape tests

- (void)assertObject:(NSDictionary *)expected forSource:(NSString *)source
{
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
    PXExpressionParser *compiler = [[PXExpressionParser alloc] init];
    PXExpressionUnit *unit = [compiler compileString:source];

    [env executeUnit:unit];
    id<PXExpressionValue> result = [env popValue];

    [self assertObjectValue:result expected:expected];
}

- (void)testPoint
{
    NSDictionary *expected = @{@"type": @"point", @"x": @10.0, @"y": @11.0};

    [self assertObject:expected forSource:@"point(10, 11)"];
}

- (void)testSize
{
    NSDictionary *expected = @{@"type": @"size", @"width": @100.0, @"height": @101.0};

    [self assertObject:expected forSource:@"size(100, 101)"];
}

- (void)testRect
{
    NSDictionary *expected = @{@"type": @"rect", @"x": @10.0, @"y": @11.0, @"width": @100.0, @"height": @101.0};

    [self assertObject:expected forSource:@"rect(10, 11, 100, 101)"];
}

#pragma mark - Color tests

- (void)testRGB
{
    NSDictionary *expected = @{@"type": @"rgba", @"red": @128, @"green": @0, @"blue": @255, @"alpha": @1};

    [self assertObject:expected forSource:@"rgb(128, 0, 255)"];
}

- (void)testRGBA
{
    NSDictionary *expected = @{@"type": @"rgba", @"red": @128, @"green": @0, @"blue": @255, @"alpha": @0.5};

    [self assertObject:expected forSource:@"rgba(128, 0, 255, 0.5)"];
}

- (void)testHSL
{
    NSDictionary *expected = @{@"type": @"hsla", @"hue": @180, @"saturation": @0.5, @"lightness": @0.25, @"alpha": @1};

    [self assertObject:expected forSource:@"hsl(180, 0.5, 0.25)"];
}

- (void)testHSLA
{
    NSDictionary *expected = @{@"type": @"hsla", @"hue": @180, @"saturation": @0.5, @"lightness": @0.25, @"alpha": @0.75};

    [self assertObject:expected forSource:@"hsla(180, 0.5, 0.25, 0.75)"];
}

- (void)testHSB
{
    NSDictionary *expected = @{@"type": @"hsba", @"hue": @180, @"saturation": @0.5, @"brightness": @0.25, @"alpha": @1};

    [self assertObject:expected forSource:@"hsb(180, 0.5, 0.25)"];
}

- (void)testHSBA
{
    NSDictionary *expected = @{@"type": @"hsba", @"hue": @180, @"saturation": @0.5, @"brightness": @0.25, @"alpha": @0.75};

    [self assertObject:expected forSource:@"hsba(180, 0.5, 0.25, 0.75)"];
}

#pragma mark - Named color tests

- (void)testBlue
{
    NSDictionary *expected = @{@"type": @"rgba", @"red": @0, @"green": @0, @"blue": @255, @"alpha": @1};

    [self assertObject:expected forSource:@"blue"];
}

- (void)testDarkGrey
{
    NSDictionary *expected = @{@"type": @"rgba", @"red": @169, @"green": @169, @"blue": @169, @"alpha": @1};

    [self assertObject:expected forSource:@"darkGrey"];
}

- (void)testOrange
{
    NSDictionary *expected = @{@"type": @"rgba", @"red": @255, @"green": @165, @"blue": @0, @"alpha": @1};

    [self assertObject:expected forSource:@"orange"];
}

- (void)testRed
{
    NSDictionary *expected = @{@"type": @"rgba", @"red": @255, @"green": @0, @"blue": @0, @"alpha": @1};

    [self assertObject:expected forSource:@"red"];
}

#pragma mark - URL tests

- (void)assertString:(NSString *)expected forSource:(NSString *)source
{
    PXExpressionEnvironment *env = [[PXExpressionEnvironment alloc] init];
    PXExpressionParser *compiler = [[PXExpressionParser alloc] init];
    PXExpressionUnit *unit = [compiler compileString:source];

    [env executeUnit:unit];
    id<PXExpressionValue> result = [env popValue];

    [self assertStringValue:result expected:expected];
}

- (void)testURL
{
    [self assertString:@"image.png" forSource:@"url('image.png')"];
}

- (void)testURLCombined
{
    [self assertString:@"http://www.example.com/image.png" forSource:@"url('http://www.example.com/', 'image.png')"];
}

@end
