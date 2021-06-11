#include <stdio.h>
#include <stdlib.h>

#include "unity.h"
#include "stacklist.h"


void test_stacklist (void)
{
  struct stacknode * root = NULL;
  stacklist_push (&root, 10);
  stacklist_push (&root, 20);
  stacklist_push (&root, 30);

  printf("%d popped from stack\n", stacklist_pop(&root));
  printf("top element is %d\n", stacklist_peek(root));

  return 0;
}


int main (void)
{
  UNITY_BEGIN ();
  RUN_TEST (test_stacklist);
  return UNITY_END ();
}
