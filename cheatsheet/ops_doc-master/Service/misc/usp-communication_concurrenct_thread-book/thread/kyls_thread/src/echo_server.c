#include "kyls_thread.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <strings.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>

static struct kyls_thread_t *server_thread;
static int terminate = 0;

void conn_proc (void *arg) {
    char str[100];
    int fd = *(int *) arg;

    while (1) {
        int k = kyls_read (fd, str, 100, 0);

        if (k == 0) {
            close (k);
            break;
        } else if (k < 0)
            continue;

        str[k] = '\0';
        if (strcmp (str, "bye\r\n") == 0)
            terminate = 1;

        kyls_sleep_ms (1000);
        kyls_write (fd, str, strlen (str) + 1, 0);
    }
    printf ("client thread on fd %d exited\n", fd);
}

void server_proc (void *arg) {
    int listen_fd;

    struct sockaddr_in servaddr;

    listen_fd = kyls_socket (AF_INET, SOCK_STREAM, 0);

    bzero (&servaddr, sizeof (servaddr));

    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = htons (INADDR_ANY);
    servaddr.sin_port = htons (*(int *) arg);

    int so_reuseaddr = 1;
    setsockopt (listen_fd, SOL_SOCKET, SO_REUSEADDR, &so_reuseaddr, sizeof so_reuseaddr);
    kyls_bind (listen_fd, (struct sockaddr *) &servaddr, sizeof (servaddr));

    kyls_listen (listen_fd, 10);

    while (!terminate) {
        int comm_fd = kyls_accept (listen_fd, (struct sockaddr *) NULL, NULL, 1000);
        if (comm_fd < 0)
            continue;

        int *fd = (int *) malloc (sizeof (*fd));
        *fd = comm_fd;
        kyls_thread_create (conn_proc, (void *) fd);
    }
    printf ("server thread exited\n");
}

int main () {
    int port = 8964;
    kyls_thread_init ();
    server_thread = kyls_thread_create (server_proc, &port);
    kyls_thread_sched ();
    printf ("All thread termintated\n");
    kyls_thread_destroy ();
    return 0;
}
