/*
 * Copyright (C) Tildeslash Ltd. All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * In addition, as a special exception, the copyright holders give
 * permission to link the code of portions of this program with the
 * OpenSSL library under certain conditions as described in each
 * individual source file, and distribute linked combinations
 * including the two.
 *
 * You must obey the GNU Affero General Public License in all respects
 * for all of the code used other than OpenSSL.
 */


#ifndef MONIT_NOTIFICATION_SMTP_H
#define MONIT_NOTIFICATION_SMTP_H


#include "config.h"

#ifdef HAVE_STDIO_H
#include <stdio.h>
#endif

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_STDARG_H
#include <stdarg.h>
#endif

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif

#ifdef HAVE_SETJMP_H
#include <setjmp.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#include "monit.h"
#include "net.h"
#include "socket.h"
#include "base64.h"

// libmonit
#include "system/Time.h"
#include "exceptions/IOException.h"


/**
 * SMTP interface
 *
 * RFCs:
 *      https://www.ietf.org/rfc/rfc3207.txt
 *      https://www.ietf.org/rfc/rfc5321.txt
 *
 * @file
 */


#define T SMTP_T
typedef struct T *T;


/**
 * Create a new SMTP protocol object.
 * @param socket A socket connected to an SMTP server
 * @return SMTP object
 * @exception AssertException if socket is NULL
 */
T SMTP_new(Socket_T socket);


/**
 * Destroy the SMTP protocol object.
 * @param S A reference to the SMTP protocol object
 * @exception AssertException if reference is NULL
 */
void SMTP_free(T *S);


/**
 * Read an SMTP server greeting and check for status code 220 in
 * response.
 * @param S The SMTP protocol object
 * @exception AssertException if S is NULL, IOException if failed
 */
void SMTP_greeting(T S);


/**
 * Send an EHLO command to the SMTP server (fallback to HELO if not
 * supported) and check for status code 250 in response.
 * @param S The SMTP protocol object
 * @param name A name to send in the EHLO/HELO command
 * @exception AssertException if S is NULL, IOException if failed
 */
void SMTP_helo(T S, const char *name);


/**
 * Send an STARTTLS command to the SMTP server and check for status
 * code 220 in response.
 * @param S The SMTP protocol object
 * @param options The SSL options.
 * @exception AssertException if S is NULL, IOException if failed
 */
void SMTP_starttls(T S, SslOptions_T options);


/**
 * Perform a SMTP authentication (using either PLAIN or LOGIN).
 * @param S The SMTP protocol object
 * @param username A username to use.
 * @param password A password to use.
 * @exception AssertException if S, username or password is NULL,
 * IOException if failed
 */
void SMTP_auth(T S, const char *username, const char *password);


/**
 * Send a MAIL FROM command to the SMTP server and check for status
 * code 250 in response.
 * @param S The SMTP protocol object
 * @param from A sender address
 * @exception AssertException if S or from is NULL, IOException if failed
 */
void SMTP_from(T S, const char *from);


/**
 * Send a RCPT TO command to the SMTP server and check for status
 * code 250 in response.
 * @param S The SMTP protocol object
 * @param to A recipient address
 * @exception AssertException if S or to is NULL, IOException if failed
 */
void SMTP_to(T S, const char *to);


/**
 * Send a DATA command to the SMTP server and check for status
 * code 354 in response.
 * @param S The SMTP protocol object
 * @exception AssertException if S is NULL, IOException if failed
 */
void SMTP_dataBegin(T S);


/**
 * Commit SMTP DATA and check for status code 250 in response.
 * @param S The SMTP protocol object
 * @exception AssertException if S is NULL, IOException if failed
 */
void SMTP_dataCommit(T S);


/**
 * Send a QUIT command to the SMTP server and check for status
 * code 221 in response.
 * @param S The SMTP protocol object
 * @exception AssertException if S is NULL, IOException if failed
 */
void SMTP_quit(T S);


#undef T
#endif

