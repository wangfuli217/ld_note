#ifndef __TREE_H_KEIXJ4PDU3__
#define __TREE_H_KEIXJ4PDU3__

typedef int (*CompFunction)(void*, void*);

typedef struct _node* tree;
typedef struct _node {
  void* key;
  void* record;
  struct _node* left;
  struct _node* right;
} node;


node* make_node(void* key, unsigned int key_size, void* record);
void* tree_insert(tree* root, void* key, unsigned int key_size, void* record, CompFunction compare);
void* tree_search(tree* root, void* key, CompFunction compare);
void* tree_delete(tree* root, void* key, CompFunction compare);
void tree_destroy(tree root);

#endif
