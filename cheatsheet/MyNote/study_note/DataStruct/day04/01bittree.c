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
}Tree;
void create(Tree *tree,int data)
{
	node *pt=(node *)malloc(sizeof(node));
	node *p=tree->root;
	int f=0;
	pt->data=data;
	pt->left=NULL;
	pt->right=NULL;
	if(tree->root==NULL)
	{
		tree->root=pt;
		return;
	}
	while(p!=NULL)
	{
		f=1;
		if(data<p->data&&p->left!=NULL)
		{
			f=0;
			p=p->left;
		}
		if(data>=p->data&&p->right!=NULL)
		{
			f=0;
			p=p->right;
		}
		if(f)
			break;
	}

	if(data<p->data)
		p->left=pt;
	else
		p->right=pt;
}
void preorder(node *root)    //前序遍历
{
	if(root)
	{
		printf("%d ",root->data);
		preorder(root->left);
		preorder(root->right);
	}
}
void inorder(node *root)    //中序遍历
{
	if(root)
	{
		inorder(root->left);
		printf("%d ",root->data);
		inorder(root->right);
	}
}
void postorder(node *root)   //后序遍历
{
	if(root)
	{
		postorder(root->left);
		postorder(root->right);
		printf("%d ",root->data);
	}
}
void clear(node **root)    //清空二叉树
{
	if(*root)
	{
		clear(&((*root)->left));
		clear(&((*root)->right));
		free(*root);
		*root=NULL;
	}
}
int main(void)
{
	int num=0;
	Tree tree={};
	create(&tree,50);
	create(&tree,70);
	create(&tree,20);
	create(&tree,60);
	create(&tree,40);
	create(&tree,30);
	create(&tree,30);
	create(&tree,10);
	create(&tree,90);
	create(&tree,80);
	printf("前序遍历\n");
	preorder(tree.root);
	printf("\n");
	printf("中序遍历\n");
	inorder(tree.root);
	printf("\n");
	printf("后序遍历\n");
	postorder(tree.root);
	printf("\n");
	clear(&tree.root);
	printf("输入回车继续\n");
	getchar();
	printf("请输入一些数,以空格相隔,-1结束\n");
	while(1)
	{
		scanf("%d",&num);
		if(num==-1)
			break;
		create(&tree,num);
	}
	printf("中序遍历\n");
	inorder(tree.root);
	printf("\n");
	return 0;
}
