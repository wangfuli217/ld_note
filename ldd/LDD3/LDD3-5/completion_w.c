#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>

int main()
{
	int completiontest;
	int count;

	if ((completiontest = open("/dev/completion", O_WRONLY )) < 0){
		 printf("open error! \n"); 
		exit(1);
	}

	if ((count=write(completiontest , NULL , 0)) < 0 )
		printf("write error! count=%d \n",count);
	else
		printf("write ok! count=%d \n",count);

	close(completiontest);

	exit(0);
}
