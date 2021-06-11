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

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

// libmonit
#include "util/List.h"

#include "monit.h"
#include "event.h"
#include "ProcessTree.h"
#include "protocol.h"


/**
 *  XML routines for status and event notification message handling.
 *
 *  @file
 */


/* ----------------------------------------------------------------- Private */


/**
 * Escape the CDATA "]]>" stop sequence in string
 * @param B Output StringBuffer object
 * @param buf String to escape
 */
static void _escapeCDATA(StringBuffer_T B, const char *buf) {
        for (int i = 0; buf[i]; i++) {
                if (buf[i] == '>' && i > 1 && (buf[i - 1] == ']' && buf[i - 2] == ']'))
                        StringBuffer_append(B, "&gt;");
                else
                        StringBuffer_append(B, "%c", buf[i]);
        }
}


/**
 * Prints a document header into the given buffer.
 * @param B StringBuffer object
 * @param V Format version
 * @param myip The client-side IP address
 */
static void document_head(StringBuffer_T B, int V, const char *myip) {
        StringBuffer_append(B, "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>");
        if (V == 2)
                StringBuffer_append(B, "<monit id=\"%s\" incarnation=\"%lld\" version=\"%s\"><server>", Run.id, (long long)Run.incarnation, VERSION);
        else
                StringBuffer_append(B,
                                    "<monit>"
                                    "<server>"
                                    "<id>%s</id>"
                                    "<incarnation>%lld</incarnation>"
                                    "<version>%s</version>",
                                    Run.id,
                                    (long long)Run.incarnation,
                                    VERSION);
        StringBuffer_append(B,
                            "<uptime>%lld</uptime>"
                            "<poll>%d</poll>"
                            "<startdelay>%d</startdelay>"
                            "<localhostname>%s</localhostname>"
                            "<controlfile>%s</controlfile>",
                            (long long)ProcessTree_getProcessUptime(getpid()),
                            Run.polltime,
                            Run.startdelay,
                            Run.system->name ? Run.system->name : "",
                            Run.files.control ? Run.files.control : "");

        if (Run.httpd.flags & Httpd_Net || Run.httpd.flags & Httpd_Unix) {
                if (Run.httpd.flags & Httpd_Net)
                        StringBuffer_append(B, "<httpd><address>%s</address><port>%d</port><ssl>%d</ssl></httpd>", Run.httpd.socket.net.address ? Run.httpd.socket.net.address : myip ? myip : "", Run.httpd.socket.net.port, Run.httpd.socket.net.ssl.flags & SSL_Enabled);
                else if (Run.httpd.flags & Httpd_Unix)
                        StringBuffer_append(B, "<httpd><unixsocket>%s</unixsocket></httpd>", Run.httpd.socket.unix.path ? Run.httpd.socket.unix.path : "");

                if (Run.mmonitcredentials)
                        StringBuffer_append(B, "<credentials><username>%s</username><password>%s</password></credentials>", Run.mmonitcredentials->uname, Run.mmonitcredentials->passwd);
        }

        StringBuffer_append(B,
                            "</server>"
                            "<platform>"
                            "<name>%s</name>"
                            "<release>%s</release>"
                            "<version>%s</version>"
                            "<machine>%s</machine>"
                            "<cpu>%d</cpu>"
                            "<memory>%llu</memory>"
                            "<swap>%llu</swap>"
                            "</platform>",
                            systeminfo.uname.sysname,
                            systeminfo.uname.release,
                            systeminfo.uname.version,
                            systeminfo.uname.machine,
                            systeminfo.cpu.count,
                            (unsigned long long)((double)systeminfo.memory.size / 1024.),   // Send as kB for backward compatibility
                            (unsigned long long)((double)systeminfo.swap.size / 1024.)); // Send as kB for backward compatibility
}


/**
 * Prints a document footer into the given buffer.
 * @param B StringBuffer object
 */
static void document_foot(StringBuffer_T B) {
        StringBuffer_append(B, "</monit>");
}


static void _ioStatistics(StringBuffer_T B, const char *name, IOStatistics_T statistics) {
        StringBuffer_append(B, "<%s>", name);
        if (Statistics_initialized(&(statistics->bytes))) {
                StringBuffer_append(B,
                        "<bytes>"
                        "<count>%.0lf</count>"     // bytes per second
                        "<total>%"PRIu64"</total>" // bytes since boot
                        "</bytes>",
                        Statistics_deltaNormalize(&(statistics->bytes)),
                        Statistics_raw(&(statistics->bytes)));
        }
        if (Statistics_initialized(&(statistics->operations))) {
                StringBuffer_append(B,
                        "<operations>"
                        "<count>%.0lf</count>"     // operations per second
                        "<total>%"PRIu64"</total>" // operations since boot
                        "</operations>",
                        Statistics_deltaNormalize(&(statistics->operations)),
                        Statistics_raw(&(statistics->operations)));
        }
        StringBuffer_append(B, "</%s>", name);
}


/**
 * Prints a service status into the given buffer.
 * @param S Service object
 * @param B StringBuffer object
 * @param V Format version
 */
static void status_service(Service_T S, StringBuffer_T B, int V) {
        if (V == 2)
                StringBuffer_append(B, "<service name=\"%s\"><type>%d</type>", S->name ? S->name : "", S->type);
        else
                StringBuffer_append(B, "<service type=\"%d\"><name>%s</name>", S->type, S->name ? S->name : "");
        StringBuffer_append(B,
                            "<collected_sec>%lld</collected_sec>"
                            "<collected_usec>%ld</collected_usec>"
                            "<status>%d</status>"
                            "<status_hint>%d</status_hint>"
                            "<monitor>%d</monitor>"
                            "<monitormode>%d</monitormode>"
                            "<onreboot>%d</onreboot>"
                            "<pendingaction>%d</pendingaction>",
                            (long long)S->collected.tv_sec,
                            (long)S->collected.tv_usec,
                            S->error,
                            S->error_hint,
                            S->monitor,
                            S->mode,
                            S->onreboot,
                            S->doaction);
        if (S->every.type != Every_Cycle) {
                StringBuffer_append(B, "<every><type>%d</type>", S->every.type);
                if (S->every.type == 1)
                        StringBuffer_append(B, "<counter>%d</counter><number>%d</number>", S->every.spec.cycle.counter, S->every.spec.cycle.number);
                else
                        StringBuffer_append(B, "<cron>%s</cron>", S->every.spec.cron);
                StringBuffer_append(B, "</every>");
        }
        if (Util_hasServiceStatus(S)) {
                switch (S->type) {
                        case Service_File:
                                StringBuffer_append(B,
                                        "<mode>%o</mode>"
                                        "<uid>%d</uid>"
                                        "<gid>%d</gid>"
                                        "<timestamps>"
                                        "<access>%"PRIu64"</access>"
                                        "<change>%"PRIu64"</change>"
                                        "<modify>%"PRIu64"</modify>"
                                        "</timestamps>"
                                        "<size>%lld</size>",
                                        S->inf.file->mode & 07777,
                                        (int)S->inf.file->uid,
                                        (int)S->inf.file->gid,
                                        S->inf.file->timestamp.access,
                                        S->inf.file->timestamp.change,
                                        S->inf.file->timestamp.modify,
                                        (long long)S->inf.file->size);
                                if (S->checksum)
                                        StringBuffer_append(B, "<checksum type=\"%s\">%s</checksum>", checksumnames[S->checksum->type], S->inf.file->cs_sum);
                                break;

                        case Service_Directory:
                                StringBuffer_append(B,
                                        "<mode>%o</mode>"
                                        "<uid>%d</uid>"
                                        "<gid>%d</gid>"
                                        "<timestamps>"
                                        "<access>%"PRIu64"</access>"
                                        "<change>%"PRIu64"</change>"
                                        "<modify>%"PRIu64"</modify>"
                                        "</timestamps>",
                                        S->inf.directory->mode & 07777,
                                        (int)S->inf.directory->uid,
                                        (int)S->inf.directory->gid,
                                        S->inf.directory->timestamp.access,
                                        S->inf.directory->timestamp.change,
                                        S->inf.directory->timestamp.modify);
                                break;

                        case Service_Fifo:
                                StringBuffer_append(B,
                                        "<mode>%o</mode>"
                                        "<uid>%d</uid>"
                                        "<gid>%d</gid>"
                                        "<timestamps>"
                                        "<access>%"PRIu64"</access>"
                                        "<change>%"PRIu64"</change>"
                                        "<modify>%"PRIu64"</modify>"
                                        "</timestamps>",
                                        S->inf.fifo->mode & 07777,
                                        (int)S->inf.fifo->uid,
                                        (int)S->inf.fifo->gid,
                                        S->inf.fifo->timestamp.access,
                                        S->inf.fifo->timestamp.change,
                                        S->inf.fifo->timestamp.modify);
                                break;

                        case Service_Filesystem:
                                StringBuffer_append(B,
                                        "<fstype>%s</fstype>"
                                        "<fsflags>%s</fsflags>"
                                        "<mode>%o</mode>"
                                        "<uid>%d</uid>"
                                        "<gid>%d</gid>"
                                        "<block>"
                                        "<percent>%.1f</percent>"
                                        "<usage>%.1lf</usage>"
                                        "<total>%.1lf</total>"
                                        "</block>",
                                        S->inf.filesystem->object.type,
                                        S->inf.filesystem->flags,
                                        S->inf.filesystem->mode & 07777,
                                        (int)S->inf.filesystem->uid,
                                        (int)S->inf.filesystem->gid,
                                        S->inf.filesystem->space_percent,
                                        S->inf.filesystem->f_bsize > 0 ? (double)S->inf.filesystem->f_blocksused / 1048576. * (double)S->inf.filesystem->f_bsize : 0.,
                                        S->inf.filesystem->f_bsize > 0 ? (double)S->inf.filesystem->f_blocks / 1048576. * (double)S->inf.filesystem->f_bsize : 0.);
                                if (S->inf.filesystem->f_files > 0) {
                                        StringBuffer_append(B,
                                                "<inode>"
                                                "<percent>%.1f</percent>"
                                                "<usage>%lld</usage>"
                                                "<total>%lld</total>"
                                                "</inode>",
                                                S->inf.filesystem->inode_percent,
                                                S->inf.filesystem->f_filesused,
                                                S->inf.filesystem->f_files);
                                }
                                _ioStatistics(B, "read", &(S->inf.filesystem->read));
                                _ioStatistics(B, "write", &(S->inf.filesystem->write));
                                boolean_t hasReadTime = Statistics_initialized(&(S->inf.filesystem->time.read));
                                boolean_t hasWriteTime = Statistics_initialized(&(S->inf.filesystem->time.write));
                                boolean_t hasWaitTime = Statistics_initialized(&(S->inf.filesystem->time.wait));
                                boolean_t hasRunTime = Statistics_initialized(&(S->inf.filesystem->time.run));
                                if (hasReadTime || hasWriteTime || hasWaitTime || hasRunTime) {
                                        StringBuffer_append(B, "<servicetime>");
                                        if (hasReadTime)
                                                StringBuffer_append(B, "<read>%.3f</read>", Statistics_deltaNormalize(&(S->inf.filesystem->time.read)));
                                        if (hasWriteTime)
                                                StringBuffer_append(B, "<write>%.3f</write>", Statistics_deltaNormalize(&(S->inf.filesystem->time.write)));
                                        if (hasWaitTime)
                                                StringBuffer_append(B, "<wait>%.3f</wait>", Statistics_deltaNormalize(&(S->inf.filesystem->time.wait)));
                                        if (hasRunTime)
                                                StringBuffer_append(B, "<run>%.3f</run>", Statistics_deltaNormalize(&(S->inf.filesystem->time.run)));
                                        StringBuffer_append(B, "</servicetime>");
                                }
                                break;

                        case Service_Net:
                                StringBuffer_append(B,
                                        "<link>"
                                        "<state>%d</state>"
                                        "<speed>%lld</speed>"
                                        "<duplex>%d</duplex>"
                                        "<download>"
                                        "<packets>"
                                        "<now>%lld</now>"
                                        "<total>%lld</total>"
                                        "</packets>"
                                        "<bytes>"
                                        "<now>%lld</now>"
                                        "<total>%lld</total>"
                                        "</bytes>"
                                        "<errors>"
                                        "<now>%lld</now>"
                                        "<total>%lld</total>"
                                        "</errors>"
                                        "</download>"
                                        "<upload>"
                                        "<packets>"
                                        "<now>%lld</now>"
                                        "<total>%lld</total>"
                                        "</packets>"
                                        "<bytes>"
                                        "<now>%lld</now>"
                                        "<total>%lld</total>"
                                        "</bytes>"
                                        "<errors>"
                                        "<now>%lld</now>"
                                        "<total>%lld</total>"
                                        "</errors>"
                                        "</upload>"
                                        "</link>",
                                        Link_getState(S->inf.net->stats),
                                        Link_getSpeed(S->inf.net->stats),
                                        Link_getDuplex(S->inf.net->stats),
                                        Link_getPacketsInPerSecond(S->inf.net->stats),
                                        Link_getPacketsInTotal(S->inf.net->stats),
                                        Link_getBytesInPerSecond(S->inf.net->stats),
                                        Link_getBytesInTotal(S->inf.net->stats),
                                        Link_getErrorsInPerSecond(S->inf.net->stats),
                                        Link_getErrorsInTotal(S->inf.net->stats),
                                        Link_getPacketsOutPerSecond(S->inf.net->stats),
                                        Link_getPacketsOutTotal(S->inf.net->stats),
                                        Link_getBytesOutPerSecond(S->inf.net->stats),
                                        Link_getBytesOutTotal(S->inf.net->stats),
                                        Link_getErrorsOutPerSecond(S->inf.net->stats),
                                        Link_getErrorsOutTotal(S->inf.net->stats));
                                break;

                        case Service_Process:
                                StringBuffer_append(B,
                                        "<pid>%d</pid>"
                                        "<ppid>%d</ppid>"
                                        "<uid>%d</uid>"
                                        "<euid>%d</euid>"
                                        "<gid>%d</gid>"
                                        "<uptime>%lld</uptime>",
                                        S->inf.process->pid,
                                        S->inf.process->ppid,
                                        S->inf.process->uid,
                                        S->inf.process->euid,
                                        S->inf.process->gid,
                                        (long long)S->inf.process->uptime);
                                if (Run.flags & Run_ProcessEngineEnabled) {
                                        StringBuffer_append(B,
                                                "<threads>%d</threads>"
                                                "<children>%d</children>"
                                                "<memory>"
                                                "<percent>%.1f</percent>"
                                                "<percenttotal>%.1f</percenttotal>"
                                                "<kilobyte>%llu</kilobyte>"
                                                "<kilobytetotal>%llu</kilobytetotal>"
                                                "</memory>"
                                                "<cpu>"
                                                "<percent>%.1f</percent>"
                                                "<percenttotal>%.1f</percenttotal>"
                                                "</cpu>",
                                                S->inf.process->threads,
                                                S->inf.process->children,
                                                S->inf.process->mem_percent,
                                                S->inf.process->total_mem_percent,
                                                (unsigned long long)((double)S->inf.process->mem / 1024.),       // Send as kB for backward compatibility
                                                (unsigned long long)((double)S->inf.process->total_mem / 1024.), // Send as kB for backward compatibility
                                                S->inf.process->cpu_percent,
                                                S->inf.process->total_cpu_percent);
                                }
                                _ioStatistics(B, "read", &(S->inf.process->read));
                                _ioStatistics(B, "write", &(S->inf.process->write));
                                break;

                        default:
                                break;
                }
                for (Icmp_T i = S->icmplist; i; i = i->next) {
                        StringBuffer_append(B,
                                            "<icmp>"
                                            "<type>%s</type>"
                                            "<responsetime>%.6f</responsetime>"
                                            "</icmp>",
                                            icmpnames[i->type],
                                            i->is_available == Connection_Ok ? i->response / 1000. : -1.); // We send the response time in [s] for backward compatibility (with microseconds precision)
                }
                for (Port_T p = S->portlist; p; p = p->next) {
                        StringBuffer_append(B,
                                            "<port>"
                                            "<hostname>%s</hostname>"
                                            "<portnumber>%d</portnumber>"
                                            "<request><![CDATA[%s]]></request>"
                                            "<protocol>%s</protocol>"
                                            "<type>%s</type>"
                                            "<responsetime>%.6f</responsetime>",
                                            p->hostname ? p->hostname : "",
                                            p->target.net.port,
                                            Util_portRequestDescription(p),
                                            p->protocol->name ? p->protocol->name : "",
                                            Util_portTypeDescription(p),
                                            p->is_available == Connection_Ok ? p->response / 1000. : -1.); // We send the response time in [s] for backward compatibility (with microseconds precision)
                        if (p->target.net.ssl.options.flags)
                                StringBuffer_append(B,
                                            "<certificate>"
                                            "<valid>%d</valid>"
                                            "</certificate>",
                                            p->target.net.ssl.certificate.validDays);
                        StringBuffer_append(B,
                                            "</port>");
                }
                for (Port_T p = S->socketlist; p; p = p->next) {
                        StringBuffer_append(B,
                                            "<unix>"
                                            "<path>%s</path>"
                                            "<protocol>%s</protocol>"
                                            "<responsetime>%.6f</responsetime>"
                                            "</unix>",
                                            p->target.unix.pathname ? p->target.unix.pathname : "",
                                            p->protocol->name ? p->protocol->name : "",
                                            p->is_available == Connection_Ok ? p->response / 1000. : -1.); // We send the response time in [s] for backward compatibility (with microseconds precision)
                }
                if (S->type == Service_System) {
                        StringBuffer_append(B,
                                            "<system>"
                                            "<load>"
                                            "<avg01>%.2f</avg01>"
                                            "<avg05>%.2f</avg05>"
                                            "<avg15>%.2f</avg15>"
                                            "</load>"
                                            "<cpu>"
                                            "<user>%.1f</user>"
                                            "<system>%.1f</system>"
#ifdef HAVE_CPU_WAIT
                                            "<wait>%.1f</wait>"
#endif
                                            "</cpu>"
                                            "<memory>"
                                            "<percent>%.1f</percent>"
                                            "<kilobyte>%llu</kilobyte>"
                                            "</memory>"
                                            "<swap>"
                                            "<percent>%.1f</percent>"
                                            "<kilobyte>%llu</kilobyte>"
                                            "</swap>"
                                            "</system>",
                                            systeminfo.loadavg[0],
                                            systeminfo.loadavg[1],
                                            systeminfo.loadavg[2],
                                            systeminfo.cpu.usage.user > 0. ? systeminfo.cpu.usage.user : 0.,
                                            systeminfo.cpu.usage.system > 0. ? systeminfo.cpu.usage.system : 0.,
#ifdef HAVE_CPU_WAIT
                                            systeminfo.cpu.usage.wait > 0. ? systeminfo.cpu.usage.wait : 0.,
#endif
                                            systeminfo.memory.usage.percent,
                                            (unsigned long long)((double)systeminfo.memory.usage.bytes / 1024.),               // Send as kB for backward compatibility
                                            systeminfo.swap.usage.percent,
                                            (unsigned long long)((double)systeminfo.swap.usage.bytes / 1024.));             // Send as kB for backward compatibility
                }
                if (S->type == Service_Program && S->program->started) {
                        StringBuffer_append(B,
                                            "<program>"
                                            "<started>%lld</started>"
                                            "<status>%d</status>"
                                            "<output><![CDATA[",
                                            (long long)S->program->started,
                                            S->program->exitStatus);
                        _escapeCDATA(B, StringBuffer_toString(S->program->lastOutput));
                        StringBuffer_append(B,
                                            "]]></output>"
                                            "</program>");
                }
        }
        StringBuffer_append(B, "</service>");
}


/**
 * Prints a servicegroups into the given buffer.
 * @param SG ServiceGroup object
 * @param B StringBuffer object
 */
static void status_servicegroup(ServiceGroup_T SG, StringBuffer_T B) {
        StringBuffer_append(B, "<servicegroup name=\"%s\">", SG->name);
        for (list_t m = SG->members->head; m; m = m->next) {
                Service_T s = m->e;
                StringBuffer_append(B, "<service>%s</service>", s->name);
        }
        StringBuffer_append(B, "</servicegroup>");
}


/**
 * Prints a event description into the given buffer.
 * @param E Event object
 * @param B StringBuffer object
 */
static void status_event(Event_T E, StringBuffer_T B) {
        StringBuffer_append(B,
                            "<event>"
                            "<collected_sec>%lld</collected_sec>"
                            "<collected_usec>%ld</collected_usec>"
                            "<service>%s</service>"
                            "<type>%d</type>"
                            "<id>%ld</id>"
                            "<state>%d</state>"
                            "<action>%d</action>"
                            "<message><![CDATA[",
                            (long long)E->collected.tv_sec,
                            (long)E->collected.tv_usec,
                            E->id == Event_Instance ? "Monit" : E->source->name,
                            E->type,
                            E->id,
                            E->state,
                            Event_get_action(E));
        if (E->message)
                _escapeCDATA(B, E->message);
        StringBuffer_append(B, "]]></message>");
        if (E->source->token)
                StringBuffer_append(B, "<token>%s</token>", E->source->token);
        StringBuffer_append(B, "</event>");
}


/* ------------------------------------------------------------------ Public */


/**
 * Get a XML formated message for event notification or general status
 * of monitored services and resources.
 * @param E An event object or NULL for general status
 * @param V Format version
 * @param myip The client-side IP address
 */
void status_xml(StringBuffer_T B, Event_T E, int V, const char *myip) {
        Service_T S;
        ServiceGroup_T SG;

        document_head(B, V, myip);
        if (V == 2)
                StringBuffer_append(B, "<services>");
        for (S = servicelist_conf; S; S = S->next_conf)
                status_service(S, B, V);
        if (V == 2) {
                StringBuffer_append(B, "</services><servicegroups>");
                for (SG = servicegrouplist; SG; SG = SG->next)
                        status_servicegroup(SG, B);
                StringBuffer_append(B, "</servicegroups>");
        }
        if (E)
                status_event(E, B);
        document_foot(B);
}

