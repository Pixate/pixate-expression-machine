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
// Make a shallow copy of an object. The first argument is the object
// to copy from. If only an object is specified, then all properties
// will be copied. Otherwise, a list of properties to copy may be
// specified as the second and greater arguments
//
func snapshot() {
    sym obj = arguments.shift();
    sym keys = (arguments.length() == 0) ? obj.keys() : arguments;
    sym result = {};

    keys.forEach(func(key) {
        result.push(key, obj{key});
    });

    result;
}

//
// URLs
//

//
// This function joins whatever values are passed to it. Values are
// expected to be a strings.
//
func url() {
  arguments.join();
}
