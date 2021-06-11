#include <stdlib.h>
#include <pthread.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include "semi_generic_llist.h"
#include "debug.h"

int main(int argc, const char *argv[])
{
	if(3!=argc){
		printf("Usage:<./client> <addr> <port>\n");
		exit(-1);
	}
	//准备sockfd
	int sockfd=socket(AF_INET,SOCK_STREAM,0);
	if(-1 == sockfd)
		err("socket");
	
	//准备地址
	struct sockaddr_in serAddr={0};
	serAddr.sin_family=AF_INET;
	serAddr.sin_port=htons(atoi(argv[2]));
	serAddr.sin_addr.s_addr=inet_addr(argv[1]);
	int len=sizeof(serAddr);

	//连接服务器
	int ret=connect(sockfd,(struct sockaddr*)&serAddr,len);
	if(-1 == ret)
		err("connect");
	while(1){
		printf(">");fflush(stdout);
		char buf[100]={0};
		fgets(buf,sizeof(buf),stdin);
		send(sockfd,buf,sizeof(buf),0);
		recv(sockfd,buf,sizeof(buf),0);
		printf("recv:%s\n",buf);
	}

	
	return 0;
}
























