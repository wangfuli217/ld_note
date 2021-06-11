/**
 * Maximum and minimum representable normal non-zero float and double values.
 */

#include <stdio.h>
#include <values.h>

int main(void)
{
  printf("FLT_MIN = %e\n", FLT_MIN);
  printf("FLT_MAX = %e\n", FLT_MAX);
  printf("DBL_MIN = %e\n", DBL_MIN);
  printf("DBL_MAX = %e\n", DBL_MAX);

  return 0;
}
