/* prototype_stack.h */
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "prototype_stack.h"

void StackNew(stack *s, int elemSize){
    assert(elemSize > 0);
    s->elemSize = elemSize;
    s->logicLen = 0;
    s->allocLen = 4;
    s->elems = malloc(4 * elemSize);
    assert(s->elems != NULL);
}

void StackDispose(stack *s){
    free(s->elems);
}

static void StackGrow(stack *s){
    s->allocLen *= 2;
    s->elems = realloc(s->elems,s->allocLen*s->elemSize);
    assert(s->elems != NULL);
}

void StackPush(stack *s, void *elemAddr){
    if(s->logicLen == s->allocLen){
        StackGrow(s);
    }
    void *target = (char*)s->elems+s->logicLen*s->elemSize;
    memcpy(target, elemAddr, s->elemSize);
    s->logicLen++;
}

void StackPop(stack *s, void *elemAddr){
    assert(s->logicLen > 0);
    s->logicLen--;
    void *source = (char*)s->elems+s->logicLen*s->elemSize;
    memcpy(elemAddr, source, s->elemSize);
}

/* app */
int main(void){
    int i;
    stack s;
    StackNew(&s, sizeof(int));
    for(i=0; i<5; i++){
        StackPush(&s,&i);
    }
    for(i--; i>=0; i--){
        StackPop(&s,&i);
        printf("%d\n", i);
    }
    StackDispose(&s);
}