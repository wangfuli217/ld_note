/************************************************************************* 
 *  > File Name: client_server.c > Author: liujizhou > Mail: jizhouyou@126.com 
	> Created Time: Wed 16 Mar 2016 01:50:48 PM CST
 ************************************************************************/

#include <stdio.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <string.h>
#include <netinet/in.h>
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
void server(void);
void client(void);
void do_service(int sock);
int main(int argc , char * argv[])
{
	int rslt;
	int opt;
	int flag=0;
	if(argc != 2) 
	{
		ERR_EXIT("argv error");
	}
	while((opt = getopt(argc,argv,"cs")) != -1)
	{
		switch(opt)
		{
			case 'c':
				flag = CLIENT_FLAG;
				break;
			case 's':
				flag = SERVER_FLAG;
				break;
			default:
				printf("error agrv \n");
				break;
		}
	}
	if(flag == SERVER_FLAG)
	{
		server();
	}
	else if(flag == CLIENT_FLAG)
	{
		client();
	}
	
	return 0;
}

void server(void)
{
	int ssock;
	int ssock_ac;
	int opt_on;
	int rslt;
	pid_t chld_pid;
//	char recvbuf[MAX_BUF],sendbuf[MAX_BUF];
//	struct sockaddr s_addr;通用地址结构
	struct sockaddr_in s_addr;//server's IP socket addr
	struct sockaddr_in c_addr;//client' IP socket addr buf
	socklen_t c_addr_len = sizeof(c_addr);
	

	/********step 1 :创建套接字**************/
//	ssock = socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);//同下一句
	ssock = socket(AF_INET,SOCK_STREAM,0);
	if(ssock == -1)
	{
		ERR_EXIT("socket error\n");
	}
	

	/********step 2 :初始化地址**************/
	memset(&s_addr,0,sizeof(s_addr));
	s_addr.sin_family = AF_INET;
	s_addr.sin_port = htons(5899);
	//s_addr.sin_addr.s_addr = htonl(INADDR_ANY);//任意主机地址INADDR_ANY 为0
	//inet_aton("127.0.0.1",&s_addr.sin_addr.s_addr);//同下一句
	s_addr.sin_addr.s_addr = inet_addr("127.0.0.1");

	opt_on = 1;	
	rslt = setsockopt(ssock,SOL_SOCKET,SO_REUSEADDR,&opt_on,sizeof(opt_on));//这句话能够解决地址重复利用的问题，必须在bind前设置
	if(rslt == -1)
	{
		ERR_EXIT("server setsocktopt error\n");
	}
	/********step 3 :将地址和套接字绑定**************/
	rslt = bind(ssock,(struct sockaddr *)&s_addr,sizeof(s_addr));
	if(rslt != 0)
	{
		ERR_EXIT("bind error\n");
	}


	/********step 4 :监听套接字,将套接字变为被动套接字,并不阻塞*****/
	rslt = listen(ssock,SOMAXCONN);
	if(rslt != 0 )
	{
		ERR_EXIT("listen error\n");
	}

	while(1)
	{
		/********step 5 :接收连接，生成主动套接字**************/

		ssock_ac = accept(ssock,(struct sockaddr *)&c_addr,&c_addr_len);
		if(ssock_ac < 0)
		{
			ERR_EXIT("accept error\n");
		}


		/********step 6 :对新套接字进行操作**************/
		chld_pid = fork();
		if(chld_pid == -1)
		{
			ERR_EXIT("server fork error\n");
		}
		if(chld_pid == 0)
		{

			close(ssock);
			do_service(ssock_ac);
			exit(EXIT_SUCCESS);//子进程再次一定要结束，否则也会accept
		}
		
		/********step 7 :关闭套接口**************/
		close(ssock_ac);//父进程释放同子进程共享的资源，只有子进程拥有
	}
	close(ssock);
}
void do_service(int sock)
{
	int rslt;
	char recvbuf[MAX_BUF],sendbuf[MAX_BUF];
	while(1)
	{
		memset(recvbuf,0,MAX_BUF);
		memset(sendbuf,0,MAX_BUF);
		rslt = read(sock,recvbuf,MAX_BUF -1);
		if(rslt == 0|| rslt == -1)
		{
			break;
		}

		fprintf(stdout,"server received msg :%s",recvbuf);
		write(sock,recvbuf,rslt);
	}
	close(sock);
}
void client(void)
{
	int csock;
	int rslt;
	int s_addr_len;
	struct sockaddr_in s_addr;
	char recvbuf[MAX_BUF],sendbuf[MAX_BUF];
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
	memset(recvbuf,0,MAX_BUF);
	memset(sendbuf,0,MAX_BUF);
	while(fgets(sendbuf,MAX_BUF-1,stdin) != NULL)
	{
		write(csock,sendbuf,strlen(sendbuf));
		fprintf(stdout,"client send msg:%s\n",sendbuf);
		read(csock,recvbuf,MAX_BUF-1);
		fprintf(stdout,"client recv  msg:%s\n",recvbuf);
		memset(recvbuf,0,MAX_BUF);
		memset(sendbuf,0,MAX_BUF);

	}
}
