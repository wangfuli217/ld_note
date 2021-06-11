//psxmq_recv.c

#include <mqueue.h>
#include <stdbool.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>    
#include <time.h>      
#include <errno.h>
#include <string.h>

int main(int argc,char**argv)
{
    if(argc !=2)
    {
        printf("Usage: %s /mqname \r\n",argv[0]);
        return -1;
    }
    const int MAXSIZE =1024;
    char RecvBuff[MAXSIZE];
    int prio;
    ssize_t n;
    char* name  = argv[1];
    int   flags = O_RDONLY;

    memset(RecvBuff,0x00,sizeof(RecvBuff));
    mqd_t mqid = mq_open(name, flags);

    struct mq_attr attr;
    if(mqid==-1)
    {
        printf("error %s (%d)\r\n",strerror(errno),errno);
        return -1;
    }
    while(true)
    {
        if(mq_getattr(mqid,&attr)==-1)
        {
            printf("get attr error\r\n");
            break;
        }
		printf("flags:%d msgsize:%d maxmsg=%d curmsgs:%d", attr.mq_flags, attr.mq_msgsize, attr.mq_maxmsg, attr.mq_curmsgs);
        if(attr.mq_curmsgs==(long)0)
        {
            printf("no messages in queue\r\n");
            break;
        }

        if((n=mq_receive(mqid,RecvBuff,sizeof(RecvBuff),&prio))==-1)
        {
            perror("mq_receive error");
            return -1;
        }
        printf("read %ld bytes\r\n",(long)n);
        printf("prio is %d\r\n",prio);
        printf("%s \r\n",RecvBuff);
    }
    mq_close(mqid);
    mq_unlink(name);
    return 0;
}
