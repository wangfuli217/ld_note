#ifndef STACK_H
#define STACK_H

#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

struct stack
{
  int top;
  unsigned capacity;
  int * array;
};


struct stack * stack_create (unsigned capacity)
{
  struct stack * stack = (struct stack *)malloc(sizeof(struct stack));
  stack->capacity = capacity;
  stack->top = -1;
  stack->array = (int*)malloc(stack->capacity*sizeof(int));

  return stack;
}


int stack_isfull (struct stack * s)
{
  return s->top == s->capacity - 1;
}


int stack_isempty (struct stack * s)
{
  return s->top == -1;
}


void stack_push (struct stack * s, int item)
{
  if (stack_isfull(s))
    return;

  s->array[++s->top] = item;
  printf("%d pushed to stack\n", item);
}


int stack_pop (struct stack * s)
{
  if (stack_isempty(s))
    return INT_MIN;

  return s->array[s->top--];
}


/* ------------------------------------------------------------------------------ */

#endif
