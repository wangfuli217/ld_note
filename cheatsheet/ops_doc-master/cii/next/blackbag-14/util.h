#ifndef LIB_UTIL_H
#define LIB_UTIL_H

/* Yes, this file is getting awfully big and unwieldy. Unfortunately, in 
 * 2005, there is nothing we can do with little bitty files that beats
 * Emacs I-search (or wtf it is in vim). So stick utility code here.
 */

#include <sys/types.h>
#include <sys/time.h>
#include <time.h>
#include <stdarg.h>
#include <ctype.h>
#include <pcap.h>

/* generic utility code (please feel free to dump code here!) */

/* mkdir -p
 */
int 		mkdirr(const char *, mode_t);

/* rm -rf 
 */
int 		rmdirr(const char *, int *);

/* Dump the contents of a file to memory. Free the result when
 * you finish. As a convenience, returned buffer will always 
 * be NUL-terminated, though the length is conveyed in "sz"
 */
u_char*		read_file(char *filename, size_t *sz);

/* As above, but for an arbitrary file descriptor (will block)
 */
u_char *	read_desc(int fd, size_t *sz);

/* Either of the above depending on "file" argument
 */
u_char *	read_file_or_stdin(char *file, size_t *sz);

/* stdin or argv catted
 */
u_char *	read_file_or_args(char **argv, size_t *sz);

/* resolve hostname or IP 
 */
u_int32_t 	resolve(char *name); 

/* 32 -> 255.255.255.255 24 -> 255.255.255.0
 */
u_int32_t 	mlen2mask(u_int mlen);

/* 255.255.255.0 -> 24
 */
u_int 		mask2mlen(u_int32_t mask);

/* randomize a buffer
 */
void*		memfry(void *, size_t);

/* I love you zero macro.
 */
#define 	zero(x) memset(x, 0, sizeof(*x))

/* jitter a timeval within +- the number of specified milliseconds 
 */
void 		tv_jitter(struct timeval *tv, u_int32_t ms);

/* Are these two IP addresses the two halves of (mask - 1)?
 */
int 		isipadjacent(u_int32_t, u_int32_t, int mask);

/* Return the address of the (mask - 1) container of this IP 
 */
u_int32_t 	ipparent(u_int32_t, int mask);

/* Given two prefixes, is the latter the "parent" netblock of
 * the former?
 */
int 		isipparent(u_int32_t, int, u_int32_t, int);

/* Chop off dirty host bits.
 */
u_int32_t 	ipnormalize(u_int32_t, int);

/* extract a common prefix from p1 and p2 to p3, return 
 * the common prefixlen 
 */
size_t 		prefix_common(const void *p1, const void *p2, size_t len, void *p3);

/* Read a string into IP prefix/mask 
 */
int 		cidr_aton(const char *s, u_int32_t *ip, u_int32_t *mask);

/* Are "a" and "b" within a threshold of each other?
 */
int 		iswithinpercent(double a, double b, int pct);

/* 6 -> "TCP" 17 -> "UDP"
 */
char*		getprotoname(u_int8_t proto);

/* "TCP" -> 6
 */
int		getprotonum(const char *proto);

/* map TCP flags to string 
 */
char*		gettcpflags(u_int8_t flags);

/* map TCP flag string to flags
 */
u_int32_t	str2flags(const char *str);

/* take a string, representing fractional seconds (.5 = 500ms),
 * convert to timeval.
 */
void    	settime(const char *string, struct timeval *tm);

#define 	ARR_LEN(m) (sizeof m / sizeof *m)

/* Get short or long from environment, or zero if the variable
 * isn't set.
 */
u_int16_t 	getenv16(const char *str);
u_int32_t 	getenv32(const char *str);

/* read an IP address in CIDR from the environment
 */
int		getenvip(const char *str, u_int32_t *ip, u_int32_t *mask);

/* don't hand-code stat(2)
 */ 
time_t		file_last_modified(int fd);

/* don't hand-code stat(2)
 */
size_t		file_size(int fd);

/* for working out port ranges
 */
u_int32_t       prefixlen_to_portlen(u_int16_t port, size_t preflen);
size_t          portlen_to_prefixlen(u_int32_t ports);

/*
 * write a file in one shot.  file will not appear under "path" until
 * contents have been completely written.  fname can be NULL.
 */
int		write_file_at_once(char *path, char *fname, const char *text);
int             write_binary_file_at_once(char *path, char *fname, const void *buf, int len);

/* pass "read" or "write" as first argument; loops until total length
 * has been written
 */
ssize_t 	atomicio(ssize_t (*)(), int, void *, size_t);

/* Verify with select() that a FD is ready for IO. -1 timeout blocks
 * indefinitely, 0 timeout busypolls.  Timeout is in milliseconds.
 */
int 		ready(int fd, int ms);
int 		writey(int fd, int ms);

/* Library writers should be put to death for not defining things like
 * this
 */
#define PIPE_READ_SIDE	0
#define PIPE_WRITE_SIDE 1

/* can i execute this program (calls access(2) underneath: do not use for security) 
 */
int 		canexec(const char *path);

/* can i read this file --- do not use for security
 */ 
int 		canread(const char *path);

/* can i write to this file --- do not use for security
 */ 
int 		canwrite(const char *path);

/* unix datagram socket bound to "path" 
 */
int 		udom(const char *path);

/* unix stream socket (listen5'd) bound to "path" 
 */
int 		udomc(const char *path);

/* connect to a connection-oriented unix-domain socket 
 */
int 		connectu(const char *path);

/* listen5'd tcp socket on host or INADDR_ANY on NULL 
 */
int 		ltcp(const char *host, unsigned porthostorder);

/* BLOCKING connection to host:port 
 */
int		ctcp(const char *host, unsigned port);

/* nonblocking connected UDP socket to host:port 
 */
int		cudp(const char *host, unsigned port);

/* udp socket on host or INADDR_ANY on NULL 
 */
int 		ludp(const char *host, unsigned porthostorder);

/* increase listen buffer to maximal size, returning it; bigger buffer ->
 * write more data before write() blocks.
 */
int 		embiggen(int fd);

/* convert string (which can just be integer, or a service
 * name) to port number in host byte order
 */
unsigned 	portname(const char *port);

/* remember, nonblocking is an ofile property, not fd,
 * return whether we're blocking or not 
 */
int 		toggleblock(int fd);
int 		setblock(int fd, int blocking);

/* can't imagine why you'd ever not want this set, but whatever
 */
int		reuseaddr(int fd);

typedef void (*nbc_cb)(int fd, int code, void *arg);

/* non-blocking connections; call cb when complete, return -1 or pass
 * -1 through "code" in cb on failure. wraps libevent. make as many 
 * outbound connections as you want; this code will scale.
 * 
 * this is one of the most useful functions in the library.
 */
int 		nbc(const char *address, unsigned port, nbc_cb cb, void *arg);
int 		nbc_timed(const char *address, unsigned port, unsigned timeout, nbc_cb cb, void *arg);

/* Quick and dirty dump-IP-packet function. Do not ever leave in
 * production code.
 */
void		quickipdump(u_char *buf);

/* Non-secure, reasonably fast integrity hash
 */
u_int64_t	bhash64(u_char *in, size_t l);

static inline u_int32_t bhash32(u_char *in, size_t l) {
	return((u_int32_t)bhash64(in, l));
}

/* For overflow testing (not thread-safe, sz bounded at 1M)
 */
char *		longstring(size_t sz);

/* Canon hexdump (to stdout) --- MOST USEFUL FUNCTION EVER.
 */
void 		hexdump(u_char *buf, size_t l);

/* Canon hexdump (to a string that you must free)
 */
char *		shexdump(u_char *buf, size_t l);

/* Reverse canon hexdump
 */
u_char *	unhexdump(char *buf, size_t *l);

/* Hexify (to a string that you must free)
 */
char *		shexify(u_char *buf, size_t l);

/* Reverse the previous process; "out" must contain at least "in"/2 bytes
 */
void		dehexify(char *in, u_char *out);

/* Canon c-dump (to a string that you must free)
 */
char *		scdump(u_char *buf, size_t l);

/* Convert Unicode to ASCII (lossy!)
 */
char *		unicode2ascii(char *dst, char *src, size_t dlen);

/* strdup for non-ASCIIZ strings
 */
void	       *bufdup(void *buf, size_t len);

/* convert a string to an amount of bytes, ala:
 *	4.5gb or 490393993 or 340M or 24.5k
 */
u_int64_t	strtoamt(char *str);

/* wait for activity on a single fd
 */
void		waitfd(int fd, int mode);

/* i love you pfopen() function (printf filename to FILE*)
 */
FILE *		pfopen(char *mode, char *fmt, ...);

/* that cast to size_t had really been pissing me off. The ternary is stupid,
 * but it has to be better than inadvertantly generating lengths over
 * 4 billion.
 */
#define 	OFFSUB(off, end) (off < end ? (size_t)(end - off) : (size_t)(off - end))

/* given a pointer, align the pointer to the specified size. every time
 * i write this by hand, I fuck it up.
 */
static inline u_char *pad(u_char *ptr, size_t align) {
	if(((u_long)ptr) % align)
		ptr += align - (((u_long)ptr) % align);
	return(ptr);
}

/* encode to base64; if "out" is NULL, just return the required size.
 */
size_t 		b64e(u_char *in, size_t inlen, char *out, size_t ol);

/* decode from base64, as above.
 */
size_t		b64d(char *in, size_t inlen, u_char *out, size_t ol);

/* strstr for u_char:size_t (or start:end)
 */
u_char *	memstr(u_char *in, size_t l, u_char *sub, size_t subl);
u_char *	memstrb(u_char *inp, u_char *endp, u_char *sub, size_t subl);

/* isspace, but NUL is also included
 */ 
static inline int iseot(int c) {
	return(!c || isspace(c));
}

/* skip by ctype macro. this is basically another way to say "strspn".
 */
static inline char *strskip(char *c, int (*fn)(int arg), int true) {
	while(*c && fn(*c) == true) c++;
	return(c);
}

/* skip by ctype macro, bounded
 */
static inline char *strskipb(char *c, char *ep, int (*fn)(int arg), int true) {
	while(c < ep && fn(*c) == true) c++;
	return(c);
}

/* safe atoi for dec/hex/octal (can pass NUL or NULL as "s", too)
 */
unsigned long 	atoulv(char *s, int *valid);

/* strchr for multiple chrs. another way to say "strpbrk" without
 * sounding like a bill the cat.
 */
char *		strchrs(const char *in, const char *chrs);     

/* compute MD5 hash
 */
void		md5(u_char *in, size_t len, u_char *out /* 16 bytes */);

/* compute SHA1 hash
 */
void		sha1(u_char *in, size_t len, u_char *out /* 20 bytes */);

/* a la perl
 */ 
static inline char *chop(char *s) {
	char *t = strsep(&s, "\r\n");
	return(t ? t : s);
}

/* has file at "path" changed? pass in time_t=0 the first time.
 */
int 		fnewer(const char *path, time_t *ts);

/* simpler than "getpeername"
 */
int		socketsource(int fd, u_int32_t *ip, u_int16_t *port);

/* generate a random u64
 */
u_int64_t	r64(void);

/* nul-terminate a bounded string (warning: from fn static)
 */
char *		nult(const char *sp, const char *ep);

/* strchr if 'c' occurs before 't'
 */
char *		strchrp(const char *s, int c, int t);

/* strstr if 'find' occurs before 'prev'
 * 
 * XXX SOMEONE PLS WRITE THIS
 */ 
char *		strstrp(const char *s, const char *find, const char *prev);

/* printf to a pcap filter on 'p'
 */
int		pfilter(pcap_t *p, char *filt, ...);

/* Convert UTF16LE to ASCII w/HTML entities
 */
char *          unicode2asc(char *dst, u_char *bp, u_char *ep, size_t *l);

/* Brain-dead wrapper around the above, don't ever use.
 */
char *          unicode2ascii(char *dst, char *src, size_t dlen);

/* Convert ASCII w/HTML entities to UTF16LE
 */
u_char *        ascii2unicode(u_char *dst, char *src, size_t *l);

/* read "n.n.n.n.n" into an array of integers        
 */
u_int32_t *     oidstr(char *str, u_int32_t *buf /*1024*/, size_t *n);

#ifdef __OpenBSD__
char *		strcasestr(char *h, char *n);
#endif
#ifdef __linux__
size_t strlcpy(char *dst, const char *src, size_t siz);
#endif
#endif

char *		strim(char *str);
