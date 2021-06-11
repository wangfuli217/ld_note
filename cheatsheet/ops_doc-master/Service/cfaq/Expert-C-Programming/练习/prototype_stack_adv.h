/* prototype_stack_adv.h */
#include <malloc.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>

typedef struct{
    void *elems;
    int elemSize;
    int logicLen;
    int allocLen;
    void (*freefn)(void*);
}stack;

void StackNew(stack *s, int elemSize, void(*freefn)(void*));
void StackDispose(stack *s);
void StackPush(stack *s, void *elemAddr);
void StackPop(stack *s, void *elemAddr);