#include "binary.h"
#include <stdlib.h>
#include <stdio.h>

void CreateTree(PTreeNode* tree)
{
	DataNode d = 0;
	
	scanf("%d", &d);
	
	if(d == 99)
	{
		*tree = NULL;
	}
	else
	{
		*tree = (PTreeNode)malloc(sizeof(TreeNode));
		if (!*tree)
			exit(1);//exit(OVERFLOW);
		else
		{
			(*tree)->data = d;
			CreateTree(&(*tree)->l_child);
			CreateTree(&(*tree)->r_child);
		}
	}																																																																										
}

void FirstOrderTraverse(PTreeNode tree)
{
	if(!tree)
		return;
	else
	{
		printf("%d", tree->data);
		FirstOrderTraverse(tree->l_child);
		FirstOrderTraverse(tree->r_child);
	}
}

void MidOrderTraverse(PTreeNode tree)
{
	if(!tree)
		return;
	else
	{
		MidOrderTraverse(tree->l_child);
		printf("%d", tree->data);
		MidOrderTraverse(tree->r_child);
	}
}

void AfterOrderTraverse(PTreeNode tree)
{
	if(!tree)
		return;
	else
	{
		AfterOrderTraverse(tree->l_child);
		AfterOrderTraverse(tree->r_child);
		printf("%d", tree->data);
	}
}
