#include<stdlib.h>
#include<stdarg.h>
#include<string.h>
#include"assert.h"
#include"mem.h"
#include"ring.h"

#define T ring_t

struct T{

    struct node{

        struct node *llink, *rlink;
        void *value;
    }*head;

    ssize_t     lastget_pos;
    struct node *lastget_node;
    ssize_t     length;
};


static struct node* _ring_node(T ring, ssize_t position);

static void _ring_node_delete(T ring, struct node *p);

static inline void _reset_lastget(T ring);

T
ring_new(void)
{
    T ring;

    NEW0(ring);
    ring->head = NULL;
    return ring;
}


T
ring_ring(void *x, ...)
{
    va_list ap;
    T ring;

    ring = ring_new();

    va_start(ap, x);

    for(; x; x = va_arg(ap, void *))
        ring_add_high(ring, x);

    va_end(ap);

    return ring;
}


void
ring_free(T *ring)
{
    struct node *p, *q, *h;
    assert(ring && *ring);

    
    if((h = (*ring)->head) != NULL){
        p = h->rlink;
        while(p != h){
            q = p->rlink;
            FREE(p);
            p = q;
        }
    }

    FREE(*ring);
}


ssize_t
ring_length(T ring)
{
    assert(ring);
    return ring->length;
}


void *
ring_get(T ring, ssize_t position)
{
    struct node *q;

    assert(ring);
    assert(position >=0 && position < ring->length);

    if(position == (ring->lastget_pos + 1)){
        q = ring->lastget_node->rlink;
    }
    else if(position == (ring->lastget_pos - 1)){
        q = ring->lastget_node->llink;
    }else{
        q = _ring_node(ring, position);
    }

    ring->lastget_pos = position;
    ring->lastget_node = q;
    return q->value;
}


void *
ring_put(T ring, ssize_t position, void *x)
{
    struct node *q;
    void *prev;
    
    assert(ring);
    assert(position >= 0 && position < ring->length);

    q = _ring_node(ring, position);
    prev = q->value;

    q->value = x;

    return prev;
}


void *
ring_add(T ring, ssize_t position, void *x)
{
    struct node *p, *q;
    int i;
    
    assert(ring);
    assert(position >= -ring->length && position <= ring->length+1);


    if(1 == position || position == -ring->length)
        return ring_add_low(ring, x);
    else if(0 == position || position == ring->length+1)
        return ring_add_high(ring, x);
    else{
       
        i = position < 0 ? position + ring->length : position - 1;
        q = _ring_node(ring, position);
        NEW(p);
        p->llink = q->llink;
        q->llink->rlink = p;
        p->rlink = q;
        q->llink = p;

        ring->length++;

        _reset_lastget(ring);
        return p->value = x;
    }
}


void *
ring_add_low(T ring, void *x)
{
    assert(ring);
    ring_add_high(ring, x);
    ring->head = ring->head->llink;

    _reset_lastget(ring);
    return x;
}


void *
ring_add_high(T ring, void *x)
{
    struct node *p, *q;

    assert(ring);
    NEW(p);

    if((q = ring->head) != NULL){
        p->llink = q->llink;
        q->llink->rlink = p;
        p->rlink = q;
        q->llink = p;
    }else{
        ring->head = p->llink = p->rlink = p;
    }

    ring->length++;

    _reset_lastget(ring);

    return p->value = x;
}


void *
ring_remove(T ring, ssize_t position)
{
    void *x;
    struct node *q;

    assert(ring);
    assert(ring->length > 0);
    assert(position >= 0 && position < ring->length);

    q = _ring_node(ring, position);

    if(0 == position)
        ring->head = ring->head->rlink;

    x = q->value;
    
    _ring_node_delete(ring, q);

    _reset_lastget(ring);
    return x;
}


void *
ring_remove_low(T ring)
{
    assert(ring);
    assert(ring->length > 0);
    ring->head = ring->head->rlink;
    _reset_lastget(ring);
    return ring_remove_high(ring);
}


void *
ring_remove_high(T ring)
{
    void *x;
    struct node *q;
    
    assert(ring);
    assert(ring->length > 0);

    q = ring->head->llink;
    x = q->value;

    _ring_node_delete(ring, q); 

    _reset_lastget(ring);
    return x;
}


void
ring_rotate(T ring, ssize_t n)
{
    struct node *q;
    int position;

    assert(ring);
    assert(n >= -ring->length && n <= ring->length);

    if(n >= 0)
        position = n % ring->length;
    else
        position = n + ring->length;
    q = _ring_node(ring, position);

    ring->head = q;

    _reset_lastget(ring);
}


static 
struct node* 
_ring_node(T ring, ssize_t position)
{
    struct node* pn;
    int n;

    pn = ring->head;

    if(position <= ring->length/2)
        for(n = position; n-- > 0;)
            pn = pn->rlink;
    else
        for(n = ring->length - position; n-- > 0;)
            pn = pn->llink;

    return pn;
}

static 
void 
_ring_node_delete(T ring, struct node *p)
{
    p->llink->rlink = p->rlink;
    p->rlink->llink = p->llink;
    FREE(p);
    if(--ring->length == 0)
        ring->head = NULL;
}

static 
inline 
void 
_reset_lastget(T ring)
{
    ring->lastget_node = ring->head;
    ring->lastget_pos = 0;
}
