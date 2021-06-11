#include "firebert.h"
#include "format/fmt.h"
#include "util.h"
#include "strutil.h"
#include "hash.h"
#include "tcpip.h"
#include "l4.h"
#include "ether_utils.h"

#include <stdarg.h>
#include <ctype.h>
#include <pcap.h>

int Select = -1;

hash_t *TCBS = NULL;
u_int64_t Total = 0;

/* ------------------------------------------------------------ */

struct tcbk { 
	u_int32_t s;
	u_int32_t d;
	u_int16_t sp;
	u_int16_t dp;
	u_int64_t ctr;
};

// ------------------------------------------------------------ 

static void
_eachtcb(const void *kp, size_t l, void **v, void *cl) {
	int *ctr = cl;
	struct tcbk *k = *((struct tcbk **)v);

	if(Select == -1) {
		fmt_print("/* %d */ %i:%u -> %i:%u /* %.1f%% */\n", *ctr, k->s, k->sp, k->d, k->dp,
			  ((double)k->ctr / (double)Total) * 100);
	} else if(*ctr == Select) {
		fmt_print("tcp and host %i and host %i and port %u and port %u\n", 
       		  k->s, k->d, k->sp, k->dp);
	}

	*ctr += 1;
}

// ------------------------------------------------------------ 

static struct tcbk *
_get(struct tcbk *k) {
	return(hash_get(TCBS, k, sizeof *k - 8));
}

// ------------------------------------------------------------ 

static void
_put(struct tcbk *k) {
	k = bufdup(k, sizeof(*k));
	if((k = hash_put(TCBS, k, sizeof *k - 8, k))) {
		free(k);
	}
}

// ------------------------------------------------------------ 

static void
_kill(struct tcbk *k) {
	pair_t p = hash_delete(TCBS, k, sizeof *k - 8);
	free(p.key);
}

// ------------------------------------------------------------ 

static inline void 
_swap(struct tcbk *k) {
	u_int32_t t = k->d;
	k->d = k->s;
	k->s = t;       
	t = k->dp;
	k->dp = k->sp;
	k->sp = (u_int16_t) t;
}

// ------------------------------------------------------------ 

static void
_ip(u_char *ip, size_t l) {
	struct tcbk k, alt, *p = NULL;

	k.ctr = l;
	k.s = htonl(ipsrc(ip));
	k.d = htonl(ipdst(ip));
	k.sp = tcpsrc(ip);
	k.dp = tcpdst(ip);

	alt = k;
	_swap(&alt);

	Total += l;

	if(tcpflags(ip) == TH_SYN) {	
		_swap(&alt);
		_kill(&alt);
		_put(&k);
	} else if(!(p = _get(&alt)) && !(p = _get(&k))) {
		if(k.sp < k.dp)
			_put(&alt);
		else
			_put(&k);
	} else {
		p->ctr += l;
	}
}

// ------------------------------------------------------------ 

static void
_arrival(u_char *v, const struct pcap_pkthdr *h, const u_char *d) {
	static int DL = -1;
	pcap_t *p = (pcap_t *) v;
	size_t l = 0;
	u_char *ip = NULL;

	if(DL == -1) DL = pcap_datalink(p);

	ip = link_to_ip(DL, (u_char*) d, h->caplen);
	l = h->caplen - (size_t)(ip - d);
	
	if(ipproto(ip) == IPPROTO_TCP && l >= 40 /* semi-safe */) 
		_ip(ip, l);
}

/* ------------------------------------------------------------ */

static void
_usage(void) {
	fmt_eprint(	"tcbs [-s (print filter for TCB #)] <file> [filter]\n"
			"summarize all TCP connections in <file>\n");
}

/* ------------------------------------------------------------ */

int 
main(int argc, char **argv) {
	char errbuf[PCAP_ERRBUF_SIZE];
	pcap_t *p = NULL;

	char 	*fn = NULL,
		*filt = "tcp";
	
	int c = 0;

	int f_wait = 0;

	while((c = getopt(argc, argv, "hs:W")) != -1) {
       		switch(c) {
		case 's':
			Select = atoi(optarg);
			break;

		case 'W':
			f_wait = 1;
			break;

		case 'h':
		default:
			_usage();
			exit(1);		       		
		}
	}

	argc -= optind;
	argv += optind;	       

	if(argc < 1) {
		_usage();
		exit(1);
	}

	fn = argv[0];
	if(argc > 1) 
		filt = copy_argv(&argv[1]);

	TCBS = hash_new(100);
	
	if((p = pcap_open_offline(fn, errbuf))) {		
		pfilter(p, "%s and tcp[tcpflags] & (tcp-rst|tcp-fin) == 0", filt);
		pcap_loop(p, -1, _arrival, (u_char*)p); 		       
	} else {
		fmt_eprint("can't open file: %s\n", errbuf);
		exit(1);
	}

	c = 0;
	hash_map(TCBS, _eachtcb, &c);

	while(f_wait) /* debug */ ; 

	exit(0);	       		
}
