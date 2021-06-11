#include<limits.h>
#include<stddef.h>
#include"mem.h"
#include"assert.h"
#include"table.h"

#define T table_t

struct T{
    int size;
    int (*cmp)(const void *x, const void *y);
    unsigned long (*hash)(const void *key);
    int length;
    unsigned long timestamp;

    struct binding{
        struct binding *link;
        const void *key;
        void *value;
    }**buckets;
};

static int _cmpatom(const void *x, const void *y);
static unsigned long _hashatom(const void *key);

T
table_new(int hint,
            int (*cmp)(const void *x, const void *y),
            unsigned long hash(const void *key))
{
    T table;
    int i;
    static int primes[] = {509, 509, 1021, 2053, 4093,
        8191, 16381, 32771, 65521, INT_MAX};

    assert(hint >= 0);

    for(i = 1; primes[i] < hint; i++)
        ;

    table = ALLOC(sizeof(*table) + 
            primes[i-1] * sizeof(table->buckets[0]));
    table->size = primes[i-1];
    table->cmp = cmp ? cmp : _cmpatom;
    table->hash = hash ? hash : _hashatom;
    table->buckets = (struct binding **) (table + 1);

    for(i = 0; i < table->size; i++)
        table->buckets[i] = NULL;
    table->length = 0;
    table->timestamp = 0;
    return table;
}


void *
table_get(T table, const void *key)
{
    int i;
    struct binding *p;

    assert(table);
    assert(key);

    i = (*table->hash)(key) % table->size;
    for(p = table->buckets[i]; p; p = p->link)
        if(0 == (*table->cmp)(key, p->key))
            break;

    return p ? p->value : NULL;
}


void *
table_put(T table, const void *key, void *value)
{
    int i;
    struct binding *p;
    void *prev;

    assert(table);
    assert(key);

    i = (*table->hash)(key) % table->size;
    for(p = table->buckets[i]; p; p = p->link)
        if(0 == (*table->cmp)(key, p->key))
            break;

    if(NULL == p){
        NEW(p);
        p->key = key;
        p->link = table->buckets[i];
        table->buckets[i] = p;
        table->length++;
        prev = NULL;
    }else
        prev = p->value;

    p->value = value;
    table->timestamp++;
    return prev;
}


int
table_length(T table)
{
    assert(table);
    return table->length;
}


void
table_map(T table,
            void (*apply)(const void *key, void **value, void *cl),
            void *cl)
{
    int i;
    unsigned long stamp;
    struct binding *p;

    assert(table);
    assert(apply);
    stamp = table->timestamp;

    for(i = 0; i < table->size; i++)
        for(p = table->buckets[i]; p; p = p->link){
            apply(p->key, &p->value, cl);
            assert(stamp == table->timestamp);
        }
}


void *
table_remove(T table, const void *key)
{
    int i;
    struct binding *p, **pp;

    assert(table);
    assert(key);

    table->timestamp++;
    i = (*table->hash)(key) % table->size;

    for(pp = &table->buckets[i]; *pp; pp = &(*pp)->link)
        if(0 == (*table->cmp)(key, (*pp)->key)){
            p = *pp;
            void *value = p->value;
            *pp = p->link;
            FREE(p);
            table->length--;
            return value;
        }

    return NULL;
}



void **
table_to_array(T table, void *end)
{
    int i, j = 0;

    void **array;
    struct binding *p;

    assert(table);
    array = ALLOC((2 * table->length + 1) * sizeof(*array));
    for(i = 0; i < table->size; i++)
        for(p = table->buckets[i]; p; p = p->link){
            array[j++] = (void *)p->key;
            array[j++] = p->value;
        }

    array[j] = end;

    return array;
}


void
table_free(T *table)
{
    int i;
    struct binding *p, *q;

    assert(table && *table);

    if((*table)->length > 0){
        for(i = 0; i < (*table)->size; i++)
            for(p = (*table)->buckets[i]; p; p = q){
                q = p->link;
                FREE(p);
            }
    }

    FREE(*table);
}





static
int 
_cmpatom(const void *x, const void *y)
{
    return x != y;
}

static
unsigned long
_hashatom(const void *key)
{
    return (unsigned long) key >> 2;
}
