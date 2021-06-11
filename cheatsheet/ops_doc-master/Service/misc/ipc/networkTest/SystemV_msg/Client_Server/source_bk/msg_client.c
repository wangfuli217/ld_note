/*************************************************************************
	> File Name: msg_client.c
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Tue 01 Mar 2016 02:51:38 PM CST
 ************************************************************************/

#include "msg_cs.h"
int main(int argc, char **agrv)
{
	struct msgbuf *msgbufptr;
	pid_t pid;
	int msqid =0;
	int reslt =0;
	key_t msg_key;
	int connected =0;
	pid_t server_pid;
	int connCount=0;
	char * client_text = "I am client\n";
	char *pwork=NULL;
	int send_msg_len;
	
	pid = getpid();
	msgbufptr = (struct msgbuf *) malloc(sizeof(long) +MSGMAX);
	while(fgets(msgbufptr->mtext+sizeof(pid_t),MSGMAX,stdin) != NULL)
	{
		pwork = msgbufptr->mtext+sizeof(pid);
		send_msg_len = strlen(pwork);
		if(strlen(pwork) >0)
		{
			if(pwork[strlen(pwork)-1] == '\n')
			{
				pwork[strlen(pwork)-1] ='\0';
			}

		}
		while(connected == 0)
		{
			msqid = msgget(SERVICE_MSG_KEY,0666);
			if(msqid == -1 && errno == ENOENT)
			{
				if(connCount++ < 5)
				{
					continue;
				}
				else 
				{
					free(msgbufptr);
					ERR_EXIT("client msgget timeout\n");
				}
			}
			else if(msqid == -1 && errno != ENOENT)
			{
				free(msgbufptr);
				ERR_EXIT("client msgget error\n");
			}
			msgbufptr->mtype = 1;
			*(pid_t *)msgbufptr->mtext = pid;
			reslt = msgsnd(msqid,msgbufptr,sizeof(pid_t)+send_msg_len,0);
			if(reslt == -1)
			{
				free(msgbufptr);
				ERR_EXIT("client msgsnd error\n");

			}
			usleep(400);
			msqid = msgget((key_t)pid,0666);
			if(msqid == -1 )
			{
				free(msgbufptr);
				ERR_EXIT("client the second msgget  error\n");

			}
			connected = 1;	
			memset(msgbufptr->mtext+sizeof(pid_t),0,send_msg_len);
			reslt = msgrcv(msqid,msgbufptr,MSGMAX,0,0);
			if(reslt < 0 )
			{
				free(msgbufptr);
				ERR_EXIT("newconnect get first message error\n");
			}
			server_pid = *(pid_t *)msgbufptr->mtext;

			printf("pid :%u , msg : %s\n",*(pid_t *)msgbufptr->mtext,msgbufptr->mtext+sizeof(pid_t));

		}//end while(connected == 0)
		if(connected == 1)
		{//
			connected ++;
			continue;//重新输入新数据
		}

		msgbufptr->mtype =pid;
		*(pid_t *)msgbufptr->mtext = pid;
		reslt = msgsnd(msqid,msgbufptr,sizeof(pid_t)+strlen(msgbufptr->mtext+sizeof(pid_t)),0);
		if(reslt == -1)
		{
			free(msgbufptr);
			ERR_EXIT("new connect send msg error\n");

		}
		memset(msgbufptr->mtext,0,send_msg_len);
//		printf("aaaaaaaaaaaaaaaaaaaaa\n");


		reslt = msgrcv(msqid,msgbufptr,MSGMAX,server_pid,0);
		printf("client get msg len: %d\n",reslt);
//		printf("bbbbbbbbbbbbbbbbbbbbbb\n");
		if(reslt < 0)
		{
			free(msgbufptr);
			ERR_EXIT("new connect rcv msg error\n");
		}
		msgbufptr->mtext[reslt] ='\0';
//		printf("mypid = %u\n",getpid());
		printf("server Pid : %u, msg:%s\n",*(pid_t *)msgbufptr->mtext,msgbufptr->mtext+sizeof(pid_t));
		
	}
	return 0;
}
