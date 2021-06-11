#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "prototype_stack_adv.h"

void StackNew(stack *s, int elemSize, void(*freefn)(void*)){
    assert(elemSize > 0);
    s->elemSize = elemSize;
    s->logicLen = 0;
    s->allocLen = 4;
    s->elems = malloc(4 * elemSize);
    s->freefn = freefn;
    assert(s->elems != NULL);
}

void StackDispose(stack *s){
    int i;
    if(s->freefn != NULL) {
        for(i = 0; i < s->logicLen; i++) {
            s->freefn((char*)s->elems + i * s->elemSize);
        }
    }
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
void stringFree(void* elemAddr) {
    char** p = (char**)elemAddr;
    free(*p);
}

int main(){
    const char friends[][5] = {"Al", "Bob", "Carl"};
    stack stringStack;
    int i;
    StackNew(&stringStack, sizeof(char*), stringFree);
    for(i = 0; i < 3; i++) {
        char *copy = strdup(friends[i]);
        StackPush(&stringStack, &copy);
    }
    char* name;
    while(stringStack.logicLen > 1) {
        StackPop(&stringStack, &name);
        printf("%s\n", name);
        free(name);
    }
    StackDispose(&stringStack);
}