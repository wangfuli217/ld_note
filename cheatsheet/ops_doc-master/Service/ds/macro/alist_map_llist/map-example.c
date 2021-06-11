#include <stdio.h>
#include "hmap.h"

uint32_t djb2(const char *str);

/* 
 * Create prototypes, structs and typedefs for a map with string keys and
 * integer values named map. This should be in every header using this map.
 *
 * This will create a type named `map` representing the map and a bunch of
 * functions, structs and typedefs with names like `map_new` or generally
 * `map_name`; the names of these functions and types are derived by appending
 * `_name` to what the map is named, `map` in this case.
 */
HMAP_PROTO(char *, int, map);

/*
 * Create functions for this map. This should be in one .c file.
 *
 * The key, value and name parameters are the same as in HMAP_PROTO.
 *
 * The fourth parameter is a function used to compare elements with the
 * signature `int compare_function(char *, char *)` in our case. It compares
 * the two keys given as the parameter and returns a value less than zero if
 * the first key is lesser than the second, 0 if the keys are equals and a
 * value greater than 0 if the first key is greater than the second.
 *
 * The last parameter is a function used to compute the hash with the signature
 * `uint32_t hash_function(char *)` in our case. It gets a key as a parameter
 * and must return a uint32_t hash of it. Optimally, keys should be evenly
 * distributed to avoid collisions. The hashmap will use the hash modulo the
 * number of its buckets, so if we use a map with 256 buckets, it will only
 * care about the least significant byte (equivalent to hash%256) as long as
 * it doesn't resize.
 */
HMAP(char *, int, map, strcmp, djb2);

/* a nice string hashing function, see http://www.cse.yorku.ca/~oz/hash.html */
uint32_t djb2(const char *str)
{
	uint32_t hash = 5381;
	int c;
	while ((c = *str++)) {
		hash = ((hash << 5) + hash) + c;
	}
	return hash;
}

/* a function that prints out the contents of the map */
void print_map(map *m)
{
	/* an iterator for iterating through all map entries */
	map_iterator i;

	/* the method `int map_size(map *) returns the current number of entries */
	printf("map (size: %d) {", map_size(m));

	/* just like lists, map is iterated with _iterate and _next */
	for (i=map_iterate(m); map_next(m, &i); ) {
		/* map_key_at and map_value_at return the key and value, respectively */
		printf(" %s:%d,", map_key_at(m, i), map_value_at(m, i));
	}
	printf("\b }\n");
}

int main(void)
{
	map *m;
	int contains;
	int value;

	/*
	 * `map *map_new(void)` allocates a new hashmap with 256 buckets.
	 *
	 * To specify the number of buckets to use manually, use
	 * `map *map_new_cap(int buckets)` instead.
	 *
	 * More buckets usually means less collisions, but the map will take up more
	 * space. When two entries go in the same bucket, a linear search is necessary
	 * to access the correct item.
	 */
	m = map_new();

	/*
	 * `int map_set(map *m, char *key, int value)` sets the map entry at `key` to
	 * `value`.
	 *
	 * If no entry with such key exists, a new one is added. Otherwise,
	 * the existing entry is overwritten.
	 */
	map_set(m, "foo", 1);
	map_set(m, "bar", 2);
	map_set(m, "baz", 4);
	map_set(m, "quux", 4);

	/* map (size: 4) { quux:4, foo:1, bar:2, baz:4 }; note: undefined order */
	print_map(m); 

	map_set(m, "baz", 3);

	/*
	 * `int map_get(const map *m, char *key)` returns the value associated with
	 * the key `key`.
	 *
	 * If no such entry exists in the map, a zeroed value is returned, 0 in our
	 * case.
	 */
	printf("baz: %d\n", map_get(m, "baz")); /* baz: 3 */

	/*
	 * `int map_contains(const map *m, char *key)` returns 1 if `key` is set in
	 * the map, 0 otherwise.
	 */
	printf("qwe in map: %s\n", map_contains(m, "qwe")?"yes":"no"); /* qwe in map: no */

	/*
	 * `int map_get_contains(const map *m, char *key, int *value)` returns 1 if
	 * `key` is in `m`, 0 otherwise. If the key exists, `*value` is set to the
	 * value of that entry. If it doesn't, then the space `value` points to is
	 * not touched.
	 */
	value = -1;
	contains = map_get_contains(m, "foo", &value);
	printf("foo in map: %s, value: %d\n", contains?"yes":"no", value); /* foo in map: yes, value: 1 */

	/*
	 * `int map_get_default(const map *m, char *key, int value)` returns the value
	 * associated with the key `key` if such an entry exists in the map, otherwise
	 * it returns the value of the `value` parameter.
	 */
	printf("asd (default: -1): %d\n", map_get_default(m, "asd", -1)); /* asd (default: -1): -1 */

	/*
	 * `int map_delete(map *m, char *key)` removes the entry with key `key` from
	 * `m`. If no such entry exists, this does nothing and returns 0; it returns
	 * 1 if an entry was removed.
	 */
	map_delete(m, "quux");
	map_delete(m, "asd");

	print_map(m); /* map (size: 3) { foo:1, bar:2, baz:3 } */

	/* `void map_free(map *m)` frees the map and its resources */
	map_free(m);

	return 0;
}
