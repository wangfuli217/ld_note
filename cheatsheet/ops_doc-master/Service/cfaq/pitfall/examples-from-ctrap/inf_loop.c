/*
 * Blocked by gcc stack protection
 */
#include<stdio.h>

int main()
{
  int i, a[10];
  for (i=1; i<=10; i++)
    a[i] = 0;
  return 0;
}
