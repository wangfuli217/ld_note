/************************************************************************* 
 *  > File Name: client_server.c > Author: liujizhou > Mail: jizhouyou@126.com 
	> Created Time: Wed 16 Mar 2016 01:50:48 PM CST
 ************************************************************************/

#include "cs_p2p.h"


void server(void)
{
	int listensock;
	int ac_sock;
	int opt_on;
	int rslt;
	pid_t chld_pid;
	char sendbuf[MAX_BUF];
//	struct sockaddr s_addr;通用地址结构
	struct sockaddr_in s_addr;//server's IP socket addr
	struct sockaddr_in c_addr;//client' IP socket addr buf
	socklen_t c_addr_len = sizeof(c_addr);
	

	/********step 1 :创建套接字**************/
//	listensock = socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);//同下一句
	listensock = socket(AF_INET,SOCK_STREAM,0);
	if(listensock == -1)
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
	rslt = setsockopt(listensock,SOL_SOCKET,SO_REUSEADDR,&opt_on,sizeof(opt_on));//这句话能够解决地址重复利用的问题，必须在bind前设置
	if(rslt == -1)
	{
		ERR_EXIT("server setsocktopt error\n");
	}
	/********step 3 :将地址和套接字绑定**************/
	rslt = bind(listensock,(struct sockaddr *)&s_addr,sizeof(s_addr));
	if(rslt != 0)
	{
		ERR_EXIT("bind error\n");
	}


	/********step 4 :监听套接字,将套接字变为被动套接字,并不阻塞*****/
	rslt = listen(listensock,SOMAXCONN);
	if(rslt != 0 )
	{
		ERR_EXIT("listen error\n");
	}

		/********step 5 :接收连接，生成主动套接字**************/

	ac_sock = accept(listensock,(struct sockaddr *)&c_addr,&c_addr_len);
	if(ac_sock < 0)
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

		close(listensock);
		server_child_do_service(ac_sock);
	
	}
	else 
	{
		signal(SIGUSR1,server_sigusr1_handler);
		while(fgets(sendbuf,MAX_BUF-1,stdin)!=NULL)
		{
			rslt =write(ac_sock,sendbuf,strlen(sendbuf));
			if(rslt == -1)
			{
				ERR_EXIT("server parent write error");
			}
			memset(sendbuf,0,MAX_BUF);
		}
		
	}
		waitpid(chld_pid,NULL,0);
	
	/********step 7 :关闭套接口**************/
	close(listensock);
	close(ac_sock);//父进程释放同子进程共享的资源，只有子进程拥有
}

void server_sigusr1_handler(int sig)
{
	printf("server parent get sig %d\n",sig);
	printf("server parent exiting \n");
	exit(EXIT_SUCCESS);
}

void server_child_do_service(int sock)
{
	int rslt;
	char recvbuf[MAX_BUF];
	while(1)
	{
		memset(recvbuf,0,MAX_BUF);
		rslt = read(sock,recvbuf,MAX_BUF -1);
		if(rslt == 0|| rslt == -1)
		{
			break;
		}

		fprintf(stdout,"server recv msg :%s\n",recvbuf);
	}
	printf("server_child existing\n");
	close(sock);
	kill(getppid(),SIGUSR1);
	exit(EXIT_SUCCESS);//子进程在此一定要结束，否则也会accept
}
