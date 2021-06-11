#include "firebert.h"
#include "util.h"
#include "event.h"
#include "log.h"
#include "par.h"
#include "pair.h"

#include "openssl/ssl.h"

char *Host = NULL;
int Port = 80;
struct event R;
struct event W;
struct event I;
struct event L;
pwr_t *WBUF = NULL;
SSL *Ssl = NULL;

int CurFd = 0; /* XXX hack hack */	

int Reco = 0;

char *SyncPath = NULL;

static void	_oncon(int fd, int code, void *arg);

/* ------------------------------------------------------------ */

static size_t
_ssl_wrapper(u_char *bp, size_t l, void *arg) { 
	SSL *s = arg;
	int ret = -1;
	
	if((ret = SSL_write(s, bp, l)) < 0) { 
		log_warn("%%GOT-ERROR %x", SSL_get_error(s, ret));
	}	
	
	return(ret);
}

/* ------------------------------------------------------------ */

static void
_catch(int sig) {
	log_fatal("%%GOT-SIG %u", sig);
	exit(1);
}

/* ------------------------------------------------------------ */

static void
_ontx(int fd, short code, void *arg) {
	struct event *e = arg;
	if(pwr_flush(WBUF))
		event_add(e, NULL);
}

/* ------------------------------------------------------------ */

static void
_ondisco(int fd) { 
	close(fd);

	if(event_pending(&R, EV_READ, NULL))
		event_del(&R);
	if(event_pending(&W, EV_WRITE, NULL))
		event_del(&W);
	pwr_release(&WBUF);

	if(!Reco) 
		log_fatal("%%DISCONNECTED");
	else {
		log_warn("%%DISCONNECTED");
		log_status("%%CONNECTING %s:%u", Host, Port);
		if(nbc(Host, Port, _oncon, NULL) < 0) {
			log_fatal("%%FAILED %s", strerror(errno));
		}
	}
}

/* ------------------------------------------------------------ */

static void
_onrx(int fd, short code, void *arg) {
	u_char buf[8192];
	struct event *e = arg;
	ssize_t l = 0;

	if(Ssl)
		l = SSL_read(Ssl, buf, 8192);
	else
		l = read(fd, buf, 8192);

	if(l > 0) { 
		log_status("%%THEY-SAY");
		hexdump(buf, l);
		log_status("%%");
		event_add(e, NULL);
	} else if(l == 0 || errno == EBADF) {
		_ondisco(fd);
	}

	if(SyncPath) utimes(SyncPath, NULL);
}

/* ------------------------------------------------------------ */

static void 
_oninput(int fd, short code, void *arg) {
	u_char buf[8192];
	struct event *e = arg;
	size_t l = 0;

	if((l = read(fd, buf, 8192)) > 0) {
		if(l >= 8 && !memcmp(buf, "%DISCO!!", 8)) {
			_ondisco(CurFd);
		} else {			
			if(WBUF) {
				log_status("%%YOU-SAY");
				hexdump(buf, l);
				log_status("%%");

				if(pwr_produce(WBUF, buf, l))
					event_add(&W, NULL);
			} else
				log_status("%%DISCARDING");
		}
	}       

	event_add(e, NULL);
}

/* ------------------------------------------------------------ */

static void
_oncon(int fd, int code, void *arg) {
	log_status("%%CONNECTED");

       	CurFd = fd;

	if(Ssl) {
		SSL_set_connect_state(Ssl);
		SSL_set_fd(Ssl, fd);
		SSL_connect(Ssl);
	}

	if(Ssl) 
		WBUF = pwr_new(_ssl_wrapper, Ssl);	
	else
		WBUF = pwr_new(pwr_write_wrapper, v2p(fd));

	event_set(&R, fd, EV_READ, _onrx, &R);
	event_set(&W, fd, EV_WRITE, _ontx, &W);
	event_add(&R, NULL);
}

/* ------------------------------------------------------------ */

static void
_onaccept(int fd, short code, void *arg) {
	int lfd = 0;
	struct sockaddr_in si;
	unsigned sl = sizeof(si);

	zero(&si);

	if((lfd = accept(fd, (struct sockaddr *)&si, &sl)) >= 0) {
		log_status("%%CONNECTION-FROM %i", si.sin_addr.s_addr);

		WBUF = pwr_new(pwr_write_wrapper, v2p(lfd));

		event_set(&R, lfd, EV_READ, _onrx, &R);
		event_set(&W, lfd, EV_WRITE, _ontx, &W);

		if(SyncPath) utimes(SyncPath, NULL);

		event_add(&R, NULL);
	}     
}

/* ------------------------------------------------------------ */

static void 
_usage(void) {
 	fmt_eprint(	"telson [flags] [@]<host>[:port] ; # w/ flags:\n"
			"\tssl\t\t\tmake an SSL connection\n"
			"\tsync:<file>\t\ttouch <file> on I/O\n"
			"\t@\t\t\tlisten on specified host/port\n"
			"\n"
			"binary interactive netcat: shuttle I/O from localhost UDP to specified connection\n"
			"see also: blit\n");

}

/* ------------------------------------------------------------ */

int
main(int argc, char **argv) {
	int fd = 0;
	char *lhost = NULL;
	int lport = 4666;
	int listen = 0;

	if(argv[1] && !strcmp(argv[1], "-h")) {
		_usage();
		exit(1);
	}

	if(argv[1] && !strcmp(argv[1], "ssl")) {
		SSL_CTX *c = NULL;
		
		SSL_library_init();
		SSL_load_error_strings();
		
		if((c = SSL_CTX_new(SSLv23_client_method()))) {
			SSL_CTX_set_options(c, SSL_OP_ALL);
			SSL_CTX_set_default_verify_paths(c);
			Ssl = SSL_new(c);	
		} else 
			log_fatal("cannot initialize SSL");

		argv++;
		argc--;
	}

	if(argv[1] && !strcmp(argv[1], "repeat")) {
		Reco = 1;

		argv++;
		argc--;
	}

	if(argv[1] && !strncmp(argv[1], "sync:", 5)) {
		argv[1] += 5;
		SyncPath = argv[1];
		argv++;
		argc--;
	}
	
	if(argv[1] && argv[1][0] == '@') {
		listen = 1;
		argv[1]++;
	}

	firebert_init();

	signal(SIGSTOP, _catch);
	signal(SIGKILL, _catch);

	if(!argv[1]) {
		log_fatal("telson remote[:port] [local:port | port]");
	} else {
		char *cp = strchr(argv[1], ':');
		if(cp) {
			*cp++ = 0;
			Port = atoi(cp);
		}

		Host = argv[1];
	}

	if(argv[2]) {
		char *cp = strchr(argv[2], ':');
		if(cp) {
			*cp++ = 0;
			lport = atoi(cp);
			lhost = argv[2];
		} else 
			lport = atoi(argv[2]);
	}

       	if((fd = ludp(lhost, lport)) >= 0) {
		event_set(&I, fd, EV_READ, _oninput, &I);
		event_add(&I, NULL);
		setblock(fd, 0);
		log_status("%%LISTENING %s:%u", lhost ? lhost : "any", lport);

		if(!listen) { 
			log_status("%%CONNECTING %s:%u", Host, Port);
			if(nbc(Host, Port, _oncon, NULL) < 0) {
				log_fatal("%%FAILED %s", strerror(errno));
			}
		} else {
			int lfd = 0;
      			if((lfd = ltcp(Host[0] == 0 ? NULL : Host, Port)) >= 0) { 
				event_set(&L, lfd, EV_READ, _onaccept, &L);
				event_add(&L, NULL);

				log_status("%%AWAITING-CONNECTION-ON %s:%u", Host, Port);			
			} else {
				log_fatal("%%CANNOT-BIND %s:%u", Host, Port);
			}
		}

		firebert_dispatch();
	} else {
		log_fatal("%%BIND-FAILED %s", strerror(errno));
	}

	exit(1);
}
