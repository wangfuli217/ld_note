/*************************************************************************
	> File Name: create_msg.c
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Mon 29 Feb 2016 06:00:03 PM CST
 ************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>

#define ERR_EXIT(m) \
	do \
	{\
		perror(m);\
		exit(EXIT_FAILURE);\
	}while(0)

int main(int argc , char ** argv)
{
	int msgid;
	msgid = msgget(456, 0666 | IPC_CREAT);
	if(msgid == -1)
	{
		ERR_EXIT("msgget\n");
	}

	printf("msgget succ\n");
	return 0;
}
