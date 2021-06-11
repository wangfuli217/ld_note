#include <stdlib.h>

#define ONE_K (1024)

int main(void)
{
	char *some_memory;
	int exit_code = EXIT_FAILURE;

	some_memory = (char *)malloc(ONE_K);
	if (some_memory != NULL)
	{
		free(some_memory);
		some_memory=NULL;
		exit_code = EXIT_SUCCESS;
	}
	exit(exit_code);
}
