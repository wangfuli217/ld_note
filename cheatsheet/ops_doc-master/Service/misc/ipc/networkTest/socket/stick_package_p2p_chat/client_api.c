/************************************************************************* 
 *  > File Name: client_server.c > Author: liujizhou > Mail: jizhouyou@126.com 
	> Created Time: Wed 16 Mar 2016 01:50:48 PM CST
 ************************************************************************/

#include "cs_p2p.h"
void client_sigusr1_handler(int sig)
{
	printf("parent get sig %d\n",sig);
	exit(EXIT_SUCCESS);

}
void client(void)
{
	int csock;
	int rslt;
	int s_addr_len;
	pid_t pid;
	struct sockaddr_in s_addr;
//	char recvbuf[MAX_BUF],sendbuf[MAX_BUF];
	package_t pack;
	/********step 1 :创建套接口**************/
	csock = socket(AF_INET,SOCK_STREAM,0);
	if(csock == -1)
	{
		ERR_EXIT("client socket error\n");
	}

	/********step 2 :初始化套接地址**************/
	memset(&s_addr,0,sizeof(s_addr));
	s_addr.sin_family = AF_INET;
	s_addr.sin_port =htons(5899);
	s_addr.sin_addr.s_addr = inet_addr("127.0.0.1");

	/********step 3 :连接服务器**************/
	rslt = connect(csock,(struct sockaddr *)&s_addr,sizeof(s_addr));	  
	if(rslt == -1)
	{
		ERR_EXIT("client connect error\n");
	}
	pid = fork();
	if(pid == -1)
	{
		close(csock);
		ERR_EXIT("client fork error\m");
	}
	if(pid == 0)//client child process recv the message
	{
		while(1)
		{
			memset(&pack,0,MAX_BUF+sizeof(size_t));
			rslt = readn(csock,&pack.len,sizeof(size_t));
			pack.len = ntohl(pack.len);
			if(rslt < 4)
			{
				printf("server colosed \n");
				break;
			}
			else if(rslt == 0 || rslt ==-1)
			{
				printf("client read error \n");
				break;
			}
			rslt = readn(csock,pack.buf,pack.len);
			if(rslt < 4)
			{
				printf("server colosed \n");
				break;
			}
			else if(rslt == 0 || rslt ==-1)
			{
				printf("client read error \n");
				break;
			}
			printf("client get msg:%s\n",pack.buf);
		}
		close(csock);
		kill(getppid(),SIGUSR1);
		printf("client child exiting\n");
		exit(EXIT_SUCCESS);
	}
	else//client parent process send msg
	{
		signal(SIGUSR1,client_sigusr1_handler);
		
		memset(&pack,0,MAX_BUF+sizeof(size_t));
		while(fgets(pack.buf,MAX_BUF-1,stdin) != NULL)
		{
			pack.len = htonl(strlen(pack.buf));
			writen(csock,&pack,strlen(pack.buf)+sizeof(size_t));
			memset(&pack,0,MAX_BUF+sizeof(size_t));
		}
		close(csock);
		exit(EXIT_SUCCESS);
	}	
}
