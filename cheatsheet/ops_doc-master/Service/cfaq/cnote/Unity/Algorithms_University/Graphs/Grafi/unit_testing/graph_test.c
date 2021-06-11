#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include "float.h"
#include "../graph.h"
#include "../priority_queue.h"
#include "unity.h"


/***********
graph helper
***********/
#define STR_SIZE 64

typedef struct arc {
  char s1[STR_SIZE];
  char s2[STR_SIZE];
  double weight;
} Arc_t, *Arc_p;

Arc_p arrayArc[14];
Graph_p euleriano;


void setUp() {
}

void tearDown() {
}

/***
hash
****/
int hash_string(void* stringKey_p, int arraySize){
  char* stringKey = (char*) stringKey_p;
  int i, strSize = strlen(stringKey);
  unsigned int index = 0;
  for (i = 0; i < strSize; i++){
    index += (unsigned int) stringKey[i] * (strSize+i);
  }
  return index % arraySize;
}

/******
compare
******/
int compare_keys_str(void* key1, void* key2) {
  char* val1 = (char*) key1;
  char* val2 = (char*) key2;

  return strcmp(val1, val2);
}

int compare_keys_float(void* key1, void* key2) {
  double* val1 = (double*) key1;
  double* val2 = (double*) key2;

  if (*val1 < *val2)
    return -1;
  else if (*val1 == *val2)
    return 0;
  else
    return 1;
}


/**************
min walk helper
**************/
void* sumDouble(void* v1, void* v2){
  double* res = (double*) malloc(sizeof(double));
  *res = (*(double*)v1) + (*(double*)v2);
  return (void*) res;
}

double* newDouble(double value) {
  double*  mvalue = (double*) malloc(sizeof(double));
  *mvalue = value;
  return mvalue;
}

void* maxDouble(){
  return (void*) newDouble(DBL_MAX);
}

void* minDouble(){
  return (void*) newDouble(0);
}

void printCityDist(void* city, void* dist){
  printf("%s %lf\n", (char*) city, *(double*) dist);
}

/************
insert helper
************/

Arc_p create_arc(char* s1, char* s2, double weight) {
  Arc_p arc = (Arc_p) malloc(sizeof(Arc_t));
  strncpy(arc->s1, s1, STR_SIZE);
  strncpy(arc->s2, s2, STR_SIZE);
  arc->weight = weight;
  return arc;
}


/**********
Insert test
**********/

void test_graph_insert() {

  arrayArc[0] = create_arc("ancona", "bologna", 4);
  arrayArc[1] = create_arc("ancona", "hone", 8);
  arrayArc[2] = create_arc("bologna", "como", 8);
  arrayArc[3] = create_arc("bologna", "hone", 11);
  arrayArc[4] = create_arc("como", "imola", 2);
  arrayArc[5] = create_arc("hone", "imola", 7);
  arrayArc[6] = create_arc("como", "firenze", 4);
  arrayArc[7] = create_arc("hone", "genova", 1);
  arrayArc[8] = create_arc("genova", "firenze", 2);
  arrayArc[9] = create_arc("como", "domodossola", 7);
  arrayArc[10] = create_arc("domodossola", "firenze", 14);
  arrayArc[11] = create_arc("domodossola", "empoli", 9);
  arrayArc[12] = create_arc("firenze", "empoli", 10);
  arrayArc[13] = create_arc("genova", "imola", 6);


  euleriano = graph_create(NOT_DIRECTED);
  // insert
  for (int i = 0; i < 14; i++){
    graph_insert(euleriano, (void*) arrayArc[i]->s1, (void*) arrayArc[i]->s2, STR_SIZE, (void*) &arrayArc[i]->weight, hash_string, compare_keys_str);
  }

  //graph_print(euleriano); // REMOVE

  // test if all weight are true
  double* weight;
  for (int i = 0; i < 14; i++){
    weight = (double*) graph_weight(euleriano, (void*) arrayArc[i]->s1, (void*) arrayArc[i]->s2, hash_string, compare_keys_str);
    TEST_ASSERT_TRUE(&arrayArc[i]->weight == weight);
  }

  // test if a weight really not exists
  weight = (double*) graph_weight(euleriano, (void*) arrayArc[0]->s1, (void*) arrayArc[2]->s2, hash_string, compare_keys_str);
  TEST_ASSERT_TRUE(weight == NULL);
}


/****************
Minimal walk test
****************/
void test_dijkstra(){
  double* min;

  min = (double*) min_walk(euleriano, (void*) "ancona", (void*) "empoli", STR_SIZE, minDouble, maxDouble, hash_string, compare_keys_str, compare_keys_float, sumDouble, NULL);
  TEST_ASSERT_TRUE(min);
  TEST_ASSERT_TRUE(*min == 21);

  min = (double*) min_walk(euleriano, (void*) "ancona", (void*) "empolix", STR_SIZE, minDouble, maxDouble, hash_string, compare_keys_str, compare_keys_float, sumDouble, NULL);
  TEST_ASSERT_TRUE(min == NULL);
}


/**********************************
Strongly connected components tests
**********************************/
void test_strong_connected(){
  unsigned int num = StrongConnected(euleriano, STR_SIZE, hash_string, compare_keys_str, false);
  TEST_ASSERT_TRUE(num == 1);
}


/*******************
Priority queue tests
*******************/
int compare_keys_val(void* key1, void* key2) {
  int* val1 = (int*) key1;
  int* val2 = (int*) key2;

  return *val1 - *val2;
}

int* newInt(int val){
  int* intp = (int*) malloc(sizeof(int));
  *intp = val;
  return intp;
}

void test_priority_queue() {

  PriorityQueue_p serpente = priority_queue_create(5);

  for (int i=10; i>0; i--){
    min_heap_insert(serpente, newInt(i));
  }

  int min;
  for (int i=1; i<=10; i++){
    min = *(int*) heap_extract_min(serpente, compare_keys_val);
    TEST_ASSERT_TRUE(min == i);
  }

}
