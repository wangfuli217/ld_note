/*************************************************************************
	> File Name: msg_server.c
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Tue 01 Mar 2016 06:48:05 PM CST
 ************************************************************************/

#include "msg_cs.h"
int main()
{
	pid_t pid;
	pid_t client_pid;
	struct msgbuf * msgbufptr = NULL;
	int timeout;
	int reslt =0;
	int msqid =0;
	int child_snd_rcv_done =0;
	msgbufptr = (struct msgbuf *) malloc(sizeof(long) + MSGMAX);
	msqid = msgget(SERVICE_MSG_KEY,IPC_CREAT|0666);
	printf("sizeof(pid_t):%d\n",sizeof(pid_t));
	if(msqid == -1)
	{
		free(msgbufptr);
		ERR_EXIT("server msgget error");
	}
	while(1)
	{
		reslt = msgrcv(msqid,msgbufptr,MSGMAX,0,0);
		if(reslt == -1)
		{
			free(msgbufptr);
			ERR_EXIT("server msgrcv error\n");

		}

		if((pid = fork())== 0)
		{//子进程处理
			client_pid = *(pid_t *)msgbufptr->mtext;
			msqid = msgget((key_t)client_pid,IPC_CREAT|0666);
			if(msqid == -1)
			{
				free(msgbufptr);
				ERR_EXIT("server child msgget error\n");
			}
			pid = getpid();
			timeout = SERVICE_TIMEOUT ;
			while(timeout >0)
			{
				if(child_snd_rcv_done ==0)
				{
					msgbufptr->mtype = pid;
					*(pid_t*) msgbufptr->mtext = pid;
					//strcpy(msgbufptr->mtext+reslt-1,"I got it\n");
					reslt = msgsnd(msqid,msgbufptr,sizeof(pid_t)+strlen(msgbufptr->mtext+sizeof(pid_t)),IPC_NOWAIT);

					if(reslt == -1 && errno == EAGAIN)
					{
						sleep(1);
						timeout--;
						continue;

					}
					else if(reslt == -1 && errno != EAGAIN)
					{
						msgctl(msqid,IPC_RMID,NULL);
						free(msgbufptr);
						ERR_EXIT(" server child snd msg error\n");

					}
					//printf("server echo pid = %u, msg = %s , server pid = %u \n",*(pid_t *)msgbufptr->mtext,msgbufptr->mtext+sizeof(pid_t),getpid());

					child_snd_rcv_done =1;
					timeout = SERVICE_TIMEOUT;
				}
				else
				{
					reslt = msgrcv(msqid,msgbufptr,MSGMAX,client_pid,IPC_NOWAIT);
					msgbufptr->mtext[reslt] = '\0';
					if(reslt == -1 && errno ==ENOMSG)
					{

						sleep(1);
						timeout --;
						printf("timeout is %d\n",timeout);
						continue;
					}
					else if(reslt == -1 && errno != ENOMSG)
					{
						msgctl(msqid,IPC_RMID,NULL);
						free(msgbufptr);
						ERR_EXIT("server child rcv msg error\n");
						
					}

					printf("server get message len :%d\n",reslt);
					child_snd_rcv_done = 0;
					timeout = SERVICE_TIMEOUT;

				}
				printf("%d\n",timeout);
			}
			if(timeout <=0)
			{

				msgctl(msqid,IPC_RMID,NULL);
				free(msgbufptr);
				ERR_EXIT("final server child time out error\n");

			}
		}
	}

}
