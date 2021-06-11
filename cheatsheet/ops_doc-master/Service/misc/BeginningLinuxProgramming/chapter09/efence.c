#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    char *ptr = (char *) malloc(1024);
    ptr[0] = 0;

    /* Now write beyond the block */
    ptr[1024] = 0;
	free(ptr);
	ptr=NULL;
    exit(0);
}
