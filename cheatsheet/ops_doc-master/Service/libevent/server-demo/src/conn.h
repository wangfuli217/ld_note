#ifndef __CONN_H__
#define __CONN_H__

#include <event.h>
#include <pthread.h>

#include "settings.h"

extern int max_fds;
extern struct settings settings;
extern struct event_base *main_base;

enum conn_states {
    conn_listening,  /**< the socket which listens for connections */
    conn_new_cmd,    /**< Prepare connection for next command */
    conn_waiting,    /**< waiting for a readable socket */
    conn_read,       /**< reading in a command line */
    conn_parse_cmd,  /**< try to parse a command from the input buffer */
    conn_write,      /**< writing out a simple response */
    conn_nread,      /**< reading in a fixed number of bytes */
    conn_swallow,    /**< swallowing unnecessary bytes w/o storing */
    conn_closing,    /**< closing this connection */
    conn_mwrite,     /**< writing out many items sequentially */
    conn_closed,     /**< connection is closed */
    conn_watch,      /**< held by the logger thread as a watcher */
    conn_max_state   /**< Max state value (used for assertion) */
};

typedef struct {
    pthread_t thread_id;        /* unique ID of this thread */
    struct event_base *base;    /* libevent handle this thread uses */
    struct event notify_event;  /* listen event for notify pipe */
    int notify_recv_fd;         /* receiving end of notify pipe */
    int notify_send_fd;         /* sending end of notify pipe */
    //struct thread_stats stats;  /* Stats generated by this thread */
    struct conn_queue *conn_queue;  /* queue of new connections to handle */
    //cache_t *suffix_cache;      /* suffix cache */
    //logger *l;                  /* logger buffer */
    //void *lru_bump_buf;         /* async LRU bump buffer */
} WORKER_THREAD;

typedef struct conn conn;
struct conn {
    int sfd;
    enum conn_states state;
    //Buffer *buf;
    struct event_base *ev_base;
    struct event event;
    short ev_flags;
    short which;
    //ProtocolHandle *handler;
    WORKER_THREAD *thread;
};

void conn_init (void);
int socket_init (int port);
conn *conn_new (const int sfd, enum conn_states init_status, const int event_flags, struct event_base *base);
#endif
