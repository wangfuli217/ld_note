#include <stdio.h>
#include <stdlib.h>

#include "unity.h"
#include "stack.h"


void test_stack (void)
{
  struct stack * s = stack_create(100);
  stack_push(s, 10);
  stack_push(s, 20);
  stack_push(s, 30);
  printf("%d popped from stack\n", stack_pop(s));

  return 0;
}


int main (void)
{
  UNITY_BEGIN ();
  RUN_TEST (test_stack);
  return UNITY_END ();
}
