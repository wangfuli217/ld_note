/**
 * Example 23: Non-associativity of floating point arithmetic. The order
 * in which addition operations are performed in this example affects
 * the result. When a large and small number are added together, the digits
 * of the small one (c in (b + c) ) are lost.
 */
#include <stdio.h>

int main(void)
{
  float a = 1.0e23;
  float b = -1.0e23;
  float c = 1.0;
  printf("(a + b) + c = %f\n", (a + b) + c);
  printf("a + (b + c) = %f\n", a + (b + c));
}
