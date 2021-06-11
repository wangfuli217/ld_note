//基于TCP协议的服务器
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>

int main(void)
{
	//创建socket,使用socket函数
	int sockfd=socket(AF_INET,SOCK_STREAM,0);
	if(sockfd==-1)
		perror("socket"),exit(-1);
	printf("创建socket成功\n");
	//准备通信地址,使用结构体类型
	struct sockaddr_in  addr={};
	addr.sin_family=AF_INET;
	addr.sin_port=htons(8888);
	addr.sin_addr.s_addr=inet_addr("192.168.90.110");
	//绑定socket和通信地址,使用bind
	int res=bind(sockfd,(struct sockaddr *)&addr,sizeof(addr));
	if(-1==res)
		perror("bind"),exit(-1);
	printf("绑定成功\n");
	//监听,使用listen函数
	res=listen(sockfd,2);
	if(res==-1)
		perror("listen"),exit(-1);
	printf("监听成功\n");
	//响应客户端的连接,accept函数
	struct sockaddr_in	rcvAddr;
	socklen_t len=sizeof(rcvAddr);
	int fd=accept(sockfd,(struct sockaddr *)&rcvAddr,&len);
	if(-1==fd)
		perror("accept"),exit(-1);
	printf("响应客户端成功\n");
	//进行通信,使用read/write函数
	char buf[100]={};
	res=read(fd,buf,sizeof(buf));
	if(-1==res)
		perror("read"),exit(-1);
	printf("客户端发来的数据是: %s\n数据大小是: %d\n",buf,res);
	res=write(fd,"I received!",12);
	if(-1==res)
		perror("write"),exit(-1);
	printf("发送给客户端的数据大小是:%d\n",res);
	//关闭socket,使用close函数
	close(sockfd);
	close(fd);
	return 0;
}
