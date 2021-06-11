#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>

#include <event.h>

void fifo_read (int fd, short events, void *arg) {
    struct event *ev = arg;
    char buf[255] = { 0 };

    event_add (ev, NULL);

    printf ("fifo_read called\n");

    int len = read (fd, buf, sizeof (buf - 1));

    if (len == -1) {
        printf ("read\n");
        return;
    } else if (len == 0) {
        printf ("connection closed\n");
        return;
    }

    buf[len] = '\0';
    printf ("read: %s\n", buf);
}

int main (void) {
    struct event evfifo;
    struct stat st;

    char *fifo = "event.fifo";

    if (lstat (fifo, &st) == 0) {
        if ((st.st_mode & S_IFMT) == S_IFREG) {
            printf ("lsata");
            exit (1);
        }
    }
    unlink (fifo);

    if (mkfifo (fifo, 0600) == -1) {
        printf ("mkfifo");
        exit (1);
    }

    int socket;
    socket = open (fifo, O_RDWR | O_NONBLOCK, 0);
    printf ("fifo fd:[%d]\n", socket);

    if (socket == -1) {
        printf ("open");
        exit (1);
    }

    event_init ();

    /*printf("base info: evsel[%p], evbase[%p], evcount[%d], evacount[%d], activequeue[%p], evqueue[%p]\n",
     * base->evsel,
     * base->evbase,
     * base->event_count,
     * base->event_count_active,
     * base->activequeues,
     * base->eventquque); */

    event_set (&evfifo, socket, EVENT_READ, fifo_read, &evfifo);
    event_add (&evfifo, NULL);
    event_dispatch ();

    return 0;
}
