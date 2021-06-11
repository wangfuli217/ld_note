#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#include<signal.h>

int listen_sockfd;
void fa(int signo)
{
	close(listen_sockfd);
	exit(0);
}
int main(void)
{
	signal(2,fa);
	listen_sockfd=socket(AF_INET,SOCK_STREAM,0);
	if(-1==listen_sockfd)
		perror("sockfd"),exit(-1);
	struct sockaddr_in server_addr={};
	server_addr.sin_family=AF_INET;
	server_addr.sin_port=htons(8888);
	server_addr.sin_addr.s_addr=inet_addr("192.168.90.110");
	int res=bind(listen_sockfd,(struct sockaddr*)&server_addr,sizeof(server_addr));
	if(-1==res)
		perror("bind"),exit(-1);
	res=listen(listen_sockfd,10);
	if(-1==res)
		perror("listen"),exit(-1);
	printf("服务器已经开始运行\n");
	printf("按ctrl+c结束运行\n");
	printf("正在等待连接\n");
	while(1)
	{
		struct sockaddr_in client_addr={};
		int client_len=sizeof(client_addr);
		int receive_sockfd=accept(listen_sockfd,(struct sockaddr*)&client_addr,&client_len);
		if(receive_sockfd==-1)
			perror("accept"),exit(-1);
		char *ip=inet_ntoa(client_addr.sin_addr);
		char *who=NULL;
		if(!strcmp(ip,"192.168.90.110"))
			ip="潘文剑";
		else if(!strcmp(ip,"192.168.90.67"))
			ip="李岸";
		printf("%s已连接\n",ip);
		pid_t pid=fork();
		if(pid==0)
		{
			pid_t pid1=fork();
			char buf[100]={};
			if(0==pid1)
			{
				while(1)
				{
					int res=read(receive_sockfd,buf,sizeof(buf));
					if(res==-1)
						perror("read"),exit(-1);
					buf[res]='\0';
					if(!strcmp(buf,"bye"))
						break;
					printf("%s:",ip);
					printf("%s\n",buf);
				}
			}
			else
			{
				while(1)
				{
					scanf("%s",buf);
					write(receive_sockfd,buf,strlen(buf));
				}
			}
			close(receive_sockfd);
			printf("%s已下线\n",ip);
			exit(0);
		}
	}
}
