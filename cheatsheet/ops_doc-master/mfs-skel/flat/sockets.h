#ifndef _SOCKETS_H_
#define _SOCKETS_H_

#include <inttypes.h>
#include <errno.h>

#ifdef EWOULDBLOCK
#  define ERRNO_ERROR (errno!=EAGAIN && errno!=EWOULDBLOCK)
#else
#  define ERRNO_ERROR (errno!=EAGAIN)
#endif

/* ----------------- TCP ----------------- */

int tcpsocket(void);
int tcpresolve(const char *hostname,const char *service,uint32_t *ip,uint16_t *port,int passiveflag);
int tcpnonblock(int sock);
int tcpgetstatus(int sock);
int tcpsetacceptfilter(int sock);
int tcpreuseaddr(int sock);
int tcpnodelay(int sock);
int tcpaccfhttp(int sock);
int tcpaccfdata(int sock);
int tcpnumbind(int sock,uint32_t ip,uint16_t port);
int tcpstrbind(int sock,const char *hostname,const char *service);
int tcpnumconnect(int sock,uint32_t ip,uint16_t port);
int tcpnumtoconnect(int sock,uint32_t ip,uint16_t port,uint32_t msecto);
int tcpstrconnect(int sock,const char *hostname,const char *service);
int tcpstrtoconnect(int sock,const char *hostname,const char *service,uint32_t msecto);
int tcpnumlisten(int sock,uint32_t ip,uint16_t port,uint16_t queue);
int tcpstrlisten(int sock,const char *hostname,const char *service,uint16_t queue);
int32_t tcptoread(int sock,void *buff,uint32_t leng,uint32_t msecto);
int32_t tcptowrite(int sock,const void *buff,uint32_t leng,uint32_t msecto);
int32_t tcptoforward(int srcsock,int dstsock,void *buff,uint32_t leng,uint32_t rcvd,uint32_t sent,uint32_t msecto);
int tcptoaccept(int sock,uint32_t msecto);
int tcpaccept(int lsock);
int tcpgetpeer(int sock,uint32_t *ip,uint16_t *port);
int tcpgetmyaddr(int sock,uint32_t *ip,uint16_t *port);
int tcpclose(int sock);

/* ----------------- UDP ----------------- */

int udpsocket(void);
int udpresolve(const char *hostname,const char *service,uint32_t *ip,uint16_t *port,int passiveflag);
int udpnonblock(int sock);
int udpgetstatus(int sock);
int udpnumlisten(int sock,uint32_t ip,uint16_t port);
int udpstrlisten(int sock,const char *hostname,const char *service);
int udpwrite(int sock,uint32_t ip,uint16_t port,const void *buff,uint16_t leng);
int udpread(int sock,uint32_t *ip,uint16_t *port,void *buff,uint16_t leng);
int udpclose(int sock);

/* ----------------- UNIX ---------------- */

int unixsocket(void);
int unixnonblock(int sock);
int unixgetstatus(int sock);
int unixconnect(int sock,const char *path);
int unixtoconnect(int sock,const char *path,uint32_t msecto);
int unixlisten(int sock,const char *path,int queue);
int32_t unixtoread(int sock,void *buff,uint32_t leng,uint32_t msecto);
int32_t unixtowrite(int sock,const void *buff,uint32_t leng,uint32_t msecto);
int32_t unixtoforward(int srcsock,int dstsock,void *buff,uint32_t leng,uint32_t rcvd,uint32_t sent,uint32_t msecto);
int unixtoaccept(int sock,uint32_t msecto);
int unixaccept(int lsock);

#endif
