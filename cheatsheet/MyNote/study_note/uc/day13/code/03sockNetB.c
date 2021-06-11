#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>

int main(void)
{
	int sockfd=socket(AF_INET,SOCK_DGRAM,0);
	if(-1==sockfd)
		perror("socket"),exit(-1);
	printf("创建socket成功\n");
	struct sockaddr_in addr;
	addr.sin_family=AF_INET;
	addr.sin_port=htons(8888);
	addr.sin_addr.s_addr=inet_addr("");
	int res=connect(sockfd,(struct sockaddr*)&addr,sizeof(addr));
	if(res==-1)
		perror("bind"),exit(-1);
	char buf[100]="周俊华是SB";
	res=write(sockfd,buf,sizeof(buf));
	if(res==-1)
		perror("write"),exit(-1);
	close(sockfd);
}
