#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include "../alberi_semplici.h"
#include "unity.h"

void setUp() {
}

void tearDown() {
}

// HELPER FUNCTIONS
tree pesco = NULL;

tree pero[12];

int compare_int_ptr(void* ptr1, void* ptr2) {
  int i1 =  *(int*)ptr1;
  int i2 =  *(int*)ptr2;
  if(i1<i2) {
    return -1;
  }

  if(i1==i2) {
    return 0;
  }

  return 1;
}

void equal_tree(tree pero, tree pesco){
  if(pero->left != NULL && pesco->left != NULL){
    TEST_ASSERT_TRUE(*(int*)pero->left->key == *(int*)pesco->left->key);
    equal_tree(pero->left, pesco->left);
  } else {
    TEST_ASSERT_TRUE(pero->left == NULL && pesco->left == NULL);
  }

  if(pero->right != NULL && pesco->right != NULL) {
    TEST_ASSERT_TRUE(*(int*)pero->right->key == *(int*)pesco->right->key);
    equal_tree(pero->right, pesco->right);
  } else {
    TEST_ASSERT_TRUE(pero->right == NULL && pesco->right == NULL);
  }
}

void insert_pesco(tree* pesco, int * array[]){
  for (int i=0; i<12; i++){
    void* replacedRecord = tree_insert(pesco, (void*) array[i], sizeof(*array[i]), (void*) array[i], compare_int_ptr);
    if (replacedRecord)
      free(replacedRecord);
  }
}

void create_pero(tree pero[], int * array[]){

  for(int i=0; i<12; i++) {
    pero[i] = make_node((void*)array[i], sizeof(array[i]), (void*) array[i]);
  }

  pero[0]->left = pero[1];
  pero[0]->right = pero[5];
  pero[1]->left = pero[2];
  pero[1]->right = pero[3];
  pero[2]->left = NULL;
  pero[2]->right = NULL;
  pero[3]->left = pero[4];
  pero[3]->right = NULL;
  pero[4]->left = NULL;
  pero[4]->right = NULL;
  pero[5]->left = pero[6];
  pero[5]->right = pero[9];
  pero[6]->left = pero[7];
  pero[6]->right = pero[8];
  pero[7]->left = NULL;
  pero[7]->right = NULL;
  pero[8]->left = NULL;
  pero[8]->right = NULL;
  pero[9]->left = pero[10];
  pero[9]->right = pero[11];
  pero[10]->left = NULL;
  pero[10]->right = NULL;
  pero[11]->left = NULL;
  pero[11]->right = NULL;

}

int* new_int(int value) {
  int* result = (int*) malloc(sizeof(int));
  *result = value;
  return result;
}

void test_tree_insert() {
  int* array[12];
  array[0] = new_int(8);
  array[1] = new_int(4);
  array[2] = new_int(3);
  array[3] = new_int(6);
  array[4] = new_int(5);
  array[5] = new_int(12);
  array[6] = new_int(10);
  array[7] = new_int(9);
  array[8] = new_int(11);
  array[9] = new_int(18);
  array[10] = new_int(15);
  array[11] = new_int(19);

  create_pero(pero, array);

  insert_pesco(&pesco, array);

  equal_tree(pero[0], pesco);
}

void test_tree_search() {
  int* record = (int*) tree_search(&pesco, new_int(100), compare_int_ptr);
  TEST_ASSERT_TRUE(!record);

  record = (int*) tree_search(&pesco, new_int(8), compare_int_ptr);
  TEST_ASSERT_TRUE(record);
}

void test_tree_delete() {
  int* recordDeleted = (int*) tree_delete(&pesco, new_int(8), compare_int_ptr);

  if(recordDeleted)
    free(recordDeleted);

  pero[7]->left = pero[1];
  pero[7]->right = pero[5];
  pero[6]->left = NULL;
  free(pero[0]);
  equal_tree(pero[0], pesco);
}
