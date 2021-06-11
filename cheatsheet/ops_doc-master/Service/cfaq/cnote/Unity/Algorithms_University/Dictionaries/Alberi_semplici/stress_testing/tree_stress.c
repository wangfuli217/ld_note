#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>

#include "../alberi_semplici.h"
#include "tree_stress.h"
#include "test.h"
#include "file.h"



/****************
Compare functions
****************/

int compare_entry_val(void* key1, void* key2) {
  int val1 = *(int*) key1;
  int val2 = *(int*) key2;

  return val1 - val2;
}

int compare_entry_str(void* key1, void* key2) {
  char* val1 = (char*) key1;
  char* val2 = (char*) key2;

  return strcmp(val1, val2);
}

int compare_entry_dec(void* key1, void* key2) {
  float val1 = *(float*) key1;
  float val2 = *(float*) key2;

  if (val1 < val2)
    return -1;
  else if (val1 == val2)
    return 0;
  else
    return 1;
}


/***************
Insert functions
***************/

void test_alberi_semplici_insert(void* param) {

  pEntry* aEntry = ((struct param*) param)->aEntry;
  size_t asize = ((struct param*) param)->asize;
  tree* pesco = ((struct param*) param)->albero;
  type val = ((struct param*) param)->val;

  void* replacedRecord;
  int i;
  for(i = 0; i < asize; i++){
    switch (val) {
      case INT:
        replacedRecord = tree_insert(pesco, (void*) &aEntry[i]->val, sizeof(aEntry[i]->val), (void*) aEntry[i], compare_entry_val);
        break;
      case STR:
        replacedRecord = tree_insert(pesco, (void*) &aEntry[i]->str, sizeof(aEntry[i]->str), (void*) aEntry[i], compare_entry_str);
        break;
      case FLOAT:
        replacedRecord = tree_insert(pesco, (void*) &aEntry[i]->dec, sizeof(aEntry[i]->dec), (void*) aEntry[i], compare_entry_dec);
        break;
    }
    //if (replacedRecord)
    //  free(replacedRecord);
  }

}



/***************
Search functions
***************/

void test_alberi_semplici_ricerca(void* param) {

  pEntry* aEntry = ((struct param*) param)->aEntry;
  size_t asize = ((struct param*) param)->asize;
  tree* pesco = ((struct param*) param)->albero;
  type val = ((struct param*) param)->val;

  void* foundRecord;
  int i;
  for(i = 0; i < 1000000; i++){
    int casual = rand() % asize;
    switch (val) {
      case INT:
        foundRecord = tree_search(pesco, (void*) &aEntry[casual]->val, compare_entry_val);
        break;
      case STR:
        foundRecord = tree_search(pesco, (void*) &aEntry[casual]->str, compare_entry_str);
        break;
      case FLOAT:
        foundRecord = tree_search(pesco, (void*) &aEntry[casual]->dec, compare_entry_dec);
        break;
    }
  }

}


/***************
Delete functions
***************/

void test_alberi_semplici_delete(void* param) {

  pEntry* aEntry = ((struct param*) param)->aEntry;
  size_t asize = ((struct param*) param)->asize;
  tree* pesco = ((struct param*) param)->albero;
  type val = ((struct param*) param)->val;

  void* removedRecord;
  int i;
  for(i = 0; i < 1000000; i++){
    int casual = rand() % asize;
    switch (val) {
      case INT:
        removedRecord = tree_delete(pesco, (void*) &aEntry[casual]->val, compare_entry_val);
        break;
      case STR:
        removedRecord = tree_delete(pesco, (void*) &aEntry[casual]->str, compare_entry_str);
        break;
      case FLOAT:
        removedRecord = tree_delete(pesco, (void*) &aEntry[casual]->dec, compare_entry_dec);
        break;
    }
  }

}



//TODO

bool parseArgs(char* opt, type* val) {
  if (!strcmp(opt, "int")){
    *val = INT;
  } else if (!strcmp(opt, "str")){
    *val = STR;
  } else if (!strcmp(opt, "float")){
    *val = FLOAT;
  } else {
    puts("Wrong params!");
    return false;
  }

  return true;
}

int main(int argc, char *argv[]) {

  srand(getpid());

  type val;
  pEntry* aEntry;
  size_t asize;

  if (argc == 3){
    if(parseArgs(argv[2], &val) && loadFile(argv[1], &aEntry, &asize)){


      tree pesco = NULL;
      struct param testParam;
      testParam.aEntry = aEntry;
      testParam.asize = asize;
      testParam.albero = &pesco;
      testParam.val = val;


      /***************
      Test inserimento
      ***************/

      start_tests("insert");
      test_par(test_alberi_semplici_insert, &testParam);
      end_tests();

      //print_tree(pesco);

      /***********
      Test ricerca
      ***********/

      start_tests("search");
      test_par(test_alberi_semplici_ricerca, &testParam);
      end_tests();


      /*****************
      Test cancellazione
      *****************/

      start_tests("delete");
      test_par(test_alberi_semplici_delete, &testParam);
      end_tests();

      tree_destroy(pesco);
      for (int i = 0; i<asize; i++)
        free(aEntry[i]);
    }
  } else
    printf("Missing parameters!\nUsage: %s file_path (int|str|float)\n", argv[0]);

  return 0;
}
