#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hash_table.h"



/****************
HASH TABLE CREATE
****************/
HashTable_p hash_table_create(size_t size) {
  if (size < 1)
    size = 3;

  // initialize hash table
  HashTable_p new_hash_table = (HashTable_p) malloc(sizeof(HashTable_t));
  new_hash_table->table = (HashList_p*) malloc(sizeof(HashList_p) * size);
  new_hash_table->size = size;
  new_hash_table->recordInserted = 0;

  // initialize all the hash table entry tith an empty list
	for(int i = 0; i < new_hash_table->size; i++)
    (new_hash_table->table)[i] = hash_list_create();

	return new_hash_table;
}


/****************
HASH TABLE RESIZE
****************/
void hash_table_resize(HashTable_p hash_table, ht_resize op, HashFunction hashing, CompFunction compare){

  size_t newSize = (op == INCREASE)? (hash_table->size * 2) : (hash_table->size / 2);

  HashTable_p new_hash_table = hash_table_create(newSize);

  unsigned int hash;
  HashNode_p item;

  //scan the old hash table and copy the nodes of the list in the new hashtable with new hash
  for(int i = 0; i < hash_table->size; i++){

    while ( (hash_table->table)[i]->first ){

      item = (hash_table->table)[i]->first;
      (hash_table->table)[i]->first = item->next;

      hash = hashing(item->key, newSize);
      hash_list_insert((new_hash_table->table)[hash], item);
    }
    free((hash_table->table)[i]);
  }

  free(hash_table->table);
  hash_table->table = new_hash_table->table;
  hash_table->size = newSize;
  free(new_hash_table);
}


/****************
HASH TABLE INSERT
****************/
void* hash_table_insert(HashTable_p hash_table, void* key, size_t key_size, void* record, HashFunction hashing, CompFunction compare){

  void* replacedRecord = NULL;

  unsigned int hash = hashing(key, hash_table->size);

  //search if the key is already present in this case we replace the record
  HashNode_p nodeFound = hash_list_search((hash_table->table)[hash], key, compare);

  if (nodeFound){
    replacedRecord = nodeFound->record;
    nodeFound->record = record;
  } else {
    nodeFound = hash_node_create(key, key_size, record);
    hash_table->recordInserted++;
    hash_list_insert((hash_table->table)[hash], nodeFound);
  }

  //if the hash table is half full we resize it with doubled size
  if (hash_table->recordInserted > hash_table->size/2)
    hash_table_resize(hash_table, INCREASE, hashing, compare);

  return replacedRecord;
}


/****************
HASH TABLE SEARCH
****************/
void* hash_table_search(HashTable_p hash_table, void* key, HashFunction hashing, CompFunction compare) {
  unsigned int hash = hashing(key, hash_table->size);
  HashNode_p nodeFound = hash_list_search((hash_table->table)[hash], key, compare);
  return (nodeFound) ? nodeFound->record : NULL;
}


/****************
HASH TABLE DELETE
****************/
void* hash_table_delete(HashTable_p hash_table, void* key, HashFunction hashing,CompFunction compare){
  void* result = NULL;
  unsigned int hash = hashing(key, hash_table->size);
  HashNode_p nodeFound = hash_list_search((hash_table->table)[hash], key, compare);

  if (nodeFound) {
    result = nodeFound->record;
    hash_list_remove_node((hash_table->table)[hash], nodeFound);
    free(nodeFound);
    hash_table->recordInserted--;
  }

  if(hash_table->recordInserted < hash_table->size/4)
    hash_table_resize(hash_table, DECREASE, hashing, compare);

  return result;
}


/*****************
HASH TABLE DESTROY
*****************/
void hash_table_destroy(HashTable_p hash_table){
  if(hash_table){
    for (int i=0; i<hash_table->size; i++) {
      hash_list_destroy(hash_table->table[i]);
    }
    free(hash_table->table);
    free(hash_table);
  }
}
