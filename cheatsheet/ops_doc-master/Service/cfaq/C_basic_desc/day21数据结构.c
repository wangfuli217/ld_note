关键字：二叉树 Binary Tree

/*二叉树 Binary Tree*/
二叉树：属于逻辑结构中的树形结构
	
	就是指每个节点最多只有两个子节点的树形结构，
	也就是最多只有两个分叉的树形结构；

	其中树形结构中的起始节点叫做根节点，
	除了根节点之外，其他每个节点有且只有一个父节点，而整棵树有且只有一个根节点；
	
	没有任何子节点的节点叫做叶子节点，叶子节点有父节点但没有子节点；

	除了根节点和叶子节点之外，剩下的所有节点都叫做枝节点，枝节点有父节点也有子节点;

	如果该二叉树中每层节点个数都达到了最大值，
	并且所有枝节点都有两个子节点，这样的二叉树叫做满二叉树；

	如果该二叉树中除了最下面一层之外，其他每层节点个数都达到了最大值，
	并且最下面一层的所有节点都连续集中在左侧，这样的二叉树就叫做完全二叉树；

二叉树基本特征
	二叉树具有递归嵌套式的空间结构特征，因此采用递归的方法去处理二叉树问题，
	会使得处理算法更加简洁，而处理的方式如下：

	处理（二叉树）
	{
		if(二叉树为空)直接处理；
		else
		{
			处理左子树（以左子节点为根节点的小二叉树 递归）；
			处理右子树（以右子节点为根节点的小二叉树 递归）；
			处理根节点；
		}
	}

二叉树的存储结构
	1. 顺序存储：一般来说，从上到下，从左到右依次存放各个节点，
		    对于非完全二叉树需要使用虚节点补成完全二叉树；

	2. 链式存储：一般来说，每个节点包括三部分内容：
		    一个记录数据元素本身 和 两个分别指向左右子节点地址的指针；

		typedef struct node{
			int data;		//记录数据元素本身
			struct node *left;	//记录左子节点地址
			struct node *right;	//记录右子节点地址
		}Node;

二叉树基本操作
	创建（binary_tree_create）
	销毁（binary_tree_destroy）
	插入新元素（binary_tree_insert）
	遍历二叉树中所有元素（binary_tree_travel）
	删除元素（binary_tree_delete）
`	查找元素（binary_tree_find）
	*修改元素（binary_tree_modify）	
	*判断是否为空（binary_tree_empty）
	*判断是否为满（binary_tree_full）
	*查看二叉树中根节点元素值（binary_tree_root）
	*计算二叉树中有效元素个数（binary_tree_size）
	*清空二叉树（binary_tree_clear）

二叉树遍历方式
	1. 先序遍历（DLR => data left right）
		先遍历根节点，再遍历左子树，最后遍历右子树，又叫做先根遍历；
	2. 中序遍历（LDR => left data right）
		先遍历左子树，再遍历根节点，最后遍历右子树，又叫做中根遍历；
	3. 后序遍历（LRD => left right data）
		先遍历左子树，再遍历右子树，最后遍历根节点，又叫做后根遍历；
		
			30
	20  		35 
15		25			40


30 20 15 25 35 40
15 20 25 30 35 40
15 25 20 40 35 30

有序二叉树
	满足以下三个条件的非空二叉树就叫做有序二叉树
	1. 如果左子树不为空，则左子树中所有节点的元素值都小于等于根节点元素值；
	2. 如果右子树不为空，则右子树中所有节点的元素值都大于等于根节点元素值；
	3. 左右子树内部依然满足上述规则；
实际应用
	主要用于需要进行查找和排序的场合中，又叫做二叉查找树；

练习:
	使用以下数据合成有序二叉树，使用三种方法遍历
	50 （根节点） 70 20 60 40 30 10 90 80

			50
	    20      70
	 10   40  60   90	
         30       80

	50 20 10 40 30 70 60 90 80 先序遍历
	10 20 30 40 50 60 70 80 90 中序遍历
	10 30 40 20 60 80 90 70 50 后序遍历

编程实现有序二叉树的遍历

//编程实现有序二叉树的基本操作
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

//定义节点的数据类型
typedef struct node
{
	int data;//记录数据元素本身
	struct node* left;//记录左子节点的地址
	struct node* right;//记录右子节点的地址
}Node;

//定义有序二叉树的数据类型
typedef struct
{
	Node* root;//记录根节点的地址
	int cnt;//记录有效元素的个数
}Binary_tree;

//实现有序二叉树的创建
Binary_tree* binary_tree_create(void);
//实现有序二叉树的销毁
void binary_tree_destroy(Binary_tree* pbt);
//实现插入元素到有序二叉树中
void binary_tree_insert(Binary_tree* pbt,int data);
//实现插入元素的递归函数
void insert(Node** pRoot,Node* pn);
//实现遍历有序二叉树中所有节点元素
void binary_tree_travel(Binary_tree* pbt);
//实现遍历的递归函数
void travel(Node* root);
//实现查找指定元素
Node** binary_tree_find(Binary_tree* pbt,int data);
//实现查找指定元素的递归函数
Node** find(Node** pRoot,int data);
//实现删除指定元素所在的节点
int binary_tree_delete(Binary_tree* pbt,int data);
//实现判断有序二叉树是否为空
bool binary_tree_empty(Binary_tree* pbt);
//实现判断有序二叉树是否为满
bool binary_tree_full(Binary_tree* pbt);
//实现计算有序二叉树中有效节点的个数
int binary_tree_size(Binary_tree* pbt);
//实现查看根节点元素值
int binary_tree_root(Binary_tree* pbt);
//实现修改指定元素值
void binary_tree_modify(Binary_tree* pbt,int old_data,int new_data);
//实现清空有序二叉树
void binary_tree_clear(Binary_tree* pbt);
//实现清空的递归函数
void clear(Node** pRoot);

int main(void)
{
	//创建有序二叉树，使用binary_tree_create函数
	Binary_tree* pbt = binary_tree_create();

	binary_tree_insert(pbt,50);
	binary_tree_travel(pbt);// 50
	binary_tree_insert(pbt,70);
	binary_tree_travel(pbt);// 50 70
	binary_tree_insert(pbt,20);
	binary_tree_travel(pbt);// 20 50 70
	binary_tree_insert(pbt,60);
	binary_tree_travel(pbt);// 20 50 60 70

	printf("---------------------------------\n");
	binary_tree_delete(pbt,50);
	binary_tree_travel(pbt);// 20 60 70

	printf("---------------------------------\n");
	printf("%s\n",binary_tree_empty(pbt)?"有序二叉树已经空了":"有序二叉树没有空");//有序二叉树没有空
	printf("%s\n",binary_tree_full(pbt)?"有序二叉树已经满了":"有序二叉树没有满");//有序二叉树没有满
	printf("有序二叉树中有效元素的个数是：%d\n",binary_tree_size(pbt));// 3
	printf("有序二叉树中根节点元素是：%d\n",binary_tree_root(pbt)); // 70

	printf("---------------------------------\n");
	binary_tree_modify(pbt,20,200);
	binary_tree_travel(pbt); // 60 70 200 

	printf("---------------------------------\n");
	binary_tree_clear(pbt);
	binary_tree_travel(pbt); // 啥也没有

	//销毁有序二叉树，使用binary_tree_destroy函数
	binary_tree_destroy(pbt);
	pbt = NULL;
	return 0;
}

//实现清空的递归函数
void clear(Node** pRoot)
{
	if(*pRoot != NULL)
	{
		//1.清空左子树，递归
		clear(&(*pRoot)->left);
		//2.清空右子树，递归
		clear(&(*pRoot)->right);
		//3.清空根节点
		free(*pRoot);
		*pRoot = NULL;
	}
}

//实现修改指定元素值
void binary_tree_modify(Binary_tree* pbt,int old_data,int new_data)
{
	//1.删除旧元素
	int res = binary_tree_delete(pbt,old_data);
	if(-1 == res)
	{
		printf("目标元素不存在，修改失败\n");
		return;//结束当前函数
	}
	//2.插入新元素
	binary_tree_insert(pbt,new_data);
}

//实现清空有序二叉树
void binary_tree_clear(Binary_tree* pbt)
{
	//1.调用递归函数实现真正的清空
	clear(&pbt->root);
	//2.节点个数变成 0
	pbt->cnt = 0;
}

//实现判断有序二叉树是否为空
bool binary_tree_empty(Binary_tree* pbt)
{
	return NULL == pbt->root;
}

//实现判断有序二叉树是否为满
bool binary_tree_full(Binary_tree* pbt)
{
	return false;
}

//实现计算有序二叉树中有效节点的个数
int binary_tree_size(Binary_tree* pbt)
{
	return pbt->cnt;
}

//实现查看根节点元素值
int binary_tree_root(Binary_tree* pbt)
{
	//判断有序二叉树是否为空
	if(binary_tree_empty(pbt))
	{
		return -1;//表示查看失败
	}
	return pbt->root->data;
}

//实现删除指定元素所在的节点
int binary_tree_delete(Binary_tree* pbt,int data)
{
	//1.查找目标元素所在的地址
	Node** ppt = binary_tree_find(pbt,data);
	if(NULL == *ppt)
	{
		return -1;//表示查找失败
	}
	//2.将该节点的左子树合并到右子树中
	if((*ppt)->left != NULL)
	{
		insert(&(*ppt)->right,(*ppt)->left);
	}
	//3.使用临时指针记录要删除的节点地址
	Node* pt = *ppt;
	//4.将原来指向要删除节点地址的指针指向右子节点
	*ppt = (*ppt)->right;
	//5.删除目标元素所在的节点
	free(pt);
	pt = NULL;
	//6.节点元素的个数 减1
	pbt->cnt--;
	//7.返回删除成功
	return 0;
}

//实现查找指定元素的递归函数
Node** find(Node** pRoot,int data)
{
	//1.如果有序二叉树为空，则返回查找失败
	if(NULL == *pRoot)
	{
		return pRoot; //代表查找失败
	}
	//2.如果目标元素等于根节点元素，则返回查找成功
	if(data == (*pRoot)->data)
	{
		return pRoot; //代表查找成功
	}
	//3.如果目标元素小于根节点元素，则查找左子树
	else if(data < (*pRoot)->data)
	{
		return find(&(*pRoot)->left,data);
	}
	//4.如果目标元素大于根节点元素，则查找右子树
	else
	{
		return find(&(*pRoot)->right,data);
	}
}

//实现查找指定元素
//实际返回的是指向目标元素所在节点的指针的地址 
Node** binary_tree_find(Binary_tree* pbt,int data)
{
	//调用递归函数进行查找
	return find(&pbt->root,data);
}

//实现遍历的递归函数
void travel(Node* root)
{
	// 表示该有序二叉树中至少有一个根节点
	if(root != NULL)
	{
		//1.遍历左子树，使用递归
		travel(root->left);
		//2.遍历根节点
		printf("%d ",root->data);
		//3.遍历右子树，使用递归
		travel(root->right);
	}
}

//实现遍历有序二叉树中所有节点元素
void binary_tree_travel(Binary_tree* pbt)
{
	//1.采用中序遍历方式进行遍历，采用递归函数
    travel(pbt->root);
	//2.打印换行
	printf("\n");
}

//实现插入元素的递归函数
void insert(Node** pRoot,Node* pn)
{
	//1.如果有序二叉树为空，则直接插入
	// Node** pRoot = &pbt->root;
	// pRoot = &pbt->root;
	// *pRoot = *(&pbt->root) = pbt->root;
	if(NULL == *pRoot)
	{
		*pRoot = pn;
		return;//结束当前函数
	}
	//2.如果有序二叉树不为空，和根节点元素比较
	//2.1 如果根节点元素大于新元素，则插入左子树中
	if((*pRoot)->data > pn->data)
	{
		insert(&(*pRoot)->left,pn);
	}
	//2.2 如果根节点元素小于等于新元素，插入右子树
	else
	{
		insert(&(*pRoot)->right,pn);
	}
}

//实现插入元素到有序二叉树中
void binary_tree_insert(Binary_tree* pbt,int data)
{
	//1.创建新节点，并进行初始化
	Node* pn = (Node*)malloc(sizeof(Node));
	if(NULL == pn)
	{
		printf("创建新节点失败，函数结束\n");
		return;
	}
	pn->data = data;
	pn->left = NULL;
	pn->right = NULL;
	//2.插入新节点到合适的位置上，调用递归函数
	insert(&pbt->root,pn);
	//3.节点元素的个数 加1
	pbt->cnt++;
}

//实现有序二叉树的创建
Binary_tree* binary_tree_create(void)
{
	//1.创建有序二叉树
	Binary_tree* pbt = (Binary_tree*)malloc(sizeof(Binary_tree));
	if(NULL == pbt)
	{
		printf("创建有序二叉树失败，程序结束\n");
		exit(-1);
	}
	//2.初始化成员
	pbt->root = NULL;
	pbt->cnt = 0;
	//3.返回有序二叉树的首地址
	return pbt;
}

//实现有序二叉树的销毁
void binary_tree_destroy(Binary_tree* pbt)
{
	free(pbt);
	pbt = NULL;
}



作业：编程实现有序二叉树的其他基本操作

预习：算法的概念 评价
	常用的查找算法
	常用的排序算法













