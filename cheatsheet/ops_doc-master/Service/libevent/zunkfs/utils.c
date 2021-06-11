
#define _GNU_SOURCE

#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <errno.h>
#include <sys/mman.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/file.h>
#include <fcntl.h>

#include "utils.h"
#include "mutex.h"

FILE *zunkfs_log_fp = NULL;
char zunkfs_log_level = 0;

int set_logging (const char *params) {
    if (zunkfs_log_fp)
        return -EALREADY;

    if (params[1] == ',') {
        switch (params[0]) {
        case 'E':
            zunkfs_log_level = ZUNKFS_ERROR;
            break;
        case 'W':
            zunkfs_log_level = ZUNKFS_WARNING;
            break;
        case 'T':
            zunkfs_log_level = ZUNKFS_TRACE;
            break;
        default:
            return -EINVAL;
        }
        params += 2;
    }
    if (!strcmp (params, "stderr"))
        zunkfs_log_fp = stderr;
    else if (!strcmp (params, "stdout"))
        zunkfs_log_fp = stdout;
    else
        zunkfs_log_fp = fopen (params, "w");

    return zunkfs_log_fp ? 0 : -errno;
}

int dup_log_fd (int to) {
    if (zunkfs_log_fp && dup2 (fileno (zunkfs_log_fp), to))
        return -errno;
    return 0;
}

void __zprintf (char level, const char *function, int line, const char *fmt, ...) {
    const char *level_str = NULL;
    va_list ap;

    if (level == ZUNKFS_WARNING)
        level_str = "WARN: ";
    else if (level == ZUNKFS_ERROR)
        level_str = "ERR:  ";
    else if (level == ZUNKFS_TRACE)
        level_str = "TRACE:";
    else
        abort ();

    flock (fileno (zunkfs_log_fp), LOCK_EX);
    if (zunkfs_log_fp == stderr)
        fflush (stdout);
    fprintf (zunkfs_log_fp, "%lx %s %s:%d: ", ((unsigned long) pthread_self ()) >> 8, level_str, function, line);

    va_start (ap, fmt);
    vfprintf (zunkfs_log_fp, fmt, ap);
    va_end (ap);

    fflush (zunkfs_log_fp);

    flock (fileno (zunkfs_log_fp), LOCK_UN);
}

void *const __errptr;

static void __attribute__ ((constructor)) util_init (void) {
    void *errptr = mmap (NULL, (MAX_ERRNO + 4095) & ~4095, PROT_NONE,
                         MAP_PRIVATE | MAP_ANON, -1, 0);
    if (errptr == MAP_FAILED) {
        fprintf (stderr, "errptr: %s\n", strerror (errno));
        exit (-1);
    }
    memcpy ((void *) &__errptr, &errptr, sizeof (void *));
}

size_t __attribute__ ((weak)) strnlen (const char *str, size_t max) {
    size_t len;
    for (len = 0; len < max && str[len]; len++) ;
    return len;
}

int __attribute__ ((weak)) fls (int i) {
    int j = 0;
    while (i) {
        i >>= 1;
        j++;
    }
    return j;
}

static int __sranddev (const char *dev) {
    unsigned seed;
    int fd;
    ssize_t n;

    fd = open (dev, O_RDONLY);
    if (fd < 0)
        return -errno;

    n = read (fd, &seed, sizeof (unsigned));
    if (n < 0) {
        int error = -errno;
        close (fd);
        return error;
    }

    srand (seed);
    close (fd);
    return 0;
}

void __attribute__ ((weak)) sranddev (void) {
    struct timeval tv;

    if (!__sranddev ("/dev/urandom"))
        return;
    if (!__sranddev ("/dev/random"))
        return;

    gettimeofday (&tv, NULL);
    srand (tv.tv_usec);
}

int __attribute__ ((weak)) posix_madvise (void *ptr, size_t len, int advice) {
    return 0;
}

int __attribute__ ((weak)) posix_fadvise (int fd, off_t offset, off_t len, int advice) {
    return 0;
}

struct sockaddr_in *__string_sockaddr_in (const char *str, struct sockaddr_in *sa) {
    char *addr_str;
    char *port;

    assert (sa != NULL);
    assert (str != NULL);

    memset (sa, 0, sizeof (struct sockaddr_in));

    addr_str = alloca (strlen (str) + 1);
    if (!addr_str)
        return NULL;

    strcpy (addr_str, str);

    port = strchr (addr_str, ':');
    if (!port)
        return NULL;

    *port++ = 0;

    sa->sin_family = AF_INET;
    sa->sin_port = htons (atoi (port));
    sa->sin_addr.s_addr = INADDR_ANY;

    if (*addr_str && !inet_aton (addr_str, &sa->sin_addr))
        return NULL;

    return sa;
}

char *sprintf_new (const char *fmt, ...) {
    va_list ap;
    char *str, dummy[1];
    int len;

    va_start (ap, fmt);
    len = vsnprintf (dummy, 1, fmt, ap);
    va_end (ap);

    str = malloc (len + 1);
    if (!str)
        return "no memory";

    va_start (ap, fmt);
    vsprintf (str, fmt, ap);
    va_end (ap);

    return str;
}
