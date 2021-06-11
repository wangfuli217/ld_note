/**
 * Example 5: Maximum and minimum denormal float and double values.
 *
 * Since standard headers do not often contain all of these values, we
 * construct these values here by manually setting the correct bits of
 * their representation.
 */

#include <stdio.h>
#include "fputil.h"

int main(void)
{
  bitfloat f_denorm_min, f_denorm_max;
  f_denorm_min.bits = 0x1U;
  f_denorm_max.bits = 0x7FFFFF;
  printf("Min float denormal = %e\n", f_denorm_min.flt);
  printf("Max float denormal = %e\n", f_denorm_max.flt);
  
  bitdouble d_denorm_min, d_denorm_max;
  d_denorm_min.bits = 0x1ULL;
  d_denorm_max.bits = 0xFFFFFFFFFFFFFULL;
  printf("Min double denormal = %e\n", d_denorm_min.dbl);
  printf("Max double denormal = %e\n", d_denorm_max.dbl);

  return 0;
}
