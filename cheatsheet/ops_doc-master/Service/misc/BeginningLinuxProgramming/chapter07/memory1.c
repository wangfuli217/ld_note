#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#define A_MEGABYTE (1024 * 1024)

///-----------------------------------------------------------
//	����ռ䣬Ȼ��ʹ�ÿռ䣬�ͷſռ�
///----------------------------------------------------------
int main(void) 
{
    char *some_memory;
    int  megabyte = A_MEGABYTE;
    int exit_code = EXIT_FAILURE;

    some_memory = (char *)malloc(megabyte);
    if (some_memory != NULL) 		//���Ǻ���Ҫ��һ��
    {
        sprintf(some_memory, "Hello World\n");
        printf("%s", some_memory);
		 free(some_memory);
        exit_code = EXIT_SUCCESS;
    }
    exit(exit_code);
}

