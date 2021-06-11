#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>

int main(void)
{
	int sockfd=socket(AF_INET,SOCK_STREAM,0);
	if(-1==sockfd)
		perror("sockfd"),exit(-1);
	struct sockaddr_in addr={};
	addr.sin_family=AF_INET;
	addr.sin_port=htons(8888);
	addr.sin_addr.s_addr=inet_addr("192.168.90.110");
	int res=connect(sockfd,(struct sockaddr *)&addr,sizeof(addr));
	if(-1==res)
		perror("bind"),exit(-1);
	char buf[100]="hello";
	res=write(sockfd,buf,strlen(buf));
	if(-1==res)
		perror("write"),exit(-1);
	printf("发送成功\n");
	return 0;
}
