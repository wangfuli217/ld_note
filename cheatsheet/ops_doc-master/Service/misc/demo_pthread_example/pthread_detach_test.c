#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

void *PrintHello(void *args)
{
	pthread_detach(pthread_self());
	int stack[1024 * 20] = {0,};
	//sleep(1);
	//pthread_exit(NULL);
	return (void *)0;
}

int main (int argc, char *argv[])
{
	pthread_t pid;
	int rc;
	
	while (1) {
	
		rc = pthread_create(&pid, NULL, PrintHello, NULL);
		if (rc) {
			printf("ERROR; return code from pthread_create() is %d\n", rc);
			//exit(-1);
		}
		sleep(1);
	}

	printf(" main End - \n");
	pthread_exit(NULL);
}