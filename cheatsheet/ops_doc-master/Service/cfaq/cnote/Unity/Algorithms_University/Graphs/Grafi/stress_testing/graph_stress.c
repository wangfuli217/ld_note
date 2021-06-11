#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdbool.h>
#include <unistd.h>
#include "float.h"

#include "../graph.h"
#include "graph_stress.h"
#include "test.h"


/*************
Hash functions
*************/

int hash_string(void* stringKey_p, int arraySize){
  char* stringKey = (char*) stringKey_p;
  int i, strSize = strlen(stringKey);
  unsigned int index = 0;
  for (i = 0; i < strSize; i++){
    index += (unsigned int) stringKey[i] * (strSize+i);
  }
  return index % arraySize;
}


/****************
Compare functions
****************/

int compare_keys_str(void* key1, void* key2) {
  char* val1 = (char*) key1;
  char* val2 = (char*) key2;

  return strcmp(val1, val2);
}

int compare_keys_double(void* key1, void* key2) {
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
Dijkstra helper
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
  if (*(double*) dist != DBL_MAX)
    printf("%s %.2lf km\n", (char*) city, *(double*) dist/1000);
}



/***************
Insert functions
***************/

void test_graph_insert(void* param) {
  void* replacedWeight;
  Entry_p* aEntry = ((Param_p) param)->aEntry;
  size_t asize = ((Param_p) param)->asize;
  Graph_p graph = ((Param_p) param)->graph;

  for(int i = 0; i < asize; i++){
    replacedWeight = graph_insert(graph, (void*) &aEntry[i]->src_city, (void*) &aEntry[i]->dst_city, STR_SIZE, (void*) &aEntry[i]->weight, hash_string, compare_keys_str);
  }

  printf("Inserted vertex: %zu\n", graph->vertex_num);

}

/**************************
Strongly Connected Components
***************************/

void test_strong_connected(void* param){
  Entry_p* aEntry = ((Param_p) param)->aEntry;
  size_t asize = ((Param_p) param)->asize;
  Graph_p graph = ((Param_p) param)->graph;

  StrongConnected(graph, STR_SIZE, hash_string, compare_keys_str, true);
}


/*****************
Shortest walk test
*****************/

void test_shortest_walk(void* param) {
  Entry_p* aEntry = ((Param_p) param)->aEntry;
  size_t asize = ((Param_p) param)->asize;
  Graph_p graph = ((Param_p) param)->graph;
  void* vertex1 = ((Param_p) param)->vertex1;
  void* vertex2 = ((Param_p) param)->vertex2;

  double* length = (double*) min_walk(graph, vertex1, vertex2, STR_SIZE, minDouble, maxDouble, hash_string, compare_keys_str, compare_keys_double, sumDouble, printCityDist);
  if (length) {
    if (*length == DBL_MAX)
      printf("Non c'e' cammino tra %s e %s\n", (char*) vertex1, (char*) vertex2);
    else
      printf("\nDistanza tra %s e %s: %.2lf km\n", (char*) vertex1, (char*) vertex2, *length/1000);
  } else
    printf("%s o %s non esiste\n", (char*) vertex1, (char*) vertex2);
}



bool parseArgs(int argc, char** argv, Param_p param, type* flag) {
  if (argc == 3 && !strcmp(argv[2], "con")){
    *flag = CON;
    param->vertex1 = NULL;
    param->vertex2 = NULL;
  } else if (argc == 5 && !strcmp(argv[2], "min")){
    *flag = MIN;
    param->vertex1 = argv[3];
    param->vertex2 = argv[4];
  } else {
    puts("Wrong pars!");
    return false;
  }

  return true;
}


int main(int argc, char *argv[]) {

  srand(getpid());

  Entry_p* aEntry;
  size_t asize;
  Param_t testParam;
  type flag;

  if (argc > 2){
    if(parseArgs(argc, argv, &testParam, &flag) && loadFile(argv[1], &aEntry, &asize)){

      Graph_p graph = graph_create(NOT_DIRECTED);

      testParam.aEntry = aEntry;
      testParam.asize = asize;
      testParam.graph = graph;

      /***************
      Test insert
      ***************/

      start_tests("Graph insert");
      test_par(test_graph_insert, &testParam);
      end_tests();


      switch (flag) {
        case CON:
          /*********************************
          Test strongly connected components
          *********************************/
          start_tests("Strong connected components");
          test_par(test_strong_connected, &testParam);
          end_tests();
          break;
        case MIN:
          /****************************
          Test min walk from one source
          ****************************/
          start_tests("Shortest walk");
          test_par(test_shortest_walk, &testParam);
          end_tests();
          break;
      }

      graph_destroy(graph);
      for (int i = 0; i<asize; i++)
        free(aEntry[i]);
    }
  } else
    printf("Error with parameters!\nUsage: %s file_path (min city1 city2|con)\n", argv[0]);

  return 0;
}
