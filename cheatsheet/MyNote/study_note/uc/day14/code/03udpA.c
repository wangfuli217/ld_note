//基于UDP通信模型的服务器
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
	int sockfd=socket(AF_INET,SOCK_DGRAM,0);
	if(-1==sockfd)
		perror("socket"),exit(-1);
	printf("创建socket成功\n");
	//准备通信地址,使用结构体
	struct sockaddr_in addr;
	addr.sin_family=AF_INET;
	addr.sin_port=htons(6666);
	addr.sin_addr.s_addr=inet_addr("192.168.90.110");
	//绑定socket和通信地址,bind函数
	int res=bind(sockfd,(struct sockaddr*)&addr,sizeof(addr));
	if(-1==res)
		perror("bind"),exit(-1);
	printf("绑定成功\n");
	//进行通信
	char buf[100]={0};
	res=read(sockfd,buf,sizeof(buf));
	if(-1==res)
		perror("read"),exit(-1);
	printf("客户端发来的消息是:%s\n",buf);
	//关闭socket,使用close函数
	close(sockfd);
	return 0;
}
