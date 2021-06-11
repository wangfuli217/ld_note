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

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#ifdef HAVE_SIGNAL_H
#include <signal.h>
#endif

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif

#include "monit.h"
#include "socket.h"
#include "event.h"
#include "MMonit.h"


/**
 *  Connect to a data collector servlet and send the event or status message.
 *
 *  @file
 */


/* ------------------------------------------------------------- Definitions */


#define MMONIT_SERVER_HEADER "Server: mmonit/"


/* ----------------------------------------------------------------- Private */


/**
 * Send message to the server
 * @param C An mmonit object
 * @param D Data to send
 * @return true if the message sending succeeded otherwise false
 */
static boolean_t _send(Socket_T socket, Mmonit_T C, StringBuffer_T sb) {
        char *auth = Util_getBasicAuthHeader(C->url->user, C->url->password);
        const void *body = NULL;
        size_t bodyLength = 0;
        if (C->compress == MmonitCompress_Yes && StringBuffer_length(sb) > 0) {
                body = StringBuffer_toCompressed(sb, 6, &bodyLength);
        } else {
                body = StringBuffer_toString(sb);
                bodyLength = StringBuffer_length(sb);
        }
        int rv = Socket_print(socket,
                              "POST %s HTTP/1.1\r\n"
                              "Host: %s%s%s:%d\r\n"
                              "Content-Type: text/xml\r\n"
                              "Content-Length: %zu\r\n"
                              "Pragma: no-cache\r\n"
                              "Accept: */*\r\n"
                              "User-Agent: Monit/%s\r\n"
                              "%s"
                              "%s"
                              "\r\n",
                              C->url->path,
                              C->url->ipv6 ? "[" : "", C->url->hostname, C->url->ipv6 ? "]" : "", C->url->port,
                              bodyLength,
                              VERSION,
                              C->compress == MmonitCompress_Yes ? "Content-Encoding: gzip\r\n" : "",
                              auth ? auth : "");
        FREE(auth);
        if (rv < 0 || Socket_write(socket, (unsigned char *)body, bodyLength) < 0) {
                LogError("M/Monit: error sending data to %s -- %s\n", C->url->url, STRERROR);
                return false;
        }
        return true;
}


/**
 * Check that the server returns a valid HTTP response
 * @param C An mmonit object
 * @return true if the response is valid otherwise false
 */
static boolean_t _receive(Socket_T socket, Mmonit_T C) {
        int  status;
        char buf[STRLEN];
        if (! Socket_readLine(socket, buf, sizeof(buf))) {
                LogError("M/Monit: error receiving data from %s -- %s\n", C->url->url, STRERROR);
                return false;
        }
        Str_chomp(buf);
        int n = sscanf(buf, "%*s %d", &status);
        if (n != 1 || (status >= 400)) {
                LogError("M/Monit: failed to send message to %s -- %s\n", C->url->url, buf);
                return false;
        }
        if (C->compress == MmonitCompress_Init) {
                C->compress = MmonitCompress_No;
#ifdef HAVE_LIBZ
                while (Socket_readLine(socket, buf, sizeof(buf))) {
                        if ((buf[0] == '\r' && buf[1] == '\n') || (buf[0] == '\n'))
                                break;
                        Str_chomp(buf);
                        if (Str_startsWith(buf, MMONIT_SERVER_HEADER)) {
                                char *version = buf + strlen(MMONIT_SERVER_HEADER);
                                if (*version) {
                                        int major, minor;
                                        if (sscanf(version, "%d.%d", &major, &minor) == 2 && (major > 3 || (major == 3 && minor >= 6)))
                                                C->compress = MmonitCompress_Yes;
                                }
                                break;
                        }
                }
#endif
        }
        return true;
}


/* ------------------------------------------------------------------ Public */


Handler_Type MMonit_send(Event_T E) {
        Handler_Type rv = Handler_Mmonit;
        /* The event is sent to mmonit just once - only in the case that the state changed */
        if (! Run.mmonits || (E && ! E->state_changed))
                return Handler_Succeeded;
        StringBuffer_T sb = StringBuffer_create(256);
        for (Mmonit_T C = Run.mmonits; C; C = C->next) {
                Socket_T  socket = Socket_create(C->url->hostname, C->url->port, Socket_Tcp, Socket_Ip, &(C->ssl), C->timeout);
                if (! socket) {
                        LogError("M/Monit: cannot open a connection to %s\n", C->url->url);
                        goto error;
                }
                status_xml(sb, E, 2, Socket_getLocalHost(socket, (char[STRLEN]){}, STRLEN));
                if (! _send(socket, C, sb)) {
                        LogError("M/Monit: cannot send %s message to %s\n", E ? "event" : "status", C->url->url);
                        goto error;
                }
                StringBuffer_clear(sb);
                if (! _receive(socket, C)) {
                        LogError("M/Monit: %s message to %s failed\n", E ? "event" : "status", C->url->url);
                        goto error;
                }
                rv = Handler_Succeeded; // Return success if at least one M/Monit succeeded
                DEBUG("M/Monit: %s message sent to %s\n", E ? "event" : "status", C->url->url);
        error:
                if (socket)
                        Socket_free(&socket);
        }
        StringBuffer_free(&sb);
        return rv;
}

