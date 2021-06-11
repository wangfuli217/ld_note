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
		/*������ִ����execlp��ʱ�������printf�Ͳ�ִ���ˣ���Ϊ���������Լ��Ŀռ�
		�ÿռ�������Ŀռ䲻һ��*/
		execlp("ls", "ls", "-al", 0);
		printf("Done.\n");
		exit(0);
	 }
	else
	{
		printf("Error \n");
	}	
}
