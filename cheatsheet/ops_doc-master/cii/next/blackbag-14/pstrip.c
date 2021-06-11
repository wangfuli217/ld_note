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

size_t 		Written = 0;
u_int64_t 	WrittenBytes = 0;
size_t 		Read = 0;
u_int64_t 	ReadBytes = 0;
int 		Full_Snap_Only = 1;
int 		No_Write = 0;
pcap_dumper_t *	D = NULL;

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

	Read += 1;
	ReadBytes += h->caplen;

	if(h->caplen >= h->len || !Full_Snap_Only) {
		Written += 1;
		WrittenBytes += h->caplen;
		if(D) 
			pcap_dump((u_char*)D, h, (u_char*) d);
	}
}

/* ------------------------------------------------------------ */

static void
_usage(void) { 
	fmt_eprint(	"pstrip [-n (don't write)] [-s (accept partials)] [-o (write here)] <file> [filter]\n"
			"\tfilter pcap file and strip partials to 'out.pcap'\n");
}

/* ------------------------------------------------------------ */

int 
main(int argc, char **argv) {
	char errbuf[PCAP_ERRBUF_SIZE];
	pcap_t *p = NULL;

	char 	*fn = NULL,
		*out = "out.pcap",
		*filt = "ip";
	
	int c = 0;

	int f_wait = 0;

	while((c = getopt(argc, argv, "no:sW")) != -1) {
       		switch(c) {
		case 'n':
			No_Write = 1;
			break;

		case 'o':
			out = optarg;
			break;

		case 's':
			Full_Snap_Only = 0;
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
	
	if((p = pcap_open_offline(fn, errbuf))) {		
		if(No_Write || (D = pcap_dump_open(p, out))) {
			pfilter(p, "%s", filt);
			pcap_loop(p, -1, _arrival, (u_char*)p); 		       
		} else {
			fmt_eprint("can't open output \"%s\"", out);
			exit(1);
		}
	} else {
		fmt_eprint("can't open file: %s\n", errbuf);
		exit(1);
	}

	if(D) {
		pcap_dump_close(D);
	}

	fmt_print("%a packets read, %a written (%.1f%%), or %.1f%% of %La total bytes\n",
		  Read, Written, ((double)Written/(double)Read)*100, ((double)WrittenBytes/(double)ReadBytes)*100, ReadBytes);

	while(f_wait) /* debug */ ; 

	exit(0);	       		
}
