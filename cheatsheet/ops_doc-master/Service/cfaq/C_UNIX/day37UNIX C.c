关键字：
	网络相关的基本常识  IP地址 子网掩码 端口号 字节号
	基于socket的一对一通信模型  socket()bind()connect()htons()inet_addr()


/*网络相关的基本常识*/
目前主流的网络通讯软件有：QQ 微信 飞信 

七层网络协议模型和常用的网络协议
1. 七层网络协议模型
	ISO将数据的传递从逻辑上划分为以下七层：
		应用层：将具体的数据内容传递给应用程序，如：QQ等；
		表示层：将数据内容按照统一的格式进行打包和封装；
		会话层：控制对话何时开始，何时终止等；
		传输层：进行错误检查和重新排序等；
		网络层：选择具体的网络协议进行再次打包和发送；
		数据链路层：将具体的数据包转换为高低电平信号；
		物理层：具体的交换机设备等物理设备；

2. 常用的网络协议
	1. tcp协议 - 传输控制协议，是一种面向连接的协议，类似于打电话；
		Transmission Control Protocol 
	2. udp协议 - 用户数据报协议，是一种非面向连接的协议，类似写信；
		User Datagram Protocol
	3. ip协议 - 互联网协议，是上述两种协议的底层协议；

IP地址和子网掩码（重点）
1. IP地址
	IP地址 - 本质就是互联网中的唯一地址标识；
	IP地址本质上就是一个由32位二进制组成的整数（ipv4）,当然也有128位二进制组成的整数（ipv6） 
	日常生活中采用点分十进制表示法来描述IP地址，也就是将每一个字节的二进制位转换为十进制的整数，不同的整数之间采用小数点分隔；
	如：0x01020304 => 1.2.3.4

	为了便于IP地址的管理，将IP地址分为两部分：网络地址 + 主机地址，根据网络地址和主机地址位数的不同分为以下4类：
	A类：0 + 7 位网络地址 + 24 位主机地址
	B类：10 + 14 位网络地址 + 16 位主机地址
	C类：110 + 21 位网络地址 + 8 位主机地址
	D类：1110 + 28 位多播地址

查看IP地址的方法：
	window系统中：在dos窗口中使用ipconfig命令来查看IP地址信息；
	linux系统中：在终端中使用ifconfig命令来查看IP地址信息，如果该命令不好使，则使用/sbin/ifconfig命令即可；


2. 子网掩码
	主要用于划分IP地址中的网络地址和主机地址，也可以用于判断两个IP地址是否在同一个局域网中，具体的划分方法为：
	IP地址 & 子网掩码 = 网络地址；
	如：
	       IP地址：	172.30.100.64
	     子网掩码：	255.255.255.0  &
	------------------------------------
			172.30.100 - 网络地址
				64 - 主机地址	

练习：判断以下两个IP地址是否在同一个局域网中？ 	是
	IP地址：166.111.160.1 和 166.111.161.45
 	子网掩码都是：255.255.254.0
解析：
     IP地址：166.111.160.1		//A66FA001
   子网掩码：255.255.254.0  &		//FFFFFE00
-----------------------------------
             166.111.160  - 网络地址  A66FA000
                       1  - 主机地址

     IP地址：166.111.161.45		//A66FA12D
   子网掩码：255.255.254.0  &		//FFFFFE00
-----------------------------------
             166.111.160  - 网络地址
                     1.45 - 主机地址


3. 端口号和字节序
	1. 端口号
		IP地址 - 定位到具体的某一台主机/设备上；
		端口号 - 定位到主机/设备上的某一个进程；
		网络编程中需要提供两个信息：IP地址+端口号
		端口号本质上就是unsigned short 类型，范围是：0～65535，其中 0～1024 之间的端口号被系统占用，建议从 1025 开始使用；

	2. 字节序
		小端系统：主要指将低位字节数据保存在低位内存地址的系统 //低对低
		大端系统：主要指将低位字节数据保存在高位内存地址的系统 //低对高

			如：0x12345678
		小端系统按照内存地址从小到大：0x78 0x56 0x34 0x12
		大端系统按照内存地址从小到大：0x12 0x34 0x56 0x78
	
		主机字节序 低位字节数据保存在低位内存地址 小端系统的字节序
		网络字节序 低位字节数据保存在高位内存地址 大端系统的字节序

一般性原则：
	一般来说，将所有发送到网络中的多字节整数/*先转换为网络字节序再发送*/，而将所有从网络中接收过来的多字节整数，
		先转换为主机字节序再解析，其中网络字节序本质就是大端系统的字节序；
	
	如：
		小端系统：0x78 0x56 0x34 0x12 => 0x12 0x34 0x56 0x78
		
	   当数据接收方为小端系统时：
	   	0x12 0x34 0x56 0x78 => 0x78 0x56 0x34 0x12 => 0x12345678
	   当数据接收方为大端系统时：
	       	0x12 0x34 0x56 0x78 => 0x12 0x34 0x56 0x78 => 0x12345678

验证大端系统还是小端系统
#include <stdio.h>
int main(void){
    int n=1;
    printf(*(char *)&n ? "小端\n" : "大端\n");
    return 0;
}

/*基于socket的一对一通信模型*/
基本概念
	socket 本意为"插座"，在这里指用于通信的逻辑载体；
通信模型
	服务器：
		1. 创建socket，使用socket函数；
		2. 准备通信地址 ，使用结构体类型；
		3. 绑定socket和通信地址，使用bind函数；
		4. 进行通信，使用read/write函数；
		5. 关闭socket，使用close函数；
	客户端：
		1. 创建socket，使用socket函数；
		2. 准备通信地址，使用服务器的地址；
		3. 连接socket和通信地址，使用connect函数；
		4. 进行通信，使用read/write函数；
		5. 关闭socket，使用close函数；

相关函数的解析
1. socket()函数			create an endpoint for communication
       #include <sys/types.h>          /* See NOTES */
       #include <sys/socket.h>

       int socket(int domain, int type, int protocol);

第一个参数：域/协议族，决定了是本地通信还是网络通信   AF（address family）

       Name                Purpose                          Man page
       AF_UNIX, AF_LOCAL   Local communication              unix(7)
	本地通信（同一主机内的通信）

       AF_INET             IPv4 Internet protocols          ip(7)	
	基于IPV4的网络通信（不同主机之间）

       AF_INET6            IPv6 Internet protocols          ipv6(7)
	基于IPV6的网络通信（暂时用不上）

       AF_IPX              IPX - Novell protocols
       AF_NETLINK          Kernel user interface device     netlink(7)
       AF_X25              ITU-T X.25 / ISO-8208 protocol   x25(7)
       AF_AX25             Amateur radio AX.25 protocol
       AF_ATMPVC           Access to raw ATM PVCs
       AF_APPLETALK        Appletalk                        ddp(7)
       AF_PACKET           Low level packet interface       packet(7)

第二个参数：通信类型
	SOCK_STREAM - 提供有序的，可靠的，双向的，面向连接的字节流方式，也就是基于tcp协议的通信方式	
	SOCK_DGRAM - 提供不可靠的，非面向连接的数据报通信方式，也就是基于udp协议的通信方式
		/*datagram*/
第三个参数：特殊的协议，默认给0即可

返回值：成功返回新的socket描述符，失败返回-1；

函数功能：
	主要用于创建可以实现通信的交流点，也就是socket通信载体；


2. 通信地址的数据类型
	1. struct sockaddr类型

           struct sockaddr {
               sa_family_t sa_family;
               char        sa_data[14];
           }
		- 该结构体类型主要用于函数的形参类型，基本不会定义变量使用

	2. struct sockaddr_un类型
	   
	   #include<sys/un.h>
	   struct sockaddr_un{
		sa_family_t  sun_family; //地址族/协议族
			- 与socket函数的第一个实参保持一致即可
		char         sun_path[]; //socket文件的路径名
    	   };
		-该结构体主要用于实现本地通信的通信模型中；
	
	3. struct sockaddr_in类型

	   #include<netinet/in.h>
	   struct sockaddr_in{
		sa_family_t  sin_family; //AF_INET
		in_port_t    sin_port;//端口号
		struct in_addr sin_addr;//ip地址
	   };
	
	   struct in_addr{
		in_addr_t  s_addr;//整数类型的ip地址
	   };
		- 该结构体主要用于实现不用主机之间的网络通信模型中；
			

3. bind()函数			bind a name to a socket
       #include <sys/types.h>          /* See NOTES */
       #include <sys/socket.h>

       int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);

第一个参数：socket描述符，socket函数的返回值

第二个参数：结构体指针，可能需要做类型转换

第三个参数：通信地址的大小，使用sizeof计算即可

函数功能：
	主要用于绑定socket和具体的通信地址；


4. connect()函数		initiate a connection on a socket
       #include <sys/types.h>          /* See NOTES */
       #include <sys/socket.h>

       int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);

函数功能：
	主要用于连接socket和指定的通信地址，参数和返回值参考bind函数即可；


5. 字节序的转换函数
       htonl,  htons,  ntohl, ntohs - convert values between host and network byte order
                                                             主机       网络
       #include <arpa/inet.h>

       uint32_t htonl(uint32_t hostlong);
	=> 主要用于将32位二进制的主机字节序转换为网络字节序；

       uint16_t htons(uint16_t hostshort);
	=> 主要用于将16位的二进制的主机字节序转换为网络字节序；
 
      uint32_t ntohl(uint32_t netlong);
	=> 主要用于将32位二进制的网络字节序转换为主机字节序；
 
      uint16_t ntohs(uint16_t netshort);
	=> 主要用于将16位二进制的网络字节序转换为主机字节序；

	网络字节顺序是TCP/IP中规定好的一种数据表示格式，它与具体的CPU类型、操作系统等无关，
		从而可以保证数据在不同主机之间传输时能够被正确解释。网络字节顺序采用big endian排序方式。

	主机字节序 低位字节数据保存在低位内存地址 小端系统的字节序
	网络字节序 低位字节数据保存在高位内存地址 大端系统的字节序


6. IP地址的转换函数 Internet address manipulation routines
       #include <sys/socket.h>
       #include <netinet/in.h>
       #include <arpa/inet.h>

       in_addr_t inet_addr(const char *cp);
	=> 主要用于将字符串类型的IP地址转换为整数类型；
		172.16.1.182转换为整数(网络地址)   

       char *inet_ntoa(struct in_addr in);
	=> 主要用于将结构体类型的IP地址转换为字符串类型；
		将整数（网络地址）转换成点分十进制  点分十进制只是方便给人看
						  整数才是实际用到的网络地址


/*网络通信 绑定自己的IP 服务器 
           连接对方的IP 客户端
	绑定时候只能是读	连接时候只能是写 
	因为bind才会建立socket和通信地址间的联系  */
	write: Destination address required


//基于socket的本地通信,读数据  服务器
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<sys/un.h>

int main()
{
	//1.创建socket，使用socket函数
	//2.准备通信地址，使用结构体类型
	//3.绑定socket和通信地址，使用bind函数
	//4.进行通信，使用read/write函数
	//5.关闭socket，使用close函数

	int sockfd=socket(AF_UNIX/*本地通信*/,SOCK_DGRAM/*数据报通信方式*/,0);
	if(-1==sockfd)
	{
		perror("socket"),exit(-1);
	}
	printf("创建socket描述符成功\n");
//--------------------------------------------
	struct sockaddr_un addr;
	addr.sun_family=AF_UNIX;
	strcpy(addr.sun_path,"a.sock");   //char sun_path[]; //socket文件的路径名 用strcpy
//--------------------------------------------
	int res=bind(sockfd,(struct sockaddr*)&addr,sizeof(addr));
	if(-1==res)
	{
		perror("bind"),exit(-1);
	}
	printf("绑定socket和通信地址成功\n");
//-------------------------------------------
	char buf[100]={0};
	res=read(sockfd,buf,sizeof(buf));
	if(-1==res)
	{
		perror("read"),exit(-1);
	}
	printf("客户端发来的消息是：%s,消息大小是：%d\n",buf,res);
//---------------------------------------------
	res=close(sockfd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭socket\n");
	return 0;
}



//使用socket进行本地通信 写数据  客户端
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<unistd.h>
#include<sys/types.h>
#include<sys/socket.h>
#include<sys/un.h>

int main()
{
	//1.创建socket，使用socket函数
	//2.准备通信地址，使用服务器地址
	//3.连接socket和通信地址，使用connect函数
	//4.进行通信，使用read/write函数
	//5.关闭socket，使用close函数
	int socketfd=socket(AF_UNIX,SOCK_DGRAM,0);
	if(-1==socketfd)
	{
		perror("socket"),exit(-1);
	}
//----------------------------------------
	struct sockaddr_un addr;
	addr.sun_family=AF_UNIX;
	strcpy(addr.sun_path,"a.sock");
//----------------------------------------
	int res=connect(socketfd,(struct sockaddr*)&addr,sizeof(addr));
	if(-1==res)
	{
		perror("connect"),exit(-1);
	}
	printf("成功连接socket和通讯地址\n");
//-----------------------------------------
	res=write(socketfd,"hello",sizeof(char)*6);
	if(-1==res)
	{
		perror("write"),exit(-1);
	}
	printf("成功写入\n");
//-------------------------------------------
	res=close(socketfd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭socket\n");

	return 0;
}



//基于socket的网络通信,读数据  服务器
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
	//3，绑定socket和通信地址，使用bind函数
	//4.进行通信，使用read/write函数
	//5.关闭socket，使用close函数

	int sockfd=socket(AF_INET/*IPV4*/,SOCK_DGRAM/*数据包*/,0);
	if(-1==sockfd)
	{
		perror("socket"),exit(-1);
	}
	printf("创建socket描述符\n");
//------------------------------------------
	struct sockaddr_in addr;
	addr.sin_family=AF_INET;
	addr.sin_port=htons(8888);
	addr.sin_addr.s_addr=inet_addr("172.16.1.182");
//--------------------------------------------
	int res=bind(sockfd,(struct sockaddr*)&addr,sizeof(addr));	
	if(-1==res)
	{
		perror("bind"),exit(-1);
	}
	printf("绑定成功\n");
//----------------------------------------------
	char buf[100]={0};
	res=read(sockfd,buf,sizeof(buf));
	if(-1==res)
	{
		perror("read"),exit(-1);
	}
	printf("客户端发来的消息是：%s,消息大小是：%d\n",buf,res);
//------------------------------------------------
	res=close(sockfd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭socket\n");
	return 0;
}


//使用socket进行网络通信，写数据  客户端
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
	//2.准备通信地址，使用服务器地址
	//3.连接socket和通信地址，使用connect函数
	//4.进行通信，使用read/write函数
	//5.关闭socket，使用close函数

	int socketfd=socket(AF_INET,SOCK_DGRAM,0);
	if(-1==socketfd)
	{
		perror("socket"),exit(-1);
	}
	printf("成功创建socket描述符\n");
//------------------------------------------
	struct sockaddr_in addr;
	addr.sin_family=AF_INET;
	addr.sin_port=htons(8888);
	addr.sin_addr.s_addr=inet_addr("172.16.1.182");
//--------------------------------------------
	int res=connect(socketfd,(struct sockaddr*)&addr,sizeof(addr));
	if(-1==res)
	{
		perror("connect"),exit(-1);
	}
	printf("成功建立socket连接\n");
//--------------------------------------------
	res=write(socketfd,"hello",6);
	if(-1==res)
	{
		perror("write"),exit(-1);
	}
	printf("成功写入数据\n");
//---------------------------------------------
	res=close(socketfd);
	if(-1==res)
	{
		perror("close"),exit(-1);
	}
	printf("成功关闭socket\n");

	return 0;
}



