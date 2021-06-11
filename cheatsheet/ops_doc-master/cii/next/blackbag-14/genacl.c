#include "firebert.h"
#include "aguri.h"
#include "util.h"
#include "strutil.h"
#include "bfmt.h"
#include "fmt.h"
#include "tcpip.h"

#include <pcap.h>

aguri_t 	*Sources = NULL,      
		*Targets = NULL,
		*TCPPorts = NULL, 
		*UDPPorts = NULL;	

/* ------------------------------------------------------------ */

size_t Off = 0;

static void 
_handle(u_char *cl, const struct pcap_pkthdr *h, const u_char *p) {
	u_char *bp = (u_char *) p;
	struct ip_h *ih = NULL;

	if(Off) {
		Off--;
		return;
	}

#if 1    // if running straight from pcap, skip llh
	bp += 14;
#endif

	ih = (struct ip_h *) bp;
	bp += ih->ip_hl * 4;	

	if(ih->ip_p == 6) {
		struct tcp_h *th = (struct tcp_h *) bp;
		aguri_add(Sources, &(ih->ip_src), h->len);
		aguri_add(Targets, &(ih->ip_dst), h->len);
		aguri_add(TCPPorts, &(th->th_dport), h->len);	
	} else if(ih->ip_p == 17) {
		struct udp_h *uh = (struct udp_h *) bp;
		aguri_add(Sources, &(ih->ip_src), h->len);
		aguri_add(Targets, &(ih->ip_dst), h->len);
		aguri_add(UDPPorts, &(uh->uh_dport), h->len);	
	}	
}

/* ------------------------------------------------------------ */

static int
_ip(size_t pbits, u_char *kv, u_int64_t bytes, int depth, void *cl) {
	u_int32_t ip = ld32(&kv, &kv[5]);
	u_int32_t m = mlen2mask(pbits);

	if(!bytes)
		return(0);

	if(depth) while(depth--) fputc(' ', stdout);

	ip &= m;

	fmt_print("%i/%u (%.3fM)\n", ip, pbits, (double)((double)bytes / 1000000.0));

	return(0);
}

/* ------------------------------------------------------------ */

static int
_port(size_t pbits, u_char *kv, u_int64_t bytes, int depth, void *cl) {
	u_int16_t p = ld16(&kv, &kv[3]);
	u_int32_t m = mlen2mask(pbits) >> 16;
	u_int16_t pmx = p;

	if(!bytes)
		return(0);

	if(depth) while(depth--) fputc(' ', stdout);

	p &= m;
	pmx |= ~m;

	if(pmx != p) {
		fmt_print("%u-%u (%.3fM)\n", p, pmx, (double)((double)bytes / 1000000.0));
	} else {
		fmt_print("%u (%.3fM)\n", p, pmx, (double)((double)bytes / 1000000.0));
	}
	
	return(0);
}

/* ------------------------------------------------------------ */

extern void aguri_print(aguri_t *);

int
main(int argc, char **argv) {
	char errbuf[PCAP_ERRBUF_SIZE];
	pcap_t *p = NULL;
	int cnt = -1;
	u_int64_t thresh = 10000;
	int c = 0;

	while((c = getopt(argc, argv, "c:t:o:")) != -1) {
		switch(c) {
		case 'c':
			cnt = strtoamt(optarg);
			break;
		case 't':
			thresh = strtoamt(optarg);
			break;
		default:
			fprintf(stderr, "??\n");
			exit(1);
		}

	}

	argc -= optind;
	argv += optind;

	if(argc && (p = pcap_open_live(*argv, 100, 1, 10, errbuf))) {
		if(argc > 1) { 
			char *filt = copy_argv(&argv[1]);
			pfilter(p, "%s", filt);
		}

		Sources = aguri_new(32, 1000);
		Targets = aguri_new(32, 1000);
		TCPPorts = aguri_new(16, 1000);
		UDPPorts = aguri_new(16, 1000);

		pcap_loop(p, cnt, _handle, NULL);

		if(thresh != 1) {
			aguri_aggregate(Sources, thresh);
			aguri_aggregate(Targets, thresh);
			aguri_aggregate(TCPPorts, thresh);	       
			aguri_aggregate(UDPPorts, thresh);
		}

		puts("# Sources");
	
		aguri_walk(Sources, _ip, NULL);

		puts("# Targets");

		aguri_walk(Targets, _ip, NULL);

		puts("# TCP");

       		aguri_walk(TCPPorts, _port, NULL);

		puts("# UDP");

		aguri_walk(UDPPorts, _port, NULL);	       
	}		

	exit(0);
}
