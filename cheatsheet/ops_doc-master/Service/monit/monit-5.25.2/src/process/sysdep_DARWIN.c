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

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#ifdef HAVE_FCNTL_H
#include <fcntl.h>
#endif

#ifdef HAVE_SYS_SYSCTL_H
#include <sys/sysctl.h>
#endif

#ifdef HAVE_MACH_MACH_H
#include <mach/mach.h>
#endif

#ifdef HAVE_LIBPROC_H
#include <libproc.h>
#endif

#include "monit.h"
#include "ProcessTree.h"
#include "process_sysdep.h"

// libmonit
#include "system/Time.h"


/**
 *  System dependent resource data collecting code for MacOS X.
 *
 *  @file
 */


#define ARGSSIZE 8192


/* ----------------------------------------------------------------- Private */


static int  pagesize;
static long total_old    = 0;
static long cpu_user_old = 0;
static long cpu_syst_old = 0;


/* ------------------------------------------------------------------ Public */


boolean_t init_process_info_sysdep(void) {
        size_t size = sizeof(systeminfo.cpu.count);
        if (sysctlbyname("hw.logicalcpu", &systeminfo.cpu.count, &size, NULL, 0) == -1) {
                DEBUG("system statistics error -- sysctl hw.logicalcpu failed: %s\n", STRERROR);
                return false;
        }

        size = sizeof(systeminfo.memory.size);
        if (sysctlbyname("hw.memsize", &systeminfo.memory.size, &size, NULL, 0) == -1) {
                DEBUG("system statistics error -- sysctl hw.memsize failed: %s\n", STRERROR);
                return false;
        }

        size = sizeof(pagesize);
        if (sysctlbyname("hw.pagesize", &pagesize, &size, NULL, 0) == -1) {
                DEBUG("system statistics error -- sysctl hw.pagesize failed: %s\n", STRERROR);
                return false;
        }

        size = sizeof(systeminfo.argmax);
        if (sysctlbyname("kern.argmax", &systeminfo.argmax, &size, NULL, 0) == -1) {
                DEBUG("system statistics error -- sysctl kern.argmax failed: %s\n", STRERROR);
                return false;
        }

        struct timeval booted;
        size = sizeof(booted);
        if (sysctlbyname("kern.boottime", &booted, &size, NULL, 0) == -1) {
                DEBUG("system statistics error -- sysctl kern.boottime failed: %s\n", STRERROR);
                return false;
        } else {
                systeminfo.booted = booted.tv_sec;
        }

        return true;
}


/**
 * Read all processes to initialize the information tree.
 * @param reference reference of ProcessTree
 * @param pflags Process engine flags
 * @return treesize > 0 if succeeded otherwise 0
 */
int initprocesstree_sysdep(ProcessTree_T **reference, ProcessEngine_Flags pflags) {
        size_t pinfo_size = 0;
        int mib[] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
        if (sysctl(mib, 4, NULL, &pinfo_size, NULL, 0) < 0) {
                LogError("system statistic error -- sysctl failed: %s\n", STRERROR);
                return 0;
        }
        struct kinfo_proc *pinfo = CALLOC(1, pinfo_size);
        if (sysctl(mib, 4, pinfo, &pinfo_size, NULL, 0)) {
                FREE(pinfo);
                LogError("system statistic error -- sysctl failed: %s\n", STRERROR);
                return 0;
        }
        size_t treesize = pinfo_size / sizeof(struct kinfo_proc);
        ProcessTree_T *pt = CALLOC(sizeof(ProcessTree_T), treesize);

        char *args = NULL;
        StringBuffer_T cmdline = NULL;
        if (pflags & ProcessEngine_CollectCommandLine) {
                cmdline = StringBuffer_create(64);
                args = CALLOC(1, systeminfo.argmax + 1);
        }
        for (int i = 0; i < treesize; i++) {
                pt[i].uptime    = systeminfo.time / 10. - pinfo[i].kp_proc.p_starttime.tv_sec;
                pt[i].zombie    = pinfo[i].kp_proc.p_stat == SZOMB ? true : false;
                pt[i].pid       = pinfo[i].kp_proc.p_pid;
                pt[i].ppid      = pinfo[i].kp_eproc.e_ppid;
                pt[i].cred.uid  = pinfo[i].kp_eproc.e_pcred.p_ruid;
                pt[i].cred.euid = pinfo[i].kp_eproc.e_ucred.cr_uid;
                pt[i].cred.gid  = pinfo[i].kp_eproc.e_pcred.p_rgid;
                if (pflags & ProcessEngine_CollectCommandLine) {
                        size_t size = systeminfo.argmax;
                        mib[0] = CTL_KERN;
                        mib[1] = KERN_PROCARGS2;
                        mib[2] = pt[i].pid;
                        if (sysctl(mib, 3, args, &size, NULL, 0) != -1) {
                                /* KERN_PROCARGS2 sysctl() returns following pseudo structure:
                                 *        struct {
                                 *                int argc
                                 *                char execname[];
                                 *                char argv[argc][];
                                 *                char env[][];
                                 *        }
                                 * The strings are terminated with '\0' and may have variable '\0' padding
                                 */
                                int argc = *args;
                                char *p = args + sizeof(int); // arguments beginning
                                StringBuffer_clear(cmdline);
                                p += strlen(p); // skip exename
                                while (argc && p < args + systeminfo.argmax) {
                                        if (*p == 0) { // skip terminating 0 and variable length 0 padding
                                                p++;
                                                continue;
                                        }
                                        StringBuffer_append(cmdline, argc-- ? "%s " : "%s", p);
                                        p += strlen(p);
                                }
                                if (StringBuffer_length(cmdline))
                                        pt[i].cmdline = Str_dup(StringBuffer_toString(StringBuffer_trim(cmdline)));
                        }
                        if (STR_UNDEF(pt[i].cmdline)) {
                                FREE(pt[i].cmdline);
                                pt[i].cmdline = Str_dup(pinfo[i].kp_proc.p_comm);
                        }
                }
                if (! pt[i].zombie) {
                        // CPU, memory, threads
                        struct proc_taskinfo tinfo;
                        int rv = proc_pidinfo(pt[i].pid, PROC_PIDTASKINFO, 0, &tinfo, sizeof(tinfo)); // If the process is zombie, skip this
                        if (rv <= 0) {
                                if (errno != EPERM)
                                        DEBUG("proc_pidinfo for pid %d failed -- %s\n", pt[i].pid, STRERROR);
                        } else if (rv < sizeof(tinfo)) {
                                LogError("proc_pidinfo for pid %d -- invalid result size\n", pt[i].pid);
                        } else {
                                pt[i].memory.usage = (uint64_t)tinfo.pti_resident_size;
                                pt[i].cpu.time = (double)(tinfo.pti_total_user + tinfo.pti_total_system) / 100000000.; // The time is in nanoseconds, we store it as 1/10s
                                pt[i].threads.self = tinfo.pti_threadnum;
                        }
#ifdef rusage_info_current
                        // Disk IO
                        rusage_info_current rusage;
                        if (proc_pid_rusage(pt[i].pid, RUSAGE_INFO_CURRENT, (rusage_info_t *)&rusage) < 0) {
                                if (errno != EPERM)
                                        DEBUG("proc_pid_rusage for pid %d failed -- %s\n", pt[i].pid, STRERROR);
                        } else {
                                pt[i].read.time = pt[i].write.time = Time_milli();
                                pt[i].read.bytes = rusage.ri_diskio_bytesread;
                                pt[i].write.bytes = rusage.ri_diskio_byteswritten;
                        }
#endif
                }
        }
        if (pflags & ProcessEngine_CollectCommandLine) {
                StringBuffer_free(&cmdline);
                FREE(args);
        }
        FREE(pinfo);

        *reference = pt;
        
        return (int)treesize;
}


/**
 * This routine returns 'nelem' double precision floats containing
 * the load averages in 'loadv'; at most 3 values will be returned.
 * @param loadv destination of the load averages
 * @param nelem number of averages
 * @return: 0 if successful, -1 if failed (and all load averages are 0).
 */
int getloadavg_sysdep (double *loadv, int nelem) {
        return getloadavg(loadv, nelem);
}


/**
 * This routine returns real memory in use.
 * @return: true if successful, false if failed (or not available)
 */
boolean_t used_system_memory_sysdep(SystemInfo_T *si) {
        /* Memory */
        vm_statistics_data_t page_info;
        mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
        kern_return_t kret = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&page_info, &count);
        if (kret != KERN_SUCCESS) {
                DEBUG("system statistic error -- cannot get memory usage\n");
                return false;
        }
        si->memory.usage.bytes = (uint64_t)(page_info.wire_count + page_info.active_count) * (uint64_t)pagesize;

        /* Swap */
        int mib[2] = {CTL_VM, VM_SWAPUSAGE};
        size_t len = sizeof(struct xsw_usage);
        struct xsw_usage swap;
        if (sysctl(mib, 2, &swap, &len, NULL, 0) == -1) {
                DEBUG("system statistic error -- cannot get swap usage: %s\n", STRERROR);
                si->swap.size = 0ULL;
                return false;
        }
        si->swap.size = (uint64_t)swap.xsu_total;
        si->swap.usage.bytes = (uint64_t)swap.xsu_used;

        return true;
}


/**
 * This routine returns system/user CPU time in use.
 * @return: true if successful, false if failed
 */
boolean_t used_system_cpu_sysdep(SystemInfo_T *si) {
        long                      total;
        long                      total_new = 0;
        kern_return_t             kret;
        host_cpu_load_info_data_t cpu_info;
        mach_msg_type_number_t    count;

        count = HOST_CPU_LOAD_INFO_COUNT;
        kret  = host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, (host_info_t)&cpu_info, &count);
        if (kret == KERN_SUCCESS) {
                for (int i = 0; i < CPU_STATE_MAX; i++)
                        total_new += cpu_info.cpu_ticks[i];
                total     = total_new - total_old;
                total_old = total_new;

                si->cpu.usage.user = (total > 0) ? (100. * (double)(cpu_info.cpu_ticks[CPU_STATE_USER] - cpu_user_old) / total) : -1.;
                si->cpu.usage.system = (total > 0) ? (100. * (double)(cpu_info.cpu_ticks[CPU_STATE_SYSTEM] - cpu_syst_old) / total) : -1.;
                si->cpu.usage.wait = 0.; /* there is no wait statistic available */

                cpu_user_old = cpu_info.cpu_ticks[CPU_STATE_USER];
                cpu_syst_old = cpu_info.cpu_ticks[CPU_STATE_SYSTEM];

                return true;
        }
        return false;
}
