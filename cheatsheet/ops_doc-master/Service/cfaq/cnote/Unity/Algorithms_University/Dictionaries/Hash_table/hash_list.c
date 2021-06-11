#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "hash_table.h"


// create a new hash list
HashList_p hash_list_create() {
  HashList_p newlist = (HashList_p) malloc(sizeof(HashList_t));
  newlist->first = NULL;
  return newlist;
}

// create a new hash node
HashNode_p hash_node_create(void* key, unsigned int key_size, void* record) {
  HashNode_p newNode = (HashNode_p) malloc(sizeof(HashNode_t));

  newNode->key = malloc(key_size);
  memcpy(newNode->key, key, key_size);

  newNode->record = record;
  newNode->next = NULL;
  newNode->prev = NULL;

  return newNode;
}

void hash_node_destroy(HashNode_p node){
  if (node){
    if (node->key)
      free(node->key);
    free(node);
  }
}


// insert a node in the hash list
void hash_list_insert(HashList_p list, HashNode_p node) {

  node->prev = NULL;
  node->next = list->first;

  if (list->first)
    list->first->prev = node;

  list->first = node;

}

// search for a node in the hash list
HashNode_p hash_list_search(HashList_p list, void* key, CompFunction compare) {
  HashNode_p item = list->first;

  while (item) {
    if (compare(item->key, key) == 0)
      return item;
    item = item->next;
  }

  return NULL;
}

// remove a node from the hash list
void hash_list_remove_node(HashList_p list, HashNode_p node) {


  if (node->prev)
    node->prev->next = node->next;
  else
    list->first = node->next;

  if (node->next)
    node->next->prev = node->prev;

  node->prev = NULL;
  node->next = NULL;

}

void hash_list_destroy(HashList_p list){
  if (list){
    HashNode_p actual = NULL;
    HashNode_p item = list->first;

    while (item) {
      actual = item;
      item = item->next;
      hash_node_destroy(actual);
    }
    free(list);
  }
}
