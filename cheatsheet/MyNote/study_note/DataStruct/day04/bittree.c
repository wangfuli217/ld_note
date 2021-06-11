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
node *create_node(int data)
{
	node *pt=(node *)malloc(sizeof(node));
	pt->data=data;
	pt->left=NULL;
	pt->right=NULL;
	return pt;
}
void insert(node ** proot,node *pn)
{
	if(NULL==*proot)
	{
		*proot=pn;
		return;
	}
	if(pn->data<(*proot)->data)
		insert(&((*proot)->left),pn);
	else
	{
		insert(&((*proot)->right),pn);
	}

}
void travel(node *root)
{
	if(root)
	{
		travel(root->left);
		printf("%d ",root->data);
		travel(root->right);
	}
}
void travelData(Tree *pt)
{
	travel(pt->root);
	printf("\n");
}
void insertData(Tree *pt,int data)
{
	insert(&pt->root,create_node(data));	
}
void clearall(node **pt)
{
	if(*pt)
	{
		clearall(&((*pt)->left));
		clearall(&((*pt)->right));
		free(*pt);
		*pt=NULL;
	}
}
void clear(Tree *pt)
{
	clearall(&(pt->root));
}
node ** find(node **pt,int data)
{
	if(*pt==NULL)
		return pt;
	if(data==(*pt)->data)
		return pt;
	else if(data<(*pt)->data)
		return find(&((*pt)->left),data);
	else 
		return find(&((*pt)->right),data);
}
node ** findData(Tree *pt,int data)
{
	return	find(&pt->root,data);
}
void delData(Tree *pt,int data)
{
	node **p=findData(pt,data);
	if(*p==NULL)  
	{
		printf("对不起，没有这个数\n");
		return;
	}
	if((*p)->left!=NULL)
	{
		insert(&(*p)->right,(*p)->left);
	}
	node *q=*p;
	*p=(*p)->right;
	free(q);
	q=NULL;
}
void modifyData(Tree *pt,int data,int data1)
{
	node **p=findData(pt,data);
	if(*p==NULL)
	{
		printf("对不起,%d不存在,修改失败\n",data);
		return ;
	}
	delData(pt,data);
	insertData(pt,data1);
}
int main(void)
{
	Tree tree={};
	insertData(&tree,50);
	travelData(&tree);
	insertData(&tree,70);
	modifyData(&tree,70,30);
	travelData(&tree);
	insertData(&tree,20);
	node **p=findData(&tree,30);
	if(*p==NULL)
		printf("没有找到\n");
	else
		printf("找的值为%d\n",(*p)->data);
	clear(&tree);
	travelData(&tree);
	return 0;
}
