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
#include <dlfcn.h>
#ifdef __sun__

#endif

/* ------------------------------------------------------------ */

static void *
_get(char *name) {
	void *ret = NULL;
	void *h = dlopen("/lib/libc.so.1", RTLD_LAZY);

	printf("trying to hook \"%s\"\n", name);

	if(h && (ret = dlsym(h, name)))
		ret = ret;
	else if((h = dlopen("/lib/libnsl.so.1", RTLD_LAZY)) && (ret = dlsym(h, name)))
		ret = ret;
	else if((h = dlopen("/lib/libsocket.so.1", RTLD_LAZY)) && (ret = dlsym(h, name)))
		ret = ret;
	else {
		perror(h ? "dlsym" : "dlopen");
		abort();
	}

	printf("hooked \"%s\" @ %p\n", name, ret);

	return(ret);
}

/* ------------------------------------------------------------ */


#define HOOK4(name, rtype, t1, t2, t3, t4)				\
rtype									\
name (t1 a1, t2 a2, t3 a3, t4 a4) {					\
	rtype ret = 0;       						\
									\
	static rtype (*O)(t1, t2, t3, t4) = NULL;			\
									\
	if(!O) O = _get(#name);						\
									\
	if(_capture_##name (a1, a2, a3, a4, O, &ret))  			\
		ret = O(a1, a2, a3, a4);	    			\
									\
	return(ret);							\
}

/* ------------------------------------------------------------ */

static FILE *Rlog = NULL;

static int 
_capture_recv(int fd, void *buf, size_t len, int flags, void *o, ssize_t *ret) {
	ssize_t (*O)(int, void*, size_t, int) = o;

	if(!Rlog) {
		char buf[1024];
		snprintf(buf, 1000, "/tmp/rlog.%d", getpid());
		Rlog = fopen(buf, "w");
	}

	*ret = O(fd, buf, len, flags);

	if(Rlog) {
		unsigned int header[4] = { 
			0x48454c55L, 0, 0, 0
		};
	
		header[1] = (unsigned) time(NULL);
		header[2] = fd;
		header[3] = *ret;

		fwrite(header, 4, 4, Rlog);
		fwrite(buf, *ret, 1, Rlog);

		fflush(Rlog);
	}

	return(0);
}

/* ------------------------------------------------------------ */

static FILE *Slog = NULL;

static int 
_capture_send(int fd, const void *buf, size_t len, int flags, void *o, ssize_t *ret) {
	if(!Slog) {
		char buf[1024];
		snprintf(buf, 1000, "/tmp/slog.%d", getpid());
		Slog = fopen(buf, "w");
	}

	if(Slog) {
		unsigned int header[4] = { 
			0x48454c55L, 0, 0, 0
		};
	
		header[1] = (unsigned) time(NULL);
		header[2] = fd;
		header[3] = len;

		fwrite(header, 4, 4, Slog);
		fwrite(buf, len, 1, Slog);

		fflush(Slog);
	}

	return(1);
}

/* ------------------------------------------------------------ */

HOOK4(recv, ssize_t, int, void*, size_t, int);
HOOK4(send, ssize_t, int, const void*, size_t, int);

/* ------------------------------------------------------------ */

