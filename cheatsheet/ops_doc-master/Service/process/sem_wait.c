#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <semaphore.h>
#include <time.h>
#include <assert.h>
#include <errno.h>
#include <signal.h>

sem_t sem;

#define handle_error(msg) \
    do { perror(msg); exit(EXIT_FAILURE); } while (0)

static void
handler(int sig)
{
    write(STDOUT_FILENO, "sem_post() from handler\n", 24);
    if (sem_post(&sem) == -1) {
        write(STDERR_FILENO, "sem_post() failed\n", 18);
        _exit(EXIT_FAILURE);
    }
}

int
main(int argc, char *argv[])
{
    struct sigaction sa;
    struct timespec ts;
    int s;

    if (argc != 3) {
        fprintf(stderr, "Usage: %s <alarm-secs> <wait-secs>\n",
                argv[0]);
        exit(EXIT_FAILURE);
    }

    if (sem_init(&sem, 0, 0) == -1)
        handle_error("sem_init");

    /* Establish SIGALRM handler; set alarm timer using argv[1] */

        handle_error("sem_init");

    /* Establish SIGALRM handler; set alarm timer using argv[1] */

    sa.sa_handler = handler;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;
    if (sigaction(SIGALRM, &sa, NULL) == -1)
        handle_error("sigaction");

    alarm(atoi(argv[1]));

    /* Calculate relative interval as current time plus
       number of seconds given argv[2] */

    if (clock_gettime(CLOCK_REALTIME, &ts) == -1)
        handle_error("clock_gettime");

    ts.tv_sec += atoi(argv[2]);

    printf("main() about to call sem_timedwait()\n");
    while ((s = sem_timedwait(&sem, &ts)) == -1 && errno == EINTR)
        continue;       /* Restart if interrupted by handler */

    /* Check what happened */

    if (s == -1) {
        if (errno == ETIMEDOUT)
            printf("sem_timedwait() timed out\n");
        else
            perror("sem_timedwait");
    } else
        printf("sem_timedwait() succeeded\n");

    exit((s == 0) ? EXIT_SUCCESS : EXIT_FAILURE);
}

/*
$ ./a.out 2 3
About to call sem_timedwait()
sem_post() from handler
sem_getvalue() from handler; value = 1
sem_timedwait() succeeded
$ ./a.out 2 1
About to call sem_timedwait()
sem_timedwait() timed out
*/