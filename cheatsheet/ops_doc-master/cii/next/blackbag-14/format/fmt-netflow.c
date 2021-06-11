#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <time.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>
#include <assert.h>
#include <ctype.h>

#include "format/fmt.h"
#include "format/fmt-extra.h"
#include "flow.h"

/* -------------------------------------------------------------------- */

static void
fmt_netflow_rec_short(fmt_code_info_t *cvt)
{
	char buf[256];
	const flow_t *rp = va_arg(*cvt->app, const flow_t *);
	fmt_sfmt(buf, sizeof(buf),
		 "%i:%u->%i:%u if(i/o)#%u/%u p#%u %.2fkb %.2fkp",
		 rp->src_addr, ntohs(rp->src_port),
		 rp->dst_addr, ntohs(rp->dst_port),
		 ntohs(rp->input_iface), ntohs(rp->output_iface),
		 rp->ip_proto,
		 ((double)ntohl(rp->bytes_sent) / 1000.0),
		 ((double)ntohl(rp->pkts_sent) / 1000.0));
	fmt_puts(buf, strlen(buf), cvt);
}

void
fmt_register_netflow_short(char c)
{
	fmt_register(toupper(c), fmt_netflow_rec_short);
}

/* -------------------------------------------------------------------- */

static void
fmt_netflow_rec_long(fmt_code_info_t *cvt)
{
	char buf[256], dst[32], src[32], icmp[32];
	const flow_t *rp = va_arg(*cvt->app, const flow_t *);

	if (rp->ip_proto == IPPROTO_TCP ||
	    rp->ip_proto == IPPROTO_UDP) {
		fmt_sfmt(src, sizeof(src), "%i:%u (%u)",
		    rp->src_addr, ntohs(rp->src_port), ntohs(rp->input_iface));
		fmt_sfmt(dst, sizeof(dst), "%i:%u (%u)",
		    rp->dst_addr, ntohs(rp->dst_port), ntohs(rp->output_iface));
	} else {
		fmt_sfmt(src, sizeof(src), "%i (%u)",
		    rp->src_addr, ntohs(rp->input_iface));
		fmt_sfmt(dst, sizeof(dst), "%i (%u)",
		    rp->dst_addr, ntohs(rp->output_iface));
	}

	if (rp->ip_proto == IPPROTO_ICMP)
		fmt_sfmt(icmp, sizeof(icmp), "icmp %d/%d",
		    FLOW_ICMP_TYPE(rp), FLOW_ICMP_CODE(rp));
	else
		icmp[0] = '\0';

	fmt_sfmt(buf, sizeof(buf),
	    " %-29s > %-29s  %i\n"
	    " pkts %-8u bytes %-11u prot %-3u  tcp 0x%02x  tos 0x%02x  %s",
	    src, dst, rp->next_hop,
	    ntohl(rp->pkts_sent), ntohl(rp->bytes_sent),
	    rp->ip_proto, rp->tcp_flags, rp->tos, icmp);
	fmt_puts(buf, strlen(buf), cvt);
}

void
fmt_register_netflow_long(char c)
{
	fmt_register(toupper(c), fmt_netflow_rec_long);
}
