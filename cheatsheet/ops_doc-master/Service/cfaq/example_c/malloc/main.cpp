#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	int** p;
	
	int (*pa)[10];
	
	int* (*paa)[10]; // int* paa[10][10]
	
	int** paaa;

	int** ppaaa;
	
	p = (int**)malloc(sizeof(int*) * 10); //p[10][1]
	
	pa = (int (*)[10])malloc(sizeof(int) * 10); //int pa[10]
	
	paa = (int* (*)[10])malloc(sizeof(int**) * 10); // int* paa[10][10]
	
	paaa = (int**)malloc(sizeof(int) * 10 * 10);// m * n
	
	//ppaaa = &paaa;// unuseful
	ppaaa = (int**)malloc(sizeof(int*) * 10);
	*(ppaaa + 0) = (int*)malloc(sizeof(int) * 10 * 10);
	
	for (int i = 1; i < 10; i++) {
		*(ppaaa + i) = *(paaa + i - 1) + 10; // *(ppaaa + i) = *(paaa + 0) + 10 * i;
	}
	
	
	for (int i = 0; i < 10; i++)
	{	
		*(p + i) = (int*)malloc(sizeof(int));
	
		*(*(p + i)) = i;
		*((*pa) + i) = i;
		
		
		
		printf("p[%d]:%d\n", i, *(*(p + i)));
		printf("pa[%d]:%d\n", i, *((*pa) + i));
	}
	
	for (int i = 0; i < 10; i++)
	{
		for (int j = 0; j < 10; j++)
		{
			
			*(*(paa + i) + j) = (int*)malloc(sizeof(int*));
			
			*(*(*(paa + i) + j)) = i * 10 + j;
			printf("paa[%d][%d]:%d\n", i, j, *(*(*(paa + i) + j)));
			printf("paa[%d][%d]:%d\n", i, j, *(paa + i) + j); // *(paa + i) + j is int**
			
			*(*(ppaaa + i) + j) = i * 10 + j;
			
			printf("ppaaa[%d][%d]:%d\n", i, j, *(*(ppaaa + i) + j));
			printf("ppaaa[%d][%d]:%d\n", i, j, *(ppaaa + i) + j);

		}
	}
	
	system("pause");
	return 0;
}
