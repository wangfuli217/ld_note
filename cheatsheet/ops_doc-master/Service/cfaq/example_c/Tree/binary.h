#ifndef __BINARY_H_
#define __BINARY_H_

typedef int DataNode;


typedef struct TreeNode* PTreeNode;
typedef struct TreeNode
{
	DataNode data;
	PTreeNode l_child;
	PTreeNode r_child;
}TreeNode;

extern void CreateTree(PTreeNode* tree);
extern void FirstOrderTraverse(PTreeNode tree);
extern void MidOrderTraverse(PTreeNode tree);
extern void AfterOrderTraverse(PTreeNode tree);


#endif