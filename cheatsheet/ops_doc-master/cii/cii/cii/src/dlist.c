#include<stdarg.h>
#include<stddef.h>
#include"assert.h"
#include"mem.h"
#include"dlist.h"

#define T dlist_t



T
dlist_push(T dlist, void *x)
{
    T p;

    if(NULL == dlist){
        NEW(p);
        p->data = x;
        p->next = p;
        p->prev = p;
        return p;
    }else{
        NEW(p);
        p->data = x;
        p->next = dlist->next;
        p->prev = dlist;

        (dlist->next)->prev = p;
        dlist->next = p; 
        return dlist;
    }

}



T
dlist_append(T dlist, T dtail)
{
    T head;
    if(NULL == dlist){
        return dtail;
    }else if(NULL == dtail){
        return dlist;
    }else{
        head = dlist->next; 
        head->prev = dtail;
        (dtail->next)->prev = dlist;
        dlist->next = dtail->next;
        dtail->next = head;
        return dtail;
    }
}


T
dlist_pop(T dlist, void **x)
{
    T head;
    if(dlist){
        head = dlist->next;
        if(x)
            *x = head->data;
        if(head == dlist){
            FREE(dlist);
        }else{
            dlist->next = head->next;
            (head->next)->prev = dlist;
            FREE(head);
        }
    }

    return dlist;
}



T
dlist_reverse(T dlist)
{
    T head, next, index;
    head = index = dlist->next;
    while(index != dlist){
        next = index->next;
        index->next = index->prev;
        index->prev = next;
        index = next;
    }
    
    index->next = index->prev;
    index->prev = head;

    return head;
}

int
dlist_length(T dlist)
{
    T index;
    int n = 0;

    if(NULL == dlist)
        return 0;

    index = dlist->next;
    while(index != dlist){
        index = index->next;
        n++;
    }

    return n+1;
}

void
dlist_free(T *dlist)
{
    T index, next;

    assert(dlist && *dlist);
    
    index = (*dlist)->next;
    while(index != *dlist){
        next = index->next;
        FREE(index);
        index = next;
    }
}

void
dlist_map(T dlist,
            void (*apply)(void **x, void *cl), 
            void *cl)
{
    T index;

    assert(apply);
    assert(dlist);

    index = dlist->next;
    while(index != dlist){
        apply(&index->data, cl);
        index = index->next;
    }
    apply(&index->data, cl);
}

void **
dlist_to_array(T dlist, void *end)
{
    int i, n = dlist_length(dlist);
    T index;
    void **array = ALLOC((n+1)*sizeof(*array));

    index = dlist->next;
    for(i = 0; i < n; i++){
        array[i] = index->data;
        index = index->next;
    }
    array[i] = end;
    return array;
}

T
dlist_copy(T dlist)
{
    T index;
    T head = NULL, *next = &head, last = NULL;

    if(NULL == dlist)
        return NULL;

    index = dlist->next;
    while(index != dlist){
        NEW(*next);
        (*next)->data = index->data;
        (*next)->prev = last;
        last = *next;
        next = &(*next)->next;
        index = index->next;
    }
        NEW(*next);
        (*next)->data = index->data;
        (*next)->prev = last;
        last = *next;
        next = &(*next)->next;
        index = index->next;

    head->prev = last;
    last->next = head;

    return last;
}


T
dlist_list(void *x, ...)
{
    T head = NULL, *next = &head, last = NULL;
    va_list ap;

    va_start(ap, x);

    for(; x; x = va_arg(ap, void *)){
        NEW(*next);
        (*next)->data = x;
        (*next)->prev = last;
        last = *next;
        next = &(*next)->next;
    }
    va_end(ap);
    head->prev = last;
    last->next = head;
    return last;
}






