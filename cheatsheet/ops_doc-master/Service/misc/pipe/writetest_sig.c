#include <unistd.h>
#include <signal.h>
#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
main()
{
    int pipe_fd[2];
    pid_t pid;
    char r_buf[4];
    char* w_buf;
    int writenum;
    int cmd;
     
    memset(r_buf,0,sizeof(r_buf));
    if(pipe(pipe_fd)<0){
        printf("pipe create error\n");
        return -1;
    }
    signal(SIGPIPE, SIG_IGN);
    if((pid=fork())==0){
        close(pipe_fd[0]);
        close(pipe_fd[1]);
        sleep(10);  
        exit(0);
    }
    else if(pid>0){
		sleep(1);  //等待子进程完成关闭读端的操作
		close(pipe_fd[0]);//write
		w_buf="111";
		if((writenum=write(pipe_fd[1],w_buf,4))==-1)
			printf("write to pipe error %d(%s)\n", errno, strerror(errno));
		else    
			printf("the bytes write to pipe is %d \n", writenum);
		 
		close(pipe_fd[1]);
    }   
}

/* 在向管道写入数据时，至少应该存在某一个进程，其中管道读端没有被关闭，否则就会出现SIGPIPE| EPIPE错误 */
