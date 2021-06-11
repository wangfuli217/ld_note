#include <malloc.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>

typedef struct{
    int *elems;
    int logicLen;
    int allocLen;
}stack;

void StackNew(stack *s);
void StackDispose(stack *s);
void StackPush(stack *s, int value);
int StackPop(stack *s);