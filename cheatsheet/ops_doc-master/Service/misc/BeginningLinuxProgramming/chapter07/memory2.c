#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>


#define A_MEGABYTE (1024 * 1024)

int main(void) 
{
    char *some_memory;
    size_t  size_to_allocate = A_MEGABYTE;    
    int  megs_obtained = 0;

	while (megs_obtained < 16) 
	{
		some_memory = (char *)malloc(size_to_allocate);
		if (some_memory != NULL)
		{
			megs_obtained++;
			sprintf(some_memory, "Hello World");
			printf("%s - now allocated %d Megabytes\n", some_memory, megs_obtained);
			free(some_memory);
			some_memory = NULL:
		}
		else 
		{
			exit(EXIT_FAILURE);
		}
	}
    exit(EXIT_SUCCESS);
}
