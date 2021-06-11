/**
 * 
 * Example 2: Computing MAXLONG_NEXT (the next floating point number after the
 * FP approximation of MAXLONG) by setting the last bit of the mantissa.
 *
 * Larger floating point numbers are spaced further apart.
 */

#include <stdio.h>
#include <values.h>
#include "fputil.h"

int main(void)
{
  bitfloat m;
  // FP representation of MAXLONG
  m.flt = MAXLONG;
  printf("(float) MAXLONG      = %f\n", m.flt);
  
  // Flip the last bit of m (m's mantissa) to 1
  m.bits = m.bits | 0x1U;
  printf("(float) MAXLONG_NEXT = %f\n", m.flt);

  return 0;
}
