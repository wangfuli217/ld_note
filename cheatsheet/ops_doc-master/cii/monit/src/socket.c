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

#ifdef HAVE_POLL_H
#include <poll.h>
#endif

#ifdef HAVE_FCNTL_H
#include <fcntl.h>
#endif

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif

#ifdef HAVE_STRINGS_H
#include <strings.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#ifdef HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif

#ifdef HAVE_SYS_UN_H
#include <sys/un.h>
#endif

#ifdef HAVE_ARPA_INET_H
#include <arpa/inet.h>
#endif

#ifdef HAVE_NETINET_TCP_H
#include <netinet/tcp.h>
#endif

#ifdef HAVE_NETDB_H
#include <netdb.h>
#endif

#include "net.h"
#include "monit.h"
#include "socket.h"
#include "SslServer.h"

// libmonit
#include "exceptions/assert.h"
#include "exceptions/IOException.h"
#include "util/Str.h"
#include "system/Net.h"
#include "system/Time.h"



/**
 * Implementation of the socket interface.
 *
 * @file
 */


/* ------------------------------------------------------------- Definitions */


typedef enum {
        Connection_Client = 0,
        Connection_Server
} __attribute__((__packed__)) Connection_Type;


// One TCP frame data size
#define RBUFFER_SIZE 1460


#define T Socket_T
struct T {
        Socket_Type type;
        Socket_Family family;
        Connection_Type connection_type;
        int socket;
        int port;
        int timeout; // milliseconds
        int length;
        int offset;
        char *host;
        Port_T Port;
#ifdef HAVE_OPENSSL
        Ssl_T ssl;
        SslServer_T sslserver;
#endif
        unsigned char buffer[RBUFFER_SIZE + 1];
};


/* --------------------------------------------------------------- Private */


/*
 * Fill the internal buffer. If an error occurs or if the read
 * operation timed out -1 is returned.
 * @param S A Socket object
 * @param timeout The number of milliseconds to wait for data to be read
 * @return the length of data read or -1 if an error occurred
 */
static int _fill(T S, int timeout) {
        S->offset = 0;
        S->length = 0;
        if (S->type == Socket_Udp)
                timeout = 500;
        int n;
#ifdef HAVE_OPENSSL
        if (S->ssl)
                n = Ssl_read(S->ssl, S->buffer + S->length, RBUFFER_SIZE - S->length, timeout);
        else
#endif
                n = (int)Net_read(S->socket, S->buffer + S->length,  RBUFFER_SIZE - S->length, timeout);
        if (n > 0)
                S->length += n;
        else if (n < 0)
                return -1;
        else if (! (errno == EAGAIN || errno == EWOULDBLOCK)) // Peer closed connection
                return -1;
        return n;
}


int _getPort(const struct sockaddr *addr) {
        if (addr->sa_family == AF_INET)
                return ntohs(((struct sockaddr_in *)addr)->sin_port);
#ifdef HAVE_IPV6
        else if (addr->sa_family == AF_INET6)
                return ntohs(((struct sockaddr_in6 *)addr)->sin6_port);
#endif
        else
                return -1;
}


static char *_addressToString(const struct sockaddr *addr, socklen_t addrlen, char *buf, int buflen) {
        int oerrno = errno;
        if (addr->sa_family == AF_UNIX) {
                snprintf(buf, buflen, "%s", ((struct sockaddr_un *)addr)->sun_path);
        } else {
                char ip[46], port[6];
                int status = getnameinfo(addr, addrlen, ip, sizeof(ip), port, sizeof(port), NI_NUMERICHOST | NI_NUMERICSERV);
                if (status) {
                        LogError("Cannot get address string -- %s\n", status == EAI_SYSTEM ? STRERROR : gai_strerror(status));
                        *buf = 0;
                } else {
                        snprintf(buf, buflen, "[%s]:%s", ip, port);
                }
        }
        errno = oerrno;
        return buf;
}


static boolean_t _doConnect(int s, const struct sockaddr *addr, socklen_t addrlen, int timeout, char *error, int errorlen) {
        int rv = connect(s, addr, addrlen);
        if (! rv) {
                return true;
        } else if (errno != EINPROGRESS) {
                snprintf(error, errorlen, "%s", STRERROR);
                return false;
        }
        struct pollfd fds[1];
        fds[0].fd = s;
        fds[0].events = POLLIN | POLLOUT;
        rv = poll(fds, 1, timeout);
        if (rv == 0) {
                snprintf(error, errorlen, "Connection timed out");
                return false;
        } else if (rv == -1) {
                snprintf(error, errorlen, "Poll failed: %s", STRERROR);
                return false;
        }
        if (fds[0].events & POLLIN || fds[0].events & POLLOUT) {
                socklen_t rvlen = sizeof(rv);
                if (getsockopt(s, SOL_SOCKET, SO_ERROR, &rv, &rvlen) < 0) {
                        snprintf(error, errorlen, "Read of error details failed: %s", STRERROR);
                        return false;
                } else if (rv) {
                        snprintf(error, errorlen, "%s", strerror(rv));
                        return false;
                }
        } else {
                snprintf(error, errorlen, "Not ready for I/O");
                return false;
        }
        return true;
}


T _createIpSocket(const char *host, const struct sockaddr *addr, socklen_t addrlen, const struct sockaddr *localaddr, socklen_t localaddrlen, int family, int type, int protocol, SslOptions_T options, int timeout) {
        ASSERT(host);
        char error[STRLEN];
        int s = socket(family, type, protocol);
        if (s >= 0) {
                if (localaddr) {
                        if (bind(s, localaddr, localaddrlen) < 0) {
                                snprintf(error, sizeof(error), "Cannot bind to outgoing address -- %s", STRERROR);
                                goto error;
                        }
                }
                if (Net_setNonBlocking(s)) {
                        if (fcntl(s, F_SETFD, FD_CLOEXEC) != -1) {
                                if (_doConnect(s, addr, addrlen, timeout, error, sizeof(error))) {
                                        T S;
                                        NEW(S);
                                        S->socket = s;
                                        S->type = type;
                                        S->family = family == AF_INET ? Socket_Ip4 : Socket_Ip6;
                                        S->timeout = timeout;
                                        S->host = Str_dup(host);
                                        S->port = _getPort(addr);
                                        S->connection_type = Connection_Client;
                                        if (options->flags == SSL_Enabled) {
                                                TRY
                                                {
                                                        Socket_enableSsl(S, options, host);
                                                }
                                                ELSE
                                                {
                                                        Socket_free(&S);
                                                        RETHROW;
                                                }
                                                END_TRY;
                                        }
                                        return S;
                                }
                        } else {
                                snprintf(error, sizeof(error), "Cannot set socket close on exec -- %s", STRERROR);
                        }
                } else {
                        snprintf(error, sizeof(error), "Cannot set nonblocking socket -- %s", STRERROR);
                }
error:
                Net_close(s);
        } else {
                snprintf(error, sizeof(error), "Cannot create socket to %s -- %s", _addressToString(addr, addrlen, (char[STRLEN]){}, STRLEN), STRERROR);
        }
        THROW(IOException, "%s", error);
        return NULL;
}


struct addrinfo *_resolve(const char *hostname, int port, Socket_Type type, Socket_Family family) {
        ASSERT(hostname);
        struct addrinfo *result, hints = {
                .ai_socktype = type,
                .ai_protocol = type == Socket_Udp ? IPPROTO_UDP : IPPROTO_TCP
        };
        switch (family) {
                case Socket_Ip:
                        hints.ai_family = AF_UNSPEC;
                        break;
                case Socket_Ip4:
                        hints.ai_family = AF_INET;
                        break;
#ifdef HAVE_IPV6
                case Socket_Ip6:
                        hints.ai_family = AF_INET6;
#ifdef AI_ADDRCONFIG
                        hints.ai_flags = AI_ADDRCONFIG;
#endif
                        break;
#endif
                default:
                        LogError("Invalid socket family %d\n", family);
                        return NULL;
        }
        char _port[6];
        snprintf(_port, sizeof(_port), "%d", port);
        int status = getaddrinfo(hostname, _port, &hints, &result);
        if (status != 0) {
                LogError("Cannot translate '%s' to IP address -- %s\n", hostname, status == EAI_SYSTEM ? STRERROR : gai_strerror(status));
                return NULL;
        }
        return result;
}


/* ------------------------------------------------------------------ Public */


T Socket_new(const char *host, int port, Socket_Type type, Socket_Family family, Ssl_Flags flags, int timeout) {
        struct SslOptions_T options = {.flags = flags};
        return Socket_create(host, port, type, family, &options, timeout);
}


T Socket_create(const char *host, int port, Socket_Type type, Socket_Family family, SslOptions_T options, int timeout) {
        ASSERT(host);
        ASSERT(timeout > 0);
        volatile T S = NULL;
        struct addrinfo *result = _resolve(host, port, type, family);
        if (result) {
                char error[512];
                // The host may resolve to multiple IPs and if at least one succeeded, we have no problem and don't have to flood the log with partial errors => log only the last error
                for (struct addrinfo *r = result; r && S == NULL; r = r->ai_next) {
                        TRY
                        {
                                S = _createIpSocket(host, r->ai_addr, r->ai_addrlen, NULL, 0, r->ai_family, r->ai_socktype, r->ai_protocol, options, timeout);
                        }
                        ELSE
                        {
                                snprintf(error, sizeof(error), "%s", Exception_frame.message);
                        }
                        END_TRY;
                }
                freeaddrinfo(result);
                if (! S)
                        LogError("Cannot create socket to [%s]:%d -- %s\n", host, port, error);
        }
        return S;
}


T Socket_createUnix(const char *path, Socket_Type type, int timeout) {
        ASSERT(path);
        ASSERT(timeout > 0);
        int s = socket(PF_UNIX, type, 0);
        if (s >= 0) {
                struct sockaddr_un unixsocket_client = {};
                if (type == Socket_Udp) {
                        unixsocket_client.sun_family = AF_UNIX;
                        snprintf(unixsocket_client.sun_path, sizeof(unixsocket_client.sun_path), "/tmp/monit_%p.sock", &unixsocket_client);
                        if (bind(s, (struct sockaddr *) &unixsocket_client, sizeof(unixsocket_client)) != 0) {
                                LogError("Unix socket %s bind error -- %s\n", unixsocket_client.sun_path, STRERROR);
                                goto error;
                        }
                }
                struct sockaddr_un unixsocket_server = {};
                unixsocket_server.sun_family = AF_UNIX;
                strncpy(unixsocket_server.sun_path, path, sizeof(unixsocket_server.sun_path) - 1);
                if (Net_setNonBlocking(s)) {
                        char error[STRLEN];
                        if (_doConnect(s, (struct sockaddr *)&unixsocket_server, sizeof(unixsocket_server), timeout, error, sizeof(error))) {
                                T S;
                                NEW(S);
                                S->connection_type = Connection_Client;
                                S->family = Socket_Unix;
                                S->type = type;
                                S->socket = s;
                                S->timeout = timeout;
                                S->host = Str_dup(LOCALHOST);
                                return S;
                        }
                        LogError("Unix socket %s connection error -- %s\n", path, error);
                } else {
                        LogError("Cannot set nonblocking unix socket %s -- %s\n", path, STRERROR);
                }
error:
                Net_close(s);
                if (type == Socket_Udp)
                        unlink(unixsocket_client.sun_path);
        } else {
                LogError("Cannot create unix socket %s -- %s\n", path, STRERROR);
        }
        return NULL;
}


T Socket_createAccepted(int socket, struct sockaddr *addr, void *sslserver) {
        ASSERT(socket >= 0);
        ASSERT(addr);
        T S;
        NEW(S);
        S->socket = socket;
        S->timeout = Run.limits.networkTimeout;
        S->connection_type = Connection_Server;
        S->type = Socket_Tcp;
        if (addr->sa_family != AF_UNIX) {
                if (addr->sa_family == AF_INET) {
                        struct sockaddr_in *a = (struct sockaddr_in *)addr;
                        S->family = Socket_Ip4;
                        S->host = Str_dup(inet_ntop(addr->sa_family, &a->sin_addr, (char[INET_ADDRSTRLEN]){}, INET_ADDRSTRLEN));
                }
#ifdef HAVE_IPV6
                else {
                        struct sockaddr_in6 *a = (struct sockaddr_in6 *)addr;
                        S->family = Socket_Ip6;
                        S->host = Str_dup(inet_ntop(addr->sa_family, &a->sin6_addr, (char[INET6_ADDRSTRLEN]){}, INET6_ADDRSTRLEN));
                }
#endif
                S->port = _getPort(addr);
#ifdef HAVE_OPENSSL
                if (sslserver) {
                        S->sslserver = sslserver;
                        if (! (S->ssl = SslServer_newConnection(S->sslserver)) || ! SslServer_accept(S->ssl, S->socket, S->timeout)) {
                                Socket_free(&S);
                                return NULL;
                        }
                }
#endif
        } else {
                S->family = Socket_Unix;
        }
        return S;
}


void Socket_free(T *S) {
        ASSERT(S && *S);
#ifdef HAVE_OPENSSL
        if ((*S)->ssl)
        {
                if ((*S)->connection_type == Connection_Client) {
                        Ssl_close((*S)->ssl);
                        Ssl_free(&((*S)->ssl));
                } else if ((*S)->connection_type == Connection_Server && (*S)->sslserver) {
                        SslServer_freeConnection((*S)->sslserver, &((*S)->ssl));
                }
        }
        else
#endif
        {
                int type;
                socklen_t length = sizeof(type);
                int rv = getsockopt((*S)->socket, SOL_SOCKET, SO_TYPE, &type, &length);
                if (rv) {
                        LogError("Freeing socket -- getsockopt failed: %s\n", STRERROR);
                } else if (type == SOCK_DGRAM) {
                        struct sockaddr_storage addr;
                        socklen_t addrlen = sizeof(addr);
                        if (getsockname((*S)->socket, (struct sockaddr *)&addr, &addrlen) == 0) {
                                if (addr.ss_family == AF_UNIX) {
                                        struct sockaddr_un *_addr = (struct sockaddr_un *)&addr;
                                        unlink(_addr->sun_path);
                                }
                        }
                }
                Net_shutdown((*S)->socket, SHUT_RDWR);
                Net_close((*S)->socket);
        }
        FREE((*S)->host);
        FREE(*S);
}


/* ------------------------------------------------------------ Properties */


void Socket_setTimeout(T S, int timeout) {
        ASSERT(S);
        S->timeout = timeout;
}


int Socket_getTimeout(T S) {
        ASSERT(S);
        return S->timeout;
}


boolean_t Socket_isSecure(T S) {
        ASSERT(S);
#ifdef HAVE_OPENSSL
        return (S->ssl != NULL);
#else
        return false;
#endif
}


int Socket_getSocket(T S) {
        ASSERT(S);
        return S->socket;
}


Socket_Type Socket_getType(T S) {
        ASSERT(S);
        return S->type;
}


void *Socket_getPort(T S) {
        ASSERT(S);
        return S->Port;
}


int Socket_getRemotePort(T S) {
        ASSERT(S);
        return S->port;
}


const char *Socket_getRemoteHost(T S) {
        ASSERT(S);
        return S->host;
}


int Socket_getLocalPort(T S) {
        ASSERT(S);
        struct sockaddr_storage addr;
        socklen_t addrlen = sizeof(addr);
        if (getsockname(S->socket, (struct sockaddr *)&addr, &addrlen) == 0)
                return _getPort((struct sockaddr *)&addr);
        return -1;
}


const char *Socket_getLocalHost(T S, char *host, int hostlen) {
        ASSERT(S);
        ASSERT(host);
        ASSERT(hostlen);
        struct sockaddr_storage addr;
        socklen_t addrlen = sizeof(addr);
        if (! getsockname(S->socket, (struct sockaddr *)&addr, &addrlen)) {
                int status = getnameinfo((struct sockaddr *)&addr, addrlen, host, hostlen, NULL, 0, NI_NUMERICHOST);
                if (! status)
                        return host;
                LogError("Cannot translate address to hostname -- %s\n", status == EAI_SYSTEM ? STRERROR : gai_strerror(status));
        } else {
                LogError("Cannot translate address to hostname -- getsockname failed: %s\n", STRERROR);
        }
        return NULL;
}


static void _testUnix(Port_T p) {
        T S = Socket_createUnix(p->target.unix.pathname, p->type, p->timeout);
        if (S) {
                S->Port = p;
                TRY
                {
                        p->protocol->check(S);
                }
                FINALLY
                {
                        Socket_free(&S);
                }
                END_TRY;
        } else {
                THROW(IOException, "Cannot create unix socket for %s", p->target.unix.pathname);
        }
}


static void _testIp(Port_T p) {
        char error[512];
        volatile Connection_State is_available = Connection_Failed;
        struct addrinfo *result = _resolve(p->hostname, p->target.net.port, p->type, p->family);
        if (result) {
                // The host may resolve to multiple IPs and if at least one succeeded, we have no problem and don't have to flood the log with partial errors => log only the last error
                for (struct addrinfo *r = result; r && is_available != Connection_Ok; r = r->ai_next) {
                        if (p->outgoing.addrlen == 0 || p->outgoing.addrlen == r->ai_addrlen) {
                                const struct sockaddr *localaddr = p->outgoing.addrlen ? (struct sockaddr *)&(p->outgoing.addr) : NULL;
                                volatile T S = NULL;
                                TRY
                                {
                                        S = _createIpSocket(p->hostname, r->ai_addr, r->ai_addrlen, localaddr, p->outgoing.addrlen, r->ai_family, r->ai_socktype, r->ai_protocol, &(p->target.net.ssl.options), p->timeout);
                                        S->Port = p;
                                        TRY
                                        {
                                                p->protocol->check(S);
                                        }
                                        FINALLY
                                        {
#ifdef HAVE_OPENSSL
                                                // Set the minimum valid days past the protocol check as if the connection uses STARTTLS to switch plain->SSL, we have no SSL certificate informations until the STARTTTLS is performed.
                                                // Try to collect the certificate validDays even on protocol exception - the protocol test may fail on higher level (e.g. when HTTP returns 400), but we can still get certificate info
                                                p->target.net.ssl.certificate.validDays = Ssl_getCertificateValidDays(S->ssl);
#endif
                                        }
                                        END_TRY;
                                        is_available = Connection_Ok;

                                }
                                ELSE
                                {
                                        snprintf(error, sizeof(error), "%s", Exception_frame.message);
                                        DEBUG("Socket test failed for %s -- %s\n", _addressToString(r->ai_addr, r->ai_addrlen, (char[STRLEN]){}, STRLEN), error);
                                }
                                FINALLY
                                {
                                        if (S)
                                                Socket_free((Socket_T *)&S);
                                }
                                END_TRY;
                        } else {
                                snprintf(error, sizeof(error), "No IP address matching '%s' was found", p->outgoing.ip);
                        }
                }
                freeaddrinfo(result);
                if (is_available != Connection_Ok)
                        THROW(IOException, "%s", error);
        } else {
                THROW(IOException, "Cannot resolve [%s]:%d", p->hostname, p->target.net.port);
        }
}


/* ---------------------------------------------------------------- Public */


void Socket_test(void *P) {
        ASSERT(P);
        Port_T p = P;
        TRY
        {
                int64_t start = Time_micro();
                switch (p->family) {
                        case Socket_Unix:
                                _testUnix(p);
                                break;
                        case Socket_Ip:
                        case Socket_Ip4:
                        case Socket_Ip6:
                                _testIp(p);
                                break;
                        default:
                                THROW(IOException, "Invalid socket family %d\n", p->family);
                                break;
                }
                p->response = (double)(Time_micro() - start) / 1000.; // Convert microseconds to milliseconds
                p->is_available = Connection_Ok;
        }
        ELSE
        {
                p->is_available = Connection_Failed;
                p->response = -1.;
                RETHROW;
        }
        END_TRY;
}


void Socket_enableSsl(T S, SslOptions_T options, const char *name)  {
        assert(S);
#ifdef HAVE_OPENSSL
        if ((S->ssl = Ssl_new(options)))
                Ssl_connect(S->ssl, S->socket, S->timeout, name);
#endif
}


int Socket_print(T S, const char *m, ...) {
        int n;
        va_list ap;
        char *buf = NULL;
        ASSERT(S);
        ASSERT(m);
        va_start(ap, m);
        buf = Str_vcat(m, ap);
        va_end(ap);
        n = Socket_write(S, buf, strlen(buf));
        FREE(buf);
        return n;
}


int Socket_write(T S, void *b, size_t size) {
        ssize_t n = 0;
        void *p = b;
        ASSERT(S);
        while (size > 0) {
#ifdef HAVE_OPENSSL
                if (S->ssl) {
                        n = Ssl_write(S->ssl, p, (int)size, S->timeout);
                } else {
#endif
                        n = Net_write(S->socket, p, size, S->timeout);
#ifdef HAVE_OPENSSL
                }
#endif
                if (n <= 0)
                        break;
                p += n;
                size -= n;

        }
        if (n < 0) {
                /* No write or a partial write is an error */
                return -1;
        }
        return  (int)(p - b);
}


int Socket_readByte(T S) {
        ASSERT(S);
        if (S->offset >= S->length)
                if (_fill(S, S->timeout) <= 0)
                        return -1;
        return S->buffer[S->offset++];
}


int Socket_read(T S, void *b, int size) {
        int c;
        unsigned char *p = b;
        ASSERT(S);
        while ((size-- > 0) && ((c = Socket_readByte(S)) >= 0))
                *p++ = c;
        return (int)((long)p - (long)b);
}


char *Socket_readLine(T S, char *s, int size) {
        int c;
        unsigned char *p = (unsigned char *)s;
        ASSERT(S);
        while (--size && ((c = Socket_readByte(S)) > 0)) { // Stop when \0 is read
                *p++ = c;
                if (c == '\n')
                        break;
        }
        *p = 0;
        if (*s)
                return s;
        return NULL;
}

