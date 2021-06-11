#ifndef L4_INCLUDED
#define L4_INCLUDED

#include "tcpip.h"

struct ip_h  shiftip(u_char **bp, u_char *ep, u_char **opts);
struct tcp_h shiftcp(u_char **bp, u_char *ep, u_char **opts);

u_int32_t    ipsrc(u_char *bp    );
u_int32_t    ipdst(u_char *bp);
u_char 	     ipproto(u_char *bp);
u_int16_t    iplen(u_char *bp);
u_int16_t    tcpsrc(u_char *bp);
u_int16_t    tcpdst(u_char *bp);
u_int32_t    tcpseq(u_char *bp);
u_int32_t    tcpack(u_char *bp);
u_char       tcpflags(u_char *bp);
u_char *     tcpdata(u_char *bp);
u_int16_t    udpsrc(u_char *bp);
u_int16_t    udpdst(u_char *bp);
u_char *     udpdata(u_char *bp);
u_char	     icmptype(u_char *bp);

#endif

