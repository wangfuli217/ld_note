#include <stdio.h>
#include <stdlib.h>

#include "unity.h"
#include "circularlist.h"


void test_circularlist (void)
{
  struct clnode * last = NULL;
  last = circularlist_insertempty (last , 6);
  last = circularlist_insertbegin (last, 4);
  last = circularlist_insertbegin (last, 2);
  last = circularlist_insertend (last, 8);
  last = circularlist_insertend (last, 12);
  last = circularlist_insertafter (last, 10, 8);
  circularlist_traverse(last);

  struct clnode * split1 = NULL;
  struct clnode * split2 = NULL;
  circularlist_split (last, &split1, &split2);
  printf("\n"); circularlist_traverse (split1);
  printf("\n"); circularlist_traverse (split2);
}


int main (void)
{
  UNITY_BEGIN ();
  RUN_TEST (test_circularlist);
  return UNITY_END ();
}
