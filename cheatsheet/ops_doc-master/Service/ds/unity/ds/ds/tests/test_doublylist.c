#include <stdio.h>
#include <stdlib.h>

#include "unity.h"
#include "doublylist.h"


void test_doublylist (void)
{
  struct dlnode * head = NULL;
  doublylist_append (&head, 6);
  doublylist_push (&head, 7);
  doublylist_push (&head, 1);
  doublylist_append (&head, 4);
  doublylist_insertafter (head->next, 8);
  printf("created dll is: ");
  doublylist_traverse (head);

  doublylist_delete (&head, head);
  doublylist_traverse (head);

  doublylist_reverse (&head);
  doublylist_traverse (head);

  doublylist_quicksort_start (head);
  doublylist_traverse (head);

  doublylist_mergesort (head);
  doublylist_traverse (head);
}


int main (void)
{
  UNITY_BEGIN ();
  RUN_TEST (test_doublylist);
  return UNITY_END ();
}
