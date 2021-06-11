#ifndef _KYLS_THREAD_H_
#define _KYLS_THREAD_H_
#include <stdlib.h>
#include <sys/socket.h>
#include <sys/types.h>

struct kyls_thread_t;

struct kyls_thread_t *kyls_thread_create (void (*sf_addr) (void *), void *sf_arg);

// not implemented yet
int kyls_thread_kill (struct kyls_thread_t *t);

void kyls_thread_yield ();
int kyls_thread_init ();
void kyls_thread_sched ();
void kyls_thread_destroy ();
int kyls_thread_self ();

int kyls_socket (int domain, int type, int protocol);
#define kyls_bind bind
#define kyls_listen listen
#define kyls_close close
void kyls_sleep_ms (unsigned int seconds);
ssize_t kyls_read (int fd, void *buf, size_t n, int timeout_ms);
ssize_t kyls_write (int fd, void *buf, size_t n, int timeout_ms);
int kyls_accept (int fd, struct sockaddr *address, socklen_t * address_len, int timeout_ms);

#endif
