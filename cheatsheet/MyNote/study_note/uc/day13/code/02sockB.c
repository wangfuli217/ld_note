#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<sys/un.h>
int main(void)
{
	//创建socket,使用socket函数
	int sockfd=socket(AF_UNIX,SOCK_DGRAM,0);
	if(-1==sockfd)
		perror("sockfd"),exit(-1);
	printf("socket创建成功\n");
	//准备通信地址,服务器的地址
	struct sockaddr_un addr;
	addr.sun_family=AF_UNIX;
	strcpy(addr.sun_path,"a.sock");
	//连接socket和通信地址,connect
	int res=connect(sockfd,(struct sockaddr*)&addr,sizeof(addr));
	if(-1==res)
		perror("bind"),exit(-1);
	char buf[100]="slkdfjlkdsjflkds";
	res=write(sockfd,buf,sizeof(buf));
	if(res==-1)
		perror("write"),exit(-1);
	close(sockfd);
	return 0;
}
