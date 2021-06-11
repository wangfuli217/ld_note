#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>

//----------------------------------------------------
//将数据从一个文件拷贝到另一个文件
//最好的方法应该是直接调用Linux的指令
//进行直接的文件复制工作
//	
//该程序写的过于简单，造成了，对于文件的
//异常，没有一点应对
//
//
//----------------------------------------------------

int main(void)
{
	char block[1024]; 
	int in, out; 
	int nread;
	int cnt;
	//O_CREAT当文件不存在的情况下，创建该文件
	//读取文件，当文件的读取大于等于0的时候
	//对该文件的读取是正确的，否则是错误的
	//
	//
	//文件的读取用O_RDONLY，最好不要加其他的... ... 
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
	//当前的文件读取是失败的
	//文件读取失败的时候，返回值是-1
	//读取成功的时候，它的值是大于等于0
	//返回值表示本次读取数据的多少 0表示读取结束
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

