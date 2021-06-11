/*
 * table.h - Simple hash table using a linear congruential generator
 * for collision resolution. Roughly based on CPython's dict object.
 *
 * Copyright 2017 Eric Chai <electromatter@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef TABLE_H
#define TABLE_H

/*
 * The collision resolution is based on the dict object from CPython see
 * <https://github.com/python/cpython/blob/master/Objects/dictobject.c>.
 *
 * For power of two bases, Hull-Dobell Theorem
 * states that the recurrence relation:
 * \[x_{n + 1} = a x_n + c \bmod m\]
 * has order m if and only if:
 *  - `m` and `c` are coprime
 *  - `a - 1` is divisible by all prime factors of `m`
 *  - `a - 1` is divisible by 4 if `m` is divisible by 4
 *
 * CPython chooses m = 2^k, a = 5, c = 1 along with the following
 * method to mix the high bits of the hash code into the probe index:
 * ```
 * hash >>= PRETURB_SHIFT;
 * j = (a * j + c + hash) % m;
 * ```
 *
 * This does not affect the Hull-Dobell theorem since hash tends to zero after
 * a few iterations. This shows that the relation is guaranteed to reach an
 * empty slot if one exists.
 */

#include <stdlib.h>

/*
 * If the load falls below TABLE_MIN_LOAD or if load_incl_del exceeds
 * TABLE_MAX_LOAD, then table is resized to a power of two at least as large
 * as TABLE_GROWTH. TABLE_PERTURB_SHIFT modifies how quickly the high bits of
 * the hash are incorporated into the table index. These are derived from
 * CPython.
 */
#define TABLE_PERTURB_SHIFT		5
#define TABLE_MIN_SIZE			8
#define TABLE_MIN_LOAD(table)		((table)->size / 4)
#define TABLE_MAX_LOAD(table)		(((table)->size * 2) / 3)
#define TABLE_GROWTH(table)		((table)->load * 2)

/* Define a table type */
#define TABLE_DEF(name, elem_t)						\
struct name {								\
	size_t size, load, load_incl_del, next;				\
	elem_t **items;							\
}

#define TABLE_INITIALIZER		{0, 0, 0, 0, NULL}
#define TABLE_LOAD(table)		((table)->load)
#define TABLE_EMPTY(table)		(!(table)->load)

/* The identity key and hash function. */
#define TABLE_ID_KEY(x)		(x)
#define TABLE_ID_HASH(x)	(x)
/* The dereference key function. */
#define TABLE_DEREF_KEY(x)	(*(x))

/* Deleted slot marker */
#define TABLE_DELETED			((void *)-1)

/*
 * For each slot of hash code hash until an empty slot is found.
 * Warning: shadows the variables index and perturb.
 */
#define TABLE_FOR_EACH_SLOT(slot_var, table, hash)			\
for (size_t perturb = (hash), index = (perturb) & ((table)->size - 1);	\
	*((slot_var) = &(table)->items[index]);				\
	index = (index * 5 + 1 + (perturb >>= TABLE_PERTURB_SHIFT))	\
						& ((table)->size - 1))

#define TABLE_PROTO(attr, prefix, table_t, key_t)			\
attr void prefix##init(table_t *table)					\
attr void prefix##clear(table_t *table)					\
attr elem_t *prefix##pop(table_t *table)				\
attr int prefix##insert(table_t *table, elem_t *elem)			\
attr elem_t *prefix##remove(table_t *table, key_t key)			\
attr elem_t *prefix##find(table_t *table, key_t key)

/*
 * Generate the hash table implementation.
 *
 * Parameters:
 *  - attr: The function attributes
 *  - prefix: The function identifier prefix
 *  - table_t: The table type as defined by TABLE_DEF
 *  - elem_t: The element type
 *  - key_t: The key type
 *  - keyf: The key function
 *  - hashf: The hash function
 *  - cmpf: The key comparison function
 *
 * The key function must have the signature:
 *
 * key_t keyf(elem_t *elem);
 *
 * The return value is the key of the element.
 *
 *
 * The hash function must have the signature:
 *
 * size_t hashf(key_t key);
 *
 * The return value is the hash-code of the key.
 *
 *
 * The compare function must have the signature:
 *
 * int cmpf(key_t left, key_t right);
 *
 * The return value of the compare function is specified as follows:
 *  - cmpf(left, right) = 1  if left `>` right
 *  - cmpf(left, right) = -1 if left `<` right
 *  - cmpf(left, right) = 0  if left `=` right
 *
 *
 * All functions operate in amortized O(1) time.
 *
 *
 * void prefix##init(table_t *table);
 *
 * Initialize the table to the empty state.
 *
 *
 * attr void prefix##clear(table_t *table);
 *
 * Clear the table.
 *
 *
 * attr elem_t *prefix##pop(table_t *table);
 *
 * Remove and return some item from the table.
 *
 *
 * attr int prefix##insert(table_t *table, elem_t *elem);
 *
 * Insert elem into the table and return zero, if another element already
 * exists in the table, then a non-zero value is returned.
 *
 *
 * attr elem_t *prefix##remove(table_t *table, key_t key);
 *
 * Remove and return an element with the key or return NULL if no element
 * exists in the table.
 *
 *
 * attr elem_t *prefix##find(table_t *table, key_t key);
 *
 * Return the element matching the key or NULL if no element exists in the
 * table.
 */
#define TABLE_GEN(attr, prefix, table_t, elem_t, key_t,			\
						keyf, hashf, cmpf)	\
attr void prefix##init(table_t *table)					\
{									\
	table->size = 0;						\
	table->load = 0;						\
	table->load_incl_del = 0;					\
	table->next = 0;						\
	table->items = NULL;						\
}									\
									\
attr void prefix##clear(table_t *table)					\
{									\
	table->size = 0;						\
	table->load = 0;						\
	table->load_incl_del = 0;					\
	table->next = 0;						\
	free(table->items);						\
	table->items = NULL;						\
}									\
									\
static inline int prefix##_rehash(table_t *table)			\
{									\
	size_t new_size, min_size, old_size;				\
	elem_t **old_items, **slot, *item;				\
									\
	min_size = TABLE_GROWTH(table);					\
	new_size = TABLE_MIN_SIZE;					\
	while (new_size < min_size)					\
		new_size *= 2;						\
									\
	old_items = table->items;					\
	old_size = table->size;						\
									\
	table->items = malloc(new_size * sizeof(elem_t *));		\
	if (!table->items) {						\
		table->items = old_items;				\
		return 0;						\
	}								\
									\
	table->size = new_size;						\
	table->load_incl_del = table->load;				\
	table->next = 0;						\
									\
	for (size_t i = 0; i < new_size; i++)				\
		table->items[i] = NULL;					\
									\
	for (size_t i = 0; i < old_size; i++) {				\
		item = old_items[i];					\
		if (!item || item == TABLE_DELETED)			\
			continue;					\
		TABLE_FOR_EACH_SLOT(slot, table, hashf(keyf(item))) {}	\
		*slot = item;						\
	}								\
									\
	free(old_items);						\
	return 0;							\
}									\
									\
attr elem_t *prefix##pop(table_t *table)				\
{									\
	elem_t *elem;							\
	for (; table->next < table->size; table->next++) {		\
		if (!table->items[table->next])				\
			continue;					\
									\
		if (table->items[table->next] == TABLE_DELETED)		\
			continue;					\
									\
		/* Remove the found item */				\
		elem = table->items[table->next];			\
		table->items[table->next] = TABLE_DELETED;		\
		table->load--;						\
		if (table->size >= TABLE_MIN_SIZE &&			\
				table->load < TABLE_MIN_LOAD(table))	\
			prefix##_rehash(table);				\
		return elem;						\
	}								\
	return NULL;							\
}									\
									\
attr int prefix##insert(table_t *table, elem_t *elem)			\
{									\
	size_t hash;							\
	elem_t **slot, **empty_slot;					\
									\
	if (table->load_incl_del >= TABLE_MAX_LOAD(table) &&		\
			prefix##_rehash(table))				\
		return 1;						\
									\
	empty_slot = NULL;						\
	hash = hashf(keyf(elem));					\
	TABLE_FOR_EACH_SLOT(slot, table, hash) {			\
		if (*slot == TABLE_DELETED) {				\
			if (!empty_slot)				\
				empty_slot = slot;			\
			continue;					\
		}							\
									\
		if (((size_t)hashf(keyf(*slot))) != hash)		\
			continue;					\
									\
		if (!cmpf(keyf(elem), keyf(*slot)))			\
			return 1;					\
	}								\
									\
	if (empty_slot) {						\
		*empty_slot = elem;					\
		table->next = 0;					\
		table->load++;						\
		return 0;						\
	}								\
									\
	*slot = elem;							\
	table->next = 0;						\
	table->load++;							\
	table->load_incl_del++;						\
	return 0;							\
}									\
									\
attr elem_t *prefix##remove(table_t *table, key_t key)			\
{									\
	size_t hash;							\
	elem_t **slot, *elem;						\
									\
	if (TABLE_EMPTY(table))						\
		return NULL;						\
									\
	hash = hashf(key);						\
	TABLE_FOR_EACH_SLOT(slot, table, hash) {			\
		if (*slot == TABLE_DELETED)				\
			continue;					\
									\
		if (((size_t)hashf(keyf(*slot))) != hash)		\
			continue;					\
									\
		if (!cmpf(key, keyf(*slot))) {				\
			elem = *slot;					\
			*slot = TABLE_DELETED;				\
			table->load--;					\
			if (table->size >= TABLE_MIN_SIZE &&		\
				    table->load < TABLE_MIN_LOAD(table))\
				prefix##_rehash(table);			\
			return elem;					\
		}							\
	}								\
									\
	return NULL;							\
}									\
									\
attr elem_t *prefix##find(table_t *table, key_t key)			\
{									\
	size_t hash;							\
	elem_t **slot;							\
									\
	if (TABLE_EMPTY(table))						\
		return NULL;						\
									\
	hash = hashf(key);						\
	TABLE_FOR_EACH_SLOT(slot, table, hash) {			\
		if (*slot == TABLE_DELETED)				\
			continue;					\
									\
		if (((size_t)hashf(keyf(*slot))) != hash)		\
			continue;					\
									\
		if (!cmpf(key, keyf(*slot)))				\
			return *slot;					\
	}								\
									\
	return NULL;							\
}

#endif
