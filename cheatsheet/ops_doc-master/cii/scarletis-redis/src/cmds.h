#ifndef CMDS_H
#define CMDS_H

#include "list.h"

#define CMD_SIGN(name) int cmd_##name(int conn_fd, list_t *paras)

CMD_SIGN(hello);
CMD_SIGN(hash);
CMD_SIGN(bye);
CMD_SIGN(shutdown);
CMD_SIGN(append);
CMD_SIGN(bitcount);
CMD_SIGN(brpop);
CMD_SIGN(brpoplpush);
CMD_SIGN(decr);
CMD_SIGN(decrby);
CMD_SIGN(del);
CMD_SIGN(exists);
CMD_SIGN(get);
CMD_SIGN(getbit);
CMD_SIGN(getrange);
CMD_SIGN(incr);
CMD_SIGN(incrby);
CMD_SIGN(keys);
CMD_SIGN(lindex);
CMD_SIGN(linsert);
CMD_SIGN(llen);
CMD_SIGN(lpop);
CMD_SIGN(lpush);
CMD_SIGN(lpushx);
CMD_SIGN(lrange);
CMD_SIGN(lrem);
CMD_SIGN(lset);
CMD_SIGN(ltrim);
CMD_SIGN(mget);
CMD_SIGN(msetnx);
CMD_SIGN(randomkey);
CMD_SIGN(rename);
CMD_SIGN(rpop);
CMD_SIGN(rpoplpush);
CMD_SIGN(rpush);
CMD_SIGN(rpushx);
CMD_SIGN(set);
CMD_SIGN(setbit);
CMD_SIGN(setrange);
CMD_SIGN(strlen);
CMD_SIGN(type);

#endif
