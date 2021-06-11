#include <stdio.h>
#include <stdlib.h>

//C语言对野指针和内存溢出不产生警告信息
//
//
int main(void)
{
    char *ptr = (char *) malloc(1024);
    char ch;

    /* Uninitialized read */
    ch = ptr[0];

    /* Write beyond the block */
    ptr[1024] = 0;

    /* Orphan the block */
    ptr = 0;
	free(ptr);
	ptr=NULL;
    exit(0);
}
