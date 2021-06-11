#ifndef __GRAPH_H_1234__
#define __GRAPH_H_1234__
#include <stdbool.h>

#include "../../Esercizio_2/Hash_table/hash_table.h"
#include "priority_queue.h"

typedef enum {NOT_DIRECTED=0, DIRECTED} Gtype;

typedef struct graph {
  HashTable_p vertex_table;
  Gtype type;
  size_t vertex_num;
} Graph_t, *Graph_p;

Graph_p graph_create(Gtype type);
void* graph_insert(Graph_p graph, void* src_vertex, void* dst_vertex, size_t vertex_size, void* weight, HashFunction hashing, CompFunction compare);
void* graph_insert_arc(Graph_p graph, void* src_vertex, void* dst_vertex, size_t vertex_size, void* weight, HashFunction hashing, CompFunction compare);
void* graph_weight(Graph_p graph, void* src_vertex, void* dst_vertex, HashFunction hashing, CompFunction compare);
void graph_print(Graph_p graph);
void graph_destroy(Graph_p graph);





/**************************
Strong connected components
**************************/

typedef enum {WHITE=0, GRAY, BLACK} ColorType;

typedef struct _DFSNode {
  void* vertex;
  struct _DFSNode* parent;
  ColorType color;
  size_t discovered;
  size_t finished;
} DFSNode_t, *DFSNode_p;

unsigned int  StrongConnected(Graph_p graph, size_t vertex_size, HashFunction hashing, CompFunction compareVertex, bool print);
void printStrong(HashTable_p strongHT);
size_t* newCounter(size_t value);
void initDfs(Graph_p graph, HashTable_p* dfsHT, size_t vertex_size, HashFunction hashing, CompFunction compareVertex);
void dfs(Graph_p graph, HashTable_p dfsHT, HashFunction hashing, CompFunction compareVertex);
void dfsVisit(Graph_p graph, HashTable_p dfsHT, DFSNode_p dfsNode, size_t *dfsTime, HashFunction hashing, CompFunction compareVertex);





/******
Dijkstra
******/
typedef struct _WalkNode {
  void* vertex;
  void* parent;
  void* dist;
} WalkNode_t, *WalkNode_p;

typedef void* (*MaxMinFunc)();
typedef void* (*SumFunction)(void*, void*);
typedef void (*PrintFunc)(void*, void*);


void* min_walk(Graph_p graph, void* src_vertex, void* dst_vertex, size_t vertex_size, MaxMinFunc minDist, MaxMinFunc maxDist, HashFunction hashing, CompFunction compareVertex, CompFunction compareDist, SumFunction sum, PrintFunc print_vertex_dist);
void print_walk(HashTable_p distHT, void* dst_vertex, HashFunction hashing, CompFunction compareVertex, PrintFunc print_vertex_dist);
void init_single_source(Graph_p graph, HashTable_p* distHT, PriorityQueue_p* distPQ, void* src_vertex, size_t vertex_size, MaxMinFunc minDist, MaxMinFunc maxDist, HashFunction hashing, CompFunction compare);
int compare_wn(void* e1, void* e2);
void dijkstra(Graph_p graph, HashTable_p* distHT, PriorityQueue_p* distPQ, HashFunction hashing, CompFunction compareVertex, CompFunction compareDist, SumFunction sum);
void relax(WalkNode_p wn, WalkNode_p adj_wn, void* weight, CompFunction compareDist, SumFunction sum);

#endif
