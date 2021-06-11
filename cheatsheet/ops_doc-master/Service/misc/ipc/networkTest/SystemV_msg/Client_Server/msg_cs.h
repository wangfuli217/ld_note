/*************************************************************************
	> File Name: msg_cs.h
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Tue 01 Mar 2016 02:52:38 PM CST
 ************************************************************************/

#ifndef __MSG_CS_H
#define __MSG_CS_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ipc.h>
#include <sys/types.h>
#include <sys/msg.h>
#include <unistd.h>
#include <errno.h>

#define ERR_EXIT(m) \
	do \
	{ \
		perror(m);\
		exit(EXIT_FAILURE); \
	}while(0)

#define MSGMAX (2048)
#define SERVICE_MSG_KEY (20)
#define SERVICE_TIMEOUT	(20)
#define ID_SIZE  (sizeof(pid_t))

struct msgbuf
{
	long mtype;
	char mtext[MSGMAX];
};

#endif
