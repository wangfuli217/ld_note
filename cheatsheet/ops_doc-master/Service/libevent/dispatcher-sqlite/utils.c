#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <curl/curl.h>
#include "utils.h"
#include "debug.h"
#include "platform.h"

int listen_s0 (int port, uint32_t addr, int backlog) {
    int fd, sz = 1;
    struct sockaddr_in sin;

    if ((fd = socket (PF_INET, SOCK_STREAM, 0)) < 0) {
        return -1;
    }

    blockmode (fd, 0);
    setsockopt (fd, SOL_SOCKET, SO_REUSEADDR, (char *) &sz, sizeof (sz));

    sin.sin_family = AF_INET;
    sin.sin_port = htons (port);
    sin.sin_addr.s_addr = htonl (addr);

    if (bind (fd, (struct sockaddr *) &sin, sizeof (sin)) < 0) {
        return -1;
    }
    if (listen (fd, backlog) < 0) {
        return -1;
    }

    return fd;
}

int listen_s1 (uint16_t port) {
    int sock, on = 1, af;

    struct {
        socklen_t len;
        union {
            struct sockaddr sa;
            struct sockaddr_in sin;
        } u;
#ifdef WITH_IPV6
        struct sockaddr_in6 sin6;
#endif                          /* WITH_IPV6 */
    } sa;

#ifdef WITH_IPV6
    af = PF_INET6;
#else
    af = PF_INET;
#endif
    if ((sock = socket (af, SOCK_STREAM, 6)) == -1) {
        ph_log_err ("Listen: socket: %s", strerror (ERRNO));
    }

    blockmode (sock, 0);
    setsockopt (sock, SOL_SOCKET, SO_REUSEADDR, (char *) &on, sizeof (on));

#ifdef WITH_IPV6
    sa.u.sin.sin6_family = af;
    sa.u.sin.sin6_port = htons (port);
    sa.u.sin.sin6_addr = in6addr_any;
    sa.len = sizeof (sa.u.sin6);
#else
    sa.u.sin.sin_family = af;
    sa.u.sin.sin_port = htons (port);
    sa.u.sin.sin_addr.s_addr = INADDR_ANY;
    sa.len = sizeof (sa.u.sin);
#endif

    if (bind (sock, &sa.u.sa, sa.len) < 0) {
        ph_log_err ("listening: af %d bind(%d):%s", af, port, strerror (ERRNO));
    }

    (void) listen (sock, 16);

    return sock;
}

int blockmode (int fd, int block) {
#ifdef _WIN32
    unsigned long on = !block;

    return ioctlsocket (fd, FIONBIO, &on);
#else
    int flags;

    if ((flags = fcntl (fd, F_GETFL, 0)) == -1) {
        ph_log_err ("nonblock: fcntl(%d, F_GETFL): %s", fd, strerror (ERRNO));
        return -1;
    }

    if (block) {
        flags &= ~O_NONBLOCK;
    } else {
        flags |= O_NONBLOCK;
    }

    if (fcntl (fd, F_SETFL, flags) != 0) {
        ph_debug ("nonblock: fcntl(%d, F_SETFL): %s", fd, strerror (ERRNO));
        return -1;
    }

    return 0;
#endif
}

void *s_malloc (size_t sz) {
#ifdef _WIN32
    return NULL;
#else
    void *mem = mmap (NULL,
                      sz,
                      PROT_READ | PROT_WRITE,
                      MAP_ANON | MAP_SHARED,
                      0,
                      0);
    if (mem < 0) {
        ph_log_err ("mmap error: mmap(...,%d,...):%s", sz, strerror (ERRNO));
    }
    return mem;
#endif
}

void *s_calloc (size_t num, size_t sz) {
#ifdef _WIN32
    return NULL;
#else
    void *p;
    int p_sz = num * sz;

    p = s_malloc (p_sz);
    if (p == NULL) {
        return NULL;
    }

    memset (p, 0, p_sz);
    return p;
#endif
}

void *s_realloc (void *p, size_t old_sz, size_t new_sz) {
#ifdef _WIN32
    return NULL;
#else
    void *newp;
    newp = s_malloc (new_sz);
    if (newp == NULL) {
        return NULL;
    }

    memcpy (newp, p, new_sz);
    s_free (p, old_sz);

    return newp;
#endif
}

void s_free (void *p, size_t sz) {
#ifdef _WIN32
    return;
#else
    if (munmap (p, sz) < 0) {
        ph_debug ("error: munmap(%x,%d):%s", p, sz, strerror (ERRNO));
    }
#endif
}

static size_t read_cb (char *ptr, size_t size, size_t nmemb, void *stream) {
    struct cUrl_response_t *buf = (struct cUrl_response_t *) stream;
    int block = size * nmemb;

    if (!buf) {
        return block;
    }

    if (buf->content == NULL) {
        buf->content = (char *) malloc (block);
    } else {
        buf->content = (char *) realloc (buf->content, buf->length + block);
    }

    if (buf->content == NULL) {
        return block;
    }

    memcpy (buf->content + buf->length, ptr, block);
    buf->length += block;

    return block;
}

void http_get (const char *url, struct cUrl_response_t *content) {
    CURL *curl = NULL;
    CURLcode rcode;
    struct curl_slist *headers = NULL;

    rcode = curl_global_init (CURL_GLOBAL_ALL);

    if (rcode != CURLE_OK) {
        ph_debug ("curl blobal init error: %s", curl_easy_strerror (rcode));
        return;
    }

    curl = curl_easy_init ();

    if (curl == NULL) {
        curl_global_cleanup ();
        return;
    }

    curl_easy_setopt (curl, CURLOPT_HTTPHEADER, headers);
    curl_easy_setopt (curl, CURLOPT_URL, url);
    curl_easy_setopt (curl, CURLOPT_WRITEFUNCTION, read_cb);
    curl_easy_setopt (curl, CURLOPT_WRITEDATA, content);

    rcode = curl_easy_perform (curl);

    if (rcode != CURLE_OK) {
        ph_debug ("curl request failed. %s", curl_easy_strerror (rcode));
    }

    curl_easy_cleanup (curl);
    curl_global_cleanup ();
}

void http_post (const char *url, char *post_field, int len, struct cUrl_response_t *content) {
    CURL *curl = NULL;
    CURLcode rcode;
    struct curl_slist *headers = NULL;

    rcode = curl_global_init (CURL_GLOBAL_ALL);

    if (rcode != CURLE_OK) {
        ph_debug ("curl global init error: %s", curl_easy_strerror (rcode));
        return;
    }

    curl = curl_easy_init ();

    if (curl == NULL) {
        curl_global_cleanup ();
        return;
    }

    curl_easy_setopt (curl, CURLOPT_URL, url);
    curl_easy_setopt (curl, CURLOPT_POST, 1L);
    curl_easy_setopt (curl, CURLOPT_POSTFIELDS, post_field);
    curl_easy_setopt (curl, CURLOPT_POSTFIELDSIZE, len);
    curl_easy_setopt (curl, CURLOPT_WRITEFUNCTION, read_cb);
    curl_easy_setopt (curl, CURLOPT_WRITEDATA, content);

    rcode = curl_easy_perform (curl);

    if (rcode != CURLE_OK) {
        ph_debug ("curl request failed. %s", curl_easy_strerror (rcode));
    }

    curl_easy_cleanup (curl);
    curl_global_cleanup ();
}
