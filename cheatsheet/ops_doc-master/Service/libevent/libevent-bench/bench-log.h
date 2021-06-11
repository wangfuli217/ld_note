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

#ifndef _LOG_H_
#define _LOG_H_

#include <stdarg.h>
#include <stdio.h>

enum log_level {
	LOG_DEBUG,
	LOG_INFO,
	LOG_NOTICE,
	LOG_WARN,
	LOG_ERROR,
	LOG_FATAL
};

#ifdef __GNUC__
#define CHECK_FMT(a,b) __attribute__((format(printf, a, b)))
#else
#define CHECK_FMT(a,b)
#endif

void log_debug(const char *msg, ...) CHECK_FMT(1,2);
void log_info(const char *msg, ...) CHECK_FMT(1,2);
void log_notice(const char *msg, ...) CHECK_FMT(1,2);
void log_warn(const char *msg, ...) CHECK_FMT(1,2);
void log_error(const char *msg, ...) CHECK_FMT(1,2);
void log_socket_error(const char *msg, ...) CHECK_FMT(1,2);
void log_fatal(const char *msg, ...) CHECK_FMT(1,2);

void log_msg_va(enum log_level lvl, int serr, const char *msg, va_list ap);

void log_set_min_level(enum log_level lvl);
enum log_level log_get_min_level(void);
void log_set_file(FILE *fp);

void log_raise_min_level(void);
void log_lower_min_level(void);

#endif
