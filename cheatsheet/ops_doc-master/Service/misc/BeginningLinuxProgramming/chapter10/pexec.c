#include <unistd.h>
#include <stdio.h>

//execl(taskp->binpath, basename(taskp->binpath), NULL)
int main(void)
{
	int childid;
	int iRet;
    printf("Running ps with execlp\n");

	 childid = fork();
	 if(childid == 0)
	{
		 iRet = execlp("ps", "ps", "-e", 0);
		 if(iRet>0)
		{
			printf("PPID=%d  PID=%d\n",getppid(),getpid());
		 }
		 return 0;
	 }
	 else if(childid >0)
	{
		/*当程序执行了execlp的时候，下面的printf就不执行了，因为它自身开了自己的空间
		该空间和其他的空间不一样*/
		execlp("ls", "ls", "-al", 0);
		printf("Done.\n");
		exit(0);
	 }
	else
	{
		printf("Error \n");
	}	
}
