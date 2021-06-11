#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(int argc, char **argv)
{
	int i = 0;
	
	int *p = &i;
	
	uintptr_t j = p;
    i = p;
    
    void* data = (void*)i;
	
	printf("I: %x\n", i);
	printf("J: %x\n", j);
	
	printf("P: %08x\n", p);
    printf("data: %p\n", data);
	
	system("pause");
}
