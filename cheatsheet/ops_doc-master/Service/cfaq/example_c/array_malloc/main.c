#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int 
main(int argc, char **argv)
{
	/* 三维指针  [2][3][4] */
	int*** pa = (int***)malloc(sizeof(int**) * 2);
	
	for (int i = 0; i < 2; i++) {
		*(pa + i) = (int**)malloc(sizeof(int*) * 3);
		
		for (int j = 0; j < 3; j++) {
			*(*(pa + i) + j) = (int*)malloc(sizeof(int) * 4);
			
			for(int k = 0; k < 4; k++) {
				*(*(*(pa + i) + j) + k) = i * j * k;

				printf("pa[%d][%d][%d]: %d\n", i, j, k, *(*(*(pa + i) + j) + k));
			}
		}		
	}
	
	for (int i = 0; i < 2; i++) {
		for (int j = 0; j < 3; j++) {
			free(*(*(pa + i) + j));
		}
		
		free(*(pa + i)); /**/	
	}
	
	free(pa);
	
	
	/* 2 * 10  其实就是三维数组 [2][10][1]*/
	//int* (*paa)[10] = (int* (*)[10])malloc(sizeof(int*) * 2 * 10);
	//int* (*paa)[10] = (int* (*)[10])malloc(sizeof(int* (*)[10]) * 2 * 10);
	//int* (*paa)[10] = (int* (*)[10])malloc(sizeof *paa * 2);
    int* (*paa)[10] = (int* (*)[10])malloc(sizeof(int*[10]) * 2);
	
	for (unsigned int i = 0; i < 2; i++) {
		for (unsigned int j = 0; j < 10;j++) {
			*(*(paa + i) + j) = malloc(sizeof(int)); //数组元素分配 *(*(paa + i) + j)  == int*  *(paa + i) == int**
			*(*(*(paa + i) + j)) = i * j;
			
			printf("paa[%d][%d]: %d\n", i, j, *(*(*(paa + i) + j)));
		}
	}
	
	for (unsigned int i = 0; i < 2; i++) {
		for (unsigned int j = 0; j < 10;j++) {
			free(*(*(paa + i) + j));
		}
	}	
	
	free(paa);
	
	/* 2 * 10  连续空间*/
	
	int** paaa = (int**)malloc(sizeof(int*) * 2);
	
	*paaa = (int*)malloc(sizeof(int) * 2 * 10); /* 连续的int*空间 */
	
	for (unsigned int i = 1; i < 2; i++) {
		*(paaa + i) = *(paaa + i - 1) + 10;
	}
	
	for (unsigned int i = 0; i < 2; i++) {
		for (unsigned int j = 0; j < 10; j++) {
			*(*(paaa + i) + j) = i * j; /* paaa[i][j] */
			printf("paaa[%d][%d]: %d\n", i, j, *(*(paaa + i) + j));
		}
	}
	
	free(*paaa);
	free(paaa);
	
	/* 2 * 10 */
	
	typedef int int_array_t[10];
	
	int_array_t* paaaa = (int_array_t*)malloc(sizeof *paaaa * 2);
	
	for (int i = 0; i < 2; i++) {
		for (int j = 0; j < 10; j++) {
			*(*(paaaa + i) + j) = i * j;
			printf("paaaa[%d][%d]: %d\n", i, j, *(*(paaaa + i) + j));
		}
	}
	
	free(paaaa);
	
	
	/* 2 * 10 */
	
	typedef int* int_arrayp_t[10]; // int [10][1]
	
	int_arrayp_t* paaaaa = (int_arrayp_t*)malloc(sizeof *paaaaa * 2);
	
	for (int i = 0; i < 2; i++) {
		for (int j = 0; j < 10; j++) {
			*(*(paaaaa + i) + j) = (int*)malloc(sizeof(int));
			*(*(*(paaaaa + i) + j)) = i * j;
			printf("paaaaa[%d][%d]: %d\n", i, j, *(*(*(paaaaa + i) + j)));
		}
	}
	
	for (unsigned int i = 0; i < 2; i++) {
		for(unsigned int j = 0; j < 10;j++) {
			free(*(*(paaaaa + i) + j));
		}
	}		
	free(paaaaa);
	
	
	/* 2 * 10 */
	int (*paaaaaa)[10] = malloc(sizeof(int[10]) * 2);//malloc(sizeof(int) * 10 * 2);//malloc(sizeof *paaaaaa * 2); // 
	
	for (int i = 0; i < 2; i++) {
		for (int j = 0; j < 10; j++)  {
			*(*(paaaaaa + i) + j) = i + j;
			printf("paaaaaa[%d][%d]: %d\n", i, j, *(*(paaaaaa + i) + j));
		}
	}
	
	free(paaaaaa);
	
	
	int** pp = NULL; // 10 * 10
	
	pp = (int**)malloc((sizeof *pp) * 10);
	
	for (int i = 0; i < 10; i++) {
		*(pp + i) = malloc(sizeof(int) * 10);
	}
	
	
	
	// int [1][10] === int* [1]    
	
	int	**ppp = (int**)malloc(sizeof(int*) * 1);
	
	for (int i = 0; i < 1; i++) {
		*(ppp + i) = malloc(sizeof(int) * 10);
		for (int j = 0; j < 10; j++) {
			*(*(ppp + i) + j) = i + j;
			printf("ppp[%d][%d]: %d\n", i, j, *(*(ppp + i) + j));
		}
	}

	for (int i = 0; i < 1; i++) {
		free(*(ppp + i));
	}
	
	free(ppp);
	
	//int [10][1] === int* [10]
	
	int **pppp = (int**)malloc(sizeof(int*) * 10);
	
	for (int i = 0; i < 10; i++) {
		*(pppp + i) = malloc(sizeof(int)); 
		*(*(pppp + i)) = i;
		printf("pppp[%d][0]: %d\n", i, *(*(pppp + i)));
	}
	
	for (int i = 0; i < 10; i++) {
		free(*(pppp + i));
	}
	
	free(pppp);
	
	
	typedef int array_4_t[1];
	
	array_4_t *ppppppp = (array_4_t*)malloc(sizeof *ppppppp * 10);
	for (int i = 0; i < 10; i++) {
		**(ppppppp + i) = i;
		printf("ppppppp[%d][0]: %d\n", i, *(*(ppppppp + i)));
	}
	
	// int [2][3][4] 
	
	typedef int array_3_t[2][3][4];
	
	array_3_t *ppppp = (array_3_t*)malloc(sizeof(array_3_t));
	free(ppppp);
	
	int (*pppppp)[3][4] = (int(*)[3][4])malloc(sizeof(int [3][4]) * 2);
	free(pppppp);
		
	return 0;
}

