#include <stdio.h>
#include <stdlib.h>

#include "unity.h"
#include "heap.h"


void test_heap (void)
{
  struct heap * h = (struct heap *)malloc(sizeof(struct heap));
  minheap_create (h, 11);
  minheap_insertkey (h, 3);
  minheap_insertkey (h, 2);
  minheap_insertkey (h, 1);
  minheap_insertkey (h, 15);
  minheap_insertkey (h, 5);
  minheap_insertkey (h, 4);
  minheap_insertkey (h, 45);

  int min = minheap_extractmin(h);
  minheap_decreasekey(h, 2, 1);
  int m = minheap_getmin(h);
  printf("%d %d\n", min,  m);
}


int main (void)
{
  UNITY_BEGIN ();
  RUN_TEST (test_heap);
  return UNITY_END ();
}
