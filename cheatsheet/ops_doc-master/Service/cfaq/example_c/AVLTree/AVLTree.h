#ifndef __AVLTREE_H_
#define __AVLTREE_H_

#define OK 1
#define ERROR 0
#define TRUE 1
#define FALSE 0
#define MAXSIZE 100 /* 存储空间初始分配量 */

#define LH +1 /*  左高 */ 
#define EH 0  /*  等高 */ 
#define RH -1 /*  右高 */ 


typedef int Status;	/* Status是函数的类型,其值是函数结果状态代码，如OK等 */ 


/* 二叉树的二叉链表结点结构定义 */
#if 0
typedef  struct BiTNode	/* 结点结构 */
{
	int data;	/* 结点数据 */
	int bf; /*  结点的平衡因子 */ 
	struct BiTNode *lchild, *rchild;	/* 左右孩子指针 */
} BiTNode, *BiTree;
#endif

typedef  struct BiTNode	/* 结点结构 */
{
	int data;	/* 结点数据 */
	int bf; /*  结点的平衡因子 */ 
	BiTNode* lchild; 
	BiTNode* rchild;	/* 左右孩子指针 */
} BiTNode, *BiTree;


/* 对以p为根的二叉排序树作右旋处理， */
/* 处理之后p指向新的树根结点，即旋转处理之前的左子树的根结点 */
extern void R_Rotate(BiTree *P);

/* 对以P为根的二叉排序树作左旋处理， */
/* 处理之后P指向新的树根结点，即旋转处理之前的右子树的根结点0  */
extern void L_Rotate(BiTree *P);

/*  对以指针T所指结点为根的二叉树作左平衡旋转处理 */
/*  本算法结束时，指针T指向新的根结点 */
extern void LeftBalance(BiTree *T);

/*  对以指针T所指结点为根的二叉树作右平衡旋转处理， */ 
/*  本算法结束时，指针T指向新的根结点 */ 
extern void RightBalance(BiTree *T);

/*  若在平衡的二叉排序树T中不存在和e有相同关键字的结点，则插入一个 */ 
/*  数据元素为e的新结点，并返回1，否则返回0。若因插入而使二叉排序树 */ 
/*  失去平衡，则作平衡旋转处理，布尔变量taller反映T长高与否。 */
extern Status InsertAVL(BiTree *T,int e,Status *taller);

/* 查找为key的节点*/
extern Status Search(BiTree tree, int key, BiTree f, BiTree* p);

extern Status Delete(BiTree* tree, int key);

extern Status Delete(BiTree* node);

/*  中序遍历二叉平衡树*/
extern void MidOrderTraverse(BiTree tree);

/* 先序遍历二叉平衡树*/
extern void FirstOrderTraverse(BiTree tree);

/* 后序遍历二叉平衡树*/
extern void AfterOrderTraverse(BiTree tree);



#endif