#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>

#include "../hash_table.h"
#include "hash_stress.h"
#include "test.h"

/*
void print_hash_table(hash_table hshtb){
  Node* iterator;
  printf("size_table: %d\n", size_table);
  for(int i=0; i<size_table; i++){
    if(hshtb[i]->first == NULL){
      printf("hash_table[%d]:NULL\n", i);
    } else {
      printf("hash_table[%d]: ", i);
      iterator = hshtb[i]->first;
      while(iterator!=NULL){
        printf("%d ", *(int*)iterator->key);
        iterator = iterator->next;
      }
      printf("\n");
    }
  }
}
*/

/*************
Hash functions
*************/

int hash_val(void* valKey, int arraySize){
  int intKey = *(int*) valKey;
  return intKey % arraySize;
}

int hash_string(void* stringKey_p, int arraySize){
  char* stringKey = (char*) stringKey_p;
  int i, strSize = strlen(stringKey);
  unsigned int index = 0;
  for (i = 0; i < strSize; i++){
    index += (unsigned int) stringKey[i] * (strSize+i);
  }
  return index % arraySize;
}

int hash_dec(void* deckey, int arraySize){
  float floatKey = *(float*) deckey;
  return ((int) (floatKey*1000) % arraySize);
}


/****************
Compare functions
****************/

int compare_keys_val(void* entry1, void* entry2) {
  int* val1 = (int*) entry1;
  int* val2 = (int*) entry1;

  return *val1 - *val2;
}

int compare_keys_str(void* key1, void* key2) {
  char* val1 = (char*) key1;
  char* val2 = (char*) key2;

  return strcmp(val1, val2);
}

int compare_keys_dec(void* key1, void* key2) {
  float* val1 = (float*) key1;
  float* val2 = (float*) key2;

  if (*val1 < *val2)
    return -1;
  else if (*val1 == *val2)
    return 0;
  else
    return 1;
}

/********/

void print_statistics(HashTable_p hash_table){
  int y=0;
  for(int i = 0; i < hash_table->size; i++){
    if((hash_table->table)[i]->first!=NULL){
      y++;
    }
  }
  printf("\nliste utilizzate: %d\nDimensine tableea: %d\n", y, hash_table->size);
}



/***************
Insert functions
***************/

void test_hash_table_insert(void* param) {
  void* replacedRecord;
  int i;
  Entry_p* aEntry = ((struct param*) param)->aEntry;
  size_t asize = ((struct param*) param)->asize;
  HashTable_p hash_table = ((struct param*) param)->hash_table;
  type val = ((struct param*) param)->val;

  for(i = 0; i < asize; i++){

    switch (val) {
      case INT:
        replacedRecord = hash_table_insert(hash_table, (void*) &aEntry[i]->val, sizeof(aEntry[i]->val), (void*) aEntry[i], hash_val, compare_keys_val);
        break;
      case STR:
        replacedRecord = hash_table_insert(hash_table, (void*) &aEntry[i]->str, sizeof(aEntry[i]->str), (void*) aEntry[i], hash_string, compare_keys_str);
        break;
      case FLOAT:
        replacedRecord = hash_table_insert(hash_table, (void*) &aEntry[i]->dec, sizeof(aEntry[i]->dec), (void*) aEntry[i], hash_dec, compare_keys_dec);
        break;
    }
  }
  //print_hash_table(*hshtb);
  //print_statistics(hash_table);

}



/***************
Search functions
***************/

void test_hash_table_ricerca(void* param) {
  int i, casual;
  void* foundRecord;
  Entry_p* aEntry = ((struct param*) param)->aEntry;
  size_t asize = ((struct param*) param)->asize;
  HashTable_p hash_table = ((struct param*) param)->hash_table;
  type val = ((struct param*) param)->val;

  for(i = 0; i < 1000000; i++){
    casual = rand() % asize;
    switch (val) {
      case INT:
        foundRecord = hash_table_search(hash_table, (void*) &aEntry[casual]->val, hash_val, compare_keys_val);
        break;
      case STR:
        foundRecord = hash_table_search(hash_table, (void*) &aEntry[casual]->str, hash_string, compare_keys_str);
        break;
      case FLOAT:
        foundRecord = hash_table_search(hash_table, (void*) &aEntry[casual]->dec, hash_dec, compare_keys_dec);
        break;
    }
  }
}



/***************
Delete functions
***************/

void test_hash_table_delete(void* param) {
  int i, casual;
  void* deletedRecord;
  Entry_p* aEntry = ((struct param*) param)->aEntry;
  size_t asize = ((struct param*) param)->asize;
  HashTable_p hash_table = ((struct param*) param)->hash_table;
  type val = ((struct param*) param)->val;

  for(i = 0; i < 1000000; i++){
    casual = rand() % (asize-1);
    switch (val) {
      case INT:
        deletedRecord = hash_table_delete(hash_table, (void*) &aEntry[casual]->val, hash_val, compare_keys_val);
        break;
      case STR:
        deletedRecord = hash_table_delete(hash_table, (void*) &aEntry[casual]->str, hash_string, compare_keys_str);
        break;
      case FLOAT:
        deletedRecord = hash_table_delete(hash_table, (void*) &aEntry[casual]->dec, hash_dec, compare_keys_dec);
        break;
    }
    //if (deletedRecord)
    //  free(deletedRecord);
  }

  //print_statistics(hash_table);
}


bool parseArgs(char* opt, type* val) {
  if (!strcmp(opt, "int")){
    *val = INT;
  } else if (!strcmp(opt, "str")){
    *val = STR;
  } else if (!strcmp(opt, "float")){
    *val = FLOAT;
  } else {
    puts("Wrong pars!");
    return false;
  }

  return true;
}

int main(int argc, char *argv[]) {

  srand(getpid());

  type val;
  Entry_p* aEntry;
  size_t asize;

  if (argc == 3){
    if(parseArgs(argv[2], &val) && loadFile(argv[1], &aEntry, &asize)){

      HashTable_p hash_table = hash_table_create(401);
      struct param testParam;
      testParam.aEntry = aEntry;
      testParam.asize = asize;
      testParam.hash_table = hash_table;
      testParam.val = val;

      /***************
      Test inserimento
      ***************/

      start_tests("insert");
      test_par(test_hash_table_insert, &testParam);
      end_tests();

      printf("%d\n", hash_table->recordInserted);

      /***********
      Test ricerca
      ***********/

      start_tests("ricerca");
      test_par(test_hash_table_ricerca, &testParam);
      end_tests();

      /*****************
      Test cancellazione
      *****************/

      start_tests("delete");
      test_par(test_hash_table_delete, &testParam);
      end_tests();

      hash_table_destroy(hash_table);
      for (int i = 0; i<asize; i++)
        free(aEntry[i]);
    }
  } else
    printf("Missing parameters!\nUsage: %s file_path (int|str|float)\n", argv[0]);

  return 0;
}
