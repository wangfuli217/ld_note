#include <unistd.h>
#include <limits.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <errno.h>
#include <string.h>
main(int argc,char**argv)
{
    int pipe_fd[2];
    pid_t pid;
    char r_buf[10000];
    char w_buf[65536*10];
    int writenum;
    int rnum;
    memset(r_buf,0,sizeof(r_buf));  
    if(pipe(pipe_fd)<0)
    {
        printf("pipe create error\n");
        return -1;
    }
	printf("PIPE_BUF=%d\n", PIPE_BUF);
     
    if((pid=fork())==0){
        close(pipe_fd[1]);
		//int flags = fcntl(pipe_fd[0], F_GETFL);
		//fcntl(pipe_fd[0], F_SETFL, flags|O_NONBLOCK);
        while(1)
        {
			sleep(1);   
			rnum=read(pipe_fd[0],r_buf,10000);
			if(rnum > 0) printf("child: readnum is %d\n",rnum);
			if(rnum == 0) {printf("child: parent had closed write side\n"); exit(0);}
			if(rnum == -1) printf("child: read errno:%d (%s)\n", errno, strerror(errno));
        }
        close(pipe_fd[0]);
         
        exit(0);
    }
    else if(pid>0){
		int flags = fcntl(pipe_fd[1], F_GETFL);
		fcntl(pipe_fd[1], F_SETFL, flags|O_NONBLOCK);

		close(pipe_fd[0]);//write
		memset(r_buf,0,sizeof(r_buf));  
		if((writenum=write(pipe_fd[1],w_buf,5536))==-1)
			printf("write to pipe error\n");
		else    
			printf("the bytes write to pipe is %d \n", writenum);
		writenum=write(pipe_fd[1],w_buf,6553);
		if(writenum > 0)printf("the bytes write to pipe is %d \n", writenum);
		if(writenum == -1) printf("write errno:%d (%s)\n", errno, strerror(errno));
		writenum=write(pipe_fd[1],w_buf,65536);
		if(writenum > 0)printf("the bytes write to pipe is %d \n", writenum);
		if(writenum == -1) printf("write errno:%d (%s)\n", errno, strerror(errno));
		writenum=write(pipe_fd[1],w_buf,65536);
		if(writenum > 0)printf("the bytes write to pipe is %d \n", writenum);
		if(writenum == -1) printf("write errno:%d (%s)\n", errno, strerror(errno));
		close(pipe_fd[1]);
		sleep(10);
    }   
}
/* 在向管道写入数据时，至少应该存在某一个进程，其中管道读端没有被关闭，否则就会出现SIGPIPE | EPIPE错误 */
