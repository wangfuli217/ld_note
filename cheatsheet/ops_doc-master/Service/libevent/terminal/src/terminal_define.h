#ifndef TERMINAL_DEFINE_H
#define TERMINAL_DEFINE_H
#include <unistd.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <event.h>
#include <errno.h>
#include <inttypes.h>

#define mytimesub(a, b, result)     do {            \
    (result)->tv_sec = (a)->tv_sec - (b)->tv_sec;       \
    (result)->tv_usec = (a)->tv_usec - (b)->tv_usec;    \
    if ((result)->tv_usec < 0) {                \
        --(result)->tv_sec;             \
        (result)->tv_usec += 1000000;           \
    }                           \
} while (0)

/**
 * Globally accessible settings as derived from the commandline.
 */
struct settings {
    int maxconns;               //max connection num
    int port;                   //listen port
    struct in_addr interf;      //listen ip addr
    int num_threads;            //num of worker thread
    int verbose;                //verbose
    int timeout;                //timeout setting
    int daemonize;              //for daemon
};

/**
 * Possible states of server.
*/
struct status {
    uint32_t curr_conns;
    uint32_t conn_structs;
    uint32_t get_cmds;
    uint32_t get_hits;
    uint32_t get_misses;
    time_t started;
    uint32_t timeouts;
    uint32_t ialloc_failed;
    pthread_mutex_t stats_lock;
};

//connection struct
typedef struct _conn {
    int sfd;
    int state;
    struct event event;
    short ev_flags;
    short which;   /* which events were just triggered */

    char *rbuf;    /* buffer to read commands into */
    char *rcurr;   /* but if we parsed some already, this is where we stopped */
    int rsize;     /* total allocated size of rbuf */
    int rbytes;    /* how much data, starting from rcur, do we have unparsed */

    char *wbuf;
    char *wcurr;
    int wsize;
    int wbytes;
    int write_and_go;

    char *cmd;
    struct timeval tv;
    struct _conn *next;
} conn;


enum conn_states {
    conn_listening,  /* the socket which listens for connections */
    conn_read,       /* reading in a command line */
    conn_write,      /* writing out a simple response */
    conn_closing,    /* closing this connection */
};

#define STATS_LOCK(status)    pthread_mutex_lock(&status.stats_lock);
#define STATS_UNLOCK(status)  pthread_mutex_unlock(&status.stats_lock);

#define DATA_BUFFER_SIZE 8192

#define FORWARD_OUT 1
#define STAY_IN  2

#define DEFAULT_PORT 9898
#define MAX_CONN_NUM 8192
#define DEFAULT_THREAD_NUM 4
#define VERSION "VERSION 1.0.0"

#endif //TERMINAL_DEFINE_H
