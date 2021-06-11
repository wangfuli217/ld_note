#include "cmd.h"

#include <sys/socket.h>
#include <string.h>
#include <ctype.h>

#include "def.h"
#include "log.h"
#include "list.h"
#include "cmds.h"
#include "param.h"

#define CMD_ADD(name) {#name, cmd_##name}

int cmd_nil(int conn_fd, list_t *para) {
    const char *nil = "Illegal command\r\n";
    if (send(conn_fd, nil, strlen(nil), 0) < 0)
        s_err("send");
    return 0;
}

const struct cmd cmd_table[] = {
    CMD_ADD(hello),
    CMD_ADD(bye),
    CMD_ADD(hash),
    CMD_ADD(shutdown),
    CMD_ADD(append),
    CMD_ADD(bitcount),
    CMD_ADD(brpop),
    CMD_ADD(brpoplpush),
    CMD_ADD(decr),
    CMD_ADD(decrby),
    CMD_ADD(del),
    CMD_ADD(exists),
    CMD_ADD(get),
    CMD_ADD(getbit),
    CMD_ADD(getrange),
    CMD_ADD(incr),
    CMD_ADD(incrby),
    CMD_ADD(keys),
    CMD_ADD(lindex),
    CMD_ADD(linsert),
    CMD_ADD(llen),
    CMD_ADD(lpop),
    CMD_ADD(lpush),
    CMD_ADD(lpushx),
    CMD_ADD(lrange),
    CMD_ADD(lrem),
    CMD_ADD(lset),
    CMD_ADD(ltrim),
    CMD_ADD(mget),
    CMD_ADD(msetnx),
    CMD_ADD(randomkey),
    CMD_ADD(rename),
    CMD_ADD(rpop),
    CMD_ADD(rpoplpush),
    CMD_ADD(rpush),
    CMD_ADD(rpushx),
    CMD_ADD(set),
    CMD_ADD(setbit),
    CMD_ADD(setrange),
    CMD_ADD(strlen),
    CMD_ADD(type),
    {NULL, cmd_nil}
};

int s_cmd(int conn_fd, char buff[BUFF_LEN]) {
    char name[BUFF_LEN];
    bzero(name, sizeof(name));
    size_t i = 0;
    for (i = 0; i != BUFF_LEN && isalpha(buff[i]); ++i)
        name[i] = buff[i];
    memmove(buff, buff + i, BUFF_LEN - i);

    const struct cmd *p = cmd_table;
    for (p = cmd_table; p->name; ++p)
        if (strcmp(p->name, name) == 0)
            break;

    S_LIST_HEAD(params);

    char *token = strtok(buff, " \t\r\n");
    while(token) {
        if (*token)
            param_add(&params, token);
        token = strtok(NULL, " \t\r\n");
    }

    int ret = p->oper(conn_fd, &params);
    param_free(&params);

    return ret;
}
