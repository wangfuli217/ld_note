#include "firebert.h"
#include "tbuf.h"
#include "util.h"
#include "slist.h"
#include "event.h"
#include "pair.h"
#include "par.h"
#include "httprequest.h"

/* ------------------------------------------------------------ 
 * the part of global variables:
 */

/* print to stdout for blitting into telson (or stunnel, or just testing)
 */
int 	Telson 				= 0;

/* be a telson server
 */
int	BeTelson       			= 0;

/* print output and canon hexdump of response
 */
int     Verbose 			= 0;

/* the file to read POST data from, defaulting to stdin, if not on cmdline
 */
int 	PostFD 				= 0;

/* asynchronous output buffer; dump vmlinux to httpcat and it should work
 */ 
pwr_t *	Buffer 				= NULL;

/* in BeTelson mode, the raw data we're reading
 */
tbuf_t *B				= NULL;

/* request state
 */ 
httprequest_t *H = NULL;

/* transmit and receive handlers
 */
struct event TX;
struct event RX;
struct event RU;

/* ------------------------------------------------------------ 
 * called when (1) data is in the buffer and (2) the socket is writeable
 */

static void
_oncts(int fd, short code, void *arg) {
	if(pwr_flush(Buffer))
		event_add(&TX, NULL);
}

/* ------------------------------------------------------------ 
 * blindly stuff data into the buffer, try to write it, and set up callback if not complete
 */

static void
_dump(void *data, size_t len) {
	if(!Telson) {
		if(pwr_produce(Buffer, data, len) && !event_pending(&TX, EV_WRITE, NULL)) {
			event_add(&TX, NULL);
		}
	} else {
		write(fileno(stdout), data, len);
	}
}

/* ------------------------------------------------------------ 
 * when data is ready from the server
 */

static void
_onready(int fd, short code, void *arg) {
	char buf[1024];
	ssize_t l = 0;

	if((l = read(fd, buf, 1024)) > 0) {
		write(fileno(stdout), buf, l);
	} else if(l == 0 || errno == EBADF) {
		if(BeTelson)
			log_fatal("%%CONNECTION-CLOSED");			
		exit(0);		       
	}
       
	event_add(&RX, NULL);
}

/* ------------------------------------------------------------ 
 * formulate a complete HTTP request
 */

static void 
_launch(void) {
	size_t bl = 0;
	u_char *buf = NULL;

	if(BeTelson) {
		size_t dl = 0;
		u_char *data = tbuf_data(B, &dl);
		httprequest_content(H, data, dl);			
	} if(httprequest_needcontent(H)) {
		size_t dl = 0;		
		u_char *data = read_desc(PostFD, &dl);
		log_cond(data == NULL, LOG_FATAL, "cannot read data");
		httprequest_content(H, data, dl);
	}

	buf = httprequest_marshall(H, &bl);
	_dump(buf, bl);
       	       
	if(Verbose)
		hexdump(buf, bl);

	free(buf);
}

/* ------------------------------------------------------------ 
 * connects are nonblocking, because I can
 */

static void
_onconnect(int fd, int code, void *arg) {
	event_set(&RX, fd, EV_READ, _onready, NULL);
	event_add(&RX, NULL);
	event_set(&TX, fd, EV_WRITE, _oncts, NULL);
	setblock(fd, 0);	
	if((Buffer = pwr_new(pwr_write_wrapper, v2p(fd)))) {
		if(!BeTelson)
			_launch();
		else
			log_status("%%CONNECTED");
	}       
}

/* ------------------------------------------------------------ */

static void 
_oninput(int fd, short code, void *arg) {
	u_char buf[8192];
	struct event *e = arg;
	size_t l = 0;

	if((l = read(fd, buf, 8192)) > 0) {
		if(l >= 8 && !memcmp(buf, "%DISCO%", 7))
			exit(1);

		if(l >= 8 && !memcmp(buf, "%MARSH%", 7)) {
			_launch();
			tbuf_reset(B);
		} else if(B) {
			tbuf_cat(B, buf, l);

			log_status("%%YOU-SAY");
			hexdump(buf, l);
			log_status("%%");
		} else
			log_status("%%DISCARDING");
	}       

	event_add(e, NULL);
}

/* ------------------------------------------------------------ */

static void
_usage(void) {
	fmt_eprint(	"cat | httpcat [flags] <url> ; # w/flags:\n"
			"\t-T\t\toutput to stdout (to blit or netcat)\n"
			"\t-Y\t\tinteract with blit\n"
			"\t-l\t\tmanually set Content-Length\n"
			"\t-t\t\tmanually set Content-Type\n"
			"\t-d\t<data>\tset postdata on cmdline\n"
			"\t-i\t<file>\tread input from here\n"
			"\t-S\t\tfake up a SOAP request\n"
			"\t-s\t<x=y>\tset HTTP header x to y\n"
			"\t-x\t<x>\tkill header x\n"
			"\t-v\t\tverbose\n"
			"\n"
			"like a bad curl or wget. Accepts URLs of the form "
			"post://foo.com/bar, reads stdin to postdata, sets Content-Length\n");

}

/* ------------------------------------------------------------ */

int
main(int argc, char **argv) {
	int c = 0;
	char *lhost = NULL;
	int lport = 4666;

	firebert_init();

	H = httprequest_blank();

	PostFD = fileno(stdin);

	while((c = getopt(argc, argv, "hYy:Td:i:Ss:x:vt:l:")) != -1) {
		switch(c) {
		case 'T':
			Telson = 1;
			break;
		
		case 'Y':
			BeTelson = 1;
			break;

		case 'y':
			lport = atoi(optarg);
			break;

		case 'l':
			httprequest_setheader(H, "Content-Length", optarg);
			break;

		case 't':
			httprequest_setheader(H, "Content-Type", optarg);
			break;

		case 'd':
			httprequest_content(H, (u_char *) optarg, strlen(optarg));
			break;

		case 'i': 
			if(optarg[0] != '-')
				PostFD = open(optarg, O_RDONLY);
			log_cond(PostFD == -1, LOG_FATAL, "cannot open \"%s\": %s", optarg, strerror(errno));
			break;

		case 'S':
			httprequest_soap(H);
			break;

		case 's': {
			char *cp = NULL;
			if((cp = strchr(optarg, '='))) {
				*cp++ = 0;
				httprequest_setheader(H, optarg, cp);
			}
		} 	break;

		case 'x':
			httprequest_killheader(H, optarg);
			break;

		case 'v':
			Verbose = 1;
			break;						

		case 'h':
		default:
			_usage();
			exit(1);
		}
	}

	argc -= optind;
	argv += optind;

	if(argc) {
		httprequest_url(H, *argv);
	
		if(BeTelson) {
			int fd = 0;
		       	if((fd = ludp(lhost, lport)) >= 0) {
				log_status("%%LISTENING %s:%u", lhost ? lhost : "any", lport);
				log_status("%%CONNECTING %s:%u", httprequest_get_host(H), httprequest_get_port(H));

				event_set(&RU, fd, EV_READ, _oninput, &RU);
				event_add(&RU, NULL);
				setblock(fd, 0);
			} else {
				log_fatal("%%BIND-FAILED %s", strerror(errno));
			}

			httprequest_setheader(H, "Connection", "Keep-Alive");
			B = tbuf_new(NULL, 0);
		}

		if(!Telson) {
			if(nbc(httprequest_get_host(H), httprequest_get_port(H), _onconnect, NULL) >= 0) {
				firebert_dispatch();	
			}
		} else {
			_launch();
			exit(0);
		}
	}

	log_fatal("could not connect: %s", strerror(errno));
	exit(1);
}
