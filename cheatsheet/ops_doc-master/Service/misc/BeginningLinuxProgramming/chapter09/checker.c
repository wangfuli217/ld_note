#include <stdio.h>
#include <stdlib.h>

//C���Զ�Ұָ����ڴ����������������Ϣ
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
