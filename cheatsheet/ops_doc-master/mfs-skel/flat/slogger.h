#ifndef _SLOGGER_H_
#define _SLOGGER_H_

#include <stdio.h>
#include <syslog.h>
#include <stdarg.h>
#include <errno.h>

#include "strerr.h"

#define mfs_syslog(priority,msg) {\
    syslog((priority),"%s",(msg)); \
    fprintf(stderr,"%s\n",(msg)); \
}

#define mfs_arg_syslog(priority,format, ...) {\
    syslog((priority),(format), __VA_ARGS__); \
    fprintf(stderr,format "\n", __VA_ARGS__); \
}

#define mfs_errlog(priority,msg) {\
    const char *_mfs_errstring = strerr(errno); \
    syslog((priority),"%s: %s", (msg) , _mfs_errstring); \
    fprintf(stderr,"%s: %s\n", (msg), _mfs_errstring); \
}

#define mfs_arg_errlog(priority,format, ...) {\
    const char *_mfs_errstring = strerr(errno); \
    syslog((priority),format ": %s", __VA_ARGS__ , _mfs_errstring); \
    fprintf(stderr,format ": %s\n", __VA_ARGS__ , _mfs_errstring); \
}

#define mfs_log_write(prio, func, line, fmt,...) {\
    syslog((prio),"%s: %d"fmt, func, line, __VA_ARGS__); \
    fprintf(stderr,"%s: %d"fmt"\n", func, line, __VA_ARGS__); \
}


#define mfs_errlog_silent(priority,msg) syslog((priority),"%s: %s", msg, strerr(errno));
#define mfs_arg_errlog_silent(priority,format, ...) syslog((priority),format ": %s", __VA_ARGS__ , strerr(errno));

void rtu_mod_dp_set(uint32_t mod, uint8_t dp);
int rtu_mod_dp_get(uint8_t *buff, uint32_t bufflen);
const char *rtu_mod_name_desc(uint32_t mod, uint8_t *dp);

void log_write(int prio, const char *func, int line, const char *fmt, ...);
void log_writeex(int prio, uint32_t module, const char *func, int line, const char *fmt, ...);

#define	RTU_EMERG	LOG_EMERG
#define	RTU_ALERT	LOG_ALERT
#define	RTU_CRIT	LOG_CRIT
#define	RTU_ERR	LOG_ERR
#define	RTU_WARNING	LOG_WARNING
#define	RTU_NOTICE	LOG_NOTICE
#define	RTU_INFO	LOG_INFO
#define	RTU_DEBUG	LOG_DEBUG

enum 
{
    MOD_FIBRE_CONF_DP = 1,
    MOD_LDPROXY_DP,
    MOD_OTDRD_DP,
    MOD_OTDR_CACHE_DP,
    MOD_OTDR_MAIN_DP,
    MOD_OTDR_SOR_DP,
    MOD_OTDR_TASK_DP,
    MOD_RTU_CONF_DP,
    MOD_RTU_MONITOR_DP,
    MOD_RTU_REPORT_DP,
    MOD_RTU_TTY_DP
};

#define rtu_emerg(fmt, args...) \
	log_write(RTU_EMERG, __func__, __LINE__, fmt, ##args)
#define rtu_alert(fmt, args...) \
	log_write(RTU_ALERT, __func__, __LINE__, fmt, ##args)
#define rtu_crit(fmt, args...) \
	log_write(RTU_CRIT, __func__, __LINE__, fmt, ##args)
#define rtu_err(fmt, args...) \
	log_write(RTU_ERR, __func__, __LINE__, fmt, ##args)
#define rtu_warn(fmt, args...) \
	log_write(RTU_WARNING, __func__, __LINE__, fmt, ##args)
#define rtu_notice(fmt, args...) \
	log_write(RTU_NOTICE, __func__, __LINE__, fmt, ##args)
#define rtu_info(fmt, args...) \
	log_write(RTU_INFO, __func__, __LINE__, fmt, ##args)
#define rtu_debug(fmt, args...) \
	log_write(RTU_NOTICE, __func__, __LINE__, fmt, ##args)


#define rtu_debugex(mod, fmt, args...) \
	log_writeex(RTU_INFO, mod, __func__, __LINE__, fmt, ##args)
	
#define rtu_noticeex(mod, fmt, args...) \
	log_writeex(RTU_NOTICE, mod, __func__, __LINE__, fmt, ##args)
	
#define rtu_warnex(mod, fmt, args...) \
	log_writeex(RTU_WARNING, mod, __func__, __LINE__, fmt, ##args)

#define rtu_errex(mod, fmt, args...) \
	log_writeex(RTU_ERR, mod, __func__, __LINE__, fmt, ##args)
	
int slogger_config_init(void);

#endif
