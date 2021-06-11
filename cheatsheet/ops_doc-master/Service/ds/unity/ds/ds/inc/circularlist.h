#ifndef CIRCULAR_LIST_H
#define CIRCULAR_LIST_H


struct clnode
{
  int data;
  struct clnode * next;
};


struct clnode * circularlist_insertempty (struct clnode * last, int data)
{
  if (last != NULL)  return last;

  struct clnode * temp = (struct clnode *)malloc(sizeof(struct clnode));
  temp->data = data;
  last = temp;
  last->next = last;

  return last;
}


struct clnode * circularlist_insertbegin (struct clnode * last, int data)
{
  if (last == NULL) return circularlist_insertempty (last, data);

  struct clnode * temp = (struct clnode *)malloc(sizeof(struct clnode));
  temp->data = data;
  temp->next = last->next;
  last->next = temp;

  return last;
}


struct clnode * circularlist_insertend (struct clnode * last, int data)
{
  if (last == NULL) return circularlist_insertempty(last, data);

  struct clnode * temp = (struct clnode *)malloc(sizeof(struct clnode));
  temp->data = data;
  temp->next = last->next;
  last->next = temp;
  last = temp;

  return last;
}


struct clnode * circularlist_insertafter (struct clnode * last, int data, int item)
{
  if (last == NULL) return NULL;

  struct clnode * temp;
  struct clnode * p;
  p = last->next;
  do
  {
    if (p->data == item)
    {
      temp = (struct clnode *)malloc(sizeof(struct clnode));
      temp->data = data;
      temp->next = p->next;
      p->next = temp;
      if (p == last) last = temp;
      return last;
    }
    p = p->next;
  } while (p != last->next);

  printf("%d not present in the list.\n");
  return last;
}


void circularlist_split (struct clnode * head, struct clnode ** split1, struct clnode ** split2)
{
  struct clnode * slow_ptr = head;
  struct clnode * fast_ptr = head;

  if (head == NULL) return;
  while (fast_ptr->next != head && fast_ptr->next->next != head)
  {
    fast_ptr = fast_ptr->next->next;
    slow_ptr = slow_ptr->next;
  }

  if (fast_ptr->next->next == head) fast_ptr = fast_ptr->next;

  * split1 = head;
  if (head->next != head) * split2 = slow_ptr->next;
  fast_ptr->next = slow_ptr->next;
  slow_ptr->next = head;
}


void circularlist_traverse (struct clnode * last)
{
  struct clnode * p;
  
  if (last == NULL)
  {
    printf("List is empty.\n");
    return;
  }

  p = last->next;
  do
  {
    printf("%d ", p->data);
    p = p->next;
  } while (p != last->next);
}


#endif
