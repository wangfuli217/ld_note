#ifndef TREE_H
#define TREE_H

#include<stdio.h>
#include<stdlib.h>
typedef struct node
{
	int data;
	struct node *left;
	struct node *right;
}node;
typedef struct
{
	node *root;
	int cnt;
}Tree;
node *create_node(int data);
void insert(node ** proot,node *pn);
void travel(node *root);
void travelData(Tree *pt);
void insertData(Tree *pt,int data);
void clearall(node **pt);
void clear(Tree *pt);
node ** find(node **pt,int data);
node ** findData(Tree *pt,int data);
void delData(Tree *pt,int data);
void modifyData(Tree *pt,int data,int data1);
#endif
