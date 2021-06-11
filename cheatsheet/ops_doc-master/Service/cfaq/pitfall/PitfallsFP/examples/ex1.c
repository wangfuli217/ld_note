/**
 * Example 1: Catastrophic cancellation in action.
 *
 * (float) MAXLONG is the closest approximation of MAXINT + MAXLONG
 * that a float can store.
 */

#include <stdio.h>
#include <values.h>

int main(void)
{
  float a = MAXINT;   //          2147483648
  float b = MAXLONG;  // 9223372036854775808
  float f = a + b;

  if (f == MAXLONG)
  {
    printf("f == MAXLONG\n");
  }
  else
  {
    printf("f != MAXLONG\n");
  }
  
  return 0;
}
