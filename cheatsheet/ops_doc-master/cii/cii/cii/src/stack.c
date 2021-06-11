#include<stddef.h>
#include"assert.h"
#include"mem.h"
#include"stack.h"

#define T stack_t

struct T{
    int count;
    struct element{
        void *x;
        struct element *link;
    } *head;
};

T
stack_new(void)
{
    T stk;

    NEW(stk);
    stk->count = 0;
    stk->head = NULL;
    
    return stk;
}


int
stack_empty(T stk)
{
    assert(stk);
    return 0 == stk->count;
}


ssize_t
stack_length(T stk)
{
    return stk->count;
}


void
stack_free(T *stk)
{
    struct element *t, *u;

    assert(stk && *stk);
    for(t = (*stk)->head; t; t = u){
        u = t->link;
        FREE(t);
    }
    FREE(*stk);
}


void
stack_push(T stk, void *x)
{
    struct element *t;

    assert(stk);
    NEW(t);
    t->x = x;
    t->link = stk->head;
    stk->head = t;
    stk->count++;
}


void *
stack_pop(T stk)
{
    void *x;
    struct element *t;

    assert(stk);
    assert(stk->count > 0);
    t = stk->head;
    stk->head = t->link;
    stk->count--;
    x = t->x;
    FREE(t);
    return x;
}


void *
stack_peek(T stk)
{
    void *x = NULL;

    assert(stk);
    do{
        if(stk->count <= 0)
            break;

        x = stk->head->x;
    }while(0);
    return x;
}
