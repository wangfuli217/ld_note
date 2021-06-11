关键字：tcp/ip     udp/ip
	基于tcp协议的通信模型
	tcp协议和udp协议的比较
	基于udp协议的通信模型

/*基于tcp协议的通信模型 一般用于一对多 需要listen函数排队*/
通信模型
	服务器：
		1. 创建socket，使用socket函数；
		2. 准备通信地址，使用结构体类型；
		3. 绑定socket和通信地址，使用bind函数；
		4. 监听，使用listen函数；
		5. 响应客户端的连接请求，使用accept函数；
		6. 进行通信，使用send/recv函数；
		7. 关闭socket，使用close函数；
	客户端：
		1. 创建socket，使用socket函数；
		2. 准备通信地址，使用服务器的地址；
		3. 连接socket和通信地址，使用connect函数；
		4. 进行通信，使用send/recv函数
		5. 关闭socket，使用close函数；

相关函数的解析
1. listen()函数			listen for connections on a socket
       #include <sys/types.h>          /* See NOTES */
       #include <sys/socket.h>

       int listen(int sockfd, int backlog);

第一个参数：socket描述符，socket函数的返回值

第二个参数：主要用于指定待决定的连接队列的最大长度
		（也就是已经发送连接请求，但没有来得及响应的最大数量）

函数功能：
	主要用于监听指定socket上的连接请求，当调用该函数后，该函数会将sockfd所指向的socket标记为被动socket，
		所谓的被动socket就是专门用于使用accept函数接收即将到来的连接请求，也就是不能用来通信了；


2. accept()函数			accept a connection on a socket
       #include <sys/types.h>          /* See NOTES */
       #include <sys/socket.h>

       int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);

第一个参数：socket描述符，socket函数的返回值

第二个参数：结构体指针，用于带出接收的客户端通信地址

第三个参数：指针类型，用于带出通信地址 地址的大小

返回值：成功返回用于通信的socket描述，失败返回-1；

函数功能:
	主要用于提取listen函数标记的socket中，未决定的队列中的第一个连接请求处理，
		创建一个新的socket用于和接收的客户端进行通信，该socket并不会处于监听的状态；


3. send()函数			send a message on a socket
       #include <sys/types.h>
       #include <sys/socket.h>

       ssize_t send(int sockfd, const void *buf, size_t len, int flags);

第一个参数：socket描述符，accept函数的返回值

第二个参数：具体的缓冲区首地址（存放即将发送的数据内容）

第三个参数：即将发送的数据大小

第四个参数：发送的标志，默认给0即可

返回值：成功返回实际发送的数据大小，失败返回-1；

函数功能：
	主要用于将指定的消息发送到指定的socket上


4. recv()函数			receive a message from a socket
       #include <sys/types.h>
       #include <sys/socket.h>

       ssize_t recv(int sockfd, void *buf, size_t len, int flags);

第一个参数：socket描述符，accept函数的返回，主动的socket

第二个参数：缓冲区的首地址，用于存放接收到的消息

第三个参数：期望接收的数据大小

第四个参数：具体的接收方式，默认给0即可

返回值：成功返回实际接收的数据大小，失败返回-1；
	当对方关闭时，该函数的返回值为0；

函数功能：
	主要用于从指定的socket上接收指定的消息；

//基于tcp协议的通信模型  服务器
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<arpa/inet.h>

int main()
{
	//1.创建socket，使用socket函数
	//2.准备通信地址，使用结构体类型
	//3.绑定socket和通信地址，使用bind函数
	//4.监听，使用listen函数
	//5.响应客户端的连接请求，使用accept函数
	//6.进行通信，使用send/recv函数
	//7.关闭socket 使用close函数

	int sockfd=socket(AF_INET,SOCK_STREAM,0);
	if(-1==sockfd)
	{
		perror("socket"),exit(-1);
	}
	printf("创建socket成功\n");
//-------------------------------------------
	struct sockaddr_in addr;
	addr.sin_family=AF_INET;
	addr.sin_port=htons(8888);
	addr.sin_addr.s_addr=inet_addr("172.16.1.182");
//--------------------------------------------
	int res=bind(sockfd,(struct sockaddr*)&addr,sizeof(addr));
	if(-1==res)	//建立服务器的地址172.16.1.182
	{
		perror("bind"),exit(-1);
	}
	printf("绑定成功\n");
//--------------------------------------------
	res=listen(sockfd,100);
	if(-1==res)
	{
		perror("listen"),exit(-1);
	}
	printf("监听成功\n");
//-------------------------------------------
	//准备两个变量作为函数的实参
	struct sockaddr_in recv_addr;
	socklen_t len=sizeof(recv_addr);
	
	int fd=accept(sockfd,(struct sockaddr*)&recv_addr,&len);
	if(-1==fd)	   //接收发进来信息的客户端地址
	{
		perror("accept"),exit(-1);
	}
	//将结构体类型的ip地址转换为字符串类型(结构体内部就是整数类型的ip地址)
	char *ip=inet_ntoa(recv_addr.sin_addr);
	printf("客户端%s连接成功\n",ip);
//-----------------`--------------------------
	char buf[100]={0};
	res=recv(fd,buf,sizeof(buf),0);
	if(-1==res)
	{
		perror("recv"),exit(-1);
	}
	printf("客户端发来的消息是：%s,消息大小是：%d\n",buf,res);
	//向客户端回发消息（建立了连接知道了客户端的IP才能回发信息）
	res=send(fd,"I received!",12,0);
	if(-1==res)
	{
		perror("send"),exit(-1);
	}
	printf("成功发送消息到客户端，发送的消息大小：%d\n",res);
//----------------------------------------------
	res=close(fd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	res=close(sockfd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭socket\n");
	return 0;
}



//基于tcp协议的通信模型  客户端
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<arpa/inet.h>

int main()
{
	//1.创建socket，使用socket函数
	//2.准备通信地址，使用服务器的地址
	//3.连接socket和通信地址，使用connect函数
	//4.进行通信，使用send/recv函数
	//5.关闭socket，使用close函数
	
	int sockfd=socket(AF_INET,SOCK_STREAM,0);
	if(-1==sockfd)
	{
		perror("socket"),exit(-1);
	}
	printf("创建socket描述符\n");
//-------------------------------------------
	struct sockaddr_in addr;
	addr.sin_family=AF_INET;
	addr.sin_port=htons(8888);
	addr.sin_addr.s_addr=inet_addr("172.16.1.180");
//-----------------------------------------------
	int res=connect(sockfd,(struct sockaddr*)&addr,sizeof(addr));
	if(-1==res)           //连接172.16.1.180的服务器地址
	{
		perror("connect"),exit(-1);
	}
	printf("连接成功\n");
//-------------------------------------------------
	res=send(sockfd,"锁",6,0);
	if(-1==res)
	{
		perror("send"),exit(-1);
	}
	printf("成功发送数据到服务器，发送的数据大小是：%d\n",res);
	char buf[100]={0};
	res=recv(sockfd,buf,sizeof(buf),0);
	if(-1==res)
	{
		perror("res"),exit(-1);
	}
	printf("服务器发来的消息是%s，消息大小：%d\n",buf,res);
//----------------------------------------------------
	res=close(sockfd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭socket\n");

	return 0;
}




练习:使用基于tcp协议的通信模型实现一对多的通信：
	1. 要求服务器可以不断的响应客户端的连接请求
		=> 使用无限循环
	2. 要求服务器可以同时和多个客户端通信
		=> 使用fork函数创建子进程来实现和客户端的通信
	3. 要求服务器和每个客户端都可以不断的通信；
		=> 使用无限循环
	4. 当客户端发来"bye"时，表示客户端已下线；
		=> 使用strcmp函数比较，终止对应的子进程
	5. 要求服务器不停地工作，直到用户按下ctrl+C
		=> 使用singnal函数实现对SIGINT的自定义处理


//基于tcp通信模型一对多的服务器   服务器
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#include<signal.h>

//定义全局变量来记录用于响应的socket描述符
int sockfd;


void fa(int signo)
{
	printf("正在关闭服务器，请稍后...\n");
	sleep(3);
	
	//7.关闭socket，使用close函数
	int res=close(sockfd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	printf("关闭服务器成功\n");
	exit(0);//终止进程
}

int main()
{
	//1.创建socket，使用socket函数
	//2.准备通信地址，使用结构体类型
	//3.绑定socket和通信地址，使用bind函数
	//4.监听，使用listen函数
	//5.不断的响应客户端的连接请求，使用accept函数
	//6.针对每个客户端进行不断的通信，send/recv函数
	//7.关闭socket，使用close函数

	sockfd=socket(AF_INET,SOCK_STREAM,0);
	if(-1==sockfd)
	{
		perror("socket"),exit(-1);
	}
	printf("创建socket成功\n");
//--------------------------------------------
	struct sockaddr_in addr;
	addr.sin_family=AF_INET;
	addr.sin_port=htons(8888);
	addr.sin_addr.s_addr=inet_addr("172.16.1.182");

	//实现地址可以被立即重复使用的效果
	//解决地址被占用的问题
	int reuseaddr=1;
	setsockopt(sockfd,SOL_SOCKET,SO_REUSEADDR,&reuseaddr,sizeof(int));

//--------------------------------------------------
	int res=bind(sockfd,(struct sockaddr*)&addr,sizeof(addr));
	if(-1==res)		//建立服务器地址 172.16.1.182
	{
		perror("bind"),exit(-1);
	}
	printf("绑定成功\n");
//----------------------------------------------
	res=listen(sockfd,100);
	if(-1==res)
	{
		perror("listen"),exit(-1);
	}
	printf("监听成功\n");
//------------------------------------------------
	//设置对信号SIGINT进行自定义处理
	if(SIG_ERR==signal(SIGINT,fa))
	{
		perror("signal"),exit(-1);
	}
	printf("关闭服务器请按ctrl+C...\n");

//------------------------------------------------
	while(1)
	{
		//准备两个变量作为accept函数的实参
		struct sockaddr_in recv_addr;
		socklen_t len=sizeof(recv_addr);
	
		int fd=accept(sockfd,(struct sockaddr*)&recv_addr,&len);
		if(-1==fd)	 //接受发送信息的客户端的地址
		{
			perror("accept"),exit(-1);
		}
		char *ip=inet_ntoa(recv_addr.sin_addr);
		printf("客户端%s连接成功\n",ip);
		//创建子进程实现和该客户端通信
		pid_t pid=fork();
		if(-1==pid)
		{
			perror("fork"),exit(-1);
		}
		//子进程
		if(0==pid)
		{	
			//使用signal函数设置对信号2进行默认处理
			if(SIG_ERR==signal(SIGINT,SIG_DFL))
			{
				perror("signal"),exit(-1);
			}

			//关闭用于响应的socket
			res=close(sockfd);
			if(-1==res)
			{
				perror("close"),exit(-1);
			}

			//6.针对每个客户端进行不断的通信，send/recv函数
			while(1)
			{
				//接收客户端发来的消息
				char buf[200]={0};
				res=recv(fd,buf,sizeof(buf),0);
				if(-1==res)
				{
					perror("recv"),exit(-1);
				}
				printf("客户端%s发来的消息：%s\n",ip,buf);
				
				//当客户端发来“bye”时，表示下线
				if(!strcmp(buf,"bye"))
				{
					printf("客户端%s已下线！\n",ip);
					break;//跳出无限循环
				}
				//向客户端回发消息
				res=send(fd,"I received!",12,0);
				if(-1==res)
				{
					perror("send"),exit(-1);
				}

			}
			//执行break之后跳到这里了
			//关闭用于通信的socket
			res=close(fd);
			if(-1==res)
			{
				perror("close"),exit(-1);
			}
			//终止当前子进程
			exit(0);

		}
		//在父进程中，关闭用于通信的socket
		res=close(fd);
		if(-1==res)
		{
			perror("close"),exit(-1);
		}	
	}
	return 0;
}


//基于tcp通信模型一对多的服务器    客户端
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#include<signal.h>
#include<string.h>


/*void fa(int signo)
{
	printf("正在关闭服务器，请稍后...\n");
	sleep(3);
	
	//7.关闭socket，使用close函数
	int res=close(sockfd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	printf("关闭服务器成功\n");
	exit(0);//终止进程
}*/

int main()
{
	//1.创建socket，使用socket函数
	//2.准备通信地址，使用结构体类型
	//3.连接socket和通信地址，使用connect函数
	//4.针对每个客户端进行不断的通信，send/recv函数
	//5.关闭socket，使用close函数

	int sockfd=socket(AF_INET,SOCK_STREAM,0);
	if(-1==sockfd)
	{
		perror("socket"),exit(-1);
	}
	printf("创建socket成功\n");
//--------------------------------------------
	struct sockaddr_in addr;
	addr.sin_family=AF_INET;
	addr.sin_port=htons(8888);
	addr.sin_addr.s_addr=inet_addr("172.16.1.180");
//--------------------------------------------------
	int res=connect(sockfd,(struct sockaddr*)&addr,sizeof(addr));
	if(-1==res)	      //连接到服务器地址172.16.1.180
	{
		perror("connect"),exit(-1);
	}
	printf("连接socket和通信地址成功\n");
//----------------------------------------------
	while(1)
	{
		char msg[200]={0};
		printf("请输入要发送的内容：\n");
		scanf("%s",msg);

		//将用户输入的信息发送给服务器
		res=send(sockfd,msg,strlen(msg)+1,0);
		if(-1==res)
		{
			perror("send"),exit(-1);
		}

		//当客户端发送的数据是bye，客户端下线
		if(!strcmp(msg,"bye"))
		{
			break;//结束通信
		}
		//接收服务器回发的消息并打印
		char buf[100]={0};
		res=recv(sockfd,buf,sizeof(buf),0);
		if(-1==res)
		{
			perror("recv"),exit(-1);
		}
		printf("服务器发来的消息是：%s\n",buf);
	}
	res=close(sockfd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭socket\n");
	return 0;
}






/*tcp协议和udp协议的比较*/
tcp协议的概念和特性
	tcp - 传输控制协议，是一种面向连接的协议，类似打电话；
	    - 建立连接 => 进行通信 => 断开连接
	    - 在通信的整个过程中全程保持连接；
	    - 该协议保证了数据传递的可靠性和有序性；
	    - 实现了流量的控制，避免数据发送方发送过多数据导致数据接收方缓冲区溢出；
	    - 属于全双工的字节流通信方式；

	    - 服务器压力比较大，资源消耗比较高，执行效率比较低

udp协议的概念和特性
	udp - 用户数据报协议，非面向连接的协议，类似写信
	    - 在通信的整个过程中不需要保持连接；
	    - 不保证数据传递的可靠性和有序性；
	    - 没有实现流量的控制；
	    - 属于全双工的数据报通信方式；
	    - 服务器压力比较小，资源消耗比较低，执行效率比较高


/*基于udp协议的通信模型（重点）*/
通信模型
	服务器：
		1. 创建socket，使用socket函数
		2. 准备通信地址，使用结构体类型
		3. 绑定socket和通信地址，使用bind函数；
		4. 进行通信，使用send/recv/...函数；recvfrom函数
		5. 关闭socket，使用close函数；
	客户端：
		1. 创建socket，使用socket函数；
		2. 准备通信地址，使用服务器地址；
		3. 进行通信，使用send/recv/...函数；sendto函数
		4. 关闭socket，使用close函数；


相关函数的解析
1. sendto()函数			send a message on a socket
       #include <sys/types.h>
       #include <sys/socket.h>

       ssize_t sendto(int sockfd, const void *buf, size_t len, int flags,
                      const struct sockaddr *dest_addr, socklen_t addrlen);


函数功能：
	主要用于将指定的消息发送到指定的目标地址上，其中前四个参数以及返回值和send函数完全一致，
		第五个参数用于指定收件人的通信地址信息，第六个参数用于指定通信地址的大小；


2. recvfrom()函数			receive a message from a socket
       #include <sys/types.h>
       #include <sys/socket.h>

       ssize_t recvfrom(int sockfd, void *buf, size_t len, int flags,
                        struct sockaddr *src_addr, socklen_t *addrlen);

函数功能：
	主要用于接收发来的消息，并保存消息发送方的通信地址，其中前四个参数以及返回值和recv函数完全一致，
		第五个参数用于保存消息发送方的通信地址，第六个参数用于保存通信地址的大小;

//基于udp协议的通信模型  接收数据  服务器
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>

int main()
{
	//1.创建socket，使用socket函数
	//2.准备通信地址，使用结构体类型
	//3.绑定socket和通信地址，使用bind函数
	//4.进行通信，使用recv/send/..函数
	//5.关闭socket，使用close函数

	int sockfd=socket(AF_INET,SOCK_DGRAM,0);
	if(-1==sockfd)
	{
		perror("socket"),exit(-1);
	}
	printf("创建socket成功\n");
//--------------------------------------
	struct sockaddr_in addr;
	addr.sin_family=AF_INET;
	addr.sin_port=htons(8888);
	addr.sin_addr.s_addr=inet_addr("172.16.1.182");
//---------------------------------------
	int res=bind(sockfd,(struct sockaddr*)&addr,sizeof(addr));
	if(-1==res)	  //建立服务器地址172.16.1.182
	{
		perror("bind"),exit(-1);
	}
	printf("绑定成功\n");
//-------------------------------------------
	char buf[100]={0};
	//res= recv(sockfd,buf,sizeof(buf),0);

	//准备两个变量作为函数的实参
	struct sockaddr_in recv_addr;
	socklen_t len= sizeof(recv_addr);
	res= recvfrom(sockfd,buf,sizeof(buf),0,(struct sockaddr*)&recv_addr,&len);
	if(-1==res)                            //发来信息的客户端的地址
	{
		perror("recvfrom"),exit(-1);
	}
	char *ip=inet_ntoa(recv_addr.sin_addr);
	printf("客户端发来的数据是%s，发来的数据大小：%d\n",buf,res);
	//向客户端回发消息
	res=sendto(sockfd,"I received!",12,0,(struct sockaddr*)&recv_addr,len);
	if(-1==res)
	{
		perror("sendto"),exit(-1);
	}
	
//----------------------------------------------
	res=close(sockfd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭socket\n");
	return 0;
}


//基于udp协议的通信模型  发送数据  客户端
#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>
#include<string.h>

int main()
{
	//1.创建socket，使用socket函数
	//2.准备通信地址，使用结构体类型
	//3.进行通信，使用recv/send/..函数
	//4.关闭socket，使用close函数

	int sockfd=socket(AF_INET,SOCK_DGRAM,0);
	if(-1==sockfd)
	{
		perror("socket"),exit(-1);
	}
	printf("创建socket成功\n");
//--------------------------------------
	struct sockaddr_in addr;
	addr.sin_family=AF_INET;
	addr.sin_port=htons(8888);
	addr.sin_addr.s_addr=inet_addr("172.16.1.182");
//---------------------------------------
	char buf[100]={0};
	printf("请发送消息：\n");
	scanf("%s",buf);
	//int res= send(sockfd,buf,strlen(buf)+1,0);
	int res= sendto(sockfd,buf,strlen(buf)+1,0,(struct sockaddr*)&addr,sizeof(addr));//向服务器地址172.16.1.182发信息
	if(-1==res)
	{
		perror("sendto"),exit(-1);
	}
	recv(sockfd,buf,sizeof(buf),0);
	printf("消息：%s",buf);
//----------------------------------------------
	res=close(sockfd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭socket\n");
	return 0;
}


作业：
	使用udp协议通信模型编写一个时间服务器，也就是只要服务器收到客户端发来消息，则将本机系统时间发送给客户端



