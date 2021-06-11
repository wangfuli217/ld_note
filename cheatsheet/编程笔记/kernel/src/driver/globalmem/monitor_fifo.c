/*
 * =====================================================================================
 *
 *       Filename:  monitor_fifo.c
 *
 *    Description:  
 *
 *        Created:  05.12.10
 *       Revision:  
 *       Compiler:  GCC 4.4
 *
 *         Author:  Yang Zhang, treblih.divad@gmail.com
 *        Company:  
 *
 * =====================================================================================
 */

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <sys/select.h>     /* fd */
#include <stdio.h>

#define FIFO_CLEAR  1

int main(int argc, const char *argv[])
{
    int fd;
    fd_set rfds, wfds;

    fd = open("/dev/globalfifo", O_RDONLY | O_NONBLOCK);
    if (fd != -1) {
        if (ioctl(fd, FIFO_CLEAR, 0) < 0)
            puts("ioctl cmd failed");
        while (1) {
            FD_ZERO(&rfds);     FD_ZERO(&wfds);
            FD_SET(fd, &rfds);  FD_SET(fd, &wfds);
            select(fd + 1, &rfds, &wfds, NULL, NULL);
            if (FD_ISSET(fd, &rfds))
                puts("poll monitor: can be read");
            if (FD_ISSET(fd, &wfds))
                puts("poll monitor: can be written");
        }
    } else puts("device open failed");
    return 0;
}
