/**
 * Example 12: Trapping invalid operands (FE_INVALID)
 *
 * This exception can often be produced by specifying operands to
 * math library functions outside their domain. In this example,
 * we attempt to take the inverse sine of 2.0, which is invalid
 * since sin(x) is in [-1, 1] for all x.
 */

// Needed to enable the use of feenableexcept
#define _GNU_SOURCE
#include <fenv.h>
#include <math.h>
#include <stdio.h>

int main(void)
{
  // Disable all exceptions to begin with
  feenableexcept(0);

  printf("asin(2.0) = %f\n", asin(2.0));

  printf("Enabling FE_INVALID...\n");
  feenableexcept(FE_INVALID);
  printf("Computing asin(2.0)...\n");
  printf("%f\n", asin(2.0));
}
