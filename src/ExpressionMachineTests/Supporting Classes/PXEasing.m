//
//  tXEasing.m
//  pixate-expression-machine
//
//  Created by Robin Debreuil on 1/20/2014.
//  Copyright (c) 2014 Pixate. All rights reserved.
//
// rewritten from AHEasing

#import "PXEasing.h"
#import <math.h>

@implementation PXEasing

+(double)easeType:(EasingType)type t:(double)t
{
    double result;
    switch (type)
    {
        case NoEasing:
            result = 1;
            break;
        case LinearEasing:
            result = [PXEasing Linear:t];
            break;
        case EaseInQuadEasing:
            result = [PXEasing EaseInQuad:t];
            break;
            
        case EaseOutQuadEasing:
            result = [PXEasing EaseOutQuad:t];
            break;
            
        case EaseInOutQuadEasing:
            result = [PXEasing EaseInOutQuad:t];
            break;
            
        case EaseInAndBackQuadEasing:
            result = [PXEasing EaseInAndBackQuad:t];
            break;
            
        case EaseOutAndBackQuadEasing:
            result = [PXEasing EaseOutAndBackQuad:t];
            break;
            
        case EaseInCubicEasing:
            result = [PXEasing EaseInCubic:t];
            break;
            
        case EaseOutCubicEasing:
            result = [PXEasing EaseOutCubic:t];
            break;
            
        case EaseInOutCubicEasing:
            result = [PXEasing EaseInOutCubic:t];
            break;
            
        case EaseInQuartEasing:
            result = [PXEasing EaseInQuart:t];
            break;
            
        case EaseOutQuartEasing:
            result = [PXEasing EaseOutQuart:t];
            break;
            
        case EaseInOutQuartEasing:
            result = [PXEasing EaseInOutQuart:t];
            break;
            
        case EaseInQuintEasing:
            result = [PXEasing EaseInQuint:t];
            break;
            
        case EaseOutQuintEasing:
            result = [PXEasing EaseOutQuint:t];
            break;
            
        case EaseInOutQuintEasing:
            result = [PXEasing EaseInOutQuint:t];
            break;
            
        case SinEasing:
            result = [PXEasing Sin:t];
            break;
            
        case CosEasing:
            result = [PXEasing Cos:t];
            break;
            
        case EaseInSine:
            result = [PXEasing EaseInSine:t];
            break;
            
        case EaseOutSine:
            result = [PXEasing EaseOutSine:t];
            break;
            
        case EaseInOutSine:
            result = [PXEasing EaseInOutSine:t];
            break;
            
        case EaseInExpo:
            result = [PXEasing EaseInExpo:t];
            break;
            
        case EaseOutExpo:
            result = [PXEasing EaseOutExpo:t];
            break;
            
        case EaseInOutExpo:
            result = [PXEasing EaseInOutExpo:t];
            break;
            
        case EaseInCirc:
            result = [PXEasing EaseInCirc:t];
            break;
            
        case EaseOutCirc:
            result = [PXEasing EaseOutCirc:t];
            break;
            
        case EaseInOutCirc:
            result = [PXEasing EaseInOutCirc:t];
            break;
            
        case EaseInElastic:
            result = [PXEasing EaseInElastic:t];
            break;
            
        case EaseOutElastic:
            result = [PXEasing EaseOutElastic:t];
            break;
            
        case EaseInOutElastic:
            result = [PXEasing EaseInOutElastic:t];
            break;

            
        case EaseInBack:
            result = [PXEasing EaseInBack:t];
            break;
            
        case EaseOutBack:
            result = [PXEasing EaseOutBack:t];
            break;
            
        case EaseInOutBack:
            result = [PXEasing EaseInOutBack:t];
            break;
            
        case EaseInBounce:
            result = [PXEasing EaseInBounce:t];
            break;
            
        case EaseOutBounce:
            result = [PXEasing EaseOutBounce:t];
            break;
            
        case EaseInOutBounce:
            result = [PXEasing EaseInOutBounce:t];
            break;
            
        default:
            result = t;
            break;
    }
    return result;
}

// simple linear tweening - no easing
+ (double) Linear:(double)t
{
    return t;
}


///////////// QUADRATIC EASING: t^2 ///////////////////

// quadratic easing in - accelerating from zero velocity
+ (double) EaseInQuad:(double)t
{
    return t * t;
}

// quadratic easing out - decelerating to zero velocity
+ (double) EaseOutQuad:(double)t
{
    return -(t * (t - 2));
}

// quadratic easing in/out - acceleration until halfway, then deceleration
+ (double) EaseInOutQuad:(double)t
{
    if(t < 0.5)
    {
        return 2 * t * t;
    }
    else
    {
        return (-2 * t * t) + (4 * t) - 1;
    }
}

+ (double) EaseInAndBackQuad:(double)t
{
    if (t < 0.5)
    {
        double t2 = t * 2;
        return t2 * t2;
    }
    else
    {
        double t2 = (t - .5) * 2;
        return 1 - t2 * t2;
        //return -length / 2f * ((--t) * (t - 2) - 1) + start;
    }
}

+ (double) EaseOutAndBackQuad:(double)t
{
    if (t < .5)
    {
        double t2 = t * 2;
        return -t2 * (t2 - 2.0f);
    }
    else
    {
        double rc = 1.0f - .5;
        double t2 = (t - .5) * (1.0f / rc);
        return 1 + t2 * (t2 - 1.0f - rc);
        //return -length / 2f * ((--t) * (t - 2) - 1) + start;
    }
}

///////////// CUBIC EASING: t^3 ///////////////////////

// cubic easing in - accelerating from zero velocity
+ (double) EaseInCubic:(double)t
{
    return t * t * t;
}

// cubic easing out - decelerating to zero velocity
+ (double) EaseOutCubic:(double)t
{
    t = t - 1;
    return t * t * t + 1;
}

// cubic easing in/out - acceleration until halfway, then deceleration
+ (double) EaseInOutCubic:(double)t
{
    if (t < .5)
    {
        return 4 * t * t * t;
    }
    else
    {
        t = 2 * t - 2;
        return .5 * t * t * t + 1;
    }
}


///////////// QUARTIC EASING: t^4 /////////////////////

// quartic easing in - accelerating from zero velocity
+ (double) EaseInQuart:(double)t
{
    return t * t * t * t;
}

// quartic easing out - decelerating to zero velocity
+ (double) EaseOutQuart:(double)t
{
    t = t - 1;
    return t * t * t * (1 - t) + 1;
}

// quartic easing in/out - acceleration until halfway, then deceleration
+ (double) EaseInOutQuart:(double)t
{
    if(t < 0.5)
    {
        return 8 * t * t * t * t;
    }
    else
    {
        double f = (t - 1);
        return -8 * f * f * f * f + 1;
    }
}


///////////// QUINTIC EASING: t^5  ////////////////////

// quintic easing in - accelerating from zero velocity
+ (double) EaseInQuint:(double)t
{
    return t * t * t * t * t;
}

// quintic easing out - decelerating to zero velocity
+ (double) EaseOutQuint:(double)t
{
    t = t - 1;
    return t * t * t * t * t + 1;
}

// quintic easing in/out - acceleration until halfway, then deceleration
+ (double) EaseInOutQuint:(double)t
{
    if(t < 0.5)
    {
        return 16 * t * t * t * t * t;
    }
    else
    {
        t = ((2 * t) - 2);
        return  0.5 * t * t * t * t * t + 1;
    }
}


+ (double) Sin:(double)t
{
    return sinf(t * M_PI * 2);
}
+ (double) Cos:(double)t
{
    return cosf(t * M_PI * 2);
}

///////////// SINUSOIDAL EASING: sin(t) ///////////////

// sinusoidal easing in - accelerating from zero velocity
+ (double) EaseInSine:(double)t
{
    return sin((t - 1) * M_PI_2) + 1;
}

// sinusoidal easing out - decelerating to zero velocity
+ (double) EaseOutSine:(double)t
{
    return sin(t * M_PI_2);
}

// sinusoidal easing in/out - accelerating until halfway, then decelerating
+ (double) EaseInOutSine:(double)t
{
    return 0.5 * (1 - cos(t * M_PI));
}

// exponential easing in - accelerating from zero velocity
+ (double) EaseInExpo:(double)t
{
    return (t == 0.0) ? t : pow(2, 10 * (t - 1));
}

// exponential easing out - decelerating to zero velocity
+ (double) EaseOutExpo:(double)t
{
    return (t == 0.0) ? t : pow(2, 10 * (t - 1));
}

// extonential easing in/out - accelerating until halfway, then decelerating
+ (double) EaseInOutExpo:(double)t
{
    if(t == 0.0 || t == 1.0) return t;
    
    if(t < 0.5)
    {
        return 0.5 * pow(2, (20 * t) - 10);
    }
    else
    {
        return -0.5 * pow(2, (-20 * t) + 10) + 1;
    }
}


/////////// CIRCULAR EASING: sqrt(1-t^2) //////////////

// circular easing in - accelerating from zero velocity
+ (double) EaseInCirc:(double)p
{
    return 1 - sqrt(1 - (p * p));
}

// circular easing out - decelerating to zero velocity
+ (double) EaseOutCirc:(double)p
{
    return sqrt((2 - p) * p);
}

// circular easing in/out - acceleration until halfway, then deceleration
+ (double) EaseInOutCirc:(double)p
{
    if(p < 0.5)
    {
        return 0.5 * (1 - sqrt(1 - 4 * (p * p)));
    }
    else
    {
        return 0.5 * (sqrt(-((2 * p) - 3) * ((2 * p) - 1)) + 1);
    }
}

+ (double) EaseInElastic:(double)p
{
    return sin(13 * M_PI_2 * p) * pow(2, 10 * (p - 1));
}

+ (double) EaseOutElastic:(double)p
{
    return sin(-13 * M_PI_2 * (p + 1)) * pow(2, -10 * p) + 1;
}

+ (double) EaseInOutElastic:(double)p
{
    if(p < 0.5)
    {
        return 0.5 * sin(13 * M_PI_2 * (2 * p)) * pow(2, 10 * ((2 * p) - 1));
    }
    else
    {
        return 0.5 * (sin(-13 * M_PI_2 * ((2 * p - 1) + 1)) * pow(2, -10 * (2 * p - 1)) + 2);
    }
}


/////////// BACK EASING: overshooting cubic easing: (s+1)*t^3 - s*t^2  //////////////

// back easing in - backtracking slightly, then reversing direction and moving to target
+ (double) EaseInBack:(double)t
{
    return t * t * t - t * sin(t * M_PI);
}

// back easing out - moving towards target, overshooting it slightly, then reversing and coming back to target
+ (double) EaseOutBack:(double)t
{
    t = 1 - t;
    return 1 - (t * t * t - t * sin(t * M_PI));
}

// back easing in/out - backtracking slightly, then reversing direction and moving to target,
+ (double) EaseInOutBack:(double)t
{
    if(t < 0.5)
    {
        double f = 2 * t;
        return 0.5 * (f * f * f - f * sin(f * M_PI));
    }
    else
    {
        double f = (1 - (2*t - 1));
        return 0.5 * (1 - (f * f * f - f * sin(f * M_PI))) + 0.5;
    }
}


/////////// BOUNCE EASING: exponentially decaying parabolic bounce  //////////////

// bounce easing in
+ (double) EaseInBounce:(double)t
{
    return 1 - [self EaseOutBounce:1 - t];
}

// bounce easing out
+ (double) EaseOutBounce:(double)t
{
    if(t < 4/11.0)
    {
        return (121 * t * t)/16.0;
    }
    else if(t < 8/11.0)
    {
        return (363/40.0 * t * t) - (99/10.0 * t) + 17/5.0;
    }
    else if(t < 9/10.0)
    {
        return (4356/361.0 * t * t) - (35442/1805.0 * t) + 16061/1805.0;
    }
    else
    {
        return (54/5.0 * t * t) - (513/25.0 * t) + 268/25.0;
    }
}

// bounce easing in/out
+ (double) EaseInOutBounce:(double)t
{
    if (t < .5f)
    {
        return [self EaseInBounce:t * 2] * 0.5f;
    }
    return [self EaseOutBounce:t * 2 - 1] * 0.5 + 0.5;
}

@end
