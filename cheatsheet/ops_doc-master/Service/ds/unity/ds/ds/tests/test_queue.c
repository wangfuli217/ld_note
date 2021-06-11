#include <stdio.h>
#include <stdlib.h>

#include "unity.h"
#include "queue.h"


void test_queue (void)
{
  struct queue * q = queue_create (1000);

  queue_enqueue(q, 10);
  queue_enqueue(q, 20);
  queue_enqueue(q, 30);
  queue_enqueue(q, 40);

  printf("%d dequeue from queue\n", queue_dequeue(q));
  printf("front item is %d\n", queue_front(q));
  printf("rear item is %d\n", queue_rear(q));

  return 0;
}


int main (void)
{
  UNITY_BEGIN ();
  RUN_TEST (test_queue);
  return UNITY_END ();
}
