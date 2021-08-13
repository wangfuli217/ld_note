#ifndef __HASH_TABLE_H_KEIXJ4PDU3__
#define __HASH_TABLE_H_KEIXJ4PDU3__

#include "hash_list.h"

typedef int (*HashFunction)(void*, int);

typedef enum {DECREASE, INCREASE} ht_resize;

typedef struct _HashTable {
    HashList_p* table; // array
    unsigned int size;
    unsigned int recordInserted;
} HashTable_t, *HashTable_p;


HashTable_p hash_table_create(size_t size);
void hash_table_resize(HashTable_p hash_table, ht_resize op, HashFunction hashing, CompFunction compare);
void* hash_table_insert(HashTable_p hash_table, void* key, size_t key_size, void* record, HashFunction hashing, CompFunction compare);
void* hash_table_search(HashTable_p hash_table, void* key, HashFunction hashing, CompFunction compare);
void* hash_table_delete(HashTable_p hash_table, void* key, HashFunction hashing,CompFunction compare);
void hash_table_destroy(HashTable_p hash_table);

#endif
