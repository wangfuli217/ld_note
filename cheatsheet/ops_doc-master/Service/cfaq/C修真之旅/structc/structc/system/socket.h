﻿#ifndef _SOCKET_H
#define _SOCKET_H

#include <time.h>
#include <fcntl.h>
#include <signal.h>
#include "strerr.h"
#include <sys/types.h>

#ifdef _WIN32

#include <ws2tcpip.h>

#undef  errno
#define errno                   WSAGetLastError()

#undef  EINTR
#define EINTR                   WSAEINTR
#undef  EAGAIN
#define EAGAIN                  WSAEWOULDBLOCK
#undef  EINPROGRESS
#define EINPROGRESS             WSAEWOULDBLOCK

// WinSock 2 extension -- manifest constants for shutdown()
//
#define SHUT_RD                 SD_RECEIVE
#define SHUT_WR                 SD_SEND
#define SHUT_RDWR               SD_BOTH

#define SO_REUSEPORT            SO_REUSEADDR

typedef int socklen_t;
typedef SOCKET socket_t;

// socket_init - 初始化 socket 库初始化方法
inline void socket_init(void) {
    WSADATA version;
    WSAStartup(WINSOCK_VERSION, &version);
}

// socket_close     - 关闭上面创建后的句柄
inline int socket_close(socket_t s) {
    return closesocket(s);
}

// socket_set_block     - 设置套接字是阻塞
inline int socket_set_block(socket_t s) {
    u_long mode = 0;
    return ioctlsocket(s, FIONBIO, &mode);
}

// socket_set_nonblock  - 设置套接字是非阻塞
inline int socket_set_nonblock(socket_t s) {
    u_long mode = 1;
    return ioctlsocket(s, FIONBIO, &mode);
}

#else

#include <netdb.h>
#include <unistd.h>
#include <sys/un.h>
#include <sys/uio.h>
#include <sys/time.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/tcp.h>
#include <sys/resource.h>

// This is used instead of -1, since the. by WinSock
// On now linux EAGAIN and EWOULDBLOCK may be the same value 
// connect 链接中, linux 是 EINPROGRESS，winds 是 WSAEWOULDBLOCK
//
typedef int socket_t;

#define INVALID_SOCKET          (~0)
#define SOCKET_ERROR            (-1)

// socket_init - 初始化 socket 库初始化方法
inline void socket_init(void) {
    // 管道破裂, 忽略 SIGPIPE 信号
    signal(SIGPIPE, SIG_IGN);
}

inline int socket_close(socket_t s) {
    return close(s);
}

// socket_set_block     - 设置套接字是阻塞
inline static int socket_set_block(socket_t s) {
    int mode = fcntl(s, F_GETFL, 0);
    return fcntl(s, F_SETFL, mode & ~O_NONBLOCK);
}

// socket_set_nonblock  - 设置套接字是非阻塞
inline int socket_set_nonblock(socket_t s) {
    int mode = fcntl(s, F_GETFL, 0);
    return fcntl(s, F_SETFL, mode | O_NONBLOCK);
}

#endif

// socket_recv      - 读取数据
inline int socket_recv(socket_t s, void * buf, int sz) {
    return sz > 0 ? (int)recv(s, buf, sz, 0) : 0;
}

// socket_send      - 写入数据
inline int socket_send(socket_t s, const void * buf, int sz) {
    return (int)send(s, buf, sz, 0);
}

//
// 通用 sockaddr_in ipv4 地址
//
typedef struct sockaddr_in sockaddr_t[1];

// socket_dgram     - 创建 UDP socket
inline socket_t socket_dgram(void) {
    return socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
}

// socket_stream    - 创建 TCP socket
inline socket_t socket_stream(void) {
    return socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
}

inline int socket_set_enable(socket_t s, int optname) {
    int ov = 1;
    return setsockopt(s, SOL_SOCKET, optname, (void *)&ov, sizeof ov);
}

// socket_set_reuse - 开启端口和地址复用
inline int socket_set_reuse(socket_t s) {
    return socket_set_enable(s, SO_REUSEPORT);
}

// socket_set_keepalive - 开启心跳包检测, 默认 5次/2h
inline int socket_set_keepalive(socket_t s) {
    return socket_set_enable(s, SO_KEEPALIVE);
}

inline int socket_set_time(socket_t s, int ms, int optname) {
    struct timeval ov = { 0,0 };
    if (ms > 0) {
        ov.tv_sec = ms / 1000;
        ov.tv_usec = (ms % 1000) * 1000;
    }
    return setsockopt(s, SOL_SOCKET, optname, (void *)&ov, sizeof ov);
}

// socket_set_rcvtimeo - 设置接收数据毫秒超时时间
inline int socket_set_rcvtimeo(socket_t s, int ms) {
    return socket_set_time(s, ms, SO_RCVTIMEO);
}

// socket_set_sndtimeo - 设置发送数据毫秒超时时间
inline int socket_set_sndtimeo(socket_t s, int ms) {
    return socket_set_time(s, ms, SO_SNDTIMEO);
}

// socket_get_error - 得到当前socket error 值, 0 表示正确, 其它都是错误
inline int socket_get_error(socket_t s) {
    int err;
    socklen_t len = sizeof(err);
    int r = getsockopt(s, SOL_SOCKET, SO_ERROR, (void *)&err, &len);
    return r < 0 ? errno : err;
}

// socket_recvfrom  - recvfrom 接受函数
inline int socket_recvfrom(socket_t s, void * buf, int sz, sockaddr_t in) {
    socklen_t inlen = sizeof (sockaddr_t);
    return recvfrom(s, buf, sz, 0, (struct sockaddr *)in, &inlen);
}

// socket_sendto    - sendto 发送函数
inline int socket_sendto(socket_t s, const void * buf, int sz, const sockaddr_t to) {
    return sendto(s, buf, sz, 0, (const struct sockaddr *)to, sizeof (sockaddr_t));
}

//
// socket_recvn     - socket 接受 sz 个字节
// socket_sendn     - socket 发送 sz 个字节
//
extern int socket_recvn(socket_t s, void * buf, int sz);
extern int socket_sendn(socket_t s, const void * buf, int sz);

// socket_bind          - bind    绑定函数
inline int socket_bind(socket_t s, const sockaddr_t addr) {
    return bind(s, (const struct sockaddr *)addr, sizeof(sockaddr_t));
}

// socket_listen        - listen  监听函数
inline int socket_listen(socket_t s) {
    return listen(s, SOMAXCONN);
}

// socket_accept        - accept  等接函数
inline socket_t socket_accept(socket_t s, sockaddr_t addr) {
    socklen_t len = sizeof (sockaddr_t);
    return accept(s, (struct sockaddr *)addr, &len);
}

// socket_connect       - connect 链接函数
inline int socket_connect(socket_t s, const sockaddr_t addr) {
    return connect(s, (const struct sockaddr *)addr, sizeof(sockaddr_t));
}

// socket_getsockname - 获取 socket 的本地地址
inline int socket_getsockname(socket_t s, sockaddr_t name) {
    socklen_t len = sizeof (sockaddr_t);
    return getsockname(s, (struct sockaddr *)name, &len);
}

// socket_getpeername - 获取 client socket 的地址
inline int socket_getpeername(socket_t s, sockaddr_t name) {
    socklen_t len = sizeof (sockaddr_t);
    return getpeername(s, (struct sockaddr *)name, &len);
}

//
// socket_binds     - 端口绑定返回绑定好的 socket fd, 返回 INVALID_SOCKET or PF_INET PF_INET6
// socket_listens   - 端口监听返回监听好的 socket fd.
//
extern socket_t socket_binds(const char * ip, uint16_t port, uint8_t protocol, int * family);
extern socket_t socket_listens(const char * ip, uint16_t port, int backlog);

//
// socket_addr -socket_recv 通过 ip, port 构造 ipv4 结构
//
extern int socket_addr(const char * ip, uint16_t port, sockaddr_t addr);

// socket_pton - 返回 ip 串
inline char * socket_pton(sockaddr_t addr, char ip[INET_ADDRSTRLEN]) {
    return (char *)inet_ntop(AF_INET, &addr->sin_addr, ip, INET_ADDRSTRLEN);
}

//
// socket_host - 通过 ip:port 串得到 socket addr 结构
// host     : ip:port 串
// addr     : 返回最终生成的地址
// return   : >= EBase 表示成功
//
extern int socket_host(const char * host, sockaddr_t addr);

//
// socket_tcp - 创建 TCP 详细套接字
// host     : ip:port 串  
// return   : 返回监听后套接字
//
extern socket_t socket_tcp(const char * host);

//
// socket_udp - 创建 UDP 详细套接字
// host     : ip:port 串  
// return   : 返回绑定后套接字
//
extern socket_t socket_udp(const char * host);

//
// socket_connects - 返回链接后的阻塞套接字
// host     : ip:port 串  
// return   : 返回链接后阻塞套接字
//
extern socket_t socket_connects(const char * host);

//
// socket_connectos - 返回链接后的非阻塞套接字
// host     : ip:port 串  
// ms       : 链接过程中毫秒数
// return   : 返回链接后非阻塞套接字
//
extern socket_t socket_connectos(const char * host, int ms);

#endif//_SOCKET_H
