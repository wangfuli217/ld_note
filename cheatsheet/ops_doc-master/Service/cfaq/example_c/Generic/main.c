#include <stdio.h>
#include <math.h>
 
// Possible implementation of the tgmath.h macro cbrt
#define cbrt(X) _Generic((X), long double:cbrtl, default:cbrt, const float:cbrtf, float:cbrtf)(X)
 
int main(void)
{
    double x = 8.0;
    const float y = 3.375;
    printf("cbrt(8.0) = %f\n", cbrt(x)); // selects the default cbrt
    printf("cbrtf(3.375) = %f\n", cbrt(y)); // gcc: converts const float to float,
                                            // then selects cbrtf
                                            // clang: selects cbrtf for const float
}