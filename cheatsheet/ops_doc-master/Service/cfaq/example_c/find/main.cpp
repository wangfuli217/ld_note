#include <stdio.h>
#include <stdlib.h>

#include "BinarySearch.h"

#define GET_ARRAY_LEN(a, b) sizeof a / sizeof(b)

#define PAUSE system("pause")

int main(int argc, char **argv)
{
	int list_ordered[] = {0, 10, 33, 44, 67, 79, 80, 100};
	
	int key = 44;
	
	int post = Binary_Search(list_ordered, GET_ARRAY_LEN(list_ordered, int), key);
	
	if ( post < 0)
	{
		printf("not found.\n");
		return 0;
	}
	
	printf("Found is: %d\n", post);
	
	PAUSE;
}
