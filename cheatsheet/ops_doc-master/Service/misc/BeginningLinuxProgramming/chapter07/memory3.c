#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#define ONE_K (1024)

///------------------------------------------------------------
//	当申请的内存足够多，而不进行释放的时候，
//	操作系统就会将该进程杀掉，
///------------------------------------------------------------
int main(void) 
{
	char *some_memory;
	int  size_to_allocate = ONE_K;
	int  megs_obtained = 0;
	int  ks_obtained = 0;

	while (1) 
	{
		for (ks_obtained = 0; ks_obtained < 1024; ks_obtained++)
		{
			some_memory = (char *)malloc(size_to_allocate);
			if (some_memory == NULL) exit(EXIT_FAILURE);
			sprintf(some_memory, "Hello World");
		}
			megs_obtained++;
			printf("Now allocated %d Megabytes\n", megs_obtained);
	}
	exit(EXIT_SUCCESS);
}
