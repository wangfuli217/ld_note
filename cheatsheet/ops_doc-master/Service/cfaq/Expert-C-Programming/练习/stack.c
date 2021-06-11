#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "stack.h"

void StackNew(stack *s){
    s->logicLen = 0;
    s->allocLen = 4;
    s->elems = malloc(4 * sizeof(int));
    assert(s->elems != NULL);
}

void StackDispose(stack *s){
    free(s->elems);
}

void StackPush(stack *s, int value){
    if(s->logicLen == s->allocLen){
        s->allocLen *= 2;
        s->elems = realloc(s->elems,s->allocLen*sizeof(int));
        assert(s->elems != NULL);
    }
    s->elems[s->logicLen] = value;
    s->logicLen++;
}

int StackPop(stack *s){
    assert(s->logicLen > 0);
    s->logicLen--;
    return s->elems[s->logicLen];
}

/* app */
int main(void){
    int i;
    stack s;
    StackNew(&s);
    for(i=0; i<5; i++){
        StackPush(&s,i);
    }
    for(i--; i>=0; i--){
        printf("%d\n", StackPop(&s));
    }
    StackDispose(&s);
}