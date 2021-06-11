
#include <sys/param.h>
#include <sys/types.h>
#include <sys/time.h>

#include <time.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <syslog.h>
#include <unistd.h>

#include "log.h"
#include "format/fmt.h"

static loglevel_t       log_level = LOG_STATUS;

loglevel_t
log_level_get(void)
{
	return (log_level);
}

void
log_level_set(loglevel_t level)
{
	log_level = level;
}

static void
_log(loglevel_t level, const char *fmt, va_list ap)
{
	if (level <= log_level) {
		fmt_vfprint(stderr, fmt, ap);
		fputc('\n', stderr);		       
		fflush(stderr);
	}
}

void
log_cond(int cond, loglevel_t l, const char *fmt, ...) 
{
	va_list ap;
	va_start(ap, fmt);

	if(cond) {
		_log(l, fmt, ap);
		if(l == LOG_FATAL) exit(1);
	}

	va_end(ap);
}

void
log_fatal(const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	_log(LOG_FATAL, fmt, ap);
	va_end(ap);
	exit(1);
}

void
log_warn(const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	_log(LOG_WARN, fmt, ap);
	va_end(ap);
}

void
log_status(const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	_log(LOG_STATUS, fmt, ap);
	va_end(ap);
}

void
log_trace(const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	_log(LOG_TRACE, fmt, ap);
	va_end(ap);
}

void
log_code(const char *fmt, ...)
{
	va_list ap;
	va_start(ap, fmt);
	_log(LOG_CODE, fmt, ap);
	va_end(ap);
}

