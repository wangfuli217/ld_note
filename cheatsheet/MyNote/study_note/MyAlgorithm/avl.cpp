#include<iostream>
#include<time.h>
#include<stdlib.h>
#include<queue>
#include<vector>
#define MAX_SIZE 100
using namespace std;
typedef class BTnode
{
	int data;			//树中结点存放的数据
	BTnode *pLeft;		//左子树
	BTnode *pRight;		//右子树
	int BF;				//平衡因子 0-左右高度相同  1-左子树高度比右子树高1  -1-左子树比右子树低1
	friend class AVL;
public:
	BTnode(int value):data(value),pLeft(NULL),pRight(NULL),BF(0){}
}BTnode,*pBTnode;

class AVL
{
	pBTnode root;		//树的根结点
	bool taller;    	//标识树是否有变高,从而去判断插入是否需要平衡
	bool shorter;		//标识树是否有变短,从而去判断删除是否需要平衡

	pBTnode createBTnode(int value)   //创建一个树结点
	{
		return new BTnode(value);
	}
	void L_Rotate(pBTnode &T)
	{
		pBTnode pTemp=T->pRight;
		T->pRight=pTemp->pLeft;
		pTemp->pLeft=T;
		T=pTemp;
	}
	void R_Rotate(pBTnode &T)
	{
		pBTnode pTemp=T->pLeft;
		T->pLeft=pTemp->pRight;
		pTemp->pRight=T;
		T=pTemp;
	}
	void leftBalance(pBTnode &T)			//所有以左开始的平衡,如左左,左右
	{
		switch(T->pLeft->BF)
		{
			case 1:		//左左
				T->BF=T->pLeft->BF=0;
				R_Rotate(T);
				taller=false;
				shorter=true;
				break;
			case 0:
				T->BF=1;
				T->pLeft->BF=-1;
				R_Rotate(T);
				shorter=false;
				break;
			case -1:	//左右
				switch(T->pLeft->pRight->BF)
				{
					case 1:
						T->BF=-1;
						T->pLeft->BF=0;
						break;
					case 0:
						T->BF=T->pLeft->BF=0;
						break;
					case -1:
						T->BF=0;
						T->pLeft->BF=1;
						break;
				}
				T->pLeft->pRight->BF=0;
				L_Rotate(T->pLeft);
				R_Rotate(T);
				taller=false;
				shorter=true;
				break;
		}
	}
	void rightBalance(pBTnode &T)			//所有以右开始的平衡,如右右,右左
	{
		switch(T->pRight->BF)
		{
			case -1:				//右右情况--左旋
				T->BF=T->pRight->BF=0;
				L_Rotate(T);
				taller=false;
				shorter=true;
				break;
			case 0:				//删除结点时需要,插入结点时用不着
				T->BF=-1;
				T->pRight->BF=1;
				shorter=false;
				L_Rotate(T);
				break;
			case 1:				//右左情况--先右旋再左旋
				switch(T->pRight->pLeft->BF)
				{
					case 1:
						T->BF=0;
						T->pRight->BF=-1;
						break;
					case 0:
						T->BF=T->pRight->BF=0;
						break;
					case -1:
						T->BF=1;
						T->pRight->BF=0;
						break;
				}
				T->pRight->pLeft->BF=0;
				R_Rotate(T->pRight);
				L_Rotate(T);
				taller=false;
				shorter=true;
				break;
		}
	}
	bool insertAVL(pBTnode &T,int value)
	{
		if( NULL==T )
		{
			T=createBTnode(value);
			taller=true;
		}
		else
		{
			if(value==T->data)		//若要插入的数字和某个结点的数字相同,则插入失败
				return false;
			else if(value<T->data)
			{
				if(insertAVL(T->pLeft,value)==false)
					return false;
				if( taller==true )
				{
					T->BF++;
					if(T->BF==0)		//平衡因子等于0说明插入数据后树高度没有变化,则不需要平衡树
						taller=false;
					else if(T->BF==2)
					{
						leftBalance(T);
					}
				}
			}
			else
			{
				if(insertAVL(T->pRight,value)==false)
					return false;
				if( taller==true )
				{
					T->BF--;
					if(T->BF==0)		//平衡因子等于0说明插入数据后树高度没有变化,则不需要平衡树
						taller=false;
					else if(T->BF==-2)
					{
						rightBalance(T);
					}
				}
			}
		}
		return true;
	}
	bool deleteAVL(pBTnode &T,int value)
	{
		if( T==NULL )
			return false;				//没找到结点,删除

		if( value==T->data)
		{
			pBTnode pTemp=NULL;
			if(T->pLeft==NULL)			//删除点左子树为空,则将删除点的右子树向上接续
			{
				pTemp=T;
				T=T->pRight;
				delete pTemp;
				pTemp=NULL;
				shorter=true;
			}
			else if(T->pRight==NULL)	//删除点右子树为空,则将删除点的左子树向上接续
			{
				pTemp=T;
				T=T->pLeft;
				delete pTemp;
				pTemp==NULL;
				shorter=true;
			}
			else						//若左右子树都存在,则查找其前驱结点,找到后用前驱结点的value替换要删除点的value,并删除前驱结点
			{
				pTemp=T->pLeft;
				while(pTemp->pRight)
				{
					pTemp=pTemp->pRight;
				}
				T->data=pTemp->data;
				deleteAVL(T->pLeft,pTemp->data);		//在左子树中递归删除前驱结点
				if( shorter==true )						//这里必须判断一下,否则如果删除的是树的根结点,就会造成不平衡
				{
					T->BF--;
					if(T->BF==-1)       //说明原来树是平衡的,那么去掉一个结点后,不会影响树的高度,所以不需要平衡
						shorter=false;
					if(T->BF==-2)
					{
						rightBalance(T);
					}
				}
			}
		}
		else if(value<T->data)			//向左查
		{
			if( deleteAVL(T->pLeft,value)==false )
				return false;
			if( shorter==true )
			{
				T->BF--;
				if(T->BF==-1)		//说明原来树是平衡的,那么去掉一个结点后,不会影响树的高度,所以不需要平衡
					shorter=false;
				if(T->BF==-2)
				{
					rightBalance(T);
				}
			}
		}
		else
		{
			if( deleteAVL(T->pRight,value)==false )
				return false;
			if( shorter==true )
			{
				T->BF++;
				if(T->BF==1)			//说明树原来是平衡的,那么去掉一个结点后,不会影响树的高度,所以不需要平衡
					shorter=false;
				if(T->BF==2)
				{
					leftBalance(T);
				}
			}
		}
		return true;
	}
	void order(pBTnode T) const
	{
		if(T)
		{
			cout<<T->data<<endl;
			order(T->pLeft);
			order(T->pRight);
		}
	}
	void inorder(pBTnode T) const
	{
		if(T)
		{
			inorder(T->pLeft);
			cout<<T->data<<endl;
			inorder(T->pRight);
		}
	}
public:
	AVL(void):root(NULL),taller(false),shorter(false){}

	bool insertAVL(int value)		//向avl树中插入一个结点
	{
		if(insertAVL(root,value)==true)
			return true;
		return false;
	}
	bool deleteAVL(int value)		//向avl树中删除一个结点
	{
		if(deleteAVL(root,value)==true)
			return true;
		return false;
	}
	void order(void) const			//前充遍历
	{
		order(root);
	}
	void inorder(void) const		//中序遍历
	{
		inorder(root);
	}
	void levelOrder(void)
	{
		queue<pBTnode> qNode;
		vector<pBTnode> vNode;
		pBTnode pTemp;
		int sumLevel=0;		//总层数
		int curNum=0;		//当前层剩余要打印的数的个数
		int nextNum=0;		//下一层要打印的数的个数
		if(root!=NULL)
		{
			qNode.push(root);
			curNum++;
			sumLevel++;
		}

		while(!qNode.empty())
		{
			pTemp=qNode.front();
			qNode.pop();
			if(pTemp==(pBTnode)-1)
			{
				cout<<'#'<<' ';
				continue;
			}
			cout<<pTemp->data<<'('<<pTemp->BF<<')'<<' ';
			curNum--;
			if(pTemp->pLeft)
			{
				qNode.push(pTemp->pLeft);
				nextNum++;
			}
			else
				qNode.push((pBTnode)-1);
			if(pTemp->pRight)
			{
				qNode.push(pTemp->pRight);
				vNode.push_back(pTemp->pRight);
				nextNum++;
			}
			else
				qNode.push((pBTnode)-1);
			if(curNum==0)	//换层
			{
				curNum=nextNum;
				nextNum=0;
				sumLevel++;
				cout<<endl;
				//if(curNum==0)
				//	break;
			}
		}
		cout<<endl;
	}
};

void test1(void)
{
	int i;
	//int A[]={8,7,11,3,5,14,4,13,11,4,14,19,14,13,15,10,3,7,7,17};
	srand(time(0));
	int A[MAX_SIZE];
	for(i=0;i<MAX_SIZE;i++)
	{
		A[i]=rand()%MAX_SIZE;
		cout<<A[i]<<',' ;
	}
	cout<<endl;
	AVL T;
	for(i=0;i<sizeof(A)/sizeof(int);i++)
	{
		T.insertAVL(A[i]);
	}
	T.levelOrder();
	for(i=0;i<sizeof(A)/sizeof(int);i++)
	{
		if(T.deleteAVL(A[i])==true)
		{
			cout<<"删除: "<<A[i]<<endl;
			T.levelOrder();
		}
	}
	//cout<<"前序遍历"<<endl;
	//T.order();
	//cout<<"中序遍历"<<endl;
	//T.inorder();
}
int main(void)
{
	test1();
	return 0;
}