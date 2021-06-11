/**
 * Example 11: Trapping underflow (FE_UNDERFLOW)
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

  float small1 = 2.0e-38;
  float small2 = 1.0e-38;
  printf("small1 - small2 = %f\n", small1 - small2);

  printf("Enabling FE_UNDERFLOW...\n");
  feenableexcept(FE_UNDERFLOW);
  printf("Computing small1 - small2...\n");
  printf("%f\n", small1 - small2);
}
