/*************************************************************************
	> File Name: mq_tools.c
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Tue 08 Mar 2016 10:53:15 AM CST
 ************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <mqueue.h>
#include <string.h>
#include <error.h>
#include <signal.h>

#define ERR_EXIT(m)\
	do\
    {\
		perror(m);\
		exit(EXIT_FAILURE);\
    }while(0)

#define	ARGV_MAX_LEN (40) 
size_t msg_size=0;
int mqid = 0;
struct sigevent sigev;
void signal_handler1(int signal_val)
{
	char buf[ARGV_MAX_LEN]={0};
	int reslt;
	if(signal_val == SIGUSR1)
	{
		mq_notify(mqid,&sigev);	
		reslt = mq_receive(mqid,buf,msg_size,NULL);
		printf("notify get message : %s\n",buf);
	}
}

int main(int argc, char *argv[])
{

	
	int rslt;
	struct mq_attr attr;	
	if(argc !=2 )
	{
		ERR_EXIT("argv error\n");
	}
	mqid = mq_open(argv[1],O_RDONLY);
	if(mqid == -1)
	{
		ERR_EXIT("mq_open error\n");
	}
	mq_getattr(mqid,&attr);
	msg_size = attr.mq_msgsize;
	signal(SIGUSR1,signal_handler1);
	sigev.sigev_notify = SIGEV_SIGNAL;
	sigev.sigev_signo = SIGUSR1;
	mq_notify(mqid,&sigev);
	while(getchar() != EOF)
	{

	}

	return 0;
}
