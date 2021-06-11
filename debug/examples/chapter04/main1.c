/* main1.c */
#include <stdio.h>
#include <stdlib.h>
int main(int argc, char *argv[]){
	const int size=100;
	int n, sum = 0;
	int *A = (int*)malloc(sizeof(int)*size);

	for(n=size; n>0; n--){ /* walk through A[100] ... A[1] */
		A[n]=n;			   /* error: A[100] invalid write */
	}
	for(n=0; n<size; n++){ /* walk: through A[0] ... A[99] */
		sum += A[n];	   /* error: A[0] not initialized */
	}

	printf("sum=%d\n", sum);
	return 0;			   /* mem leak: A[]  */
}
