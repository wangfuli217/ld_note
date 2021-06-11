#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<signal.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
//定义全局变量,保存socket描述符
int sockfd;
void fa(int signo)
{
	printf("正在关闭服务器,请稍后...\n");
	sleep(2);
	close(sockfd);
	printf("关闭服务器成功\n");
	exit(0);
}

int main(void)
{
	//创建socket,使用socket函数
	sockfd=socket(AF_INET,SOCK_STREAM,0);
	if(-1==sockfd)
		perror("socket"),exit(-1);
	printf("创建socket成功\n");
	//准备通信地址,作用结构体
	struct sockaddr_in	addr={};
	addr.sin_family=AF_INET;
	addr.sin_port=htons(8888);
	addr.sin_addr.s_addr=inet_addr("192.168.90.110");
	//解决重新运行时地址被占用的问题
	int reuseaddr=1;
	setsockopt(sockfd,SOL_SOCKET,SO_REUSEADDR,&reuseaddr,sizeof(reuseaddr));
	//绑定socket和通信地址,bind函数
	int res=bind(sockfd,(struct sockaddr *)&addr,sizeof(addr));
	if(-1==res)
		perror("bind"),exit(-1);
	printf("绑定成功\n");
	//监听,使用listen函数
	res=listen(sockfd,10);
	if(-1==res)
		perror("listen"),exit(-1);
	printf("监听成功\n");
	//采用信号关闭服务器
	signal(SIGINT,fa);
	//不断地响应客户端连接
	printf("服务器初始化成功,等待客户端连接,关闭服务器请按ctrl+c...\n");
	while(1)
	{
		struct sockaddr_in rcvAddr={};
		socklen_t  len=sizeof(rcvAddr);
		int fd=accept(sockfd,(struct sockaddr*)&rcvAddr,&len);
		if(fd==-1)
			perror("accept"),exit(-1);
		printf("客户端%s已连接\n",inet_ntoa(rcvAddr.sin_addr));
		//采用多进程同时响应多个客户端fork
		pid_t pid=fork();
		if(-1==pid)
			perror("fork"),exit(-1);
		if(0==pid)	//子进程
		{
			//针对每一个客户端不断地通信
			while(1)
			{
				char buf[100]={};
				res=read(fd,buf,sizeof(buf));
				if(-1==res)
					perror("read"),exit(-1);
				if(!strcmp(buf,"bye"))
				{
					printf("客户端%s已下线\n",inet_ntoa(rcvAddr.sin_addr),buf);
					break;
				}
				printf("%s %s\n",inet_ntoa(rcvAddr.sin_addr),buf);
				res=write(fd,"I received!",12);
				if(-1==res)
					perror("write");
			}
			close(fd); //关闭socket,然后终止进程
			exit(0);
		}
	}
	return 0;
}
