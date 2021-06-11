#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include "daemonize.h"

void daemonize (void) {
    int fd;

    if (fork () != 0)
        exit (0);

    setsid ();

    if ((fd = open ("/dev/null", O_RDWR, 0)) != -1) {
        dup2 (fd, STDIN_FILENO);
        dup2 (fd, STDOUT_FILENO);
        dup2 (fd, STDERR_FILENO);
        if (fd > STDERR_FILENO)
            close (fd);
    }
}
