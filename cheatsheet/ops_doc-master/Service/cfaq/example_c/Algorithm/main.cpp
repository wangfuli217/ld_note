#include <stdio.h>
#include <stdlib.h>
#include "algorithm.h"

//#define PAUSE	system("pause");
#define PAUSE	EXEC(pause);
#define EXEC(a)	system(#a);

void
swap(int& a, int& b)
{
	a ^= b;
	b ^= a;
	a ^= b;
}

int main(int argc, char **argv)
{
	char src[] = "hello world!";
	
	strrev2(src);
	
	printf("src: %s\n", src);
	
	
	PListItem list;
	
	List_Init(&list, 10);
	
	List_Print(list);
	
	List_Rev(&list);
	
	List_Print(list);
	
	int a, b;
	
	a = 3;
	b = 9;
	
	swap(a, b);
	
	printf("a: %d b: %d\n", a, b);
	
	
	PAUSE;
	
	return 0;
}
