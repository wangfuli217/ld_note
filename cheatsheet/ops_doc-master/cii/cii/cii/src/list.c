#include<stdarg.h>
#include<stddef.h>
#include"assert.h"
#include"mem.h"
#include"list.h"

#define T list_t

T
list_push(T list, void *x)
{
    T p;

    NEW(p);
    p->first = x;
    p->rest = list;

    return p;
}


T
list_list(void *x, ...)
{
    va_list ap;
    T list, *p = &list;

    va_start(ap, x);

    for(; x; x = va_arg(ap, void *)){
        NEW(*p);
        (*p)->first = x;
        p = &(*p)->rest;
    }
    *p = NULL;

    va_end(ap);

    return list;
}

static
T
_list_list_g(void *x, ...)
{
    va_list ap;
    T head, cur, next;

    va_start(ap, x);
    for(; x; x = va_arg(ap, void *)){

        if(NULL == head){
            NEW(head);
            head->first = x;
            cur = head;
        }else{
            NEW(next);
            next->first = x;
            cur->rest = next;
            cur = next;
        }
    }
    va_end(ap);
    cur->rest = NULL;
    return head;
}

T
list_append(T list, T tail)
{
    T *p = &list;

    while(*p)
        p = &(*p)->rest;

    *p = tail;
    return list;
}

static
T
_list_append_g(T list, T tail)
{
    T p = list;
    if(NULL == p){
        return tail;
    }else{
        while((p->rest)->rest)
            p = p->rest;
        p->rest = tail;
    }
}

T
list_copy(T list)
{
    T head, *p = &head;

    for(; list; list = list->rest){
        NEW(*p);
        (*p)->first = list->first;
        p = &(*p)->rest;
    }

    *p = NULL;
    return head;
}

T
list_pop(T list, void **x)
{
    T head;
    if(list){
        head = list->rest;
        if(x)
            *x = list->first;
        FREE(list);
        return head;
    }else
        return list;
}

T
list_reverse(T list)
{
    T head = NULL, next;

    for(; list; list = next){
        next = list->rest;
        list->rest = head;
        head = list;
    }

    return head;
}

static
T
_list_reverse_g(T list)
{
    T head = NULL, next;

    for(; list; list = next){
        next = list->rest;
        list->rest = head;
        head = list;
    }

    return head;
}

int
list_length(T list)
{
    int n;

    for(n = 0; list; list = list->rest)
        n++;
    return n;
}

void
list_free(T *list)
{
    T next;
    
    assert(list);
    for(; *list; *list = next){
        next = (*list)->rest;
        FREE(*list);
    }
}

void
list_map(T list, 
        void (*apply)(void **x, void *cl),
        void *cl)
{
    assert(apply);

    for(; list; list = list->rest)
        apply(&list->first, cl);
}


void **
list_to_array(T list, void *end)
{
    int i, n = list_length(list);
    void **array = ALLOC((n + 1) * sizeof(*array));

    for(i = 0; i < n; i++){
        array[i] = list->first;
        list = list->rest;
    }

    array[i] = end;
    return array;
}
