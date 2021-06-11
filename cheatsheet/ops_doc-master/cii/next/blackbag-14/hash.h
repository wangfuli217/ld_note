#ifndef HASH_H
#define HASH_H

#include "pair.h"

/*
 * Hash table cribbed from Jenkins, because it dynamically resizes, uses
 * a good hash function, keeps cursors, and is probably better tested than
 * the alternatives. 
 * 
 * Unlike btree this just takes/compares buffers, so no comparison functions
 * are used.
 */

typedef struct hash_s hash_t;
typedef void *hash_iter_t;

/* create a new hash table, with "hint" a guess at how big it might get.
 */
hash_t *hash_new(size_t hint);

/* retrieve the element of the hash table with key:len as a key
 */
void *hash_get(hash_t *t, void *key, size_t len);

/* store an element in the hash table with key:len, associate "data" to it
 * (may be NULL, may be a pointer to the same memory as the key)
 */
void *hash_put(hash_t *t, void *key, size_t len, void *data);

/* how many elements are in the table?
 */
size_t hash_count(hash_t *t);

/* delete an element by its key, returning pointers to the key and data
 * (you are responsible for freeing this memory, the hash table never 
 * touches it)
 */
pair_t hash_delete(hash_t *t, void *key, size_t len);

/* release a whole hash table, freeing the memory consumed by the table
 * but not the memory consumed by the keys and data (loop over all elements
 * of the table using _map() to do that)
 */
void hash_release(hash_t **t);

/* unbind all keys and values in the hash table, but because we don't 
 * free the memory consumed by those elements, this is usally not a
 * safe operation (it will leak memory) and this function is here for
 * consistency. If you have hash tables that come and go, or get reset,
 * recommend allocating keys and values from an arena.
 */
void hash_clear(hash_t *t);

/* call "apply" with obvious arguments for every element in the table.
 */
void hash_map(hash_t *t, 
	      void apply(const void *key, size_t len, void **value, void *cl),
	      void *cl);

/* XXX provide iterators here (jenkins hash keeps cursors, should be easy) */

#endif
