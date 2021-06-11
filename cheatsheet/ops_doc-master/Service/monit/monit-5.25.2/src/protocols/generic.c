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

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#ifdef HAVE_REGEX_H
#include <regex.h>
#endif

#include "protocol.h"

// libmonit
#include "exceptions/IOException.h"
#include "exceptions/ProtocolException.h"

/* Escape zero i.e. '\0' in expect buffer with "\0" so zero can be tested in expect strings as "\0". If there are no '\0' in the buffer it is returned as it is */
static char *_escapeZeroInExpectBuffer(char *buf, int buflen, int n) {
        for (int i = 0, j = 0; i < n && j < buflen; i++, j++) {
                if (buf[j] == '\0') {
                        if (j + 1 < buflen) {
                                memmove(buf + j + 1, buf + j, n - i);
                                buf[j] = '\\';
                                buf[j + 1] = '0';
                                j++;
                        }
                }
        }
        return buf;
}


/**
 *  Generic service test.
 *
 *  @file
 */
void check_generic(Socket_T socket) {
        ASSERT(socket);

        Generic_T g = NULL;
        if (Socket_getPort(socket))
                g = ((Port_T)(Socket_getPort(socket)))->parameters.generic.sendexpect;

        char *buf = CALLOC(sizeof(char), Run.limits.sendExpectBuffer + 1);

        while (g != NULL) {

                if (g->send != NULL) {
                        /* Unescape any \0x00 escaped chars in g's send string to allow sending a string containing \0 bytes also */
                        char *X = Str_dup(g->send);
                        int l = Util_handle0Escapes(X);

                        if (Socket_write(socket, X, l) < 0) {
                                FREE(X);
                                FREE(buf);
                                THROW(IOException, "GENERIC: error sending data -- %s", STRERROR);
                        } else {
                                DEBUG("GENERIC: successfully sent: '%s'\n", g->send);
                        }
                        FREE(X);
                } else if (g->expect != NULL) {
                        /* Since the protocol is unknown we need to wait on EOF. To avoid waiting
                         timeout seconds on EOF we first read one byte to fill the socket's read
                         buffer and then set a low timeout on next read which reads remaining bytes
                         as well as wait on EOF */
                        int first_byte = Socket_readByte(socket);
                        if (first_byte < 0) {
                                FREE(buf);
                                THROW(IOException, "GENERIC: error receiving data -- %s", STRERROR);
                        }
                        *buf = first_byte;

                        int timeout = Socket_getTimeout(socket);
                        Socket_setTimeout(socket, 200);
                        int n = Socket_read(socket, buf + 1, Run.limits.sendExpectBuffer - 1) + 1;
                        buf[n] = 0;
                        if (n > 0)
                                _escapeZeroInExpectBuffer(buf, Run.limits.sendExpectBuffer, n);
                        Socket_setTimeout(socket, timeout); // Reset back original timeout for next send/expect
                        int regex_return = regexec(g->expect, buf, 0, NULL, 0);
                        if (regex_return != 0) {
                                char e[STRLEN];
                                regerror(regex_return, g->expect, e, STRLEN);
                                char error[STRLEN];
                                snprintf(error, sizeof(error), "GENERIC: received unexpected data [%s] -- %s", Str_trunc(Str_trim(buf), sizeof(error) - 128), e);
                                FREE(buf);
                                THROW(ProtocolException, "%s", error);
                        } else {
                                DEBUG("GENERIC: successfully received: '%s'\n", Str_trunc(buf, STRLEN));
                        }
                } else {
                        /* This should not happen */
                        FREE(buf);
                        THROW(ProtocolException, "GENERIC: unexpected strangeness");
                }
                g = g->next;
        }
        FREE(buf);
}

