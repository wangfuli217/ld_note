/**
 * Example 21: some comparisons of exceptional values.
 */

#include <stdio.h>
#include <math.h>
#include "fputil.h"

int main(void)
{
  printf("False is 0 and True is 1:\n\n");

  // Positive and negative zero
  printf("-0 == 0 is %d\n", -0 == 0);

  // Inf comparisons
  printf("Inf == Inf is %d\n", get_pos_inf() == get_pos_inf());
  printf("-Inf == -Inf is %d\n", get_neg_inf() == get_neg_inf());
  printf("-Inf == Inf is %d\n", get_neg_inf() == get_pos_inf());

  // NaN comparisons
  printf("NaN == NaN is %d\n", get_nan() == get_nan());
  printf("Inf == NaN is %d\n", get_pos_inf() == get_nan());

  // Beware of NaNs if comparing less than and greater than - it is
  // not safe to conclude that lt == false and gt == false means
  // equality!
  printf("NaN  < 1.0 is %d\n", get_nan()  < 1.0);
  printf("NaN  > 1.0 is %d\n", get_nan()  > 1.0);
  printf("NaN == 1.0 is %d\n", get_nan() == 1.0);
  printf("isnan(NaN) is %d\n", isnan(get_nan()));
}
