/**
 * File: log.h
 * Author: ZhuXindi
 * Date: 2013-07-11
 */

#ifndef _LOG_H
#define _LOG_H

#include <stdio.h>

enum {
	LOG_DEBUG = 0,
	LOG_INFO,
	LOG_WARN,
	LOG_ERROR,
	LOG_DIE,
};

/* set log level and return the old level, default level is LOG_WARN */
int set_log_level(int min_level);

/* set log file and return the old file, default file is stderr */
FILE *set_log_file(FILE *f);

void write_log(const char *file, int line, int level, const char *fmt, ...);

#define log_debug(fmt, ...) \
	write_log(__FILE__, __LINE__, LOG_DEBUG, fmt, ##__VA_ARGS__)

#define log_info(fmt, ...) \
	write_log(__FILE__, __LINE__, LOG_INFO, fmt, ##__VA_ARGS__)

#define log_warn(fmt, ...) \
	write_log(__FILE__, __LINE__, LOG_WARN, fmt, ##__VA_ARGS__)

#define log_error(fmt, ...) \
	write_log(__FILE__, __LINE__, LOG_ERROR, fmt, ##__VA_ARGS__)

#define log_die(fmt, ...) \
	write_log(__FILE__, __LINE__, LOG_DIE, fmt, ##__VA_ARGS__)

#endif /* _LOG_H */
