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

#ifdef NEED_SOCKLEN_T_DEFINED
#define _BSD_SOCKLEN_T_
#endif

#ifdef HAVE_NETINET_IN_SYSTM_H
#include <netinet/in_systm.h>
#endif

#ifdef HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif

#ifdef HAVE_SYS_UN_H
#include <sys/un.h>
#endif

#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif

#ifdef HAVE_FCNTL_H
#include <fcntl.h>
#endif

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif

#ifdef HAVE_SIGNAL_H
#include <signal.h>
#endif

#ifdef HAVE_NET_IF_H
#include <net/if.h>
#endif

#ifdef HAVE_NETDB_H
#include <netdb.h>
#endif

#ifdef HAVE_SYS_TIME_H
#include <sys/time.h>
#endif

#ifdef HAVE_SYS_FILIO_H
#include <sys/filio.h>
#endif

#ifdef HAVE_SYS_IOCTL_H
#include <sys/ioctl.h>
#endif

#ifdef HAVE_SYS_FILIO_H
#include <sys/filio.h>
#endif

#ifdef HAVE_NETINET_IP_H
#include <netinet/ip.h>
#endif

#ifdef HAVE_NETINET_IP_ICMP_H
#include <netinet/ip_icmp.h>
#endif

#ifdef HAVE_NETINET_ICMP6_H
#include <netinet/icmp6.h>
#endif

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#ifdef HAVE_STDDEF_H
#include <stddef.h>
#else
#define offsetof(st, m) ((size_t) ( (char *)&((st *)(0))->m - (char *)0 ))
#endif

#ifdef HAVE_SYS_STAT_H
#include <sys/stat.h>
#endif

#ifndef __dietlibc__
#ifdef HAVE_STROPTS_H
#include <stropts.h>
#endif
#endif

#ifdef HAVE_ARPA_INET_H
#include <arpa/inet.h>
#endif

#include "monit.h"
#include "net.h"

// libmonit
#include "system/Net.h"
#include "system/Time.h"
#include "exceptions/AssertException.h"
#include "exceptions/IOException.h"


/**
 *  General purpose Network and Socket methods.
 *
 *  @file
 */


/* ----------------------------------------------------------------- Private */


/*
 * Compute Internet Checksum for "count" bytes beginning at location "addr".
 * Based on RFC1071.
 */
static unsigned short _checksum(unsigned char *_addr, int count) {
        register long sum = 0;
        unsigned short *addr = (unsigned short *)_addr;
        while (count > 1) {
                sum += *addr++;
                count -= 2;
        }
        /* Add left-over byte, if any */
        if (count > 0)
                sum += *(unsigned char *)addr;
        /* Fold 32-bit sum to 16 bits */
        while (sum >> 16)
                sum = (sum & 0xffff) + (sum >> 16);
        return ~sum;
}


static void __attribute__((format (printf, 3, 4))) _LogWarningOrError(int attempt, int maxAttempts, const char *s, ...) {
        ASSERT(s);
        va_list ap;
        va_start(ap, s);
        if (attempt < maxAttempts) {
                vLogWarning(s, ap);
        } else {
                vLogError(s, ap);
        }
        va_end(ap);
}


/* ------------------------------------------------------------------ Public */


int create_server_socket_tcp(const char *address, int port, Socket_Family family, int backlog, char error[STRLEN]) {
        struct addrinfo *result, hints = {
                .ai_flags = AI_PASSIVE,
                .ai_socktype = SOCK_STREAM,
                .ai_protocol = IPPROTO_TCP
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
                        break;
#endif
                default:
                        snprintf(error, STRLEN, "Invalid socket family %d", family);
                        return -1;
        }
        char _port[6];
        snprintf(_port, sizeof(_port), "%d", port);
        int status = getaddrinfo(address, _port, &hints, &result);
        if (status) {
                snprintf(error, STRLEN, "Cannot translate %s socket [%s]:%d -- %s", socketnames[family], NVLSTR(address), port, status == EAI_SYSTEM ? STRERROR : gai_strerror(status));
                return -1;
        }
        int flag = 1;
        for (struct addrinfo *_result = result; _result; _result = _result->ai_next) {
                int s = socket(_result->ai_family, _result->ai_socktype, _result->ai_protocol);
                if (s != -1) {
                        if (setsockopt(s, SOL_SOCKET, SO_REUSEADDR, (char *)&flag, sizeof(flag)) == 0) {
                                if (Net_setNonBlocking(s)) {
                                        if (fcntl(s, F_SETFD, FD_CLOEXEC) != -1) {
                                                if (family != Socket_Ip6 || setsockopt(s, IPPROTO_IPV6, IPV6_V6ONLY, &flag, sizeof(flag)) == 0) {
                                                        if (bind(s, _result->ai_addr, _result->ai_addrlen) == 0) {
                                                                if (listen(s, backlog) == 0) {
                                                                        freeaddrinfo(result);
                                                                        return s;
                                                                } else {
                                                                        snprintf(error, STRLEN, "Cannot listen: %s", STRERROR);
                                                                }
                                                        } else {
                                                                snprintf(error, STRLEN, "Cannot bind: %s", STRERROR);
                                                        }
                                                } else {
                                                        snprintf(error, STRLEN, "Cannot set IPV6_V6ONLY option: %s", STRERROR);
                                                }
                                        } else {
                                                snprintf(error, STRLEN, "Cannot set close on exec option: %s", STRERROR);
                                        }
                                } else {
                                        snprintf(error, STRLEN, "Cannot set nonblocking socket: %s", STRERROR);
                                }
                        } else {
                                snprintf(error, STRLEN, "Cannot set reuseaddr option: %s", STRERROR);
                        }
                        if (close(s) < 0)
                                LogError("Server socket %d close failed: %s\n", s, STRERROR);
                } else {
                        snprintf(error, STRLEN, "Cannot create socket: %s", STRERROR);
                }
        }
        freeaddrinfo(result);
        return -1;
}


int create_server_socket_unix(const char *path, int backlog, char error[STRLEN]) {
        int s = socket(AF_UNIX, SOCK_STREAM, 0);
        if (s < 0) {
                snprintf(error, STRLEN, "Cannot create socket -- %s", STRERROR);
                return -1;
        }
        struct sockaddr_un addr = {
                .sun_family = AF_UNIX
        };
        snprintf(addr.sun_path, sizeof(addr.sun_path), "%s", path);
        if (Net_setNonBlocking(s)) {
                if (fcntl(s, F_SETFD, FD_CLOEXEC) != -1) {
                        if (bind(s, (struct sockaddr *)&addr, sizeof(struct sockaddr_un)) == 0) {
                                if (listen(s, backlog) == 0) {
                                        return s;
                                } else {
                                        snprintf(error, STRLEN, "Cannot listen -- %s", STRERROR);
                                }
                        } else {
                                snprintf(error, STRLEN, "Cannot bind -- %s", STRERROR);
                        }
                } else {
                        snprintf(error, STRLEN, "Cannot set close on exec option -- %s", STRERROR);
                }
        } else {
                snprintf(error, STRLEN, "Cannot set nonblocking socket: %s", STRERROR);
        }
        if (close(s) < 0)
                LogError("Socket %d close failed -- %s\n", s, STRERROR);
        return -1;
}


static void _setPingOptions(int socket, struct addrinfo *addr) {
#ifdef HAVE_IPV6
        struct icmp6_filter filter;
        ICMP6_FILTER_SETBLOCKALL(&filter);
        ICMP6_FILTER_SETPASS(ICMP6_ECHO_REPLY, &filter);
#endif
        int ttl = 255;
        switch (addr->ai_family) {
                case AF_INET:
                        if (setsockopt(socket, IPPROTO_IP, IP_TTL, &ttl, sizeof(ttl)) < 0)
                                LogError("Ping: setsockopt for TTL failed -- %s\n", System_getLastError());
                        break;
#ifdef HAVE_IPV6
                case AF_INET6:
                        if (setsockopt(socket, IPPROTO_IPV6, IPV6_MULTICAST_HOPS, &ttl, sizeof(ttl)) < 0)
                                LogError("Ping: setsockopt for multicast hops failed -- %s\n", System_getLastError());
                        if (setsockopt(socket, IPPROTO_IPV6, IPV6_UNICAST_HOPS, &ttl, sizeof(ttl)) < 0)
                                LogError("Ping: setsockopt for unicast hops failed -- %s\n", System_getLastError());
                        if (setsockopt(socket, IPPROTO_ICMPV6, ICMP6_FILTER, &filter, sizeof(struct icmp6_filter)) < 0)
                                LogError("Ping: setsockopt for filter failed -- %s\n", System_getLastError());
                        break;
#endif
                default:
                        break;
        }
}


static boolean_t _sendPing(const char *hostname, int socket, struct addrinfo *addr, int size, int retry, int maxretries, int id, int64_t started) {
        char buf[ICMP_MAXSIZE] = {};
        int header_len = 0;
        int out_len = 0;
        void *out_icmp = NULL;
        struct icmp *out_icmp4;
#ifdef HAVE_IPV6
        struct icmp6_hdr *out_icmp6;
#endif
        switch (addr->ai_family) {
                case AF_INET:
                        out_icmp4 = (struct icmp *)buf;
                        out_icmp4->icmp_type = ICMP_ECHO;
                        out_icmp4->icmp_code = 0;
                        out_icmp4->icmp_cksum = 0;
                        out_icmp4->icmp_id = htons(id);
                        out_icmp4->icmp_seq = htons(retry);
                        memcpy((int64_t *)(out_icmp4->icmp_data), &started, sizeof(int64_t)); // set data to timestamp
                        header_len = offsetof(struct icmp, icmp_data);
                        out_len = header_len + size;
                        out_icmp4->icmp_cksum = _checksum((unsigned char *)out_icmp4, out_len); // IPv4 requires checksum computation
                        out_icmp = out_icmp4;
                        break;
#ifdef HAVE_IPV6
                case AF_INET6:
                        out_icmp6 = (struct icmp6_hdr *)buf;
                        out_icmp6->icmp6_type = ICMP6_ECHO_REQUEST;
                        out_icmp6->icmp6_code = 0;
                        out_icmp6->icmp6_cksum = 0;
                        out_icmp6->icmp6_id = htons(id);
                        out_icmp6->icmp6_seq = htons(retry);
                        memcpy((int64_t *)(out_icmp6 + 1), &started, sizeof(int64_t)); // set data to timestamp
                        header_len = sizeof(struct icmp6_hdr);
                        out_len = header_len + size;
                        out_icmp = out_icmp6;
                        break;
#endif
                default:
                        break;
        }
        if (out_len > sizeof(buf)) {
                _LogWarningOrError(retry, maxretries, "Ping request for %s %d/%d failed -- too large (%d vs. maximum %lu bytes)\n", hostname, retry, maxretries, size, (unsigned long)(sizeof(buf) - header_len));
                return false;
        }
        ssize_t n;
        do {
                n = sendto(socket, out_icmp, out_len, 0, addr->ai_addr, addr->ai_addrlen);
        } while (n == -1 && errno == EINTR);
        if (n < 0) {
                _LogWarningOrError(retry, maxretries, "Ping request for %s %d/%d failed -- %s\n", hostname, retry, maxretries, STRERROR);
                return false;
        }
        return true;
}


static double _receivePing(const char *hostname, int socket, struct addrinfo *addr, int retry, int maxretries, int out_id, int64_t started, int timeout) {
        int in_len = 0, read_timeout = timeout;
        uint16_t in_id = 0, in_seq = 0;
        unsigned char *data = NULL;
        struct icmp *in_icmp4;
        struct ip *in_iphdr4;
#ifdef HAVE_IPV6
        struct icmp6_hdr *in_icmp6;
#endif
        ssize_t n;
        char buf[ICMP_MAXSIZE] = {};
        switch (addr->ai_family) {
                case AF_INET:
                        in_len = 36; // 20 bytes for IP header + 8 bytes for minimum ICMP fields (type, code, checksum, id, seq) + 8 bytes for data payload
                        break;
#ifdef HAVE_IPV6
                case AF_INET6:
                        in_len = sizeof(struct icmp6_hdr);
                        break;
#endif
                default:
                        break;
        }
        while (read_timeout > 0 && Net_canRead(socket, read_timeout)) {
                if (Run.flags & Run_Stopped) {
                        return -1.;
                }
                int64_t stopped = Time_micro();
                struct sockaddr_storage in_addr;
                socklen_t addrlen = sizeof(in_addr);
                boolean_t in_addrmatch = false, in_typematch = false;
                do {
                        n = recvfrom(socket, buf, sizeof(buf), 0, (struct sockaddr *)&in_addr, &addrlen);
                } while (n == -1 && errno == EINTR);
                if (n < 0) {
                        _LogWarningOrError(retry, maxretries, "Ping response from %s %d/%d failed -- %s\n", hostname, retry, maxretries, STRERROR);
                        return -1.;
                } else if (n >= in_len) {
                        /* read from raw socket via recvfrom() provides messages regardless of origin, we have to check the IP and skip responses belonging to other conversations or different ICMP types (n < in_len) */
                        switch (in_addr.ss_family) {
                                case AF_INET:
                                        in_addrmatch = memcmp(&((struct sockaddr_in *)&in_addr)->sin_addr, &((struct sockaddr_in *)(addr->ai_addr))->sin_addr, sizeof(struct in_addr)) ? false : true;
                                        in_iphdr4 = (struct ip *)buf;
                                        in_icmp4 = (struct icmp *)(buf + in_iphdr4->ip_hl * 4);
                                        in_typematch = in_icmp4->icmp_type == ICMP_ECHOREPLY ? true : false;
                                        in_id = ntohs(in_icmp4->icmp_id);
                                        in_seq = ntohs(in_icmp4->icmp_seq);
                                        data = (unsigned char *)in_icmp4->icmp_data;
                                        break;
#ifdef HAVE_IPV6
                                case AF_INET6:
                                        in_addrmatch = memcmp(&((struct sockaddr_in6 *)&in_addr)->sin6_addr, &((struct sockaddr_in6 *)(addr->ai_addr))->sin6_addr, sizeof(struct in6_addr)) ? false : true;
                                        in_icmp6 = (struct icmp6_hdr *)buf;
                                        in_typematch = in_icmp6->icmp6_type == ICMP6_ECHO_REPLY ? true : false;
                                        in_id = ntohs(in_icmp6->icmp6_id);
                                        in_seq = ntohs(in_icmp6->icmp6_seq);
                                        data = (unsigned char *)(in_icmp6 + 1);
                                        break;
#endif
                                default:
                                        LogError("Invalid address family: %d\n", in_addr.ss_family);
                                        return -1.;
                        }
                }
                if (n < in_len || in_addr.ss_family != addr->ai_family || ! in_addrmatch || ! in_typematch || in_id != out_id || in_seq > (uint16_t)maxretries) {
                        // Try to read next packet, but don't exceed the timeout while waiting for our response so we won't loop forever if the socket is flooded with other ICMP packets
                        if (stopped < started) {
                                // Time jumped
                                break;
                        } else {
                                read_timeout = timeout - (stopped - started) / 1000.;
                        }
                } else {
                        memcpy(&started, data, sizeof(int64_t));
                        double response = (double)(stopped - started) / 1000.; // Convert microseconds to milliseconds
                        DEBUG("Ping response for %s %d/%d succeeded -- received id=%d sequence=%d response_time=%s\n", hostname, retry, maxretries, in_id, in_seq, Str_time2str(response, (char[11]){}));
                        return response; // Wait for one response only
                }
        }
        _LogWarningOrError(retry, maxretries, "Ping response for %s %d/%d timed out -- no response within %s\n", hostname, retry, maxretries, Str_time2str(timeout, (char[11]){}));
        return -1.;
}


double icmp_echo(const char *hostname, Socket_Family family, Outgoing_T *outgoing, int size, int timeout, int maxretries) {
        ASSERT(hostname);
        ASSERT(size > 0);
        int rv;
        double response = -1.;
        struct addrinfo *result, hints = {};
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
                        break;
#endif
                default:
                        LogError("Invalid socket family %d\n", family);
                        return response;
        }
        int status = getaddrinfo(hostname, NULL, &hints, &result);
        if (status) {
                LogError("Ping for %s -- getaddrinfo failed: %s\n", hostname, status == EAI_SYSTEM ? STRERROR : gai_strerror(status));
                return response;
        }
        struct addrinfo *addr = result;
        int s = -1;
        while (addr && s < 0) {
                if (outgoing->addrlen == 0 || outgoing->addrlen == addr->ai_addrlen) {
                        switch (addr->ai_family) {
                                case AF_INET:
                                        s = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP);
                                        break;
#ifdef HAVE_IPV6
                                case AF_INET6:
                                        s = socket(AF_INET6, SOCK_RAW, IPPROTO_ICMPV6);
                                        break;
#endif
                                default:
                                        break;
                        }
                        if (s >= 0 && outgoing->ip) {
                                if (bind(s, (struct sockaddr *)&(outgoing->addr), outgoing->addrlen) < 0) {
                                        LogError("Cannot bind to outgoing address -- %s\n", STRERROR);
                                        goto error1;
                                }
                        }
                }
                if (s < 0)
                        addr = addr->ai_next;
        }
        if (s < 0) {
                if (errno == EACCES || errno == EPERM) {
                        DEBUG("Ping for %s -- cannot create socket: %s\n", hostname, STRERROR);
                        response = -2.;
                } else {
                        LogError("Ping for %s -- cannot create socket: %s\n", hostname, STRERROR);
                }
                goto error2;
        }
        _setPingOptions(s, addr);
        uint16_t id = getpid() & 0xFFFF;
        for (int retry = 1; retry <= maxretries && ! (Run.flags & Run_Stopped); retry++) {
                int64_t started = Time_micro();
                if (_sendPing(hostname, s, addr, size, retry, maxretries, id, started) && (response = _receivePing(hostname, s, addr, retry, maxretries, id, started, timeout)) >= 0.)
                        break;
        }
error1:
        do {
                rv = close(s);
        } while (rv == -1 && errno == EINTR);
        if (rv == -1)
                LogError("Socket %d close failed -- %s\n", s, STRERROR);
error2:
        freeaddrinfo(result);
        return response;
}

