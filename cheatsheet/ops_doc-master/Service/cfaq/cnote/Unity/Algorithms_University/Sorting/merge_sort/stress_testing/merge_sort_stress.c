#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdbool.h>

#include "../merge_sort.h"
#include "merge_sort_stress.h"
#include "test.h"
#include "file.h"




int compare_entry_val(void* entry1, void* entry2) {
  int val1 = (((pEntry) entry1)->val);
  int val2 = (((pEntry) entry2)->val);

  return val1 - val2;
}

int compare_entry_str(void* entry1, void* entry2) {
  char* val1 = (((pEntry) entry1)->str);
  char* val2 = (((pEntry) entry2)->str);

  return strcmp(val1, val2);
}

int compare_entry_decimal(void* entry1, void* entry2) {
  float val1 = ((pEntry) entry1)->decimal;
  float val2 = ((pEntry) entry2)->decimal;

  if (val1 < val2)
    return -1;
  else if (val1 == val2)
    return 0;
  else
    return 1;
}



void test_merge_sort_on_file_val(void* param) {
  pEntry* aEntry = ((struct param*) param)->aEntry;
  size_t sizeAEntry = ((struct param*) param)->sizeAEntry;

  merge_sort((void**) aEntry, sizeAEntry, compare_entry_val);

  for(int i=0; i<sizeAEntry-1; ++i) {
    assert(aEntry[i]->val <= aEntry[i+1]->val);
  }

}

void test_merge_sort_on_file_str(void* param) {
  pEntry* aEntry = ((struct param*) param)->aEntry;
  size_t sizeAEntry = ((struct param*) param)->sizeAEntry;

  merge_sort((void**) aEntry, sizeAEntry, compare_entry_str);

  for(int i=0; i<sizeAEntry-1; ++i) {
    assert(strcmp(aEntry[i]->str, aEntry[i+1]->str) <= 0);
  }
}

void test_merge_sort_on_file_dec(void* param) {
  pEntry* aEntry = ((struct param*) param)->aEntry;
  size_t sizeAEntry = ((struct param*) param)->sizeAEntry;

  merge_sort((void**) aEntry, sizeAEntry, compare_entry_decimal);

  for(int i=0; i<sizeAEntry-1; ++i) {
    assert(aEntry[i]->decimal <= aEntry[i+1]->decimal);
  }
}


bool parseArgs(char* opt, TestFunction *test_func) {
  if (!strcmp(opt, "int"))
    *test_func = test_merge_sort_on_file_val;
  else if (!strcmp(opt, "str"))
    *test_func = test_merge_sort_on_file_str;
  else if (!strcmp(opt, "float"))
    *test_func = test_merge_sort_on_file_dec;
  else {
    puts("Wrong pars!");
    return false;
  }
  return true;
}

int main(int argc, char *argv[]) {
  pEntry* aEntry = NULL;
  size_t sizeAEntry = 0;
  TestFunction test_func;

  if (argc == 3){
    if(parseArgs(argv[2], &test_func) && loadFile(argv[1], &aEntry, &sizeAEntry)){

      struct param testParam;
      testParam.aEntry = aEntry;
      testParam.sizeAEntry = sizeAEntry;

      start_tests("merge sort");
      test_par(test_func, &testParam);
      end_tests();

      for (int i = 0; i<sizeAEntry; i++)
        free(aEntry[i]);
    }

  } else
    printf("Missing parameters!\nUsage: %s file_path (int|str|float)\n", argv[0]);

  return 0;
}
