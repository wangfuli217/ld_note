#include <limits.h>
#include <stddef.h>

#include "mem.h"
#include "assert.h"
#include "table.h"
#include "safeint.h"

#define T Table_T

struct T {
	int size;
	int (*cmp)(const void *x, const void *y);
	unsigned (*hash)(const void *key);
	int length;
	unsigned timestamp;
	struct binding {
		struct binding *link;
		const void *key;
		void *value;
	} **buckets;
};

static int cmpatom(const void *x, const void *y) {
	return x != y;
}

static unsigned hashatom(const void *key) {
	return (unsigned long)key>>2;
}

T Table_new(int hint,
	int cmp(const void *x, const void *y),
	unsigned hash(const void *key)) {
	T table;
	int i;
	static int primes[] = { 509, 509, 1021, 2053, 4093,
		8191, 16381, 32771, 65521, INT_MAX };
    size_t primessz;

	assert(hint >= 0);
	for (i = 1; primes[i] < hint; i++)
		;
    primessz = safe_cast_su(primes[i - 1]);
	table = ALLOC(sizeof (*table) + primessz * sizeof (table->buckets[0]));
	table->size = primes[i-1];
	table->cmp  = cmp  ?  cmp : cmpatom;
	table->hash = hash ? hash : hashatom;
	table->buckets = (struct binding **)(table + 1);
	for (i = 0; i < table->size; i++)
		table->buckets[i] = NULL;
	table->length = 0;
	table->timestamp = 0;
	return table;
}

void *Table_get(T table, const void *key) {
	int i;
	struct binding *p;
	size_t usize = safe_cast_su(table->size);

	assert(table);
	assert(key);

	i = safe_cast_us((*table->hash)(key) % usize);
	for (p = table->buckets[i]; p; p = p->link)
		if ((*table->cmp)(key, p->key) == 0)
			break;
	return p ? p->value : NULL;
}

void *Table_put(T table, const void *key, void *value) {
	int i;
	struct binding *p;
	void *prev;
	size_t usize = safe_cast_su(table->size);

	assert(table);
	assert(key);

	i = safe_cast_us((*table->hash)(key) % usize);
	for (p = table->buckets[i]; p; p = p->link)
		if ((*table->cmp)(key, p->key) == 0)
			break;
	if (p == NULL) {
		NEW(p);
		p->key = key;
		p->link = table->buckets[i];
		table->buckets[i] = p;
		table->length++;
		prev = NULL;
	} else
		prev = p->value;
	p->value = value;
	table->timestamp++;
	return prev;
}

int Table_length(T table) {
	assert(table);
	return table->length;
}

void Table_map(T table,
	void apply(const void *key, void **value, void *cl),
	void *cl) {
	int i;
	unsigned stamp;
	struct binding *p;
	assert(table);
	assert(apply);
	stamp = table->timestamp;
	for (i = 0; i < table->size; i++)
		for (p = table->buckets[i]; p; p = p->link) {
			apply(p->key, &p->value, cl);
			assert(table->timestamp == stamp);
		}
}

void *Table_remove(T table, const void *key) {
	int i;
	struct binding **pp;
	size_t usize = safe_cast_su(table->size);

	assert(table);
	assert(key);

	table->timestamp++;
	i = safe_cast_us((*table->hash)(key) % usize);
	for (pp = &table->buckets[i]; *pp; pp = &(*pp)->link)
		if ((*table->cmp)(key, (*pp)->key) == 0) {
			struct binding *p = *pp;
			void *value = p->value;
			*pp = p->link;
			FREE(p);
			table->length--;
			return value;
		}
	return NULL;
}

#pragma GCC diagnostic ignored "-Wcast-qual"
void **Table_toArray(T table, void *end) {
	int i, j = 0;
	void **array;
	struct binding *p;
	size_t lengthsz = safe_cast_su(table->length);

	assert(table);

	array = ALLOC((2 * lengthsz + 1)*sizeof (*array));
	for (i = 0; i < table->size; i++)
		for (p = table->buckets[i]; p; p = p->link) {
			array[j++] = (void*)p->key;
			array[j++] = p->value;
		}
	array[j] = end;
	return array;
}

void Table_free(T *table) {
	assert(table && *table);
	if ((*table)->length > 0) {
		int i;
		struct binding *p, *q;
		for (i = 0; i < (*table)->size; i++)
			for (p = (*table)->buckets[i]; p; p = q) {
				q = p->link;
				FREE(p);
			}
	}
	FREE(*table);
}
