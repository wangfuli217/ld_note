#include "table.h"

#include <limits.h>
#include <stddef.h>
#include <stdlib.h>
#include <assert.h>

#define T table_t

static int cmpatom(const void *x, const void *y) {
    return x != y;
}

static unsigned int hashatom(const void *key) {
    return (unsigned long)key >> 2;
}

T table_new   (int hint,
        int cmp(const void *x, const void *y),
        unsigned int hash(const void *key)) {
    T table;
    static const int primes[] = {
        509, 509, 1021, 3053, 4093, 8191, 16381, 32771, 65521, INT_MAX
    };
    assert(hint >= 0);
    int i = 1;
    while (primes[i] < hint)
        ++i;
    table = malloc(sizeof(*table) + primes[i-1] * sizeof(table->buckets[0]));
    table->size = primes[i-1];
    table->cmp = cmp ? cmp : cmpatom;
    table->hash = hash ? hash : hashatom;
    table->buckets = (struct binding **)(table + 1);
    for (i = 0; i != table->size; ++i)
        table->buckets[i] = NULL;
    table->length = 0;
    table->timestamp = 0;
    return table;
}

void table_free (T *table) {
    assert(table && *table);
    if ((*table)->length > 0) {
        struct binding *p, *q;
        for (int i = 0; i < (*table)->size; ++i)
            for (p = (*table)->buckets[i]; p; p = q) {
                q = p->link;
                free(p);
            }
    }
    free(*table);
}

int table_length (T table) {
    assert(table);
    return table->length;
}

void *table_put (T table, void *key, void *value) {
    struct binding *p;
    void *prev;
    assert(table);
    assert(key);
    int i = (*table->hash)(key) % table->size;
    for (p = table->buckets[i]; p; p = p->link)
        if ((*table->cmp)(key, p->key) == 0)
            break;
    if (p == NULL) {
        p = malloc(sizeof(*p));
        p->key = key;
        p->link = table->buckets[i];
        table->buckets[i] = p;
        ++(table->length);
        prev = NULL;
    } else
        prev = p->value;
    p->value = value;
    ++(table->timestamp);
    return prev;
}

void *table_get (T table, const void *key) {
    struct binding *p;
    assert(table);
    assert(key);
    int i = (*table->hash)(key) % table->size;
    for (p = table->buckets[i]; p; p = p->link)
        if ((*table->cmp)(key, p->key) == 0)
            break;
    return p ? p->value : NULL;
}

struct binding *table_remove (T table, void *key) {
    assert(table);
    assert(key);
    ++(table->timestamp);
    int i = (*table->hash)(key) % table->size;
    for (struct binding **pp = &table->buckets[i]; *pp; pp = &(*pp)->link)
        if ((*table->cmp)(key, (*pp)->key) == 0) {
            struct binding *p = *pp;
            *pp = p->link;
            --(table->length);
            return p;
        }
    return NULL;
}

void table_map (T table,
        void apply(void *key, void **value)) {
    assert(table);
    assert(apply);
    unsigned int stamp = table->timestamp;
    for (int i = 0; i != table->size; ++i)
        for (struct binding *p = table->buckets[i]; p; p = p->link) {
            apply(p->key, &p->value);
            assert(table->timestamp = stamp);
        }
}

void table_map_cl (T table,
        void apply(void *key, void **value, void *cl),
        void *cl) {
    assert(table);
    assert(apply);
    unsigned int stamp = table->timestamp;
    for (int i = 0; i != table->size; ++i)
        for (struct binding *p = table->buckets[i]; p; p = p->link) {
            apply(p->key, &p->value, cl);
            assert(table->timestamp = stamp);
        }
}

#undef T
