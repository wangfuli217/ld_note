#include "firebert.h"

#include <sys/param.h>
#include <sys/stat.h>
#include <sys/uio.h>
#include <sys/un.h>
#include <netinet/tcp.h>
#include <libgen.h>
#include <limits.h>
#include <resolv.h>

#include "util.h"
#include "tcpip.h"
#include "format/fmt.h"

#ifdef __OpenBSD__
static long double strtold(const char *ptr, char **ep) {
	return(strtod(ptr, ep));
}

char *
strcasestr (char *haystack, char *needle)
{
	char *p, *startn = 0, *np = 0;

	for (p = haystack; *p; p++) {
		if (np) {
			if (toupper(*p) == toupper(*np)) {
				if (!*++np)
					return startn;
			} else
				np = 0;
		} else if (toupper(*p) == toupper(*needle)) {
			np = needle + 1;
			startn = p;
		}
	}

	return 0;
}

#endif

#ifdef __linux__
/*
 * Copy src to string dst of size siz.  At most siz-1 characters
 * will be copied.  Always NUL terminates (unless siz == 0).
 * Returns strlen(src); if retval >= siz, truncation occurred.
 */
size_t strlcpy(dst, src, siz)
        char *dst;
        const char *src;
        size_t siz;
{
        register char *d = dst;
        register const char *s = src;
        register size_t n = siz;

        /* Copy as many bytes as will fit */
        if (n != 0 && --n != 0) {
                do {
                        if ((*d++ = *s++) == 0)
                                break;
                } while (--n != 0);
        }

        /* Not enough room in dst, add NUL and traverse rest of src */
        if (n == 0) {
                if (siz != 0)
                        *d = '\0';              /* NUL-terminate dst */
                while (*s++)
                        ;
        }

        return(s - src - 1);    /* count does not include NUL */
}
#endif

/* ------------------------------------------------------------ */

u_char *
read_desc(int fd, size_t *sz) {
        size_t l = 0, bl = 2048, tl = 0;
        u_char *buf = malloc(bl);

        while((l = (read(fd, &buf[tl], bl-tl))) > 0) {
                tl += l;
                if(!(bl - tl))
                        buf = realloc(buf, (bl = tl*2));
        }

        *sz = tl;     

        if(!tl) {      
                free(buf);
                buf = NULL;
        } else {
                if(tl == bl) {
                        /* dumb fucking luck! */
                        buf = realloc(buf, (bl+=2));
                }       

                buf[tl] = 0;
        }

        return(buf);  
}

/* ------------------------------------------------------------ */

u_char *
read_file(char *filename, size_t *sz)
{
	FILE *fp = NULL;
	u_char *ret = NULL;

	if ((fp = fopen(filename, "r")) != NULL) {
		struct stat sb;
		if (fstat(fileno(fp), &sb) >= 0) {
			ret = malloc(sb.st_size + 1);
			if (ret != NULL) {
				fread(ret, sb.st_size, 1, fp);
				ret[sb.st_size] = '\0';
				*sz = sb.st_size;
			}
		}
		fclose(fp);
	}

	return (ret);
}

/* ---------------------------------------------------------- */

#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <assert.h>

u_int32_t
resolve(char *name) {
	u_int32_t ret = inet_addr(name);
	if(ret == INADDR_NONE) {
		struct hostent *hp = gethostbyname(name);
		if(hp)
			ret = *(u_int32_t *)hp->h_addr;
	}

	return(ret);
}

/* ---------------------------------------------------------- */

/*
 * cidr_aton
 *
 * CIDR version of inet_aton.  Interprets s as a CIDR address
 * ("a.b.c.d" or 'a.b.c.d/m") and stores the address in i and the mask
 * in m.
 */

int
cidr_aton(const char *s, u_int32_t *i, u_int32_t *m) {
	int ret = -1;
	char buf[100], *cp = NULL;

	strncpy(buf, s, sizeof buf);

	if((cp = strchr(buf, '/'))) {
		u_int32_t c = 0;

		*cp++ = 0;

		if((c = strtoul(cp, NULL, 0)) < 32 && c != 0) {
			*m = (u_int32_t) -1;
			*m <<= (32 - c); 
			*m = htonl(*m);
			ret = 0;
		} else if(c == 0) {
			*m = 0;
			ret = 0;
       		} else {
			struct in_addr in;
			ret = inet_aton(s, &in);
			*m = in.s_addr;
		}
	} else {
		*m = ~0;
		ret = 0;
	}

	if(!ret) {
		struct in_addr in;
		ret = inet_aton(buf, &in);
		*i = in.s_addr;
	}

	return(ret);
}

/* ---------------------------------------------------------- */

/* return 1 if larger is within pct of smaller */
int
iswithinpercent(double a, double b, int pct) {
	if (a > b)
		return (a <= (b + (b * pct / 100.0)));
	else if (b > a)
		return (b <= (a + (a * pct / 100.0)));
	return (1);
}

/* ---------------------------------------------------------- */

void *
memfry(void *r, size_t len) {
	u_char *b = (u_char *)r;
	u_int32_t rands[376];
	u_char *arr = (u_char *) rands;
	int i = 0;
		
	for(i = 0; i < (sizeof rands / sizeof rands[0]) ; i++) 
#ifndef __linux__
		rands[i] = arc4random();
#else
		rands[i] = lrand48();
#endif

	i = 0;

	while(len--) {
		*b++ = arr[i];
		i = (i + 1) % (sizeof rands);
	}

	return(r);
}

/* ---------------------------------------------------------- */

char *
getprotoname(u_int8_t proto)
{
	static char nbuf[8];
	struct protoent *pe;

	if ((pe = getprotobynumber(proto)) == NULL) {
		snprintf(nbuf, sizeof(nbuf), "%d", proto);
		return (nbuf);
	} else {
		return (pe->p_name);
	}
}

/* ------------------------------------------------------- */

int
getprotonum(const char *proto)
{
	struct protoent *e;
	int save_errno, p;

	save_errno = errno;
	if ((e = getprotobyname(proto))) {
		p = e->p_proto;
	} else {
		char *ep;

		errno = 0;
		p = strtoul(proto, &ep, 0);
		if (*ep != '\0' || errno == ERANGE || p > 255)
			p = -1;
	}
	errno = save_errno;

	return (p);
}

/* ---------------------------------------------------------- */

void
settime(const char *arg, struct timeval *tm) {
	double v = atof(arg);
	size_t us = (1000 * 1000) * v;
	tm->tv_sec = us / 1000000;
	tm->tv_usec  = us % 1000000;
}

/* ---------------------------------------------------------- */

u_int16_t 
getenv16(const char *str) {
	u_int16_t ret = 0;
	char *cp = getenv(str);

	if(cp) {
		ret = (u_int16_t) strtoul(cp, NULL, 0);
	}

	return(ret);
}

/* -------------------------------------------------- */

u_int32_t 
getenv32(const char *str) {
	u_int32_t ret = 0;
	char *cp = getenv(str);

	if(cp) {
		ret = (u_int32_t) strtoul(cp, NULL, 0);
	}

	return(ret);
}

/* -------------------------------------------------- */

int
getenvip(const char *str, u_int32_t *ip, u_int32_t *mask) {
	char *cp = getenv(str);	
	int ret = -1;

	*mask = ~0;
	*ip = ~0;

	if(cp) {
		ret = cidr_aton(cp, ip, mask);
	}

	return(ret);
}

/* -------------------------------------------------- */

time_t 
file_last_modified(int fd) {
	struct stat sb;

	fstat(fd, &sb); /* won't fail */
#ifndef __linux__
	return(sb.st_mtimespec.tv_sec);
#else
	return(sb.st_mtime);
#endif
}

/* -------------------------------------------------- */

int
fnewer(const char *path, time_t *arg) {
	int ret = 0;
	int fd = open(path, O_RDONLY);
	if(fd >= 0) {
		time_t n = file_last_modified(fd);
		if(n > *arg) {
			*arg = n;
			ret = 1;
		}
		
		close(fd);
	}

	return(ret);
}

/* -------------------------------------------------- */

size_t
file_size(int fd) {
	struct stat sb;

	fstat(fd, &sb); /* won't fail */

	return(sb.st_size);
}

/*
 * ensure all of data on socket comes through. f==read || f==write
 */
ssize_t
atomicio(f, fd, _s, n)
	ssize_t (*f) ();
	int fd;
	void *_s;
	size_t n;
{
	char *s = _s;
	ssize_t res, pos = 0;

	while (n > pos) {
		res = (f) (fd, s + pos, n - pos);
		switch (res) {
		case -1:
			if (errno == EINTR || errno == EAGAIN)
				continue;
		case 0:
			return (res);
		default:
			pos += res;
		}
	}
	return (pos);
}

/* ------------------------------------------------------------------ */

int 
ready(int fd, int ms)
{
	fd_set fds;
	struct timeval tm = { 0, 0 };

	FD_ZERO(&fds);
	FD_SET(fd, &fds);
	
	if (ms > 0) {
                tm.tv_sec = ms / 1000;
		tm.tv_usec = (ms % 1000) * 1000;
	}

	return (select(fd + 1, &fds, NULL, NULL, ms >= 0 ? &tm : NULL));
}

/* ------------------------------------------------------------------ */

int 
writey(int fd, int ms)
{
	fd_set fds;
	struct timeval tm = { 0, 0 };

	FD_ZERO(&fds);
	FD_SET(fd, &fds);
	
	if (ms > 0) {
                tm.tv_sec = ms / 1000;
		tm.tv_usec = (ms % 1000) * 1000;
	}

	return (select(fd + 1, NULL, &fds, NULL, ms >= 0 ? &tm : NULL));
}

/* ------------------------------------------------------------------ */

/* can i execute this file (access(2)) */
int
canexec(const char *path)
{
	return (access(path, X_OK) == 0);
}

/* can i read this file (access(2)) */
int
canread(const char *path)
{
	return (access(path, R_OK) == 0);
}

/* can i write this file (access(2)) */
int
canwrite(const char *path)
{
	return (access(path, W_OK) == 0);
}


#include "cons.h"
#include "event.h"
#include "timer.h"

/* ------------------------------------------------------- */

int 
udom(const char *file) {
	int ret = socket(AF_UNIX, SOCK_DGRAM, 0);
	if(ret >= 0) {
		struct sockaddr_un sun;
		memset(&sun, 0, sizeof(sun));
		sun.sun_family = AF_UNIX;
		strlcpy(sun.sun_path, file, sizeof(sun.sun_path));
		if(bind(ret, (struct sockaddr *)&sun, SUN_LEN(&sun)) == 0) {
			return(ret);
		} else {
			close(ret);
			ret = -1;
		}
	}

	return(ret);
}

/* ------------------------------------------------------- */

int 
udomc(const char *file) {
	int ret = socket(AF_UNIX, SOCK_STREAM, 0);
	if(ret >= 0) {
		struct sockaddr_un sun;
		memset(&sun, 0, sizeof(sun));
		sun.sun_family = AF_UNIX;
		strlcpy(sun.sun_path, file, sizeof(sun.sun_path));
		if(bind(ret, (struct sockaddr *)&sun, SUN_LEN(&sun)) != 0) {
			close(ret);
			ret = -1;
		} else
			listen(ret, 5);
	}

	return(ret);
}

/* ------------------------------------------------------- */

int
connectu(const char *file) {
	int ret = socket(AF_UNIX, SOCK_DGRAM, 0);
	if(ret >= 0) {
		struct sockaddr_un sun;
		memset(&sun, 0, sizeof(sun));
		sun.sun_family = AF_UNIX;
		strlcpy(sun.sun_path, file, sizeof(sun.sun_path));
		if(connect(ret, (struct sockaddr *)&sun, SUN_LEN(&sun)) != 0) {
			close(ret);
			ret = -1;
		} 
	}

	return(ret);
}

/* ------------------------------------------------------- */

int
reuseaddr(int socket) {
	int val = 1;
	return(setsockopt(socket, SOL_SOCKET, SO_REUSEADDR, &val, 4));
}

/* ------------------------------------------------------- */

int 
ctcp(const char *host, unsigned port) {
	int ret = -1;
	int fd = socket(AF_INET, SOCK_STREAM, 0);
	if(fd >= 0) {
		u_int32_t ip = resolve((char*)host);
		if(ip != INADDR_NONE) {
			struct sockaddr_in si;
			zero(&si);
			si.sin_family = AF_INET;
			si.sin_port = htons(port);
			si.sin_addr.s_addr = ip;
			if(connect(fd, (struct sockaddr *)&si, sizeof si) >= 0)
				ret = fd;
		}
	}

	return(ret);
}

/* ------------------------------------------------------- */

int 
cudp(const char *host, unsigned port) {
	int ret = -1;
	int fd = socket(AF_INET, SOCK_DGRAM, 0);
	if(fd >= 0) {
		u_int32_t ip = resolve((char*)host);
		if(ip != INADDR_NONE) {
			struct sockaddr_in si;
			zero(&si);
			si.sin_family = AF_INET;
			si.sin_port = htons(port);
			si.sin_addr.s_addr = ip;
			if(connect(fd, (struct sockaddr *)&si, sizeof si) >= 0)
				ret = fd;
		}
	}

	return(ret);
}

/* ------------------------------------------------------------ */

int
ltcp(const char *host, unsigned port) {
	int ret = socket(AF_INET, SOCK_STREAM, 0);
	if(ret >= 0) {
		int resd = 0;
		struct sockaddr_in sin;
		memset(&sin, 0, sizeof(sin));
		sin.sin_family = AF_INET;
		sin.sin_port = htons(port);

		if(host) {
			sin.sin_addr.s_addr = inet_addr(host);
			if(sin.sin_addr.s_addr == INADDR_NONE) {
				struct hostent *hp = gethostbyname(host);
				if(hp) {
					memcpy(&sin.sin_addr.s_addr, hp->h_addr, 4);
					resd = 1;
				}
			} else 
				resd = 1;
		} else {
			sin.sin_addr.s_addr = INADDR_ANY;
			resd = 1;
		}

		reuseaddr(ret);

		if(resd) {
			if(bind(ret, (struct sockaddr *)&sin, sizeof(sin)) != 0) {
				close(ret);
				ret = -1;
			} else
				listen(ret, 5);
		} else {
			close(ret);
			ret = -1;
		}
	}

	return(ret);
}

/* ------------------------------------------------------- */

int
ludp(const char *host, unsigned port) {
	int ret = socket(AF_INET, SOCK_DGRAM, 0);
	if(ret >= 0) {
		int resd = 0;
		struct sockaddr_in sin;
		memset(&sin, 0, sizeof(sin));
		sin.sin_family = AF_INET;
		sin.sin_port = htons(port);

		if(host) {
			sin.sin_addr.s_addr = inet_addr(host);
			if(sin.sin_addr.s_addr == INADDR_NONE) {
				struct hostent *hp = gethostbyname(host);
				if(hp) {
					memcpy(&sin.sin_addr.s_addr, hp->h_addr, 4);
					resd = 1;
				}
			} else 
				resd = 1;
		} else {
			sin.sin_addr.s_addr = INADDR_ANY;
			resd = 1;
		}

		if(resd) {
			if(bind(ret, (struct sockaddr *)&sin, sizeof(sin)) != 0) {
				close(ret);
				ret = -1;
			} 
		} else {
			close(ret);
			ret = -1;
		}
	}

	return(ret);
}

/* ------------------------------------------------------- */

enum {
	INCR = 128,
	MAX = (1024 * 1024),
};

int 
embiggen(int sockfd) {
	unsigned int len = sizeof(len);
	int retlen = -1;
	
	int opts[] = { SO_RCVBUF, SO_SNDBUF, 0 };
	int i;

	for(i = 0; opts[i]; i++) {
		if (getsockopt(sockfd, SOL_SOCKET, opts[i], &retlen, &len) >= 0) {
			while ((retlen += INCR) <= MAX) {
				if (setsockopt(sockfd, SOL_SOCKET, opts[i], &retlen, len) < 0) {
					if (errno == ENOBUFS) 
						retlen -= INCR;
					break;
				}
			}
		}
	}
		
	return(retlen);
}

/* ------------------------------------------------------- */

int
toggleblock(int fd) {
	int v = fcntl(fd, F_GETFL, 0);
	if(v >= 0) {
		if(!(v & O_NONBLOCK)) 
			v |= O_NONBLOCK;
		else
			v &= ~(O_NONBLOCK);

		if(fcntl(fd, F_SETFL, v) >= 0)
			v = (v & O_NONBLOCK) ? 0 : 1;
		else
			v = -1;
	}
	
	return(v);
}

/* ------------------------------------------------------- */

int
setblock(int fd, int block)
{
	int v = fcntl(fd, F_GETFL, 0);
	
	if (v != -1) {
		if (block)
			v &= ~(O_NONBLOCK);
		else
			v |= O_NONBLOCK;
		v = fcntl(fd, F_SETFL, v);
	}
	return(v);
}

/* ------------------------------------------------------- */

unsigned
portname(const char *name) {
	unsigned ret = 0;

	struct servent *sv = getservbyname(name, "tcp");
	if(!sv) sv = getservbyname(name, "udp");
	if(sv) {
		ret = htons(sv->s_port);
	} else {
		ret = strtoul(name, NULL, 0);
	}

	return(ret);
}

/* -------------------------------------------------- */

static void
_nbc_2(int fd, short code, void *arg) {
	cons_t c = cons_release((cons_t *)arg);
	cons_t c2 = cons_release((cons_t *)cdr(&c));
	struct event *ep = car(&c);
	nbc_cb cb = cdr(&c2);
	void *carg = car(&c2);

	struct sockaddr_in si;
	unsigned int sil;

	event_del(ep);
	free(ep);

	cb(fd, getpeername(fd, (struct sockaddr *)&si, &sil), carg);
}

/* -------------------------------------------------- */

static int
_do_nbc(const char *host, unsigned port, unsigned to, nbc_cb cb, void *arg) {
	int ret = socket(AF_INET, SOCK_STREAM, 0);
	if(ret >= 0) {
		int resd = 0;
		struct sockaddr_in sin;
		memset(&sin, 0, sizeof(sin));
		sin.sin_family = AF_INET;
		sin.sin_port = htons(port);

		if(host) {
			sin.sin_addr.s_addr = inet_addr(host);
			if(sin.sin_addr.s_addr == INADDR_NONE) {
				struct hostent *hp = gethostbyname(host);
				if(hp) {
					memcpy(&sin.sin_addr.s_addr, hp->h_addr, 4);
					resd = 1;
				}
			} else 
				resd = 1;
		} else {
			sin.sin_addr.s_addr = INADDR_ANY;
			resd = 1;
		}

		if(resd) {
			int fd = ret;

			fcntl(ret, F_SETFL, O_NONBLOCK);

			ret = connect(fd, (struct sockaddr *)&sin, sizeof(sin));
			if(ret >= 0 || errno == EINPROGRESS) {
				struct event *ep = malloc(sizeof(*ep));
				struct timeval tv = timer_ms2tv(to);

				event_set(ep, fd, EV_WRITE, _nbc_2, cons(ep, cons(arg, cb)));
				event_add(ep, to ? &tv : NULL);

				ret = 0;
			}

		} else {
			close(ret);
			ret = -1;
		}
	}

	return(ret);
}

/* -------------------------------------------------- */

int
nbc(const char *host, unsigned port, nbc_cb cb, void *arg) {
	return(_do_nbc(host, port, 0, cb, arg));
}

/* -------------------------------------------------- */

int
nbc_timed(const char *host, unsigned port, unsigned to, nbc_cb cb, void *arg) {
	return(_do_nbc(host, port, to, cb, arg));
}

/* ------------------------------------------------------------ */

static char* icmp_info[32][32] =
{
        {"ECHOREPLY"},
        {},
	{},
	{"UNREACH_NET", "UNREACH_HOST", "UNREACH_PROTOCOL", "UNREACH_PORT",
	 "UNREACH_NEEDFRAG", "UNREACH_SRCFAIL", "UNREACH_NET_UNKNOWN", "UNREACH_HOST_UNKNOWN",
	 "UNREACH_ISOLATED", "UNREACH_NET_PROHIB", "UNREACH_HOST_PROHIB", "UNREACH_TOSNET",
	 "UNREACH_TOSHOST", "UNREACH_FILTER_PROHIB", "UNREACH_HOST_PRECEDENCE", "UNREACH_PRECEDENCE_CUTOFF"},
	{"SOURCEQUENCH"},
	{"REDIRECT_NET", "REDIRECT_HOST", "REDIRECT_TOSNET", "REDIRECT_TOSHOST"},
	{},
	{},
	{"ECHO"},
	{"ROUTERADVERT"},
	{"ROUTERSOLICIT"},
	{"TIMXCEED_INTRANS", "TIMXCEED_REASS"},
	{"PARAMPROB_ERRATPTR", "PARAMPROB_OPTABSENT", "PARAMPROB_LENGTH"},
	{"TSTAMP"},
	{"TSTAMPREPLY"},
	{"IREQ"},
	{"IREQREPLY"},
	{"MASKREQ"},
	{"MASKREPLY"},
	{"ECHOREPLY"},
	{"ECHOREPLY"}
};

void 
quickipdump(u_char *buf) {
        u_char *bp = buf;
	struct ip_h *ih = NULL;
	
#if 0    // if running straight from pcap, skip llh
	bp += 14;
#endif
	
	ih = (struct ip_h *) bp;
	
	bp += ih->ip_hl * 4;	
	
	if(ih->ip_p == 6) {
	        struct tcp_h *th = (struct tcp_h *) bp;
		char flags[7];
		sprintf(flags, "%s%s%s%s%s%s",
			(th->th_flags & TH_FIN)?"F":" ",
			(th->th_flags & TH_SYN)?"S":" ",
			(th->th_flags & TH_RST)?"R":" ",
			(th->th_flags & TH_PUSH)?"P":" ",
			(th->th_flags & TH_ACK)?"A":" ",
			(th->th_flags & TH_URG)?"U":" ");
		
		fmt_eprint("%i -> %i (TTL %d) TCP (%6s) %d -> %d (%d bytes)\n",
			   ih->ip_src, ih->ip_dst, ih->ip_ttl, flags, ntohs(th->th_sport), ntohs(th->th_dport), ntohs(ih->ip_len));
	} else if(ih->ip_p == 17) {
	        struct udp_h *uh = (struct udp_h *) bp;
		
		fmt_eprint("%i -> %i (TTL %d) UDP %d -> %d (%d bytes)\n",
			   ih->ip_src, ih->ip_dst, ih->ip_ttl, ntohs(uh->uh_sport),
			   ntohs(uh->uh_dport), ntohs(ih->ip_len));
	} else if(ih->ip_p == IPPROTO_ICMP) {
	        struct ip_h *ih2;
		struct icmp_h *ic = (struct icmp_h *) bp;
		fmt_eprint("%i -> %i (TTL %d) ICMP %s (%d bytes)\n",
			   ih->ip_src, ih->ip_dst, ih->ip_ttl, icmp_info[ic->icmp_type][ic->icmp_code], ntohs(ih->ip_len));
		switch(ic->icmp_type) {
		case ICMP_UNREACH:
		case ICMP_TIMXCEED:
		        bp += 8; // unreachables are 8 bytes
			ih2 = (struct ip_h *) bp;
			ih2->ip_len = htons(ntohs(ih->ip_len) - (ih->ip_hl * 4) - 8); // jeremy touches up to prevent vuln...
			fmt_eprint("\t");
			quickipdump(bp); // but tom's lack of length var makes there still be a problem...
			break;
		default:
		        break;
		}
	}      
}

/* ------------------------------------------------------------ */

#define R(a,b) (((a) << (b)) | ((a) >> (32 - (b))))
static void salsa20_word_specification(u_int32_t out[16],u_int32_t in[16]) {
	int i;
	u_int32_t x[16];
	for (i = 0;i < 16;++i) x[i] = in[i];
	for (i = 20;i > 0;i -= 2) {
		x[ 4] ^= R(x[ 0]+x[12], 7);  x[ 8] ^= R(x[ 4]+x[ 0], 9);
		x[12] ^= R(x[ 8]+x[ 4],13);  x[ 0] ^= R(x[12]+x[ 8],18);
		x[ 9] ^= R(x[ 5]+x[ 1], 7);  x[13] ^= R(x[ 9]+x[ 5], 9);
		x[ 1] ^= R(x[13]+x[ 9],13);  x[ 5] ^= R(x[ 1]+x[13],18);
		x[14] ^= R(x[10]+x[ 6], 7);  x[ 2] ^= R(x[14]+x[10], 9);
		x[ 6] ^= R(x[ 2]+x[14],13);  x[10] ^= R(x[ 6]+x[ 2],18);
		x[ 3] ^= R(x[15]+x[11], 7);  x[ 7] ^= R(x[ 3]+x[15], 9);
		x[11] ^= R(x[ 7]+x[ 3],13);  x[15] ^= R(x[11]+x[ 7],18);
		x[ 1] ^= R(x[ 0]+x[ 3], 7);  x[ 2] ^= R(x[ 1]+x[ 0], 9);
		x[ 3] ^= R(x[ 2]+x[ 1],13);  x[ 0] ^= R(x[ 3]+x[ 2],18);
		x[ 6] ^= R(x[ 5]+x[ 4], 7);  x[ 7] ^= R(x[ 6]+x[ 5], 9);
		x[ 4] ^= R(x[ 7]+x[ 6],13);  x[ 5] ^= R(x[ 4]+x[ 7],18);
		x[11] ^= R(x[10]+x[ 9], 7);  x[ 8] ^= R(x[11]+x[10], 9);
		x[ 9] ^= R(x[ 8]+x[11],13);  x[10] ^= R(x[ 9]+x[ 8],18);
		x[12] ^= R(x[15]+x[14], 7);  x[13] ^= R(x[12]+x[15], 9);
		x[14] ^= R(x[13]+x[12],13);  x[15] ^= R(x[14]+x[13],18);
	}
	for (i = 0;i < 16;++i) out[i] = x[i] + in[i];
}

u_int64_t 
bhash64(u_char *in, size_t l) {
	u_int32_t ib[16];
	u_int64_t ob[8];
	int i = 0;

	while(l > 64) {
		memcpy(ib, in, 64);
		salsa20_word_specification((u_int32_t *)ob, ib);
		l -= 64;
		in += 64;
	}

	{ u_char *ip = (u_char*)ib;
	  while(l--) 	
		ip[i++] = *in++;
 	  while(i < 64)
		ip[i++] = 0;
	}

	salsa20_word_specification((u_int32_t *)ob, ib);

	return(ob[0]);
}

/* ------------------------------------------------------------ */

static void 
_hexdump(stringvec_t *s, size_t off, u_char *buf, size_t count) {
        int pad = 16 - count;
        int i = 0, j = 0;

        fmt_build(s, 20, "%08x  ", (unsigned)off);

        while(i < count) {
                fmt_build(s, 20, "%02x ", buf[i++]);
                if(!(i % 8))
                        fmt_build(s, 20, " ");
        }

        for(j = 0, i += 1; j < pad; i++, j++) {
                fmt_build(s, 20, "-- ");
                if(!(i % 8))
			fmt_build(s, 20, " ");
        }
	
	fmt_build(s, 20, " |");

        for(i = 0; i < count; i++)
                if(isprint(buf[i]))
			fmt_build(s, 20, "%c", buf[i]);
                else
			fmt_build(s, 20, ".");
	
	fmt_build(s, 20, "|\n");
}

/* ------------------------------------------------------------ */

char *
shexdump(u_char *buf, size_t len) {
	stringvec_t *s = fmt_start(100);
	u_char *o = buf;
	while(len) {
		int step = len > 16 ? 16 : len;
		_hexdump(s, (size_t)(buf - o), buf, step);
		buf += step;
		len -= step;
	}

	return(fmt_convert(&s));
}

/* ------------------------------------------------------------ */

char *
shexify(u_char *buf, size_t l) {
	stringvec_t *s = fmt_start(100);
	int i = 0;

	while(l--) fmt_build(s, 10, "%0.2x", buf[i++]);
       
	return(fmt_convert(&s));
}

/* ------------------------------------------------------------ */

void
dehexify(char *instr, u_char *outbuf) {
	char *cp = NULL;
	u_char *op = NULL;
	int t = 0;
		
	for(cp = instr, op = outbuf; *cp && isxdigit(*cp); cp++) {
		int c = tolower(*cp);
		int v = c < 0x3a ? c - 0x30 : (c - 0x61) + 10;
		if(t) {
			*op |= v;
			op++;
			t = 0;
		} else {
			*op =  v << 4;
			t = 1;
		}
	}
}

/* ------------------------------------------------------------ */

char *
scdump(u_char *buf, size_t l) {
	stringvec_t *s = fmt_start(100);
	int i = 0;

	fmt_build(s, 99, "u_char pkt[] = {\n\t");
	
	for(i = 0; i < l; i++) {
		fmt_build(s, 10, "0x%X, ", buf[i]);

		if(i && !(i % 8)) {
			fmt_build(s, 10, "\n\t");
		}		
	}
       
	fmt_build(s, 10, "};\n");

	return(fmt_convert(&s));
}

/* ------------------------------------------------------------ */

void
hexdump(u_char *buf, size_t len) {
	char *cp = NULL;
	fputs((cp = shexdump(buf, len)), stdout);
	free(cp);
}

/* ------------------------------------------------------------ */

void *
bufdup(void *buf, size_t n) {
	void *ret = malloc(n);
	if(ret) 
		memcpy(ret, buf, n);
	return(ret);
}

/* ------------------------------------------------------------ */

u_int64_t 
strtoamt(char *str) {
	u_int64_t ret = 0;
	size_t mult = 1;
	char *nn = NULL;

	for(nn = str; *nn && (isdigit(*nn) || *nn == '.' || *nn == ' '); nn++);

	switch(*nn) {
	case 'm':
	case 'M':
		mult = 1000 * 1000;
		break;
	case 'g':
	case 'G':
		mult = 1000 * 1000 * 1000;
		break;
	case 'k':
	case 'K':
		mult = 1000;
		break;
	default:
		break;		      
	}

	if(strchr(str, '.')) {
		long double v = strtold(str, NULL);
		ret = v * mult;
	} else {
		ret = strtoul(str, NULL, 0);
		ret *= mult;
	}

	return(ret);
}

/* ------------------------------------------------------------ */

void
waitfd(int fd, int mode) {
	fd_set fds;

	do {
		FD_ZERO(&fds);
		FD_SET(fd, &fds);

		if(mode == O_RDONLY) 
			select(fd + 1, &fds, NULL, NULL, NULL);
		else 
			select(fd + 1, NULL, &fds, NULL, NULL);
		
	} while(!FD_ISSET(fd, &fds));
}

/* ------------------------------------------------------------ */

char *
longstring(size_t sz) {
	static char *Buf = NULL; 
	char *cp = Buf ? Buf : (Buf = malloc(1024 * 1024 + 1));
		
	if(sz > (1024 * 1024)) 
		sz = 1024 * 1024;

	while(sz--) 
		*cp++ = 'A';
	
	*cp++ = 0;
	return(Buf);
}

/* ------------------------------------------------------------ */

FILE *
pfopen(char *mode, char *fmt, ...) {
	char buf[2048];
	va_list ap;

	va_start(ap, fmt);
	fmt_vsfmt(buf, 2047, fmt, ap);
	
	return(fopen(buf, mode));
}

/* ------------------------------------------------------------ */

int
memmap(u_char *buf, size_t l, u_char *from, u_char *to, size_t maplen) { 
	int ret = 0;
	u_char *ep = NULL;
		
	for(ep = &buf[l]; buf < ep; buf++) {
		u_char *fp = NULL;

		if((fp = memchr(from, *buf, maplen))) {
			*buf = to[(size_t)(fp - from)];
			ret++;
		}
	}

	return(ret);
}

/* ------------------------------------------------------------ */

#define SKIPWS(s) {while(*s==' ')s++;}

#if 0
static const unsigned char BaseChars[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
#else
static const unsigned char BaseChars[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz./";
#endif

#define BaseChar(c) BaseChars[c]

static const unsigned char BaseVals[] = {
	0xff,0xff,0xff,0xff, 0xff,0xff,0xff,0xff, 0xff,0xff,0xff,0xff, 0xff,0xff,0xff,0xff,
	0xff,0xff,0xff,0xff, 0xff,0xff,0xff,0xff, 0xff,0xff,0xff,0xff, 0xff,0xff,0xff,0xff,
	0xff,0xff,0xff,0xff, 0xff,0xff,0xff,0xff, 0xff,0xff,0xff,62, 0xff,0xff,0xff,63,
	52,53,54,55, 56,57,58,59, 60,61,0xff,0xff, 0xff,0xff,0xff,0xff,
	0xff, 0, 1, 2,  3, 4, 5, 6,  7, 8, 9,10, 11,12,13,14,
	15,16,17,18, 19,20,21,22, 23,24,25,0xff, 0xff,0xff,0xff,0xff,
	0xff,26,27,28, 29,30,31,32, 33,34,35,36, 37,38,39,40,
	41,42,43,44, 45,46,47,48, 49,50,51,0xff, 0xff,0xff,0xff,0xff
};

#define BaseVal(c) BaseVals[c]

/* ------------------------------------------------------------ */

size_t 
b64e(u_char *in, size_t inlen, char *out, size_t ol) {
	char *curpos = NULL;
	unsigned char a, b, c;
	size_t outlen = 0;

	/* determine how long the output will be.  if it is not a multple of 3
	 * bytes, increase length so that it is so that the pad characters are
	 * accounted for.
	 */
	if (inlen % 3 != 0)
		outlen = inlen + 3 - inlen % 3;
	else
		outlen = inlen;

	/* base64 encoding creates 4 output chars for every 3 input chars */
	outlen = 4 * (outlen) / 3;

	if(!out || ol < outlen)
		return(outlen);

	curpos = out;

	while (inlen) {
		a = *in++;
		inlen--;

		*curpos++ = BaseChar (a >> 2);

		if (inlen)
			b = *in++;
		else
			b = 0;

		*curpos++ = BaseChar (((a & 0x03) << 4) | (b >> 4));

		if (!inlen) {
			*curpos++ = '=';
			*curpos++ = '=';
			break;
		}
		inlen--;

		if (inlen)
			c = *in++;
		else
			c = 0;

		*curpos++ = BaseChar (((b & 0x0f) << 2) | (c >> 6));

		if (!inlen) {
			*curpos++ = '=';
			break;
		}
		inlen--;

		*curpos++ = BaseChar (c & 0x3f);
	}

	*curpos = 0;

	return(outlen);
}

/* ------------------------------------------------------------ */

size_t
b64d(char *in, size_t inlen, u_char *out, size_t ol) {
	unsigned char *curpos = NULL;
	unsigned char a, b;
	size_t outlen = 0;

	outlen = (3 * strlen (in)) / 4; /* maximum length */

	if(!out || ol < outlen)
		return(outlen);

	curpos = out;

	SKIPWS (in);
	while (*in) {
		a = *in++;
		SKIPWS (in);
		if (!*in)
			break;
		b = *in++;
		SKIPWS (in);
		if (!*in)
			break;
	
		*curpos++ = (BaseVal (a) << 2) | (BaseVal (b) >> 4);

		a = b;
		b = *in++;
		SKIPWS (in);
		if (!*in)
			break;

		if (b == '=')
			break;

		*curpos++ = (BaseVal (a) << 4) | (BaseVal (b) >> 2);

		a = b;
		b = *in++;
		SKIPWS (in);

		if (b == '=')
			break;

		*curpos++ = (BaseVal (a) << 6) | BaseVal (b);
	}

	outlen = (size_t)(curpos - out); /* real length */

	return (outlen);
}

/* ------------------------------------------------------------ */

u_char *
memstr(u_char *buf, size_t l, u_char *sub, size_t s) {
        u_char *ret = NULL;
	u_char *e = &buf[l];	
        u_char *p = NULL;
        size_t i = 0;
                
	while(s < l && (p = memchr(buf, sub[0], l)) && !ret) {
		buf = p + 1;
                for(i = 1; i < s; i++)
			if(*buf++ != sub[i])
				break;
		if(i >= s)
			ret = p;
		else
			l = (size_t)(e - buf);
        }

        return(ret);
}

/* ------------------------------------------------------------ */

u_char *
memstrb(u_char *buf, u_char *ep, u_char *sub, size_t s) {
	if(buf < ep) {
		return(memstr(buf, (size_t)(ep - buf), sub, s));
	}

	return(NULL);
}

/* ------------------------------------------------------------ */

unsigned long atoulv(char *s, int *valid) { 
	if(s && *s) {
		char *ep = NULL;
		unsigned long ret = strtoul(s, &ep, 0);
		*valid = (ep != s && iseot(*ep));
		return(ret);
	} else {
		*valid = 0;
		return(~0);
	}
}	

/* ------------------------------------------------------------ */

char *
strchrs(const char *in, const char *chrs) {
	return(strpbrk(in, chrs));
}

/* ------------------------------------------------------------ */

#include <openssl/md5.h>

void
md5(u_char *in, size_t l, u_char *out) {
	MD5(in, l, out);
}

/* ------------------------------------------------------------ */

#include <openssl/sha.h>

void
sha1(u_char *in, size_t l, u_char *out /*20 BYTES*/) {
	SHA1(in, l, out);
}

/* ------------------------------------------------------------ */

int
socketsource(int fd, u_int32_t *a, u_int16_t *p) {
	struct sockaddr_in si;
	unsigned sl = sizeof(si);
	int ret = getpeername(fd, (struct sockaddr *)&si, &sl);
	if(ret >= 0) {
		*a = si.sin_addr.s_addr;
		*p = htons(si.sin_port);       
	}
	
	return(ret);
}

/* ------------------------------------------------------------ */

u_int64_t
r64(void) {
	u_int64_t ret = 0;
	static int Init = 0;
#ifndef __linux__
	if(!Init) srandomdev();

	ret = random();
	ret <<= 32;
	ret |= random();
#else
	ret = lrand48();
	ret <<= 32;
	ret |= lrand48();
#endif

	return(ret);
}

/* ------------------------------------------------------------ */

char *
nult(const char *str, const char *ep) {
       static int round = 0;
       static char buf[5][1024], *ret = NULL;
       if(str) {
	       size_t l = (size_t)(ep - str);

	       if(l < 1023) {
	       	    ret = buf[(round = (round + 1) % 5)];
		    memcpy(ret, str, l);
		    ret[l] = 0;	    		       
	       }
       }
       return(ret);
}


/* ------------------------------------------------------------ */

char *
strchrp(const char *p, int ch, int th) {
	char c = ch, t = th;
	for(;;++p) {
		if(*p == t || !*p)
			return(NULL);
		if(*p == c)
			return((char*)p);
	}
	/*NOTREACHED*/
}

/* ------------------------------------------------------------ */

#include <pcap.h>

int
pfilter(pcap_t *p, char *filt, ...) {
	va_list ap;
	int i = -1;
	struct bpf_program bp;
	char buf[2000];

	if(filt) {
		va_start(ap, filt);
		fmt_vsfmt(buf, 2000, filt, ap);

		if(pcap_compile(p, &bp, buf, 1, 0) >= 0) {
			if(pcap_setfilter(p, &bp) >= 0) {
				i = 0;
			}
		}
	}

	return(i);	       
}

/* ------------------------------------------------------------ */

u_char *
unhexdump(char *buf, size_t *n) {
	char *cp = buf;
	int s = 0, steps = 0;
	u_char *out = malloc(strlen(buf)/*SWAG*/), *outp = out;

	*n = 0;

	while(*cp && s != ~0) {
		switch(s) {
		case 0:
			if(isxdigit(cp[0]) && isxdigit(cp[1]) && isxdigit(cp[2]) && isxdigit(cp[3]) && isxdigit(cp[4]) && isxdigit(cp[5]) && isxdigit(cp[6]) && isxdigit(cp[7]) && cp[8] == ' ' && cp[9] == ' ') {
				cp += 10;
				s = 1;
			} else if(*cp) {
				cp++;
			} else
				s = ~0;
			break;

		case 1:
			if(isxdigit(cp[0]) && isxdigit(cp[1]) && cp[2] == ' ') {
				char tb[3]; tb[0] = cp[0]; tb[1] = cp[1]; tb[2] = 0;
				dehexify(tb, outp);

				outp += 1;			
				steps += 1;
				cp += 3;

				if(steps == 8)
					cp += 1;
				else if(steps == 16) {
					s = 2;
					steps = 0;
				}	
			} else if(cp[0] == '-' || !*cp) {
				steps = 0;
				s = ~0;
			} else if(cp[0] == '\n') {
				steps = 0;
				cp++;
				s = 0;
			} else {
				cp++;
			}

			break;

		case 2:
			while(*cp && *cp != '\n') cp++;
			if(*cp) {
				cp++;
				s = 0;
			} else
				s = ~0;
			break;

		default:
			assert(0 || !"impossible state");
			break;
		}
	}

	*n = (size_t)(outp - out);
	return(out);	
}

/* ------------------------------------------------------------ */

u_int32_t *
oidstr(char *str, u_int32_t *buf /*1024*/, size_t *n) {
        char *cp = NULL;
        *n = 0;

        while((cp = strsep(&str, "."))) {
                buf[*n] = strtoul(cp, NULL, 0);
                *n += 1;
        }

        return(buf);
}


// ------------------------------------------------------------ 

u_char *
read_file_or_stdin(char *file, size_t *sz) {
	u_char *ret = NULL;

	if(!file)
		ret = read_desc(fileno(stdin), sz);
	else
		ret = read_file(file, sz);

	return(ret);
}

// ------------------------------------------------------------ 

#include "strutil.h"

u_char *
read_input(char **argv, size_t *sz) {
	u_char *ret = NULL;
	
	if(!argv[0]) 
		ret = read_desc(fileno(stdin), sz);
	else if(argv[1]) {
		ret = (u_char *) copy_argv(argv);
 		*sz = strlen((char*) ret);
	} else 
		ret = read_file(argv[0], sz);

	return(ret);
}

// ------------------------------------------------------------ 

static in_addr_t mlen_masks[33] = {
	0x00000000, 0x80000000, 0xc0000000,
	0xe0000000, 0xf0000000, 0xf8000000,
	0xfc000000, 0xfe000000, 0xff000000,
	0xff800000, 0xffc00000, 0xffe00000,
	0xfff00000, 0xfff80000, 0xfffc0000,
	0xfffe0000, 0xffff0000, 0xffff8000,
	0xffffc000, 0xffffe000, 0xfffff000,
	0xfffff800, 0xfffffc00, 0xfffffe00,
	0xffffff00, 0xffffff80, 0xffffffc0,
	0xffffffe0, 0xfffffff0, 0xfffffff8,
	0xfffffffc, 0xfffffffe, 0xffffffff
};

in_addr_t
mlen2mask(u_int mlen)
{
	if (mlen == 0)
		return (0);
	if (mlen > 32)
		mlen = 32;
	return (htonl(~0L << (32 - mlen)));
}

// ------------------------------------------------------------ 

char *
strim(char *str) { 
	size_t l = strlen(str);
	char *ep = &str[l-1];
	while(isspace(*str)) str++;
	while(isspace(*ep)) ep--;
	ep++;
	*ep = 0;
	return(str);
}

// ------------------------------------------------------------ 

#include "strutil.h"

u_char *
read_file_or_args(char **argv, size_t *sz) {
	u_char *ret = NULL;
	
	if(argv && argv[0]) {
 		ret = (u_char *) copy_argv(argv);
 		*sz = strlen((char*) ret);
	} else 
		ret = read_desc(fileno(stdin), sz);

	return(ret);
}
