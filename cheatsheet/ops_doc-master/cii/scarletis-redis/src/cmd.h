#ifndef CMD_H
#define CMD_H

#include "def.h"
#include "list.h"

struct cmd {
    const char *name;
    int (*oper)(int conn_fd, list_t *paras);
};

int s_cmd(int conn_fd, char buff[BUFF_LEN]);

#endif
