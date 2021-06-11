#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>

const char *lock_file = "/tmp/LCK.test2";

//*---------------------------------------------------------*//
//	如果创建成功该文件，则关闭该文件，然后删除该文件
//	如果创建失败文件，延迟3秒以后，重新试着创建
//	小心互锁
//*---------------------------------------------------------*//
int main(void)
{
	int file_desc;
	int tries = 20;

    while (tries--) 
	{	//如果该文件打开成功，就关闭该文件并删除该文件
		//如果该文件打开失败，就等待直到在规定的时间内打开该文件
		printf("tries =%d\n",tries);
		file_desc = open(lock_file, O_RDWR | O_CREAT | O_EXCL, 0444);
		if (file_desc == -1) 
		{
			 printf("%d - Lock already present\n", getpid());
			  sleep(3);
		}
		 else
		{
		            /* critical region */
		        printf("%d - I have exclusive access\n", getpid());
		        sleep(1);
		        (void)close(file_desc);
		        (void)unlink(lock_file);
		            /* non-critical region */
		        sleep(2);
		    }
	} /* while */
    exit(EXIT_SUCCESS);
}
