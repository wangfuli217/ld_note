#include <stdio.h>
#include <stdlib.h>

int 
main(int argc, char **argv)
{
	/* 三维指针  [2][3][4] */
	int*** pa = new int**[2];
	
	for (int i = 0; i < 2; i++) {
		*(pa + i) = new int*[3];
		
		for (int j = 0; j < 3; j++) {
			*(*(pa + i) + j) = new int[4];
			
			for(int k = 0; k < 4; k++) {
				*(*(*(pa + i) + j) + k) = i * j * k;

				printf("pa[%d][%d][%d]: %d\n", i, j, k, *(*(*(pa + i) + j) + k));
			}
		}		
	}
	
	for (int i = 0; i < 2; i++) {
		for (int j = 0; j < 3; j++) {
			delete[] *(*(pa + i) + j);
		}

		delete[] *(pa + i);
	}

	delete[] pa;
	
	int* (*paa)[10] = new int*[2][10];
	
	for (unsigned int i = 0; i < 2; i++) {
		for (unsigned int j = 0; j < 10; j++) {
			*(*(paa + i) + j) = new int;
			*(*(*(paa + i) + j)) = i * j;
			
			printf("paa[%d][%d]: %d\n", i, j, *(*(*(paa + i) + j)));				
		}
	}
	
	for (unsigned int i = 0; i < 2; i++) {
		for (unsigned int j = 0; j < 10; j++) {
			delete *(*(paa + i) + j);
		}
	}	
	
	delete[] paa;
	
	/* 2 * 10 */
	int** paaa = new int*[2];
	
	*paaa = new int[2 * 10];
	
	for (unsigned int i = 1; i < 2; i++ ) {
		*(paaa + i) = *(paaa + i - 1) + 10; //重新分配地址， 10表示向后int*向后移动10个位置(10 * sizeof(int))
	}
	
	for (unsigned int i = 0; i < 2; i++ ) {
		for (unsigned int j = 0; j < 10; j++) {
			*(*(paaa + i) + j) = i * j;
			printf("paaa[%d][%d]: %d\n", i, j, *(*(paaa + i) + j));
		}
	}
	
	delete[] *paaa;
	delete[] paaa;
		
	int (*pppp)[10] = new int[2][10]; // return int(*)[10]
	
	for (int i = 0; i < 2; i++) {
		for (int j = 0; j < 10; j++) {
			*(*(pppp + i) + j) = i * j;
		}		
	}

	for (int i = 0; i < 2; i++) {
		for (int j = 0; j < 10; j++) {
			printf("pppp[%d][%d]: %d\n", i, j, *(*(pppp + i) + j));
		}		
	}
	
	
	typedef int array_t[10];
	
	array_t *pp = new array_t[2];
	
	for (int i = 0; i < 2; i++) {
		for (int j = 0; j < 10; j++) {
			*(*(pp + i) + j) = i + j;
			printf("pp[%d][%d]: %d\n", i, j, *(*(pp + i) + j));
		}
	}
	
	delete[] pp;
	
	
	// int [10][1] == int* [10]
	
	int **ppp = new int*[10];
	
	for (unsigned int i = 0; i < 10; i++) {
		*(ppp + i) = new int;
		*(*(ppp + i)) = i;
		printf("ppp[10][0]: %d\n", *(*(ppp + i)));
		
	}
	
	for (unsigned int i = 0; i < 10; i++) {
		delete *(ppp + i);
	}
	
	delete[] ppp;
	
	// int (*)[1]
	int (*ppppp)[1] = new int[10][1];
	
	for (unsigned int i = 0; i < 10; i++) {
		*(*(ppppp + i)) = i;
		printf("ppppp[%d]: %d\n", i, *(*(ppppp + i)));
	}
	
	delete[] ppppp;
	
	typedef int pppppp_t[1];
	
	pppppp_t *pppppp = new pppppp_t[10];
	
	for (unsigned int i = 0; i < 10; i++) {
		*(*(pppppp + i)) = i;
		printf("pppppp[%d]: %d\n", i, *(*(pppppp + i)));
	}
	
	system("pause");
	
	return 0;
}
