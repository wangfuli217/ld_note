#include<stdio.h>
#include<unistd.h>
#include<sys/types.h>
int main(void)
{
	//pid_t =>int
	printf("pid=%d\n",getpid());
	printf("ppid=%d\n",getppid());
	//uid_t =>unsigned int
	printf("uid=%d\n",getuid());
	//gid_t =>unsigned int
	printf("gid=%d\n",getgid());
	return 0;
}
