/**
 * Example 13: math functions turning Inf into normal numbers
 *
 * There are probably more examples like this - these are two that I
 * found. The ISO C standard specifies the cases in which these functions
 * take exceptional values and return normal values.
 */

#include <stdio.h>
#include <math.h>
#include "fputil.h"

int main(void)
{
  printf("tanh(inf) = %f\n", tanh(get_pos_inf()));
  printf("atan(inf) = %f\n", atan(get_pos_inf()));

  return 0;
}
