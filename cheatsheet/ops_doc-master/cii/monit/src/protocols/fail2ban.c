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
/**
 *  Send PING and check for PONG.
 *
 *  @file
 */
void check_fail2ban(Socket_T socket) {
        ASSERT(socket);

        const unsigned char ping[] = "(lp0\nS'ping'\np1\na.<F2B_END_COMMAND>"; // pickle protocol version 0

        // Send PING
        if (Socket_write(socket, (void *)ping, sizeof(ping)) < 0) {
                THROW(IOException, "FAIL2BAN: PING command error -- %s", STRERROR);
        }

        // Read and check response - just the pickle protocol header beginning to see if the server reacts to commands, so we can keep the response test pickle-protocol-version agnostic
        unsigned char response[1] = {};
        if (Socket_read(socket, response, sizeof(response)) != 1) {
                THROW(IOException, "FAIL2BAN: PONG read error -- %s", STRERROR);
        }
        if (response[0] != 0x80) {
                THROW(ProtocolException, "FAIL2BAN: PONG error");
        }
}

