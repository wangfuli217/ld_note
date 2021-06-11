/************************************************************************* 
 *  > File Name: client_server.c > Author: liujizhou > Mail: jizhouyou@126.com 
	> Created Time: Wed 16 Mar 2016 01:50:48 PM CST
 ************************************************************************/
#ifndef CS_P2P_H
#define CS_P2P_H

#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <string.h>
#include <netinet/in.h>
#include <signal.h>
#include <errno.h>
#include <netinet/ip.h>
#include <stdlib.h>
#include <unistd.h>
#define ERR_EXIT(m)\
	do \
	{\
		perror(m);\
		exit(EXIT_FAILURE);\
	}while(0)

#define  MAX_BUF   (200)
#define  SERVER_FLAG  (1)
#define  CLIENT_FLAG (2)
typedef struct package
{
	size_t len;
	char buf[MAX_BUF];
}package_t;

void server(void);
void client(void);
void server_child_do_service(int sock);
void server_sigusr1_handler(int);
void client_sigusr1_handler(int);
ssize_t readn(int fd,void * recvbuf,size_t len);
ssize_t writen(int fd,const void *sendbuf,size_t len);
#endif

