/*
 *
 *	Authors:
 *	 Lars Fenneberg		<lf@elemental.net>
 *
 *	This software is Copyright 1996,1997 by the above mentioned author(s),
 *	All Rights Reserved.
 *
 *	The license which is distributed with this software in the file
 *	COPYRIGHT applies to this software. If your distribution is missing
 *	this file, you may request it from <reubenhwk@gmail.com>.
 *
 */

#include "config.h"
#include "includes.h"
#include "radvd.h"

__attribute__((format(printf, 2, 0))) static int vlog(int prio, char const *format, va_list ap);

static int log_method = L_NONE;
static char const *log_ident;
static char const *log_file;
static FILE *log_file_fd;
static int log_facility;
static int debug_level = 0;

int log_open(int method, char const *ident, char const *log, int facility)
{
	log_method = method;
	log_ident = ident;

	switch (log_method) {
	case L_NONE:
	case L_UNSPEC:
	case L_STDERR:
		break;
	case L_STDERR_CLEAN:
	/* fallthrough */
	case L_STDERR_SYSLOG:
	/* fallthrough */
	case L_SYSLOG:
		if (facility == -1)
			log_facility = LOG_DAEMON;
		else
			log_facility = facility;

		openlog(log_ident, LOG_PID, log_facility);
		break;
	case L_LOGFILE:
		if (!log) {
			fprintf(stderr, "%s (%d): no logfile specified\n", log_ident, getpid());
			return -1;
		}
		log_file = log;
		if ((log_file_fd = fopen(log_file, "a")) == NULL) {
			fprintf(stderr, "%s (%d): can't open %s: %s\n", log_ident, getpid(), log_file, strerror(errno));
			return -1;
		}
		break;
	default:
		fprintf(stderr, "%s (%d): unknown logging method: %d\n", log_ident, getpid(), log_method);
		log_method = L_NONE;
		return -1;
	}
	return 0;
}

/* note: [dfv]log() is also called from root context */
__attribute__((format(printf, 2, 0))) static int vlog(int prio, char const *format, va_list ap)
{
	char tstamp[64], buff[1024];
	struct tm *tm;
	time_t current;

	vsnprintf(buff, sizeof(buff), format, ap);

	switch (log_method) {
	case L_NONE:
	case L_UNSPEC:
		break;
	case L_SYSLOG:
		syslog(prio, "%s", buff);
		break;
	case L_STDERR_SYSLOG:
		syslog(prio, "%s", buff);
		if (debug_level < prio) /* fall through for messages with high priority */
			break;
	case L_STDERR:
		current = time(NULL);
		tm = localtime(&current);
		(void)strftime(tstamp, sizeof(tstamp), LOG_TIME_FORMAT, tm);

		fprintf(stderr, "[%s] %s (%d): %s\n", tstamp, log_ident, getpid(), buff);
		fflush(stderr);
		break;
	case L_STDERR_CLEAN:
		fprintf(stderr, "%s\n", buff);
		fflush(stderr);
		break;
	case L_LOGFILE:
		current = time(NULL);
		tm = localtime(&current);
		(void)strftime(tstamp, sizeof(tstamp), LOG_TIME_FORMAT, tm);

		fprintf(log_file_fd, "[%s] %s (%d): %s\n", tstamp, log_ident, getpid(), buff);
		fflush(log_file_fd);
		break;
	default:
		fprintf(stderr, "%s (%d): unknown logging method: %d\n", log_ident, getpid(), log_method);
		log_method = L_NONE;
		return -1;
	}
	return 0;
}

void dlog(int prio, int level, char const *format, ...)
{
	if (debug_level < level)
		return;

	va_list ap;
	va_start(ap, format);
	vlog(prio, format, ap);
	va_end(ap);
}

void flog(int prio, char const *format, ...)
{
	va_list ap;

	va_start(ap, format);
	vlog(prio, format, ap);
	va_end(ap);
}

int log_close(void)
{
	switch (log_method) {
	case L_NONE:
	case L_UNSPEC:
	case L_STDERR:
		break;
	case L_STDERR_SYSLOG:
	case L_SYSLOG:
		closelog();
		break;
	case L_LOGFILE:
		fclose(log_file_fd);
		break;
	default:
		fprintf(stderr, "%s (%d): unknown logging method: %d\n", log_ident, getpid(), log_method);
		log_method = L_NONE;
		return -1;
	}
	return 0;
}

void set_debuglevel(int level) { debug_level = level; }

int get_debuglevel(void) { return debug_level; }
