#define _GNU_SOURCE     /* Expose declaration of tdestroy() */
#include <search.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

// a binary tree
// man tsearch
static void *root = NULL;

static void * xmalloc(unsigned n)
{
	void *p;
	p = malloc(n);
	if (p)
		return p;
	fprintf(stderr, "insufficient memory\n");
	exit(EXIT_FAILURE);
}

static int compare(const void *pa, const void *pb)
{
	printf("compare, *(int *)pa = %d, *(int *)pb = %d\n", *(int *)pa, *(int *)pb);
	if (*(int *) pa < *(int *) pb)
		return -1;
	if (*(int *) pa > *(int *) pb)
		return 1;
	return 0;
}

static void action(const void *nodep, const VISIT which, const int depth)
{
	int *datap;
	//printf("which = %d, preorder = %d, postorder = %d, endorder = %d, leaf = %d\n", which, preorder, postorder, endorder, leaf);
	switch (which)
	{
		case preorder:
			//datap = *(int **) nodep;
			//printf("%6d\n", *datap);
			break;
		case postorder:
			datap = *(int **) nodep;
			printf("%6d\n", *datap);
			break;
		case endorder:
			//datap = *(int **) nodep;
			//printf("%6d\n", *datap);
			break;
		case leaf:
			datap = *(int **) nodep;
			printf("%6d\n", *datap);
			break;
	}
}

void fun()
{
	int i, *ptr;
	void *val;
	//srand(time(NULL)); // 官方文档上的例子是采用随机数，但是由于每次执行都会产生不同的随机数，这样不便于观察，所以这里采用下面固定的数组。
	int array[12] = {2, 2, 1, 12, 9, 4, 8, 10, 3, 7, 5, 11};
	for (i = 0; i < 12; i++)
	{
		printf("~~~~~~~~~~~~ i = %d ~~~~~~~~~~~~~~\n", i);
		ptr = xmalloc(sizeof(int));
		//*ptr = rand() & 0xff; // 取随机数的低8位。
		*ptr = array[i];
		//ptr = array + i;
		printf("*ptr = %d\n", *ptr);

		val = tsearch((void *) ptr, &root, compare);

		int *pint = *(int **)val;
		printf("ptr = %p, *ptr = %d, val = %p, pint = %p, *pint = %d, root = %p\n", ptr, *ptr, val, pint, *pint, root);
		if (val == NULL)
		{
			printf("tsearch return NULL, will exit\n");
			exit(EXIT_FAILURE);
		}
		else if (pint != ptr)
		{
			printf("pint != ptr, will free(ptr)\n");
			free(ptr);
		}
	}
}

void main()
{
	fun();
	twalk(root, action);
	int key = 10;
	void *p = tfind((void *)&key, &root, compare);
	if(p)
	{
		int *pint = *(int **)p;
		printf("tfind key >>> p = %p, pint = %p, *pint = %d\n\n", p, pint, *pint);
	}

	p = tdelete((void *)&key, &root, compare);
	if(p)
	{
		int *pint = *(int **)p;
		printf("tdelete key, key's father is >>> p = %p, pint = %p, *pint = %d\n\n", p, pint, *pint);
	}
	twalk(root, action);

	tdestroy(root, free);
	exit(EXIT_SUCCESS);
}
