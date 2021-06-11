#include<cstdio>
#include<cstdlib>
#define LH 1
#define EH 0
#define RH -1
using namespace std;

typedef struct BTNode
{
	int data;
	int BF;
	BTNode *lchild,*rchild;
}BTNode,*BTree;

void R_Rotate(BTree *p)
{
	BTree L;
	L=(*p)->lchild;
	(*p)->lchild=L->rchild;
	L->rchild=*p;
	*p=L;
}
void L_Rotate(BTree *p)
{
	BTree R;
	R=(*p)->rchild;
	(*p)->rchild=R->lchild;
	R->lchild=*p;
	*p=R;
}
void LeftBalance(BTree *T)
{
	BTree L,Lr;
	L=(*T)->lchild;
	switch(L->BF)
	{
		case LH:
			(*T)->BF=L->BF=EH;
			R_Rotate(T);
			break;
		case RH:
			Lr=L->rchild;
			switch(Lr->BF)
			{
				case LH:
					(*T)->BF=RH;
					L->BF=EH;
					break;
				case EH:
					(*T)->BF=L->BF=EH;
					break;
				case RH:
					(*T)->BF=EH;
					L->BF=LH;
					break;
			}
			Lr->BF=EH;
			L_Rotate(&(*T)->lchild);
			R_Rotate(T);
			break;
	}
}
void RightBalance(BTree *T)
{
	BTree R,Rl;
	R=(*T)->rchild;
	switch(R->BF)
	{
		case RH:
			(*T)->BF=R->BF=EH;
			L_Rotate(T);
			break;
		case LH:
			Rl=R->lchild;
			switch(Rl->BF)
			{
				case LH:
					(*T)->BF=EH;
					R->BF=LH;
					break;
				case EH:
					(*T)->BF=R->BF=EH;
					break;
				case RH:
					(*T)->BF=LH;
					R->BF=EH;
					break;
			}
			Rl->BF=EH;
			R_Rotate(&(*T)->rchild);
			L_Rotate(T);
			break;
	}
}
bool InsertAVL(BTree *T,int e,bool *taller)
{
	if(!*T)
	{
		*T=(BTree)malloc(sizeof(BTNode));
		(*T)->data=e;
		(*T)->lchild=(*T)->rchild=NULL;
		(*T)->BF=EH;
		*taller=true;
	}
	else
	{
		if(e==(*T)->data)
		{
			*taller=false;
			return false;
		}
		if(e<(*T)->data)
		{
			if(!InsertAVL(&(*T)->lchild,e,taller))
				return false;
			if(*taller)
			{
				switch((*T)->BF)
				{
					case LH:
						LeftBalance(T);
						*taller=false;
						break;
					case EH:
						(*T)->BF=LH;
						*taller=true;
						break;
					case RH:
						(*T)->BF=EH;
						*taller=false;
						break;
				}
			}
		}
		else
		{
			if(!InsertAVL(&(*T)->rchild,e,taller))
					return false;
			if(*taller)
			{
				switch((*T)->BF)
				{
					case LH:
						(*T)->BF=EH;
						*taller=false;
						break;
					case EH:
						(*T)->BF=RH;
						*taller=true;
						break;
					case RH:
						RightBalance(T);
						*taller=false;
						break;
				}
			}
		}
	}
	return true;
}
void order(BTree T)
{
	if(T)
	{
		printf("%d\n",T->data);
		order(T->lchild);
		order(T->rchild);
	}
}
void inorder(BTree T)
{
	if(T)
	{
		inorder(T->lchild);
		printf("%d\n",T->data);
		inorder(T->rchild);
	}
}
void test1(void)
{
	int i;
	int A[]={1,2,3,4,5,6,7,8,9,10};
	BTree T=NULL;
	bool taller;
	for(i=0;i<sizeof(A)/sizeof(int);i++)
		InsertAVL(&T,A[i],&taller);
	printf("前序遍历\n");
	order(T);
	printf("中序遍历\n");
	inorder(T);
}
int main(void)
{
	test1();
	return 0;
}
