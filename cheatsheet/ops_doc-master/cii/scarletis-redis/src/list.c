#include "list.h"

void list_insert (list_t *newp, list_t *elem) {
  newp->prev = elem->prev;
  newp->next = elem;
  elem->prev->next = newp;
  elem->prev = newp;
}

void list_del (list_t *elem) {
  elem->next->prev = elem->prev;
  elem->prev->next = elem->next;
}

void list_slice (list_t *head, list_t *elem, list_t *new_head) {
    new_head->prev = head->prev;
    new_head->next = elem;

    head->prev->next = new_head;
    head->prev = elem->prev;
    elem->prev->next = head;
    elem->prev = new_head;
}

list_t *list_half (list_t *head) {
    list_t *ptr = head->next;
    list_t *rev_ptr = head->prev;
    while (ptr != rev_ptr && ptr->next != rev_ptr) {
        ptr = ptr->next;
        rev_ptr = rev_ptr->prev;
    }
    return rev_ptr;
}

void list_swap (list_t *a, list_t *b) {
    if (a == b)
        return;

    list_del(a);
    list_del(b);

    list_t *temp;
    if (a->next == b) {
        temp = a->prev;
        list_insert(a, b->next);
        list_insert(b, temp->next);
    } else {
        temp = a->next;
        list_insert(a, b->prev->next);
        list_insert(b, temp);
    }
}

void list_join (list_t *head, list_t *add) {
  /* Do nothing if the list which gets added is empty.  */
  if (add != add->next)
    {
      add->prev->next = head;
      add->next->prev = head->prev;
      head->prev->next = add->next;
      head->prev = add->prev;
    }
}
