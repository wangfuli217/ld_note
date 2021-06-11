static volatile sig_atomic_t got_SIGCHLD = 0;

static void
child_sig_handler(int sig)
{
    got_SIGCHLD = 1;
}

int
main(int argc, char *argv[])
{
    sigset_t sigmask, empty_mask;
    struct sigaction sa;
    fd_set readfds, writefds, exceptfds;
    int r;

    sigemptyset(&sigmask);
    sigaddset(&sigmask, SIGCHLD);
    if (sigprocmask(SIG_BLOCK, &sigmask, NULL) == -1) {
        perror("sigprocmask");
        exit(EXIT_FAILURE);
    }

    sa.sa_flags = 0;
    sa.sa_handler = child_sig_handler;
    sigemptyset(&sa.sa_mask);
    if (sigaction(SIGCHLD, &sa, NULL) == -1) {
        perror("sigaction");
        exit(EXIT_FAILURE);
    }

    sigemptyset(&empty_mask);


    for (;;) {          /* main loop */
        /* Initialize readfds, writefds, and exceptfds
           before the pselect() call. (Code omitted.) */

        r = pselect(nfds, &readfds, &writefds, &exceptfds,
                    NULL, &empty_mask);
        if (r == -1 && errno != EINTR) {
            /* Handle error */
        }

        if (got_SIGCHLD) {
            got_SIGCHLD = 0;

            /* Handle signalled event here; e.g., wait() for all
               terminated children. (Code omitted.) */
        }

        /* main body of program */
    }
}