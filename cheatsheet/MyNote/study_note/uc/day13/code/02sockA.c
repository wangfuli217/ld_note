//基于socket的本地通信
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<string.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<sys/un.h>
int main(void)
{
	//创建socket,使用socket函数
	int sockfd=socket(AF_UNIX,SOCK_DGRAM,0);
	if(-1==sockfd)
		perror("socket"),exit(-1);
	printf("创建socket成功\n");
	//准备通信地址,使用结构体类型
	struct sockaddr_un addr;
	addr.sun_family=AF_UNIX;
	strcpy(addr.sun_path,"a.sock");
	//绑定socket和通信地址,使用bind函数
	int res=bind(sockfd,(struct sockaddr *)&addr,sizeof(addr));
	if(-1==res)
		perror("bind"),exit(-1);
	//进行通信,使用read/write函数
	char buf[100]={};
	res=read(sockfd,buf,sizeof(buf));
	if(-1==res)
		perror("read"),exit(-1);
	printf("读取客户端发来的数据是:%s,数据大小是:%d\n",buf,res);
	//关闭socket,使用close函数
	close(sockfd);
	return 0;
}
