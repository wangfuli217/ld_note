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
#include "SMTP.h"

// libmonit
#include "exceptions/IOException.h"
#include "exceptions/ProtocolException.h"


/**
 * Implementation of the SMTP interface.
 *
 * RFCs:
 *      https://tools.ietf.org/html/rfc3207
 *      https://tools.ietf.org/html/rfc4616
 *      https://tools.ietf.org/html/rfc4954
 *      https://tools.ietf.org/html/rfc5321
 *      https://tools.ietf.org/html/rfc6409
 *
 * @file
 */


/* ------------------------------------------------------------- Definitions */


typedef enum {
        MTA_None      = 0x0,
        MTA_StartTLS  = 0x1,
        MTA_AuthPlain = 0x2,
        MTA_AuthLogin = 0x4
} __attribute__((__packed__)) MTA_Flags;


typedef enum {
        SMTP_Init = 0,
        SMTP_Greeting,
        SMTP_Helo,
        SMTP_StartTLS,
        SMTP_Auth,
        SMTP_MailFrom,
        SMTP_RcptTo,
        SMTP_DataBegin,
        SMTP_DataCommit,
        SMTP_Quit
} __attribute__((__packed__)) SMTP_State;


#define T SMTP_T
struct T {
        MTA_Flags flags;
        SMTP_State state;
        Socket_T socket;
        const char *name;
};


/* ----------------------------------------------------------------- Private */


// Note: we parse currently only flags for which we have some use
static void _parseFlags(T S, const char *line) {
        const char *flag = line + 4;
        if (Str_startsWith(flag, "STARTTLS")) {
                S->flags |= MTA_StartTLS;
        } else if (Str_startsWith(flag, "AUTH")) {
                if (Str_sub(flag, " PLAIN"))
                        S->flags |= MTA_AuthPlain;
                if (Str_sub(flag, " LOGIN"))
                        S->flags |= MTA_AuthLogin;
        }
}


static void _send(T S, const char *data, ...) {
        va_list ap;
        va_start(ap, data);
        char *msg = Str_vcat(data, ap);
        va_end(ap);
        int rv = Socket_write(S->socket, msg, strlen(msg));
        FREE(msg);
        if (rv <= 0)
                THROW(IOException, "Error sending data to the mailserver -- %s", STRERROR);
}


static void _receive(T S, int code, void (*callback)(T S, const char *line)) {
        int status = 0;
        char line[STRLEN];
        do {
                if (! Socket_readLine(S->socket, line, sizeof(line)))
                        THROW(IOException, "Error receiving data from the mailserver -- %s", STRERROR);
                Str_chomp(line);
                if (strlen(line) < 4 || sscanf(line, "%d", &status) != 1 || status != code)
                        THROW(ProtocolException, "Mailserver response error -- %s", line);
                if (callback)
                        callback(S, line);
        } while (line[3] == '-'); // multi-line response
}


/* ------------------------------------------------------------------ Public */


T SMTP_new(Socket_T socket) {
        ASSERT(socket);
        T S;
        NEW(S);
        S->socket = socket;
        return S;
}


void SMTP_free(T *S) {
        ASSERT(S && *S);
        TRY
        {
                if ((*S)->state != SMTP_Quit && (*S)->state > SMTP_Init)
                        SMTP_quit(*S);
        }
        ELSE
        {
                LogError("SMTP: %s\n", Exception_frame.message);
        }
        FINALLY
        {
                FREE(*S);
        }
        END_TRY;
}


void SMTP_greeting(T S) {
        ASSERT(S);
        _receive(S, 220, NULL);
        S->state = SMTP_Greeting;
}


void SMTP_helo(T S, const char *name) {
        ASSERT(S);
        S->name = name;
        _send(S, "EHLO %s\r\n", name);
        TRY
        {
                _receive(S, 250, _parseFlags);
        }
        ELSE
        {
                // If EHLO failed, fallback to HELO, but if it fails too, let the exception bubble up
                _send(S, "HELO %s\r\n", name);
                _receive(S, 250, NULL);
        }
        END_TRY;
        S->state = SMTP_Helo;
}


void SMTP_starttls(T S, SslOptions_T options) {
        ASSERT(S);
        if (S->flags & MTA_StartTLS) {
                _send(S, "STARTTLS\r\n");
                _receive(S, 220, NULL);
                // Switch to TLS
                Socket_enableSsl(S->socket, options, NULL);
                // Reset state and flags and send EHLO again (see RFC 3207 section 4.2)
                S->flags = MTA_None;
                S->state = SMTP_Greeting;
                SMTP_helo(S, S->name);
        } else {
                THROW(ProtocolException, "STARTTLS required but the mail server doesn't support it");
        }
        S->state = SMTP_StartTLS;
}


void SMTP_auth(T S, const char *username, const char *password) {
        ASSERT(S);
        ASSERT(username);
        ASSERT(password);
        char buffer[STRLEN] = {};
        // PLAIN has precedence
        if (S->flags & MTA_AuthPlain) {
                int len = snprintf(buffer, STRLEN, "%c%s%c%s", '\0', username, '\0', password);
                char *b64 = encode_base64(len, (unsigned char *)buffer);
                TRY
                {
                        _send(S, "AUTH PLAIN %s\r\n", b64);
                        _receive(S, 235, NULL);
                }
                FINALLY
                {
                        FREE(b64);
                }
                END_TRY;
        } else if (S->flags & MTA_AuthLogin) {
                _send(S, "AUTH LOGIN\r\n");
                _receive(S, 334, NULL);
                strncpy(buffer, username, sizeof(buffer) - 1);
                char *b64 = encode_base64(strlen(buffer), (unsigned char *)buffer);
                TRY
                {
                        _send(S, "%s\r\n", b64);
                        _receive(S, 334, NULL);
                }
                FINALLY
                {
                        FREE(b64);
                }
                END_TRY;
                strncpy(buffer, password, sizeof(buffer) - 1);
                b64 = encode_base64(strlen(buffer), (unsigned char *)buffer);
                TRY
                {
                        _send(S, "%s\r\n", b64);
                        _receive(S, 235, NULL);
                }
                FINALLY
                {
                        FREE(b64);
                }
                END_TRY;
        } else {
                THROW(ProtocolException, "Authentication failed -- no supported authentication methods found");
        }
        S->state = SMTP_Auth;
}


void SMTP_from(T S, const char *from) {
        ASSERT(S);
        ASSERT(from);
        _send(S, "MAIL FROM: <%s>\r\n", from);
        _receive(S, 250, NULL);
        S->state = SMTP_MailFrom;
}


void SMTP_to(T S, const char *to) {
        ASSERT(S);
        ASSERT(to);
        _send(S, "RCPT TO: <%s>\r\n", to);
        _receive(S, 250, NULL);
        S->state = SMTP_RcptTo;
}


void SMTP_dataBegin(T S) {
        ASSERT(S);
        _send(S, "DATA\r\n");
        _receive(S, 354, NULL);
        S->state = SMTP_DataBegin;
}


void SMTP_dataCommit(T S) {
        ASSERT(S);
        _send(S, "\r\n.\r\n");
        _receive(S, 250, NULL);
        S->state = SMTP_DataCommit;
}


void SMTP_quit(T S) {
        _send(S, "QUIT\r\n");
        _receive(S, 221, NULL);
        S->state = SMTP_Quit;
}

