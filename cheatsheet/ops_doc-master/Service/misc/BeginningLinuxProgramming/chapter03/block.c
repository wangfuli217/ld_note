#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>

//----------------------------------------------------
//�����ݴ�һ���ļ���������һ���ļ�
//��õķ���Ӧ����ֱ�ӵ���Linux��ָ��
//����ֱ�ӵ��ļ����ƹ���
//	
//�ó���д�Ĺ��ڼ򵥣�����ˣ������ļ���
//�쳣��û��һ��Ӧ��
//
//
//----------------------------------------------------

int main(void)
{
	char block[1024]; 
	int in, out; 
	int nread;
	int cnt;
	//O_CREAT���ļ������ڵ�����£��������ļ�
	//��ȡ�ļ������ļ��Ķ�ȡ���ڵ���0��ʱ��
	//�Ը��ļ��Ķ�ȡ����ȷ�ģ������Ǵ����
	//
	//
	//�ļ��Ķ�ȡ��O_RDONLY����ò�Ҫ��������... ... 
   	in = open("file.in", O_RDONLY); 
	if(in < 0)
	{
		printf("@@@@@@@@@@@@@@@@\n");
		return 1;
	}
	
   	out = open("file.out", O_WRONLY|O_CREAT, S_IRUSR|S_IWUSR);
	if(out < 0)
	{
		printf("@@@@@@@@@@@@@@@@\n");
		close( in );
		return 2;
	}
	cnt = 0;
	//��ǰ���ļ���ȡ��ʧ�ܵ�
	//�ļ���ȡʧ�ܵ�ʱ�򣬷���ֵ��-1
	//��ȡ�ɹ���ʱ������ֵ�Ǵ��ڵ���0
	//����ֵ��ʾ���ζ�ȡ���ݵĶ��� 0��ʾ��ȡ����
    while((nread = read(in,block,sizeof(block))) > 0)
	{
		write(out,block,nread);
		printf("cnt=%d	nread=%d	in=%d  out=%d\n",cnt,nread,in,out);
		cnt++;
	}

	close( in );
	close( out );
	//printf("cnt=%d	nread=%d\n	in=%d\n",cnt,nread,in);

    return (0);
}

