#include <pthread.h>
#include "terminal_define.h"
#include "connection.h"
#include "network.h"
void conn_init(){
    freetotal = 200;
    freecurr = 0;
    freeconns = (conn **)malloc(sizeof (conn *)*freetotal);
    return;
}

conn *conn_new(int sfd, int init_state, int event_flags, struct event_base *base) {
    conn *c;
    if (freecurr > 0) {
        c = freeconns[--freecurr];
    } else {
        if (!(c = (conn *)malloc(sizeof(conn)))) {
            perror("malloc(conn)");
            return NULL;
        }

        c->rbuf = c->wbuf = 0;
        c->rbuf = (char *) malloc(DATA_BUFFER_SIZE);
        c->wbuf = (char *) malloc(DATA_BUFFER_SIZE);

        if (c->rbuf == 0 || c->wbuf == 0) {
            if (c->rbuf != 0) free(c->rbuf);
            if (c->wbuf != 0) free(c->wbuf);
            free(c);
            perror("malloc()");
            return NULL;
        }
        c->rsize = c->wsize = DATA_BUFFER_SIZE;
        c->rcurr = c->rbuf;

        STATS_LOCK(stats);
        stats.conn_structs++;
        STATS_UNLOCK(stats);
    }

    if (settings.verbose > 1) {
        if (init_state == conn_listening)
            fprintf(stderr, "<%d server listening\n", sfd);
        else
            fprintf(stderr, "<%d new client connection\n", sfd);
    }

    c->sfd = sfd;
    c->state = init_state;
    c->rbytes = c->wbytes = 0;
    c->wcurr = c->wbuf;
    c->write_and_go = conn_read;
    event_set(&c->event, sfd, event_flags, event_handler, (void *)c);
    event_base_set(base, &c->event);
    c->ev_flags = event_flags;
    if (event_add(&c->event, 0) == -1) {
        if (freecurr < freetotal) {
            freeconns[freecurr++] = c;
        } else {
            free (c->rbuf);
            free (c->wbuf);
            free (c);

            STATS_LOCK(stats);
            stats.conn_structs--;
            STATS_UNLOCK(stats);
        }
        return NULL;
    }

    STATS_LOCK(stats);
    stats.curr_conns++;
    STATS_UNLOCK(stats);
    return c;
}

void conn_close(conn *c) {
    event_del(&c->event);

    if (settings.verbose > 1)
        fprintf(stderr, "<%d connection closed.\n", c->sfd);

    close(c->sfd);

    if (freecurr < freetotal) {
        freeconns[freecurr++] = c;
    } else {
        conn **new_freeconns = realloc(freeconns, sizeof(conn *)*freetotal*2);
        if (new_freeconns) {
            freetotal *= 2;
            freeconns = new_freeconns;
            freeconns[freecurr++] = c;
        } else {
            if (settings.verbose > 0)
                fprintf(stderr, "Couldn't realloc freeconns\n");
            free(c->rbuf);
            free(c->wbuf);
            free(c);

            STATS_LOCK(stats);
            stats.conn_structs--;
            STATS_UNLOCK(stats);
        }
    }

    STATS_LOCK(stats);
    stats.curr_conns--;
    STATS_UNLOCK(stats);
}
