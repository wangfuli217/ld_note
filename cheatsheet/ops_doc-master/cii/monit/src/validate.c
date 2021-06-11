
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

#ifdef HAVE_STDARG_H
#include <stdarg.h>
#endif

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_SIGNAL_H
#include <signal.h>
#endif

#ifdef HAVE_SETJMP_H
#include <setjmp.h>
#endif

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif

#ifdef HAVE_IFADDRS_H
#include <ifaddrs.h>
#endif

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#ifdef HAVE_SYS_TIME_H
#include <sys/time.h>
#endif

#ifdef HAVE_TIME_H
#include <time.h>
#endif

#ifdef HAVE_NETINET_IN_SYSTM_H
#include <netinet/in_systm.h>
#endif

#ifdef HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif

#ifdef HAVE_NETINET_IP_H
#include <netinet/ip.h>
#endif

#ifdef HAVE_NETINET_IP_ICMP_H
#include <netinet/ip_icmp.h>
#endif

#include "monit.h"
#include "alert.h"
#include "event.h"
#include "socket.h"
#include "net.h"
#include "device.h"
#include "ProcessTree.h"
#include "protocol.h"

// libmonit
#include "system/Time.h"
#include "io/File.h"
#include "io/InputStream.h"
#include "exceptions/AssertException.h"

/**
 *  Implementation of validation engine
 *
 *  @file
 */


/* ----------------------------------------------------------------- Private */


/**
 * Read program output. The output is saved to StringBuffer up to Run.limits.programOutput,
 * remaining bytes are dropped (must read whole output so the program doesn't hang on full
 * stdout / stderr pipe).
 */
static void _programOutput(InputStream_T I, StringBuffer_T S) {
        int n;
        char buf[STRLEN];
        InputStream_setTimeout(I, 0);
        do {
                n = InputStream_readBytes(I, buf, sizeof(buf) - 1);
                if (n > 0 && StringBuffer_length(S) < Run.limits.programOutput) {
                        buf[n] = 0;
                        StringBuffer_append(S, "%s", buf);
                }
        } while (n > 0);
}


/**
 * Test the connection and protocol
 */
static State_Type _checkConnection(Service_T s, Port_T p) {
        ASSERT(s);
        ASSERT(p);
        volatile int retry_count = p->retry;
        volatile State_Type rv = State_Succeeded;
        char buf[STRLEN];
        char report[1024] = {};
retry:
        TRY
        {
                Socket_test(p);
                rv = State_Succeeded;
                DEBUG("'%s' succeeded testing protocol [%s] at %s [response time %s]\n", s->name, p->protocol->name, Util_portDescription(p, buf, sizeof(buf)), Str_time2str(p->response, (char[11]){}));
        }
        ELSE
        {
                rv = State_Failed;
                snprintf(report, sizeof(report), "failed protocol test [%s] at %s -- %s", p->protocol->name, Util_portDescription(p, buf, sizeof(buf)), Exception_frame.message);
        }
        END_TRY;
        if (rv == State_Failed) {
                if (retry_count-- > 1) {
                        LogWarning("'%s' %s (attempt %d/%d)\n", s->name, report, p->retry - retry_count, p->retry);
                        goto retry;
                }
                Event_post(s, Event_Connection, State_Failed, p->action, "%s", report);
        } else {
                Event_post(s, Event_Connection, State_Succeeded, p->action, "connection succeeded to %s", Util_portDescription(p, buf, sizeof(buf)));
        }
        if (p->target.net.ssl.options.flags && p->target.net.ssl.certificate.validDays >= 0 && p->target.net.ssl.certificate.minimumDays > 0) {
                if (p->target.net.ssl.certificate.validDays < p->target.net.ssl.certificate.minimumDays) {
                        Event_post(s, Event_Timestamp, State_Failed, p->action, "certificate expiry in %d days matches check limit [valid > %d days]", p->target.net.ssl.certificate.validDays, p->target.net.ssl.certificate.minimumDays);
                        rv = State_Failed;
                } else {
                        Event_post(s, Event_Timestamp, State_Succeeded, p->action, "certificate valid days test succeeded [valid for %d days]", p->target.net.ssl.certificate.validDays);
                }
        }
        return rv;
}


/**
 * Test process state (e.g. Zombie)
 */
static State_Type _checkProcessState(Service_T s) {
        ASSERT(s);
        if (s->inf.process->zombie) {
                Event_post(s, Event_Data, State_Failed, s->action_DATA, "process with pid %d is a zombie", s->inf.process->pid);
                return State_Failed;
        }
        Event_post(s, Event_Data, State_Succeeded, s->action_DATA, "zombie check succeeded");
        return State_Succeeded;
}


/**
 * Test process pid for possible change since last cycle
 */
static State_Type _checkProcessPid(Service_T s) {
        ASSERT(s);
        if (s->inf.process->_pid < 0 || s->inf.process->pid < 0) // process pid was not initialized yet
                return State_Init;
        if (s->inf.process->_pid != s->inf.process->pid) {
                for (Pid_T l = s->pidlist; l; l = l->next)
                        Event_post(s, Event_Pid, State_Changed, l->action, "process PID changed from %d to %d", s->inf.process->_pid, s->inf.process->pid);
                return State_Changed;
        }
        for (Pid_T l = s->pidlist; l; l = l->next)
                Event_post(s, Event_Pid, State_ChangedNot, l->action, "process PID has not changed since last cycle");
        return State_ChangedNot;
}


/**
 * Test process ppid for possible change since last cycle
 */
static State_Type _checkProcessPpid(Service_T s) {
        ASSERT(s);
        if (s->inf.process->_ppid < 0 || s->inf.process->ppid < 0) // process ppid was not initialized yet
                return State_Init;
        if (s->inf.process->_ppid != s->inf.process->ppid) {
                for (Pid_T l = s->ppidlist; l; l = l->next)
                        Event_post(s, Event_PPid, State_Changed, l->action, "process PPID changed from %d to %d", s->inf.process->_ppid, s->inf.process->ppid);
                return State_Changed;
        }
        for (Pid_T l = s->ppidlist; l; l = l->next)
                Event_post(s, Event_PPid, State_ChangedNot, l->action, "process PPID has not changed since last cycle");
        return State_ChangedNot;
}


/**
 * Check process resources
 */
static State_Type _checkProcessResources(Service_T s, Resource_T r) {
        ASSERT(s);
        ASSERT(r);
        State_Type rv = State_Succeeded;
        char report[STRLEN] = {}, buf1[10], buf2[10];
        switch (r->resource_id) {
                case Resource_CpuPercent:
                        if (s->inf.process->cpu_percent < 0.) {
                                DEBUG("'%s' cpu usage check skipped (initializing)\n", s->name);
                                return State_Init;
                        } else if (Util_evalDoubleQExpression(r->operator, s->inf.process->cpu_percent, r->limit)) {
                                rv = State_Failed;
                                snprintf(report, STRLEN, "cpu usage of %.1f%% matches resource limit [cpu usage %s %.1f%%]", s->inf.process->cpu_percent, operatorshortnames[r->operator], r->limit);
                        } else {
                                snprintf(report, STRLEN, "cpu usage check succeeded [current cpu usage = %.1f%%]", s->inf.process->cpu_percent);
                        }
                        break;

                case Resource_CpuPercentTotal:
                        if (s->inf.process->total_cpu_percent < 0.) {
                                DEBUG("'%s' total cpu usage check skipped (initializing)\n", s->name);
                                return State_Init;
                        } else if (Util_evalDoubleQExpression(r->operator, s->inf.process->total_cpu_percent, r->limit)) {
                                rv = State_Failed;
                                snprintf(report, STRLEN, "total cpu usage of %.1f%% matches resource limit [cpu usage %s %.1f%%]", s->inf.process->total_cpu_percent, operatorshortnames[r->operator], r->limit);
                        } else {
                                snprintf(report, STRLEN, "total cpu usage check succeeded [current cpu usage = %.1f%%]", s->inf.process->total_cpu_percent);
                        }
                        break;

                case Resource_MemoryPercent:
                        if (s->inf.process->mem_percent < 0.) {
                                DEBUG("'%s' memory usage check skipped (initializing)\n", s->name);
                                return State_Init;
                        } else if (Util_evalDoubleQExpression(r->operator, s->inf.process->mem_percent, r->limit)) {
                                rv = State_Failed;
                                snprintf(report, STRLEN, "mem usage of %.1f%% matches resource limit [mem usage %s %.1f%%]", s->inf.process->mem_percent, operatorshortnames[r->operator], r->limit);
                        } else {
                                snprintf(report, STRLEN, "mem usage check succeeded [current mem usage = %.1f%%]", s->inf.process->mem_percent);
                        }
                        break;

                case Resource_MemoryKbyte:
                        if (s->inf.process->mem == 0) {
                                DEBUG("'%s' process memory usage check skipped (initializing)\n", s->name);
                                return State_Init;
                        } else if (Util_evalDoubleQExpression(r->operator, s->inf.process->mem, r->limit)) {
                                rv = State_Failed;
                                snprintf(report, STRLEN, "mem amount of %s matches resource limit [mem amount %s %s]", Str_bytes2str(s->inf.process->mem, buf1), operatorshortnames[r->operator], Str_bytes2str(r->limit, buf2));
                        } else {
                                snprintf(report, STRLEN, "mem amount check succeeded [current mem amount = %s]", Str_bytes2str(s->inf.process->mem, buf1));
                        }
                        break;

                case Resource_Threads:
                        if (s->inf.process->threads < 0) {
                                DEBUG("'%s' process threads count check skipped (initializing)\n", s->name);
                                return State_Init;
                        } else if (Util_evalDoubleQExpression(r->operator, s->inf.process->threads, r->limit)) {
                                rv = State_Failed;
                                snprintf(report, STRLEN, "threads count %i matches resource limit [threads %s %.0f]", s->inf.process->threads, operatorshortnames[r->operator], r->limit);
                        } else {
                                snprintf(report, STRLEN, "threads check succeeded [current threads = %i]", s->inf.process->threads);
                        }
                        break;

                case Resource_Children:
                        if (s->inf.process->children < 0) {
                                DEBUG("'%s' process children count check skipped (initializing)\n", s->name);
                                return State_Init;
                        } else if (Util_evalDoubleQExpression(r->operator, s->inf.process->children, r->limit)) {
                                rv = State_Failed;
                                snprintf(report, STRLEN, "children count %i matches resource limit [children %s %.0f]", s->inf.process->children, operatorshortnames[r->operator], r->limit);
                        } else {
                                snprintf(report, STRLEN, "children check succeeded [current children = %i]", s->inf.process->children);
                        }
                        break;

                case Resource_MemoryKbyteTotal:
                        if (s->inf.process->total_mem == 0) {
                                DEBUG("'%s' process total memory usage check skipped (initializing)\n", s->name);
                                return State_Init;
                        } else if (Util_evalDoubleQExpression(r->operator, s->inf.process->total_mem, r->limit)) {
                                rv = State_Failed;
                                snprintf(report, STRLEN, "total mem amount of %s matches resource limit [total mem amount %s %s]", Str_bytes2str(s->inf.process->total_mem, buf1), operatorshortnames[r->operator], Str_bytes2str(r->limit, buf2));
                        } else {
                                snprintf(report, STRLEN, "total mem amount check succeeded [current total mem amount = %s]", Str_bytes2str(s->inf.process->total_mem, buf1));
                        }
                        break;

                case Resource_MemoryPercentTotal:
                        if (s->inf.process->total_mem_percent < 0.) {
                                DEBUG("'%s' total memory usage check skipped (initializing)\n", s->name);
                                return State_Init;
                        } else if (Util_evalDoubleQExpression(r->operator, s->inf.process->total_mem_percent, r->limit)) {
                                rv = State_Failed;
                                snprintf(report, STRLEN, "total mem amount of %.1f%% matches resource limit [total mem amount %s %.1f%%]", (float)s->inf.process->total_mem_percent, operatorshortnames[r->operator], (float)r->limit);
                        } else {
                                snprintf(report, STRLEN, "total mem amount check succeeded [current total mem amount = %.1f%%]", s->inf.process->total_mem_percent);
                        }
                        break;

                case Resource_ReadBytes:
                        if (Statistics_initialized(&(s->inf.process->read.bytes))) {
                                double value = Statistics_deltaNormalize(&(s->inf.process->read.bytes));
                                if (Util_evalDoubleQExpression(r->operator, value, r->limit)) {
                                        rv = State_Failed;
                                        snprintf(report, STRLEN, "read rate %s/s matches resource limit [read %s %s/s]", Str_bytes2str(value, (char[10]){}), operatorshortnames[r->operator], Str_bytes2str(r->limit, (char[10]){}));
                                } else {
                                        snprintf(report, STRLEN, "read rate test succeeded [current read = %s/s]", Str_bytes2str(value, (char[10]){}));
                                }
                        } else {
                                DEBUG("'%s' warning -- no data are available for bytes read rate test\n", s->name);
                                return State_Init;
                        }
                        break;

                case Resource_ReadOperations:
                        if (Statistics_initialized(&(s->inf.process->read.operations))) {
                                double value = Statistics_deltaNormalize(&(s->inf.process->read.operations));
                                if (Util_evalDoubleQExpression(r->operator, value, r->limit)) {
                                        rv = State_Failed;
                                        snprintf(report, STRLEN, "read rate %.1f operations/s matches resource limit [read %s %.0f operations/s]", value, operatorshortnames[r->operator], r->limit);
                                } else {
                                        snprintf(report, STRLEN, "read rate test succeeded [current read = %.1f operations/s]", value);
                                }
                        } else {
                                DEBUG("'%s' warning -- no data are available for read rate test\n", s->name);
                                return State_Init;
                        }
                        break;

                case Resource_WriteBytes:
                        if (Statistics_initialized(&(s->inf.process->write.bytes))) {
                                double value = Statistics_deltaNormalize(&(s->inf.process->write.bytes));
                                if (Util_evalDoubleQExpression(r->operator, value, r->limit)) {
                                        rv = State_Failed;
                                        snprintf(report, STRLEN, "write rate %s/s matches resource limit [write %s %s/s]", Str_bytes2str(value, (char[10]){}), operatorshortnames[r->operator], Str_bytes2str(r->limit, (char[10]){}));
                                } else {
                                        snprintf(report, STRLEN, "write rate test succeeded [current write = %s/s]", Str_bytes2str(value, (char[10]){}));
                                }
                        } else {
                                DEBUG("'%s' warning -- no data are available for bytes write rate test\n", s->name);
                                return State_Init;
                        }
                        break;

                case Resource_WriteOperations:
                        if (Statistics_initialized(&(s->inf.process->write.operations))) {
                                double value = Statistics_deltaNormalize(&(s->inf.process->write.operations));
                                if (Util_evalDoubleQExpression(r->operator, value, r->limit)) {
                                        rv = State_Failed;
                                        snprintf(report, STRLEN, "write rate %.1f operations/s matches resource limit [write %s %.0f operations/s]", value, operatorshortnames[r->operator], r->limit);
                                } else {
                                        snprintf(report, STRLEN, "write rate test succeeded [current write = %.1f operations/s]", value);
                                }
                        } else {
                                DEBUG("'%s' warning -- no data are available for write rate test\n", s->name);
                                return State_Init;
                        }
                        break;

                default:
                        LogError("'%s' error -- unknown resource ID: [%d]\n", s->name, r->resource_id);
                        return State_Failed;
        }
        Event_post(s, Event_Resource, rv, r->action, "%s", report);
        return rv;
}


static State_Type _checkSystemResources(Service_T s, Resource_T r) {
        ASSERT(s);
        ASSERT(r);
        State_Type rv = State_Succeeded;
        char report[STRLEN] = {}, buf1[10], buf2[10];
        switch (r->resource_id) {
                case Resource_CpuPercent:
                        {
                                float cpu =
#ifdef HAVE_CPU_WAIT
                                        (systeminfo.cpu.usage.wait > 0. ? systeminfo.cpu.usage.wait : 0.) +
#endif
                                        (systeminfo.cpu.usage.system > 0. ? systeminfo.cpu.usage.system : 0.) +
                                        (systeminfo.cpu.usage.user > 0. ? systeminfo.cpu.usage.user : 0.);
                                if (cpu < 0.) {
                                        DEBUG("'%s' cpu usage check skipped (initializing)\n", s->name);
                                        return State_Init;
                                } else if (Util_evalDoubleQExpression(r->operator, cpu, r->limit)) {
                                        rv = State_Failed;
                                        snprintf(report, STRLEN, "cpu usage of %.1f%% matches resource limit [cpu usage %s %.1f%%]", cpu, operatorshortnames[r->operator], r->limit);
                                } else {
                                        snprintf(report, STRLEN, "cpu usage check succeeded [current cpu usage = %.1f%%]", cpu);
                                }
                        }
                        break;

                case Resource_CpuUser:
                        if (systeminfo.cpu.usage.user < 0.) {
                                DEBUG("'%s' cpu user usage check skipped (initializing)\n", s->name);
                                return State_Init;
                        } else if (Util_evalDoubleQExpression(r->operator, systeminfo.cpu.usage.user, r->limit)) {
                                rv = State_Failed;
                                snprintf(report, STRLEN, "cpu user usage of %.1f%% matches resource limit [cpu user usage %s %.1f%%]", systeminfo.cpu.usage.user, operatorshortnames[r->operator], r->limit);
                        } else {
                                snprintf(report, STRLEN, "cpu user usage check succeeded [current cpu user usage = %.1f%%]", systeminfo.cpu.usage.user);
                        }
                        break;

                case Resource_CpuSystem:
                        if (systeminfo.cpu.usage.system < 0.) {
                                DEBUG("'%s' cpu system usage check skipped (initializing)\n", s->name);
                                return State_Init;
                        } else if (Util_evalDoubleQExpression(r->operator, systeminfo.cpu.usage.system, r->limit)) {
                                rv = State_Failed;
                                snprintf(report, STRLEN, "cpu system usage of %.1f%% matches resource limit [cpu system usage %s %.1f%%]", systeminfo.cpu.usage.system, operatorshortnames[r->operator], r->limit);
                        } else {
                                snprintf(report, STRLEN, "cpu system usage check succeeded [current cpu system usage = %.1f%%]", systeminfo.cpu.usage.system);
                        }
                        break;

                case Resource_CpuWait:
                        if (systeminfo.cpu.usage.wait < 0.) {
                                DEBUG("'%s' cpu wait usage check skipped (initializing)\n", s->name);
                                return State_Init;
                        } else if (Util_evalDoubleQExpression(r->operator, systeminfo.cpu.usage.wait, r->limit)) {
                                rv = State_Failed;
                                snprintf(report, STRLEN, "cpu wait usage of %.1f%% matches resource limit [cpu wait usage %s %.1f%%]", systeminfo.cpu.usage.wait, operatorshortnames[r->operator], r->limit);
                        } else {
                                snprintf(report, STRLEN, "cpu wait usage check succeeded [current cpu wait usage = %.1f%%]", systeminfo.cpu.usage.wait);
                        }
                        break;

                case Resource_MemoryPercent:
                        if (Util_evalDoubleQExpression(r->operator, systeminfo.memory.usage.percent, r->limit)) {
                                rv = State_Failed;
                                snprintf(report, STRLEN, "mem usage of %.1f%% matches resource limit [mem usage %s %.1f%%]", systeminfo.memory.usage.percent, operatorshortnames[r->operator], r->limit);
                        } else {
                                snprintf(report, STRLEN, "mem usage check succeeded [current mem usage = %.1f%%]", systeminfo.memory.usage.percent);
                        }
                        break;

                case Resource_MemoryKbyte:
                        if (Util_evalDoubleQExpression(r->operator, systeminfo.memory.usage.bytes, r->limit)) {
                                rv = State_Failed;
                                snprintf(report, STRLEN, "mem amount of %s matches resource limit [mem amount %s %s]", Str_bytes2str(systeminfo.memory.usage.bytes, buf1), operatorshortnames[r->operator], Str_bytes2str(r->limit, buf2));
                        } else {
                                snprintf(report, STRLEN, "mem amount check succeeded [current mem amount = %s]", Str_bytes2str(systeminfo.memory.usage.bytes, buf1));
                        }
                        break;

                case Resource_SwapPercent:
                        if (Util_evalDoubleQExpression(r->operator, systeminfo.swap.usage.percent, r->limit)) {
                                rv = State_Failed;
                                snprintf(report, STRLEN, "swap usage of %.1f%% matches resource limit [swap usage %s %.1f%%]", systeminfo.swap.usage.percent, operatorshortnames[r->operator], r->limit);
                        } else {
                                snprintf(report, STRLEN, "swap usage check succeeded [current swap usage = %.1f%%]", systeminfo.swap.usage.percent);
                        }
                        break;

                case Resource_SwapKbyte:
                        if (s->type == Service_System) {
                                if (Util_evalDoubleQExpression(r->operator, systeminfo.swap.usage.bytes, r->limit)) {
                                        rv = State_Failed;
                                        snprintf(report, STRLEN, "swap amount of %s matches resource limit [swap amount %s %s]", Str_bytes2str(systeminfo.swap.usage.bytes, buf1), operatorshortnames[r->operator], Str_bytes2str(r->limit, buf2));
                                } else {
                                        snprintf(report, STRLEN, "swap amount check succeeded [current swap amount = %s]", Str_bytes2str(systeminfo.swap.usage.bytes, buf1));
                                }
                        }
                        break;

                case Resource_LoadAverage1m:
                        if (Util_evalDoubleQExpression(r->operator, systeminfo.loadavg[0], r->limit)) {
                                rv = State_Failed;
                                snprintf(report, STRLEN, "loadavg(1min) of %.1f matches resource limit [loadavg(1min) %s %.1f]", systeminfo.loadavg[0], operatorshortnames[r->operator], r->limit);
                        } else {
                                snprintf(report, STRLEN, "loadavg(1min) check succeeded [current loadavg(1min) = %.1f]", systeminfo.loadavg[0]);
                        }
                        break;

                case Resource_LoadAverage5m:
                        if (Util_evalDoubleQExpression(r->operator, systeminfo.loadavg[1], r->limit)) {
                                rv = State_Failed;
                                snprintf(report, STRLEN, "loadavg(5min) of %.1f matches resource limit [loadavg(5min) %s %.1f]", systeminfo.loadavg[1], operatorshortnames[r->operator], r->limit);
                        } else {
                                snprintf(report, STRLEN, "loadavg(5min) check succeeded [current loadavg(5min) = %.1f]", systeminfo.loadavg[1]);
                        }
                        break;

                case Resource_LoadAverage15m:
                        if (Util_evalDoubleQExpression(r->operator, systeminfo.loadavg[2], r->limit)) {
                                rv = State_Failed;
                                snprintf(report, STRLEN, "loadavg(15min) of %.1f matches resource limit [loadavg(15min) %s %.1f]", systeminfo.loadavg[2], operatorshortnames[r->operator], r->limit);
                        } else {
                                snprintf(report, STRLEN, "loadavg(15min) check succeeded [current loadavg(15min) = %.1f]", systeminfo.loadavg[2]);
                        }
                        break;

                default:
                        LogError("'%s' error -- unknown resource ID: [%d]\n", s->name, r->resource_id);
                        return State_Failed;
        }
        Event_post(s, Event_Resource, rv, r->action, "%s", report);
        return rv;
}


/**
 * Test for associated path checksum change
 */
static State_Type _checkChecksum(Service_T s) {
        ASSERT(s);
        ASSERT(s->path);
        State_Type rv = State_Succeeded;
        if (s->checksum) {
                Checksum_T cs = s->checksum;
                if (Util_getChecksum(s->path, cs->type, s->inf.file->cs_sum, sizeof(s->inf.file->cs_sum))) {
                        Event_post(s, Event_Data, State_Succeeded, s->action_DATA, "checksum %s", s->inf.file->cs_sum);
                        if (! cs->initialized) {
                                cs->initialized = true;
                                strncpy(cs->hash, s->inf.file->cs_sum, sizeof(cs->hash) - 1);
                        }
                        int changed;
                        switch (cs->type) {
                                case Hash_Md5:
                                        changed = strncmp(cs->hash, s->inf.file->cs_sum, 32);
                                        break;
                                case Hash_Sha1:
                                        changed = strncmp(cs->hash, s->inf.file->cs_sum, 40);
                                        break;
                                default:
                                        LogError("'%s' unknown hash type (%d)\n", s->name, cs->type);
                                        *s->inf.file->cs_sum = 0;
                                        return State_Failed;
                        }
                        if (changed) {
                                if (cs->test_changes) {
                                        rv = State_Changed;
                                        /* reset expected value for next cycle */
                                        strncpy(cs->hash, s->inf.file->cs_sum, sizeof(cs->hash) - 1);
                                        /* if we are testing for changes only, the value is variable */
                                        Event_post(s, Event_Checksum, State_Changed, cs->action, "checksum changed to %s", s->inf.file->cs_sum);
                                } else {
                                        /* we are testing constant value for failed or succeeded state */
                                        rv = State_Failed;
                                        Event_post(s, Event_Checksum, State_Failed, cs->action, "checksum failed, expected %s got %s", cs->hash, s->inf.file->cs_sum);
                                }
                        } else if (cs->test_changes) {
                                rv = State_ChangedNot;
                                Event_post(s, Event_Checksum, State_ChangedNot, cs->action, "checksum has not changed");
                        } else {
                                Event_post(s, Event_Checksum, State_Succeeded, cs->action, "checksum is valid");
                        }
                        return rv;
                }
                Event_post(s, Event_Data, State_Failed, s->action_DATA, "cannot compute checksum for %s", s->path);
                return State_Failed;
        }
        return rv;
}


/**
 * Test for associated path permission change
 */
static State_Type _checkPerm(Service_T s, int mode) {
        ASSERT(s);
        if (s->perm) {
                if (mode >= 0) {
                        mode_t m = mode & 07777;
                        if (m != s->perm->perm) {
                                if (s->perm->test_changes) {
                                        Event_post(s, Event_Permission, State_Changed, s->perm->action, "permission for %s changed from %04o to %04o", s->path, s->perm->perm, m);
                                        s->perm->perm = m;
                                        return State_Changed;
                                } else {
                                        Event_post(s, Event_Permission, State_Failed, s->perm->action, "permission test failed for %s [current permission %04o]", s->path, m);
                                        return State_Failed;
                                }
                        } else {
                                if (s->perm->test_changes) {
                                        Event_post(s, Event_Permission, State_ChangedNot, s->perm->action, "permission not changed for %s", s->path);
                                        return State_ChangedNot;
                                } else {
                                        Event_post(s, Event_Permission, State_Succeeded, s->perm->action, "permission test succeeded [current permission %04o]", m);
                                        return State_Succeeded;
                                }
                        }
                }
                return State_Init;
        }
        return State_Succeeded;
}


/**
 * Test UID of file or process
 */
static State_Type _checkUid(Service_T s, int uid) {
        ASSERT(s);
        if (s->uid) {
                if (uid >= 0) {
                        if (uid != s->uid->uid) {
                                Event_post(s, Event_Uid, State_Failed, s->uid->action, "uid test failed for %s -- current uid is %d", s->name, uid);
                                return State_Failed;
                        } else {
                                Event_post(s, Event_Uid, State_Succeeded, s->uid->action, "uid test succeeded [current uid = %d]", uid);
                                return State_Succeeded;
                        }
                }
                return State_Init;
        }
        return State_Succeeded;
}


/**
 * Test effective UID of process
 */
static State_Type _checkEuid(Service_T s, int euid) {
        ASSERT(s);
        if (s->euid) {
                if (euid >= 0) {
                        if (euid != s->euid->uid) {
                                Event_post(s, Event_Uid, State_Failed, s->euid->action, "euid test failed for %s -- current euid is %d", s->name, euid);
                                return State_Failed;
                        } else {
                                Event_post(s, Event_Uid, State_Succeeded, s->euid->action, "euid test succeeded [current euid = %d]", euid);
                                return State_Succeeded;
                        }
                }
                return State_Init;
        }
        return State_Succeeded;
}


static State_Type _checkSecurityAttribute(Service_T s, char *attribute) {
        ASSERT(s);
        State_Type rv = State_Succeeded;
        const char *attr = NVLSTR(attribute);
        for (SecurityAttribute_T a = s->secattrlist; a; a = a->next) {
                if (IS(attr, a->attribute)) {
                        Event_post(s, Event_Invalid, State_Succeeded, a->action, "Security attribute test succeeded [current attribute = '%s']", attr);
                } else {
                        rv = State_Failed;
                        Event_post(s, Event_Invalid, State_Failed, a->action, "Security attribute test failed for %s -- current attribute is '%s'", s->name, attr);
                }
        }
        return rv;
}


/**
 * Test GID of file or process
 */
static State_Type _checkGid(Service_T s, int gid) {
        ASSERT(s);
        if (s->gid) {
                if (gid >= 0) {
                        if (gid != s->gid->gid) {
                                Event_post(s, Event_Gid, State_Failed, s->gid->action, "gid test failed for %s -- current gid is %d", s->name, gid);
                                return State_Failed;
                        } else {
                                Event_post(s, Event_Gid, State_Succeeded, s->gid->action, "gid test succeeded [current gid = %d]", gid);
                                return State_Succeeded;
                        }
                }
                return State_Init;
        }
        return State_Succeeded;
}


static State_Type _checkTimestamp(Service_T s, Timestamp_T t, time_t timestamp) {
        State_Type rv = State_Succeeded;
        if (t->test_changes) {
                if (! t->initialized) {
                        t->initialized = true;
                        t->lastTimestamp = timestamp;
                } else {
                        if (t->lastTimestamp != timestamp) {
                                rv = State_Changed;
                                Event_post(s, Event_Timestamp, State_Changed, t->action, "%s for %s changed from %s to %s", timestampnames[t->type], s->path, t->lastTimestamp ? Time_string(t->lastTimestamp, (char[26]){}) : "N/A", Time_string(timestamp, (char[26]){}));
                                t->lastTimestamp = timestamp; // reset expected value for next cycle
                        } else {
                                Event_post(s, Event_Timestamp, State_ChangedNot, t->action, "%s was not changed for %s", timestampnames[t->type], s->path);
                        }
                }
        } else {
                /* we are testing constant value for failed or succeeded state */
                if (Util_evalQExpression(t->operator, Time_now() - timestamp, t->time)) {
                        rv = State_Failed;
                        Event_post(s, Event_Timestamp, State_Failed, t->action, "%s for %s failed -- current %s is %s", timestampnames[t->type], s->path, timestampnames[t->type], Time_string(timestamp, (char[26]){}));
                } else {
                        Event_post(s, Event_Timestamp, State_Succeeded, t->action, "%s test succeeded for %s [current %s is %s]", timestampnames[t->type], s->path, timestampnames[t->type], Time_string(timestamp, (char[26]){}));
                }
        }
        return rv;
}


/**
 * Validate timestamps of a service s
 */
static State_Type _checkTimestamps(Service_T s, time_t atime, time_t ctime, time_t mtime) {
        ASSERT(s);
        if (atime > 0 && ctime > 0 && mtime > 0) {
                State_Type rv;
                int failed = 0, changed = 0;
                for (Timestamp_T t = s->timestamplist; t; t = t->next) {
                        switch (t->type) {
                                case Timestamp_Access:
                                        rv = _checkTimestamp(s, t, atime);
                                        break;
                                case Timestamp_Change:
                                        rv = _checkTimestamp(s, t, ctime);
                                        break;
                                case Timestamp_Modification:
                                        rv = _checkTimestamp(s, t, mtime);
                                        break;
                                default:
                                        rv = _checkTimestamp(s, t, MAX(mtime, ctime));
                                        break;
                        }
                        if (rv == State_Failed) {
                                failed++;
                        } else if (rv == State_Changed) {
                                changed++;
                        }
                }
                return failed ? State_Failed : (changed ? State_Changed : State_Succeeded);
        }
        return State_Init;
}


/**
 * Test size
 */
static State_Type _checkSize(Service_T s, off_t size) {
        ASSERT(s);
        if (size >= 0) {
                State_Type rv = State_Succeeded;
                if (s->sizelist) {
                        char buf[10];
                        for (Size_T sl = s->sizelist; sl; sl = sl->next) {
                                /* if we are testing for changes only, the value is variable */
                                if (sl->test_changes) {
                                        if (! sl->initialized) {
                                                /* the size was not initialized during monit start, so set the size now
                                                 * and allow further size change testing */
                                                sl->initialized = true;
                                                sl->size = size;
                                        } else {
                                                if (sl->size != size) {
                                                        rv = State_Changed;
                                                        Event_post(s, Event_Size, State_Changed, sl->action, "size for %s changed to %s", s->path, Str_bytes2str(size, buf));
                                                        /* reset expected value for next cycle */
                                                        sl->size = size;
                                                } else {
                                                        Event_post(s, Event_Size, State_ChangedNot, sl->action, "size has not changed [current size = %s]", Str_bytes2str(size, buf));
                                                }
                                        }
                                } else {
                                        /* we are testing constant value for failed or succeeded state */
                                        if (Util_evalQExpression(sl->operator, size, sl->size)) {
                                                rv = State_Failed;
                                                Event_post(s, Event_Size, State_Failed, sl->action, "size test failed for %s -- current size is %s", s->path, Str_bytes2str(size, buf));
                                        } else {
                                                Event_post(s, Event_Size, State_Succeeded, sl->action, "size check succeeded [current size = %s]", Str_bytes2str(size, buf));
                                        }
                                }
                        }
                }
                return rv;
        } else {
                return State_Init;
        }
}


/**
 * Test uptime
 */
static State_Type _checkUptime(Service_T s, long long uptime) {
        ASSERT(s);
        State_Type rv = State_Succeeded;
        if (uptime < 0)
                return State_Init;
        for (Uptime_T ul = s->uptimelist; ul; ul = ul->next) {
                if (Util_evalQExpression(ul->operator, uptime, ul->uptime)) {
                        rv = State_Failed;
                        Event_post(s, Event_Uptime, State_Failed, ul->action, "uptime test failed for %s -- current uptime is %llu seconds", s->path, (unsigned long long)uptime);
                } else {
                        Event_post(s, Event_Uptime, State_Succeeded, ul->action, "uptime test succeeded [current uptime = %llu seconds]", (unsigned long long)uptime);
                }
        }
        return rv;
}


static int _checkPattern(Match_T pattern, const char *line) {
        return regexec(pattern->regex_comp, line, 0, NULL, 0);
}


/**
 * Match content.
 *
 * The test compares only the lines terminated with \n.
 *
 * In the case that line with missing \n is read, the test stops, as we suppose that the file contains only partial line and the rest of it is yet stored in the buffer of the application which writes to the file.
 * The test will resume at the beginning of the incomplete line during the next cycle, allowing the writer to finish the write.
 *
 * We test only Run.limits.fileContentBuffer at maximum - in the case that the line is bigger, we read the rest of the line (till '\n') but ignore the characters past the maximum
 */
static State_Type _checkMatch(Service_T s) {
        ASSERT(s);
        /* TODO: https://bitbucket.org/tildeslash/monit/issues/401 Refactor and use mmap instead of naive std file io.
         mmap can make code simpler, more efficient and support multi-line matching as there is no line-buffer, but the
         whole file is in the buffer.
         */
        State_Type rv = State_Succeeded;
        if (s->matchlist) {
                FILE *file = fopen(s->path, "r");
                if (! file) {
                        LogError("'%s' cannot open file %s: %s\n", s->name, s->path, STRERROR);
                        return State_Failed;
                }
                /* FIXME: Refactor: Initialize the filesystems table ahead of file and filesystems test and index it by device id + replace the Str_startsWith() with lookup to the table by device id (obtained via file's stat()).
                 The central filesystems initialization will allow to reduce the statfs() calls in the case that there will be multiple file and/or filesystems tests for the same fs. Temporarily we go with
                 dummy Str_startsWith() as quick fix which will cover 99.9% of use cases without rising the statfs overhead if statfs call would be inlined here.
                 */
                if (Str_startsWith(s->path, "/proc")) {
                        s->inf.file->readpos = 0;
                } else {
                        /* If inode changed or size shrinked -> set read position = 0 */
                        if (s->inf.file->inode != s->inf.file->inode_prev || s->inf.file->readpos > s->inf.file->size)
                                s->inf.file->readpos = 0;
                        /* Do we need to match? Even if not, go to final, so we can reset the content match error flags in this cycle */
                        if (s->inf.file->readpos == s->inf.file->size) {
                                DEBUG("'%s' content match skipped - file size nor inode has not changed since last test\n", s->name);
                                goto final1;
                        }
                }
                char *line = CALLOC(sizeof(unsigned char), Run.limits.fileContentBuffer);
                while (true) {
next:
                        /* Seek to the read position */
                        if (fseek(file, (long)s->inf.file->readpos, SEEK_SET)) {
                                rv = State_Failed;
                                LogError("'%s' cannot seek file %s: %s\n", s->name, s->path, STRERROR);
                                goto final2;
                        }
                        if (! fgets(line, Run.limits.fileContentBuffer, file)) {
                                if (! feof(file)) {
                                        rv = State_Failed;
                                        LogError("'%s' cannot read file %s: %s\n", s->name, s->path, STRERROR);
                                }
                                goto final2;
                        }
                        size_t length = strlen(line);
                        if (length == 0) {
                                /* No content: shouldn't happen - empty line will contain at least '\n' */
                                goto final2;
                        } else if (line[length - 1] != '\n') {
                                if (length < Run.limits.fileContentBuffer - 1) {
                                        /* Incomplete line: we gonna read it next time again, allowing the writer to complete the write */
                                        DEBUG("'%s' content match: incomplete line read - no new line at end. (retrying next cycle)\n", s->name);
                                        goto final2;
                                } else if (length >= Run.limits.fileContentBuffer - 1) {
                                        /* Our read buffer is full: ignore the content past the Run.limits.fileContentBuffer */
                                        int _rv;
                                        do {
                                                if ((_rv = fgetc(file)) == EOF)
                                                        goto final2;
                                                length++;
                                        } while (_rv != '\n');
                                }
                        } else {
                                /* Remove trailing newline */
                                line[length - 1] = 0;
                        }
                        /* Set read position to the end of last read */
                        s->inf.file->readpos += length;
                        /* Check ignores */
                        for (Match_T ml = s->matchignorelist; ml; ml = ml->next) {
                                if ((_checkPattern(ml, line) == 0) ^ (ml->not)) {
                                        /* We match! -> line is ignored! */
                                        DEBUG("'%s' Ignore pattern %s'%s' match on content line\n", s->name, ml->not ? "not " : "", ml->match_string);
                                        goto next;
                                }
                        }
                        /* Check non ignores */
                        for (Match_T ml = s->matchlist; ml; ml = ml->next) {
                                if ((_checkPattern(ml, line) == 0) ^ (ml->not)) {
                                        DEBUG("'%s' Pattern %s'%s' match on content line [%s]\n", s->name, ml->not ? "not " : "", ml->match_string, line);
                                        /* Save the line for Event_post */
                                        if (! ml->log)
                                                ml->log = StringBuffer_create(Run.limits.fileContentBuffer);
                                        if (StringBuffer_length(ml->log) < Run.limits.fileContentBuffer) {
                                                StringBuffer_append(ml->log, "%s\n", line);
                                                if (StringBuffer_length(ml->log) >= Run.limits.fileContentBuffer)
                                                        StringBuffer_append(ml->log, "...\n");
                                        }
                                } else {
                                        DEBUG("'%s' Pattern %s'%s' doesn't match on content line [%s]\n", s->name, ml->not ? "not " : "", ml->match_string, line);
                                }
                        }
                }
final2:
                FREE(line);
final1:
                if (fclose(file)) {
                        rv = State_Failed;
                        LogError("'%s' cannot close file %s: %s\n", s->name, s->path, STRERROR);
                }
                /* Post process the matches: generate events for particular patterns */
                for (Match_T ml = s->matchlist; ml; ml = ml->next) {
                        if (ml->log) {
                                rv = State_Changed;
                                Event_post(s, Event_Content, State_Changed, ml->action, "content match:\n%s", StringBuffer_toString(ml->log));
                                StringBuffer_free(&ml->log);
                        } else {
                                Event_post(s, Event_Content, State_ChangedNot, ml->action, "content doesn't match");
                        }
                }
        }
        return rv;
}


/**
 * Test filesystem flags for possible change since last cycle
 */
static State_Type _checkFilesystemFlags(Service_T s) {
        ASSERT(s);
        if (*(s->inf.filesystem->flags)) {
                if (s->inf.filesystem->flagsChanged) {
                        s->inf.filesystem->flagsChanged = false;
                        for (FsFlag_T l = s->fsflaglist; l; l = l->next)
                                Event_post(s, Event_FsFlag, State_Changed, l->action, "filesystem flags changed to %s", s->inf.filesystem->flags);
                        return State_Changed;
                }
                for (FsFlag_T l = s->fsflaglist; l; l = l->next)
                        Event_post(s, Event_FsFlag, State_ChangedNot, l->action, "filesystem flags has not changed [current flags %s]", s->inf.filesystem->flags);
                return State_ChangedNot;
        }
        return State_Init;
}


/**
 * Filesystem test
 */
static State_Type _checkFilesystemResources(Service_T s, FileSystem_T td) {
        ASSERT(s);
        ASSERT(td);
        if ((td->limit_percent < 0) && (td->limit_absolute < 0)) {
                LogError("'%s' error: filesystem limit not set\n", s->name);
                return State_Failed;
        }
        switch (td->resource) {

                case Resource_Inode:
                        if (s->inf.filesystem->f_files <= 0) {
                                DEBUG("'%s' filesystem doesn't support inodes\n", s->name);
                                return State_Succeeded;
                        }
                        if (td->limit_percent >= 0.) {
                                if (Util_evalDoubleQExpression(td->operator, s->inf.filesystem->inode_percent, td->limit_percent)) {
                                        Event_post(s, Event_Resource, State_Failed, td->action, "inode usage %.1f%% matches resource limit [inode usage %s %.1f%%]", s->inf.filesystem->inode_percent, operatorshortnames[td->operator], td->limit_percent);
                                        return State_Failed;
                                }
                        } else {
                                if (Util_evalQExpression(td->operator, s->inf.filesystem->f_filesused, td->limit_absolute)) {
                                        Event_post(s, Event_Resource, State_Failed, td->action, "inode usage %lld matches resource limit [inode usage %s %lld]", s->inf.filesystem->f_filesused, operatorshortnames[td->operator], td->limit_absolute);
                                        return State_Failed;
                                }
                        }
                        Event_post(s, Event_Resource, State_Succeeded, td->action, "inode usage test succeeded [current inode usage = %.1f%%]", s->inf.filesystem->inode_percent);
                        return State_Succeeded;

                case Resource_InodeFree:
                        if (s->inf.filesystem->f_files <= 0) {
                                DEBUG("'%s' filesystem doesn't support inodes\n", s->name);
                                return State_Succeeded;
                        }
                        if (td->limit_percent >= 0.) {
                                if (Util_evalDoubleQExpression(td->operator, 100. - s->inf.filesystem->inode_percent, td->limit_percent)) {
                                        Event_post(s, Event_Resource, State_Failed, td->action, "inode free %.1f%% matches resource limit [inode free %s %.1f%%]", 100. - s->inf.filesystem->inode_percent, operatorshortnames[td->operator], td->limit_percent);
                                        return State_Failed;
                                }
                        } else {
                                if (Util_evalQExpression(td->operator, s->inf.filesystem->f_filesfree, td->limit_absolute)) {
                                        Event_post(s, Event_Resource, State_Failed, td->action, "inode free %lld matches resource limit [inode free %s %lld]", s->inf.filesystem->f_filesfree, operatorshortnames[td->operator], td->limit_absolute);
                                        return State_Failed;
                                }
                        }
                        Event_post(s, Event_Resource, State_Succeeded, td->action, "inode free test succeeded [current inode free = %.1f%%]", 100. - s->inf.filesystem->inode_percent);
                        return State_Succeeded;

                case Resource_Space:
                        if (td->limit_percent >= 0.) {
                                if (Util_evalDoubleQExpression(td->operator, s->inf.filesystem->space_percent, td->limit_percent)) {
                                        Event_post(s, Event_Resource, State_Failed, td->action, "space usage %.1f%% matches resource limit [space usage %s %.1f%%]", s->inf.filesystem->space_percent, operatorshortnames[td->operator], td->limit_percent);
                                        return State_Failed;
                                }
                        } else {
                                int64_t bytesUsed = s->inf.filesystem->f_blocksused * (s->inf.filesystem->f_bsize > 0 ? s->inf.filesystem->f_bsize : 1);
                                if (Util_evalQExpression(td->operator, bytesUsed, td->limit_absolute)) {
                                        char buf1[10];
                                        char buf2[10];
                                        Str_bytes2str(bytesUsed, buf1);
                                        Str_bytes2str(td->limit_absolute, buf2);
                                        Event_post(s, Event_Resource, State_Failed, td->action, "space usage %s matches resource limit [space usage %s %s]", buf1, operatorshortnames[td->operator], buf2);
                                        return State_Failed;
                                }
                        }
                        Event_post(s, Event_Resource, State_Succeeded, td->action, "space usage test succeeded [current space usage = %.1f%%]", s->inf.filesystem->space_percent);
                        return State_Succeeded;

                case Resource_SpaceFree:
                        if (td->limit_percent >= 0.) {
                                if (Util_evalDoubleQExpression(td->operator, 100. - s->inf.filesystem->space_percent, td->limit_percent)) {
                                        Event_post(s, Event_Resource, State_Failed, td->action, "space free %.1f%% matches resource limit [space free %s %.1f%%]", 100. - s->inf.filesystem->space_percent, operatorshortnames[td->operator], td->limit_percent);
                                        return State_Failed;
                                }
                        } else {
				int64_t bytesFreeTotal = s->inf.filesystem->f_blocksfreetotal * (s->inf.filesystem->f_bsize > 0 ? s->inf.filesystem->f_bsize : 1);
                                if (Util_evalQExpression(td->operator, bytesFreeTotal, td->limit_absolute)) {
                                        char buf1[10];
                                        char buf2[10];
                                        Str_bytes2str(bytesFreeTotal, buf1);
                                        Str_bytes2str(td->limit_absolute, buf2);
                                        Event_post(s, Event_Resource, State_Failed, td->action, "space free %s matches resource limit [space free %s %s]", buf1, operatorshortnames[td->operator], buf2);
                                        return State_Failed;
                                }
                        }
                        Event_post(s, Event_Resource, State_Succeeded, td->action, "space free test succeeded [current space free = %.1f%%]", 100. - s->inf.filesystem->space_percent);
                        return State_Succeeded;

                case Resource_ReadBytes:
                        if (Statistics_initialized(&(s->inf.filesystem->read.bytes))) {
                                double value = Statistics_deltaNormalize(&(s->inf.filesystem->read.bytes));
                                if (Util_evalDoubleQExpression(td->operator, value, td->limit_absolute)) {
                                        Event_post(s, Event_Resource, State_Failed, td->action, "read rate %s/s matches resource limit [read %s %s/s]", Str_bytes2str(value, (char[10]){}), operatorshortnames[td->operator], Str_bytes2str(td->limit_absolute, (char[10]){}));
                                        return State_Failed;
                                }
                                Event_post(s, Event_Resource, State_Succeeded, td->action, "read rate test succeeded [current read = %s/s]", Str_bytes2str(value, (char[10]){}));
                        } else {
                                DEBUG("'%s' warning -- no data are available for bytes read rate test\n", s->name);
                        }
                        return State_Succeeded;

                case Resource_ReadOperations:
                        if (Statistics_initialized(&(s->inf.filesystem->read.operations))) {
                                double value = Statistics_deltaNormalize(&(s->inf.filesystem->read.operations));
                                if (Util_evalDoubleQExpression(td->operator, value, td->limit_absolute)) {
                                        Event_post(s, Event_Resource, State_Failed, td->action, "read rate %.1f operations/s matches resource limit [read %s %llu operations/s]", value, operatorshortnames[td->operator], td->limit_absolute);
                                        return State_Failed;
                                }
                                Event_post(s, Event_Resource, State_Succeeded, td->action, "read rate test succeeded [current read = %.1f operations/s]", value);
                        } else {
                                DEBUG("'%s' warning -- no data are available for read rate test\n", s->name);
                        }
                        return State_Succeeded;

                case Resource_WriteBytes:
                        if (Statistics_initialized(&(s->inf.filesystem->write.bytes))) {
                                double value = Statistics_deltaNormalize(&(s->inf.filesystem->write.bytes));
                                if (Util_evalDoubleQExpression(td->operator, value, td->limit_absolute)) {
                                        Event_post(s, Event_Resource, State_Failed, td->action, "write rate %s/s matches resource limit [write %s %s/s]", Str_bytes2str(value, (char[10]){}), operatorshortnames[td->operator], Str_bytes2str(td->limit_absolute, (char[10]){}));
                                        return State_Failed;
                                }
                                Event_post(s, Event_Resource, State_Succeeded, td->action, "write rate test succeeded [current write = %s/s]", Str_bytes2str(value, (char[10]){}));
                        } else {
                                DEBUG("'%s' warning -- no data are available for bytes write rate test\n", s->name);
                        }
                        return State_Succeeded;

                case Resource_WriteOperations:
                        if (Statistics_initialized(&(s->inf.filesystem->write.operations))) {
                                double value = Statistics_deltaNormalize(&(s->inf.filesystem->write.operations));
                                if (Util_evalDoubleQExpression(td->operator, value, td->limit_absolute)) {
                                        Event_post(s, Event_Resource, State_Failed, td->action, "write rate %.1f operations/s matches resource limit [write %s %llu operations/s]", value, operatorshortnames[td->operator], td->limit_absolute);
                                        return State_Failed;
                                }
                                Event_post(s, Event_Resource, State_Succeeded, td->action, "write rate test succeeded [current write = %.1f operations/s]", value);
                        } else {
                                DEBUG("'%s' warning -- no data are available for write rate test\n", s->name);
                        }
                        return State_Succeeded;

                case Resource_ServiceTime:
                        {
                                double deltaTime = 0.;
                                boolean_t hasReadTime = Statistics_initialized(&(s->inf.filesystem->time.read));
                                boolean_t hasWriteTime = Statistics_initialized(&(s->inf.filesystem->time.write));
                                boolean_t hasWaitTime = Statistics_initialized(&(s->inf.filesystem->time.wait));
                                boolean_t hasRunTime = Statistics_initialized(&(s->inf.filesystem->time.run));
                                // Some platforms have detailed R/W time (Linux, MacOS), other just total R/W time (*BSD), Solaris has total R/W time with wait/run granularity. To make the test cross-platform and simple, we operate on sum
                                if (! hasReadTime && ! hasWriteTime && ! hasWaitTime && ! hasRunTime) {
                                        DEBUG("'%s' warning -- no data are available for service time test\n", s->name);
                                        return State_Succeeded;
                                }
                                if (hasReadTime) {
                                        deltaTime += Statistics_delta(&(s->inf.filesystem->time.read));
                                }
                                if (hasWriteTime) {
                                        deltaTime += Statistics_delta(&(s->inf.filesystem->time.write));
                                }
                                if (hasWaitTime) {
                                        deltaTime += Statistics_delta(&(s->inf.filesystem->time.wait));
                                }
                                if (hasRunTime) {
                                        deltaTime += Statistics_delta(&(s->inf.filesystem->time.run));
                                }
                                double deltaOperations = Statistics_delta(&(s->inf.filesystem->read.operations)) + Statistics_delta(&(s->inf.filesystem->write.operations));
                                double serviceTime = deltaOperations > 0. ? deltaTime / deltaOperations : 0.;
                                if (Util_evalDoubleQExpression(td->operator, serviceTime, td->limit_absolute)) {
                                        Event_post(s, Event_Resource, State_Failed, td->action, "service time %.3fms/operation matches resource limit [service time %s %s/operation]", serviceTime, operatorshortnames[td->operator], Str_time2str(td->limit_absolute, (char[11]){}));
                                        return State_Failed;
                                }
                                Event_post(s, Event_Resource, State_Succeeded, td->action, "service time test succeeded [current service time = %.3f ms/operations]", serviceTime);
                        }
                        return State_Succeeded;

                default:
                        LogError("'%s' error -- unknown resource type: [%d]\n", s->name, td->resource);
                        return State_Failed;
        }
}


static void _checkTimeout(Service_T s) {
        if (s->actionratelist) {
                /* Start counting cycles */
                if (s->nstart > 0)
                        s->ncycle++;
                int max = 0;
                for (ActionRate_T ar = s->actionratelist; ar; ar = ar->next) {
                        if (max < ar->cycle)
                                max = ar->cycle;
                        if (s->nstart >= ar->count && s->ncycle <= ar->cycle)
                                Event_post(s, Event_Timeout, State_Failed, ar->action, "service restarted %d times within %d cycles(s) - %s", s->nstart, s->ncycle, actionnames[ar->action->failed->id]);
                }
                /* Stop counting and reset if the cycle interval is succeeded */
                if (s->ncycle > max) {
                        s->ncycle = 0;
                        s->nstart = 0;
                }
        }
}


static boolean_t _incron(Service_T s, time_t now) {
        if ((now - s->every.last_run) > 59) { // Minute is the lowest resolution, so only run once per minute
                if (Time_incron(s->every.spec.cron, now)) {
                        s->every.last_run = now;
                        return true;
                }
        }
        return false;
}


/**
 * Returns true if validation should be skiped for this service in this cycle, otherwise false. Handle every statement
 */
static boolean_t _checkSkip(Service_T s) {
        ASSERT(s);
        time_t now = Time_now();
        if (s->every.type == Every_SkipCycles) {
                s->every.spec.cycle.counter++;
                if (s->every.spec.cycle.counter < s->every.spec.cycle.number) {
                        s->monitor |= Monitor_Waiting;
                        DEBUG("'%s' test skipped as current cycle (%d) < every cycle (%d) \n", s->name, s->every.spec.cycle.counter, s->every.spec.cycle.number);
                        return true;
                }
                s->every.spec.cycle.counter = 0;
        } else if (s->every.type == Every_Cron && ! _incron(s, now)) {
                s->monitor |= Monitor_Waiting;
                DEBUG("'%s' test skipped as current time (%lld) does not match every's cron spec \"%s\"\n", s->name, (long long)now, s->every.spec.cron);
                return true;
        } else if (s->every.type == Every_NotInCron && Time_incron(s->every.spec.cron, now)) {
                s->monitor |= Monitor_Waiting;
                DEBUG("'%s' test skipped as current time (%lld) matches every's cron spec \"not %s\"\n", s->name, (long long)now, s->every.spec.cron);
                return true;
        }
        s->monitor &= ~Monitor_Waiting;
        // Skip if parent is not initialized
        for (Dependant_T d = s->dependantlist; d; d = d->next ) {
                Service_T parent = Util_getService(d->dependant);
                if (parent) {
                        if (parent->monitor != Monitor_Yes) {
                                DEBUG("'%s' test skipped as required service '%s' is %s\n", s->name, parent->name, parent->monitor == Monitor_Init ? "initializing" : "not monitored");
                                return true;
                        } else if (parent->error) {
                                DEBUG("'%s' test skipped as required service '%s' has errors\n", s->name, parent->name);
                                return true;
                        }
                }
        }
        return false;
}


/**
 * Returns true if scheduled action was performed
 */
static boolean_t _doScheduledAction(Service_T s) {
        int rv = false;
        Action_Type action = s->doaction;
        if (action != Action_Ignored) {
                rv = control_service(s->name, action);
                Event_post(s, Event_Action, State_Changed, s->action_ACTION, "%s action %s", actionnames[action], rv ? "done" : "failed");
                FREE(s->token);
        }
        return rv;
}


/* ---------------------------------------------------------------- Public */


/**
 *  This function contains the main check machinery for  monit. The
 *  validate function check services in the service list to see if
 *  they will pass all defined tests.
 */
int validate() {
        Run.handler_flag = Handler_Succeeded;
        Event_queue_process();

        update_system_info();
        ProcessTree_init(ProcessEngine_None);
        gettimeofday(&systeminfo.collected, NULL);

        /* In the case that at least one action is pending, perform quick loop to handle the actions ASAP */
        if (Run.flags & Run_ActionPending) {
                Run.flags &= ~Run_ActionPending;
                for (Service_T s = servicelist; s; s = s->next)
                        _doScheduledAction(s);
        }

        int errors = 0;
        /* Check the services */
        for (Service_T s = servicelist; s && ! interrupt(); s = s->next) {
                // FIXME: The Service_Program must collect the exit value from last run, even if the program start should be skipped in this cycle => let check program always run the test (to be refactored with new scheduler)
                if (! _doScheduledAction(s) && s->monitor && (s->type == Service_Program || ! _checkSkip(s))) {
                        _checkTimeout(s); // Can disable monitoring => need to check s->monitor again
                        if (s->monitor) {
                                State_Type state = s->check(s);
                                if (state != State_Init && s->monitor != Monitor_Not) // The monitoring can be disabled by some matching rule in s->check so we have to check again before setting to Monitor_Yes
                                        s->monitor = Monitor_Yes;
                                if (state == State_Failed)
                                        errors++;
                        }
                        gettimeofday(&s->collected, NULL);
                }
        }
        return errors;
}


/**
 * Validate a given process service s. Events are posted according to
 * its configuration. In case of a fatal event false is returned.
 */
State_Type check_process(Service_T s) {
        ASSERT(s);
        State_Type rv = State_Succeeded;
        pid_t pid = ProcessTree_findProcess(s);
        if (! pid) {
                for (NonExist_T l = s->nonexistlist; l; l = l->next) {
                        rv = State_Failed;
                        Event_post(s, Event_NonExist, State_Failed, l->action, "process is not running");
                }
                for (Exist_T l = s->existlist; l; l = l->next) {
                        Event_post(s, Event_Exist, State_Succeeded, l->action, "process is not running");
                }
                return rv;
        } else {
                for (NonExist_T l = s->nonexistlist; l; l = l->next) {
                        Event_post(s, Event_NonExist, State_Succeeded, l->action, "process is running with pid %d", (int)pid);
                }
                for (Exist_T l = s->existlist; l; l = l->next) {
                        rv = State_Failed;
                        Event_post(s, Event_Exist, State_Failed, l->action, "process is running with pid %d", (int)pid);
                }
        }
        /* Reset the exec and timeout errors if active ... the process is running (most probably after manual intervention) */
        if (IS_EVENT_SET(s->error, Event_Exec))
                Event_post(s, Event_Exec, State_Succeeded, s->action_EXEC, "process is running after previous exec error (slow starting or manually recovered?)");
        if (IS_EVENT_SET(s->error, Event_Timeout))
                for (ActionRate_T ar = s->actionratelist; ar; ar = ar->next)
                        Event_post(s, Event_Timeout, State_Succeeded, ar->action, "process is running after previous restart timeout (manually recovered?)");
        if (Run.flags & Run_ProcessEngineEnabled) {
                if (ProcessTree_updateProcess(s, pid)) {
                        if (_checkProcessState(s) == State_Failed)
                                rv = State_Failed;
                        if (_checkProcessPid(s) == State_Failed)
                                rv = State_Failed;
                        if (_checkProcessPpid(s) == State_Failed)
                                rv = State_Failed;
                        if (_checkUid(s, s->inf.process->uid) == State_Failed)
                                rv = State_Failed;
                        if (_checkEuid(s, s->inf.process->euid) == State_Failed)
                                rv = State_Failed;
                        if (_checkGid(s, s->inf.process->gid) == State_Failed)
                                rv = State_Failed;
                        if (_checkUptime(s, s->inf.process->uptime) == State_Failed)
                                rv = State_Failed;
                        if (_checkSecurityAttribute(s, s->inf.process->secattr) == State_Failed)
                                rv = State_Failed;
                        for (Resource_T pr = s->resourcelist; pr; pr = pr->next)
                                if (_checkProcessResources(s, pr) == State_Failed)
                                        rv = State_Failed;
                } else {
                        LogError("'%s' failed to get service data\n", s->name);
                        rv = State_Failed;
                }
        }
        int64_t uptimeMilli = (int64_t)(s->inf.process->uptime) * 1000LL;
        for (Port_T pp = s->portlist; pp; pp = pp->next) {
                //FIXME: instead of pause, try to test, but ignore any errors in the start timeout timeframe ... will allow to display the port response time as soon as available, instead of waiting for 30+ seconds
                /* pause port tests in the start timeout timeframe while the process is starting (it may take some time to the process before it starts accepting connections) */
                if (! s->start || uptimeMilli > s->start->timeout) {
                        if (_checkConnection(s, pp) == State_Failed)
                                rv = State_Failed;
                } else {
                        pp->is_available = Connection_Init;
                        DEBUG("'%s' connection test paused for %s while the process is starting\n", s->name, Str_time2str(s->start->timeout - (uptimeMilli < 0 ? 0 : uptimeMilli), (char[11]){}));
                }
        }
        for (Port_T pp = s->socketlist; pp; pp = pp->next) {
                //FIXME: instead of pause, try to test, but ignore any errors in the start timeout timeframe ... will allow to display the port response time as soon as available, instead of waiting for 30+ seconds
                /* pause socket tests in the start timeout timeframe while the process is starting (it may take some time to the process before it starts accepting connections) */
                if (! s->start || uptimeMilli > s->start->timeout) {
                        if (_checkConnection(s, pp) == State_Failed)
                                rv = State_Failed;
                } else {
                        pp->is_available = Connection_Init;
                        DEBUG("'%s' connection test paused for %s while the process is starting\n", s->name, Str_time2str(s->start->timeout - (uptimeMilli < 0 ? 0 : uptimeMilli), (char[11]){}));
                }
        }
        return rv;
}


/**
 * Validate a given filesystem service s. Events are posted according to
 * its configuration. In case of a fatal event false is returned.
 */
State_Type check_filesystem(Service_T s) {
        ASSERT(s);
        State_Type rv = State_Succeeded;
        if (! filesystem_usage(s)) {
                for (NonExist_T l = s->nonexistlist; l; l = l->next) {
                        rv = State_Failed;
                        Event_post(s, Event_NonExist, State_Failed, l->action, "unable to read filesystem '%s' state", s->path);
                }
                for (Exist_T l = s->existlist; l; l = l->next) {
                        Event_post(s, Event_Exist, State_Succeeded, l->action, "filesystem '%s' doesn't exist", s->path);
                }
                return rv;
        }
        for (NonExist_T l = s->nonexistlist; l; l = l->next) {
                Event_post(s, Event_NonExist, State_Succeeded, l->action, "succeeded getting filesystem statistics for '%s'", s->path);
        }
        for (Exist_T l = s->existlist; l; l = l->next) {
                rv = State_Failed;
                Event_post(s, Event_Exist, State_Failed, l->action, "filesystem '%s' exists", s->path);
        }
        if (_checkPerm(s, s->inf.filesystem->mode) == State_Failed)
                rv = State_Failed;
        if (_checkUid(s, s->inf.filesystem->uid) == State_Failed)
                rv = State_Failed;
        if (_checkGid(s, s->inf.filesystem->gid) == State_Failed)
                rv = State_Failed;
        if (_checkFilesystemFlags(s) == State_Failed)
                rv = State_Failed;
        for (FileSystem_T fs = s->filesystemlist; fs; fs = fs->next)
                if (_checkFilesystemResources(s, fs) == State_Failed)
                        rv = State_Failed;
        return rv;
}


/**
 * Validate a given file service s. Events are posted according to
 * its configuration. In case of a fatal event false is returned.
 */
State_Type check_file(Service_T s) {
        ASSERT(s);
        struct stat stat_buf;
        State_Type rv = State_Succeeded;
        if (stat(s->path, &stat_buf) != 0) {
                for (NonExist_T l = s->nonexistlist; l; l = l->next) {
                        rv = State_Failed;
                        Event_post(s, Event_NonExist, State_Failed, l->action, "file doesn't exist");
                }
                for (Exist_T l = s->existlist; l; l = l->next) {
                        Event_post(s, Event_Exist, State_Succeeded, l->action, "file doesn't exist");
                }
                return rv;
        } else {
                s->inf.file->mode = stat_buf.st_mode;
                if (s->inf.file->inode) {
                        s->inf.file->inode_prev = s->inf.file->inode;
                } else {
                        // Seek to the end of the file the first time we see it => skip existing content (files which passed the test at least once have inode always set via state file)
                        DEBUG("'%s' seeking to the end of the file\n", s->name);
                        s->inf.file->readpos = stat_buf.st_size;
                        s->inf.file->inode_prev = stat_buf.st_ino;
                }
                s->inf.file->inode = stat_buf.st_ino;
                s->inf.file->uid = stat_buf.st_uid;
                s->inf.file->gid = stat_buf.st_gid;
                s->inf.file->size = stat_buf.st_size;
                s->inf.file->timestamp.access = stat_buf.st_atime;
                s->inf.file->timestamp.change = stat_buf.st_ctime;
                s->inf.file->timestamp.modify = stat_buf.st_mtime;
                for (NonExist_T l = s->nonexistlist; l; l = l->next) {
                        Event_post(s, Event_NonExist, State_Succeeded, l->action, "file exists");
                }
                for (Exist_T l = s->existlist; l; l = l->next) {
                        rv = State_Failed;
                        Event_post(s, Event_Exist, State_Failed, l->action, "file exists");
                }
        }
        if (! S_ISREG(s->inf.file->mode) && ! S_ISSOCK(s->inf.file->mode)) {
                Event_post(s, Event_Invalid, State_Failed, s->action_INVALID, "is neither a regular file nor a socket");
                return State_Failed;
        } else {
                Event_post(s, Event_Invalid, State_Succeeded, s->action_INVALID, "is a regular %s",
                           S_ISSOCK(s->inf.file->mode) ? "socket" : "file");
        }
        if (_checkChecksum(s) == State_Failed)
                rv = State_Failed;
        if (_checkPerm(s, s->inf.file->mode) == State_Failed)
                rv = State_Failed;
        if (_checkUid(s, s->inf.file->uid) == State_Failed)
                rv = State_Failed;
        if (_checkGid(s, s->inf.file->gid) == State_Failed)
                rv = State_Failed;
        if (_checkSize(s, s->inf.file->size) == State_Failed)
                rv = State_Failed;
        if (_checkTimestamps(s, s->inf.file->timestamp.access, s->inf.file->timestamp.change, s->inf.file->timestamp.modify) == State_Failed)
                rv = State_Failed;
        if (_checkMatch(s) == State_Failed)
                rv = State_Failed;
        return rv;
}


/**
 * Validate a given directory service s. Events are posted according to
 * its configuration. In case of a fatal event false is returned.
 */
State_Type check_directory(Service_T s) {
        ASSERT(s);
        struct stat stat_buf;
        State_Type rv = State_Succeeded;
        if (stat(s->path, &stat_buf) != 0) {
                for (NonExist_T l = s->nonexistlist; l; l = l->next) {
                        rv = State_Failed;
                        Event_post(s, Event_NonExist, State_Failed, l->action, "directory doesn't exist");
                }
                for (Exist_T l = s->existlist; l; l = l->next) {
                        Event_post(s, Event_Exist, State_Succeeded, l->action, "directory doesn't exist");
                }
                return rv;
        } else {
                s->inf.directory->mode = stat_buf.st_mode;
                s->inf.directory->uid = stat_buf.st_uid;
                s->inf.directory->gid = stat_buf.st_gid;
                s->inf.directory->timestamp.access = stat_buf.st_atime;
                s->inf.directory->timestamp.change = stat_buf.st_ctime;
                s->inf.directory->timestamp.modify = stat_buf.st_mtime;
                for (NonExist_T l = s->nonexistlist; l; l = l->next) {
                        Event_post(s, Event_NonExist, State_Succeeded, l->action, "directory exists");
                }
                for (Exist_T l = s->existlist; l; l = l->next) {
                        rv = State_Failed;
                        Event_post(s, Event_Exist, State_Failed, l->action, "directory exists");
                }
        }
        if (! S_ISDIR(s->inf.directory->mode)) {
                Event_post(s, Event_Invalid, State_Failed, s->action_INVALID, "is not directory");
                return State_Failed;
        } else {
                Event_post(s, Event_Invalid, State_Succeeded, s->action_INVALID, "is directory");
        }
        if (_checkPerm(s, s->inf.directory->mode) == State_Failed)
                rv = State_Failed;
        if (_checkUid(s, s->inf.directory->uid) == State_Failed)
                rv = State_Failed;
        if (_checkGid(s, s->inf.directory->gid) == State_Failed)
                rv = State_Failed;
        if (_checkTimestamps(s, s->inf.directory->timestamp.access, s->inf.directory->timestamp.change, s->inf.directory->timestamp.modify) == State_Failed)
                rv = State_Failed;
        return rv;
}


/**
 * Validate a given fifo service s. Events are posted according to
 * its configuration. In case of a fatal event false is returned.
 */
State_Type check_fifo(Service_T s) {
        ASSERT(s);
        struct stat stat_buf;
        State_Type rv = State_Succeeded;
        if (stat(s->path, &stat_buf) != 0) {
                for (NonExist_T l = s->nonexistlist; l; l = l->next) {
                        rv = State_Failed;
                        Event_post(s, Event_NonExist, State_Failed, l->action, "fifo doesn't exist");
                }
                for (Exist_T l = s->existlist; l; l = l->next) {
                        Event_post(s, Event_Exist, State_Succeeded, l->action, "fifo doesn't exist");
                }
                return rv;
        } else {
                s->inf.fifo->mode = stat_buf.st_mode;
                s->inf.fifo->uid = stat_buf.st_uid;
                s->inf.fifo->gid = stat_buf.st_gid;
                s->inf.fifo->timestamp.access = stat_buf.st_atime;
                s->inf.fifo->timestamp.change = stat_buf.st_ctime;
                s->inf.fifo->timestamp.modify = stat_buf.st_mtime;
                for (NonExist_T l = s->nonexistlist; l; l = l->next) {
                        Event_post(s, Event_NonExist, State_Succeeded, l->action, "fifo exists");
                }
                for (Exist_T l = s->existlist; l; l = l->next) {
                        rv = State_Failed;
                        Event_post(s, Event_Exist, State_Failed, l->action, "fifo exists");
                }
        }
        if (! S_ISFIFO(s->inf.fifo->mode)) {
                Event_post(s, Event_Invalid, State_Failed, s->action_INVALID, "is not fifo");
                return State_Failed;
        } else {
                Event_post(s, Event_Invalid, State_Succeeded, s->action_INVALID, "is fifo");
        }
        if (_checkPerm(s, s->inf.fifo->mode) == State_Failed)
                rv = State_Failed;
        if (_checkUid(s, s->inf.fifo->uid) == State_Failed)
                rv = State_Failed;
        if (_checkGid(s, s->inf.fifo->gid) == State_Failed)
                rv = State_Failed;
        if (_checkTimestamps(s, s->inf.fifo->timestamp.access, s->inf.fifo->timestamp.change, s->inf.fifo->timestamp.modify) == State_Failed)
                rv = State_Failed;
        return rv;
}


/**
 * Validate a program status. Events are posted according to
 * its configuration. In case of a fatal event false is returned.
 */
State_Type check_program(Service_T s) {
        ASSERT(s);
        ASSERT(s->program);
        State_Type rv = State_Succeeded;
        time_t now = Time_now();
        Process_T P = s->program->P;
        if (P) {
                // Process program output
                _programOutput(Process_getErrorStream(P), s->program->inprogressOutput);
                _programOutput(Process_getInputStream(P), s->program->inprogressOutput);
                // Is the program still running?
                if (Process_exitStatus(P) < 0) {
                        int64_t execution_time = (now - s->program->started) * 1000;
                        if (execution_time > s->program->timeout) { // Program timed out
                                rv = State_Failed;
                                LogError("'%s' program timed out after %s. Killing program with pid %ld\n", s->name, Str_time2str(execution_time, (char[11]){}), (long)Process_getPid(P));
                                Process_kill(P);
                                Process_waitFor(P); // Wait for child to exit to get correct exit value
                                // Fall-through with P and evaluate exit value below.
                        } else {
                                // Defer test of exit value until program exit or timeout
                                DEBUG("'%s' status check deferred - waiting on program to exit\n", s->name);
                                return State_Init;
                        }
                }
                s->program->exitStatus = Process_exitStatus(P); // Save exit status for web-view display
                StringBuffer_trim(s->program->inprogressOutput);
                // Swap program output (instance finished)
                StringBuffer_clear(s->program->lastOutput);
                StringBuffer_append(s->program->lastOutput, "%s", StringBuffer_toString(s->program->inprogressOutput));
                // Evaluate program's exit status against our status checks.
                const char *output = StringBuffer_length(s->program->inprogressOutput) ? StringBuffer_toString(s->program->inprogressOutput) : "no output";
                for (Status_T status = s->statuslist; status; status = status->next) {
                        if (status->operator == Operator_Changed) {
                                if (status->initialized) {
                                        if (Util_evalQExpression(status->operator, s->program->exitStatus, status->return_value)) {
                                                Event_post(s, Event_Status, State_Changed, status->action, "status changed (%d -> %d) -- %s", status->return_value, s->program->exitStatus, output);
                                                status->return_value = s->program->exitStatus;
                                        } else {
                                                Event_post(s, Event_Status, State_ChangedNot, status->action, "status didn't change (%d) -- %s", s->program->exitStatus, output);
                                        }
                                } else {
                                        status->initialized = true;
                                        status->return_value = s->program->exitStatus;
                                }
                        } else {
                                if (Util_evalQExpression(status->operator, s->program->exitStatus, status->return_value)) {
                                        rv = State_Failed;
                                        Event_post(s, Event_Status, State_Failed, status->action, "status failed (%d) -- %s", s->program->exitStatus, output);
                                } else {
                                        Event_post(s, Event_Status, State_Succeeded, status->action, "status succeeded (%d) -- %s", s->program->exitStatus, output);
                                }
                        }
                }
                Process_free(&s->program->P);
        } else {
                rv = State_Init;
        }
        //FIXME: the current off-by-one-cycle based design requires that the check program will collect the exit value next cycle even if program startup should be skipped in the given cycle => must test skip here (new scheduler will obsolete this deferred skip checking)
        if (! _checkSkip(s) && s->monitor != Monitor_Not) { // The status evaluation may disable service monitoring
                // Start program
                StringBuffer_clear(s->program->inprogressOutput);
                s->program->P = Command_execute(s->program->C);
                if (! s->program->P) {
                        rv = State_Failed;
                        Event_post(s, Event_Status, State_Failed, s->action_EXEC, "failed to execute '%s' -- %s", s->path, STRERROR);
                } else {
                        Event_post(s, Event_Status, State_Succeeded, s->action_EXEC, "program started");
                        s->program->started = now;
                }
        }
        return rv;
}


/**
 * Validate a remote service.
 * @param s The remote service to validate
 * @return false if there was an error otherwise true
 */
State_Type check_remote_host(Service_T s) {
        ASSERT(s);
        State_Type rv = State_Succeeded;
        Icmp_T last_ping = NULL;
        /* Test each icmp type in the service's icmplist */
        for (Icmp_T icmp = s->icmplist; icmp; icmp = icmp->next) {
                switch (icmp->type) {
                        case ICMP_ECHO:
                                icmp->response = icmp_echo(s->path, icmp->family, &(icmp->outgoing), icmp->size, icmp->timeout, icmp->count);
                                if (icmp->response == -2) {
                                        icmp->is_available = Connection_Init;
#ifdef SOLARIS
                                        DEBUG("'%s' ping test skipped -- the monit user has no permission to create raw socket, please add net_icmpaccess privilege\n", s->name);
#else
                                        DEBUG("'%s' ping test skipped -- the monit user has no permission to create raw socket, please run monit as root\n", s->name);
#endif
                                } else if (icmp->response == -1) {
                                        rv = State_Failed;
                                        icmp->is_available = Connection_Failed;
                                        Event_post(s, Event_Icmp, State_Failed, icmp->action, "ping test failed");
                                } else {
                                        icmp->is_available = Connection_Ok;
                                        Event_post(s, Event_Icmp, State_Succeeded, icmp->action, "ping test succeeded [response time %s]", Str_time2str(icmp->response, (char[11]){}));
                                }
                                last_ping = icmp;
                                break;
                        default:
                                LogError("'%s' error -- unknown ICMP type: [%d]\n", s->name, icmp->type);
                                return State_Failed;
                }
        }
        /* If we could not ping the host we assume it's down and do not continue to check any port connections  */
        if (last_ping && last_ping->is_available == Connection_Failed && s->portlist) {
                DEBUG("'%s' icmp ping failed, skipping any port connection tests\n", s->name);
                return State_Failed;
        }
        /* Test each host:port and protocol in the service's portlist */
        for (Port_T p = s->portlist; p; p = p->next)
                if (_checkConnection(s, p) == State_Failed)
                        rv = State_Failed;
        return rv;
}


/**
 * Validate the general system indicators. In case of a fatal event
 * false is returned.
 */
State_Type check_system(Service_T s) {
        ASSERT(s);
        State_Type rv = State_Succeeded;
        for (Resource_T r = s->resourcelist; r; r = r->next)
                if (_checkSystemResources(s, r) == State_Failed)
                        rv = State_Failed;
        if (_checkUptime(s, Time_now() - systeminfo.booted) == State_Failed)
                rv = State_Failed;
        return rv;
}


State_Type check_net(Service_T s) {
        boolean_t havedata = true;
        State_Type rv = State_Succeeded;
        TRY
        {
                Link_update(s->inf.net->stats);
        }
        ELSE
        {
                havedata = false;
                for (LinkStatus_T link = s->linkstatuslist; link; link = link->next)
                        Event_post(s, Event_Link, State_Failed, link->action, "link data collection failed -- %s", Exception_frame.message);
        }
        END_TRY;
        if (! havedata)
                return State_Failed; // Terminate test if no data are available
        for (LinkStatus_T link = s->linkstatuslist; link; link = link->next) {
                Event_post(s, Event_Link, State_Succeeded, link->action, "link data collection succeeded");
        }
        // State
        if (! Link_getState(s->inf.net->stats)) {
                for (LinkStatus_T link = s->linkstatuslist; link; link = link->next)
                        Event_post(s, Event_Link, State_Failed, link->action, "link down");
                return State_Failed; // Terminate test if the link is down
        } else {
                for (LinkStatus_T link = s->linkstatuslist; link; link = link->next)
                        Event_post(s, Event_Link, State_Succeeded, link->action, "link up");
        }
        // Link errors
        long long oerrors = Link_getErrorsOutPerSecond(s->inf.net->stats);
        for (LinkStatus_T link = s->linkstatuslist; link; link = link->next) {
                if (oerrors > 0) {
                        rv = State_Failed;
                        Event_post(s, Event_Link, State_Failed, link->action, "%lld upload errors detected", oerrors);
                } else {
                        Event_post(s, Event_Link, State_Succeeded, link->action, "upload errors check succeeded");
                }
        }
        long long ierrors = Link_getErrorsInPerSecond(s->inf.net->stats);
        for (LinkStatus_T link = s->linkstatuslist; link; link = link->next) {
                if (ierrors > 0) {
                        rv = State_Failed;
                        Event_post(s, Event_Link, State_Failed, link->action, "%lld download errors detected", ierrors);
                } else {
                        Event_post(s, Event_Link, State_Succeeded, link->action, "download errors check succeeded");
                }
        }
        // Link speed
        int duplex = Link_getDuplex(s->inf.net->stats);
        long long speed = Link_getSpeed(s->inf.net->stats);
        for (LinkSpeed_T link = s->linkspeedlist; link; link = link->next) {
                if (speed > 0 && link->speed) {
                        if (duplex > -1 && duplex != link->duplex)
                                Event_post(s, Event_Speed, State_Changed, link->action, "link mode is now %s-duplex", duplex ? "full" : "half");
                        else
                                Event_post(s, Event_Speed, State_ChangedNot, link->action, "link mode has not changed since last cycle [current mode is %s-duplex]", duplex ? "full" : "half");
                        if (speed != link->speed)
                                Event_post(s, Event_Speed, State_Changed, link->action, "link speed changed to %.0lf Mb/s", (double)speed / 1000000.);
                        else
                                Event_post(s, Event_Speed, State_ChangedNot, link->action, "link speed has not changed since last cycle [current speed = %.0lf Mb/s]", (double)speed / 1000000.);
                }
                link->duplex = duplex;
                link->speed = speed;
        }
        // Link saturation
        double osaturation = Link_getSaturationOutPerSecond(s->inf.net->stats);
        double isaturation = Link_getSaturationInPerSecond(s->inf.net->stats);
        if (osaturation >= 0. && isaturation >= 0.) {
                for (LinkSaturation_T link = s->linksaturationlist; link; link = link->next) {
                        if (duplex) {
                                if (Util_evalDoubleQExpression(link->operator, osaturation, link->limit))
                                        Event_post(s, Event_Saturation, State_Failed, link->action, "link upload saturation of %.1f%% matches limit [saturation %s %.1f%%]", osaturation, operatorshortnames[link->operator], link->limit);
                                else
                                        Event_post(s, Event_Saturation, State_Succeeded, link->action, "link upload saturation check succeeded [current upload saturation %.1f%%]", osaturation);
                                if (Util_evalDoubleQExpression(link->operator, isaturation, link->limit))
                                        Event_post(s, Event_Saturation, State_Failed, link->action, "link download saturation of %.1f%% matches limit [saturation %s %.1f%%]", isaturation, operatorshortnames[link->operator], link->limit);
                                else
                                        Event_post(s, Event_Saturation, State_Succeeded, link->action, "link download saturation check succeeded [current download saturation %.1f%%]", isaturation);
                        } else {
                                double iosaturation = osaturation + isaturation;
                                if (Util_evalDoubleQExpression(link->operator, iosaturation, link->limit))
                                        Event_post(s, Event_Saturation, State_Failed, link->action, "link saturation of %.1f%% matches limit [saturation %s %.1f%%]", iosaturation, operatorshortnames[link->operator], link->limit);
                                else
                                        Event_post(s, Event_Saturation, State_Succeeded, link->action, "link saturation check succeeded [current saturation %.1f%%]", iosaturation);
                        }
                }
        }
        // Upload
        char buf1[10], buf2[10];
        for (Bandwidth_T upload = s->uploadbyteslist; upload; upload = upload->next) {
                long long obytes;
                switch (upload->range) {
                        case Time_Minute:
                                obytes = Link_getBytesOutPerMinute(s->inf.net->stats, upload->rangecount);
                                break;
                        case Time_Hour:
                                if (upload->rangecount == 1) // Use precise minutes range for "last hour"
                                        obytes = Link_getBytesOutPerMinute(s->inf.net->stats, 60);
                                else
                                        obytes = Link_getBytesOutPerHour(s->inf.net->stats, upload->rangecount);
                                break;
                        default:
                                obytes = Link_getBytesOutPerSecond(s->inf.net->stats);
                                break;
                }
                if (obytes >= 0 && Util_evalQExpression(upload->operator, obytes, upload->limit))
                        Event_post(s, Event_ByteOut, State_Failed, upload->action, "%supload %s matches limit [upload rate %s %s in last %d %s]", upload->range != Time_Second ? "total " : "", Str_bytes2str(obytes, buf1), operatorshortnames[upload->operator], Str_bytes2str(upload->limit, buf2), upload->rangecount, Util_timestr(upload->range));
                else
                        Event_post(s, Event_ByteOut, State_Succeeded, upload->action, "%supload check succeeded [current upload rate %s in last %d %s]", upload->range != Time_Second ? "total " : "", Str_bytes2str(obytes, buf1), upload->rangecount, Util_timestr(upload->range));
        }
        for (Bandwidth_T upload = s->uploadpacketslist; upload; upload = upload->next) {
                long long opackets;
                switch (upload->range) {
                        case Time_Minute:
                                opackets = Link_getPacketsOutPerMinute(s->inf.net->stats, upload->rangecount);
                                break;
                        case Time_Hour:
                                if (upload->rangecount == 1) // Use precise minutes range for "last hour"
                                        opackets = Link_getPacketsOutPerMinute(s->inf.net->stats, 60);
                                else
                                        opackets = Link_getPacketsOutPerHour(s->inf.net->stats, upload->rangecount);
                                break;
                        default:
                                opackets = Link_getPacketsOutPerSecond(s->inf.net->stats);
                                break;
                }
                if (opackets >= 0 && Util_evalQExpression(upload->operator, opackets, upload->limit))
                        Event_post(s, Event_PacketOut, State_Failed, upload->action, "%supload packets %lld matches limit [upload packets %s %lld in last %d %s]", upload->range != Time_Second ? "total " : "", opackets, operatorshortnames[upload->operator], upload->limit, upload->rangecount, Util_timestr(upload->range));
                else
                        Event_post(s, Event_PacketOut, State_Succeeded, upload->action, "%supload packets check succeeded [current upload packets %lld in last %d %s]", upload->range != Time_Second ? "total " : "", opackets, upload->rangecount, Util_timestr(upload->range));
        }
        // Download
        for (Bandwidth_T download = s->downloadbyteslist; download; download = download->next) {
                long long ibytes;
                switch (download->range) {
                        case Time_Minute:
                                ibytes = Link_getBytesInPerMinute(s->inf.net->stats, download->rangecount);
                                break;
                        case Time_Hour:
                                if (download->rangecount == 1) // Use precise minutes range for "last hour"
                                        ibytes = Link_getBytesInPerMinute(s->inf.net->stats, 60);
                                else
                                        ibytes = Link_getBytesInPerHour(s->inf.net->stats, download->rangecount);
                                break;
                        default:
                                ibytes = Link_getBytesInPerSecond(s->inf.net->stats);
                                break;
                }
                if (ibytes >= 0 && Util_evalQExpression(download->operator, ibytes, download->limit))
                        Event_post(s, Event_ByteIn, State_Failed, download->action, "%sdownload %s matches limit [download rate %s %s in last %d %s]", download->range != Time_Second ? "total " : "", Str_bytes2str(ibytes, buf1), operatorshortnames[download->operator], Str_bytes2str(download->limit, buf2), download->rangecount, Util_timestr(download->range));
                else
                        Event_post(s, Event_ByteIn, State_Succeeded, download->action, "%sdownload check succeeded [current download rate %s in last %d %s]", download->range != Time_Second ? "total " : "", Str_bytes2str(ibytes, buf1), download->rangecount, Util_timestr(download->range));
        }
        for (Bandwidth_T download = s->downloadpacketslist; download; download = download->next) {
                long long ipackets;
                switch (download->range) {
                        case Time_Minute:
                                ipackets = Link_getPacketsInPerMinute(s->inf.net->stats, download->rangecount);
                                break;
                        case Time_Hour:
                                if (download->rangecount == 1) // Use precise minutes range for "last hour"
                                        ipackets = Link_getPacketsInPerMinute(s->inf.net->stats, 60);
                                else
                                        ipackets = Link_getPacketsInPerHour(s->inf.net->stats, download->rangecount);
                                break;
                        default:
                                ipackets = Link_getPacketsInPerSecond(s->inf.net->stats);
                                break;
                }
                if (ipackets >= 0 && Util_evalQExpression(download->operator, ipackets, download->limit))
                        Event_post(s, Event_PacketIn, State_Failed, download->action, "%sdownload packets %lld matches limit [download packets %s %lld in last %d %s]", download->range != Time_Second ? "total " : "", ipackets, operatorshortnames[download->operator], download->limit, download->rangecount, Util_timestr(download->range));
                else
                        Event_post(s, Event_PacketIn, State_Succeeded, download->action, "%sdownload packets check succeeded [current download packets %lld in last %d %s]", download->range != Time_Second ? "total " : "", ipackets, download->rangecount, Util_timestr(download->range));
        }
        return rv;
}


