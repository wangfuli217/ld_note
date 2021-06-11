#include <stdio.h>
#include <stdlib.h>
#include "bit.h"

void apply(int n, int bit)
{
	if(bit == 1)
		printf("%d\n",n);
}

int main(void)
{
	Bit telephoneBit = Bit_new(10000000);
	int count = 0;
	
	Bit_put(telephoneBit,6422938,1);
	Bit_put(telephoneBit,6311577,1);
	Bit_set(telephoneBit,9222211,9222281);
	
	count = Bit_count(telephoneBit);
	printf("count of Bit is %d.\n",count);
	printf("all of Bit:\n");
	Bit_map(telephoneBit,apply);
	
	system("pause");
	Bit_free(&telephoneBit);
	
	return 0;	
}

