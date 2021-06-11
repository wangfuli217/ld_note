/**
 * Example 8: trapping rounding (FE_INEXACT)
 *
 * This can sometimes be fiddly to deliberately trigger - the following
 * works on my system (Linux x86_64, gcc 4.8.1).
 *
 * If it fails to produce "floating point exception" or similar on your
 * system, it may be possible to jiggle around operands/change values
 * to get it to trap.
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

  printf("1.1 * 1.2 * 1.3 = %f\n", 1.1 * 1.2 * 1.3);

  printf("Enabling FE_INEXACT...\n");
  feenableexcept(FE_INEXACT);
  printf("Computing 1.1 * 1.2 * 1.3...\n");
  
  float a = 1.1f;
  float b = 1.2f;
  float c = a * b * 1.3f;
  printf("c = %f\n", c); 
  return 0;
}
