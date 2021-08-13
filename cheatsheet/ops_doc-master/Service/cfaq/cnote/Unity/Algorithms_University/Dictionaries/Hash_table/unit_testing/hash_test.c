#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include "../hash_table.h"
#include <string.h>
#include "unity.h"

void setUp() {
}

void tearDown() {
}

HashTable_p ht_lib;
HashTable_p ht_man;

// HELPER FUNCTIONS

int hash_val(void* valKey, int arraySize){
  int* intKey = (int*) valKey;
  return *intKey % arraySize;
}

int compare_int_ptr(void* ptr1, void* ptr2) {
  int i1 =  *(int*)ptr1;
  int i2 =  *(int*)ptr2;
  if (i1<i2) {
    return -1;
  }

  if(i1==i2) {
    return 0;
  }

  return 1;
}

int* new_int(int value) {
  int* result = (int*) malloc(sizeof(int));
  *result = value;
  return result;
}

HashTable_p hash_table_create_man(int* array[]){
  HashTable_p new_ht_man = (HashTable_p) malloc(sizeof(HashTable_t));
  new_ht_man->table = (HashList_p*) malloc(sizeof(HashList_p) * 1000037);
  new_ht_man->size = 1000037;
  new_ht_man->recordInserted = 10;


  for(int i = 0; i < 1000037; i++)
    (new_ht_man->table)[i] = (HashList_p) hash_list_create();

  (new_ht_man->table)[8]->first = hash_node_create((void*) array[1], sizeof(*array[1]), (void*) array[1]);

  (new_ht_man->table)[8]->first->next = hash_node_create((void*) array[0], sizeof(*array[0]), (void*) array[0]);

  (new_ht_man->table)[8]->first->next->prev = (new_ht_man->table)[8]->first;

  (new_ht_man->table)[3]->first = hash_node_create((void*) array[3], sizeof(*array[3]), (void*) array[3]);

  (new_ht_man->table)[3]->first->next = hash_node_create((void*) array[2], sizeof(*array[2]), (void*) array[2]);

  (new_ht_man->table)[3]->first->next->prev = (new_ht_man->table)[3]->first;
  
  (new_ht_man->table)[5]->first = hash_node_create((void*) array[4], sizeof(*array[4]), (void*) array[4]);

  (new_ht_man->table)[12]->first = hash_node_create((void*) array[6], sizeof(*array[6]), (void*) array[6]);

  for(int i = 7; i < 11; i++){
    (new_ht_man->table)[*array[i]]->first = hash_node_create((void*) array[i], sizeof(*array[i]), (void*) array[i]);
  }

  return new_ht_man;
}

void equal_table(HashTable_p ht1, HashTable_p ht2){
  assert(ht1->size == ht2->size);
  assert(ht1->recordInserted == ht2->recordInserted);
  
  HashNode_p iterator1, iterator2;
  for (int i = 0; i < ht1->size; ++i) {
    if((ht1->table)[i]->first != NULL && (ht2->table)[i]->first != NULL){
      iterator1 = (ht1->table)[i]->first;
      iterator2 = (ht2->table)[i]->first;

      while(iterator1 != NULL && iterator2 != NULL){
        assert(*(int*)iterator1->key == *(int*)iterator2->key);
        iterator1 = iterator1->next;
        iterator2 = iterator2->next;
      }
      assert(iterator1 == NULL && iterator2 == NULL);
    } else {
      assert((ht1->table)[i]->first == NULL && (ht2->table)[i]->first == NULL);
    }
  }
}

void test_hash_table_insert() {

  void* key;
  int* array[11];
  void* replacedRecord;
  array[0] = new_int(8);
  array[1] = new_int(1000045);
  array[2] = new_int(3);
  array[3] = new_int(1000040);
  array[4] = new_int(5);
  array[5] = new_int(12);
  array[6] = new_int(12);
  array[7] = new_int(9);
  array[8] = new_int(11);
  array[9] = new_int(14);
  array[10] = new_int(15);
  
  ht_lib = hash_table_create(1000037);
  
  for(int i=0; i < 11; i++){
    replacedRecord = hash_table_insert(ht_lib, (void*) array[i], sizeof(*array[i]), (void*) array[i], hash_val, compare_int_ptr);
    if (replacedRecord) 
      free(replacedRecord);
  }

  ht_man = hash_table_create_man(array);

  equal_table(ht_lib, ht_man);  
}

void test_hash_table_search() {
  int* record;
  
  record = (int*) hash_table_search(ht_lib, (void*) new_int(1000045), hash_val, compare_int_ptr);
  TEST_ASSERT_TRUE(record);

  record = (int*) hash_table_search(ht_lib, (void*) new_int(3), hash_val, compare_int_ptr);
  TEST_ASSERT_TRUE(record);

  record = (int*) hash_table_search(ht_lib, (void*) new_int(1000), hash_val, compare_int_ptr);
  TEST_ASSERT_TRUE(!record);
}

void test_hash_table_delete() {


  int* record_deleted = (int*) hash_table_delete(ht_lib,  (void*) new_int(3), hash_val, compare_int_ptr); 

  if(record_deleted){
    free(record_deleted);
  }

  ht_man->size = 500018;
  ht_man->recordInserted = 9;

  // remove 3
  free((ht_man->table)[3]->first->next);
  (ht_man->table)[3]->first->next = NULL;

  // move 1000040
  (ht_man->table)[4]->first = (ht_man->table)[3]->first;
  (ht_man->table)[3]->first = NULL;

  // move 1000045
  (ht_man->table)[9]->first->next = (ht_man->table)[8]->first;
  (ht_man->table)[8]->first = (ht_man->table)[8]->first->next;
  (ht_man->table)[9]->first->next->next = NULL;

  equal_table(ht_lib, ht_man); 
}

