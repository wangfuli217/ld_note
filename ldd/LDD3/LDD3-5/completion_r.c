#include <unistd.h>
#include <stdio.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>

int main()
{
	int completiontest;
	int count;

	if ((completiontest = open("/dev/completion", O_RDONLY )) < 0){
		 printf("open error! \n"); 
		exit(1);
	}

	if ((count=read(completiontest , NULL , 0)) < 0 )
		printf("read error! count=%d \n",count);
	else
		printf("read ok! count=%d \n",count);

	close(completiontest);

	exit(0);
}
