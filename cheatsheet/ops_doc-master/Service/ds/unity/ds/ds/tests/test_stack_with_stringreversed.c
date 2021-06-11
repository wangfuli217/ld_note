#include <stdio.h>

#include "stack.h"


void reverse (int A[], unsigned size)
{
  int n = size;
  struct stack * s = stack_create(n);

  int i;
  for (i = 0; i < n; ++i) stack_push (s, A[i]);
  for (i = 0; i < n; ++i) A[i] = stack_pop (s);
}


int main ()
{
  int A[3] = {1, 2, 3};

  reverse(A, 3);
  int i;
  for (i = 0; i < 3; ++i) { printf("%d ", A[i]); }

  return 0;
}
