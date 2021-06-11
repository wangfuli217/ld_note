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

#define ERR_EXIT(m)\
	do\
    {\
		perror(m);\
		exit(EXIT_FAILURE);\
    }while(0)

#define	ARGV_MAX_LEN (40) 

mqd_t mq_create(const char *name, int flag, mode_t mode, struct mq_attr *attr);
mqd_t mq_getInfo(mqd_t mqdes, struct mq_attr *attr);
mqd_t mq_setInfo(mqd_t mqdes, struct mq_attr *newattr,struct mq_attr * oldattr);
mqd_t mq_recvmsg(const char* mq_name, unsigned prio);

int main(int argc, char *argv[])
{

	int mqid;
	int opt;
	int reslt;
	char argv_tmp[ARGV_MAX_LEN+1];
	struct mq_attr newattr,oldattr;
	argv_tmp[0] = '/';
	while((opt = getopt(argc,argv,"c:s:g:d:w:r:")) != -1)
	{
		switch(opt)
		{
			case 'c':
				strcpy(&argv_tmp[1],optarg);
				mqid = mq_create(argv_tmp,O_RDWR,0666,NULL);
				break;
			case 'd':
				strcpy(&argv_tmp[1],optarg);
				reslt = mq_unlink(argv_tmp);
				if(reslt == -1)
				{
					ERR_EXIT("mq_unlink error\n");
				}
				break;
			case 's':
				break;
			case 'g':
				strcpy(&argv_tmp[1],optarg);
				mqid = mq_open(argv_tmp,O_RDONLY);
				if(mqid == -1)
				{
					ERR_EXIT("mq_open -g error\n");
				}
				reslt = mq_getInfo(mqid,&oldattr);
				break;
			case 'r':
				strcpy(&argv_tmp[1],optarg);
				mq_recvmsg(argv_tmp,0);
				break;
			case 'w':
				strcpy(&argv_tmp[1],optarg);
				mq_sendmsg(argv_tmp,0);
				break;
			default:
				ERR_EXIT("opt error\n");
				break;
		}
	
	}
	if(mqid != 0)
		close(mqid);
	return 0;
}
mqd_t mq_create(const char *name, int flag, mode_t mode, struct mq_attr *attr)
{
	mqd_t mqid;
	mqid = mq_open(name,flag |O_CREAT,mode,attr);
	if(mqid == -1)
	{
		ERR_EXIT("mq_open error\n");
	}
	return mqid;
}
mqd_t mq_getInfo(mqd_t mqdes, struct mq_attr *attr)
{
	mqd_t ret;
	ret = mq_getattr(mqdes,attr);
	if(ret == -1)
	{
		ERR_EXIT("mq_getattr error\n");
	}
	printf("mq_maxmsg = %ld, mq_msgsize = %ld, mq_curmsgs = %ld\n",attr->mq_maxmsg,attr->mq_msgsize,attr->mq_curmsgs);
	return ret;
}
mqd_t mq_setInfo(mqd_t mqdes, struct mq_attr *newattr,struct mq_attr * oldattr)
{
	mqd_t ret;

	return ret;
}
mqd_t mq_sendmsg(const char * mq_name,unsigned prio)
{
	mqd_t ret;
	mqd_t mqid;
	mqid = mq_open(mq_name,O_WRONLY);
	if(mqid == -1)
	{
		ERR_EXIT("mq_sendmsg mq_open error\n");
	}
	printf("sendmsg len =%d\n",strlen(mq_name));
	ret = mq_send(mqid,mq_name,strlen(mq_name),prio);
	if(ret == -1)
	{
		ERR_EXIT("mq_sendmsg mq_send error\n");
	}
	close(mqid);

	return ret;
}
mqd_t mq_recvmsg(const char* mq_name, unsigned prio)
{
	mqd_t ret;
	mqd_t mqid;
	char buf[ARGV_MAX_LEN+1]={0};
	struct mq_attr attr;
	mqid = mq_open(mq_name,O_RDONLY);
	if(mqid == -1)
	{
		ERR_EXIT("mq_recvmsg mq_open error\n");
	}
	ret = mq_getattr(mqid,&attr);
	if(ret == -1)
	{
		ERR_EXIT("mq_recvmsg getattr error\n");
	}
	ret = mq_receive(mqid,buf,attr.mq_msgsize,NULL);
	if(ret == -1)
	{
		close(mqid);
		ERR_EXIT("mq_recvmsg mq_receive error\n");
	}
	fprintf(stdout,"Got message: %s\n",buf);
	close(mqid);
	return ret;
}
