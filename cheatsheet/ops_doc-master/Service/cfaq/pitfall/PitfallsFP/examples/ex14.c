/**
 * Example 14: Denormal maths
 *
 * Since standard headers do not often contain all of these values, we
 * construct these values here by manually setting the correct bits of
 * their representation.
 */

#include <stdio.h>
#include "fputil.h"

int main(void)
{
  bitdouble d_min, d_min_next;
  d_min.bits = 0x0010000000000000ULL;
  d_min_next.bits = 0x0010000000000001ULL;
  printf("X = %18.16e\n", d_min.dbl);
  printf("Y = %18.16e\n", d_min_next.dbl);
  printf("Y - X = %18.16e\n", d_min_next.dbl - d_min.dbl);

  return 0;
}
