#include<limits.h>
#include<stddef.h>
#include"mem.h"
#include"assert.h"
#include"arith.h"
#include"set.h"

#define T set_t


struct T{
    int length;
    unsigned long timestamp;
    int (*cmp) (const void *x, const void *y);
    unsigned long (*hash) (const void *x);
    int size;
    struct member{
        struct member *link;
        const void *member;
    }**buckets;
};

static int _cmpatom(const void *x, const void *y);
static unsigned long _hashatom(const void *x);
static T _set_copy(T t, int hint);


T
set_new(int hint,
            int cmp(const void *x, const void *y),
            unsigned long hash(const void *x))
{
    T set;
    int i;
    static int primes[] = {509, 509, 1021, 2053, 4093,
        8191, 16381, 32771, 65521, INT_MAX};
    assert(hint >= 0);
    
    for(i = 1; primes[i] < hint; i++)
        ;

    set = ALLOC(sizeof(*set) + primes[i-1] * sizeof(set->buckets[0]));
    set->size = primes[i-1];
    set->cmp = cmp ? cmp : _cmpatom;
    set->hash= hash ? hash : _hashatom;
    set->buckets = (struct member **) (set + 1);
    for(i = 0; i < set->size; i++)
        set->buckets[i] = NULL;
    set->length = 0;
    set->timestamp = 0;
    
    return set;
}

int
set_member(T set, const void *member)
{
    int i;
    struct member *p;

    assert(set);
    assert(member);

    //<search set for member>
    i = (*set->hash)(member)% set->size;
    for(p = set->buckets[i]; p; p = p->link)
        if(0 == (*set->cmp)(member, p->member))
            break;

    return NULL != p;
}

void
set_put(T set, const void *member)
{
    int i;
    struct member *p;

    assert(set);
    assert(member);

    //<search set for member>
    i = (*set->hash)(member) % set->size;
    for(p = set->buckets[i]; p; p = p->link)
        if(0 == (*set->cmp)(member, p->member))
            break;

    if(NULL == p){
        //<add member to set>
        NEW(p);
        p->member = member;
        p->link = set->buckets[i];
        set->buckets[i] = p;
        set->length++;
    }else
        p->member = member;

    set->timestamp;
}


void *
set_remove(T set, const void *member)
{
    int i;
    struct member *p, **pp;

    assert(set);
    assert(member);

    set->timestamp++;
    i = (*set->hash)(member) % set->size;
    for(pp = &set->buckets[i]; *pp; pp = &(*pp)->link)
        if(0 == (*set->cmp)(member, (*pp)->member)){
            p = *pp;
            *pp = p->link;
            member = p->member;
            FREE(p);
            set->length--;
            return (void *)member;
        }

    return NULL;
}




int
set_length(T set)
{
    assert(set);
    return set->length;
}



void
set_free(T *set)
{
    int i;
    struct member *p, *q;

    assert(set && *set);

    if((*set)->length > 0){
        for(i = 0; i < (*set)->size; i++)
            for(p = (*set)->buckets[i]; p; p = q){
                q = p->link;
                FREE(p);
            }
    }

    FREE(*set);
}



void
set_map(T set,
            void (*apply)(const void *member, void *cl),
            void *cl)
{
    int i;
    unsigned long stamp;
    struct member *p;

    assert(set);
    assert(apply);

    stamp = set->timestamp;

    for(i = 0; i < set->size; i++)
        for(p = set->buckets[i]; p; p = p->link){
            apply(p->member, cl);
            assert(set->timestamp == stamp);
        }
}



void **
set_to_array(T set, void *end)
{
    int i, j = 0;
    void **array;
    struct member *p;

    assert(set);

    array = ALLOC((set->length + 1) * sizeof(*array));

    for(i = 0; i < set->size; i++)
        for(p = set->buckets[i]; p; p = p->link)
            array[j++] = (void *)p->member;
    array[j] = end;

    return array;
}


T
set_union(T s, T t)
{
    T set;
    int i;
    struct member *q;

    if(NULL == s){

        assert(t);
        return _set_copy(t, t->size);
    }else if(NULL == t){
        return _set_copy(s, s->size); 
    }else{
        assert(s->cmp == t->cmp && s->hash == t->hash);

        set = _set_copy(s, arith_max(s->size, t->size));
        for (i = 0; i < t->size; i++)
            for (q = t->buckets[i]; q; q = q->link)
                set_put(set, q->member);
		return set;
    }
}


T
set_inter(T s, T t)
{
    T set;
    int i, j;
    struct member *q, *p;
    const void *member;

    if(NULL == s){

        assert(t);
        return set_new(t->size, t->cmp, t->hash);
    }else if(NULL == t){
        return set_new(s->size, s->cmp, s->hash);
    }else if(s->length < t->length){
        return set_inter(t, s);
    }else{
        assert(s->cmp == t->cmp && s->hash == t->hash);

        set = set_new(arith_min(s->size, t->size),
                s->cmp, s->hash);
        for (i = 0; i < t->size; i++)
            for (q = t->buckets[i]; q; q = q->link)               
                if(set_member(s, q->member)){
                    member = q->member;
                    j = (*set->hash)(member)%set->size;
                    NEW(p);
                    p->member = member;
                    p->link = set->buckets[j];
                    set->buckets[j] = p;
                    set->length++;
                }
		return set;
    }
}


T
set_minus(T s, T t)
{
    T set;
    int i, j;
    struct member *q, *p;
    const void *member;

    if(NULL == t){

        assert(s);
        return set_new(t->size, t->cmp, t->hash);
    }else if(NULL == s){
        return _set_copy(t, t->size);
    }else{
        assert(s->cmp == t->cmp && s->hash == t->hash);

        set = set_new(arith_min(s->size, t->size),
                s->cmp, s->hash);
        for (i = 0; i < t->size; i++)
            for (q = t->buckets[i]; q; q = q->link)               
                if(!set_member(s, q->member)){
                    member = q->member;
                    j = (*set->hash)(member)%set->size;
                    NEW(p);
                    p->member = member;
                    p->link = set->buckets[j];
                    set->buckets[j] = p;
                    set->length++;
                }
		return set;
    }
}


T
set_diff(T s, T t)
{
    T set;
    int i, j;
    struct member *q, *p;
    const void *member;

    if(NULL == s){

        assert(t);
        return _set_copy(t, t->size);
    }else if(NULL == t){
        return _set_copy(s, s->size);
    }else{
        assert(s->cmp == t->cmp && s->hash == t->hash);

        set = set_new(arith_min(s->size, t->size),
                s->cmp, s->hash);
        for (i = 0; i < t->size; i++)
            for (q = t->buckets[i]; q; q = q->link)               
                if(!set_member(s, q->member)){
                    member = q->member;
                    j = (*set->hash)(member)%set->size;
                    NEW(p);
                    p->member = member;
                    p->link = set->buckets[j];
                    set->buckets[j] = p;
                    set->length++;
                }
        {T u = t; t = s; s = u;}
        for (i = 0; i < t->size; i++)
            for (q = t->buckets[i]; q; q = q->link)               
                if(!set_member(s, q->member)){
                    member = q->member;
                    j = (*set->hash)(member)%set->size;
                    NEW(p);
                    p->member = member;
                    p->link = set->buckets[j];
                    set->buckets[j] = p;
                    set->length++;
                }
		return set;
    }
}


static
int 
_cmpatom(const void *x, const void *y)
{
    return x != y;
}

static
unsigned long
_hashatom(const void *x)
{
    return (unsigned long) x >> 2;
}

static
T
_set_copy(T t, int hint)
{
    T set;
    int i, j;
    struct member *q, *p;
    const void *member;

    assert(t);
    set = set_new(hint, t->cmp, t->hash);

    //<for each member q>
    for(i = 0; i < t->size; i++)
        for(q = t->buckets[i]; q; q = q->link){
            //<add q->member to set>
            member = q->member;
            j = (*set->hash)(member) % set->size;
            
            //<add member to set>
            NEW(p);
            p->member = member;
            p->link = set->buckets[j];
            set->buckets[j] = p;
            set->length++;
        }

    return set;
}
