/**
 * Example 9: Catching division by zero (FE_DIVBYZERO)
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

  printf("1.0/0.0 = %f\n", 1.0/0.0);

  printf("Enabling FE_DIVBYZERO...\n");
  feenableexcept(FE_DIVBYZERO);
  printf("Computing 1.0/0.0...\n");
  printf("%f\n", 1.0/0.0);
}
