#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define FIFO_SERVER "/tmp/fifoserver"
main(int argc,char** argv)
{
    char r_buf[4096*2];
    int  fd;
    int  r_size;
    int  ret_size;
    r_size=atoi(argv[1]);
    printf("requred real read bytes %d\n",r_size);
    memset(r_buf,0,sizeof(r_buf));
    fd=open(FIFO_SERVER,O_RDONLY,0);
    //fd=open(FIFO_SERVER,O_RDONLY,0);
    //在此处可以把读程序编译成两个不同版本：阻塞版本及非阻塞版本
    if(fd==-1){
        printf("open %s for read error\n");
        exit(1); 
    }
    while(1){
        printf("real read bytes ...\n");
        memset(r_buf,0,sizeof(r_buf));
        ret_size=read(fd,r_buf,r_size);
        if(ret_size==-1){
            if(errno==EAGAIN)
                printf("no data avlaible\n");
            printf("read errno:%d(%s)\n", errno, strerror(errno));
		}
        printf("real read bytes %d\n",ret_size);
        sleep(1);
    }   
    pause();
    unlink(FIFO_SERVER);
}
