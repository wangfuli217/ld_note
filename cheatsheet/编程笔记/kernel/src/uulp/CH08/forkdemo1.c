/*  forkdemo1.c
 *	shows how fork creates two processes, distinguishable
 *	by the different return values from fork()
 */

#include	<stdio.h>
#include	<stdlib.h>
#include	<string.h>
#include	<unistd.h>
#include	<fcntl.h>

int main()
{
//	int	ret_from_fork, mypid;
//
//	mypid = getpid();			   /* who am i?  	*/
//	printf("Before: my pid is %d\n", mypid);   /* tell the world	*/
//
//	ret_from_fork = fork();
//
//	sleep(1);
//	printf("After: my pid is %d, fork() said %d\n",
//			getpid(), ret_from_fork);
	
	int fd, pid;
	FILE * fp;
	char *msg1 = "test 1..\n";
	char *msg2 = "hello, world\n";

	if ((fp = fopen("testfile", "w")) == NULL) {
		return 0;
	}
	fprintf(fp, "%s", msg1);
	if ((pid = fork()) == -1) {
		return 0;
	}
	fprintf(fp, "%s SS", msg2);
	fclose(fp);
	
//	for ( int i = 0; i < 10; i += 1 ) {
//		printf("still here \n");
//		sleep(1);
//	}
		return 1;
}

