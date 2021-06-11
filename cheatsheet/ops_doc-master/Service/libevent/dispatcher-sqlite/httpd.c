/*
 * Simple and portable HTTP server
 * Features:  CGI, SSL, Basic Auth, Cookies
 * Not implemented: If-Modified-Since support
 *
 * Compilation:
 *    SSL support:  -DWITH_SSL -I/usr/include/openssl -lssl
 *    No CGI:       -DNO_CGI
 *    No Basic auth:    -DNO_AUTH
 *
 * Author: Sergey Lyubka <valenok@gmail.com>
 *
 * Changelog:
 *   1.1    Multiple index files support
 *   1.2    Redirecting errors to a file.
 *      Fixed 'page contains no data' bug.
 *   1.3    Better error reporting (404, 500)
 *      Fixed CGI handling for win32, when CGI file is a native
 *      executable, not a script
 */

#define VERSION     "1.3"

#ifdef _WIN32                   /* Windows specific */
#include <winsock.h>
#include <io.h>
#define ERRNO       GetLastError()
typedef int socklen_t;
typedef void *pid_t;
typedef unsigned int uint32_t;
typedef unsigned short uint16_t;
#define waitpid(a,b,c)  0
#define EWOULDBLOCK WSAEWOULDBLOCK
#define SIGCHLD     0
#define SIGPIPE     SIGTERM
#define snprintf    _snprintf
#define vsnprintf   _vsnprintf
#define close(a)    closesocket(a)
#define open        _open
#define setuid(a)   0

#define PULL(a,b,c) recv(a, b, c, 0)
#define PUSH(a,b,c) send(a, b, c, 0)

#else                           /* UNIX specific */

/*
 * The reason behind PULL() and PUSH() macros is as follows:
 * Functions pull() and push() are used to read and write data from iobufs.
 * on windows, the file descriptors fdread and fdwrite in iobufs passed
 * to functions pull() and push() are always sockets, so we use
 * send() and recv(), because on Windows we cannot use read/write on sockets.
 * On UNIX fdread and fdwrite is socket for remote iobuf, file descriptor
 * for local regular file, and pipe for CGI. So we use read/write.
 */

#include <sys/wait.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include <unistd.h>
#define ERRNO       errno
#define PULL(a,b,c) read(a, b, c)
#define PUSH(a,b,c) write(a, b, c)
#endif                          /* _WIN32 */

#include <sys/types.h>          /* Common */
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <assert.h>
#include <time.h>
#include <errno.h>
#include <signal.h>
#include <string.h>
#include <ctype.h>
#include <fcntl.h>

#ifdef WITH_DMALLOC
#include <dmalloc.h>
#endif                          /* WITH_DMALLOC */

#ifdef WITH_SSL
#include <ssl.h>
#else                           /* Stubs for non-SSL build */
typedef void *SSL_CTX;
typedef void *SSL;
#define SSL_free(x)                 (void) 0
#define SSL_read(a,b,c)             0
#define SSL_write(a,b,c)            0
#define SSL_accept(a)               0
#define SSL_load_error_strings()    (void) 0
#define SSL_set_fd(a,b)             0
#define SSLeay_add_ssl_algorithms()         (void) 0
#define SSL_CTX_use_certificate_file(a,b,c) 0
#define SSL_CTX_use_PrivateKey_file(a,b,c)  0
#define SSL_CTX_new(a)              0
#define SSL_FILETYPE_PEM            0
#define SSL_new(a)                  0
#define SSL_ERROR_WANT_WRITE        -1
#define SSL_ERROR_WANT_READ         -1
#define SSL_get_error(a,b)          0
#define SSL_shutdown(a)             (void) 0
#endif                          /* WITH_SSL */

/*
 * Macros for doubly-linked circular linked lists.
 */
struct llhead {
    struct llhead *prev, *next;
};

#define LL_INIT(N)  ((N)->next = (N)->prev = (N))

#define LL_HEAD(H)  struct llhead H = { &H, &H }

#define LL_ENTRY(P,T,N) ((T *)((char *)(P) -(unsigned long)(&((T *) 0)->N)))

#define LL_TAIL(H, N)                               \
    do {                                            \
        ((H)->prev)->next = (N);                    \
        (N)->prev = ((H)->prev);                    \
        (N)->next = (H);                            \
        (H)->prev = (N);                            \
    } while (0)

#define LL_DEL(N)                                   \
    do {                                            \
        ((N)->next)->prev = ((N)->prev);            \
        ((N)->prev)->next = ((N)->next);            \
        LL_INIT(N);                                 \
    } while (0)

#define LL_FOREACH(H,N) for (N = (H)->next; N != (H); N = (N)->next)

#define LL_FOREACH_SAFE(H,N,T)                      \
    for (N = (H)->next, T = (N)->next; N != (H);    \
            N = (T), T = (N)->next)

/* General vector */
struct vec {
    int len;
    const void *ptr;
};

/* HTTP URL */
struct url {
    struct vec proto;
    struct vec user;
    struct vec pass;
    struct vec host;
    struct vec port;
    struct vec uri;
};

/* HTTP header */
struct hthdr {
    struct vec name;
    struct vec value;
};

/* HTTP information */
struct hti {
    struct vec method;
    struct vec url;
    struct vec proto;
    struct hthdr hh[64];        /* Headers */
    int nhdrs;                  /* Actual number of headers */
    int reqlen;                 /* Request line length */
    int totlen;                 /* request len + headers len */
};

/* HTTP header callback */
typedef void (*hcb_t) (const struct hthdr * header, void *userdata);

/* Unified socket address */
struct sa {
    socklen_t len;
    union {
        struct sockaddr sa;
        struct sockaddr_in sin;
    } u;
#ifdef WITH_IPV6
    struct sockaddr_in6 sin6;
#endif                          /* WITH_IPV6 */
};

struct iobuf {
    int fdread;                 /* Read file descriptor */
    int fdwrite;                /* Write file descriptor */
    SSL *ssl;                   /* SSL descriptor */
    char buf[16 * 1024];        /* Buffer */
    int nread;                  /* Bytes read */
    int nwritten;               /* Bytes written */
};

/* Connection from client */
struct conn {
    struct llhead link;         /* Connections chain */
    struct sa sa;               /* Remote socket address */
    struct iobuf local;         /* Local end io descriptor */
    struct iobuf remote;        /* Remote connection */
    struct hti hti;             /* Parsed request */
    struct vec uri;             /* URI vector */
    struct vec req;             /* stuff after ? */
    struct vec auth;            /* Auth vector */
    struct vec cookie;          /* Cookie: */
    struct vec clength;         /* Content-Length: */
    struct vec ctype;           /* Content-Type:  */
    struct vec status;          /* Status: */
    struct vec location;        /* Location: */
    time_t ims;                 /* If-Modified-Since: */
    time_t expire;              /* Expiration time */
    char user[32];              /* Authorized user */
    int ntotal;                 /* Total read from socket */
    int nexpected;              /* headers + content length */

    /* Flags */
    char gotrequest;            /* Request parsed flag */
    char gotreply;              /* Got CGI reply headers */
    char cgimode;               /* CGI */
    char sslaccepted;           /* SSL_accept() succeeded */
};

/*
 * Globals
 */
static const char *docroot = ".";   /* Document root */
static const char *certfile = "httpd.pem";  /* Certificate file */
static const char *htpass = ".htpasswd";    /* per-directory .htpasswd */
static const char *globhtpass;  /* Global .htpasswd file */
static const char *ifile = "index.html,index.cgi,index.php";
                        /* Index file */
static const char *logfile = "httpd.log";   /* Log file */
static const char *cgipat = ".cgi"; /* CGI file pattern */
static uint16_t lport = 80;     /* Listening port */
static SSL_CTX *ctx;            /* SSL context */
static int uid;                 /* Runtime User ID  */
static int quit;                /* Exit flag */
static int dossl;               /* SSL mode */
static int ttl = 300;           /* Max idle time */
static time_t now;              /* Current time */
static LL_HEAD (conns);         /* List of connections */

/* Compare two vectors case-insensitive */
static int vcasecmp (const struct vec *v1, const struct vec *v2) {
    register const char *s1, *s2, *e;
    int equal = 0;

    if (v1->len == v2->len) {
        for (s1 = v1->ptr, s2 = v2->ptr, e = s1 + v1->len; s1 < e; s1++, s2++)
            if (tolower (*s1) != tolower (*s2))
                break;
        if (s1 == e)
            equal++;
    }

    return (equal);
}

/* Return integer represented by vector */
static int vtoint (const struct vec *v) {
    int i, n;

    for (i = n = 0; i < v->len; i++) {
        n *= 10;
        n += ((char *) v->ptr)[i] - '0';
    }

    return (n);
}

/* Return ptr to character `ch' in a vector, or NULL */
static const char *vchr (const struct vec *v, char ch) {
    register const char *s, *e, *p;

    for (p = NULL, s = v->ptr, e = s + v->len; s < e; s++)
        if (*s == ch) {
            p = s;
            break;
        }

    return (p);
}

/*
 * Assume the given string `s' of length `len' is pointing to valid URL,
 * parse this URL, filling the passed struct url u
 * Return -1 if the URL is invalid, or the URL length.
 */
static int hturl (const char *s, int len, struct url *u) {
    register const char *p, *e;
    struct vec *v, nil = { 0, 0 };

    (void) memset (u, 0, sizeof (*u));

    /* Now, dispatch URI */
    for (p = s, e = s + len, v = &u->proto; p < e; p++) {
        switch (*p) {

        case ':':
            if (v == &u->proto) {
                if (&p[2] < e && p[1] == '/' && p[2] == '/') {
                    p += 2;
                    v = &u->user;
                } else {
                    u->user = u->proto;
                    u->proto = nil;
                    v = &u->pass;
                }
            } else if (v == &u->user) {
                v = &u->pass;
            } else if (v == &u->host) {
                v = &u->port;
            } else if (v == &u->uri) {
                /* : is allowed in path or query */
                v->len++;
            } else {
                return (-1);
            }
            break;

        case '@':
            if (v == &u->proto) {
                u->user = u->proto;
                u->proto = nil;
                v = &u->host;
            } else if (v == &u->pass || v == &u->user) {
                v = &u->host;
            } else if (v == &u->uri) {
                /* @ is allowed in path or query */
                v->len++;
            } else {
                return (-1);
            }
            break;

        case '/':
#define SETURI()    v = &u->uri; v->ptr = p; v->len = 1
            if ((v == &u->proto && u->proto.len == 0) || v == &u->host || v == &u->port) {
                SETURI ();
            } else if (v == &u->user) {
                u->host = u->user;
                u->user = nil;
                SETURI ();
            } else if (v == &u->pass) {
                u->host = u->user;
                u->port = u->pass;
                u->user = u->pass = nil;
                SETURI ();
            } else if (v == &u->uri) {
                /* / is allowed in path or query */
                v->len++;
            } else {
                return (-1);
            }
            break;

        default:
            if (!v->ptr)
                v->ptr = p;
            v->len++;
        }
    }

    if (v == &u->proto && v->len > 0) {
        v = ((char *) v->ptr)[0] == '/' ? &u->uri : &u->host;
        *v = u->proto;
        u->proto = nil;
    } else if (v == &u->user) {
        u->host = u->user;
        u->user = nil;
    } else if (v == &u->pass) {
        u->host = u->user;
        u->port = u->pass;
        u->user = u->pass = nil;
    }

    return (p - s);
}

/*
 * Parse given HTTP request.
 * Fill struct hti during parse.
 * For every header, call `cb'.
 * Return number of parsed bytes (normally, full request length)
 */
static int htparse (const char *s, int len, struct hti *info, hcb_t cb, void *data) {
    register const char *p, *e = s + len;
    struct vec h, v, vec[3] = { {0, 0}, {0, 0}, {0, 0} };
    struct hthdr *hdr;
    int i;
    enum { WAIT, CONT, HDR, HDRVAL } state;

    (void) memset (info, 0, sizeof (*info));

    for (state = WAIT, i = 0, p = s; p < e; p++)
        switch (state) {

        case WAIT:
            if (*p != ' ') {
                state = CONT;
                vec[i].ptr = p;
                vec[i].len = 0;
            }
            break;

        case CONT:
            vec[i].len++;
            if (*p == ' ' && i < 2) {
                state = WAIT;
                i++;
            } else if (*p == '\n') {
                /* End request */
                info->reqlen = p - s + 1;
                if (vec[i].len > 0 && p[-1] == '\r')
                    vec[i].len--;
                h.ptr = p + 1;
                h.len = v.len = 0;
                v.ptr = NULL;
                info->method = vec[0];
                info->url = vec[1];
                info->proto = vec[2];
                state = HDR;
            }
            break;

        case HDR:
            if (*p == ':') {
                v.ptr = p + 1;
                state = HDRVAL;
            } else if (*p == '\n') {
                /* End headers */
                info->totlen = p - s + 1;
                return (info->totlen);
            } else if (v.len == 0 && isspace (*p)) {
                /* skip initial whitespaces */
                h.ptr = p + 1;
            } else {
                h.len++;
            }
            break;

        case HDRVAL:
            if (*p == '\n') {
                if (v.len && p[-1] == '\r')
                    v.len--;
                /* Save header */
                hdr = &info->hh[info->nhdrs++];
                if (info->nhdrs < (int)
                    (sizeof (info->hh) / sizeof (info->hh[0]))) {
                    hdr->name = h;
                    hdr->value = v;
                    if (cb)
                        cb (hdr, data);
                }
                h.ptr = p + 1;
                v.ptr = NULL;
                h.len = v.len = 0;
                state = HDR;
            } else if (v.len == 0 && isspace (*p)) {
                /* skip initial whitespaces */
                v.ptr = p + 1;
            } else {
                v.len++;
            }
            break;
        }

    return (-1);
}

/*
 * SIGTERM, SIGINT signal handler
 */
static void sigterm (int signo) {
    quit = signo;
}

/*
 * Grim reaper of innocent children: SIGCHLD signal handler
 */
static void sigchild (int signo) {
    while (waitpid (-1, &signo, WNOHANG) > 0) ;
}

/*
 * Log function
 */
static void elog (int fatal, const char *fmt, ...) {
    va_list ap;

#if 1
    if (!fatal)                 /* Do not show debug messages */
        return;
#endif

    (void) fprintf (stderr, "%lu ", (unsigned long) now);

    va_start (ap, fmt);
    (void) vfprintf (stderr, fmt, ap);
    va_end (ap);

    (void) fputc ('\n', stderr);

    if (fatal)
        exit (EXIT_FAILURE);
}

static void usage (const char *prog) {
    (void) fprintf (stderr,
                    "shttpd version %s\n"
                    "usage: %s [OPTIONS]\n"
                    "-d directory   document root (dflt: %s)\n"
                    "-p port        listen on port (dflt: 80 or 443)\n" "-l logfile     log file (dflt: %s)\n" "-e elogfile    errorlog file (dflt: none)\n" "-i file1,..    index file (dflt: %s)\n"
#ifndef NO_CGI
                    "-c cgipattern  CGI file pattern (dflt: %s)\n"
#endif                          /* NO_CGI */
#ifndef NO_AUTH
                    "-P passfile    authorization passwords file (dflt: none)\n"
#endif                          /* NO_AUTH */
                    "-u numeric_uid run-time UID (dflt: none)\n"
#ifdef WITH_SSL
                    "-s certfile    SSL certfileificate (dflt: %s)\n" "-S         use SSL (dflt: NO)\n"
#endif                          /* WITH_SSL */
                    , VERSION, prog, docroot, logfile, ifile
#ifndef NO_CGI
                    , cgipat
#endif                          /* NO_CGI */
#ifdef WITH_SSL
                    , certfile
#endif                          /* WITH_SSL */
        );

    exit (EXIT_FAILURE);
}

/*
 * Write an HTTP access log into a file `logfile'
 */
static void accesslog (const struct conn *c, int status) {
    char date[64];
    FILE *fp;

    if ((fp = fopen (logfile, "a"))) {
        (void) strftime (date, sizeof (date), "%d/%b/%Y %H:%M:%S", localtime (&now));
        (void) fprintf (fp, "%.15s - %s [%s] \"%.*s %.*s %.*s\" %d\n",
                        inet_ntoa (c->sa.u.sin.sin_addr),
                        c->user[0] == '\0' ? "-" : c->user,
                        date, c->hti.method.len, (char *) c->hti.method.ptr, c->hti.url.len, (char *) c->hti.url.ptr, c->hti.proto.len, (char *) c->hti.proto.ptr, status);
        (void) fclose (fp);
    }
}

/*
 * Put given file descriptor in blocking (block == 1)
 * or non-blocking (block == 0) mode.
 * Return 0 if success, or -1
 */
static int blockmode (int fd, int block) {
#ifdef  _WIN32
    unsigned long on = !block;

    return (ioctlsocket (fd, FIONBIO, &on));
#else
    int flags, retval = 0;

    if ((flags = fcntl (fd, F_GETFL, 0)) == -1) {
        elog (0, "nonblock: fcntl(%d, F_GETFL): %s", fd, strerror (ERRNO));
        retval--;
    } else {
        if (block)
            flags &= ~O_NONBLOCK;
        else
            flags |= O_NONBLOCK;

        /* Apply the mode */
        if (fcntl (fd, F_SETFL, flags) != 0) {
            elog (0, "nonblock: fcntl(%d, F_SETFL): %s", fd, strerror (ERRNO));
            retval--;
        }
    }

    return (retval);
#endif                          /* _WIN32 */
}

#ifdef _WIN32
static int socketpair (SOCKET * pair) {
    SOCKET servsock;
    int val;
    struct sockaddr_in out, in;

    servsock = socket (PF_INET, SOCK_STREAM, 0);
    if (servsock == INVALID_SOCKET)
        goto fail;

    memset (&out, 0, sizeof (out));
    out.sin_family = AF_INET;
    out.sin_addr.s_addr = htonl (INADDR_ANY);
    out.sin_port = htons (0);

    val = sizeof (out);
    if (bind (servsock, (struct sockaddr *) &out, val) < 0)
        goto fail;

    listen (servsock, 1);

    if (getsockname (servsock, (struct sockaddr *) &out, &val) < 0)
        goto fail;

    if ((pair[0] = socket (PF_INET, SOCK_STREAM, 0)) == INVALID_SOCKET)
        goto fail;

    memset (&in, 0, sizeof (in));
    in.sin_family = AF_INET;
    in.sin_addr.s_addr = htonl (0x7f000001);
    in.sin_port = out.sin_port;

    if (connect (pair[0], (struct sockaddr *) &in, sizeof (in)) < 0)
        goto fail;

    if ((pair[1] = accept (servsock, (struct sockaddr *) &out, &val))
        == INVALID_SOCKET)
        goto fail;

    closesocket (servsock);

    return (0);

  fail:
    (void) closesocket (pair[0]);
    (void) closesocket (pair[1]);
    closesocket (servsock);
    return (WSAGetLastError ());
}

struct threadparam {
    SOCKET s;
    int fd;
};

/*
 * Poll a socket, if something found, push to stdout
 */
static DWORD WINAPI stdoutput (struct threadparam *tp) {
    int n, k, sent, stop = 0;
    char buf[8192];

    _setmode (tp->fd, O_BINARY);

    while (stop == 0) {
        n = recv (tp->s, buf, sizeof (buf), 0);

        if (n <= 0)
            stop++;
        else
            for (sent = 0; sent < n; sent += k)
                if ((k = _write (tp->fd, buf, n)) <= 0)
                    stop++;
    }

    elog (0, "stdoutput: exiting");

    _close (tp->fd);
    closesocket (tp->s);
    free (tp);
    return (0);
}

/*
 * Poll stdin, if something found, push it to socket
 */
static DWORD WINAPI stdinput (struct threadparam *tp) {
    int n, k, sent, stop = 0;
    char buf[8192];

    _setmode (tp->fd, O_BINARY);

    while (stop == 0) {
        n = _read (tp->fd, buf, sizeof (buf));

        if (n <= 0)
            stop++;
        else
            for (sent = 0; sent < n; sent += k)
                if ((k = send (tp->s, buf, n, 0)) <= 0)
                    stop++;

        elog (0, "stdinput: read %d bytes (%s)", n, strerror (ERRNO));
    }

    elog (0, "stdinput: exiting");

    _close (tp->fd);
    closesocket (tp->s);
    free (tp);
    return (0);
}

/*
 * Connect opened file descriptor to a socket pair, and return
 * one side of a pipe or -1
 * If opened file descriptor is opened for reading, pass stdinput as func
 * If opened file descriptor is opened for writing, pass stdoutput as func
 */
static int fdtosock (int fd, int in) {
    struct threadparam *tp;
    SOCKET pair[2];
    DWORD tid;

    if ((tp = malloc (sizeof (*tp))) == NULL)
        return (-1);

    socketpair (pair);
    tp->s = pair[0];
    tp->fd = fd;
    CreateThread (NULL, 0, in ? stdinput : stdoutput, (void *) tp, 0, &tid);

    return (pair[1]);
}

#endif                          /* _WIN32 */

/*
 * Setup listening socket on given port, return socket
 */
static int Listen (uint16_t port) {
    int sock, on = 1, af;
    struct sa sa;

#ifdef WITH_IPV6
    af = PF_INET6;
#else
    af = PF_INET;
#endif                          /* WITH_IPV6 */

    if ((sock = socket (af, SOCK_STREAM, 6)) == -1)
        elog (1, "Listen: socket: %s", strerror (ERRNO));

    /* Make it nonblock to avoid block in accept() */
    blockmode (sock, 0);
    setsockopt (sock, SOL_SOCKET, SO_REUSEADDR, (char *) &on, sizeof (on));

#ifdef WITH_IPV6
    sa.u.sin6.sin6_family = af;
    sa.u.sin6.sin6_port = htons (port);
    sa.u.sin6.sin6_addr = in6addr_any;
    sa.len = sizeof (sa.u.sin6);
#else
    sa.u.sin.sin_family = af;
    sa.u.sin.sin_port = htons (port);
    sa.u.sin.sin_addr.s_addr = INADDR_ANY;
    sa.len = sizeof (sa.u.sin);
#endif                          /* WITH_IPV6 */

    if (bind (sock, &sa.u.sa, sa.len) < 0)
        elog (1, "Listen: af %d bind(%d): %s", af, port, strerror (ERRNO));

    (void) listen (sock, 16);

    return (sock);
}

static void closeiobuf (struct iobuf *io) {
    elog (0, "closeiobuf: %d", io->fdread);

    if (io->ssl) {
        SSL_shutdown (io->ssl);
        SSL_free (io->ssl);
        io->ssl = NULL;
    }

    if (io->fdwrite != -1) {
        (void) close (io->fdwrite);
        io->fdwrite = -1;
    }

    if (io->fdread != -1) {
        (void) close (io->fdread);
        io->fdread = -1;
    }
}

/*
 * Close connection
 */
static void closeconn (struct conn *c) {
    elog (0, "closeconn: %d %d", c->remote.fdread, c->local.fdread);

    closeiobuf (&c->local);
    closeiobuf (&c->remote);
}

static time_t datetosec (const struct vec *v) {
    v = 0;
    return (now);
}

/*
 * Callback function called fow every header when request is parsed.
 * the connection is passwd as arg
 */
static void cbheader (const struct hthdr *header, void *arg) {
    struct vec auth = { 13, "Authorization" }, cookie = {
    6, "Cookie"}, cl = {
    14, "Content-Length"}, loc = {
    8, "Location"}, status = {
    6, "Status"}, ims = {
    18, "If-Modified-Since:"}, ct = {
    12, "Content-Type"};
    struct conn *c = arg;

    if (vcasecmp (&header->name, &auth))
        c->auth = header->value;
    else if (vcasecmp (&header->name, &cookie))
        c->cookie = header->value;
    else if (vcasecmp (&header->name, &cl))
        c->clength = header->value;
    else if (vcasecmp (&header->name, &ct))
        c->ctype = header->value;
    else if (vcasecmp (&header->name, &loc))
        c->location = header->value;
    else if (vcasecmp (&header->name, &status))
        c->status = header->value;
    else if (vcasecmp (&header->name, &ims))
        c->ims = datetosec (&header->value);
}

/*
 * Send an error back to a client.
 */
static void senderr (struct conn *c, int status, const char *descr, const char *headers, const char *fmt, ...) {
    char msg[512];
    va_list ap;
    int n;

    n = snprintf (msg, sizeof (msg), "HTTP/1.0 %d %s\r\n%s\r\n\r\n", status, descr, headers);

    va_start (ap, fmt);
    n += vsnprintf (msg + n, sizeof (msg) - n, fmt, ap);
    va_end (ap);

    if (c->remote.ssl)
        (void) SSL_write (c->remote.ssl, msg, n);
    else
        (void) send (c->remote.fdwrite, msg, n, 0);

    accesslog (c, status);

    closeconn (c);
}

/*
 * Push data to client
 */
static void push (struct iobuf *from, struct iobuf *to) {
    int n, buflen;

    buflen = from->nread - from->nwritten;

    assert (buflen > 0);
    assert (to->fdwrite != -1);

    if (to->ssl)
        n = SSL_write (to->ssl, from->buf + from->nwritten, buflen);
    else
        n = PUSH (to->fdwrite, from->buf + from->nwritten, buflen);

#if 1
    elog (0, "push: %d %d.%p (%d)", from->fdread, to->fdwrite, to->ssl, n);
#endif
    if (n > 0) {
#if 0
        elog (0, "push: [%.*s]", n, from->buf + from->nwritten);
#endif
        from->nwritten += n;
        if (from->nwritten == from->nread)
            from->nwritten = from->nread = 0;
    } else if (n <= 0 && ERRNO != EWOULDBLOCK) {
        closeiobuf (to);
    } else {
        elog (0, "push: send: %s", strerror (ERRNO));
    }
}

#ifndef NO_CGI
/*
 * Open program, and return read/write pipes to it
 */
static int redirect (const char *prog, int *in, int *out, char **envp) {
    int r[2], w[2];
    pid_t pid;

#ifdef _WIN32
    char cmdline[2048], line[1024] = "#!", *p;
    FILE *fp;
    STARTUPINFO si;
    PROCESS_INFORMATION pi;

    if (_pipe (r, BUFSIZ, _O_BINARY) == -1 || _pipe (w, BUFSIZ, _O_BINARY)) {
        elog (0, "redirect: _pipe");
        return (-1);
    }

    (void) memset (&si, 0, sizeof (si));
    si.cb = sizeof (si);
    si.dwFlags = STARTF_USESHOWWINDOW | STARTF_USESTDHANDLES;
    si.wShowWindow = SW_HIDE;
    si.hStdInput = (HANDLE) _get_osfhandle (w[0]);
    si.hStdOutput = si.hStdError = (HANDLE) _get_osfhandle (r[1]);

    /* If CGI file is a script, try to read the interpreter line */
    if ((fp = fopen (prog, "r")) != NULL) {
        (void) fgets (line, sizeof (line), fp);
        if (line[0] != '#' || line[1] != '!')
            line[2] = '\0';
        /* Trim whitespaces from interpreter name */
        for (p = &line[strlen (line) - 1]; p > line && isspace (*p); p--)
            *p = '\0';

        (void) fclose (fp);
    }

    (void) snprintf (cmdline, sizeof (cmdline), "%s%s%s", line + 2, line[2] == '\0' ? "" : " ", prog);
    elog (0, "redirect: cmdline [%s]", cmdline);

    if (CreateProcess (NULL, cmdline, NULL, NULL, TRUE, CREATE_NEW_PROCESS_GROUP, NULL, NULL, &si, &pi) == 0) {
        elog (0, "redirect: CreateProcess(%s): %d", cmdline, ERRNO);
        _close (r[0]), _close (r[1]), _close (w[0]), close (w[1]);
        return (-1);
    }

    pid = pi.hProcess;

    (void) _close (r[1]);
    (void) _close (w[0]);
    *in = r[0];
    *out = w[1];
    return (0);
#else
    unsigned i, word;
    char *argv[128], *s;
#define NELEMS(ar)  (sizeof(ar) / sizeof(ar[0]))

    /* Prepare the argv */
    for (i = word = 0, s = strdup (prog); s && *s && i < NELEMS (argv); s++)
        if (isspace (*s) && word) {
            *s = '\0';
            word = 0;
        } else if (!isspace (*s) && !word) {
            argv[i++] = s;
            word = 1;
        }
    argv[i] = NULL;

    if (pipe (r) != 0 || pipe (w) != 0) {
        elog (0, "redirect: pipe");
        return (-1);
    }

    if ((pid = fork ()) == -1) {
        elog (0, "redirect: fork");
        return (-1);
    } else if (pid == 0) {
        /* Child */
        (void) close (r[0]);
        (void) close (w[1]);
        (void) close (0);
        (void) close (1);
        if (dup2 (r[1], 1) == -1 || dup2 (w[0], 0) == -1)
            elog (1, "redirect: dup2");

        (void) execve (argv[0], argv, envp);
        elog (1, "redirect: exec(%s)", argv[0]);
    } else {
        /* Parent */
        (void) close (r[1]);
        (void) close (w[0]);
        *in = r[0];
        *out = w[1];
    }

    return (0);
#endif                          /* _WIN32 */
}

/*
 * Start CGI program
 */
static int spawncgi (struct conn *c, const char *prog) {
    char *p, qs[BUFSIZ], gi[BUFSIZ], sn[BUFSIZ], path[BUFSIZ], ct[BUFSIZ], rm[BUFSIZ], pl[BUFSIZ], user[BUFSIZ], cookie[BUFSIZ], cl[BUFSIZ], *env[20];
    int ret;

    /* Prepare the environment */
    env[0] = gi;
    (void) snprintf (gi, sizeof (gi), "GATEWAY_INTERFACE=CGI/1.1");

    env[1] = sn;
    (void) snprintf (sn, sizeof (sn), "SCRIPT_NAME=%.*s", c->uri.len, (char *) c->uri.ptr);
    elog (0, "spawncgi: sn [%s]", sn);

    env[2] = path;
    if ((p = getenv ("PATH")) == NULL)
        p = "/bin:/sbin:/usr/bin:/usr/sbin";
    (void) snprintf (path, sizeof (path), "PATH=%s", p);

    env[3] = qs;
    (void) snprintf (qs, sizeof (qs), "QUERY_STRING=%.*s", c->req.len, (char *) c->req.ptr);

    env[4] = ct;
    (void) snprintf (ct, sizeof (ct), "CONTENT_TYPE=%s", "text/html");

    env[5] = rm;
    (void) snprintf (rm, sizeof (rm), "REQUEST_METHOD=%.*s", c->hti.method.len, (char *) c->hti.method.ptr);
    elog (0, "spawncgi: rm [%s]", rm);

    env[6] = pl;
    if ((p = getenv ("PERLLIB")) == NULL)
        p = "/perl";
    (void) snprintf (pl, sizeof (pl), "PERLLIB=%s", p);

    env[7] = user;
    (void) snprintf (user, sizeof (user), "REMOTE_USER=%s", "Mr. Bin");

    env[8] = cookie;
    (void) snprintf (cookie, sizeof (cookie), "HTTP_COOKIE=%.*s", c->cookie.len, (char *) c->cookie.ptr);

    env[9] = cl;
    (void) snprintf (cl, sizeof (cl), "CONTENT_LENGTH=%d", vtoint (&c->clength));

    env[10] = ct;
    (void) snprintf (ct, sizeof (ct), "CONTENT_TYPE=%.*s", c->ctype.len, (char *) c->ctype.ptr);

    env[11] = NULL;

    ret = redirect (prog, &c->local.fdread, &c->local.fdwrite, env);

#ifdef _WIN32
    c->local.fdread = fdtosock (c->local.fdread, 1);
    c->local.fdwrite = fdtosock (c->local.fdwrite, 0);
#endif                          /* _WIN32 */

    return (ret);
}
#endif                          /* NO_CGI */

/*
 * Parse CGI reply, construct reply line, and set gotreply flag so
 * further CGI output will be passed through
 */
static void reply (struct conn *c) {
    int n, status = 200;
    char buf[512], *p;

    if (htparse (c->local.buf, c->local.nread, &c->hti, cbheader, c) < 0) {
        elog (0, "reply error:%d %d", c->local.fdread, c->local.nread);
        return;
    }

    c->gotreply++;

    if (c->status.len > 0)
        status = vtoint (&c->status);
    else if (c->location.len > 0)
        status = 302;

    switch (status) {
    case 200:
        p = "OK";
        break;
    case 302:
        p = "Found";
        break;
    case 304:
        p = "Not Modified";
        break;
    case 400:
        p = "Bad Request";
        break;
    case 401:
        p = "Unauthorized";
        break;
    case 403:
        p = "Forbidden";
        break;
    case 404:
        p = "Not Found";
        break;
    case 408:
        p = "Request Timeout";
        break;
    case 500:
        p = "Internal Error";
        break;
    case 501:
        p = "Not Implemented";
        break;
    case 503:
        p = "Service Temporarily Overloaded";
        break;
    default:
        p = "tralala";
        break;
    }

    n = snprintf (buf, sizeof (buf), "HTTP/1.0 %d %s\r\n", status, p);
    if (c->remote.ssl)
        (void) SSL_write (c->remote.ssl, buf, n);
    else
        (void) send (c->remote.fdwrite, buf, n, 0);
}

#ifndef NO_AUTH
/*
 * Base64 decoding table
 */
static char tab[256] = {
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1,
    -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1,
    -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
};

static int decode64 (const unsigned char *s, int len, char *to, int tolen) {
    const unsigned char *p, *e;
    int n, d, prev, state;

    for (p = s, e = p + len, n = state = d = prev = 0; n < tolen && p < e; p++, prev = d) {
        if ((d = tab[*p]) == -1)
            continue;
        switch (state) {
        case 0:
            state++;
            break;
        case 1:
            to[n++] = prev << 2 | d >> 4;
            state++;
            break;
        case 2:
            to[n++] = prev << 4 | d >> 2;
            state++;
            break;
        case 3:
            to[n++] = ((prev << 6) & 0xc0) | d;
            state = 0;
            break;
        }
    }
    to[n] = '\0';

    elog (0, "decode64: %d %d [%.*s] [%s]", n, len, len, s, to);

    return (n);
}

/*
 * Check authorization. Return 1 if not needed or authorized, 0 otherwise
 */
static int checkauth (struct conn *c, struct vec *uri) {
    int authorized = 1;
    const char *p, *e;
    char authfile[2048], line[BUFSIZ], auth[BUFSIZ], *pass, *cryptpass, *s;
    FILE *fp;

    if (globhtpass) {
        /* Use global passwords file */
        (void) snprintf (authfile, sizeof (authfile), "%s", globhtpass);
    } else {
        /* Try to find .htpasswd in requested directory */
        for (p = uri->ptr, e = p + uri->len; e != NULL && e > p; e--)
            if (*e == '/')
                break;
        if (p == NULL)
            p = "/", e = p + 1;
        (void) snprintf (authfile, sizeof (authfile), "%s/%.*s/%s", docroot, e - p, p, htpass);
    }

    /* Try to open passwords file */
    if ((fp = fopen (authfile, "r")) != NULL) {
        /* Loop through lines */
        authorized = 0;

        if (c->auth.len > 6 && memcmp (c->auth.ptr, "Basic ", 6) == 0 && decode64 ((unsigned char *) c->auth.ptr + 6, c->auth.len - 6, auth, sizeof (auth)) > 0 && (pass = strchr (auth, ':')) != NULL) {
            *pass++ = '\0';

            while (fgets (line, sizeof (line), fp) != NULL) {

                /* Trim line */
                for (s = line + strlen (line) - 1; s > line && isspace (*s); s--)
                    *s = '\0';

                /* Split into user and encrypted password. */
                if ((cryptpass = strchr (line, ':')) == NULL)
                    continue;

                *cryptpass++ = '\0';

                /* Check user */
                if (!strcmp (line, auth)) {
                    if (!strcmp (cryptpass, pass))
                        authorized = 1;
                    (void) strncpy (c->user, line, sizeof (c->user));
                    break;
                }
            }
        }
        if (authorized == 0)
            senderr (c, 401, "Unauthorized", "WWW-Authenticate: Basic realm=\"user\"", "Authentication required");
        (void) fclose (fp);
    }

    return (authorized);
}
#endif                          /* NO_AUTH */

static void sendheaders (const struct conn *c) {
    char headers[2048];
    const char *mime = "text/plain";
    int i, n;
    struct vec v;
    struct {
        struct vec v;
        const char *mime;
    } tab[] = {
        { {
        5, ".html"}, "text/html"}, { {
        4, ".htm"}, "text/html"}, { {
        4, ".css"}, "text/css"}, { {
        4, ".gif"}, "image/gif"}, { {
        4, ".jpg"}, "image/jpeg"}, { {
        5, ".jpeg"}, "image/jpeg"}, { {
        4, ".png"}, "image/png"}, { {
        4, ".mpg"}, "video/mpeg"}, { {
        4, ".asf"}, "video/x-ms-asf"}, { {
        4, ".avi"}, "video/x-msvideo"}, { {
        4, ".bin"}, "application/octet-stream"}, { {
        4, ".bmp"}, "image/bmp"}, { {
        4, ".doc"}, "application/msword"}, { {
        4, ".exe"}, "application/octet-stream"}, { {
    4, ".zip"}, "application/zip"},};

    /* Figure out the mime type */
    for (i = 0; i < (int) (sizeof (tab) / sizeof (tab[0])); i++) {
        if (c->uri.len <= tab[i].v.len)
            continue;
        v.ptr = (char *) c->uri.ptr + c->uri.len - tab[i].v.len;
        v.len = tab[i].v.len;
        if (vcasecmp (&v, &tab[i].v)) {
            mime = tab[i].mime;
            break;
        }
    }

    n = snprintf (headers, sizeof (headers), "HTTP/1.0 200 OK\r\n" "Content-type: %s\r\n" "\r\n", mime);

    accesslog (c, 200);

    if (c->remote.ssl)
        (void) SSL_write (c->remote.ssl, headers, n);
    else
        (void) send (c->remote.fdwrite, headers, n, 0);
}

/*
 * Protect from ..
 */
static void dotdot (char *file) {
    char *p, *s;
    int n;

    /* Collapse any multiple / sequences. */
    while ((p = strstr (file, "//")) != NULL) {
        for (s = p + 2; *s == '/'; ++s)
            continue;
        (void) strcpy (p + 1, s);
    }

    /* Remove leading ./ and any /./ sequences. */
    while (strncmp (file, "./", 2) == 0)
        (void) strcpy (file, file + 2);

    while ((p = strstr (file, "/./")) != NULL)
        (void) strcpy (p, p + 2);

    /* Alternate between removing leading ../ and removing xxx/../ */
    for (;;) {
        while (strncmp (file, "../", 3) == 0)
            (void) strcpy (file, file + 3);
        if ((p = strstr (file, "/../")) == NULL)
            break;
        for (s = p - 1; s >= file && *s != '/'; --s)
            continue;
        (void) strcpy (s + 1, p + 4);
    }

    /* Also elide any xxx/.. at the end. */
    while ((n = strlen (file)) > 3 && strcmp ((p = file + n - 3), "/..") == 0) {
        for (s = p - 1; s >= file && *s != '/'; --s)
            continue;
        if (s < file)
            break;
        *s = '\0';
    }
}

static void fixdirsep (char *path) {
#ifdef _WIN32
    /* Change Web directory separators to Windows ones, / -> \  */
    for (; *path != '\0'; path++)
        if (*path == '/')
            *path = '\\';
#else
    path = NULL;
#endif                          /* _WIN32 */
}

/*
 * For given directory path, substitute it to valid index file.
 * Return 0 if index file has been found, -1 if not found
 */
static int useindex (char *path, size_t maxpath) {
    struct stat st;
    char try[2048], index[64];
    const char *s = ifile;

    do {
        if (sscanf (s, "%64[^,]", index)) {
            (void) snprintf (try, sizeof (try), "%s%s", path, index);
            fixdirsep (try);
            if (stat (try, &st) == 0) {
                strncat (path, index, maxpath - strlen (path) - 1);
                return (0);
            }
        }

        /* Move to the next index file */
        if ((s = strchr (s, ',')) != NULL)
            s++;
    } while (s != NULL);

    return (-1);
}

/*
 * Try to open requested file
 */
static void handle (struct conn *c) {
    struct stat st;
    struct url url;
    const char *p;
    char file[2048];
    int n;

    if (htparse (c->remote.buf, c->remote.nread, &c->hti, cbheader, c) < 0)
        return;
    c->gotrequest++;
    c->remote.nwritten = c->hti.totlen;
    c->nexpected = c->hti.totlen + vtoint (&c->clength);

#ifdef NO_AUTH
#define checkauth(a,b)  1
#endif                          /* NO_AUTH */

    if (hturl (c->hti.url.ptr, c->hti.url.len, &url) <= 0) {
        senderr (c, 500, "Bad Request", "", "Bad request");
    } else if (checkauth (c, &url.uri) == 1) {
        c->uri = url.uri;

        elog (0, "handle: [%.*s]", c->uri.len, (char *) c->uri.ptr);

        /* Strip QUERY_STRING from URI */
        if (c->uri.len != 0 && (p = vchr (&c->uri, '?')) != NULL) {
            c->req.len = (char *) c->uri.ptr + c->uri.len - p - 1;
            c->req.ptr = p + 1;
            c->uri.len = p - (char *) c->uri.ptr;
            assert (c->uri.len >= 0);
            assert (c->req.len >= 0);
        }

        n = snprintf (file, sizeof (file), "%s/./%.*s", docroot, c->uri.len, (char *) c->uri.ptr);

        /* If directory has been requested, substitute index file */
        if (file[n - 1] == '/' && useindex (file, sizeof (file)) == -1) {
            senderr (c, 403, "Forbidden", "", "Directory Listing Denied");
            return;
        }

        dotdot (file);
        fixdirsep (file);

        if (strstr (file, htpass)) {
            senderr (c, 403, "Forbidden", "", "Permission Denied");
        } else if (stat (file, &st) != 0) {
            senderr (c, 404, "Not Found", "", "Not Found");
            elog (0, "handle: stat(%s): %s", file, strerror (ERRNO));
        } else if (st.st_mode & S_IFDIR) {
            elog (0, "handle: %s: Denied", file);
            senderr (c, 403, "Forbidden", "", "Directory listing denied");
        } else if (c->ims && c->ims >= st.st_mtime) {
            elog (0, "handle: %s: Not Modified", file);
            senderr (c, 304, "Not Modified", "", "");
#ifndef NO_CGI
        } else if (strstr (file, cgipat) != NULL) {
            if (spawncgi (c, file) < 0) {
                senderr (c, 500, "Server Error", "", "Error executing CGI script");
            }
            c->cgimode++;
#endif                          /* NO_CGI */
        } else if ((c->local.fdread = open (file, O_RDONLY)) != -1
#ifdef _WIN32
                   && (c->local.fdread = fdtosock (c->local.fdread, 1)) == -1
#endif                          /* _WIN32 */
            ) {
            sendheaders (c);
            elog (0, "handle: fdread %d", c->local.fdread);
        } else if (c->local.fdread == -1) {
            elog (0, "handle: error opening [%s]", file);
            senderr (c, 404, "Not Found", "", "File Not Found");
        }
    }
}

/*
 * Perform SSL handshake
 */
static void handshake (struct conn *c) {
    int n;

    assert (c->remote.ssl != NULL);
    assert (c->sslaccepted == 0);

    if ((n = SSL_accept (c->remote.ssl)) == 0) {
        n = SSL_get_error (c->remote.ssl, n);
        if (n != SSL_ERROR_WANT_READ && n != SSL_ERROR_WANT_WRITE)
            closeiobuf (&c->remote);
        elog (0, "handshake: SSL_accept: %d", n);
    } else {
        elog (0, "handshake: SSL accepted");
        c->sslaccepted = 1;
    }
}

/*
 * Read incoming data
 */
static int pull (struct iobuf *io) {
    int n, buflen;

    buflen = sizeof (io->buf) - io->nread;  /* Bytes left in buffer */
    assert (io->fdread != -1);
    assert (buflen > 0);
    errno = 0;

    if (io->ssl)
        n = SSL_read (io->ssl, io->buf + io->nread, buflen);
    else
        n = PULL (io->fdread, io->buf + io->nread, buflen);
#if 1
    elog (0, "pull: %d.%p: %d read (%d)", io->fdread, io->ssl, n, ERRNO);
#endif

    if (n <= 0 && ERRNO != EWOULDBLOCK) {
        closeiobuf (io);
    } else if (n > 0) {
        io->nread += n;
    }

    return (n);
}

/*
 * Accept new connection
 */
static void Accept (int lsn) {
    struct conn *c;
    struct sa sa;
    SSL *ssl = NULL;
    int sock;

    sa.len = sizeof (sa.u.sin);

    if ((sock = accept (lsn, &sa.u.sa, &sa.len)) == -1) {
        elog (0, "Accept: accept: %s", strerror (ERRNO));
    } else if (blockmode (sock, 0) != 0) {
        elog (0, "Accept: blockmode: %s", strerror (ERRNO));
        (void) close (sock);
    } else if (dossl && (ssl = SSL_new (ctx)) == NULL) {
        elog (0, "Accept: SSL_new: %s", strerror (ERRNO));
        (void) close (sock);
    } else if (dossl && SSL_set_fd (ssl, sock) == 0) {
        elog (0, "Accept: SSL_set_fd: %s", strerror (ERRNO));
        (void) close (sock);
        SSL_free (ssl);
    } else if ((c = calloc (1, sizeof (*c))) == NULL) {
        (void) close (sock);
        elog (0, "Accept: calloc: %s", strerror (ERRNO));
    } else {
        LL_TAIL (&conns, &c->link);
        c->sa = sa;
        c->remote.ssl = ssl;
        c->remote.fdread = c->remote.fdwrite = sock;
        c->local.fdread = c->local.fdwrite = -1;
        c->expire = now + ttl;
        elog (0, "client connected.");

        if (ssl)
            handshake (c);
    }
}

static void disconnect (struct conn *c) {
    if (c->cgimode && !c->gotreply && c->local.nread > 0) {
        senderr (c, 500, "Server Error", "", "Premature end of script headers");
    }

    elog (0, "disconnect.");
    closeconn (c);
    LL_DEL (&c->link);
    free (c);
}

int main (int argc, char *argv[]) {
    int i, lsn, fd;
    const char *optarg, *errfile = NULL;

#ifdef _WIN32
    /* Standard microsoft crap */
    {
        WSADATA data;
        WSAStartup (MAKEWORD (2, 2), &data);
    }
#endif                          /* _WIN32 */

    /* Parse command-line options */
#define GETARG(p)                                               \
    if ((p = (argv[i][2] ? &argv[i][2] : argv[++i])) == NULL)   \
        usage(argv[0])

    for (i = 1; i < argc && argv[i][0] == '-'; i++)
        switch (argv[i][1]) {

        case 'd':              /* Document root */
            GETARG (optarg);
            docroot = optarg;
            break;

        case 'p':              /* Listening port */
            GETARG (optarg);
            lport = (uint16_t) atoi (optarg);
            break;

        case 'l':              /* Log file */
            GETARG (optarg);
            logfile = optarg;
            break;

        case 'i':              /* Index file */
            GETARG (optarg);
            ifile = optarg;
            break;

        case 'P':              /* Passwords file */
            GETARG (optarg);
            globhtpass = optarg;
            break;

        case 'c':              /* CGI pattern */
            GETARG (optarg);
            cgipat = optarg;
            break;

        case 'S':              /* SSL mode */
            dossl++;
            lport = 443;
            break;

        case 's':              /* Certificate */
            GETARG (optarg);
            certfile = optarg;
            break;

        case 'u':              /* Runtime UID */
            GETARG (optarg);
            uid = atoi (optarg);
            break;

        case 'e':              /* Error file */
            GETARG (optarg);
            errfile = optarg;
            break;

        default:
            usage (argv[0]);
            break;
        }

    now = time (0);

    (void) signal (SIGTERM, sigterm);
    (void) signal (SIGINT, sigterm);
    (void) signal (SIGCHLD, sigchild);
    (void) signal (SIGPIPE, SIG_IGN);

    lsn = Listen (lport);

    /* Go to alternate UID */
    if (uid > 0 && setuid (uid) == -1)
        elog (1, "main: setuid(%d): %s", uid, strerror (errno));

    if (dossl) {
        SSL_load_error_strings ();
        SSLeay_add_ssl_algorithms ();
        if ((ctx = SSL_CTX_new (SSLv23_server_method ())) == NULL)
            elog (1, "main: error: SSL_CTX_new %p", ctx);
        else if (SSL_CTX_use_certificate_file (ctx, certfile, SSL_FILETYPE_PEM) == 0)
            elog (1, "main: please put %s here", certfile);
        else if (SSL_CTX_use_PrivateKey_file (ctx, certfile, SSL_FILETYPE_PEM) == 0)
            elog (1, "main: please put %s here", certfile);
    }

    (void) printf ("shttpd version %s (%s) started on port %d\n", VERSION, dossl ? "with SSL" : "no SSL", lport);

    if (errfile) {
        /* Redirect stderr to a file */
        if ((fd = open (errfile, O_WRONLY | O_APPEND | O_CREAT, 0666)) == -1)
            elog (1, "open(%s): %s", errfile, strerror (errno));

        dup2 (fd, 2);
        (void) close (fd);
    }

    while (quit == 0) {
        struct llhead *lp, *tmp;
        struct conn *c;
        int n, maxfd = lsn;
        fd_set rset, wset;

        /* Prepare file descriptors */
        FD_ZERO (&rset);
        FD_ZERO (&wset);

        FD_SET (lsn, &rset);
        // for (lp = (&conns)->next; lp != (&conns); lp = (lp)->next)
        LL_FOREACH (&conns, lp) {
            // c = ( (struct conn *) ( (char *)(lp) - (unsigned long) (&( (struct conn *) 0)->link))
            c = LL_ENTRY (lp, struct conn, link);
            assert (c->remote.fdread != -1);

#define ADDREAD(io)                                                 \
do {                                                                \
    if ((io)->fdread != -1 &&                                       \
        (io)->nread < (int) sizeof((io)->buf)) {                    \
        FD_SET((io)->fdread, &rset);                                \
        if ((io)->fdread > maxfd)                                   \
            maxfd = (io)->fdread;                                   \
    }                                                               \
} while (0)

#define ADDWRITE(ior,iow)                                           \
do {                                                                \
    if ((iow)->fdwrite != -1 && (ior)->nwritten < (ior)->nread) {   \
        FD_SET((iow)->fdwrite, &wset);                              \
        if ((iow)->fdwrite > maxfd)                                 \
            maxfd = (iow)->fdwrite;                                 \
    }                                                               \
} while (0)

            ADDREAD (&c->remote);
            ADDREAD (&c->local);
            ADDWRITE (&c->remote, &c->local);
            if (!c->cgimode || (c->cgimode && c->gotreply))
                ADDWRITE (&c->local, &c->remote);
        }

        if (select (maxfd + 1, &rset, &wset, 0, 0) > 0) {

            now = time (0);

            /* Accept new connection */
            if (FD_ISSET (lsn, &rset))
                Accept (lsn);

            /* Loop through all connections, handle if needed */
            LL_FOREACH_SAFE (&conns, lp, tmp) {
                c = LL_ENTRY (lp, struct conn, link);

#define HASDATA(fd, set)    (fd != -1 && FD_ISSET(fd, set))

                if (HASDATA (c->remote.fdread, &rset)) {
                    n = 0;
                    if (c->remote.ssl && !c->sslaccepted) {
                        handshake (c);
                    } else if ((n = pull (&c->remote)) > 0) {
                        c->ntotal += n;
                        if (!c->gotrequest)
                            handle (c);
                        ADDWRITE (&c->remote, &c->local);
                    }
                    c->expire = now + ttl;
                }

                if (HASDATA (c->local.fdread, &rset)) {
                    pull (&c->local);
                    if (c->cgimode && !c->gotreply)
                        reply (c);
                    if (!c->cgimode || (c->cgimode && c->gotreply))
                        ADDWRITE (&c->local, &c->remote);
                    c->expire = now + ttl;
                }

                if (HASDATA (c->remote.fdwrite, &wset)) {
                    push (&c->local, &c->remote);
                }

                if (HASDATA (c->local.fdwrite, &wset)) {
                    push (&c->remote, &c->local);
                    if (c->ntotal == c->nexpected && c->remote.nread == c->remote.nwritten) {
                        (void) close (c->local.fdwrite);
                        c->local.fdwrite = -1;
                    }
                }

                if (c->remote.fdread == -1 || (c->gotrequest && c->local.fdread == -1)) {
                    disconnect (c);
                }
            }
        } else {
            elog (0, "select: %d, %s", ERRNO, strerror (ERRNO));
        }

        /* Handle timed out connections */
        LL_FOREACH_SAFE (&conns, lp, tmp) {
            c = LL_ENTRY (lp, struct conn, link);
            if (c->expire < now) {
                disconnect (c);
            }
        }
    }

    return (EXIT_SUCCESS);
}
