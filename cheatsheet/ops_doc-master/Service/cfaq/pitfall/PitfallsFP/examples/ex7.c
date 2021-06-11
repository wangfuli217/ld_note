/**
 * Example 7 - propagation of infinity.
 *
 * You may follow the propagation by uncommenting the printf,
 * or examining the value of n at each iteration in a debugger.
 */

#include <stdio.h>

int main(void)
{
  double n = 1000.0;
  for(double i = 0.0; i < 100.0; i += 1.0)
  {
    // Uncomment to see 1000.0 -> inf then propagate
    // printf("%f\n", n);
    n = n / i;
  }
  printf("After all loop iterations, n = %f\n", n); 
}
