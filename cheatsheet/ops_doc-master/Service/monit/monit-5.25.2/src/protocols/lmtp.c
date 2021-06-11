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

/* --------------------------------------------------------------- Private */


static void say(Socket_T socket, char *msg) {
        if (Socket_write(socket, msg, strlen(msg)) < 0)
                THROW(IOException, "LMTP: error sending data -- %s", STRERROR);
}


static void expect(Socket_T socket, int expect) {
        int status;
        char buf[STRLEN];
        do {
                if (! Socket_readLine(socket, buf, STRLEN))
                        THROW(IOException, "LMTP: error receiving data -- %s", STRERROR);
                Str_chomp(buf);
        } while (buf[3] == '-'); // Discard multi-line response
        if (sscanf(buf, "%d", &status) != 1 || status != expect)
                THROW(ProtocolException, "LMTP error: %s", buf);
}


/* ---------------------------------------------------------------- Public */


/**
 * Check the server for greeting code 220, send LHLO, test for return code 250 and finally send QUIT and check for return code 221
 *
 * @see RFC2033
 *
 * @file
 */
void check_lmtp(Socket_T socket) {
        ASSERT(socket);
        expect(socket, 220);
        say(socket, "LHLO localhost\r\n");
        expect(socket, 250);
        say(socket, "QUIT\r\n");
        expect(socket, 221);
}


