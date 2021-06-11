#ifndef LIST_H
#define LIST_H

#include <stdio.h>

struct node
{
  int data;
  struct node * next;
};

/* --------------------------------------------------------------------------- */
/*
 * create:
 * - push
 * - insert
 * - append
 */

void list_push (struct node ** head_ref, int data)
{
  struct node * new_node = (struct node *)malloc(sizeof(struct node));
  new_node->data = data;
  new_node->next = (*head_ref);
  (*head_ref) = new_node;
}


void list_insert (struct node * prev_node, int data)
{
  if (prev_node == NULL)
  {
    printf("the given previous node cannot be NULL\n");
    return;
  }

  struct node * new_node = (struct node *)malloc(sizeof(struct node));
  new_node->data = data;
  new_node->next = prev_node->next;
  prev_node->next = new_node;
}


void list_append (struct node ** head_ref, int data)
{
  struct node * new_node = (struct node *)malloc(sizeof(struct node));
  struct node * last = * head_ref;
  new_node->data = data;
  new_node->next = NULL;
  
  if (*head_ref == NULL)
  {
    *head_ref = new_node;
    return;
  }
  
  while (last->next != NULL)
  {
    last = last->next;
  }
  last->next = new_node;

  return;
}


/* --------------------------------------------------------------------------- */
/*
 * delete:
 * - head
 * - node
 * - tail
 */


void list_delete (struct node ** head_ref, int data)
{
  struct node * tmp = * head_ref;
  struct node * prev;

  if (tmp != NULL && tmp->data == data)
  {
    * head_ref = tmp->next;  // change head
    free (tmp);              // free old head
    return;
  }

  while (tmp != NULL && tmp->data != data)
  {
    prev = tmp;
    tmp = tmp->next;
  }

  if (tmp == NULL) return;
  prev->next = tmp->next;

  free(tmp);
}


void list_delete_by_position (struct node ** head_ref, int position)
{
  if (*head_ref == NULL)
  {
    return;
  }

  struct node * tmp = * head_ref;
  if (position == 0)
  {
    * head_ref = tmp->next;
    free (tmp);
    return;
  }

  int i;
  for (i = 0; tmp != NULL && i < position-1; ++i)
  {
    tmp = tmp->next;
  }

  if (tmp == NULL || tmp->next == NULL)
  {
    return;
  }

  struct node * next = tmp->next->next;
  free (tmp->next);
  tmp->next = next;
}

/* --------------------------------------------------------------------------- */

int list_count (struct node * head)
{
/*
  int counter = 0;
  struct node * current = head;
  while (current != NULL)
  {
    counter++;
    current = current->next;
  }
  return counter;
*/

  if (head == NULL)
    return 0;
  return 1 + list_count(head->next);
}


void list_swap (struct node ** head_ref, int datax, int datay)
{
  if (datax == datay) return;

  struct node * prevx = NULL;
  struct node * currx = * head_ref;
  while (currx && currx->data != datax)
  {
    prevx = currx;
    currx = currx->next;
  }

  struct node * prevy = NULL;
  struct node * curry = * head_ref;
  while (curry && curry->data != datay)
  {
    prevy = curry;
    curry = curry->next;
  }

  if (currx == NULL || curry == NULL)  return;

  if (prevx != NULL)  prevx->next = curry;
  else * head_ref = curry;

  if (prevy != NULL) prevy->next = currx;
  else * head_ref = currx;

  struct node * tmp = curry->next;
  curry->next = currx->next;
  currx->next = tmp;  
}


void list_reverse (struct node ** head_ref)
{
  struct node * prev = NULL;
  struct node * current = * head_ref;
  struct node * next;
  while (current != NULL)
  {
    next = current->next;
    current->next = prev;
    prev = current;
    current = next;
  }
  * head_ref = prev;
}


struct node * list_reverse_by_group (struct node * head, int group_size)
{
  struct node * current = head;
  struct node * next = NULL;
  struct node * prev = NULL;
  int counter = 0;

  while (current != NULL && counter < group_size)
  {
    next = current->next;
    current->next = prev;
    prev = current;
    current = next;
    counter++;
  }

  if (next != NULL)
  {
    head->next = list_reverse_by_group(next, group_size);
  }

  return prev;
}

/* --------------------------------------------------------------------------- */
// mergesort


struct node * list_merge (struct node * a, struct node * b)
{
  struct node * result = NULL;

  if (a == NULL) return (b);
  else if (b == NULL) return (a);

  if (a->data <= b->data)
  {
    result = a;
    result->next = list_merge (a->next, b);
  }
  else
  {
    result = b;
    result->next = list_merge (a, b->next);
  }

  return result;
}


void list_frontbacksplit (struct node * source, struct node ** front, struct node ** back)
{
  struct node * fast;
  struct node * slow;
  if ((source == NULL) || (source->next == NULL))
  {
    * front = source;
    * back = NULL;
  }
  else
  {
    slow = source;
    fast = source->next;

    while (fast != NULL)
    {
      fast = fast->next;
      if (fast != NULL)
      {
        slow = slow->next;
        fast = fast->next;
      }
    }

    * front = source;
    * back = slow->next;
    slow->next = NULL;
  }
}


void list_mergesort (struct node ** head)
{
  struct node * head_ref = * head;
  struct node * a;
  struct node * b;

  if ((head_ref == NULL) || (head_ref->next == NULL))
  {
    return;
  }

  list_frontbacksplit (head_ref, &a, &b);
  list_mergesort (&a);
  list_mergesort (&b);
  head_ref = list_merge (a, b);
}

/* --------------------------------------------------------------------------- */
// detect loop and remove loop

int list_detectremoveloop (struct node * head)
{
  struct node * slow_ptr = head;
  struct node * fast_ptr = head;

  while (slow_ptr && fast_ptr && fast_ptr->next)
  {
    slow_ptr = slow_ptr->next;
    fast_ptr = fast_ptr->next->next;

    if (slow_ptr == fast_ptr)
    {
      list_removeloop (slow_ptr, head);
      return 1;
    }
  }
  return 0;
}


void list_removeloop (struct node * loopnode, struct node * head)
{
  struct node * ptr1;
  struct node * ptr2;

  ptr1 = head;
  while (1)
  {
    ptr2 = loopnode;
    while (ptr2->next != loopnode && ptr2->next != ptr1)
    {
      ptr2 = ptr2->next;
    }

    if (ptr2->next == ptr1)
    {
      break;
    }

    ptr1 = ptr1->next;
  }

  ptr2->next = NULL;
}

/* --------------------------------------------------------------------------- */

void list_traverse (struct node * n)
{
  while (n != NULL)
  {
    printf(" %d ", n->data);
    n = n->next;
  }
}

#endif
