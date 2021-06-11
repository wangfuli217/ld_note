#include<stdio.h>
#include<stdlib.h>
typedef struct node
{
	char ch;
	struct node* left;
	struct node* right;
}node,*tree;
void preorder(const node* root)
{
	if(root)
	{
		printf("%c ",root->ch);
		preorder(root->left);
		preorder(root->right);
	}
}
void createtree(tree* root)
{
	char ch;
	scanf("%c",&ch);
	if(ch=='#') 
	{
		*root=NULL;
		return;
	}
	else
	{
		*root=(node *)malloc(sizeof(node));
		(*root)->ch=ch;
		createtree(&(*root)->left);
		createtree(&(*root)->right);
	}
}
int main()
{
	node *a=NULL;
	createtree(&a);
	preorder(a);
	printf("\n");
	return 0;
}
