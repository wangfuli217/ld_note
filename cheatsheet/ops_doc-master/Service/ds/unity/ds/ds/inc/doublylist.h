#ifndef DOUBLY_LIST_H
#define DOUBLY_LIST_H

#include <stdio.h>
#include <stdlib.h>

struct dlnode
{
  int data;
  struct dlnode * next;
  struct dlnode * prev;
};


void swap (int * x, int * y)
{
  int temp = * x;
  * x = * y;
  * y = temp;
}


struct dlnode * doublylist_lastnode (struct dlnode * root)
{
  while (root && root->next)
  {
    root = root->next;
  }
  return root;
}


void doublylist_reverse (struct dlnode ** head)
{
  struct dlnode * temp = NULL;
  struct dlnode * current = * head;

  while (current != NULL)
  {
    temp = current->prev;
    current->prev = current->next;
    current->next = temp;
    current = current->prev;
  }

  if (temp != NULL) * head = temp->prev;
}


void doublylist_push (struct dlnode ** head, int data)
{
  struct dlnode * n = (struct dlnode *)malloc(sizeof(struct dlnode));
  n->data = data;
  n->next = (*head);
  n->prev = NULL;

  if ((*head) != NULL) (*head)->prev = n;
  (*head) = n;
}


void doublylist_insertafter (struct dlnode * prevnode, int data)
{
  if (prevnode == NULL)
  {
    printf("the given previous node cannot be null.\n");
  }

  struct dlnode * n = (struct dlnode *)malloc(sizeof(struct dlnode));
  n->data = data;
  n->next = prevnode->next;
  prevnode->next = n;
  n->prev = prevnode;

  if (n->next != NULL) n->next->prev = n;
}


void doublylist_append (struct dlnode ** head, int data)
{
  struct dlnode * n = (struct dlnode *)malloc(sizeof(struct dlnode));
  struct dlnode * last = * head;
  n->data = data;
  n->next = NULL;
  
  if (*head == NULL)
  {
    n->prev = NULL;
    *head = n;
    return;
  }

  while (last->next != NULL)
  {
    last = last->next;
  }
  last->next = n;
  
  n->prev = last;

  return;
}


void doublylist_delete (struct dlnode ** head, struct dlnode * del)
{
  if (*head == NULL || del == NULL) return;
  if (*head == del) * head = del->next;
  if (del->next != NULL) del->next->prev = del->prev;
  if (del->prev != NULL) del->prev->next = del->next;
  free(del);

  return;
}


/* --------------------------------------------------------------------------------- */
// quicksort

struct dlnode * doublylist_partition (struct dlnode * startnode, struct dlnode * endnode)
{
  int x = endnode->data;
  struct dlnode * i = startnode->prev;
  
  struct dlnode * j;
  for (j = startnode; j != endnode; j = j->next)
  {
    if (j->data <= x)
    {
      i = (i == NULL) ? startnode : i->next;
      swap(&(i->data), &(j->data));
    }
  }
  i = (i == NULL) ? startnode : i->next;
  swap (&(i->data), &(endnode->data));

  return i;
}


void doublylist_quicksort (struct dlnode * startnode, struct dlnode * endnode)
{
  if (endnode != NULL && startnode != endnode && startnode != endnode->next)
  {
    struct dlnode * p = doublylist_partition (startnode, endnode);
    doublylist_quicksort (startnode, p->prev);
    doublylist_quicksort (p->next, endnode);
  }
}


void doublylist_quicksort_start (struct dlnode * head)
{
  struct dlnode * h = doublylist_lastnode (head);
  doublylist_quicksort (head, h); 
}

/* --------------------------------------------------------------------------------- */
// mergesort

struct dlnode * doublylist_merge (struct dlnode * first, struct dlnode * second)
{
  if (!first)
  {
    return second;
  }

  if (!second)
  {
    return first;
  }

  if (first->data < second->data)
  {
    first->next = doublylist_merge (first->next, second);
    first->next->prev = first;
    first->prev = NULL;
    return first;
  }
  else
  {
    second->next = doublylist_merge (first, second->next);
    second->next->prev = second;
    second->prev = NULL;
    return second;
  }
}


struct dlnode * doublylist_split (struct dlnode * head)
{
  struct dlnode * fast = head;
  struct dlnode * slow = head;
  while (fast->next && fast->next->next)
  {
    fast = fast->next->next;
    slow = slow->next;
  }

  struct dlnode * temp = slow->next;
  slow->next = NULL;

  return temp;
}


struct dlnode * doublylist_mergesort (struct dlnode * head)
{
  if (!head || !head->next)
  {
    return head;
  }

  struct dlnode * second = doublylist_split (head);
  head = doublylist_mergesort (head);
  second = doublylist_mergesort (second);

  return doublylist_merge (head, second);
}

/* --------------------------------------------------------------------------------- */


void doublylist_traverse (struct dlnode * n)
{
  struct dlnode * last;
  printf("\n Traversal in forward direction \n");
  while (n != NULL)
  {
    printf(" %d ", n->data);
    last = n;
    n = n->next;
  }

  printf("\n Traversal in reverse direction \n");
  while (last != NULL)
  {
    printf(" %d ", last->data);
    last = last->prev;
  }
}

#endif
