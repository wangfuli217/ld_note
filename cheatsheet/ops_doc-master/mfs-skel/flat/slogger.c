#include <stdio.h>
#include <stdarg.h>
#include <errno.h>
#include <time.h>
#include <sys/time.h>
#include <inttypes.h>
#include <string.h>

#include "main.h"
#include "utils.h"
#include "cfg.h"
#include "slogger.h"

#define MAX_MSG_SIZE 1024

#define TEXT_NORMAL         "\033[0m"
#define TEXT_BOLD           "\033[1m"
#define TEXT_RED            "\033[0;31m"
#define TEXT_BOLD_RED       "\033[1;31m"
#define TEXT_GREEN          "\033[0;32m"
#define TEXT_BOLD_GREEN     "\033[1;32m"
#define TEXT_YELLOW         "\033[0;33m"
#define TEXT_BOLD_YELLOW    "\033[1;33m"
#define TEXT_BLUE           "\033[0;34m"
#define TEXT_BOLD_BLUE      "\033[1;34m"
#define TEXT_MAGENTA        "\033[0;35m"
#define TEXT_BOLD_MAGENTA   "\033[1;35m"
#define TEXT_CYAN           "\033[0;36m"
#define TEXT_BOLD_CYAN      "\033[1;36m"

#define CLEAR_SCREEN        "\033[2J"
#define RESET_CURSOR        "\033[1;1H"

#define MAX_THREAD_NAME_LEN 20 
#define FUNC_NAME_SIZE 32 
struct logmsg {
    uint32_t tv;
    int prio;
    char func[FUNC_NAME_SIZE];
    int line;
    char worker_name[MAX_THREAD_NAME_LEN];
    int worker_idx;

    size_t str_len;
    char str[0];
};


static int colorize;
static const char * const log_color[] = {
    [RTU_EMERG] = TEXT_BOLD_RED,
    [RTU_ALERT] = TEXT_BOLD_RED,
    [RTU_CRIT] = TEXT_BOLD_RED,
    [RTU_ERR] = TEXT_BOLD_RED,
    [RTU_WARNING] = TEXT_BOLD_YELLOW,
    [RTU_NOTICE] = TEXT_BOLD_CYAN,
    [RTU_INFO] = TEXT_CYAN,
    [RTU_DEBUG] = TEXT_GREEN,
};

static const char * const log_prio_str[] = {
    [RTU_EMERG]   = "EMERG",
    [RTU_ALERT]   = "ALERT",
    [RTU_CRIT]    = "CRIT",
    [RTU_ERR]     = "ERROR",
    [RTU_WARNING] = "WARN",
    [RTU_NOTICE]  = "NOTICE",
    [RTU_INFO]    = "INFO",
    [RTU_DEBUG]   = "DEBUG",
};

static void init_logmsg(struct logmsg *msg, uint32_t tv,
                        int prio, const char *func, int line)
{
    msg->tv = tv;
    msg->prio = prio;
    strncpy(msg->func, func, FUNC_NAME_SIZE);
    msg->line = line;
    strcpy(msg->worker_name, "main");
    msg->worker_idx = 1014;
}

static int server_log_formatter(char *buff, size_t size,
                                const struct logmsg *msg, int print_time)
{
    char *p = buff;
    struct tm tm;
    ssize_t len;

    if (print_time) {
        localtime_r((const time_t *)&msg->tv, &tm);
        len = strftime(p, size, "%b %2d %H:%M:%S ",
                       (const struct tm *)&tm);
        p += len;
        size -= len;
    }

    len = snprintf(p, size, "%s%6s %s[%s] %s(%d) %s%s%s",
                   colorize ? log_color[msg->prio] : "",
                   log_prio_str[msg->prio],
                   colorize ? TEXT_YELLOW : "",
                   msg->worker_name,
                   msg->func, msg->line,
                   colorize ? log_color[msg->prio] : "",
                   msg->str, colorize ? TEXT_NORMAL : "");
    if (len < 0)
    len = 0;
    p += min((size_t)len, size - 1);

    return p - buff;
}

#if 0
static int default_log_formatter(char *buff, size_t size,
                                 const struct logmsg *msg, int print_time)
{
    print_time = 0;
    size_t len = min(size, msg->str_len);

    memcpy(buff, msg->str, len);

    return len;
}

static int json_log_formatter(char *buff, size_t size,
                              const struct logmsg *msg, int print_time)
{
    char *p = buff;
    ssize_t len;
    uint16_t port = 3600;
    char *log_name = "rdproxy";
    print_time = 0;

    len = snprintf(p, size, "{ \"user_info\": "
                              "{\"program_name\": \"%s\", \"port\": %d},"
                              "\"body\": {"
                                          "\"second\": %lu, \"usecond\": %lu, "
                                          "\"worker_name\": \"%s\", \"worker_idx\": %d, "
                                          "\"func\": \"%s\", \"line\": %d, "
                                          "\"msg\": \"",
                                          log_name, port,
                                          msg->tv.tv_sec, msg->tv.tv_usec,
                                          "main",
                                          msg->worker_idx, msg->func, msg->line);
                                          if (len < 0)
                                          return 0;
                                          len = min((size_t)len, size - 1);
                                          p += len;
                                          size -= len;

                                          size_t i = 0;
                                          for (i = 0; i < msg->str_len; i++) {
                                              if (size <= 1)
                                              break;

                                              if (msg->str[i] == '"') {
                                                  *p++ = '\\';
                                                  size--;
                                              }

                                              if (size <= 1)
                                              break;
                                              *p++ = msg->str[i];
                                              size--;
                                          }

                                          strncpy(p, "\"} }", size);
    p += strlen(p);

    return p - buff;
}
#endif

static void dolog(int prio, const char *func, int line,
                  const char *fmt, va_list ap)
{
    char buf[sizeof(struct logmsg) + MAX_MSG_SIZE];
    char *str = buf + sizeof(struct logmsg);
    struct logmsg *msg = (struct logmsg *)buf;
    int len = 0;
    uint32_t tv = main_time();

    len = vsnprintf(str, MAX_MSG_SIZE, fmt, ap);
    if (len < 0) {
        syslog(LOG_ERR, "vsnprintf failed");
        return;
    }
    msg->str_len = min(len, MAX_MSG_SIZE - 1);

    char str_final[MAX_MSG_SIZE];

    init_logmsg(msg, tv, prio, func, line);
    len = server_log_formatter(str_final, sizeof(str_final) - 1, msg, 0);
    str_final[len++] = '\0';
    mfs_syslog(prio, str_final);

}

#ifdef RTUD_DEBUG
static int rtu_log_level = 7;
#else
static int rtu_log_level = 5;
#endif

void log_write(int prio, const char *func, int line, const char *fmt, ...)
{
    va_list ap;

    if (prio > rtu_log_level)
    return;

    va_start(ap, fmt);
    dolog(prio, func, line, fmt, ap);
    va_end(ap);
}


static void dologex(int prio, const char *module, const char *func, int line,
                    const char *fmt, va_list ap)
{
    char buf[sizeof(struct logmsg) + MAX_MSG_SIZE];
    char *str = buf + sizeof(struct logmsg);
    struct logmsg *msg = (struct logmsg *)buf;
    int len = 0;
    uint32_t tv = main_time();

    len = vsnprintf(str, MAX_MSG_SIZE, fmt, ap);
    if (len < 0) {
        syslog(LOG_ERR, "vsnprintf failed");
        return;
    }
    msg->str_len = min(len, MAX_MSG_SIZE - 1);

    char str_final[MAX_MSG_SIZE];

    init_logmsg(msg, tv, prio, func, line);
    strcpy(msg->worker_name, module);
    len = server_log_formatter(str_final, sizeof(str_final) - 1, msg, 0);
    str_final[len++] = '\0';
    mfs_syslog(prio, str_final);
}


typedef struct dbgentry {
    uint8_t modnam;
    char *str;
    uint8_t level;
} dbgentry;

static dbgentry dbghead[] = {
    {MOD_FIBRE_CONF_DP, "fibre_config", RTU_ERR},
    {MOD_LDPROXY_DP, "ldproxy", RTU_ERR},
    {MOD_OTDRD_DP, "otdrd", RTU_ERR},
    {MOD_OTDR_CACHE_DP, "otdr_cache", RTU_ERR},
    {MOD_OTDR_MAIN_DP, "otdr_main", RTU_ERR},
    {MOD_OTDR_SOR_DP, "otdr_sor", RTU_ERR},
    {MOD_OTDR_TASK_DP, "otdr_task", RTU_ERR},
    {MOD_RTU_CONF_DP, "rtu_config", RTU_ERR},
    {MOD_RTU_MONITOR_DP, "rtu_mon", RTU_ERR},
    {MOD_RTU_REPORT_DP, "rtu_report", RTU_ERR},
    {MOD_RTU_TTY_DP, "rtu_tty", RTU_ERR}
};

void rtu_mod_dp_set(uint32_t mod, uint8_t dp)
{
    uint8_t pos;

    for(pos=0;pos<sizeof(dbghead)/sizeof(dbgentry);pos++)
    {
        if(mod == dbghead[pos].modnam)
        {
            dbghead[pos].level = dp;
        }
    }
}

int rtu_mod_dp_get(uint8_t *buff, uint32_t bufflen)
{
    uint8_t pos;

    if(bufflen < sizeof(dbghead)/sizeof(dbgentry)*2) 
    return -1;

    for(pos=0;pos<sizeof(dbghead)/sizeof(dbgentry);pos++)
    {
        buff[pos*2] = dbghead[pos].modnam;
        buff[pos*2+1] = dbghead[pos].level;
    }

    return sizeof(dbghead)/sizeof(dbgentry)*2;
}


const char *rtu_mod_name_desc(uint32_t mod, uint8_t *dp)
{
    uint8_t pos;

    for(pos=0;pos<sizeof(dbghead)/sizeof(dbgentry);pos++)
    {
        if(mod == dbghead[pos].modnam)
        {
            *dp = dbghead[pos].level;
            return dbghead[pos].str;
        }
    }
    *dp = RTU_INFO;
    return "rtu";
}

void log_writeex(int prio, uint32_t module, const char *func, int line, const char *fmt, ...)
{
    va_list ap;
    uint8_t dp;
    const char *desc = rtu_mod_name_desc(module, &dp);

    if (prio > dp)
    return;

    va_start(ap, fmt);
    dologex(prio, desc, func, line, fmt, ap);
    va_end(ap);
}

int slogger_config_init(void)
{
    int dbg;

    dbg  = cfg_getuint16("MOD_FIBRE_CONF_DP", RTU_INFO);
    rtu_mod_dp_set(MOD_FIBRE_CONF_DP, dbg);

    dbg  = cfg_getuint16("MOD_LDPROXY_DP", RTU_INFO);
    rtu_mod_dp_set(MOD_LDPROXY_DP, dbg);

    dbg  = cfg_getuint16("MOD_OTDRD_DP", RTU_INFO);
    rtu_mod_dp_set(MOD_OTDRD_DP, dbg);

    dbg  = cfg_getnum("MOD_OTDR_CACHE_DP", RTU_INFO);
    rtu_mod_dp_set(MOD_OTDR_CACHE_DP, dbg);

    dbg  = cfg_getnum("MOD_OTDR_MAIN_DP", RTU_INFO);
    rtu_mod_dp_set(MOD_OTDR_MAIN_DP, dbg);

    dbg  = cfg_getnum("MOD_OTDR_SOR_DP", RTU_INFO);
    rtu_mod_dp_set(MOD_OTDR_SOR_DP, dbg);

    dbg  = cfg_getnum("MOD_OTDR_TASK_DP", RTU_INFO);
    rtu_mod_dp_set(MOD_OTDR_TASK_DP, dbg);

    dbg  = cfg_getnum("MOD_RTU_CONF_DP", RTU_INFO);
    rtu_mod_dp_set(MOD_RTU_CONF_DP, dbg);

    dbg  = cfg_getnum("MOD_RTU_MONITOR_DP", RTU_INFO);
    rtu_mod_dp_set(MOD_RTU_MONITOR_DP, dbg);

    dbg  = cfg_getnum("MOD_RTU_REPORT_DP", RTU_INFO);
    rtu_mod_dp_set(MOD_RTU_REPORT_DP, dbg);

    dbg  = cfg_getnum("MOD_RTU_TTY_DP", RTU_INFO);
    rtu_mod_dp_set(MOD_RTU_TTY_DP, dbg);

    return 0;
}

