#include<stdlib.h>
#include<stdarg.h>
#include<string.h>
#include"assert.h"
#include"seq.h"
#include"array.h"
#include"arrayrep.h"
#include"mem.h"

#define T seq_t

struct T{
    struct array_t array;
    ssize_t length;
    ssize_t head;
};

static void _expand(T seq);

static inline void *_access_get(T seq, ssize_t position);
static inline void *_access_set(T seq, ssize_t position, void *x);

T
seq_new(ssize_t hint)
{
    T seq;

    assert(hint >= 0);

    NEW0(seq);

    if(0 == hint)
        hint = 16;

    arrayrep_init(&seq->array, hint, sizeof(void *),
            ALLOC(hint * sizeof(void *)));

    return seq;
}


T
seq_seq(void *x, ...)
{
    va_list ap;
    T seq;

    seq = seq_new(0);

    va_start(ap, x);

    for(; x; x = va_arg(ap, void *))
        seq_add_high(seq, x);

    va_end(ap);

    return seq;
}


void
seq_free(T *seq)
{
    assert(seq && *seq);
    assert((void *) *seq == (void *) &(*seq)->array);

    array_free((array_t *) seq);
}


ssize_t
seq_length(T seq)
{
    assert(seq);
    return seq->length;
}


void *
seq_get(T seq, ssize_t position)
{
    assert(seq);
    assert(position >= 0 && position < seq->length);

    return _access_get(seq, position);
}


void *
seq_put(T seq, ssize_t position, void *x)
{
    void *prev;
    
    assert(seq);
    assert(position >= 0 && position < seq->length);

    prev = _access_get(seq, position);
    _access_set(seq, position, x);

    return prev;

}


void *
seq_add_low(T seq, void *x)
{
    ssize_t position = 0;

    assert(seq);

    if(seq->length == seq->array.length)
        _expand(seq);
    if(--seq->head < 0)
        seq->head = seq->array.length - 1;

    seq->length++;

    return _access_set(seq, position, x);
}


void *
seq_add_high(T seq, void *x)
{
    ssize_t position;

    assert(seq);

    if(seq->length == seq->array.length)
        _expand(seq);
    position = seq->length ++;

    return _access_set(seq, position, x);
}


void *
seq_remove_low(T seq)
{
    ssize_t position;
    void *x;

    assert(seq);
    assert(seq->length > 0);

    position = 0;

    x = _access_get(seq, position);

    seq->head = (seq->head + 1) % seq->array.length;
    --seq->length;

    return x;
}



void *
seq_remove_high(T seq)
{
    ssize_t position;

    assert(seq);
    assert(seq->length > 0);
    position = --seq->length;
    return _access_get(seq, position);
}


static
void 
_expand(T seq)
{
    void **old;
    ssize_t n ;
    
    n = seq->array.length;
    
    array_resize(&seq->array, 2 * n);

    if(seq->head > 0){
        old = &((void **)seq->array.array)[seq->head];

        memcpy(old + n, old, (n - seq->head) * sizeof(void *));

        seq->head += n;
    }
}


static
inline 
void *
_access_get(T seq, ssize_t position)
{
    return ((void **)seq->array.array)[
        (seq->head + position) % seq->array.length];
}



static
inline
void *
_access_set(T seq, ssize_t position, void *x)
{
    return ((void **)seq->array.array)[
        (seq->head + position) % seq->array.length] = x;
}
