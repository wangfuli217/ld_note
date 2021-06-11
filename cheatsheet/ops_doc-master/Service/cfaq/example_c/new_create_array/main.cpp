#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	int (*pTemp)[4];
	
	int ** pTemp2;
	
	pTemp = new int[2][4]; // char (*)[4]
	

	pTemp2 = new int*[2]; // char **
	
	int* pTemp4 = new int[4]; // int* 
	
	int (*pTemp5)[2][4] = new int[1][2][4]; // int(*)[2][4]
 	
	for (int i = 0; i < 4; i++)
	{
		*(pTemp2 + i) = new int[4];
	}
	
	// three
	
	system("pause");
}
