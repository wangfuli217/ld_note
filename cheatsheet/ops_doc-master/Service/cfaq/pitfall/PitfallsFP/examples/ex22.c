/**
 * Example 22: Reciprocal math. Reducing the number of divisions can increase
 * performance because the division operation is generally much slower than
 * multiplication.
 */

#include <stdio.h>

int main(void)
{
  // Divison
  float x = 2.0;
  float y = 6.0;
  float a = x / y;
  printf("By division: %f\n", a);

  // Reciprocal multiplication
  float y1 = 1.0 / y;
  a = x*y1;
  printf("By reciprocal multiply: %f\n", a);
}
