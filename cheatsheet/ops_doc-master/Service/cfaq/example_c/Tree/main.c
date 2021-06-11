#include <stdio.h>
#include <stdlib.h>
#include "binary.h"

int main(int argc, char **argv)
{
	PTreeNode pTree;
	
	CreateTree(&pTree);
	
	printf("\nFirst:\n");
	
	FirstOrderTraverse(pTree);
	
	printf("\nMid:\n");
	
	MidOrderTraverse(pTree);
	
	printf("\nAfter:\n");
	
	AfterOrderTraverse(pTree);
	
	system("pause");
	
	return 0;
}
