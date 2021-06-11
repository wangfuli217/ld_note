/*************************************************************************
	> File Name: msg_getIPC_perm.c
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Mon 29 Feb 2016 06:09:22 PM CST
 ************************************************************************/

#include <stdio.h>
#include <unistd.h>
#include <sys/ipc.h>
#include <sys/types.h>
#include <sys/msg.h>
#include <errno.h>
#include <stdlib.h>

#define ERR_EXIT(m) \
	do \
	{\
		perror(m);\
		exit(EXIT_FAILURE);\
	}while(0)

int main(int argc, char ** argv)
{
	int msgid;
	int msg_op_reslt =0;
	char msg_del_flag ;
	struct msqid_ds buf;	
	int key=(int) IPC_PRIVATE;
	if(argc < 2)
	{
		ERR_EXIT("main function agrv error \n");
	}
	key = atoi(argv[1]);

	msgid = msgget((key_t)key,IPC_CREAT|0666);
	if(msgid == -1)
	{
		ERR_EXIT("msgget error\n");
	}
    msg_op_reslt =  msgctl(msgid,IPC_STAT,&buf);
	if(msg_op_reslt == -1)
	{
		ERR_EXIT("msgctl_stat error\n");
	}
	printf("__msg_cbytes : %u,__key : %u\n,mode : %o\n",buf.__msg_cbytes,buf.msg_perm.__key,buf.msg_perm.mode);
	sscanf("0664","%o",&buf.msg_perm.mode);
	msg_op_reslt = msgctl(msgid,IPC_SET,&buf);
	if(msg_op_reslt == -1)
	{
		ERR_EXIT("IPC_SET error\n");
	}

	msg_op_reslt = msgctl(msgid,IPC_STAT,&buf);
	if(msg_op_reslt == -1)
	{
		ERR_EXIT("IPC_STAT error\n");
	}
	printf("__msg_cbytes : %u,__key : %u\n,mode : %o\n",buf.__msg_cbytes,buf.msg_perm.__key,buf.msg_perm.mode);
	printf("delete msg 'y' or 'n' :");
	scanf("%c",&msg_del_flag);
	if(msg_del_flag == 'y' || msg_del_flag == 'Y')
	{
		msg_op_reslt = msgctl(msgid,IPC_RMID,NULL);
		if(msg_op_reslt == -1)
		{
			ERR_EXIT("IPC_STAT error\n");
		}
	}
	return 0;


}
