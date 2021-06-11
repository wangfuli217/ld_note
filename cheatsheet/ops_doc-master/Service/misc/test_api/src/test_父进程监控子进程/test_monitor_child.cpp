#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

void error_exit(const char* msg) {
    printf("NG: %s\n", msg);
    exit(-1);
}

void success_exit(const char* msg) {
    printf("OK: %s\n", msg);
    exit(0);
}

void print_wait_status(const char* msg, int status) {
    if (msg != NULL)
        printf("%s\n", msg);

    if (WIFEXITED(status)) {
        printf("child exited: status=%d.\n", WEXITSTATUS(status));
    } else if (WIFSIGNALED(status)) {
        printf("child killed by signal: %d\n", WTERMSIG(status));
    } else if (WIFSTOPPED(status)) {
        printf("child stopped by signal: %d\n", WSTOPSIG(status));
    } else if (WIFCONTINUED(status)) {
        printf("child continued.\n");
    } else {
        printf("unknow status.\n");
    }
}

int main(int argc, char* argv[]) {
    int status;
    pid_t child_pid;

    switch (fork()) {
    case -1:
        error_exit("fork failed!");
    case 0:
        printf("child:started with pid=%d.\n", getpid());
        if (argc == 3)
        {
            strcpy(0, "heloworld");//
        }
        else if (argc == 2) /* exit with the arg supplied on command line. */
            exit(atoi(argv[1]));
        else
            /* wait for signal, until get kill signal. */
            for (;;)
                pause();

        error_exit("nerver be here.");
    default:
        for (;;) { /* check child's status until child exit. */
            child_pid = waitpid(-1, &status, WUNTRACED | WCONTINUED);
            if (child_pid == -1)
                error_exit("waitpid failed!");
            printf("father:waitpid returned,child_pid=%ld,status=0x%04x (%d,%d).\n",
                    (long) child_pid, (unsigned int) status, status >> 8,
                    status & 0xff);
            print_wait_status(NULL, status);
            if (WIFEXITED(status) || WIFSIGNALED(status))
                success_exit("child has exited");
        }
    }

    return 0;
}

