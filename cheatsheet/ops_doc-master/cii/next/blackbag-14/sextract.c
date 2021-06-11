#include "firebert.h"
#include "format/fmt.h"
#include "util.h"
#include "mfile.h"
#include "strutil.h"
#include "vector.h"
#include "tcb.h"
#include "engine.h"
#include "tcpip.h"
#include "check.h"
#include "slist.h"
#include <stdarg.h>
#include <ctype.h>
#include <pcap.h>

static ctx_t P; 


/* ------------------------------------------------------------ */

static void
_arrival(u_char *v, const struct pcap_pkthdr *p, const u_char *d) {
	ip(&P, (u_char*)&d[14], p->len - 14);
}

/* ------------------------------------------------------------ */

static void
_chrdump(u_char *buf, size_t len) {
	while(len--) {
		if(isprint(*buf) || isspace(*buf)) fputc(*buf, stdout);
		else fputc('.', stdout);
		buf++;
	}
}

/* ------------------------------------------------------------ */

static void
_usage(void) {
	fmt_eprint(	"sextract [opts] <file> [filter]\n"
			"\t-a\t\t: safe ASCII\n"
			"\t-b\t\t: raw binary\n"
			"\t(default)\t: canon hex\n"
			"\t-h\t\t: suppress headers\n"
			"\t-d\t\t: suppress dividers\n"
			"\t-i\t\t: src stream only\n"
			"\t-o\t\t: dst stream only\n");       
}

/* ------------------------------------------------------------ */

int 
main(int argc, char **argv) {
	char errbuf[PCAP_ERRBUF_SIZE];
	pcap_t *p = NULL;
	slist_t *n = NULL;

	char 	*fn = NULL,
		*filt = "tcp";
	
	int c = 0;

	int 	f_ascii = 0,
		f_hex = 1,
		f_bin = 0, 
		f_div = 1,
		f_only = 0,
		f_header = 1,
		f_wait = 0;



	extern int Printer;              

	while((c = getopt(argc, argv, "abdhioW")) != -1) {
       		switch(c) {
		case 'W':
			f_wait = 1;
			break;

		case 'a':
			f_ascii = 1;
			f_hex = 0;
			f_bin = 0;
			break;
		case 'b':
			f_bin = 1;
			f_hex = 0;
			f_ascii = 0;
			break;
		case 'd':
			f_div = 0;
			break;
		case 'h':
			f_header = 0;
			break;
		case 'i':
			f_only = -1;
			break;
		case 'o':
			f_only = 1;
			break;

		case '?':
		default:
			_usage();
			exit(1);		       		
		}
	}

	argc -= optind;
	argv += optind;	       

	Printer = 0;

	if(argc < 1) {
		_usage();
		exit(1);
	}

	fn = argv[0];
	if(argc > 1) 
		filt = copy_argv(&argv[1]);

	if((p = pcap_open_offline(fn, errbuf))) {		
		pfilter(p, "%s and tcp[tcpflags] & (tcp-rst|tcp-fin) == 0", filt);
		memset(&P, 0, sizeof(P));
		tcb_init();
		pcap_loop(p, -1, _arrival, NULL); 		       
	} else {
		fmt_eprint("can't open file: %s\n", errbuf);
		exit(1);
	}

	for(n = tcb_all(); n; n = n->next) { 
		tcb_t *t = n->data;
		size_t sl, dl;
		u_int32_t sh, dh;
		u_char *sb = NULL, *db = NULL;
		u_int32_t s, d;
		u_int16_t sp, dp;
	
		if(tcb_meta(t)->ss) {
			sl = mfile_size(tcb_meta(t)->ss);
			sb = malloc(sl);
			mfile_read(tcb_meta(t)->ss, sb, sl);
			sh = bhash64(sb, sl);
       		} else {
			sl = 0;
			sh = 0;
		}

		if(tcb_meta(t)->ds) {
			dl = mfile_size(tcb_meta(t)->ds);
			db = malloc(dl);
			mfile_read(tcb_meta(t)->ds, db, dl);
			dh = bhash64(db, dl);
		} else {
			dl = 0;
			dh = 0;
		}

		tcb_addrs(t, &s, &d);
		tcb_ports(t, &sp, &dp);
	
		if(f_header)
		fmt_print("%i:%u -> %i:%u %lu:%lx / %lu:%lx\n%%%%%%\n",
			  s, sp, d, dp, sl, sh, dl, dh);

		if(f_hex) {
			if(f_only <= 0 && sb) hexdump(sb, sl);
			if(f_div) fputs("\n%%%\n", stdout);
			if(f_only >= 0 && db) hexdump(db, dl);			  	
			if(f_div) fputs("\n%%%\n", stdout);
		} else if(f_ascii) {
			if(f_only <= 0 && sb) _chrdump(sb, sl);
			if(f_div) fputs("\n%%%\n", stdout);
			if(f_only >= 0 && db) _chrdump(db, dl);			  	
			if(f_div) fputs("\n%%%\n", stdout);
		} else {
			if(f_only <= 0 && sb) fwrite(sb, sl, 1, stdout);
			if(f_div) fputs("\n%%%\n", stdout);
			if(f_only >= 0 && db) fwrite(db, dl, 1, stdout);	  	
			if(f_div) fputs("\n%%%\n", stdout);
		}
	}

	while(f_wait) /* debug */ ; 

	exit(0);	       		
}
