#ifndef __DEPLOY_H__
#define __DEPLOY_H__

#include "ini.h"

typedef struct {
    char *listen_host;
    short listen_port;
    char *redis_addr;
    short redis_port;
    char *config_path;
    int daemon_mode;
    ini_t *ini;
} deploy_setting_t;

extern deploy_setting_t *setting;

#define   DEPLOY_ID_KEY           "ad_deploy_id"
#define   DEPLOY_HASH_PREFIX      "ad_deploy_info_"
#define   DEPLOY_LOG_PREFIX       "ad_deploy_log_"
#define   DEPLOY_STATUS_RUNNING   "running"
#define   DEPLOY_STATUS_SUCCESS   "success"
#define   DEPLOY_STATUS_FAILURE   "failure"

#define   DEPLOY_LIST_KEY         "ad_deploy_list"

#endif
