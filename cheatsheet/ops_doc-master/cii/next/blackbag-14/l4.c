#include "firebert.h"
#include "l4.h"
#include <stddef.h>
#include "util.h"
#include "bfmt.h"

/* ------------------------------------------------------------ */

struct ip_h 
shiftip(u_char **bp, u_char *ep, u_char **opts) {
	struct ip_h ret;

	if((size_t)(ep - *bp) > 20) {
		memcpy(&ret, *bp, sizeof ret);
		*bp += sizeof ret;

		if((ret.ip_hl * 4) > sizeof ret) {
			size_t x = (ret.ip_hl * 4) - sizeof ret;
			if(*opts)
				*opts = *bp;

			*bp += x;
		}		 		
	} else {
		memset(&ret, 0, sizeof ret);
	}

	return(ret);
}

/* ------------------------------------------------------------ */

struct tcp_h 
shiftcp(u_char **bp, u_char *ep, u_char **opts) {
	struct tcp_h ret;

	if((size_t)(ep - *bp) > sizeof ret) {
		memcpy(&ret, *bp, sizeof ret);
		*bp += sizeof ret;

		if((ret.th_off * 4) > sizeof ret) {
			size_t x = (ret.th_off * 4) - sizeof ret;
			if(*opts)
				*opts = *bp;

			*bp += x;
		}		 		
	} else {
		memset(&ret, 0, sizeof ret);
	}

	return(ret);
}

/* ------------------------------------------------------------ */

u_int32_t
ipsrc(u_char *buf) {
	buf += offsetof(struct ip_h, ip_src);
	return(nld32(&buf, &buf[5]));       	
}

/* ------------------------------------------------------------ */

u_int32_t
ipdst(u_char *buf) {
	buf += offsetof(struct ip_h, ip_dst);
	return(nld32(&buf, &buf[5]));       	
}

/* ------------------------------------------------------------ */

u_char
ipproto(u_char *buf) {
	buf += offsetof(struct ip_h, ip_p);
	return *buf;
}

/* ------------------------------------------------------------ */

u_int16_t
tcpsrc(u_char *buf) {
	int hl = ((*buf) & 0xF) * 4;
	buf += (hl + offsetof(struct tcp_h, th_sport));
	return(nld16(&buf, &buf[3]));
}

/* ------------------------------------------------------------ */

u_int16_t
tcpdst(u_char *buf) {
	int hl = ((*buf) & 0xF) * 4;
	buf += (hl + offsetof(struct tcp_h, th_dport));
	return(nld16(&buf, &buf[3]));
}

/* ------------------------------------------------------------ */

u_int32_t
tcpseq(u_char *buf) {
	int hl = ((*buf) & 0xF) * 4;
	buf += (hl + offsetof(struct tcp_h, th_seq));
	return(nld32(&buf, &buf[5]));
}

/* ------------------------------------------------------------ */

u_int32_t
tcpack(u_char *buf) {
	int hl = ((*buf) & 0xF) * 4;
	buf += (hl + offsetof(struct tcp_h, th_ack));
	return(nld16(&buf, &buf[5]));
}

/* ------------------------------------------------------------ */

u_char 
tcpflags(u_char *buf) {
	int hl = ((*buf) & 0xF) * 4;
	buf += (hl + offsetof(struct tcp_h, th_flags));
	return *buf;
}

/* ------------------------------------------------------------ */

u_char *
tcpdata(u_char *buf) {
	int hl = ((*buf) & 0xF) * 4, tl = 0;
	buf += hl;
	tl = buf[12 /*XXX*/];
	tl >>= 4;
	tl *= 4;
	buf += tl;
       	return(buf);
}

/* ------------------------------------------------------------ */

u_int16_t
udpsrc(u_char *buf) {
	int hl = ((*buf) & 0xF) * 4;
	buf += (hl + offsetof(struct udp_h, uh_sport));
	return(nld16(&buf, &buf[5]));
}

/* ------------------------------------------------------------ */

u_int16_t
udpdst(u_char *buf) {
	int hl = ((*buf) & 0xF) * 4;
	buf += (hl + offsetof(struct udp_h, uh_dport));
	return(nld16(&buf, &buf[5]));
}

/* ------------------------------------------------------------ */

u_char *
udpdata(u_char *buf) {
	int hl = ((*buf) & 0xF) * 4;
	buf += hl;
	return(&buf[8]);
}

/* ------------------------------------------------------------ */

u_int16_t
icmpproto(u_char *buf) {
	int hl = ((*buf) & 0xF) * 4;
        buf += (hl + offsetof(struct icmp_h, icmp_type));
	return(*buf);
}
