#ifndef __REDIS_H__
#define __REDIS_H__

#include <hiredis.h>
#include "smart_str.h"

void redis_init (char *host, int port);

void redis_free ();

int redis_hash_set (char *key, char *field, char *value);
int redis_hash_get (smart_str * str, char *key, char *field);

int redis_append (char *key, char *value);

int redis_list_push (char *key, char *value);
redisReply *redis_list_get (char *key, int offset, int size);

int get_deploy_id ();

#endif
