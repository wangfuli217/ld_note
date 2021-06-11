#include "cmds.h"

#include <stdio.h>
#include <unistd.h>
#include <sys/socket.h>
#include <signal.h>
#include <string.h>
#include <ctype.h>

#include "def.h"
#include "log.h"
#include "param.h"
#include "hash.h"
#include "db.h"
#include "table.h"

enum s_errno {
    EARGNUM
};

void cmd_err(int conn_fd, const char *cmd, enum s_errno e) {
    char msg[BUFF_LEN];
    strcpy(msg, "ERR ");

    const char *content;
    switch (e) {
        case EARGNUM:
            content = "wrong number of arguments";
            break;
        default:
            content = "unkown error";
            break;
    }

    strcat(msg, content);

    strcat(msg, " for '");
    strcat(msg, cmd);
    strcat(msg, "' command\r\n");
    if (send(conn_fd, msg, strlen(msg), 0) < 0)
        s_err("send");
}

CMD_SIGN(hello) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "Greetings");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, ", ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, ".\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(bye) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "Bye.\r\n");
    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    close(conn_fd);
    s_log("Connection Terminated");
    return 0;
}

CMD_SIGN(shutdown) {
    raise(SIGQUIT);
    return 0;
}

CMD_SIGN(hash) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        char *p = param_value(pos);
        size_t len = strlen(p);
        sprintf(buff, "hash(\"%s\") = %u\r\n", p, dictGenHashFunction(p, len));
        if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    }

    return 0;
}

CMD_SIGN(append) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(bitcount) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(brpop) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(brpoplpush) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(decr) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(decrby) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(del) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    char *key, *val;

    int para_num = 0;

    list_t *pos = NULL;
    list_for_each(pos, paras)
        ++para_num;

    if (para_num != 1) {
        cmd_err(conn_fd, "del", EARGNUM);
        return 1;
    }

    key = param_value(paras->next);

    val = (char *)table_get(s_db, key);

    sprintf(buff, "%s\r\n", val ? val : "(nil)");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");

    if (val) {
        struct binding *entry = table_remove(s_db, key);
        free(entry->key);
        free(entry->value);
        free(entry);
    }

    return 0;
}

CMD_SIGN(exists) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(get) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    const char *key, *val;

    int para_num = 0;

    list_t *pos = NULL;
    list_for_each(pos, paras)
        ++para_num;

    if (para_num != 1) {
        cmd_err(conn_fd, "get", EARGNUM);
        return 1;
    }

    key = param_value(paras->next);

    val = (const char *)table_get(s_db, key);

    sprintf(buff, "%s\r\n", val ? val : "nil");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(getbit) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(getrange) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(incr) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(incrby) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(keys) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(lindex) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(linsert) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(llen) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(lpop) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(lpush) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(lpushx) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(lrange) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(lrem) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(lset) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(ltrim) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(mget) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(msetnx) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(randomkey) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(rename) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(rpop) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(rpoplpush) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(rpush) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(rpushx) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(set) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    char *key, *val, *new_key, *new_val;

    int para_num = 0;

    list_t *pos = NULL;
    list_for_each(pos, paras)
        ++para_num;

    if (para_num != 2) {
        cmd_err(conn_fd, "set", EARGNUM);
        return 0;
    }

    key = param_value(paras->next);
    val= param_value(paras->prev);

    new_key = malloc(sizeof(char) * (strlen(key) + 1));
    strcpy(new_key, key);
    new_val = malloc(sizeof(char) * (strlen(val) + 1));
    strcpy(new_val, val);

    table_put(s_db, new_key, new_val);

    sprintf(buff, "OK\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(setbit) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(setrange) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(strlen) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}

CMD_SIGN(type) {
    char buff[BUFF_LEN];
    bzero(buff, sizeof(buff));
    strcpy(buff, "params:");

    list_t *pos = NULL;
    list_for_each(pos, paras) {
        strcat(buff, " ");
        strcat(buff, param_value(pos));
    }
    strcat(buff, "\r\n");

    if (send(conn_fd, buff, strlen(buff), 0) < 0)
        s_err("send");
    return 0;
}
