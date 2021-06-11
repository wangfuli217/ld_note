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
#include "base64.h"

// libmonit
#include "exceptions/IOException.h"
#include "exceptions/ProtocolException.h"

/**
 * Check an Apache server status using the server-status report from mod_status
 *
 * @file
 */


/* ----------------------------------------------------------------- Private */


static void parse_scoreboard(char *scoreboard, Port_T p) {
        int logging = 0, close = 0, dns = 0, keepalive = 0, reply = 0, request = 0, start = 0, wait = 0, graceful = 0, cleanup = 0, open = 0;
        for (char *state = scoreboard; *state; state++) {
                switch (*state) {
                        case 'S':
                                start++;
                                break;
                        case 'R':
                                request++;
                                break;
                        case 'W':
                                reply++;
                                break;
                        case 'K':
                                keepalive++;
                                break;
                        case 'D':
                                dns++;
                                break;
                        case 'C':
                                close++;
                                break;
                        case 'L':
                                logging++;
                                break;
                        case 'G':
                                graceful++;
                                break;
                        case 'I':
                                cleanup++;
                                break;
                        case '_':
                                wait++;
                                break;
                        case '.':
                                open++;
                                break;
                }
        }
        int total = logging + close + dns + keepalive + reply + request + start + wait + graceful + cleanup + open;
        if (! total)
                return; // Idle server
        if (p->parameters.apachestatus.loglimit > 0 && Util_evalQExpression(p->parameters.apachestatus.loglimitOP, (100 * logging / total), p->parameters.apachestatus.loglimit))
                THROW(ProtocolException, "APACHE-STATUS: error -- %d percent of processes are logging", 100 * logging / total);
        if (p->parameters.apachestatus.startlimit > 0 && Util_evalQExpression(p->parameters.apachestatus.startlimitOP, (100 * start / total), p->parameters.apachestatus.startlimit))
                THROW(ProtocolException, "APACHE-STATUS: error -- %d percent of processes are starting", 100 * start / total);
        if (p->parameters.apachestatus.requestlimit > 0 && Util_evalQExpression(p->parameters.apachestatus.requestlimitOP, (100 * request / total), p->parameters.apachestatus.requestlimit))
                THROW(ProtocolException, "APACHE-STATUS: error -- %d percent of processes are reading requests", 100 * request / total);
        if (p->parameters.apachestatus.replylimit > 0 && Util_evalQExpression(p->parameters.apachestatus.replylimitOP, (100 * reply / total), p->parameters.apachestatus.replylimit))
                THROW(ProtocolException, "APACHE-STATUS: error -- %d percent of processes are sending a reply", 100 * reply / total);
        if (p->parameters.apachestatus.keepalivelimit > 0 && Util_evalQExpression(p->parameters.apachestatus.keepalivelimitOP, (100 * keepalive / total), p->parameters.apachestatus.keepalivelimit))
                THROW(ProtocolException, "APACHE-STATUS: error -- %d percent of processes are in keepalive", 100 * keepalive / total);
        if (p->parameters.apachestatus.dnslimit > 0 && Util_evalQExpression(p->parameters.apachestatus.dnslimitOP, (100 * dns / total), p->parameters.apachestatus.dnslimit))
                THROW(ProtocolException, "APACHE-STATUS: error -- %d percent of processes are waiting for DNS", 100 * dns / total);
        if (p->parameters.apachestatus.closelimit > 0 && Util_evalQExpression(p->parameters.apachestatus.closelimitOP, (100 * close / total), p->parameters.apachestatus.closelimit))
                THROW(ProtocolException, "APACHE-STATUS: error -- %d percent of processes are closing connections", 100 * close / total);
        if (p->parameters.apachestatus.gracefullimit > 0 && Util_evalQExpression(p->parameters.apachestatus.gracefullimitOP, (100 * graceful / total), p->parameters.apachestatus.gracefullimit))
                THROW(ProtocolException, "APACHE-STATUS: error -- %d percent of processes are finishing gracefully", 100 * graceful / total);
        if (p->parameters.apachestatus.cleanuplimit > 0 && Util_evalQExpression(p->parameters.apachestatus.cleanuplimitOP, (100 * cleanup / total), p->parameters.apachestatus.cleanuplimit))
                THROW(ProtocolException, "APACHE-STATUS: error -- %d percent of processes are in idle cleanup", 100 * cleanup / total);
        if (p->parameters.apachestatus.waitlimit > 0 && Util_evalQExpression(p->parameters.apachestatus.waitlimitOP, (100 * wait / total), p->parameters.apachestatus.waitlimit))
                THROW(ProtocolException, "APACHE-STATUS: error -- %d percent of processes are waiting for a connection", 100 * wait / total);
}


static void _parseResponseHeaders(Socket_T socket) {
        int status;
        char buf[STRLEN];
        if (! Socket_readLine(socket, buf, sizeof(buf)))
                THROW(IOException, "APACHE-STATUS: error receiving data -- %s", STRERROR);
        Str_chomp(buf);
        if (! sscanf(buf, "%*s %d", &status))
                THROW(ProtocolException, "APACHE-STATUS: error -- cannot parse HTTP status in response: %s", buf);
        if (status != 200)
                THROW(ProtocolException, "APACHE-STATUS: error -- server returned status %d", status);
        while (Socket_readLine(socket, buf, sizeof(buf))) {
                if (! strncmp(buf, "\r\n", sizeof(buf)))
                        break;
        }
}


/* ------------------------------------------------------------------ Public */


void check_apache_status(Socket_T socket) {
        ASSERT(socket);
        char buf[4096];
        Port_T p = Socket_getPort(socket);
        ASSERT(p);
        char *auth = Util_getBasicAuthHeader(p->parameters.apachestatus.username, p->parameters.apachestatus.password);
        int rv = Socket_print(socket,
                "GET %s?auto HTTP/1.1\r\n"
                "Host: %s\r\n"
                "Accept: */*\r\n"
                "User-Agent: Monit/%s\r\n"
                "Connection: close\r\n"
                "%s"
                "\r\n",
                p->parameters.apachestatus.path ? p->parameters.apachestatus.path : "/server-status",
                Util_getHTTPHostHeader(socket, buf, sizeof(buf)),
                VERSION,
                auth ? auth : "");
        FREE(auth);
        if (rv < 0)
                THROW(IOException, "APACHE-STATUS: error sending data -- %s", STRERROR);
        _parseResponseHeaders(socket);
        while (Socket_readLine(socket, buf, sizeof(buf))) {
                if (Str_startsWith(buf, "Scoreboard: ")) {
                        char *scoreboard = buf + 12; // skip header
                        parse_scoreboard(scoreboard, p);
                        return;
                }
        }
        THROW(ProtocolException, "APACHE-STATUS: error -- no scoreboard found");
}

