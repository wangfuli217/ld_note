#ifndef TREE_H
#define TREE_H

#include <stdio.h>

struct treenode
{
  int data;
  struct treenode * left;
  struct treenode * right;
};


struct treenode * treenode_create (int data)
{
  struct treenode * n = (struct treenode *)malloc(sizeof(struct treenode));
  n->data = data;
  n->left = NULL;
  n->right = NULL;

  return n;
}


int tree_height (struct treenode * tree)
{
  if (tree == NULL) return 0;
  else
  {
    int left_h = tree_height (tree->left);
    int right_h = tree_height (tree->right);

    if (left_h > right_h) return (left_h + 1);
    else return (right_h + 1);
  }
}


int tree_width (struct treenode * root, int level)
{
  if (root == NULL) return 0;
  if (level == 1) return 1;
  else if (level > 1) return tree_width(root->left, level-1) + tree_width(root->right, level-1);
}


int tree_maxwidth (struct treenode * tree)
{
  int maxwidth = 0;
  int width;
  int height = tree_height (tree);
  int i;
  for (i = 0; i <= height; ++i)
  {
    width = tree_width (tree, i);
    if (width > maxwidth) maxwidth = width; 
  }
}


struct treenode * tree_insert (struct treenode * node, int data)
{
  if (node == NULL) return treenode_create(data);
  if (data < node->data) node->left = tree_insert (node->left, data);
  else if (data > node->data) node->right = tree_insert (node->right, data);

  return node;
}


struct treenode * tree_minnode (struct treenode * node)
{
  struct treenode * current = node;
  while (current->left != NULL)
  {
    current = current->left;
  }

  return current;
}


struct treenode * tree_delete (struct treenode * root, int data)
{
  if (root == NULL) return root;

  if (data < root->data) root->left = tree_delete (root->left, data);
  else if (data > root->data) root->right = tree_delete (root->right, data);
  else
  {
    if (root->left == NULL)
    {
      struct treenode * temp = root->right;
      free (root);
      return temp;
    }
    else if (root->right == NULL)
    {
      struct treenode * temp = root->left;
      free (root);
      return temp;
    }

    struct treenode * temp = tree_minnode (root->right);
    root->data = temp->data;
    root->right = tree_delete (root->right, temp->data);
  }

  return root;
}

/* ------------------------------------------------------------------------------------- */


void tree_traverse_preorder (struct treenode * tree)
{
  if (tree == NULL) return;
  printf("%d ", tree->data);

  tree_traverse_preorder (tree->left);
  tree_traverse_preorder (tree->right); 
}


void tree_traverse_inorder (struct treenode * tree)
{
  if (tree == NULL) return;
  tree_traverse_inorder (tree->left);
  printf("%d ", tree->data);
  tree_traverse_inorder (tree->right);
}


void tree_traverse_postorder (struct treenode * tree)
{
  if (tree == NULL) return;
  tree_traverse_postorder (tree->left);
  tree_traverse_postorder (tree->right);
  printf("%d ", tree->data);
}


void tree_traverse_given_level (struct treenode * root, int level)
{
  if (root == NULL) return;
  if (level == 1) printf("%d ", root->data);
  else if (level > 1)
  {
    tree_traverse_given_level (root->left, level-1);
    tree_traverse_given_level (root->right, level-1);
  }
}


void tree_traverse_levelorder (struct treenode * tree)
{
  int h = tree_height (tree);
  int i;
  for (i = 1; i <= h; ++i)
    tree_traverse_given_level (tree, i); 
}


void tree_traverse_morris (struct treenode * tree)
{
  struct treenode * current;
  struct treenode * prev;

  if (tree == NULL) return;

  current = tree;
  while (current != NULL)
  {
    if (current->left == NULL)
    {
      printf("%d ", current->data);
      current = current->right;
    }
    else
    {
      prev = current->left;
      while (prev->right != NULL && prev->right != current)
      {
        prev = prev->right;
      }

      if (prev->right == NULL)
      {
        prev->right = current;
        current = current->left;
      }
      else
      {
        prev->right = NULL;
        printf("%d ", current->data);
        current = current->right;
      }
    }
  }
}


void tree_traverse_kdistance (struct treenode * root, int k)
{
  if (root == NULL) return;
  if (k == 0)
  {
    printf("%d ", root->data);
    return;
  }
  else
  {
    tree_traverse_kdistance (root->left, k-1);
    tree_traverse_kdistance (root->right, k-1);
  }
}


/* ------------------------------------------------------------------------------------- */

#endif
