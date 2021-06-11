#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>
#include <string.h>
#include <event.h>

#include "parser.h"
#include "conn.h"
#include "thread.h"

#define SERVER_CONF "conf/server.conf"

struct event_base *main_base;
struct settings settings;
int max_fds;

static void sig_handler (const int sig) {
    printf ("Signal handled: %s.\n", strsignal (sig));
    exit (EXIT_SUCCESS);
}

static int sigignore (int sig) {
    struct sigaction sa = {.sa_handler = SIG_IGN,.sa_flags = 0 };

    if (sigemptyset (&sa.sa_mask) == -1 || sigaction (sig, &sa, 0) == -1) {
        return -1;
    }
    return 0;
}

int main (int argc, char *argv[]) {
    int fd;

    if (argc == 1) {
        fd = open (SERVER_CONF, O_RDONLY);
    } else if (argc == 2) {
        fd = open (argv[1], O_RDONLY);
    } else {
        printf ("USAGE: %s <conf>\n", argv[0]);
        exit (1);
    }
    if (fd < 0) {
        perror (argv[1]);
        exit (1);
    }
    dup2 (fd, 0);
    yyparse ();

    /* handle SIGINT and SIGTERM */
    signal (SIGINT, sig_handler);
    signal (SIGTERM, sig_handler);

    if (sigignore (SIGPIPE) == -1) {
        perror ("failed to ignore SIGPIPE; sigaction");
        exit (1);
    }

    /* set stderr non-buffering (for running under, say, daemontools) */
    setbuf (stderr, NULL);

    if (settings.daemonize) {
        /** TODO **/
    }

    /* initialize main thread libevent instance */
    main_base = event_init ();

    /* initialize other stuff */
    /** logger_init(); **/
    conn_init ();

    thread_init (settings.num_threads);

    if (socket_init (settings.port) == -1) {
        fprintf (stderr, "socket_init() error.\n");
        exit (1);
    }

    if (event_base_loop (main_base, 0) != 0) {
        fprintf (stderr, "event_base_loop() error.\n");
        exit (1);
    }

    return 0;
}
