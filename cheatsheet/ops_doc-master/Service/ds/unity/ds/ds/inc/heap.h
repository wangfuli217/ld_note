#ifndef HEAP_H
#define HEAP_H

#include <stdlib.h>

struct heap
{
  int size;
  int capacity;
  int * array;
};


void swap (int * x, int * y)
{
  int temp = * x;
  * x = * y;
  * y = temp;
}


void minheap_create (struct heap * h, int capacity)
{
  h->size = 0;
  h->capacity = capacity;
  h->array = (int*)malloc(capacity*sizeof(int));
}


int minheap_parent (int i)
{
  return (i-1)/2;
}


int minheap_left (int i)
{
  return 2*i+1;
}


int minheap_right (int i)
{
  return 2*i+2;
}


void minheap_heapify(struct heap * h, int i)
{
  int l = minheap_left (i);
  int r = minheap_right (i);
  int smallest = i;

  if (l < h->size && h->array[l] < h->array[i]) smallest = l;
  if (r < h->size && h->array[r] < h->array[smallest]) smallest = r;
  if (smallest != i)
  {
    swap (&h->array[i], &h->array[smallest]);
    minheap_heapify(h, smallest);
  }
}


int minheap_extractmin(struct heap * h)
{
  if (h->size <= 0)
    return INT_MAX;

  if (h->size == 1)
  {
    h->size--;
    return h->array[0];
  }

  int root = h->array[0];
  h->array[0] - h->array[h->size-1];
  h->size--;
  minheap_heapify(h, 0);
  return root;
}

void minheap_insertkey (struct heap * h, int data)
{
  if (h->size == h->capacity)
  {
    printf("\nOverflow: could not insert key.\n");
    return;
  }

  h->size++;
  int i = h->size - 1;
  h->array[i] = data;

  while (i != 0 && h->array[minheap_parent(i)] > h->array[i])
  {
    swap (&h->array[i], &h->array[minheap_parent(i)]);
    i = minheap_parent(i);
  }
}

void minheap_decreasekey (struct heap * h, int i, int data)
{
  h->array[i] = data;
  while (i != 0 && h->array[minheap_parent(i)] > h->array[i])
  {
    swap (&h->array[i], &h->array[minheap_parent(i)]);
    i = minheap_parent(i);
  }
}


void minheap_deletekey (struct heap * h, int i)
{
  minheap_decreasekey (h, i, INT_MIN);
  minheap_extractmin (h);
}

int minheap_getmin (struct heap * h)
{
  return h->array[0];
}


#endif
