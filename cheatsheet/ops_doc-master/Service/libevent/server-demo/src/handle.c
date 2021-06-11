#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>

#include "handle.h"

int protocol_handle (int sfd) {
    int ret;
    char buf[1024];
    memset (buf, 0, 1024);
    ret = recv (sfd, buf, 1023, 0);
    if (ret <= 0)
        return -1;
    printf ("sfd = %d, recv = %d: %s\n", sfd, ret, buf);
    send (sfd, "world", 5, 0);
    return 0;
}
