#include<stdio.h>
#include<stdlib.h>
#include<netinet/in.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<pthread.h>
#include<string.h>
#define  SERVER_ADDR  "192.168.90.137"
#define PORT	10000

char name[20]={};	//用户昵称
int sockfd=0;		//通信socket
void init(void);	//初始化客户端
void *recv_client(void*);	//建立线程和服务器接收,发送消息
void send_client(void );	//发送函数
void send_client(void )		//发送函数
{
	printf("请输入您想要使用的昵称: ");
	fgets(name,20,stdin);
	if(strlen(name)==19&&name[18]!='\n')
	{
		scanf("%*[^\n]");
		scanf("%*c");
	}
	else
		name[strlen(name)-1]='\0';
	pthread_t tid=0;
	pthread_create(&tid,NULL,recv_client,NULL);
	while(1)
	{
		char temp[980]={};
		char buf[1000]={};
		fgets(temp,980,stdin);
		if(strlen(name)==979&&name[978]!='\n')
		{
			scanf("%*[^\n]");
			scanf("%*c");
		}
		else
			temp[strlen(temp)-1]='\0';
		sprintf(buf,"%s: %s",name,temp);
		send(sockfd,buf,strlen(buf),0);
		if(!strcmp(strstr(buf," ")+1,"bye"))
			break;
	}
	close(sockfd);
	exit(0);
}
void *recv_client(void *p)		//建立线程和服务器接收,发送消息
{
	while(1)
	{
		char buf[1000]={};
		recv(sockfd,buf,sizeof(buf),0);
		if(!strncmp(buf,name,strstr(buf,":")-buf))
			continue;
		printf("%s\n",buf);
	}
}
void init(void)		//初始化客户端
{
	sockfd=socket(AF_INET,SOCK_STREAM,0);
	struct sockaddr_in	addr={};
	addr.sin_family=AF_INET;
	addr.sin_port=htons(PORT);
	addr.sin_addr.s_addr=inet_addr(SERVER_ADDR);
	int res=connect(sockfd,(struct sockaddr*)&addr,sizeof(addr));
	if(-1==res)
		perror("连接服务器失败"),exit(-1);
	send_client();
}
void fa(int signo)
{
	char buf[1000]={};
	sprintf(buf,"%s: %s",name,"bye");
	send(sockfd,buf,strlen(buf),0);
	close(sockfd);
	exit(0);
}
int main(void)
{
	signal(2,fa);
	init();	
	return 0;
}
