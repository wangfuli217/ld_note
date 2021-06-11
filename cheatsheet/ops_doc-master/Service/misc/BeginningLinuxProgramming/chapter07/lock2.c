#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <errno.h>

const char *lock_file = "/tmp/LCK.test2";

//*---------------------------------------------------------*//
//	��������ɹ����ļ�����رո��ļ���Ȼ��ɾ�����ļ�
//	�������ʧ���ļ����ӳ�3���Ժ��������Ŵ���
//	С�Ļ���
//*---------------------------------------------------------*//
int main(void)
{
	int file_desc;
	int tries = 20;

    while (tries--) 
	{	//������ļ��򿪳ɹ����͹رո��ļ���ɾ�����ļ�
		//������ļ���ʧ�ܣ��͵ȴ�ֱ���ڹ涨��ʱ���ڴ򿪸��ļ�
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
