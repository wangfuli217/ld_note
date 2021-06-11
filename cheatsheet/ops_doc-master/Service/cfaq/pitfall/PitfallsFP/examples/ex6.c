/**
 * Example 6 - Generation and propagation of some Inf and Nan values.
 *
 * The sign bit of a NaN does not matter - however, on many architectures,
 * the sign bit is set for a "quiet NaN", which does not normally raise
 * an exception when used as an operand, and is cleared for a "signalling
 * NaN", which usually does raise an exception when used as an operand.
 * Thus, on many architectures, the printed value of the NaN values
 * here may appear negative.
 */

#include <stdio.h>
#include <math.h>
#include "fputil.h"

int main(void)
{
  printf("1.0 / 0.0 = %f\n", 1.0 / 0.0);
  printf("-1.0 / 0.0 = %f\n", -1.0 / 0.0);
 
  double pos_inf = get_pos_inf();
  double neg_inf = get_neg_inf();
  printf("0.0 / 0.0 = %f\n", 0.0 / 0.0);
  printf("inf / inf = %f\n", pos_inf / pos_inf);
  printf("inf + (-inf) = %f\n", pos_inf + neg_inf);
  printf("0 * inf = %f\n", pos_inf * 0.0);
  
  printf("sqrt(-1.0) = %f\n", sqrt(-1.0));
  return 0;
}
