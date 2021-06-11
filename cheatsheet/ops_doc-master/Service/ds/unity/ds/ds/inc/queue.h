#ifndef QUEUE_H
#define QUEUE_H

#include <stdlib.h>

struct queue
{
  int front;
  int rear;
  int size;
  unsigned capacity;
  int * array;
};


struct queue * queue_create (unsigned capacity)
{
  struct queue * q = (struct queue *)malloc(sizeof(struct queue));
  q->capacity = capacity;
  q->front = 0;
  q->rear = capacity - 1;
  q->size = 0;
  q->array = (int*)malloc(q->capacity*sizeof(int));

  return q;
}


int queue_isfull (struct queue * q)
{
  return q->size == q->capacity;
}


int queue_isempty (struct queue * q)
{
  return q->size == 0;
}


void queue_enqueue (struct queue * q, int item)
{
  if (queue_isfull(q))
  {
    return;
  }
  q->rear = (q->rear + 1) % q->capacity;
  q->array[q->rear] = item;
  q->size += 1;
  printf("%d enqueued to queue\n", item);
}


int queue_dequeue (struct queue * q)
{
  if (queue_isempty(q))
    return INT_MIN;

  int item = q->array[q->front];
  q->front = (q->front + 1) % q->capacity;
  q->size -= 1;

  return item;
}


int queue_front (struct queue * q)
{
  if (queue_isempty(q))
    return INT_MIN;

  return q->array[q->front];
}


int queue_rear (struct queue * q)
{
  if (queue_isempty(q))
    return INT_MIN;

  return q->array[q->rear];
}


#endif
