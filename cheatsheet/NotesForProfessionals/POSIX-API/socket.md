---
title: Socket
comments: true
---

# 创建socket

    #include <sys/types.h>          /* See NOTES */
    #include <sys/socket.h>

    int socket(int domain, int type, int protocol);

domain:

   |        |
-----------------------|--------------------------------|---
     AF_UNIX, AF_LOCAL | Local communication            |  unix(7)
     AF_INET           |  IPv4 Internet protocols         | ip(7)
     AF_INET6            |IPv6 Internet protocols          |ipv6(7)
     AF_IPX              |IPX - Novell protocols           |
     AF_NETLINK         | Kernel user interface device     |netlink(7)
     AF_X25             | ITU-T X.25 / ISO-8208 protocol  | x25(7)
     AF_AX25           |  Amateur radio AX.25 protocol    |
     AF_ATMPVC         |  Access to raw ATM PVCs           |
     AF_APPLETALK      |  AppleTalk                       | ddp(7)
     AF_PACKET          | Low level packet interface      | packet(7)
     AF_ALG            |  Interface to kernel crypto API   |

type:

   |        |
---|--------|-------------------
SOCK_STREAM    | TCP, 有序、可靠、双向、面向连接的字节流
SOCK_DGRAM    | UDP， 固定长度、无连接、不可靠的报文传递
SOCK_SEQPACKET  | 固定长度、有序、可靠的、面向连接的报文传递(SCTP协议)
SOCK_RAW       | IP协议数据报接口，需要超级权限
SOCK_RDM       | Provides a reliable datagram layer that does not guarantee ordering.
SOCK_PACKET    | 废弃

type还可以与下面两个选项组合

* SOCK_NONBLOCK   Set the O_NONBLOCK
* SOCK_CLOEXEC    Set the close-on-exec (FD_CLOEXEC) flag on the new file descriptor.

<!--more-->

protocol:

  Protocol | 说明
--------|---------
IPPROTO_IP   | IPv4协议
IPPROTO_IPV6 | IPv6协议
IPPROTO_ICMP | ICMP
IPPROTO_RAW  | 原始IP数据包协议
IPPROTO_TCP  | TCP
IPPROTO_UDP  | UDP

# 关闭读写端

    #include <sys/socket.h>
    int shutdown(int sockfd, int how);

用来关闭套接字的IO

how:

* SHUT_RD 关闭读
* SHUT_WR 关闭写
* SHUT_RDWR 关闭读写

errno:

* EACCES 没有创建指定type或protocol的套接字
* EAFNOSUPPORT 不支持的地址协议簇
* EINVAL 不支持的协议或type
* EMFILE 本进程打开文件数目达到限制
* ENFILE 系统范围内打开的文件数目达到限制
* ENOBUFS or ENOMEM 内存不足
* EPROTONOSUPPORT 指定domain不支持指定的protocol

# 字节序转换

    #include <arpa/inet.h>
    uint32_t htonl(uint32_t hostlong);
    uint16_t htons(uint16_t hostshort);
    uint32_t ntohl(uint32_t netlong);
    uint16_t ntohs(uint16_t netshort);

TCP/IP使用大端字节序

# socket地址数据结构

    /* Internet address. */
    struct in_addr {
        uint32_t       s_addr;     /* address in network byte order */
    };

    struct sockaddr_in {
        sa_family_t    sin_family; /* address family: AF_INET */
        in_port_t      sin_port;   /* port in network byte order */
        struct in_addr sin_addr;   /* internet address */
    };

    struct in6_addr {
        unsigned char   s6_addr[16];   /* IPv6 address */
    };

    struct sockaddr_in6 {
        sa_family_t     sin6_family;   /* AF_INET6 */
        in_port_t       sin6_port;     /* port number */
        uint32_t        sin6_flowinfo; /* IPv6 flow information */
        struct in6_addr sin6_addr;     /* IPv6 address */
        uint32_t        sin6_scope_id; /* Scope ID (new in 2.4) */
    };


    struct sockaddr {
      sa_family_t sa_family; /* address family */
      char sa_data[14]; /* variable-length address */
    };

sockaddr_in、sockaddr_in6都转换为sockaddr

# 地址格式转换

    int inet_pton(int af, const char *src, void *dst);

字符串格式转为网络字节序二进制地址

    const char *inet_ntop(int af, const void *src, char *dst, socklen_t size);

网络字节序二进制转换为字符串

af只支持AF_INET或AF_INET6

size可以为INET_ADDRSTRLEN或INET6_ADDRSTRLEN

    int inet_net_pton(int af, const char *pres, void *netp, size_t nsize);

字符串格式转为网络字节序二进制地址

    char *inet_net_ntop(int af, const void *netp, int bits, char *pres, size_t psize);

网络字节序二进制转换为字符串

af只支持AF_INET或AF_INET6

psize可以为INET_ADDRSTRLEN或INET6_ADDRSTRLEN

    int inet_aton(const char *cp, struct in_addr *inp);
    in_addr_t inet_addr(const char *cp);
    in_addr_t inet_network(const char *cp);
    char *inet_ntoa(struct in_addr in);
    struct in_addr inet_makeaddr(in_addr_t net, in_addr_t host);
    in_addr_t inet_lnaof(struct in_addr in);
    in_addr_t inet_netof(struct in_addr in);

    uint16_t htobe16(uint16_t host_16bits);
    uint16_t htole16(uint16_t host_16bits);
    uint16_t be16toh(uint16_t big_endian_16bits);
    uint16_t le16toh(uint16_t little_endian_16bits);

    uint32_t htobe32(uint32_t host_32bits);
    uint32_t htole32(uint32_t host_32bits);
    uint32_t be32toh(uint32_t big_endian_32bits);
    uint32_t le32toh(uint32_t little_endian_32bits);

    uint64_t htobe64(uint64_t host_64bits);
    uint64_t htole64(uint64_t host_64bits);
    uint64_t be64toh(uint64_t big_endian_64bits);
    uint64_t le64toh(uint64_t little_endian_64bits);

    bswap_16(x);
    bswap_32(x);
    bswap_64(x);

# 获取网卡信息

    struct ifaddrs {
        struct ifaddrs  *ifa_next;    /* Next item in list */
        char            *ifa_name;    /* Name of interface */
        unsigned int     ifa_flags;   /* Flags from SIOCGIFFLAGS */
        struct sockaddr *ifa_addr;    /* Address of interface */
        struct sockaddr *ifa_netmask; /* Netmask of interface */
        union {
            struct sockaddr *ifu_broadaddr;
                             /* Broadcast address of interface */
            struct sockaddr *ifu_dstaddr;
                             /* Point-to-point destination address */
        } ifa_ifu;
    #define              ifa_broadaddr ifa_ifu.ifu_broadaddr
    #define              ifa_dstaddr   ifa_ifu.ifu_dstaddr
        void            *ifa_data;    /* Address-specific data */
    };

    int getifaddrs(struct ifaddrs **ifap);
    void freeifaddrs(struct ifaddrs *ifa);

# 获取本地主机信息

    struct hostent {
        char  *h_name;            /* official name of host */
        char **h_aliases;         /* alias list */
        int    h_addrtype;        /* host address type */
        int    h_length;          /* length of address */
        char **h_addr_list;       /* list of addresses */
    }
    #define h_addr h_addr_list[0] /* for backward compatibility */


    #include <netdb.h>

    void endhostent(void);
    struct hostent *gethostent(void);
    void sethostent(int stayopen);

# 获取远程主机网络名字和网络编号

    struct netent {
        char      *n_name;     /* official network name */
        char     **n_aliases;  /* alias list */
        int        n_addrtype; /* net address type */
        uint32_t   n_net;      /* network number */
    }
    #include <netdb.h>

    struct netent *getnetbyaddr(uint32_t net, int type);
    struct netent *getnetbyname(const char *name);
    struct netent *getnetent(void);
    void setnetent(int stayopen);
    void endnetent(void);

    int getnetent_r(struct netent *result_buf, char *buf, size_t buflen, struct netent **result, int *h_errnop);

    int getnetbyname_r(const char *name, struct netent *result_buf, char *buf, size_t buflen, struct netent **result, int *h_errnop);

    int getnetbyaddr_r(uint32_t net, int type, struct netent *result_buf, char *buf, size_t buflen, struct netent **result, int *h_errnop);

# 协议名字和协议编号相互映射

    struct protoent {
        char  *p_name;       /* official protocol name */
        char **p_aliases;    /* alias list */
        int    p_proto;      /* protocol number */
    }

    #include <netdb.h>

    struct protoent *getprotoent(void);

    struct protoent *getprotobyname(const char *name);

    struct protoent *getprotobynumber(int proto);

    void setprotoent(int stayopen);

    void endprotoent(void);

    int getprotoent_r(struct protoent *result_buf, char *buf, size_t buflen, struct protoent **result);

    int getprotobyname_r(const char *name, struct protoent *result_buf, char *buf, size_t buflen, struct protoent **result);

    int getprotobynumber_r(int proto, struct protoent *result_buf, char *buf, size_t buflen, struct protoent **result);

# 服务名称映射到端口

    struct servent {
        char  *s_name;       /* official service name */
        char **s_aliases;    /* alias list */
        int    s_port;       /* port number */
        char  *s_proto;      /* protocol to use */
    }
    #include <netdb.h>

    void endservent(void);
    struct servent *getservbyname(const char *name, const char *proto);
    struct servent *getservbyport(int port, const char *proto);
    struct servent *getservent(void);
    void setservent(int stayopen);

    int getservent_r(struct servent *result_buf, char *buf, size_t buflen, struct servent **result);

    int getservbyname_r(const char *name, const char *proto, struct servent *result_buf, char *buf, size_t buflen, struct servent **result);

    int getservbyport_r(int port, const char *proto, struct servent *result_buf, char *buf, size_t buflen, struct servent **result);

# 将主机名和一个服务名映射到一个地址，域名解析

    struct addrinfo {
        int              ai_flags;
        int              ai_family;
        int              ai_socktype;
        int              ai_protocol;
        socklen_t        ai_addrlen;
        struct sockaddr *ai_addr;
        char            *ai_canonname;
        struct addrinfo *ai_next;
    };


    #include <sys/types.h>
    #include <sys/socket.h>
    #include <netdb.h>

    int getaddrinfo(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res);

    void freeaddrinfo(struct addrinfo *res);

    int getaddrinfo_a(int mode, struct gaicb *list[], int nitems, struct sigevent *sevp);
    int gai_suspend(const struct gaicb * const list[], int nitems, const struct timespec *timeout);
    int gai_error(struct gaicb *req);
    int gai_cancel(struct gaicb *req);

    const char *gai_strerror(int errcode);

ai_flags

   |
--------------|----------------------------------------------------
AI_ADDRCONFIG  |   查询地址类型(IPV4或IPV6)
AI_ALL        |       查找IPV4和IPV6地址(仅和AI_V4MAPPED同时指定)
AI_CANONNAME |需要一个规范名字（与别名相对）
AI_NUMERICHOST |以数字格式指定主机地址，不翻译
AI_NUMERICSERV |将服务指定为数字端口号，不翻译
AI_PASSIVE | 套接字地址用于监听绑定
AI_V4MAPPED |如果没有找到IPV6地址，返回映射到IPV6格式的IPV4地址

getaddrinfo失败，不能使用perror或者strerror，而应该gai_strerror

# 将地址转换为主机名或服务名

    #include <sys/socket.h>
    #include <netdb.h>

    int getnameinfo(const struct sockaddr *addr, socklen_t addrlen, char *host, socklen_t hostlen, char *serv, socklen_t servlen, int flags);



  |
---------------|-------------------------------------------
NI_DGRAM | 服务基于数据报而不是流
NI_NAMEREQD |如果找不到主机名，将其作为一个错误对待
NI_NOFQDN |对于本地主机，仅返回全限定域名的节点名部分
NI_NUMERICHOST |返回主机地址的数字形式，而非主机名
NI_NUMERICSCOPE |对于IPV6地址，返回范围ID的数字形式，而非名字
NI_NUMERICSERV |返回服务地址的数字形式，即端口号，而非名字

## 例子

    #include "apue.h"
    #if defined(SOLARIS)
    #include <netinet/in.h>
    #endif
    #include <netdb.h>
    #include <arpa/inet.h>
    #if defined(BSD)
    #include <sys/socket.h>
    #include <netinet/in.h>
    #endif

    void
    print_family(struct addrinfo *aip)
    {
    	printf(" family ");
    	switch (aip->ai_family) {
    	case AF_INET:
    		printf("inet");
    		break;
    	case AF_INET6:
    		printf("inet6");
    		break;
    	case AF_UNIX:
    		printf("unix");
    		break;
    	case AF_UNSPEC:
    		printf("unspecified");
    		break;
    	default:
    		printf("unknown");
    	}
    }

    void
    print_type(struct addrinfo *aip)
    {
    	printf(" type ");
    	switch (aip->ai_socktype) {
    	case SOCK_STREAM:
    		printf("stream");
    		break;
    	case SOCK_DGRAM:
    		printf("datagram");
    		break;
    	case SOCK_SEQPACKET:
    		printf("seqpacket");
    		break;
    	case SOCK_RAW:
    		printf("raw");
    		break;
    	default:
    		printf("unknown (%d)", aip->ai_socktype);
    	}
    }

    void
    print_protocol(struct addrinfo *aip)
    {
    	printf(" protocol ");
    	switch (aip->ai_protocol) {
    	case 0:
    		printf("default");
    		break;
    	case IPPROTO_TCP:
    		printf("TCP");
    		break;
    	case IPPROTO_UDP:
    		printf("UDP");
    		break;
    	case IPPROTO_RAW:
    		printf("raw");
    		break;
    	default:
    		printf("unknown (%d)", aip->ai_protocol);
    	}
    }

    void
    print_flags(struct addrinfo *aip)
    {
    	printf("flags");
    	if (aip->ai_flags == 0) {
    		printf(" 0");
    	} else {
    		if (aip->ai_flags & AI_PASSIVE)
    			printf(" passive");
    		if (aip->ai_flags & AI_CANONNAME)
    			printf(" canon");
    		if (aip->ai_flags & AI_NUMERICHOST)
    			printf(" numhost");
    		if (aip->ai_flags & AI_NUMERICSERV)
    			printf(" numserv");
    		if (aip->ai_flags & AI_V4MAPPED)
    			printf(" v4mapped");
    		if (aip->ai_flags & AI_ALL)
    			printf(" all");
    	}
    }

    int
    main(int argc, char *argv[])
    {
    	struct addrinfo		*ailist, *aip;
    	struct addrinfo		hint;
    	struct sockaddr_in	*sinp;
    	const char 			*addr;
    	int 				err;
    	char 				abuf[INET_ADDRSTRLEN];

    	if (argc != 3)
    		err_quit("usage: %s nodename service", argv[0]);
    	hint.ai_flags = AI_CANONNAME;
    	hint.ai_family = 0;
    	hint.ai_socktype = 0;
    	hint.ai_protocol = 0;
    	hint.ai_addrlen = 0;
    	hint.ai_canonname = NULL;
    	hint.ai_addr = NULL;
    	hint.ai_next = NULL;
    	if ((err = getaddrinfo(argv[1], argv[2], &hint, &ailist)) != 0)
    		err_quit("getaddrinfo error: %s", gai_strerror(err));
    	for (aip = ailist; aip != NULL; aip = aip->ai_next) {
    		print_flags(aip);
    		print_family(aip);
    		print_type(aip);
    		print_protocol(aip);
    		printf("\n\thost %s", aip->ai_canonname?aip->ai_canonname:"-");
    		if (aip->ai_family == AF_INET) {
    			sinp = (struct sockaddr_in *)aip->ai_addr;
    			addr = inet_ntop(AF_INET, &sinp->sin_addr, abuf,
    			    INET_ADDRSTRLEN);
    			printf(" address %s", addr?addr:"unknown");
    			printf(" port %d", ntohs(sinp->sin_port));
    		}
    		printf("\n");
    	}
    	exit(0);
    }

# socket绑定网卡ip地址

    int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);

端口号小于1024需要超级权限

只能将一个套接字绑定到一个给定地址上

errno：

* EACCES 地址受保护，但是进程不是超级进程
* EADDRINUSE 地址已经被绑定，或者addr指定的port为0，所以尝试临时端口，但是所有临时端口都被占用，详细查看/proc/sys/net/ipv4/ip_local_port_range
* EBADF  sockfd不是一个正确的文件描述符
* EINVAL socket已经绑定了一个地址或者addr对于socket domain不正确
* ENOTSOCK sockfd不是指向一个套接字
* EACCES addr路径中某个目录没有搜索权限
* EADDRNOTAVAIL 请求绑定一个不存在的端口或者addr不是一个本地地址
* EFAULT 指向进程能访问的空间
* ELOOP  解析addr时遇到太多符号链接
* ENAMETOOLONG 地址太长
* ENOENT addr路径中某个目录不存在
* ENOMEM 内核内存不够
* ENOTDIR addr前缀不是目录
* EROFS  socket在只读文件系统

# 找出套接字上的地址

    int getsockname(int sockfd, struct sockaddr *addr, socklen_t *addrlen);

发现绑定到套接字上的地址

    int getpeername(int sockfd, struct sockaddr *addr, socklen_t *addrlen);

套接字已经和对方连接，返回对方地址

# connection

    int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);

若sockfd没有绑定地址，connect会自动绑定一个

sockfd处于非阻塞模式时，connect返回-1，errno置为EINPROGRESS。可以用poll和select，epoll来判断文件是否可写，可写连接完成。

errno：

* EACCES 对于UNIX域sockets, 没有写权限或者路径某个目录没有搜索权限
* EACCES, EPERM 进程试图连接一个广播地址，但是没有置相应socket标志，或者被防火墙拒绝
* EADDRINUSE 本地地址在使用中
* EADDRNOTAVAIL 对于互联网socket，sockfd没有绑定一个地址，尝试临时端口，但是所有临时端口在使用中
* EAFNOSUPPORT 指定地址sa_family指定错误
* EAGAIN 没有足够路由cache
* EALREADY socket是非阻塞的，前面的连接尝试未完成
* EBADF  sockfd不是一个正确的文件描述符
* ECONNREFUSED 远程没有监听
* EFAULT socket地址结构不在用户空间
* EINPROGRESS socket是非阻塞的，连接不能立即完成，可以用select 或者poll来判断是否可写，可写连接就完成了，用getsockopt的SOL_SOCKET选项读SO_ERROR选，来判断连接是否成功，成功SO_ERROR为0，否则失败
* EINTR  被信号中断
* EISCONN socket已经连接
* ENETUNREACH 网络不可达
* ENOTSOCK sockfd不是只想一个socket文件
* EPROTOTYPE socket类型不支持指定的通信协议
* ETIMEDOUT 连接超时，服务器设置了syncookies了，超时时间可能非常长

## c重试connect

    #include "apue.h"
    #include <sys/socket.h>

    #define MAXSLEEP 128

    int
    connect_retry(int domain, int type, int protocol,
                  const struct sockaddr *addr, socklen_t alen)
    {
    	int numsec, fd;

    	/*
    	 * Try to connect with exponential backoff.
    	 */
    	for (numsec = 1; numsec <= MAXSLEEP; numsec <<= 1) {
    		if ((fd = socket(domain, type, protocol)) < 0)
    			return(-1);
    		if (connect(fd, addr, alen) == 0) {
    			/*
    			 * Connection accepted.
    			 */
    			return(fd);
    		}
    		close(fd);

    		/*
    		 * Delay before trying again.
    		 */
    		if (numsec <= MAXSLEEP/2)
    			sleep(numsec);
    	}
    	return(-1);
    }

为了可移植性，每次重试都应该关闭原来套接字，打开一个新套接字

# listen

    int listen(int sockfd, int backlog);

backlog提示系统改进程要入队的未完成连接请求数量，实际值由系统决定。一旦队列满，就会拒绝连接请求。

errno：

* EADDRINUSE 另一个进程已经在监听此端口
* EADDRINUSE  对于互联网socket，sockfd没有绑定一个地址，尝试临时端口，但是所有临时端口在使用中
* EBADF  sockfd不是一个正确的文件描述符
* ENOTSOCK sockfd没有指向一个socket
* EOPNOTSUPP socket不支持监听

# accept、accept4

    int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
    int accept4(int sockfd, struct sockaddr *addr, socklen_t *addrlen, int flags);

只支持SOCK_STREAM, SOCK_SEQPACKET，如果没有连接请求在等待，accetp会阻塞直到一个请求到来。对于设置了非阻塞的sockfd，accept会出错返回EAGAIN或EWOULDBLOCK。可以先用select，poll或者epoll判断sockfd上是否有连接，有连接再调用accept。

对于accept4，若flags为0，等同于accept，否则可以指定为SOCK_NONBLOCK，相当于用fcntl设置O_NONBLOCK，或者SOCK_CLOEXEC，相当于FD_CLOEXEC

errno：

* EAGAIN or EWOULDBLOCK sockfd设置为非阻塞，但是当前没有连接请求
* EBADF  sockfd不是一个正确的文件描述符
* ECONNABORTED 连接已经失效
* EFAULT sockaddr不是进程的可写空间
* EINTR 被信号中断
* EINVAL sockfd不是用来监听的连接，或者addrlen不正确
* EINVAL accept4 flags设置不正确.
* EMFILE 进程打开的文件数目受限
* ENFILE 系统范围内打开文件数目过多
* ENOBUFS, ENOMEM 没有足够的内存，一般是socket缓存，而不是系统内存不够
* ENOTSOCK sockfd没有指向一个套接字
* EOPNOTSUPP 关联的socket类型不是SOCK_STREAM.
* EPROTO 协议错误
* EPERM  防火墙组织
* ENOSR, ESOCKTNOSUPPORT, EPROTONOSUPPORT, ETIMEDOUT 协议错误

# 数据传输

## 发送函数，send，recv

send，recv系列函数可以通过flags参数比read，write函数实现更多功能

    struct msghdr {
    	void         *msg_name;       /* optional address */
    	socklen_t     msg_namelen;    /* size of address */
    	struct iovec *msg_iov;        /* scatter/gather array */
    	size_t        msg_iovlen;     /* # elements in msg_iov */
    	void         *msg_control;    /* ancillary data, see below */
    	size_t        msg_controllen; /* ancillary data buffer len */
    	int           msg_flags;      /* flags (unused) */
    };

    struct mmsghdr {
    	struct msghdr msg_hdr;  /* Message header */
    	unsigned int  msg_len;  /* Number of bytes transmitted */
    };

    #include <sys/types.h>
    #include <sys/socket.h>

    ssize_t send(int sockfd, const void *buf, size_t len, int flags);
    ssize_t sendto(int sockfd, const void *buf, size_t len, int flags, const struct sockaddr *dest_addr, socklen_t addrlen);
    ssize_t sendmsg(int sockfd, const struct msghdr *msg, int flags);
    int sendmmsg(int sockfd, struct mmsghdr *msgvec, unsigned int vlen, unsigned int flags);

flags;

标志          |  描述
--------|------------------------
MSG_CONFIRM | 提供链路层反馈以保持地址映射有效
MSG_DONTROUTE | 不要将数据包路由出本地网络
MSG_DONTWAIT |非阻塞操作（等价于使用O_NONBLOCK）
MSG_EOF |发生数据后关闭套接子发送端
MSG_EOR | 如果协议支持，标记记录结束
MSG_MORE | 延迟发送数据包，允许写更多数据
MSG_NOSIGNAL | 写无连接套接字时不产生SIGPIPE信号
MSG_OOB | 如果协议支持，发送带外数据

send发送成功，不能保证接收端已经收到数据，只是表示数据写到了网络驱动程序上。

对于支持报文边界的协议，如果发送单个报文长度大于协议支持长度，send失败，errno置为EMSGSIZE。

对于字节流协议，send会阻塞到整个数据传输完成

errno:

* EACCES 对于由文件路径标识的UNIX域套接字，没有写权限，或者路径上某个文件夹没有搜索权限。 对于UDP套接字，本身是一个单播地址，但是尝试发送数据到广播或网络地址
* EAGAIN or EWOULDBLOCK socket标记为非阻塞，当socket不可写时，出错返回T
* EAGAIN 对于互联网数据报连接，sockfd之前没有绑定一个地址，并且没有临时端口可以使用
* EBADF  sockfd不是一个正确的文件描述符
* ECONNRESET 连接被接收方重置
* EDESTADDRREQ 套接字不是已连接模式，并且没有指定接收方地址
* EFAULT 参数指定的地址不在合法用户空间
* EINTR  在任意数据发送前被信号中断
* EINVAL 传递了非法参数
* EISCONN 处于连接模式的socket已经连接，依然指定了接收地址，可能接收地址直接被忽略而不是返回错误
* EMSGSIZE socket类型要求消息自动发送，但是消息大小让发送不可能
* ENOBUFS 发送队列已经满了，一般这个在Linux中不会发生，包会被直接丢弃当设备队列溢出时。
* ENOMEM 内存不够
* ENOTCONN socket不是一个完成连接，且没有指定接收方
* ENOTSOCK 文件描述符没有指向socket
* EOPNOTSUPP flags标志位对指定的socket类型不合适
* EPIPE  MSG——NOSIGNAL没有设置的情况下，本地发送端被关闭会收到SIGPIPE信号

## 接收函数

    #define SO_EE_ORIGIN_NONE    0
    #define SO_EE_ORIGIN_LOCAL   1
    #define SO_EE_ORIGIN_ICMP    2
    #define SO_EE_ORIGIN_ICMP6   3

    struct sock_extended_err
    {
    	uint32_t ee_errno;   /* error number */
    	uint8_t  ee_origin;  /* where the error originated */
    	uint8_t  ee_type;    /* type */
    	uint8_t  ee_code;    /* code */
    	uint8_t  ee_pad;     /* padding */
    	uint32_t ee_info;    /* additional information */
    	uint32_t ee_data;    /* other data */
    						 /* More data may follow */
    };

    struct iovec {                    /* Scatter/gather array items */
    	void  *iov_base;              /* Starting address */
    	size_t iov_len;               /* Number of bytes to transfer */
    };

    struct cmsghdr {
    	size_t cmsg_len;    /* Data byte count, including header
    						(type is socklen_t in POSIX) */
    	int    cmsg_level;  /* Originating protocol */
    	int    cmsg_type;   /* Protocol-specific type */
    						/* followed by
    						unsigned char cmsg_data[]; */
    };

    struct msghdr {
    	void         *msg_name;       /* optional address */
    	socklen_t     msg_namelen;    /* size of address */
    	struct iovec *msg_iov;        /* scatter/gather array */
    	size_t        msg_iovlen;     /* # elements in msg_iov */
    	void         *msg_control;    /* ancillary data, see below */
    	size_t        msg_controllen; /* ancillary data buffer len */
    	int           msg_flags;      /* flags (unused) */
    };

    struct cmsghdr *CMSG_FIRSTHDR(struct msghdr *msgh);
    struct cmsghdr *CMSG_NXTHDR(struct msghdr *msgh, struct cmsghdr
    	*cmsg);
    size_t CMSG_ALIGN(size_t length);
    size_t CMSG_SPACE(size_t length);
    size_t CMSG_LEN(size_t length);
    unsigned char *CMSG_DATA(struct cmsghdr *cmsg);

    ssize_t recv(int sockfd, void *buf, size_t len, int flags);

    ssize_t recvfrom(int sockfd, void *buf, size_t len, int flags, struct sockaddr *src_addr, socklen_t *addrlen);

    ssize_t recvmsg(int sockfd, struct msghdr *msg, int flags);//指定缓冲区

flags;

标志          |  描述
--------|------------------------
MSG_CMSG_CLOEXEC| 为UNIX域套接字上接收的文件描述符设置执行时关闭标志
MSG_DONTWAIT |非阻塞操作（等价于使用O_NONBLOCK）
MSG_ERRQUEUE|接收错误信息作为辅助数据
MSG_OOB | 如果协议支持，获取带外数据
MSG_PEEK | 返回数据内容而不真正取走数据包，再次read或recv时依旧返回刚才数据
MSG_TRUNC| 即使数据包被截断，返回数据包实际长度
MSG_WAITALL | 等待直到所有数据可用（仅SOCK_STREAM）

对于recvmsg

flags:

标志  | 描述
--------|-----------
MSG_CTRUNC | 控制数据被截断
MSG_EOR | 接收记录结束符
MSG_ERRQUEUE | 接受错误信息作为辅助数据
MSG_OOB | 接收带外数据
MSG_TRUNC | 一般数据被截断

对于SOCK_STREAM套接字， 接收的数据可能比预期少，设置MSG_WAITALL会直到所有请求数据全部返回，recv才会返回。

对于SOCK_DGRAM和SOCK_SEQPACKET,MSG_WAITALL不起作用，因为基于报文的套接字一次读取整个报文。

如果发送方调用shutdown关闭发送，获取网络协议支持默认的顺序关闭并且发送端已经关闭，那么所有数据接收完毕后，recv返回0。

errno:

* EAGAIN or EWOULDBLOCK socket标记为非阻塞，当socket不可写时，出错返回T
* EBADF  sockfd不是一个正确的文件描述符
* ECONNREFUSED 连接被对方拒绝
* EFAULT 参数指定的地址不在合法用户空间
* EINTR  在任意数据发送前被信号中断
* EINVAL 传递了非法参数
* ENOMEM 内存不够
* ENOTCONN socket是连接类型的，但是没有连接完成
* ENOTSOCK 文件描述符没有指向socket

## 套接字选项

       int getsockopt(int sockfd, int level, int optname, void *optval, socklen_t *optlen);
       int setsockopt(int sockfd, int level, int optname, const void *optval, socklen_t optlen);

level标识协议。

* 应用于通用套接字层次选项，level设置成SOL_SOCKET
* 应用于IP， IPPROTO_IP
* 应用于TCP， IPPROTO_TCP

level:

选项 | 参数val类型 | 描述
-------|-----------------|-----------------------------------------------------------------------
SO_ACCEPTCONN | int | 返回信息指示该套接字能否被监听（仅getsockopt）
SO_BROADCAT | int | 如果*val非0，广播数据报
SO_DEBUG | int | 如果*val非0，启用网络驱动调试功能
SO_DONTROUTE | int | 如果*val非0，绕过通常路由
SO_ERROR | int | 返回挂起的套接字错误并清除（仅getsockopt）
SO_KEEPALIVE |  int | 如果*val非0，启用周期性keep-alive报文
SO_LINGER | struct linger | 当还有未发报文而套接字关闭时，延迟时间
SO_OOBINLINE  | int | 如果*val非0，将带外数据放在普通数据中
SO_RCVBUF   | int  | 接收缓冲区字节长度
SO_RCVLOWAT | int  | 接收调用中返回的最小数据字节数
SO_RCVTIMEO | struct timeval | 套接字接收调用超时值
SO_REUSEADDR | int  | 如果*val非0，重用bind中的地址
SO_SNDBUF | int  | 发送缓冲区字节长度
SO_SNDLOWAT | int | 发送调用中传送的最小数据字节数
SO_SNDTIMEO | struct timeval | 套接字发送调用的超时值
SO_TYPE | int | 标识套接字类型（仅getsockopt）

## 带外数据

       int sockatmark(int sockfd);

TCP只支持一个字节的紧急数据，数据量如果大于一个字节，最后一个字节是紧急数据，发送数据指定MSG_OOB则发送紧急数据，。需要fcntl使用F_SETOWN命令设置套接字所有权，设置完所有权后，当收到紧急数据时，会收到SIGURG信号。

当使用SO_OOBINLINE时，可以在普通数据中接收紧急数据，用sockatmark来标记紧急字节标志处。
当使用MSG_OOB时，第一个字节是紧急数据。

## 非阻塞数据

recv函数没有数据可用时会阻塞，send函数在套接字输出队列没有足够空间时，也会阻塞。在非阻塞模式下，直接出错返回errno置为EWOLDBLOCK或EAGAIN。用select，poll或epoll来判断能否接收数据或发送数据。

启用socket异步IO

1. 建立套接字所有权，这样特定套接字上的信号发送到合适的进程上去。
2. 通知套接字IO操作不会阻塞时给进程发送信号

建立套接字所有权：

1. fcntl使用F_SETOWN命令
2. ioctl中使用FIOSETOWN命令
3. ioctl中使用SIOCSPGRP命令

完成第二个步骤方式

1. fcntl中使用F_SETFL命令并且启用文件标志O_ASYNC
2. ioctl中使用FIOASYNC命令

# 例子

##  面向连接的socket获取服务器uptime的客户端

    #include "apue.h"
    #include <netdb.h>
    #include <errno.h>
    #include <sys/socket.h>

    #define BUFLEN		128

    extern int connect_retry(int, int, int, const struct sockaddr *,
    	socklen_t);

    void
    print_uptime(int sockfd)
    {
    	int		n;
    	char	buf[BUFLEN];

    	while ((n = recv(sockfd, buf, BUFLEN, 0)) > 0)
    		write(STDOUT_FILENO, buf, n);
    	if (n < 0)
    		err_sys("recv error");
    }

    int
    main(int argc, char *argv[])
    {
    	struct addrinfo	*ailist, *aip;
    	struct addrinfo	hint;
    	int				sockfd, err;

    	if (argc != 2)
    		err_quit("usage: ruptime hostname");
    	memset(&hint, 0, sizeof(hint));
    	hint.ai_socktype = SOCK_STREAM;
    	hint.ai_canonname = NULL;
    	hint.ai_addr = NULL;
    	hint.ai_next = NULL;
    	if ((err = getaddrinfo(argv[1], "ruptime", &hint, &ailist)) != 0)
    		err_quit("getaddrinfo error: %s", gai_strerror(err));
    	for (aip = ailist; aip != NULL; aip = aip->ai_next) {
    		if ((sockfd = connect_retry(aip->ai_family, SOCK_STREAM, 0,
    		  aip->ai_addr, aip->ai_addrlen)) < 0) {
    			err = errno;
    		} else {
    			print_uptime(sockfd);
    			exit(0);
    		}
    	}
    	err_exit(err, "can't connect to %s", argv[1]);
    }

    #include "apue.h"
    #include <netdb.h>
    #include <errno.h>
    #include <syslog.h>
    #include <sys/socket.h>

    #define BUFLEN	128
    #define QLEN 10

    #ifndef HOST_NAME_MAX
    #define HOST_NAME_MAX 256
    #endif

    extern int initserver(int, const struct sockaddr *, socklen_t, int);

    void
    serve(int sockfd)
    {
    	int		clfd;
    	FILE	*fp;
    	char	buf[BUFLEN];

    	set_cloexec(sockfd);
    	for (;;) {
    		if ((clfd = accept(sockfd, NULL, NULL)) < 0) {
    			syslog(LOG_ERR, "ruptimed: accept error: %s",
    			  strerror(errno));
    			exit(1);
    		}
    		set_cloexec(clfd);
    		if ((fp = popen("/usr/bin/uptime", "r")) == NULL) {
    			sprintf(buf, "error: %s\n", strerror(errno));
    			send(clfd, buf, strlen(buf), 0);
    		} else {
    			while (fgets(buf, BUFLEN, fp) != NULL)
    				send(clfd, buf, strlen(buf), 0);
    			pclose(fp);
    		}
    		close(clfd);
    	}
    }

    int
    main(int argc, char *argv[])
    {
    	struct addrinfo	*ailist, *aip;
    	struct addrinfo	hint;
    	int				sockfd, err, n;
    	char			*host;

    	if (argc != 1)
    		err_quit("usage: ruptimed");
    	if ((n = sysconf(_SC_HOST_NAME_MAX)) < 0)
    		n = HOST_NAME_MAX;	/* best guess */
    	if ((host = malloc(n)) == NULL)
    		err_sys("malloc error");
    	if (gethostname(host, n) < 0)
    		err_sys("gethostname error");
    	daemonize("ruptimed");
    	memset(&hint, 0, sizeof(hint));
    	hint.ai_flags = AI_CANONNAME;
    	hint.ai_socktype = SOCK_STREAM;
    	hint.ai_canonname = NULL;
    	hint.ai_addr = NULL;
    	hint.ai_next = NULL;
    	if ((err = getaddrinfo(host, "ruptime", &hint, &ailist)) != 0) {
    		syslog(LOG_ERR, "ruptimed: getaddrinfo error: %s",
    		  gai_strerror(err));
    		exit(1);
    	}
    	for (aip = ailist; aip != NULL; aip = aip->ai_next) {
    		if ((sockfd = initserver(SOCK_STREAM, aip->ai_addr,
    		  aip->ai_addrlen, QLEN)) >= 0) {
    			serve(sockfd);
    			exit(0);
    		}
    	}
    	exit(1);
    }

    #include "apue.h"
    #include <netdb.h>
    #include <errno.h>
    #include <syslog.h>
    #include <fcntl.h>
    #include <sys/socket.h>
    #include <sys/wait.h>

    #define QLEN 10

    #ifndef HOST_NAME_MAX
    #define HOST_NAME_MAX 256
    #endif

    extern int initserver(int, const struct sockaddr *, socklen_t, int);

    void
    serve(int sockfd)
    {
    	int		clfd, status;
    	pid_t	pid;

    	set_cloexec(sockfd);
    	for (;;) {
    		if ((clfd = accept(sockfd, NULL, NULL)) < 0) {
    			syslog(LOG_ERR, "ruptimed: accept error: %s",
    			  strerror(errno));
    			exit(1);
    		}
    		if ((pid = fork()) < 0) {
    			syslog(LOG_ERR, "ruptimed: fork error: %s",
    			  strerror(errno));
    			exit(1);
    		} else if (pid == 0) {	/* child */
    			/*
    			 * The parent called daemonize ({Prog daemoninit}), so
    			 * STDIN_FILENO, STDOUT_FILENO, and STDERR_FILENO
    			 * are already open to /dev/null.  Thus, the call to
    			 * close doesn't need to be protected by checks that
    			 * clfd isn't already equal to one of these values.
    			 */
    			if (dup2(clfd, STDOUT_FILENO) != STDOUT_FILENO ||
    			  dup2(clfd, STDERR_FILENO) != STDERR_FILENO) {
    				syslog(LOG_ERR, "ruptimed: unexpected error");
    				exit(1);
    			}
    			close(clfd);
    			execl("/usr/bin/uptime", "uptime", (char *)0);
    			syslog(LOG_ERR, "ruptimed: unexpected return from exec: %s",
    			  strerror(errno));
    		} else {		/* parent */
    			close(clfd);
    			waitpid(pid, &status, 0);
    		}
    	}
    }

    int
    main(int argc, char *argv[])
    {
    	struct addrinfo	*ailist, *aip;
    	struct addrinfo	hint;
    	int				sockfd, err, n;
    	char			*host;

    	if (argc != 1)
    		err_quit("usage: ruptimed");
    	if ((n = sysconf(_SC_HOST_NAME_MAX)) < 0)
    		n = HOST_NAME_MAX;	/* best guess */
    	if ((host = malloc(n)) == NULL)
    		err_sys("malloc error");
    	if (gethostname(host, n) < 0)
    		err_sys("gethostname error");
    	daemonize("ruptimed");
    	memset(&hint, 0, sizeof(hint));
    	hint.ai_flags = AI_CANONNAME;
    	hint.ai_socktype = SOCK_STREAM;
    	hint.ai_canonname = NULL;
    	hint.ai_addr = NULL;
    	hint.ai_next = NULL;
    	if ((err = getaddrinfo(host, "ruptime", &hint, &ailist)) != 0) {
    		syslog(LOG_ERR, "ruptimed: getaddrinfo error: %s",
    		  gai_strerror(err));
    		exit(1);
    	}
    	for (aip = ailist; aip != NULL; aip = aip->ai_next) {
    		if ((sockfd = initserver(SOCK_STREAM, aip->ai_addr,
    		  aip->ai_addrlen, QLEN)) >= 0) {
    			serve(sockfd);
    			exit(0);
    		}
    	}
    	exit(1);
    }

##  无连接的socket获取服务器uptime的客户端

    #include "apue.h"
    #include <netdb.h>
    #include <errno.h>
    #include <sys/socket.h>

    #define BUFLEN		128
    #define TIMEOUT		20

    void
    sigalrm(int signo)
    {
    }

    void
    print_uptime(int sockfd, struct addrinfo *aip)
    {
    	int		n;
    	char	buf[BUFLEN];

    	buf[0] = 0;
    	if (sendto(sockfd, buf, 1, 0, aip->ai_addr, aip->ai_addrlen) < 0)
    		err_sys("sendto error");
    	alarm(TIMEOUT);
    	if ((n = recvfrom(sockfd, buf, BUFLEN, 0, NULL, NULL)) < 0) {
    		if (errno != EINTR)
    			alarm(0);
    		err_sys("recv error");
    	}
    	alarm(0);
    	write(STDOUT_FILENO, buf, n);
    }

    int
    main(int argc, char *argv[])
    {
    	struct addrinfo		*ailist, *aip;
    	struct addrinfo		hint;
    	int					sockfd, err;
    	struct sigaction	sa;

    	if (argc != 2)
    		err_quit("usage: ruptime hostname");
    	sa.sa_handler = sigalrm;
    	sa.sa_flags = 0;
    	sigemptyset(&sa.sa_mask);
    	if (sigaction(SIGALRM, &sa, NULL) < 0)
    		err_sys("sigaction error");
    	memset(&hint, 0, sizeof(hint));
    	hint.ai_socktype = SOCK_DGRAM;
    	hint.ai_canonname = NULL;
    	hint.ai_addr = NULL;
    	hint.ai_next = NULL;
    	if ((err = getaddrinfo(argv[1], "ruptime", &hint, &ailist)) != 0)
    		err_quit("getaddrinfo error: %s", gai_strerror(err));

    	for (aip = ailist; aip != NULL; aip = aip->ai_next) {
    		if ((sockfd = socket(aip->ai_family, SOCK_DGRAM, 0)) < 0) {
    			err = errno;
    		} else {
    			print_uptime(sockfd, aip);
    			exit(0);
    		}
    	}

    	fprintf(stderr, "can't contact %s: %s\n", argv[1], strerror(err));
    	exit(1);
    }

    #include "apue.h"
    #include <netdb.h>
    #include <errno.h>
    #include <syslog.h>
    #include <sys/socket.h>

    #define BUFLEN		128
    #define MAXADDRLEN	256

    #ifndef HOST_NAME_MAX
    #define HOST_NAME_MAX 256
    #endif

    extern int initserver(int, const struct sockaddr *, socklen_t, int);

    void
    serve(int sockfd)
    {
    	int				n;
    	socklen_t		alen;
    	FILE			*fp;
    	char			buf[BUFLEN];
    	char			abuf[MAXADDRLEN];
    	struct sockaddr	*addr = (struct sockaddr *)abuf;

    	set_cloexec(sockfd);
    	for (;;) {
    		alen = MAXADDRLEN;
    		if ((n = recvfrom(sockfd, buf, BUFLEN, 0, addr, &alen)) < 0) {
    			syslog(LOG_ERR, "ruptimed: recvfrom error: %s",
    			  strerror(errno));
    			exit(1);
    		}
    		if ((fp = popen("/usr/bin/uptime", "r")) == NULL) {
    			sprintf(buf, "error: %s\n", strerror(errno));
    			sendto(sockfd, buf, strlen(buf), 0, addr, alen);
    		} else {
    			if (fgets(buf, BUFLEN, fp) != NULL)
    				sendto(sockfd, buf, strlen(buf), 0, addr, alen);
    			pclose(fp);
    		}
    	}
    }

    int
    main(int argc, char *argv[])
    {
    	struct addrinfo	*ailist, *aip;
    	struct addrinfo	hint;
    	int				sockfd, err, n;
    	char			*host;

    	if (argc != 1)
    		err_quit("usage: ruptimed");
    	if ((n = sysconf(_SC_HOST_NAME_MAX)) < 0)
    		n = HOST_NAME_MAX;	/* best guess */
    	if ((host = malloc(n)) == NULL)
    		err_sys("malloc error");
    	if (gethostname(host, n) < 0)
    		err_sys("gethostname error");
    	daemonize("ruptimed");
    	memset(&hint, 0, sizeof(hint));
    	hint.ai_flags = AI_CANONNAME;
    	hint.ai_socktype = SOCK_DGRAM;
    	hint.ai_canonname = NULL;
    	hint.ai_addr = NULL;
    	hint.ai_next = NULL;
    	if ((err = getaddrinfo(host, "ruptime", &hint, &ailist)) != 0) {
    		syslog(LOG_ERR, "ruptimed: getaddrinfo error: %s",
    		  gai_strerror(err));
    		exit(1);
    	}
    	for (aip = ailist; aip != NULL; aip = aip->ai_next) {
    		if ((sockfd = initserver(SOCK_DGRAM, aip->ai_addr,
    		  aip->ai_addrlen, 0)) >= 0) {
    			serve(sockfd);
    			exit(0);
    		}
    	}
    	exit(1);
    }
