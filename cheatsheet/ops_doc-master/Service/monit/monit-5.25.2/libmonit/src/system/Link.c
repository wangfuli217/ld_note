/*
 * Copyright (C) Tildeslash Ltd. All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
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


#include "Config.h"

#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <unistd.h>
#include <sys/ioctl.h>
#ifdef HAVE_IFADDRS_H
#include <ifaddrs.h>
#endif
#ifdef HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif
#ifdef HAVE_NET_IF_H
#include <net/if.h>
#endif
#ifdef HAVE_NET_IF_MEDIA_H
#include <net/if_media.h>
#endif
#ifdef HAVE_KSTAT_H
#include <kstat.h>
#endif
#ifdef HAVE_SYS_SYSCTL_H
#include <sys/sysctl.h>
#endif
#ifdef HAVE_NET_ROUTE_H
#include <net/route.h>
#endif
#ifdef HAVE_NET_IF_DL_H
#include <net/if_dl.h>
#endif
#ifdef HAVE_LIBPERFSTAT_H
#include <sys/protosw.h>
#include <libperfstat.h>
#endif

#include "system/Link.h"
#include "system/Time.h"
#include "system/System.h"
#include "Str.h"


/**
 * Implementation of the Statistics Facade for Unix Systems.
 *
 * @author http://www.tildeslash.com/
 * @see http://www.mmonit.com/
 * @file
 */


/* ------------------------------------------------------------- Definitions */


#define T Link_T


static struct {
        struct ifaddrs *addrs;
        uint64_t timestamp;
} _stats = {};


typedef struct LinkData_T {
#ifndef __LP64__
        unsigned long long raw;
#endif
        unsigned long long last;
        unsigned long long now;
        unsigned long long minute[60];
        unsigned long long hour[24];
} LinkData_T;


struct T {
        char *object;
        const char *(*resolve)(const char *object); // Resolve Object -> Interface, set during Link_T instantiation by constructor (currently we implement only IPAddress -> Interface lookup)
        struct {
                unsigned long long last;
                unsigned long long now;
        } timestamp;
        int state;       // State (-1 = N/A, 0 = down, 1 = up)
        int duplex;      // Duplex (-1 = N/A, 0 = half, 1 = full)
        long long speed; // Speed [bps]
        LinkData_T ipackets;  // Packets received on interface
        LinkData_T ierrors;   // Input errors on interface
        LinkData_T ibytes;    // Total number of octets received
        LinkData_T opackets;  // Packets sent on interface
        LinkData_T oerrors;   // Output errors on interface
        LinkData_T obytes;    // Total number of octets sent
};


/* ----------------------------------------------------- Static destructor */


static void __attribute__ ((destructor)) _destructor() {
#ifdef HAVE_IFADDRS_H
        if (_stats.addrs)
                freeifaddrs(_stats.addrs);
#endif
}


/* --------------------------------------------------------------- Private */


static void _updateValue(LinkData_T *data, unsigned long long raw) {
       unsigned long long value = raw;
#ifndef __LP64__
        if (raw < data->raw)
                value = data->now + ULONG_MAX + 1ULL - data->raw + raw; // Counter wrapped
        else
                value = data->now + raw - data->raw; 
       data->raw = raw;
#endif
       data->last = data->now;
       data->now = value;
}


#if defined DARWIN
#include "os/macosx/Link.inc"
#elif defined FREEBSD
#include "os/freebsd/Link.inc"
#elif defined OPENBSD
#include "os/openbsd/Link.inc"
#elif defined NETBSD
#include "os/netbsd/Link.inc"
#elif defined DRAGONFLY
#include "os/dragonfly/Link.inc"
#elif defined LINUX
#include "os/linux/Link.inc"
#elif defined SOLARIS
#include "os/solaris/Link.inc"
#elif defined AIX
#include "os/aix/Link.inc"
#endif


static void _resetData(LinkData_T *data, unsigned long long value) {
#ifndef __LP64__
        data->raw = value;
#endif
        data->last = data->now = value;
        for (int i = 0; i < 60; i++)
                data->minute[i] = value;
        for (int i = 0; i < 24; i++)
                data->hour[i] = value;
}


static void _reset(T L) {
        L->timestamp.last = L->timestamp.now = 0ULL;
        L->speed = -1LL;
        L->state = L->duplex = -1;
        _resetData(&(L->ibytes), 0ULL);
        _resetData(&(L->ipackets), 0ULL);
        _resetData(&(L->ierrors), 0ULL);
        _resetData(&(L->obytes), 0ULL);
        _resetData(&(L->opackets), 0ULL);
        _resetData(&(L->oerrors), 0ULL);
}


static unsigned long long _deltaSecond(T L, LinkData_T *data) {
        if (L->timestamp.last > 0 && L->timestamp.now > L->timestamp.last)
                if (data->last > 0 && data->now > data->last)
                        return (unsigned long long)((data->now - data->last) * 1000. / (L->timestamp.now - L->timestamp.last));
        return 0ULL;
}


static unsigned long long _deltaMinute(T L, LinkData_T *data, int count) {
        int stop = Time_minutes(L->timestamp.now / 1000.);
        int delta = stop - count;
        int start = delta < 0 ? 60 + delta : delta;
        if (start == stop) // count == 60 (wrap)
                start = start < 59 ? start + 1 : 0;
        assert(start >= 0 && start < 60);
        assert(stop >= 0 && stop < 60);
        return data->minute[stop] - data->minute[start];
}


static unsigned long long _deltaHour(T L, LinkData_T *data, int count) {
        int stop = Time_hour(L->timestamp.now / 1000.);
        int delta = stop - count;
        int start = delta < 0 ? 24 + delta : delta;
        if (start == stop) // count == 24 (wrap)
                start = start < 23 ? start + 1 : 0;
        assert(start >= 0 && start < 24);
        assert(stop >= 0 && stop < 24);
        return data->hour[stop] - data->hour[start];
}


static const char *_findInterfaceForAddress(const char *address) {
#ifdef HAVE_IFADDRS_H
        for (struct ifaddrs *a = _stats.addrs; a != NULL; a = a->ifa_next) {
                if (a->ifa_addr == NULL)
                        continue;
                int s;
                char host[NI_MAXHOST];
                if (a->ifa_addr->sa_family == AF_INET)
                        s = getnameinfo(a->ifa_addr, sizeof(struct sockaddr_in), host, NI_MAXHOST, NULL, 0, NI_NUMERICHOST);
#ifdef HAVE_IPV6
                else if (a->ifa_addr->sa_family == AF_INET6)
                        s = getnameinfo(a->ifa_addr, sizeof(struct sockaddr_in6), host, NI_MAXHOST, NULL, 0, NI_NUMERICHOST);
#endif
                else
                        continue;
                if (s != 0)
                        THROW(AssertException, "Cannot translate address to interface -- %s", gai_strerror(s));
                if (Str_isEqual(address, host))
                        return a->ifa_name;
        }
        THROW(AssertException, "Address %s not found", address);
#else
        THROW(AssertException, "Network monitoring by IP address is not supported on this platform, please use 'check network <foo> with interface <bar>' instead");
#endif
        return NULL;
}


static const char *_returnInterface(const char *interface) {
        return interface;
}


static void _updateHistory(T L) {
        if (L->timestamp.last == 0ULL) {
                // Initialize the history on first update, so we can start accounting for total data immediately. Any delta will show difference between the very first value and then given point in time, until regular update cycle
                _resetData(&(L->ibytes), L->ibytes.now);
                _resetData(&(L->ipackets), L->ipackets.now);
                _resetData(&(L->ierrors), L->ierrors.now);
                _resetData(&(L->obytes), L->obytes.now);
                _resetData(&(L->opackets), L->opackets.now);
                _resetData(&(L->oerrors), L->oerrors.now);
        } else {
                // Update relative values only
                time_t now = L->timestamp.now / 1000.;
                int minute = Time_minutes(now);
                int hour =  Time_hour(now);
                L->ibytes.minute[minute] = L->ibytes.hour[hour] = L->ibytes.now;
                L->ipackets.minute[minute] = L->ipackets.hour[hour] = L->ipackets.now;
                L->ierrors.minute[minute] = L->ierrors.hour[hour] = L->ierrors.now;
                L->obytes.minute[minute] = L->obytes.hour[hour] = L->obytes.now;
                L->opackets.minute[minute] = L->opackets.hour[hour] = L->opackets.now;
                L->oerrors.minute[minute] = L->oerrors.hour[hour] = L->oerrors.now;
        }
}


static void _updateCache() {
#ifdef HAVE_IFADDRS_H
        uint64_t now = Time_milli();
        // Refresh only if the statistics are older then 1 second (handle also backward time jumps)
        if (now > _stats.timestamp + 1000 || now < _stats.timestamp - 1000) {
                _stats.timestamp = now;
                if (_stats.addrs) {
                        freeifaddrs(_stats.addrs);
                        _stats.addrs = NULL;
                }
                if (getifaddrs(&(_stats.addrs)) == -1) {
                        _stats.timestamp = 0ULL;
                        THROW(AssertException, "Cannot get network statistics -- %s", System_getError(errno));
                }
        }
#endif
}


/* ---------------------------------------------------------------- Public */


T Link_createForAddress(const char *address) {
        assert(address);
        T L;
        NEW(L);
        _reset(L);
        L->object = Str_dup(address);
        L->resolve = _findInterfaceForAddress;
        return L;
}


T Link_createForInterface(const char *interface) {
        assert(interface);
        T L;
        NEW(L);
        _reset(L);
        L->object = Str_dup(interface);
        L->resolve = _returnInterface;
        return L;
}


void Link_free(T *L) {
        FREE((*L)->object);
        FREE(*L);
}


void Link_reset(T L) {
        _reset(L);
}


int Link_isGetByAddressSupported() {
#ifdef HAVE_IFADDRS_H
        return true;
#else
        return false;
#endif
}


void Link_update(T L) {
        _updateCache();
        const char *interface = L->resolve(L->object);
        if (_update(L, interface))
                _updateHistory(L);
        else
                THROW(AssertException, "Cannot udate network statistics -- interface %s not found", interface);
}


long long Link_getBytesInPerSecond(T L) {
        assert(L);
        return L->state > 0 ? _deltaSecond(L, &(L->ibytes)) : -1LL;
}


long long Link_getBytesInPerMinute(T L, int count) {
        assert(L);
        return L->state > 0 ? _deltaMinute(L, &(L->ibytes), count) : -1LL;
}


long long Link_getBytesInPerHour(T L, int count) {
        assert(L);
        return L->state > 0 ? _deltaHour(L, &(L->ibytes), count) : -1LL;
}


long long Link_getBytesInTotal(T L) {
        assert(L);
        return L->state > 0 ? L->ibytes.now : -1LL;
}


double Link_getSaturationInPerSecond(T L) {
        assert(L);
        return L->state > 0 && L->speed ? (double)Link_getBytesInPerSecond(L) * 8. * 100. / L->speed : -1.;
}


long long Link_getPacketsInPerSecond(T L) {
        assert(L);
        return L->state > 0 ? _deltaSecond(L, &(L->ipackets)) : -1LL;
}


long long Link_getPacketsInPerMinute(T L, int count) {
        assert(L);
        return L->state > 0 ? _deltaMinute(L, &(L->ipackets), count) : -1LL;
}


long long Link_getPacketsInPerHour(T L, int count) {
        assert(L);
        return L->state > 0 ? _deltaHour(L, &(L->ipackets), count) : -1LL;
}


long long Link_getPacketsInTotal(T L) {
        assert(L);
        return L->state > 0 ? L->ipackets.now : -1LL;
}


long long Link_getErrorsInPerSecond(T L) {
        assert(L);
        return L->state > 0 ? _deltaSecond(L, &(L->ierrors)) : -1LL;
}


long long Link_getErrorsInPerMinute(T L, int count) {
        assert(L);
        return L->state > 0 ? _deltaMinute(L, &(L->ierrors), count) : -1LL;
}


long long Link_getErrorsInPerHour(T L, int count) {
        assert(L);
        return L->state > 0 ? _deltaHour(L, &(L->ierrors), count) : -1LL;
}


long long Link_getErrorsInTotal(T L) {
        assert(L);
        return L->state > 0 ? L->ierrors.now : -1LL;
}


long long Link_getBytesOutPerSecond(T L) {
        assert(L);
        return L->state > 0 ? _deltaSecond(L, &(L->obytes)) : -1LL;
}


long long Link_getBytesOutPerMinute(T L, int count) {
        assert(L);
        return L->state > 0 ? _deltaMinute(L, &(L->obytes), count) : -1LL;
}


long long Link_getBytesOutPerHour(T L, int count) {
        assert(L);
        return L->state > 0 ? _deltaHour(L, &(L->obytes), count) : -1LL;
}


long long Link_getBytesOutTotal(T L) {
        assert(L);
        return L->state > 0 ? L->obytes.now : -1LL;
}


double Link_getSaturationOutPerSecond(T L) {
        assert(L);
        return L->state > 0 && L->speed ? (double)Link_getBytesOutPerSecond(L) * 8. * 100. / L->speed : -1.;
}


long long Link_getPacketsOutPerSecond(T L) {
        assert(L);
        return L->state > 0 ? _deltaSecond(L, &(L->opackets)) : -1LL;
}


long long Link_getPacketsOutPerMinute(T L, int count) {
        assert(L);
        return L->state > 0 ? _deltaMinute(L, &(L->opackets), count) : -1LL;
}


long long Link_getPacketsOutPerHour(T L, int count) {
        assert(L);
        return L->state > 0 ? _deltaHour(L, &(L->opackets), count) : -1LL;
}


long long Link_getPacketsOutTotal(T L) {
        assert(L);
        return L->state > 0 ? L->opackets.now : -1LL;
}


long long Link_getErrorsOutPerSecond(T L) {
        assert(L);
        return L->state > 0 ? _deltaSecond(L, &(L->oerrors)) : -1LL;
}


long long Link_getErrorsOutPerMinute(T L, int count) {
        assert(L);
        return L->state > 0 ? _deltaMinute(L, &(L->oerrors), count) : -1LL;
}


long long Link_getErrorsOutPerHour(T L, int count) {
        assert(L);
        return L->state > 0 ? _deltaHour(L, &(L->oerrors), count) : -1LL;
}


long long Link_getErrorsOutTotal(T L) {
        assert(L);
        return L->state > 0 ? L->oerrors.now : -1LL;
}


int Link_getState(T L) {
        assert(L);
        return L->state;
}


long long Link_getSpeed(T L) {
        assert(L);
        return L->state > 0 ? L->speed : -1LL;
}


int Link_getDuplex(T L) {
        assert(L);
        return L->state > 0 ? L->duplex : -1;
}

