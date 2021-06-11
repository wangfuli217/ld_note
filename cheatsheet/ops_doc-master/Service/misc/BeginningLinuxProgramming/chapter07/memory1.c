#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#define A_MEGABYTE (1024 * 1024)

///-----------------------------------------------------------
//	申请空间，然后使用空间，释放空间
///----------------------------------------------------------
int main(void) 
{
    char *some_memory;
    int  megabyte = A_MEGABYTE;
    int exit_code = EXIT_FAILURE;

    some_memory = (char *)malloc(megabyte);
    if (some_memory != NULL) 		//这是很重要的一步
    {
        sprintf(some_memory, "Hello World\n");
        printf("%s", some_memory);
		 free(some_memory);
        exit_code = EXIT_SUCCESS;
    }
    exit(exit_code);
}

