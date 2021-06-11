#include "alberi_semplici.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//create a node
node* make_node(void* key, unsigned int key_size, void* record){
  node* newNode = (node*) malloc(sizeof(struct _node));
  newNode->key = malloc(key_size);
  memcpy(newNode->key, key, key_size); // malloc della key (passare la dimensione della key)
  newNode->record = record;
  newNode->left = NULL;
  newNode->right = NULL;
  return newNode;
}

//replace node
void node_replace(tree* root, node* father, node* son, node* newSon){

  if (father != NULL) {
    if (father->left == son){
      father->left = newSon;
    } else if (father->right == son){
      father->right = newSon;
    }
  } else {
    *root = newSon; // the node to remove is the root
  }
}

//insert a record in the binary tree
void* tree_insert(tree* root, void* key, unsigned int key_size, void* record, CompFunction compare){

  node* father = NULL;
  node* item = *root;
  int comp;

  //scan the tree
  while(item) {
    father = item;
    comp = compare(key, item->key);

    if (comp < 0)
      item = item->left;
    else if (comp > 0)
      item = item->right;
    else {                            //the key is already present in this case we replace the record
      void* oldRecord = item->record;
      item->record = record;
      return oldRecord;
    }
  }

  node* newNode = make_node(key, key_size, record);

  if (father == NULL)
    *root = newNode;
  else {
    if (comp < 0)
      father->left = newNode;
    else
      father->right = newNode;
  }

  return NULL;
}

//search a record in the tree
void* tree_search(tree* root, void* key, CompFunction compare){

  node* item = *root;
  int comp;

  while(item) {
    comp = compare(key, item->key);
    if (comp < 0)
      item = item->left;
    else if (comp > 0)
      item = item->right;
    else {
      return item->record;
    }
  }

  return NULL;
}


//extract the minimum son that it doesn't have son on the left
node* node_extract_min(node* root){

  node* father = NULL;
  node* item = root;

  while(item->left) {
    father = item;
    item = item->left;
  }

  if (father){
    if (item && item->right)
      father->left = item->right;
    else
      father->left = NULL;
  }

  return item;
}

//delete a node from the tree
void* tree_delete(tree* root, void* key, CompFunction compare){
  node* father = NULL;
  node* item = *root;
  int comp;

  //scan the tree to find the node to delete
  while(item) {

    comp = compare(key, item->key);
    if (comp < 0){
      father = item;
      item = item->left;
    }else if (comp > 0){
      father = item;
      item = item->right;
    }else {                 //node found

      if (item->left == NULL && item->right == NULL){     //the node is a leaf

        node_replace(root, father, item, NULL);

      } else if (item->left == NULL) {                    //the node has only the right son

        node_replace(root, father, item, item->right);

      } else if (item->right == NULL) {                   //the node has only the left son

        node_replace(root, father, item, item->left);

      } else {                                            //the node has both sons

        node* min_albero_destro = node_extract_min(item->right);

        node_replace(root, father, item, min_albero_destro);

        min_albero_destro->left = item->left;

        if (item->right != min_albero_destro)
          min_albero_destro->right = item->right;

      }

      void* oldRecord = item->record;
      free(item);
      return oldRecord;
    }
  }

  return NULL;
}

void tree_destroy(tree root){
  if (root != NULL){
    tree_destroy(root->left);
    tree_destroy(root->right);
    free(root->key);
    free(root);
  }
}
