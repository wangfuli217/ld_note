// hash.h
// Structures and functions for working with hash tables.
//
// MAINTAINER
//     Justin J. Meza <justin dot meza at gmail dot com>
//
// STYLE
// - `#define's are not used to keep the code clear.
// - Argument names are in CAPS.
// - Control structures without braces will appear on a single line (if space
//   permits).
// - NULL is used instead of 0 for indicating a null-pointer.
//
// EXAMPLE
/*
	TODO: Make an example
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "list.h"

////////// >>> Copy the following function into the client code and implement
        //     any special freeing of data structures being stored in the hash
        //     table (DATA). Replace the `T' in `data_delete_T' with a unique
        //     name (perhaps the datatype name) and pass this function name to
        //     the call to `hash_create' for this particular type of hash table
        //     to ensure all of its data items' memories are freed properly.

/*
void
data_delete_T(void *DATA)
	// This function is meant to be used if the data structures this list
	// points to contain other allocated memory which must be separately
	// freed. Do so here.
{
	// EXAMPLE
	// free(DATA->my_pointer);
	free(DATA);
}
*/

////////// Structures and functions required for internal implementation. These
        // need not be dealt with directly.

struct hash {
	void (*delete)(void *);
	unsigned int size;
	struct list **table;
};

struct pair {
	void *key;
	void *value;
	void (*delete)(void *);
};

struct pair *
pair_create(void *KEY, void *VALUE, void (*DELETE)(void *))
	// Assumes KEY is a string.
{
	struct pair *pair = malloc(sizeof(struct pair));
	// >>>>> Begin key-specific code.
	pair->key = malloc(sizeof(char) * (strlen(KEY) + 1));
	strcpy(pair->key, KEY);
	// <<<<< End key-specific code.
	pair->value = VALUE;
	pair->delete = DELETE;
	return pair;
}

int
pair_delete(struct pair *PAIR)
	// Make sure any data stored in the PAIR->data datatype is freed prior
	// to calling this function.
{
	if (!PAIR) return -1;
	// >>>>> Begin key-specific code.
	free(PAIR->key);
	// <<<<< End key-specific code.
	PAIR->delete(PAIR->value);
	free(PAIR);
	return 0;
}

void
data_delete_pair(void *DATA)
{
	pair_delete(DATA);
}

////////// Functions for use with hash tables

struct hash *
hash_create(void (*DELETE)(void *), unsigned int SIZE)
	// Creates a hash table of initial size SIZE. A prime number
	// proportional to the size of the potential data set is recommended to
	// reduce collisions and therefore lookup time.
{
	struct hash *hash = malloc(sizeof(struct hash));
	int n;
	hash->delete = DELETE;
	hash->size = SIZE;
	hash->table = malloc(sizeof(struct list *) * hash->size);
	for (n = 0; n < hash->size; n++)
		(hash->table)[n] = list_create(data_delete_pair);
	return hash;
}

void
hash_delete(struct hash *HASH)
	// Delete a hash structure and all of the data contained within its
	// elements. (This function utilizes the function passed to
	// `hash_create' to properly delete the individule pair contents.)
{
	int n;
	if (!HASH) return;
	for (n = 0; n < HASH->size; n++) {
		struct list *list = (HASH->table)[n];
		if (list) list_delete(list);
	}
	free(HASH->table);
	free(HASH);
}

unsigned int
hash_map(struct hash *HASH, void *DATA)
	// TODO: There must be a way of doing this that decreases collisions.
{
	return (int)DATA % HASH->size;
}

int
hash_insert(struct hash *HASH, void *KEY, void *DATA)
	// The idea is that by pushing the data item onto the front of a mapped
	// hash list, we will be obeying locality of reference which says that
	// if something needs to be inserted into the hash table right now, it
	// will likely be referenced in the near future where it will quickly be
	// found near the front of the list.
{
	struct pair *pair = NULL;
	struct list *list = NULL;
	if (!HASH || !KEY) return -1;
	list = (HASH->table)[hash_map(HASH, KEY)];
	list_push_front(list, pair_create(KEY, DATA, HASH->delete));
	return 0;
}

void *
hash_find(struct hash *HASH, void *KEY)
{
	struct list *list = NULL;
	struct item *item = NULL;
	if (!HASH || !KEY) return NULL;
	list = (HASH->table)[hash_map(HASH, KEY)];
	if (!list) return NULL;
	item = list->head;
	while (item) {
		struct pair *pair = item->data;
		if (!strcmp(pair->key, KEY)) return pair->value;
		item = item->next;
	}
	return NULL;
}

void
hash_remove(struct hash *HASH, void *KEY)
        // 0 Make a temporary list
        // 1 While the table list is not empty,
        // 1.1 If the head of the table list is the key to remove,
        // 1.1.1 Properly delete it's data
        // 1.2 Else, push the head of the table list onto the temporary list
        // 1.3 Pop the head of the table list
        // 2 Change the table list to point to the temporary list
        // 3 Properly delete the old table list
{
	struct list *list = NULL;
	struct list *temp = NULL;
	if (!HASH || !KEY) return;
	list = (HASH->table)[hash_map(HASH, KEY)];
        // 0 Make a temporary list
	temp = list_create(data_delete_pair);
        // 1 While the table list is not empty,
	while (!list_empty(list)) {
		struct pair *pair = list->head->data;
		struct pair *keep = NULL;
       	// 1.1 If the head of the table list is the key to remove,
		if (!strcmp(pair->key, KEY)) {
        // 1.1.1 Properly delete it's data
			list_pop_front(list);
			continue;
		}
        // 1.2 Else, push the head of the table list onto the temporary list
		keep = malloc(sizeof(struct pair));
		memcpy(keep, pair, sizeof(struct pair));
		list_push_back(temp, keep);
        // 1.3 Pop the head of the table list
		list_pop_front(list);
	}
        // 2 Change the table list to point to the temporary list
	(HASH->table)[hash_map(HASH, KEY)] = temp;
        // 3 Properly delete the old table list
	list_delete(list);
}


void
data_delete_int(void *DATA)
{
	free(DATA);
}

int
main(int ARGC, char **ARGV)
{
	struct hash *hash;
	int *i0 = malloc(sizeof(int));
	int *i1 = malloc(sizeof(int));
	int *i2 = malloc(sizeof(int));
	*i0 = 1;
	*i1 = 2;
	*i2 = 505;
	hash = hash_create(data_delete_int, 97);
	hash_insert(hash, "one", i0);
	hash_insert(hash, "two", i1);
	hash_insert(hash, "fiveohfive", i2);
	printf("Some maps: %d, %d, %d\n",
			hash_map(hash, i0),
			hash_map(hash, i1),
			hash_map(hash, i2));
	printf("Looked up: %d\n", *(int *)hash_find(hash, "one"));
	printf("Looked up: %d\n", *(int *)hash_find(hash, "two"));
	printf("Looked up: %d\n", *(int *)hash_find(hash, "fiveohfive"));
	hash_remove(hash, "one");
	hash_remove(hash, "fiveohfive");
	if (hash_find(hash, "one"))
		printf("Looked up: %d\n", *(int *)hash_find(hash, "one"));
	printf("Looked up: %d\n", *(int *)hash_find(hash, "two"));
	if (hash_find(hash, "fiveohfive"))
		printf("Looked up: %d\n", *(int *)hash_find(hash, "fiveohfive"));
	hash_delete(hash);
	
	system("pause");
	return 0;
}
