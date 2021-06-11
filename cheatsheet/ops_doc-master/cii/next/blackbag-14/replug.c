#include "firebert.h"
#include "plugboard.h"
#include "log.h"
#include "util.h"
#include "event.h"

int LogBinaryDumps = 0;
struct event U_C_RX;
struct event U_S_RX;
int U_I_FD = 0;
int U_O_FD = 0;
struct sockaddr_in Last_Client;

/* ------------------------------------------------------------ */

static void 
_log(int serverp, u_int32_t ip, u_int16_t port, u_char *data, size_t len) {
	if(LogBinaryDumps) {
		FILE *fp = NULL;

		/* sure it's expensive that's what makes it fun ok?
		 */
		if((fp = pfopen("a+", "%i:%u.%s.dump", ip, port, serverp ? "rx" : "tx"))) {
			fwrite(data, len, 1, fp);
			fclose(fp);
		}

		if((fp = pfopen("a+", "spans.%i:%u", ip, port))) {
			fprintf(fp, "%s %lu\n", serverp ? "S" : "C", len);
			fclose(fp);
		}
	}
}

/* ------------------------------------------------------------ */

static void 
_logframe(int serverp, u_int32_t ip, u_int16_t port, u_char *data, size_t len) {
	u_char *bp = data, *ep = &data[len];

}

/* ------------------------------------------------------------ */

static void
_onucrx(int fd, short code, void *arg) {
	struct sockaddr_in si;
	unsigned sil = sizeof(si);
	size_t ret = 0;
	u_char buf[65535];
	zero(&si);

	if((ret = recvfrom(fd, buf, sizeof buf, 0, (struct sockaddr *)&si, &sil))) {
		if(1) { 
			_log(0, si.sin_addr.s_addr, ntohs(si.sin_port), buf, ret);

			log_status("%%CLIENT-SAYS");
			hexdump(buf, ret);
			log_status("%%SO-THERE");	
		} 

		Last_Client = si;
		if(send(U_O_FD, buf, ret, 0) < ret) {
			log_warn("%%WRITE-FAILED from %i:%u: %s", si.sin_addr.s_addr, ntohs(si.sin_port), strerror(errno));
		}
	}

	event_add(arg, NULL);
}

/* ------------------------------------------------------------ */

static void
_onusrx(int fd, short code, void *arg) { 
	struct sockaddr_in si;
	unsigned sil = sizeof(si);
	size_t ret = 0; 
	u_char buf[65535];
	zero(&si);

	if((ret = recvfrom(fd, buf, sizeof buf, 0, (struct sockaddr *)&si, &sil))) {
		if(1) {
			_log(1, si.sin_addr.s_addr, ntohs(si.sin_port), buf, ret);

			log_status("%%SERVER-SAYS");
			hexdump(buf, ret);
			log_status("%%SO-THERE");	
		} 

		si = Last_Client;
		sil = sizeof(si);

		if(sendto(U_I_FD, buf, ret, 0, (struct sockaddr *)&si, sil) < ret) { 
			log_warn("%%WRITE-FAILED to %i:%u: %s", si.sin_addr.s_addr, ntohs(si.sin_port), strerror(errno));
		}
	}

	event_add(arg, NULL);
}

/* ------------------------------------------------------------ */

static size_t
_onsdata(u_int32_t ip, u_int16_t port, u_char *data, size_t len, void *arg) {
	_log(1, ip, port, data, len);
	log_status("%%SERVER-SAYS");
	hexdump(data, len);
	log_status("%%SO-THERE");	
	return(len);
}

/* ------------------------------------------------------------ */

static size_t
_oncdata(u_int32_t ip, u_int16_t port, u_char *data, size_t len, void *arg) {
	_log(0, ip, port, data, len);
	log_status("%%CLIENT-SAYS");
	hexdump(data, len);
	log_status("%%SO-THERE");
	return(len);
}

/* ------------------------------------------------------------ */

static void
_onclient(u_int32_t ip, u_int16_t port, int openp, void *arg) {
	log_status("%%%s %i:%u", openp ? "CONNECTED" : "DISCONNECTED", ip, port);
}

/* ------------------------------------------------------------ */

int
main(int argc, char **argv) {
	plug_t *p = NULL;
	int c = 0;
	int udp = 0;

	firebert_init();

	while((c = getopt(argc, argv, "bu")) != -1) {
		switch(c) {
		case 'u':
			udp = 1;
			break;
		case 'b':
			LogBinaryDumps = 1;
			break;
		case '?':
		default:
		usage:
			log_fatal("replug [-b (log)] [-u (UDP)] target[:port[@lport]]");
			exit(1);
		}
	}

	argc -= optind;
	argv += optind;		
	
	if(*argv) {
		u_int16_t port = 80;
		u_int16_t lport = 80;
		char *cp = strchr(*argv, ':');
		if(cp) {
			*cp++ = 0;
			lport = port = atoi(cp);
			if((cp = strchr(cp, '@'))) {
				*cp++ = 0;
				lport = atoi(cp);
			}
		}
		
		if(udp) { 
			int infd = 0;
			if((infd = ludp(NULL, lport)) >= 0) { 
				int outfd = 0;
				if((outfd = cudp(*argv, port)) >= 0) {
					U_O_FD = outfd;
					U_I_FD = infd;
					event_set(&U_C_RX, infd, EV_READ, _onucrx, &U_C_RX);
					event_set(&U_S_RX, outfd, EV_READ, _onusrx, &U_S_RX);
					event_add(&U_S_RX, NULL);
					event_add(&U_C_RX, NULL);
				
					udp++;
				}
			}
			
			if(udp != 2) {
				log_fatal("%%CANT-PLUGBOARD %s:%u to localhost:%u", *argv, port, lport);
			}
		} else {
			p = plug_new(lport, *argv, port, _onclient, _oncdata, _onsdata, NULL);
			assert(p || !"setup");
		}

		log_status("%%AWAITING-CONNECTION for %s:%u on %u", *argv, port, lport);

		firebert_dispatch();
	} else goto usage;

	exit(1);
}
