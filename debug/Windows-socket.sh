scoeket(linker)
{
在Windows环境下，使用Windows socket api进行网络程序开发时，需要调用Windows操作系统的Windows socket动态库。
在应用程序中需要包含Windows sockets头文件。windows sockets 2.2版本需要包含WINSOCK2.h头文件（不区分大小写）。
同时还需要添加动态库。一种是在头文件中添加。如：
#pragma  comment(lib,"WS2_32.lib")
另一种是在vc中添加。可以选择project ->settting，在link标签下添加wsock32.lib字符串。
}

scoeket(SOCKET)
{
Windows sockets中定义的套接字类型SOCKET来表示套接字：

typedef unsigned int u_int;  
typedef u_int SOCKET;

INVALID_SOCKET表示一个无效的套接字，除此之外的0--INVALID_SOCKET-1都表示一个有效的套接字。因此在创建套接字后，
都需要与INVALID_SOCKET比较，看创建的套接字是否有效。


}

socket(inet_ntoa,inet_addr)
{
给in_addr赋值的一种最简单方法是使用inet_addr函数，它可以把一个代表IP地址的字符串赋值转换为in_addr类型，
如addrto.sin_addr.s_addr=inet_addr("192.168.0.2");
inet_addr:如果正确执行将返回一个无符号长整数型数。如果传入的字符串不是一个合法的IP地址，将返回INADDR_NONE。
inet_ntoa:返回点分十进制的字符串在静态内存中的指针。
其反函数是inet_ntoa，可以把一个in_addr类型转换为一个字符串。
}

socket(htonl和htons, ntohl和ntohs)
{
Htonl和htons函数实现主机字节顺序和网络字节序的转换功能。H代表host，主机。N代表net。L代表long。S代表short。
当然也有从网络字节序到主机字节序的转换函数：ntohl和ntohs。
}

socket(WSAStartup)
{
在使用套接字进行编程之前，无论是服务器还是客户端都必须加载Windows SOCKET动态库。函数WSAStartup就实现了此功能。
它是套接字应用程序必须调用的第一个函数。

第一个参数指定准备加载的Windows SOCKET动态库的版本。一般使用宏MAKEWORD构造。如MAKEWORD(2,2）表示加载2.2版本。
WSADATA会返回被加载动态链接库的基本信息。如是否加载成功，以及当前实际使用的版本。具体结构不再介绍。
初始化socket之后，需要创建套接字。socket函数和WSASocket函数可以实现此功能。

WSAStartup，是Windows Sockets Asynchronous的启动命令、Windows下的网络编程接口软件 Winsock1 或 Winsock2 里面的一个命令。
int WSAStartup ( WORD wVersionRequested, LPWSADATA lpWSAData )；
(1)wVersionRequested：一个WORD（双字节）型数值，在最高版本的Windows Sockets支持调用者使用，高阶字节指定小版本(修订本)号,低位字节指定主版本号。
(2)lpWSAData 指向WSADATA数据结构的指针，用来接收Windows Sockets[1]  实现的细节。
WindowsSockets API提供的调用方可使用的最高版本号。高位字节指出副版本(修正)号，低位字节指明主版本号。

正常返回值为0；否则返回WSASYSNOTREADY、WSAVERNOTSUPPORTED、WSAEINPROGRESS、WSAEPROCLIM、WSAEFAULT。
}

socket(socket)
{
当函数创建成功时，返回一个新建的套接字句柄。否则将返回INVALID_SOCKET。
}

socket(bind)
{
函数调用成功将返回0，否则返回值为SOCKET_ERROR。如果程序不关心分配给它的地址，可使用INADDR_ANY或将端口号设为0。端口号为0时，
Windows SOCKET将给应用程序分配一个值在1024-5000之间唯一的端口号。
}

socket(listen)
{
当函数成功时返回0，否则返回SOCKET_ERROR。
假如backlog为3，则说明最大等待连接的最大值为3.如果有四个客户端同时向服务器发起请求，那么第四个连接将会发生WSAEWOULDBLOCK错误。
当服务器接受了一个请求，就将该请求从请求队列中删去。
}

socket(accept)
{
函数执行成功时：
1：主机接受了等待队列的第一个请求。
2：addr结构返回客户端地址。
3：返回一个新的套接字句柄。服务器可以使用该套接字与客户端进行通信。而监听套接字仍用于接受客户端连接。
函数执行失败时：
INVALID_SOCKET
}

socket(recv和WSARecv)
{
recv()函数
recv()和WSARecv()函数用于接收数据。
flags:该参数影响函数的行为。它可以是0，MEG_PEEK和MSG_OOB。0表示无特殊行为。
      MSG_PEEK会使有用的数据被复制到buff中，但没有从系统缓冲区内将这些数据删除。MSG_OOB表示处理外带数据。
recv函数返回接收的字节数。当函数执行失败时返回SOCKET_ERROR。
}

socket(send和WSASend)
{
send函数
send()和WSASend()用于发送数据。

flags可以是0或MSG_DONTROUTE或MSG_OOB。0表示无特殊行为。MSG_DONTROUTEyaoqiu传输层不要将此数据路由出去。MSG_OOB表示该数据应该被外带发送。
函数成功时返回实际发送的字节数。失败返回SOCKET_ERROR。
}

socket(closesocket)
{
closesocket()函数用以关闭套接字。释放套接字所占资源。
调用过closesocket函数的套接字继续使用时会返回WSAENOTSOCK错误。


Shutdown()函数用于通知对方不再发送数据或者不再接收数据或者既不发送也不接收数据。
how参数可以是：
SD_RECEIVE表示不再接收数据，不允许再调用接收数据函数。
SD_SEND表示不再发送数据。
SD_BOTH表示既不发送也不接收数据。
}

socket(connect)
{
connect函数实现连接服务器的功能。
s为套接字。
    name为服务器地址。
    namelen为sockaddr结构长度。
    函数执行成功返回0，否则返回SOCKET_ERROR。
}

socket(getsockopt,setsockopt)
{
s为要取得选项的套接字。
level为选项级别，有SOL_SOCKET和IPPROTO_TCP两个级别。
函数成功，返回值为0。否则返回SOCKET_ERROR。

当设置SOL_SOCKET选项级别时，调用setsockopt函数和getsockopt函数所设置或获取的信息为套接字本身的特征，这些信息与基层协议无关。


SOL_SOCKET级别包括一下类型：
SO_ACCEPTCONN      bool类型。如果为真，表明套接字处于监听模式。
SO_BROADCAST       bool类型，如果为真，表明套接字已设置成广播消息发送。
SO_DEBUG           bool类型。如果为真，则允许输出调试信息。
SO_DONTLINGER      bool类型。如果为真，则禁止SO_LINGER。
SO_DONTROUTE       bool类型。如果为真，则不会做出路由选择。
SO_ERROR           int 类型。返回和重设以具体套接字为基础的错误代码。
SO_KEEKPALIVE       bool类型。如果为真，则套接字在会话过程中会发送保持活动消息。
SO_LINGER           struct linger*类型，设置或获取当前的拖延值。
SO_OOBINLINE        bool如果为真，则带外数据会在普通数据流中返回。
SO_RECVBUF          int类型。设置或获取接收缓冲区长度。
SO_REUSEADDR        bool类型。如果为真，套接字可以与一个正在被其他套接字使用的地址绑定。
SO_SNDBUF           bool类型。设置或获取发送缓冲区大小。
SO_TYPE            int类型。返回套接字类型，如SOCK_DGREAM，SOCK_STREAM。
SO_SNDTIMEO         int类型。设置或获取套接字在发送数据的超时时间。
SO_RECVTIMEO        int类型，设置或获取套接字在接收数据的超时时间。

}

socket(WSAGetLastError)
{
该函数用来在Socket相关API失败后读取错误码，根据这些错误码可以对照查出错误原因。
}

socket(获取计算机的IP地址和名称)
{
利用函数GetComputerName()
1.      gethostname函数：
int gethostname(char FAR* name, int namelen);
没有错误则返回0，有错误则返回SOCKET_ERROR，通过WSAGetLastError获取指定的错误代码
2. gethostbyname函数：从主机数据库中得到对应的主机的相应信息，如IP地址等。
struct hostent FAR* gethostbyname(const char FAR* name );//name是主机名字，一般是由gethostname获得的名字。
3.      gethostbyaddr函数：从网络地址得到对应的主机。
struct hostent FAR* gethostbyaddr(const char FAR* addr,  int len,  int type);
}

socket(获取计算机子网掩码)
{
用函数GetAdaptersInfo可以获取本地计算机的网络信息，从而获得该计算机的子网掩码。
DWORD GetAdaptersInfo(PIP_ADAPTER_INFO pAdapterInfo,  PULONG pOutBufLen);
typedef struct _IP_ADAPTER_INFO {
  struct _IP_ADAPTER_INFO* Next;
  DWORD ComboIndex;
  Char AdapterName[MAX_ADAPTER_NAME_LENGTH + 4];//网卡名
  char Description[MAX_ADAPTER_DESCRIPTION_LENGTH + 4];//对网卡的描述
  UINT AddressLength;//物理地址的长度
  BYTE Address[MAX_ADAPTER_ADDRESS_LENGTH];//物理地址
  DWORD Index;//网卡索引号
  UINT Type;//网卡类型
  UINT DhcpEnabled;//是否启用了DHCP动态IP分配
  PIP_ADDR_STRING CurrentIpAddress;//当前使用的IP
  IP_ADDR_STRING IpAddressList;//绑定到此网卡的IP地址链表
  IP_ADDR_STRING GatewayList;//网关地址链表
  IP_ADDR_STRING DhcpServer;//DHCP服务器地址
  BOOL HaveWins;//是否启用了WINS
  IP_ADDR_STRING PrimaryWinsServer;//主WINS地址
  IP_ADDR_STRING SecondaryWinsServer;//辅WINS地址
  time_t LeaseObtained;//当前DHCP租借获取的时间
  time_t LeaseExpires;//失效时间
} IP_ADAPTER_INFO, *PIP_ADAPTER_INFO;

//获取网卡的相关信息，还可以枚举网卡
IP_ADAPTER_INFO* pAdapterInfo;
pAdapterInfo = (IP_ADAPTER_INFO *) malloc( sizeof(IP_ADAPTER_INFO) );
ULONG ulOutBufLen = sizeof(IP_ADAPTER_INFO);
//第一次调用GetAdaptersInfo获取适当的ulOutBufLen变量大小
DWORD res = GetAdaptersInfo(pAdapterInfo,&ulOutBufLen);
free (pAdapterInfo);
pAdapterInfo = (IP_ADAPTER_INFO *) malloc ( ulOutBufLen );
res = GetAdaptersInfo(pAdapterInfo,&ulOutBufLen);
}

socket(获取计算机的DNS设置)
{
采用函数GetNetWorkParams函数可以获得本地计算机的网络参数，从而获得计算机的DNS设置。
DWORD GetNetworkParams(PFIXED_INFO pFixedInfo,   PULONG pOutBufLen);

参数pFixedInfo定义为：
typedef struct {
  char HostName [MAX_HOSTNAME_LEN + 4];//主机名字
  char DomainName [MAX_DOMAIN_NAME_LEN + 4]; //域名
  PIP_ADDR_STRING CurrentDnsServer; //IP地址的一个节点
  IP_ADDR_STRING DnsServerList; //服务器IP地址链表
  UINT NodeType; //节点类型
  char ScopeId [MAX_SCOPE_ID_LEN + 4]; //
  UINT EnableRouting; //
  UINT EnableProxy; //
  UINT EnableDns; //
} FIXED_INFO, *PFIXED_INFO;

//获取DNS设置

FIXED_INFO *pFixedInfo;
ULONG       ulOutBufLen;
DWORD       dwRetVal;
pFixedInfo = (FIXED_INFO *) malloc( sizeof( FIXED_INFO ) );
ulOutBufLen = sizeof( FIXED_INFO );
if ( GetNetworkParams( pFixedInfo, &ulOutBufLen ) == ERROR_BUFFER_OVERFLOW )
{
     free( pFixedInfo );
     pFixedInfo = (FIXED_INFO *) malloc( ulOutBufLen );
}
dwRetVal = GetNetworkParams( pFixedInfo, &ulOutBufLen );
}


socket(获取计算机安装的协议)
{
       可以通过函数WSAEnumProtocols获取安装在本地主机上可用的网络协议集。
int WSAEnumProtocols(  LPINT lpiProtocols,  LPWSAPROTOCOL_INFO lpProtocolBuffer,  ILPDWORD lpdwBufferLength);
}

socket(获取计算机提供的服务)
{
       可以调用函数getservbyname来获取对应给定服务名和服务协议的相关服务信息。
struct servent* FAR getservbyname( onst char* name,  const char* proto );
}

socket(获取计算机的所有网络资源)
{
       函数WNetOpenEnum开始一个网络资源或存在的网络连接枚举值，可以通过调用函数WNetEnumResource获取详细的网络资源。
DWORD WNetOpenEnum(
  DWORD dwScope,
  DWORD dwType,
  DWORD dwUsage,
  LPNETRESOURCE lpNetResource,
  LPHANDLE lphEnum
);
}


socket(修改本地网络设置)
{

修改本地已经存在的地址解析协议表：SetIpNetEntry:
DWORD SetIpNetEntry( PMIB_IPNETROW pArpEntry );
l        设置某一网络接口卡的管理状态，SetIfentry：
DWORD SetIfEntry( PMIB_IFROW pIfRow );
l        为本地计算机特定的适配器添加地址，AddIpAddress:
DWORD AddIPAddress(
  IPAddr Address,
  IPMask IpMask,
  DWORD IfIndex,
  PULONG NTEContext,
  PULONG NTEInstance
);
l        删除IP地址，DeleteIpAddress:
DWORD DeleteIPAddress( ULONG NTEContext );
}

socket(获取计算机TCP/IP的所有信息)
{
    通过函数GetTcpStatics获取本地的TCP协议统计信息：
DWORD GetTcpStatistics( PMIB_TCPSTATS pStats ); 参数pStats是指向MIB_TCPSTATS的指针，
函数GetTcpTable获取TCP协议连接表：
DWORD GetTcpTable(PMIB_TCPTABLE pTcpTable, PDWORD pdwSize, BOOL bOrder );

函数GetIpAddrTable获取网络接口卡与IP地址的映射表：
DWORD GetIpAddrTable( PMIB_IPADDRTABLE pIpAddrTable,PULONG pdwSize,BOOL bOrder );

GetIpStatics获取当前IP统计信息：
DWORD GetIpStatistics( PMIB_IPSTATS pStats );
}

socket(非阻塞套接字)
{
非阻塞套接字在处理同时建立的多个连接等方面具有明显的优势。但是使用过程中有一定的难度。

把套接字设置为非阻塞模式，即告诉系统：在调用Windows socket API时，不让主调线程睡眠，而让函数立即返回。
比如在调用recv函数时，即使此时接受缓冲区没有数据，也不会导致线程在recv处等待，recv函数会立即返回。
如果没有调用成功函数会返回WSAEROULDBLOCK错误代码。为了接收到数据必须循环调用recv,这也是非阻塞与阻塞模式的主要区别。

ret=recv(s,buff,num,0);  
if(ret==SOCKET_ERROR)  
{  
    err=WSAGetLastError();  
    if(err==WSAEWOULDBLOCK)//套接字缓冲区还没有数据
    {  
        continue;  
    }  
    else if(err==WSAETIMEDOUT)//超时。  
    {
    }  
    else if(err==WSAENETDOWN)//连接断开。  
    {  
    } 
    else//其他错误
    {
    }
} 

不同的Windows socket api虽然都返回WSAEWOULDBLOCK但是它们所表示的错误原因却不尽相同:
    对于accept和WSAAccept，WSAEWOULDBLOCK表示没有收到连接请求。
    recv和WSARecv、recvfrom、WSARecvfrom，表示接受缓冲区没有收到数据。
    send、WSASend、sendfrom和WSASendfrom标识发送缓冲区不可用。
    connect、WSAConnect表示连接未能立即完成。
    
}

socket(select)
{
int select 
(  
   Int nfds,//被忽略。传入0即可。  
   fd_set *readfds,//可读套接字集合。  
   fd_set *writefds,//可写套接字集合。  
   fd_set *exceptfds,//错误套接字集合。  
   const struct timeval*timeout);//select函数等待时间。
   
struct fd_set  
{  
     u_int fd_count;  
     socket fd_array[FD_SETSIZE];  
}fd_set;

select函数中需要三个fd_set结构:
    一：准备接收数据的套接字集合，即可读性集合。
    二：准备发送数据的套接字集合，即可写性集合。
     在select函数返回时，会在fd_set结构中，填入相应的套接字。

readfds数组将包括满足以下条件的套接字：
     1：有数据可读。此时在此套接字上调用recv，立即收到对方的数据。
     2：连接已经关闭、重设或终止。
     3：正在请求建立连接的套接字。此时调用accept函数会成功。

writefds数组包含满足下列条件的套接字：
    1：有数据可以发出。此时在此套接字上调用send,可以向对方发送数据。
    2：调用connect函数，并连接成功的套接字。

exceptfds数组将包括满足下列条件的套接字：
    1：调用connection函数，但连接失败的套接字。
    2：有带外（out of band）数据可读。
    
structure timeval  
{  
   long tv_sec;//秒。  
    long tv_usec;//毫秒。  
};  

当timeval为空指针时，select会一直等待，直到有符合条件的套接字时才返回。
    当tv_sec和tv_usec之和为0时，无论是否有符合条件的套接字，select都会立即返回。
    当tv_sec和tv_usec之和为非0时，如果在等待的时间内有套接字满足条件，则该函数将返回符合条件的套接字。如果在等待的时间内没有套接字满足设置的条件，则select会在时间用完时返回，并且返回值为0。
    为了方便使用，windows sockets提供了下列宏，用来对fd_set进行一系列操作。使用以下宏可以使编程工作简化。
    FD_CLR(s,*set);从set集合中删除s套接字。
    FD_ISSET(s,*set);检查s是否为set集合的成员。
    FD_SET(s,*set);将套接字加入到set集合中。
    FD_ZERO(*set);将set集合初始化为空集合。
}

socket(WSAAsyncSelect)
{
http://blog.csdn.net/ithzhang/article/details/8464330

    WSAAsyncSelect模型是Windows socket的一个异步IO模型。利用该模型可以接收以Windows消息为基础的网络事件。
Windows sockets应用程序在创建套接字后，调用WSAAsyncSelect函数注册感兴趣的网络事件，当该事件发生时Windows窗口收到消息，
应用程序就可以对接收到的网络事件进行处理。

     WSAAsyncSelect是select模型的异步版本。在应用程序使用select函数时会发生阻塞现象。
可以通过select的timeout参数设置阻塞的时间。在设置的时间内，select函数等待，直到一个或多个套接字满足可读或可写的条件。

     而WSAAsyncSelect是非阻塞的。Windows sockets程序在调用recv或send之前，调用WSAAsyncSelect注册网络事件。
WSAAsyncSelect函数立即返回。当系统中数据准备好时，会向应用程序发送消息。此此消息的处理函数中可以调用
recv或send进行接收或发送数据。

更重要的一点是：WSAAsyncSelect模型应用在基于消息的Windows环境下，使用该模型时必须创建窗口，
而select模型可以广泛应用在Unix系统，使用该模型不需要创建窗口。
最后一点区别：应用程序在调用WSAAsyncSelect函数后，套接字就被设置为非阻塞状态。
而使用select函数不改变套接字的工作方式。

下列条件下会发生FD_READ事件：
    1：当调用WSAAsyncSelect函数时，如果当前有数据可读。
    2：当数据到达并且没有发送FD_READ网络事件时。
    3：调用recv()或这recvfrom,如果仍有数据可读里。

 

下列情况下会发生FD_WRITE事件：
    1：调用WSAAsyncSelect函数时，如果能够发送数据时。
    2：connect或者accept函数后，连接已经建立时。
    3：调用send或者sendto函数，返回WSAWOULDBLOCK错误后，再次调用send()或者sendto函数可能成功时。
       因为此时可能是套接字还处于不可写状态，多次调用直到调用成功为止。
       
}

socket(WSAEventSelect)
{
http://blog.csdn.net/ithzhang/article/details/8476556
    WSAEventSelect模型是Windows socekts提供的另一个有用异步IO模型。该模型允许在一个或多个套接字上接收以事件为基础的
网络事件通知。Windows sockets应用程序可以通过调用WSAEventSelect函数，将一个事件与网络事件集合关联起来。
当网络事件发生时，应用程序以事件的形式接收网络事件通知。

     WSAEventSelect模型与WSAAsyncSelect模型很相似。它们最主要的差别就是当网络事件发生时通知应用程序的形式不同。
虽然它们都是异步的，但WSAAsyncSelect以消息的形式通知，而WSAEventSelect以事件的形式通知。

     与select模型相比较，WSAAsyncSelect与WSAEventSelect模型都是被动接受的。网络事件发生时，系统通知应用程序。
而select模型是主动的，应用程序主动调用select函数来检查是否发生了网络事件。

     WSAEventSelect函数。
     该函数功能是为套接字注册网络事件。该函数将事件对象与网络事件关联起来。当在该套接字上发生一个或多个网络事件时，
应用程序便以事件的形式接收这些网络事件通知。
}

socket(重叠IO-aio)
{
http://blog.csdn.net/ithzhang/article/details/8496232
    Windows socket重叠IO延续了win32 IO模型。从发送和接收的角度来看，重叠IO模型与前面介绍的Select模型、
WSAAsyncSelect模型和WSAEventSelect模型都不同。因为在这三个模型中IO操作还是同步的，例如：在应用程序调用recv函数时，
都会在recv函数内阻塞，直到接收数据完毕后才返回。而重叠IO模型会在调用recv后立即返回。等数据准备好后再通知应用程序。

系统向应用程序发送通知的形式有两种：一是事件通知。二是完成例程。后面将会介绍这两种形式。
     注意：套接字的重叠IO属性不会对套接字的当前工作模式产生影响。创建具有重叠属性的套接字执行重叠IO操作，
并不会改变套接字的阻塞模式。套接字的阻塞模式与重叠IO操作不相关。重叠IO模型仅仅对WSASend和WSARecv的行为有影响。 
对listen，如果是阻塞模式，直到有客户请求到达时才会返回。这点要特别注意。

与其他模型的区别
    在Windows socket中，接收数据的过程可以分为：等待数据和将数据从系统复制到用户空间两个阶段。
各种IO模型的区别在于这两个阶段上。
    前三个模型的第一个阶段的区别： select模型利用select函数主动检查系统中套接字是否满足可读条件。
WSAAsyncSelect模型和WSAEventSelect模型则被动等待系统的通知。
    第二个阶段的区别：此阶段前三个模型基本相同，在将数据从系统复制到用户缓冲区时，线程阻塞。
而重叠IO与它们都不同，应用程序在调用输入函数后，只需等待接收系统完成的IO操作完成通知。
}

socket(IOCP)
{
IO完成端口是一种内核对象。利用完成端口，套接字应用程序能够管理数百上千个套接字。应用程序创建完成端口对象后，通过指定一定数量的服务线程，为已经完成的重叠IO操作提供服务。该模型可以达到最后的系统性能。
    完成端口是一种真正意义上的异步模型。在重叠IO模型中，当Windows socket应用程序在调用WSARecv函数后立即返回，
 线程继续运行。另一线程在在完成端口等待操作结果，当系统接收数据完成后，会向完成端口发送通知，然后应用程序对数据
 进行处理。
    
    为了将Windows打造成一个出色的服务器环境，Microsoft开发出了IO完成端口。它需要与线程池配合使用。
    服务器有两种线程模型：串行和并发模型。
    串行模型：单个线程等待客户端请求。当请求到来时，该线程被唤醒来处理请求。但是当多个客户端同时向服务器发出请求时，
这些请求必须依次被请求。
    并发模型：单个线程等待请求到来。当请求到来时，会创建新线程来处理。但是随着更多的请求到来必须创建更多的线程。
这会导致系统内核进行上下文切换花费更多的时间。线程无法即时响应客户请求。伴随着不断有客户端请求、退出，
系统会不断新建和销毁线程，这同样会增加系统开销。

     而IO完成端口却可以很好的解决以上问题。它的目标就是实现高效服务器程序。
     
与重叠IO相比较
    重叠IO与IO完成端口模型都是异步模型。都可以改善程序性能。但是它们也有以下区别：
    1：在重叠IO使用事件通知时，WSAWaitForMultipleEvents只能等待WSA_MAXIMUM_WAIT_EVENTS（64）个事件。这限制了服务器提供服务的客户端的数量。
    2：事件对象、套接字和WSAOVERLAPPED结构必须一一对应关系，如果出现一点疏漏将会导致严重的后果。

完成端口模型实现包括以下步骤：
   1：创建完成端口
   2：将套接字与完成端口关联。
   3：调用输入输出函数，发起重叠IO操作。
   4：在服务线程中，等待完成端口重叠IO操作结果。

   

}
socket(IOCP-创建IO完成端口)
{
一：创建IO完成端口
    IO完成端口也是一个内核对象。调用以下函数创建IO完成端口内核对象。
HANDLE CreateIoCompletionPort(  
      HANDLE hFile,  
      HANDLE hExistingCompletionPort,  
      ULONG_PTR CompletionKey,  
      DWORD dwNumberOfConcurrentThreads);
这个函数会完成两个任务：
    一是创建一个IO完成端口对象。
    二是将一个设备与一个IO完成端口关联起来。
    hFile就是设备句柄。在本文中就是套接字。
    hExistingCompletionPort是与设备关联的IO完成端口句柄。为NULL时，系统会创建新的完成端口。
    dwCompletionKey是一个对我们有意义的值，但是操作系统并不关心我们传入的值。一般用它来区分各个设备。
    dwNumberOfConcurrentThreads告诉IO完成端口在同一时间最多能有多少进程处于可运行状态。如果传入0，那么将使用默认值（并发的线程数量等于cpu数量）。 
    每次调用CreateIoCompletionPort时，函数会判断hExistingCompletionKey是否为NULL，如果为NULL，会创建新的完成端口内核对象。并为此完成端口创建设备列表然后将设备加入到此完成端口设备列表中（先入先出）。
    如果CreateIoCompletionPort调用成功则返回完成端口的句柄。否则返回NULL。
    一般情况下，分两次调用这个函数，每次实现一个功能。
    首先创建新的完成端口（不关联设备）：此时hFile应为INVALID_HANDLE_VALUE。
    
    ExistingCompletionPort为NULL。   
    hIOPort=CreateIoCompletionPort(INVALID_HANDLE_VALUE,NULL,0,0);  
    
}

socket(IOCP-将套接字与IO完成端口关联)
{
第二步:将套接字与IO完成端口关联CreateIoCompletionPort(sListenSocket,hIOPort,完成键，0);

调用此函数即告诉系统：当IO操作完成时，想完成端口发送一个IO操作完成通知。这些通知按照FIFO 方式在完成队列中等待服务线程读取。

在利用IO完成端口开发套接字应用程序时，通常声明一个结构体保存与套接字相关的信息。该结构通常作为完成键传递给
CreateIoCompletionPort用以区分与套接字相关的信息。我们可以给完成键传入任何对我们有用的信息，一般情况下都是
传入一个结构的地址。如可以定义以下结构，：
    typedef struct _completionKey  
    {  
       SOCKET s;  
       SOCKADDR_IN clientAddr;  
    }COMPLETIONKEY,*PCOMPLETIONKEY;  
作为完成键传递给CreateIoCompletionPort代码如下：

PCOMPLETIONPKEY pCompletionKey=new COMPLETIONKEY;  
    SOCKADDR_IN addr;  
    int len;  
    sAccept=accept(sListen,(SOCKADDR*)&addr,&len);  
    pCompletionKey->s=sAccept;  
    pCompletionKey->clientAddr=addr;  
    HANDLE h=CreateIoCompletionPort((HANDLE)sAccept,  
                               hIOPort,  
                               (DWORD)pCompletionKey,  
                                0);
}

socket(IOCP-发起重叠IO操作)
{
3:发起重叠IO操作

     将套接字与IO完成端口关联后，应用程序可以调用以下函数，发起重叠IO操作：
WSASend和WSASendTo：发送数据。
WSARecv和WSARecvFrom：接收数据。

在应用程序中通常声明一个和IO操作相关的结构体，它是WSAOVERLAPPED结构的扩展。用以保存每一次IO操作的相关信息。该结构定义如下：

    typdef struct _io_operation_data  
    {  
       WSAOVERLAPPED overlapped;  
       WSABUF dataBuf;  
       CHAR   buffer[BUFFER_SIZE];  
    }IO_OPERATION_DATA;  

除了上面这一种方法：将WSOVERLAPPED结构作为IO_OPERATION_DATAA的第一个成员外，还可以将IO_OPERATION_DATA结构继承自WSAOVERLAPPED结构。效果是一样的。
下列代码演示了调用WSARecv发起异步接收数据的过程，程序清单如下：

    IO_OPERATION_DATA *pIoData=new IO_OPERATION_DATA;  
    pIoData->dataBuf=pIoData->buffer;  
    pIoData->dataBuf.len=BUFFER_SIZE;  
    ZeroMemory(&pIoData->overlapped,sizeof(WSAOVERLAPPED));  
    if(WSARecv(sAccept,&(pIo->dataBuf),1,&recvBytes,&flags,&(pIoData->overlapped),NULL)==SOCKET_ERROR)  
    {   
       if(WSAGetLastError()!=ERROR_IO_PENDING)  
       {  
           return ;  
       }  
    }
}

socket(IOCP-等待重叠IO操作结果：)
{
4：等待重叠IO操作结果：
服务线程启动后，调用GetQueuedCompletionStatus函数等待重叠IO操作的完成结果。
当重叠IO操作完成时，IO操作完成通知被发送到完成端口上，此时函数返回。

GetQueuedCompletionStatus函数从完成端口完成队列中取出一个完成项。完成队列为空则等待。该函数声明如下：
BOOL GetQueuedCompletionStatus(  
HANDLE hCompletionPort,  
PDWORD pdwNumberOfBytesTransferred,  
ULONG_PTR pCompletionKey,  
OVERLAPPED** ppOverlapped,  
DWORD dwMilliSeconds);  

     hCompletionPort表示线程希望对哪个完成端口进行监视，GetQueuedCompletionStatus的任务就是将调用线程切换到睡眠状态，也就是阻塞在此函数上，直到指定的IO完成端口出现一项或者超时。
        pdwNumberOfBytesTransferred返回在异步IO完成时传输的字节数。
      pCompletionKey返回完成键。
      ppOverlapped返回异步IO开始时传入的OVERLAPPED结构地址。
      dwMillisecond指定等待时间。
      函数执行成功则返回true，否则返回false。
      如果在完成端口上成功等待一个完成项的到来，则函数返回TRUE。此时lpNumberOfBytesTransferred,lpCompletionKey和lpOverlapped参数返回相关信息。一般从lpCompletionKey和lpOverlapped获得与本次IO相关的信息。
      如果在完成端口等待失败，则返回false，此时lpOverlapped不为NULL。如果等待超时，则返回false，错误代码为WAIT_TIMEOUT。
       综上，在使用完成端口开发Windows socket应用程序时，一般需要定义两种数据结构：完成键和扩展的WSAOVERLAPPED结构。完成键保存与套接字有关的信息。在GetQueuedCompletionStatus返回时可以通过该参数获取套接字的相关信息。这用于区分不同设备。
扩展的WSAOVERLAPPED结构，保存每次发起IO操作时IO操作相关的信息。当GetQueuedCompletionStatus返回时通过该参数获取套接字的IO操作相关信息。
　　　下面展示GetQueuedCompletionStatus函数的用法：

    PCOMPLETIONKEY pCompletionKey;  
    DWORD dwNumberOfBytesTransferrd;  
    LPOVERLAPPED pOverlapped;  
    bool ret=GetQueuedCompletionStatus(hIOPort,&dwNumberOfBytesTransferred,(LPDWORD)pCompletionKey,&pOverlapped,100);  
    if(ret)  
    {  
        //等待成功。  
    }  
    else  
    {  
        int err=WSAGetLastError();  
        if(NULL!=pOverlapped)  
        {  
          //失败的IO操作。  
        }  
        else if(ret==WAIT_TIMEOUT)  
        {  
          //超时。  
        }  
    }  
}

socket(IOCP-取消异步操作)
{
5：取消异步操作。
     当关闭套接字时，如果此时系统还有未完成的异步操作，应用程序可以调用CancelIo函数取消等待执行的异步操作。
函数声明如下：
bool CancelIo(HANDLE hFile);
如果函数调用成功，返回TRUE，所有在此套接字上等待的异步操作都被成功的取消。

       投递完成通知
      当服务器退出，应用程序可以调用PostQueuedCompletionStatus函数向服务器发送一个特殊的完成通知。
服务器收到通知后即退出。
该函数声明如下：
BOOL PostQueuedCompletionStatus(  
HANDLE hCompletionPort,  
DWORD dwNumBytes,  
ULONG_PTR CompletionKey,  
OVERLAPPED*pOverlapped);

这个函数用来将已完成的IO通知追加到IO完成端口的队列中。
该函数的四个参数与GetQueuedCompletionStatus的函数相同。
hCompletionPort表示我们要将已完成的IO项添加到哪个完成端口的队列中。
}


socket(IOCP-step)
{
利用完成端口开发应用程序可以按一下步骤进行：
      1：调用CreateIoCompletionPort创建完成端口。
      2：创建服务线程。
      3：接受客户端请求；
      4：声明完成键结构，它包含客户端套接字信息。
      5：调用CreateIoCompletionPort将套接字与完成端口关联起来。并传入完成键。
      6：声明IO操作结构，它包含每次重叠IO时的操作信息。如WSAOVERLAPPED结构，WSADATA结构等。
      7：在服务线程中，调用GetQueuedCompletionStatus函数等待IO操作结果
      
IOCP开发驾照理论考试系统 
http://blog.csdn.net/ithzhang/article/details/8525306
http://blog.csdn.net/ithzhang/article/details/8532711
}