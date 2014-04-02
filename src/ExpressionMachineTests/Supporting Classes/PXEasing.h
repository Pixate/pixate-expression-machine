//
//  PXEasing.h
//  pixate-expression-machine
//
//  Created by Robin Debreuil on 1/20/2014.
//  Copyright (c) 2014 Pixate. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    NoEasing = 0,
    LinearEasing,
    EaseInQuadEasing,
    EaseOutQuadEasing,
    EaseInOutQuadEasing,
    EaseInCubicEasing,
    EaseOutCubicEasing,
    EaseInOutCubicEasing,
    EaseInQuartEasing,
    EaseOutQuartEasing, // 10
    EaseInOutQuartEasing,
    EaseInQuintEasing,
    EaseOutQuintEasing,
    EaseInOutQuintEasing,
    SinEasing,
    CosEasing,
    
    EaseInSine,
    EaseOutSine,
    EaseInOutSine,
    EaseInExpo, // 20
    EaseOutExpo,
    EaseInOutExpo,
    EaseInCirc,
    EaseOutCirc,
    EaseInOutCirc,
    EaseInElastic,
    EaseOutElastic,
    EaseInOutElastic,
    
    EaseInBounce,
    EaseOutBounce, // 30
    EaseInOutBounce,
    EaseInBack,
    EaseOutBack,
    EaseInAndBackQuadEasing,
    EaseOutAndBackQuadEasing,
    EaseInOutBack
    
} EasingType;

@interface PXEasing : NSObject

+ (double) easeType:(EasingType) type t:(double)t;

@end
