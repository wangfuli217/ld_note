#include<stdio.h>
#include<string.h>
#include<pthread.h>
#include<stdlib.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#define  SERVER_ADDR  "192.168.90.137"
#define  SOCK_INVALID	 -1
#define PORT 10000
typedef struct
{
	int id;
	int sock;
}Client_Info;
Client_Info client_info[100]={};		//保存客户端信息
int pos=0;		//上面数组的下标
int listen_sock=0;    //监听socket

void init(void);		//服务初始化
void accept_client(void);	//响应客户端连接请求
void deal(void);				//为每一个连接上服务器的客户端建立一个线程
void *pthread_deal(void*);		//每一个线程的处理函数
void fa(int sino);				//信号2处理函数
void fa(int sino)				//信号2处理函数
{
	close(listen_sock);	
	printf("服务器已关闭\n");
	exit(0);
}
void *pthread_deal(void* p)			//每一个线程的处理函数
{
	int Pos=pos-1;
	int i=0;
	while(1)
	{
		char buf[1000]={ };
		int size=recv(client_info[Pos].sock,buf,sizeof(buf),0);
		if(!strcmp(strstr(buf," ")+1,"bye"))
		{
			char name[20]={};
			strncpy(name,buf,strstr(buf,":")-buf);
			sprintf(buf,"客户端: %s 已下线",name);
			size=1000;
			for(i=0;i<pos;i++)
				if(client_info[i].sock!=SOCK_INVALID)
					send(client_info[i].sock,buf,size,0);
			break;
		}
		for(i=0;i<pos;i++)
			if(client_info[i].sock!=SOCK_INVALID)
				send(client_info[i].sock,buf,size,0);
	}
	close(client_info[Pos].sock);
	client_info[Pos].sock=SOCK_INVALID;
	pthread_exit(0);
}
void deal(void)					//为每一个连接上服务器的客户端建立一个线程
{
	pthread_t  tid=0;
	pthread_create(&tid,NULL,pthread_deal,NULL);
}
void accept_client(void)		//响应客户端连接请求
{
	struct sockaddr_in	client_addr={};
	int client_len=sizeof(client_addr);
	int receive_sock=accept(listen_sock,(struct sockaddr*)&client_addr,&client_len);
	if(-1==receive_sock)
		perror("accept"),exit(-1);
	client_info[pos].id=client_addr.sin_addr.s_addr;
	client_info[pos++].sock=receive_sock;
	deal();
}
void init(void)		//服务器初始化
{
	signal(2,fa);
	listen_sock=socket(AF_INET,SOCK_STREAM,0);
	if(-1==listen_sock)
		perror("服务器初始化失败"),exit(-1);
	struct sockaddr_in server_addr={};
	server_addr.sin_family=AF_INET;
	server_addr.sin_port=htons(PORT);
	server_addr.sin_addr.s_addr=inet_addr(SERVER_ADDR);
	int res=bind(listen_sock,(struct sockaddr*)&server_addr,sizeof(server_addr));
	if(-1==res)
		perror("bind"),exit(-1);
	printf("服务器初始化成功并开始运行,按ctrl+c结束服务器\n");
}
int main(void)
{
	init();
	listen(listen_sock,100);
	while(1)
	{
		accept_client();
	}
	return 0;
}
