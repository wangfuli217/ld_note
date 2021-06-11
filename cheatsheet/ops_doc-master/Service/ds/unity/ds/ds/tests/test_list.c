#include <stdio.h>
#include <stdlib.h>

#include "unity.h"
#include "list.h"


void test_list (void)
{
  struct node * head = NULL;
  struct node * second = NULL;
  struct node * third = NULL;
  struct node * fourth = NULL;

  // allocate 3 nodes in the heap
  head = (struct node *)malloc(sizeof(struct node));
  second = (struct node *)malloc(sizeof(struct node));
  third = (struct node *)malloc(sizeof(struct node));
  fourth = (struct node *)malloc(sizeof(struct node));

  head->data = 1;
  head->next = second;
  second->data = 2;
  second->next = third;
  third->data = 3;
  third->next = fourth;
  fourth->data = 4;
  fourth->next = NULL;

  printf("list: "); list_traverse (head); printf("\n");
  // create
  list_push (&head, 7);
  printf("push: "); list_traverse (head); printf("\n");
  list_insert (head->next, 8);
  printf("insert: "); list_traverse (head); printf("\n");
  list_append (&head, 6);
  printf("append: "); list_traverse (head); printf("\n");
  // delete
  list_delete (&head, 1);
  printf("delete: "); list_traverse (head); printf("\n");
  list_delete_by_position (&head, 4);
  printf("delete by position: "); list_traverse (head); printf("\n");

  // count
  int len = list_count (head);
  printf("list length: %d\n", len);
  // swap
  list_swap (&head, 8, 2);
  printf("swap: "); list_traverse (head); printf("\n");
  // reverse
  list_reverse (&head);
  printf("reverse: "); list_traverse (head); printf("\n");
  head = list_reverse_by_group (head, 2);
  printf("reverse by group: "); list_traverse (head); printf("\n");

  list_mergesort (&head);
  printf("mergesort: "); list_traverse (head); printf("\n");
  

  free (head);
  free (second);
  free (third);
  free (fourth);
}


int main (void)
{
  UNITY_BEGIN ();
  RUN_TEST (test_list);
  return UNITY_END ();
}
