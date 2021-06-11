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

#include "md5.h"
#include "sha1.h"
#include "base64.h"
#include "protocol.h"
#include "httpstatus.h"
#include "util/Str.h"

// libmonit
#include "exceptions/IOException.h"
#include "exceptions/ProtocolException.h"

/**
 *  A HTTP test.
 *
 *  We send the following request to the server:
 *  'GET / HTTP/1.1'             ... if request statement isn't defined
 *  'GET /custom/page  HTTP/1.1' ... if request statement is defined
 *  and check the server's status code.
 *
 *  If the statement defines hostname, it's used in the 'Host:' header otherwise a default (empty) Host header is set.
 *
 *  If the status code is >= 400, an error has occurred.
 *
 *  @file
 */


/* ----------------------------------------------------------------- Private */


static boolean_t _hasHeader(List_T list, const char *name) {
        if (list) {
                for (list_t h = list->head; h; h = h->next) {
                        char *header = h->e;
                        if (Str_startsWith(header, name))
                                if (header[strlen(name)] == ':') // Ensure that name is not just a prefix
                                        return true;
                }
        }
        return false;
}


static void _checkResponseContent(Socket_T socket, int content_length, Request_T R) {
        boolean_t rv = false;

        if (content_length == 0)
                THROW(ProtocolException, "HTTP error: No content returned from server");
        else if (content_length < 0 || content_length > Run.limits.httpContentBuffer) /* content_length < 0 if no Content-Length header was found */
                content_length = Run.limits.httpContentBuffer;

        char error[STRLEN];
        int size = 0, length = content_length, buflen = content_length + 1;
        char *buf = ALLOC(buflen);
        do {
                int n = Socket_read(socket, &buf[size], length);
                if (n <= 0)
                        break;
                size += n;
                length -= n;
        } while (length > 0);

        if (size == 0) {
                snprintf(error, sizeof(error), "Receiving data -- %s", STRERROR);
                goto error;
        }
        buf[size] = 0;

        int regex_return = regexec(R->regex, buf, 0, NULL, 0);
        FREE(buf);
        switch (R->operator) {
                case Operator_Equal:
                        if (regex_return == 0) {
                                rv = true;
                                DEBUG("HTTP: Regular expression matches\n");
                        } else {
                                char errbuf[STRLEN];
                                regerror(regex_return, NULL, errbuf, sizeof(errbuf));
                                snprintf(error, sizeof(error), "Regular expression doesn't match: %s", errbuf);
                        }
                        break;
                case Operator_NotEqual:
                        if (regex_return == 0) {
                                snprintf(error, sizeof(error), "Regular expression matches");
                        } else {
                                rv = true;
                                DEBUG("HTTP: Regular expression doesn't match\n");
                        }
                        break;
                default:
                        snprintf(error, sizeof(error), "Invalid content operator");
                        break;
        }

error:
        if (! rv)
                THROW(ProtocolException, "HTTP error: %s", error);
}


static void _checkResponseChecksum(Socket_T socket, int content_length, char *checksum, Hash_Type hashtype) {
        int n, keylength = 0;
        MD_T result, hash;
        md5_context_t ctx_md5;
        sha1_context_t ctx_sha1;
        char buf[8192];

        if (content_length <= 0) {
                DEBUG("HTTP warning: Response does not contain a valid Content-Length -- cannot compute checksum\n");
                return;
        }

        switch (hashtype) {
                case Hash_Md5:
                        md5_init(&ctx_md5);
                        while (content_length > 0) {
                                if ((n = Socket_read(socket, buf, content_length > sizeof(buf) ? sizeof(buf) : content_length)) < 0)
                                        break;
                                md5_append(&ctx_md5, (const md5_byte_t *)buf, n);
                                content_length -= n;
                        }
                        md5_finish(&ctx_md5, (md5_byte_t *)hash);
                        keylength = 16; /* Raw key bytes not string chars! */
                        break;
                case Hash_Sha1:
                        sha1_init(&ctx_sha1);
                        while (content_length > 0) {
                                if ((n = Socket_read(socket, buf, content_length > sizeof(buf) ? sizeof(buf) : content_length)) < 0)
                                        break;
                                sha1_append(&ctx_sha1, (md5_byte_t *)buf, n);
                                content_length -= n;
                        }
                        sha1_finish(&ctx_sha1, (md5_byte_t *)hash);
                        keylength = 20; /* Raw key bytes not string chars! */
                        break;
                default:
                        THROW(ProtocolException, "HTTP checksum error: Unknown hash type");
        }
        if (strncasecmp(Util_digest2Bytes((unsigned char *)hash, keylength, result), checksum, keylength * 2) != 0)
                THROW(ProtocolException, "HTTP checksum error: Document checksum mismatch");
        DEBUG("HTTP: Succeeded testing document checksum\n");
}


/**
 * Check that the server returns a valid HTTP response as well as checksum
 * or content regex if required
 * @param s A socket
 */
static void _checkResponse(Socket_T socket, Port_T P) {
        int status, content_length = -1;
        char buf[512];
        if (! Socket_readLine(socket, buf, sizeof(buf)))
                THROW(IOException, "HTTP: Error receiving data -- %s", STRERROR);
        Str_chomp(buf);
        if (! sscanf(buf, "%*s %d", &status))
                THROW(ProtocolException, "HTTP error: Cannot parse HTTP status in response: %s", buf);
        if (! Util_evalQExpression(P->parameters.http.operator, status, P->parameters.http.hasStatus ? P->parameters.http.status : 400))
                THROW(ProtocolException, "HTTP error: Server returned status %d", status);
        /* Get Content-Length header value */
        while (Socket_readLine(socket, buf, sizeof(buf))) {
                if ((buf[0] == '\r' && buf[1] == '\n') || (buf[0] == '\n'))
                        break;
                Str_chomp(buf);
                if (Str_startsWith(buf, "Content-Length")) {
                        if (! sscanf(buf, "%*s%*[: ]%d", &content_length))
                                THROW(ProtocolException, "HTTP error: Parsing Content-Length response header '%s'", buf);
                        if (content_length < 0)
                                THROW(ProtocolException, "HTTP error: Illegal Content-Length response header '%s'", buf);
                }
        }
        /* FIXME:
         * we read the data from the socket inside _checkResponseContent() and also _checkResponseChecksum() independently => these two cannot be used together - only one wil read the data. Refactor the spaghetti code and consolidate
         * the read function, so data are ready before we test the content (read once, allow to apply different tests / many times) */
        /* FIXME:
         * We don't support chuncked transfer encoding and rely on Content-Length only ... this has two problems:
         * 1.) we read chunk headers to buffer as part of data and apply checksum test and regex test to it => technically wrong, as the pattern we're looking for may be split in different chunks and won't match, checksum completyly wrong
         * 2.) the read of chunked data is slowed downed by read delay (https://bitbucket.org/tildeslash/monit/issues/254/hosts-check-is-too-long)
         * I.e. implement support for Chunked encoding (see above FIXME comment - we should have one read function, which can be used to read data and reuse it for all tests)
         */
        if (P->url_request && P->url_request->regex)
                _checkResponseContent(socket, content_length, P->url_request);
        if (P->parameters.http.checksum)
                _checkResponseChecksum(socket, content_length, P->parameters.http.checksum, P->parameters.http.hashtype);
}


static char *_getAuthHeader(Port_T P) {
        if (P->url_request) {
                URL_T U = P->url_request->url;
                if (U)
                        return Util_getBasicAuthHeader(U->user, U->password);
        }
        return Util_getBasicAuthHeader(P->parameters.http.username, P->parameters.http.password);
}


static void _sendRequest(Socket_T socket, Port_T P) {
        char *auth = _getAuthHeader(P);
        StringBuffer_T sb = StringBuffer_create(168);
        //FIXME: add decompression support to InputStream and switch here to it + set Accept-Encoding to gzip, so the server can send body compressed (if we test checksum/content)
        StringBuffer_append(sb,
                            "%s %s HTTP/1.1\r\n"
                            "%s",
                            httpmethod[P->parameters.http.method],
                            P->parameters.http.request ? P->parameters.http.request : "/",
                            auth ? auth : "");
        FREE(auth);
        // Set default header values unless defined
        if (! _hasHeader(P->parameters.http.headers, "Host"))
                StringBuffer_append(sb, "Host: %s\r\n", Util_getHTTPHostHeader(socket, (char[STRLEN]){}, STRLEN));
        if (! _hasHeader(P->parameters.http.headers, "User-Agent"))
                StringBuffer_append(sb, "User-Agent: Monit/%s\r\n", VERSION);
        if (! _hasHeader(P->parameters.http.headers, "Accept"))
                StringBuffer_append(sb, "Accept: */*\r\n");
        if (! _hasHeader(P->parameters.http.headers, "Connection"))
                StringBuffer_append(sb, "Connection: close\r\n");
        // Add headers if we have them
        if (P->parameters.http.headers) {
                for (list_t p = P->parameters.http.headers->head; p; p = p->next) {
                        char *header = p->e;
                        StringBuffer_append(sb, "%s\r\n", header);
                }
        }
        StringBuffer_append(sb, "\r\n");
        int send_status = Socket_write(socket, (void*)StringBuffer_toString(sb), StringBuffer_length(sb));
        StringBuffer_free(&sb);
        if (send_status < 0)
                THROW(IOException, "HTTP: error sending data -- %s", STRERROR);
}


/* ------------------------------------------------------------------ Public */


void check_http(Socket_T socket) {
        ASSERT(socket);

        Port_T P = Socket_getPort(socket);
        ASSERT(P);

        _sendRequest(socket, P);
        _checkResponse(socket, P);
}

