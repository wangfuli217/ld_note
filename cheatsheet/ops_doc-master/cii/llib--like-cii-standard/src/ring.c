#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

#include "assert.h"
#include "ring.h"
#include "mem.h"
#include "safeint.h"

#define T Ring_T

struct T {
    struct node {
        struct node *llink, *rlink;
        void *value;
    } *head;
    unsigned length;
};

T Ring_new(void) {
    T ring;

    NEW0(ring);
    ring->head = NULL;

    return ring;
}

T Ring_ringx(void *x, ...) {
    va_list ap;

    T ring = Ring_new();

    va_start(ap, x);
    for ( ; x; x = va_arg(ap, void *))
        Ring_push_front(ring, x);
    va_end(ap);

    return ring;
}

void Ring_free(T *ring) {
    struct node *p, *q;
    assert(ring && *ring);

    if ((p = (*ring)->head) != NULL) {
        unsigned n = (*ring)->length;

        for ( ; n-- > 0; p = q) {
            q = p->rlink;
            FREE(p);
        }
    }
    FREE(*ring);
}

unsigned Ring_length(T ring) {
    assert(ring);
    return ring->length;
}

void *Ring_get(T ring, unsigned i) {
    struct node *q;
    assert(ring);
    assert(i < ring->length);

    {
        unsigned n;
        q = ring->head;
        if (i <= ring->length/2)
            for (n = i; n-- > 0; )
                q = q->rlink;
        else
            for (n = ring->length - i; n-- > 0; )
                q = q->llink;
    }

    return q->value;
}

void *Ring_put(T ring, unsigned i, void *x) {
    struct node *q;
    void *prev;
    assert(ring);
    assert(i < ring->length);

    {
        unsigned n;
        q = ring->head;
        if (i <= ring->length/2)
            for (n = i; n-- > 0; )
                q = q->rlink;
        else
            for (n = ring->length - i; n-- > 0; )
                q = q->llink;
    }

    prev = q->value;
    q->value = x;
    return prev;
}

T Ring_push_front(T ring, void *x) {
    struct node *p, *q;
    assert(ring);

    NEW(p);
    if ((q = ring->head) != NULL)
        {
            p->llink = q->llink;
            q->llink->rlink = p;
            p->rlink = q;
            q->llink = p;
        }
    else
        ring->head = p->llink = p->rlink = p;

    safe_sum_uu(ring->length, 1);

    ring->length++;
    p->value = x;
    return ring;
}

T Ring_push_back(T ring, void *x) {
    assert(ring);

    Ring_push_front(ring, x);
    ring->head = ring->head->llink;

    return ring;
}

void *Ring_add(T ring, signed pos, void *x) {
    signed slength;
    assert(ring);

    slength = safe_cast_us(ring->length);
    assert(pos >= -slength && pos <= slength +1);

    if (pos == 1 || pos == - slength)
        return Ring_push_back(ring, x);
    else if (pos == 0 || pos == slength + 1)
        return Ring_push_front(ring, x);
    else {
        struct node *p, *q;

        unsigned i = pos < 0 ? safe_cast_su (pos + slength) : safe_cast_su (pos - 1);
        {
            unsigned n;
            q = ring->head;
            if (i <= ring->length/2)
                for (n = i; n-- > 0; )
                    q = q->rlink;
            else
                for (n = ring->length - i; n-- > 0; )
                    q = q->llink;
        }
        NEW(p);
        {
            p->llink = q->llink;
            q->llink->rlink = p;
            p->rlink = q;
            q->llink = p;
        }

        safe_sum_uu(ring->length, 1);
        ring->length++;

        return p->value = x;
    }
}

void *Ring_remove(T ring, unsigned i) {
    void *x;
    struct node *q;
    assert(ring);
    assert(ring->length > 0);
    assert(i < ring->length);

    {
        unsigned n;
        q = ring->head;
        if (i <= ring->length/2)
            for (n = i; n-- > 0; )
                q = q->rlink;
        else
            for (n = ring->length - i; n-- > 0; )
                q = q->llink;
    }

    if (i == 0)
        ring->head = ring->head->rlink;

    x = q->value;
    q->llink->rlink = q->rlink;
    q->rlink->llink = q->llink;
    FREE(q);
    if (--ring->length == 0)
        ring->head = NULL;
    return x;
}

void *Ring_pop_front(T ring) {
    void *x;
    struct node *q;
    assert(ring);
    assert(ring->length > 0);

    q = ring->head->llink;
    x = q->value;
    q->llink->rlink = q->rlink;
    q->rlink->llink = q->llink;
    FREE(q);

    if (--ring->length == 0)
        ring->head = NULL;

    return x;
}

void *Ring_pop_back(T ring) {
    assert(ring);
    assert(ring->length > 0);

    ring->head = ring->head->rlink;
    return Ring_pop_front(ring);
}

void Ring_rotate(T ring, int n) {
    struct node *q;
    int i;
    signed slength = safe_cast_us(ring->length);

    assert(ring);
    assert(n >= - slength && n <= slength);

    if (n >= 0)
        i = n % slength;
    else
        i = n + slength;
    {
        signed n1;
        q = ring->head;
        if (i <= slength / 2)
            for (n1 = i; n1-- > 0; )
                q = q->rlink;
        else
            for (n1 = slength - i; n1-- > 0; )
                q = q->llink;
    }
    ring->head = q;
}

void Ring_map(T ring, void apply(void **x, void *cl), void *cl) {
    struct node *p, *q;
    assert(ring && apply);

    if ((p = ring->head) != NULL) {
        unsigned n = ring->length;

        for ( ; n-- > 0; p = q) {
            q = p->rlink;
            apply(&p->value, cl);
        }
    }
}

