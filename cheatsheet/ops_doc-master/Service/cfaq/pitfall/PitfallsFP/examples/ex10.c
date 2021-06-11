/**
 * Example 10: Trapping overflow (FE_OVERFLOW)
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

  float big1 = 3.4e+38;
  float big2 = 1.0e+36;
  printf("big1 + big2 = %f\n", big1 + big2);

  printf("Enabling FE_OVERFLOW...\n");
  feenableexcept(FE_OVERFLOW);
  printf("Computing big1 + big2...\n");
  printf("%f\n", big1 + big2);
}
