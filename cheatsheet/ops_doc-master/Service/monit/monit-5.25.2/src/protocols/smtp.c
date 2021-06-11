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

#include "protocol.h"
#include "SMTP.h"


/* --------------------------------------------------------------- Public */


/**
 * Check the SMTP server.
 *
 * @file
 */
void check_smtp(Socket_T socket) {
        ASSERT(socket);
        SMTP_T smtp = SMTP_new(socket);
        TRY
        {
                Port_T port = Socket_getPort(socket);
                SMTP_greeting(smtp);
                SMTP_helo(smtp, "localhost");
                if (port->family != Socket_Unix && port->target.net.ssl.options.flags == SSL_StartTLS)
                        SMTP_starttls(smtp, &(port->target.net.ssl.options));
                if (port->parameters.smtp.username && port->parameters.smtp.password)
                        SMTP_auth(smtp, port->parameters.smtp.username, port->parameters.smtp.password);
                SMTP_quit(smtp);
        }
        FINALLY
        {
                SMTP_free(&smtp);
        }
        END_TRY;
}

