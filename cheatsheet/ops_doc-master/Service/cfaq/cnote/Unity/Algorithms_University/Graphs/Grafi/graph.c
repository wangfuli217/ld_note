#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "graph.h"

// create an empty graph
Graph_p graph_create(Gtype type){
  Graph_p newGraph = (Graph_p) malloc(sizeof(Graph_t));
  newGraph->vertex_table = hash_table_create(401);
  newGraph->type = type;
  newGraph->vertex_num = 0;
  return newGraph;
}

// free the memory of the graph
void graph_destroy(Graph_p graph){
  if (graph){
    HashTable_p ext_table = graph->vertex_table;
    HashList_p* ext_item = ext_table->table;

    for (int i = 0; i < ext_table->size; i++){
      HashNode_p ext_node =  ext_item[i]->first;
      while (ext_node) {
        //each node of the hash table contains hash table
        hash_table_destroy(ext_node->record);
        ext_node = ext_node->next;
      }
    }

    hash_table_destroy(graph->vertex_table);
    free(graph);
  }
}

//insert a new arc inside the graph (if the graph is not oriented, insert the arc in the opposite direction too)
void* graph_insert(Graph_p graph, void* src_vertex, void* dst_vertex, size_t vertex_size, void* weight, HashFunction hashing, CompFunction compare){

  void* replacedWeight = graph_insert_arc(graph, src_vertex, dst_vertex, vertex_size, weight, hashing, compare);
  if (graph->type == NOT_DIRECTED) // if the graph is not oriented, insert the arc in the opposite direction too
    graph_insert_arc(graph, dst_vertex, src_vertex, vertex_size, weight, hashing, compare);
  else // if the graph is oriented, make sure that dest vertex is present in source list
    graph_insert_arc(graph, dst_vertex, NULL, vertex_size, weight, hashing, compare);

  return replacedWeight;
}


// insert the arc (src_vertex in source list and dst_vertex in its adjacent list)
void* graph_insert_arc(Graph_p graph, void* src_vertex, void* dst_vertex, size_t vertex_size, void* weight, HashFunction hashing, CompFunction compare){
  HashTable_p adj_table;
  adj_table = (HashTable_p) hash_table_search(graph->vertex_table, src_vertex, hashing, compare);

  // control if the vertex is already present, if not we insert it and initialize its adjacent list
  if (adj_table == NULL){
    hash_table_insert(graph->vertex_table, src_vertex, vertex_size, hash_table_create(401), hashing, compare);
    adj_table = (HashTable_p) hash_table_search(graph->vertex_table, src_vertex, hashing, compare);
    graph->vertex_num++;
  }

  // if a dst vertex was passed we insert it in src vertex adjacent list and return the replaced weight if there were a identic dst vertex in that list
  if (dst_vertex)
    return hash_table_insert(adj_table, dst_vertex, vertex_size, weight, hashing, compare);
  else
    return NULL;
}


// returns the weight of an arc between two given vertex
void* graph_weight(Graph_p graph, void* src_vertex, void* dst_vertex, HashFunction hashing, CompFunction compare) {
  void* weight = NULL;
  HashTable_p adj_table = (HashTable_p) hash_table_search(graph->vertex_table, src_vertex, hashing, compare);
  if (adj_table) {
    weight = hash_table_search(adj_table, dst_vertex, hashing, compare);
  }
  return weight;
}

void graph_print(Graph_p graph) {
  HashTable_p ext_table = graph->vertex_table;
  HashList_p* ext_item = ext_table->table;
  for (int i = 0; i < ext_table->size; i++){
    HashNode_p ext_node =  ext_item[i]->first;

    while (ext_node) {
      printf("Src: %s\n", (char*) ext_node->key);

      HashTable_p int_table = (HashTable_p) ext_node->record;
      HashList_p* int_item = int_table->table;
      for (int j = 0; j < int_table->size; j++){
        HashNode_p int_node =  int_item[j]->first;
        while (int_node) {
          printf("\tDst: %s, %lf\n", (char*) int_node->key, *(double*) int_node->record);
          int_node = int_node->next;
        }
      }

      ext_node = ext_node->next;
    }
  }
}

void remove_record_hash_table_destroy(HashTable_p hash_table){
  if (hash_table){
    HashList_p* ext_item = hash_table->table;

    for (int i = 0; i < hash_table->size; i++){
      HashNode_p ext_node =  ext_item[i]->first;
      while (ext_node) {
        if (ext_node->record)
          free(ext_node->record);
        ext_node = ext_node->next;
      }
    }

    hash_table_destroy(hash_table);
  }
}

/**************************
Strong connected components
**************************/

unsigned int StrongConnected(Graph_p graph, size_t vertex_size, HashFunction hashing, CompFunction compareVertex, bool print) {
  HashTable_p dfsHT;
  initDfs(graph, &dfsHT, vertex_size, hashing, compareVertex);
  dfs(graph, dfsHT, hashing, compareVertex);

  DFSNode_p dfsNode;
  HashTable_p strongHT = hash_table_create(401);
  HashList_p* hash_list = dfsHT->table;
  for (int i = 0; i < dfsHT->size; i++){
    HashNode_p hash_node =  hash_list[i]->first;
    while (hash_node) {

      // take a dfsnode from dfsHT
      dfsNode = (DFSNode_p) hash_node->record;

      while(dfsNode->parent) // go to the root
        dfsNode = dfsNode->parent;

      // search if this parent is already in strongHT
      size_t* counterComponent = (size_t*) hash_table_search(strongHT, dfsNode->vertex, hashing, compareVertex);

      if (counterComponent) // if is alraeady present we increment the number of components
        (*counterComponent)++;
      else                  // otherwise we insert the parent with value 1
        hash_table_insert(strongHT, dfsNode->vertex, vertex_size, (void*) newCounter(1), hashing, compareVertex);

      hash_node = hash_node->next;
    }
  }

  if (print)
    printStrong(strongHT);

  unsigned int numSCC = strongHT->recordInserted;
  remove_record_hash_table_destroy(strongHT);
  remove_record_hash_table_destroy(dfsHT);

  return numSCC;
}

// prints strongly connected components
void printStrong(HashTable_p strongHT){
  HashList_p* hash_list = strongHT->table;
  for (int i = 0; i < strongHT->size; i++){
    HashNode_p hash_node =  hash_list[i]->first;
    while (hash_node) {

      printf("Component size: %zu\n", *(size_t*) hash_node->record);

      hash_node = hash_node->next;
    }
  }
  printf("Number of strongly connected components: %u\n", strongHT->recordInserted);
}

// allocate a new couter for strongly connected components
size_t* newCounter(size_t value) {
  size_t*  mvalue = (size_t*) malloc(sizeof(size_t));
  *mvalue = value;
  return mvalue;
}

// initialize depth first search hash table for all vertex with parent to null and color to white
void initDfs(Graph_p graph, HashTable_p* dfsHT, size_t vertex_size, HashFunction hashing, CompFunction compareVertex) {
  HashTable_p TMPdfsHT = hash_table_create(401);

  DFSNode_p dfsNode;
  HashTable_p ext_table = graph->vertex_table;
  HashList_p* ext_item = ext_table->table;
  for (int i = 0; i < ext_table->size; i++){
    HashNode_p ext_node =  ext_item[i]->first;

    while (ext_node) {
      //printf("Src: %s\n", (char*) ext_node->key);

      dfsNode = (DFSNode_p) malloc(sizeof(DFSNode_t));
      dfsNode->vertex = ext_node->key;
      dfsNode->parent = NULL;
      dfsNode->color = WHITE;
      dfsNode->discovered = 0;
      dfsNode->finished = 0;

      hash_table_insert(TMPdfsHT, ext_node->key, vertex_size, (void*) dfsNode, hashing, compareVertex);

      ext_node = ext_node->next;
    }
  }


  *dfsHT = TMPdfsHT;
}

// Depth First Search implementation
void dfs(Graph_p graph, HashTable_p dfsHT, HashFunction hashing, CompFunction compareVertex){
  size_t dfsTime = 0;

  // scan all the dfs hash table and call dfs visit on each vertex if it is still white
  DFSNode_p dfsNode;
  HashList_p* dfs_item = dfsHT->table;
  for (int i = 0; i < dfsHT->size; i++){
    HashNode_p hash_node =  dfs_item[i]->first;

    while (hash_node) {
      dfsNode = (DFSNode_p) hash_node->record;
      if (dfsNode->color == WHITE){
        dfsVisit(graph, dfsHT, dfsNode, &dfsTime, hashing, compareVertex);
      }
      hash_node = hash_node->next;
    }
  }

}

// visit the vertex
void dfsVisit(Graph_p graph, HashTable_p dfsHT, DFSNode_p dfsNode, size_t *dfsTime, HashFunction hashing, CompFunction compareVertex){
  (*dfsTime)++;
  dfsNode->discovered = *dfsTime;
  dfsNode->color = GRAY;

  // gets the adjacent hash table of visited vertex
  HashTable_p adj_table = (HashTable_p) hash_table_search(graph->vertex_table, dfsNode->vertex, hashing, compareVertex);
  HashList_p* adj_item = adj_table->table;

  // scan all the adjacent hash table
  for (int j = 0; j < adj_table->size; j++){
    HashNode_p adj_node =  adj_item[j]->first;
    while (adj_node) {

      // gets the dfs info of adjacent vertex
      DFSNode_p adjDfs = (DFSNode_p) hash_table_search(dfsHT, adj_node->key, hashing, compareVertex);

      // if the adjacent vertex is white, set its parent and call recoursively the visit on adjacent itself
      if (adjDfs->color == WHITE){
        adjDfs->parent = dfsNode;
        dfsVisit(graph, dfsHT, adjDfs, dfsTime, hashing, compareVertex);
      }
      adj_node = adj_node->next;
    }
  }

  dfsNode->color = BLACK;
  (*dfsTime)++;
  dfsNode->finished = *dfsTime;
}


/*******
Dijkstra
*******/
int (*ExternCompare)(void*, void*) = NULL; // needed to compare walking node from priority queue

// start dijkstra algorithm
void* min_walk(Graph_p graph, void* src_vertex, void* dst_vertex, size_t vertex_size, MaxMinFunc minDist, MaxMinFunc maxDist, HashFunction hashing, CompFunction compareVertex, CompFunction compareDist, SumFunction sum, PrintFunc print_vertex_dist) {

  ExternCompare = compareDist;
  HashTable_p distHT;
  PriorityQueue_p distPQ;

  // controls if both vertexes exist
  if (hash_table_search(graph->vertex_table, src_vertex, hashing, compareVertex) && hash_table_search(graph->vertex_table, dst_vertex, hashing, compareVertex)){

    init_single_source(graph, &distHT, &distPQ, src_vertex, vertex_size, minDist, maxDist, hashing, compareVertex);

    dijkstra(graph, &distHT, &distPQ, hashing, compareVertex, compareDist, sum);

    if (print_vertex_dist)
      print_walk(distHT, dst_vertex, hashing, compareVertex, print_vertex_dist);

    WalkNode_t wn = *(WalkNode_p) hash_table_search(distHT, dst_vertex, hashing, compareVertex);
    remove_record_hash_table_destroy(distHT);
    priority_queue_destroy(distPQ);

    return wn.dist;

  } else
    return NULL;

}

// prints the path from source to given dest
void print_walk(HashTable_p distHT, void* dst_vertex, HashFunction hashing, CompFunction compareVertex, PrintFunc print_vertex_dist) {
  WalkNode_p wn = hash_table_search(distHT, dst_vertex, hashing, compareVertex);
  if (wn->parent){
    print_walk(distHT, wn->parent, hashing, compareVertex, print_vertex_dist);
  }
  print_vertex_dist(wn->vertex, wn->dist);
}

// initialize dijkstra hash table and priority queue for all vertex with parent to null and dist from source to "infinity"
void init_single_source(Graph_p graph, HashTable_p* distHT, PriorityQueue_p* distPQ, void* src_vertex, size_t vertex_size, MaxMinFunc minDist, MaxMinFunc maxDist, HashFunction hashing, CompFunction compare) {
  HashTable_p TMPdistHT = hash_table_create(401);
  PriorityQueue_p TMPdistPQ = priority_queue_create(graph->vertex_num);

  WalkNode_p wn;
  HashTable_p ext_table = graph->vertex_table;
  HashList_p* ext_item = ext_table->table;
  for (int i = 0; i < ext_table->size; i++){
    HashNode_p ext_node =  ext_item[i]->first;

    while (ext_node) {

      wn = (WalkNode_p) malloc(sizeof(WalkNode_t));
      wn->vertex = ext_node->key;
      wn->parent = NULL;
      wn->dist = maxDist();

      hash_table_insert(TMPdistHT, ext_node->key, vertex_size, (void*) wn, hashing, compare);
      min_heap_insert(TMPdistPQ, wn);

      ext_node = ext_node->next;
    }
  }

  wn = (WalkNode_p) hash_table_search(TMPdistHT, src_vertex, hashing, compare);
  wn->dist = minDist();

  *distHT = TMPdistHT;
  *distPQ = TMPdistPQ;
}


// compare two given walking node on their dist (used by priority queue)
int compare_wn(void* e1, void* e2){
  WalkNode_p wn1 = (WalkNode_p) e1;
  WalkNode_p wn2 = (WalkNode_p) e2;
  return ExternCompare(wn1->dist, wn2->dist);
}

// dijkstra algorithm implementation
void dijkstra(Graph_p graph, HashTable_p* distHT, PriorityQueue_p* distPQ, HashFunction hashing, CompFunction compareVertex, CompFunction compareDist, SumFunction sum) {
  WalkNode_p wn, adj_wn;
  // extract the vertex with min dist from priority queue
  while( (wn = heap_extract_min(*distPQ, compare_wn)) ) {
    void *main_vertex, *adj_vertex;
    main_vertex = wn->vertex;

    // get the adjacent hash table of vertex extracted from priority queue
    HashTable_p adj_table = (HashTable_p) hash_table_search(graph->vertex_table, main_vertex, hashing, compareVertex);

    for (int j = 0; j < adj_table->size; j++){
      HashNode_p int_node = adj_table->table[j]->first;
      while (int_node) {
        // for each adjacent get dist info from dist hash table
        adj_wn = (WalkNode_p) hash_table_search(*distHT, int_node->key, hashing, compareVertex);

        // get the weight of vertex extracted from priority queue and its adjacent vertex
        void* weight = graph_weight(graph, wn->vertex, adj_wn->vertex, hashing, compareVertex);
        // call relax on vertex extracted from priority queue and its adjacent vertex
        relax(wn, adj_wn, weight, compareDist, sum);
        int_node = int_node->next;
      }
    }
  }
}

// relax a dist of an adjacent vertex if the dist of vertex extracted from priority queue plus their arc weight is minor
void relax(WalkNode_p wn, WalkNode_p adj_wn, void* weight, CompFunction compareDist, SumFunction sum){
  // sum the dist of vertex extracted from priority queue and the weight between it and his adjacent
  void* main_dist_plus_walk = sum(wn->dist, weight);
  // if the sum is lower than present dist of adjacent vertex, override it with sum
  if (compareDist(adj_wn->dist, main_dist_plus_walk) > 0){
    free(adj_wn->dist);
    adj_wn->dist = main_dist_plus_walk;
    adj_wn->parent = wn->vertex;
  } else {
    free(main_dist_plus_walk);
  }
}
