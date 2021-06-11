#include <stdio.h>
#include <stdlib.h>

#include "unity.h"
#include "tree.h"


void test_tree (void)
{
  struct treenode * root = treenode_create(1);
  root->left = treenode_create(2);
  root->right = treenode_create(3);
  root->left->left = treenode_create(4);
  tree_insert (root, 5);
  tree_insert (root, 6);
  tree_delete (root, 6);

  printf("preorder: "); tree_traverse_preorder (root); printf("\n");
  printf("inorder: "); tree_traverse_inorder (root); printf("\n");
  printf("postorder: "); tree_traverse_postorder (root); printf("\n");
  printf("levelorder: "); tree_traverse_levelorder (root); printf("\n");
  printf("morris inorder: "); tree_traverse_morris (root); printf("\n");
  printf("kdistance: "); tree_traverse_kdistance (root, 1); printf("\n");

  int maxwidth = tree_maxwidth (root);
  printf("maxwidth: %d\n", maxwidth);
}


int main (void)
{
  UNITY_BEGIN ();
  RUN_TEST (test_tree);
  return UNITY_END ();
}
