#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <signal.h>
#include <string.h>
#include <stdlib.h>
#define FIFO_SERVER "/tmp/fifoserver"
main(int argc,char** argv)
//参数为即将写入的字节数
{
    int fd;
    char w_buf[4096*2];
    int real_wnum;
    memset(w_buf,0,4096*2);
    if(mkfifo(FIFO_SERVER,O_CREAT|O_EXCL)<0)
       if (errno == EEXIST)
			printf("create fifoserver EEXIST\n");
	   else
			printf("cannot create fifoserver\n");
			
	signal(SIGPIPE, SIG_IGN);
	sleep(10);
    fd=open(FIFO_SERVER,O_WRONLY|O_NONBLOCK,0);
    if(fd==-1)
        if(errno==ENXIO)
			{printf("open error; no reading process\n"); exit(1);}
    //设置非阻塞标志
    //fd=open(FIFO_SERVER,O_WRONLY,0);
    //设置阻塞标志
    real_wnum=write(fd,w_buf,2048);
    if(real_wnum==-1)
    {
        if(errno==EAGAIN)
            printf("write to fifo error; try later\n");
    }
    else 
        printf("real write num is %d\n",real_wnum);
    sleep(4);
	real_wnum=write(fd,w_buf,5000);
    //5000用于测试写入字节大于4096时的非原子性
    //real_wnum=write(fd,w_buf,4096);
    //4096用于测试写入字节不大于4096时的原子性
     
    printf("write num=%d\n", real_wnum);
    if(real_wnum==-1)
        if(errno==EAGAIN)
            printf("try later\n");
	pause();
	return 0;
}
