//psxmq_send.c

#include <mqueue.h>
#include <stdbool.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>    
#include <time.h>   
#include <errno.h>
#include <string.h>

#define MAXSIZE 1024
int main(int argc,char**argv)
{
    if(argc!=2)
    {
    printf("Usage: %s /mqname \r\n",argv[0]);
    return -1;
    }
    char Msg[MAXSIZE]="Hello World";
    char *name = argv[1];
    int flags = O_RDWR | O_CREAT | O_EXCL | O_NONBLOCK ;
    mode_t mode = S_IRUSR | S_IWUSR| S_IRGRP |S_IROTH;
    //set mq_attr
    struct mq_attr attr;
    attr.mq_flags=O_NONBLOCK;
    attr.mq_maxmsg=10;
    attr.mq_msgsize=sizeof(Msg);
    attr.mq_curmsgs=0;

    mqd_t mqid = mq_open(name,flags,mode,&attr);
    if(mqid==-1)
    {
        printf("error %s (%d)\r\n",strerror(errno),errno);
        return -1;
    }
	if(mq_getattr(mqid,&attr)==-1)
	{
		printf("get attr error\r\n");
	}
	sleep(20);
	printf("flags:%d msgsize:%d maxmsg=%d curmsgs:%d", attr.mq_flags, attr.mq_msgsize, attr.mq_maxmsg, attr.mq_curmsgs);
    int i;
    for(i=0;i<20;i++)
    {
        if(mq_send(mqid,Msg,strlen(Msg),i)==-1)
        {
            perror("mq_send error");
            return -1;
        }
    }
    mq_close(mqid);
    return 0;
}
