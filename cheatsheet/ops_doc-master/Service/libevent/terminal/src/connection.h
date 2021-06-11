#ifndef CONNECTION_H
#define CONNECTION_H

#include <event.h>
#include <sys/time.h>
#include <stdlib.h>

extern struct status stats;
extern conn **freeconns;

//total free connection
extern int freetotal;

//current free connection
extern int freecurr;

conn *conn_new(int sfd, int init_state, int event_flags, struct event_base *base);

void conn_close(conn *c);

void conn_init();
#endif //CONNECTION_H
