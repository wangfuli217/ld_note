/**
 * File: log.c
 * Author: ZhuXindi
 * Date: 2013-07-11
 */

#include <log.h>
#include <systime.h>
#include <stdio.h>
#include <stdarg.h>

static FILE *log_file;
static int log_level = LOG_WARN;
static const char *str_levels[] = {
	[LOG_DEBUG]	= "DEBUG",
	[LOG_INFO]	= "INFO",
	[LOG_WARN]	= "WARN",
	[LOG_ERROR]	= "ERROR",
	[LOG_DIE]	= "DIE",
};

int set_log_level(int min_level)
{
	int ret = log_level;

	log_level = min_level;
	if (log_level < LOG_DEBUG)
		log_level = LOG_DEBUG;
	else if (log_level > LOG_DIE)
		log_level = LOG_DIE;
	return ret;
}

static inline FILE *__set_log_file(FILE *f)
{
	FILE *ret = log_file;

	log_file = f;
	return ret;
}

FILE *set_log_file(FILE *f)
{
	if (log_file)
		fflush(log_file);
	return __set_log_file(f ?: stderr);
}

void write_log(const char *file, int line, int level, const char *fmt, ...)
{
	if (!log_file)
		__set_log_file(stderr);

	if (level >= log_level) {
		va_list va;
		va_start(va, fmt);
		fprintf(log_file, "%s #%d %s:%d [%s] ", str_time, (int)pid, file, line, str_levels[level]);
		vfprintf(log_file, fmt, va);
		fprintf(log_file, "\n");
		va_end(va);
	}

	if (level == LOG_DIE) {
		fflush(log_file);
		_exit(1);
	}
}
