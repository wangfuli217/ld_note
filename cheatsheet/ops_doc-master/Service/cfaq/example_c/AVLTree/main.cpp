#include <stdio.h>
#include <stdlib.h>

#include "AVLTree.h"

#define	NEWLINE printf("\n")

int main(int argc, char* argv[])
{
	int i;
	int a[11]={3,2,1,4,5,6,7,10,9,8, 22};
	
	BiTree T=NULL;
	
	Status taller;
	
	for(i=0;i<11;i++)
	{
		printf("Status: %d\n", InsertAVL(&T,a[i],&taller));
	}
	
	FirstOrderTraverse(T);
	
	NEWLINE;
	
	MidOrderTraverse(T);
	
	NEWLINE;
	
	AfterOrderTraverse(T);

	NEWLINE;

	int key = 9;
	
	BiTree f = {0}, p;
	
	Search(T, key, f, &p);
	
	system("pause");
	return 0;
}
