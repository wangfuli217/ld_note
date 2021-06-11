#include <stdio.h>
#include <stdlib.h>
#include "QuickSort.h"


#define PAUSE system("pause")

static 
void
Array_print(int* array, unsigned int len)
{
	for(unsigned int i = 0; i < len; i++)
	{
		printf("Array[%u]: %d\n", i, array[i]);
	}
}

int main(int argc, char **argv)
{	
	int list[] = {21, 12, 32, 46,18, 53, 80, 72, 63, 98};
	
	Array_print(list, sizeof list / sizeof(int));
	
	Quick_Sort(list, 0, sizeof list / sizeof(int));
	
	Array_print(list, sizeof list / sizeof(int));
	
	PAUSE;
	
}
