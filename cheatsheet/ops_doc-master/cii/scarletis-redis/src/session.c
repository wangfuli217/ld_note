#include "session.h"

#include <stdio.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <string.h>

#include "def.h"
#include "log.h"
#include "cmd.h"

int Session(int conn_fd, int bytes) {
    char buff[BUFF_LEN];
    size_t length = 0;

    bzero(buff, sizeof(buff));
    if ( (length = recv(conn_fd, buff, bytes, 0)) < 0)
        s_err("recv data");

    if (buff[length - 1] == '\n') buff[--length] = '\0';
    if (buff[length - 1] == '\r') buff[--length] = '\0';

    s_log("MSG");
    s_prt(buff, length);
    putchar('\n');

    s_cmd(conn_fd, buff);

    return 0;
}
