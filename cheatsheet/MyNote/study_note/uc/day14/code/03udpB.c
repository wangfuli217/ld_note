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
	int sockfd=socket(AF_INET,SOCK_DGRAM,0);
	if(-1==sockfd)
		perror("sockfd"),exit(-1);
	printf("创建socket成功\n");
	struct sockaddr_in addr={};
	addr.sin_family=AF_INET;
	addr.sin_port=htons(6666);
	addr.sin_addr.s_addr=inet_addr("192.168.90.110");
//	int res=connect(sockfd,(struct sockaddr *)&addr,sizeof(addr));
//	if(-1==res)
//		perror("bind"),exit(-1);
//	int	res=write(sockfd,buf,strlen(buf));
	int res=sendto(sockfd,"hello",5,0,(struct sockaddr*)&addr,sizeof(addr));
	if(-1==res)
		perror("write"),exit(-1);
	printf("发送成功\n");
	close(sockfd);
	return 0;
}
