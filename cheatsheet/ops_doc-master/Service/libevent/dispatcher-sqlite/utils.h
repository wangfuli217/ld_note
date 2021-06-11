#ifndef __UTILS_H__
#define __UTILS_H__

#include <stdint.h>
#include <stddef.h>

#ifndef __cplusplus
typedef int bool;
#define true  1
#define false 0
#endif

struct cUrl_response_t {
    char *content;
    int length;
};

int listen_s0 (int port, uint32_t addr, int backlog);
int listen_s1 (uint16_t port);
int blockmode (int fd, int block);
void *s_malloc (size_t sz);
void *s_calloc (size_t num, size_t sz);
void *s_realloc (void *p, size_t old_sz, size_t new_sz);
void s_free (void *p, size_t sz);
void http_get (const char *url, struct cUrl_response_t *content);
void http_post (const char *url, char *post_field, int len, struct cUrl_response_t *content);

#endif
