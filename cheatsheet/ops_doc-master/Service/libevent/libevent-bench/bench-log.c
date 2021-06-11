/*
 * Copyright (c) 2010 Christopher Davis
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdio.h>
#include <stdlib.h>
#include "bench-log.h"

static enum log_level min_log_level = LOG_NOTICE;
static FILE *log_file = NULL;

void
log_debug(const char *msg, ...)
{
	va_list ap;

	va_start(ap, msg);
	log_msg_va(LOG_DEBUG, 0, msg, ap);
	va_end(ap);
}

void
log_info(const char *msg, ...)
{
	va_list ap;

	va_start(ap, msg);
	log_msg_va(LOG_INFO, 0, msg, ap);
	va_end(ap);
}

void
log_notice(const char *msg, ...)
{
	va_list ap;

	va_start(ap, msg);
	log_msg_va(LOG_NOTICE, 0, msg, ap);
	va_end(ap);
}

void
log_warn(const char *msg, ...)
{
	va_list ap;

	va_start(ap, msg);
	log_msg_va(LOG_WARN, 0, msg, ap);
	va_end(ap);
}

void
log_error(const char *msg, ...)
{
	va_list ap;

	va_start(ap, msg);
	log_msg_va(LOG_ERROR, 0, msg, ap);
	va_end(ap);
}

void
log_socket_error(const char *msg, ...)
{
	va_list ap;

	va_start(ap, msg);
	log_msg_va(LOG_ERROR, 1, msg, ap);
	va_end(ap);
}

void
log_fatal(const char *msg, ...)
{
	va_list ap;

	va_start(ap, msg);
	log_msg_va(LOG_FATAL, 0, msg, ap);
	va_end(ap);
}

void
log_msg_va(enum log_level lvl, int serr, const char *msg, va_list ap)
{
	if (lvl >= min_log_level) {
		vfprintf(log_file, msg, ap);
		/* XXX
		if (serr)
			fprintf(log_file, ": %s", socket_error_string(-1));
		*/
		fputs("\n", log_file);
		fflush(log_file);
		if (lvl >= LOG_FATAL)
			abort();
	}
}

void
log_set_min_level(enum log_level lvl)
{
	min_log_level = lvl;
}

enum log_level
log_get_min_level(void)
{
	return min_log_level;
}

void
log_set_file(FILE *fp)
{
	if (!fp)
		log_file = stderr;
	else
		log_file = fp;
}

void
log_raise_min_level(void)
{
	switch (min_log_level) {
	case LOG_DEBUG:
		min_log_level = LOG_INFO;
		break;
	case LOG_INFO:
		min_log_level = LOG_NOTICE;
		break;
	case LOG_NOTICE:
		min_log_level = LOG_WARN;
		break;
	case LOG_WARN:
		min_log_level = LOG_ERROR;
		break;
	case LOG_ERROR:
	case LOG_FATAL:
		min_log_level = LOG_FATAL;
		break;
	}
}

void
log_lower_min_level(void)
{
	switch (min_log_level) {
	case LOG_DEBUG:
	case LOG_INFO:
		min_log_level = LOG_DEBUG;
		break;
	case LOG_NOTICE:
		min_log_level = LOG_INFO;
		break;
	case LOG_WARN:
		min_log_level = LOG_NOTICE;
		break;
	case LOG_ERROR:
		min_log_level = LOG_WARN;
		break;
	case LOG_FATAL:
		min_log_level = LOG_ERROR;
		break;
	}
}
