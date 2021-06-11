#include <stdio.h>
#include <unistd.h>
//#include <sys/types.h>
//#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>

int daemon( int nochdir,  int noclose )
{
	pid_t pid;
	if ( !nochdir && chdir("/") != 0 ) //���nochdir=0,��ô�ı䵽"/"��Ŀ¼
		return -1;

	if ( !noclose ) //���û��noclose��־
	{
		int fd = open("/dev/null", O_RDWR);
		if ( fd  <  0 )
		return -1;

		/* �ض����׼���롢��������� ��/dev/null��
			���̵����뽫�Խ������κ�Ӱ�죬���̵����Ҳ����������ն�
		*/
//		dup2(fd, 0);
//		dup2(fd, 1);
//		dup2(fd, 2);
//		close(fd);
	}

   pid = fork();  //�����ӽ���.
   if (pid  <  0)  //ʧ��
	  return -1;

   if (pid > 0)
	   exit(0); //����ִ�е��Ǹ�����,��ô�������˳�,���ӽ��̱�������Ĺ¶�����.

	//������ daemon�ӽ���ִ�е�������
   if ( setsid()  < 0 )   //�����µĻỰ����ʹ���ӽ��̳�Ϊ�»Ự����ͷ����
	  return -1;

   return 0;  //�ɹ�����daemon�ӽ���
}

int main()
{
	printf("start pgrp = %d, pgid = %d, pid = %d, sid = %d.\n", getpgrp(), getpgid(getpid()), getpid(), getsid(getpid()));

	daemon(0,0);

	printf("enddd pgrp = %d, pgid = %d, pid = %d, sid = %d.\n", getpgrp(), getpgid(getpid()), getpid(), getsid(getpid()));

	while(1)
	{
		printf("sleep...\n");
		sleep(10);
	}

	return 0;
}
