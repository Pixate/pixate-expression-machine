//
// Numerical Constants
//
sym E                = 2.71828182845904523536028747135266250;   // e
sym LOG2E            = 1.44269504088896340735992468100189214;   // log2(e)
sym LOG10E           = 0.434294481903251827651128918916605082;  // log10(e)
sym LN2              = 0.693147180559945309417232121458176568;  // loge(2)
sym LN10             = 2.30258509299404568401799145468436421;   // loge(10)
sym PI               = 3.14159265358979323846264338327950288;   // pi
sym π                = 3.14159265358979323846264338327950288;   // pi
sym PI_OVER_TWO      = 1.57079632679489661923132169163975144;   // pi/2
sym PI_OVER_FOUR     = 0.785398163397448309615660845819875721;  // pi/4
sym ONE_OVER_PI      = 0.318309886183790671537767526745028724;  // 1/pi
sym TWO_OVER_PI      = 0.636619772367581343075535053490057448;  // 2/pi
sym TWO_OVER_SQRT_PI = 1.12837916709551257389615890312154517;   // 2/sqrt(pi)
sym SQRT2            = 1.41421356237309504880168872420969808;   // sqrt(2)
sym ONE_OVER_SQRT2   = 0.707106781186547524400844362104849039;  // 1/sqrt(2)

//
// Named Color Constants
//
sym black    = rgb(  0,   0,   0);
sym blue     = rgb(  0,   0, 255);
sym darkGrey = rgb(169, 169, 169);
sym green    = rgb(  0, 128,   0);
sym orange   = rgb(255, 165,   0);
sym red      = rgb(255,   0,   0);
sym white    = rgb(255, 255, 255);
sym yellow   = rgb(255, 255,   0);

//
// The min function returns the smaller of two values
//
func min(a, b) {
  (a < b) ? a : b;
}

//
// The max function returns the larger of two values
//
func max(a, b) {
  (a > b) ? a : b;
}

//
// The abs function returns the negation of negative numbers and
// returns positive numbers untouched
//
func abs(a) {
  (a < 0) ? -a : a;
}

//
// The clamp function is used to guarantee that a value lies within a
// well-defined range. If the number is below the range, then the 'low'
// value will be returned. If the number is above the range, then the
// 'high' value will be returned. Otherwise, the number will be returned
// untouched
//
func clamp(value, low = 0, high = 1) {
  min(high, max(low, value));
}


//
// The normalize function is used to map a value to a percentage within
// a range. The result is typically a value between 0 and 1; however, it
// is possible to provide a value outside of the range, resulting in
// negative values and values over 1
//
func normalize(value, low, high, clampResult=false) {
  sym result = (value - low) / (high - low);

  clampResult ? clamp(result) : result;
}

//
// The distance function is used to find the distance between two points
//
func distance(x1, y1, x2, y2) {
  sym dx = x2 - x1;
  sym dy = y2 - y1;

  √(dx*dx + dy*dy);
}

//
// Linearly interpolate a value between start and end using t as a
// percentage. If t is zero, this returns start. If t is one, this
// returns end. For all values in between zero and one, a percentage
// between start and end is returned.
//
// Note that t may be outside the close interval [0,1]; however, it
// usually expected to be clamped to that interval
//
func lerp(start, end, t) {
  start + (end - start) * t;
}

//
// Map a value from one range to a value in another range. This finds
// the percentage the value is between start1 and end1. This percentage
// is then applied to start2 and end2 to find the mapped value.
//
func map(value, start1, end1, start2, end2, clampResult=false) {
  lerp(
    start2,
    end2,
    normalize(value, start1, end1, clampResult)
  );
}

//
// URLs
//

//
// This function returns whatever value is passed to it. The value is
// expected to be a string.
//
func url() {
  arguments.join();
}

//
// Easing Functions
//

// linear easing

func linear(t) {
  t;
}

// quadratic easings

func quadraticIn(t) {
  t * t;
}

func quadraticOut(t) {
  -(t * (t - 2));
}

func quadraticInOut(t) {
  if (t < 0.5) {
    2 * t * t;
  }
  else {
    (-2 * t * t) + (4 * t) - 1;
  }
}

func quadraticInAndBack(t) {
  if (t < 0.5) {
    sym t2 = t * 2;

    t2 * t2;
  }
  else {
    sym t2 = (t - 0.5) * 2;

    1 - t2 * t2;
  }
}

func quadraticOutAndBack(t) {
  if (t < 0.5) {
    sym t2 = t * 2;

    -t2 * (t2 - 2.0);
  }
  else {
    sym rc = 1.0 - 0.5;
    sym t2 = (t - 0.5) * (1.0 / rc);

    1 + t2 * (t2 - 1.0 - rc);
  }
}

// cubic easings

func cubicIn(t) {
  t * t * t;
}

func cubicOut(t) {
  sym s = t - 1;

  s * s * s + 1;
}

func cubicInOut(t) {
  if (t < 0.5) {
    4 * t * t * t;
  }
  else {
    sym s = 2 * t - 2;

    0.5 * s * s * s + 1;
  }
}

// quartic easings

func quarticIn(t) {
  t * t * t * t;
}

func quarticOut(t) {
  sym s = t - 1;

  s * s * s * (1 - s) + 1;
}

func quarticInOut(t) {
  if (t < 0.5) {
    8 * t * t * t * t;
  }
  else {
    sym s = t - 1;

    -8 * s * s * s * s + 1;
  }
}

// quintic easings

func quinticIn(t) {
  t * t * t * t * t;
}

func quinticOut(t) {
  sym s = t - 1;

  s * s * s * s * s + 1;
}

func quinticInOut(t) {
  if (t < 0.5) {
    16 * t * t * t * t * t;
  }
  else {
    sym s = (2 * t) - 2;

    0.5 * s * s * s * s * s + 1;
  }
}

// sine easings

func sineIn(t) {
  sin((t - 1) * PI_OVER_TWO) + 1;
}

func sineOut(t) {
  sin(t * PI_OVER_TWO);
}

func sineInOut(t) {
  0.5 * (1 - cos(t * π));
}

// exponential easings

func exponentialIn(t) {
  if (t == 0) {
    0.0;
  }
  else {
    pow(2, 10 * (t - 1));
  }
}

func exponentialOut(t) {
  if (t == 0) {
    0.0;
  }
  else {
    pow(2, 10 * (t - 1));
  }
}

func exponentialInOut(t) {
  if (t == 0.0 || t == 1.0) {
    t;
  }
  elsif (t < 0.5) {
    0.5 * pow(2, (20 * t) - 10);
  }
  else {
    -0.5 * pow(2, (-20 * t) + 10) + 1;
  }
}

// circular easings

func circularIn(t) {
  1 - √(1 - (t * t));
}

func circularOut(t) {
  √((2 - t) * t);
}

func circularInOut(t) {
  if (t < 0.5) {
    0.5 * (1 - √(1 - 4 * (t * t)));
  }
  else {
    0.5 * ( √(-((2 * t) - 3) * ((2 * t) - 1)) + 1 );
  }
}

// elastic easings

func elasticIn(t) {
  sin(13 * PI_OVER_TWO * t) * pow(2, 10 * (t - 1));
}

func elasticOut(t) {
  sin(-13 * PI_OVER_TWO * (t + 1)) * pow(2, -10 * t) + 1;
}

func elasticInOut(t) {
  if (t < 0.5) {
    0.5 * sin(13 * PI_OVER_TWO * (2 * t)) * pow(2, 10 * ((2 * t) - 1));
  }
  else {
    0.5 * (sin(-13 * PI_OVER_TWO * ((2 * t - 1) + 1)) * pow(2, -10 * (2 * t - 1)) + 2);
  }
}

// back easings

func backIn(t) {
  t * t * t - t * sin(t * π);
}

func backOut(t) {
  sym s = 1 - t;

  1 - (s * s * s - s * sin(s * π));
}

func backInOut(t) {
  if (t < 0.5) {
    sym s = 2 * t;

    0.5 * (s * s * s - s * sin(s * π));
  }
  else {
    sym s = (1 - (2 * t - 1));

    0.5 * (1 - (s * s * s - s * sin(s * π))) + 0.5;
  }
}

// bounce easings

func bounceIn(t) {
  1 - bounceOut(1 - t);
}

func bounceOut(t) {
  if (t < 4 / 11) {
    (121 * t * t) / 16;
  }
  elsif (t < 8 / 11) {
    (363 / 40 * t * t) - (99 / 10 * t) + 17 / 5;
  }
  elsif (t < 9 / 10) {
    (4356 / 361 * t * t) - (35442 / 1805 * t) + 16061 / 1805;
  }
  else {
    (54 / 5 * t * t) - (513 / 25 * t) + 268 / 25;
  }
}

func bounceInOut(t) {
  if (t < 0.5) {
    bounceIn(t * 2) * 0.5;
  }
  else {
    bounceOut(t * 2 - 1) * 0.5 + 0.5;
  }
}

//
// Geometry Functions
//

func point(x, y) {
  {
    type: 'point',
    x: x,
    y: y
  };
}

func size(width, height) {
  {
    type: 'size',
    width: width,
    height: height
  };
}

//
// The rect function returns an object representing the bounds of a rectangle
//
func rect(x, y, width, height) {
  {
    type: 'rect',
    x: x,
    y: y,
    width: width,
    height: height
  };
}

//
// Color Functions
//

//
// Create an 'rgba' object using the specified values. The red, green, and blue
// values are expected to be integers in the closed interval [0,255]. The alpha
// channel is set to 1.0.
//
func rgb(red, green, blue) {
  {
    type: 'rgba',
    red: red,
    green: green,
    blue: blue,
    alpha: 1.0
  };
}

//
// Create an 'rgba' object using the specified values. The red, green, and blue
// values are expected to be integers in the closed interval [0,255]. The alpha
// value is expected to be a double in the closed interval [0,1].
func rgba(red, green, blue, alpha) {
  {
    type: 'rgba',
    red: red,
    green: green,
    blue: blue,
    alpha: alpha
  };
}

//
// Create an 'hsla' object using the specified values. The hue value is expected to
// be an angle in degrees. Saturation, and lightness values are expected to be
// doubles in the closed interval [0,1]. The alpha channel is set to 1.0.
//
func hsl(hue, saturation, lightness) {
  {
    type: 'hsla',
    hue: hue,
    saturation: saturation,
    lightness: lightness,
    alpha: 1.0
  };
}

//
// Create an 'hsla' object using the specified values. The hue value is expected to
// be an angle in degrees. Saturation, lightness, and alpha values are expected to
// be doubles in the closed interval [0,1]
//
func hsla(hue, saturation, lightness, alpha) {
  {
    type: 'hsla',
    hue: hue,
    saturation: saturation,
    lightness: lightness,
    alpha: alpha
  };
}

//
// Create an 'hsba' object using the specified values. The hue value is expected to
// be an angle in degrees. Saturation, and brightness values are expected to be
// doubles in the closed interval [0,1]. The alpha channel is set to 1.0.
//
func hsb(hue, saturation, brightness) {
  {
    type: 'hsba',
    hue: hue,
    saturation: saturation,
    brightness: brightness,
    alpha: 1.0
  };
}

//
// Create an 'hsba' object using the specified values. The hue value is expected to
// be an angle in degrees. Saturation, brightness, and alpha values are expected to
// be doubles in the closed interval [0,1]
//
func hsba(hue, saturation, brightness, alpha) {
  {
    type: 'hsba',
    hue: hue,
    saturation: saturation,
    brightness: brightness,
    alpha: alpha
  };
}
