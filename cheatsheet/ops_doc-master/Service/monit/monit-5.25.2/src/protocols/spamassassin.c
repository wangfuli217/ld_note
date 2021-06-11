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

#include "protocol.h"

// libmonit
#include "exceptions/IOException.h"
#include "exceptions/ProtocolException.h"

/**
 *  Send PING and check for PONG.
 *
 *  @file
 */
void check_spamassassin(Socket_T socket) {
        ASSERT(socket);

        // Send PING
        if (Socket_print(socket, "PING SPAMC/1.2\r\n") < 0) {
                THROW(IOException, "SPAMASSASSIN: PING command error -- %s", STRERROR);
        }

        // Read and check PONG
        char buf[STRLEN];
        if (! Socket_readLine(socket, buf, sizeof(buf))) {
                THROW(IOException, "SPAMASSASSIN: PONG read error -- %s", STRERROR);
        }
        Str_chomp(buf);
        if (! Str_startsWith(buf, "SPAMD/") || ! Str_sub(buf, " PONG")) {
                THROW(ProtocolException, "SPAMASSASSIN: invalid PONG response -- %s", buf);
        }
}

