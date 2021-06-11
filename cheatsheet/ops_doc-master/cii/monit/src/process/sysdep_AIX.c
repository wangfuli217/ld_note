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

#include "monit.h"

#ifdef HAVE_STDIO_H
#include <stdio.h>
#endif

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#ifdef HAVE_SYS_STAT_H
#include <sys/stat.h>
#endif

#ifdef HAVE_FCNTL_H
#include <fcntl.h>
#endif

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#ifdef HAVE_PROCINFO_H
#include <procinfo.h>
#endif

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#ifdef HAVE_SYS_PROC_H
#include <sys/proc.h>
#endif

#ifdef HAVE_SYS_PROCFS_H
#include <sys/procfs.h>
#endif

#ifdef HAVE_CF_H
#include <cf.h>
#endif

#ifdef HAVE_SYS_CFGODM_H
#include <sys/cfgodm.h>
#endif

#ifdef HAVE_SYS_CFGDB_H
#include <sys/cfgdb.h>
#endif

#ifdef HAVE_SYS_SYSTEMCFG_H
#include <sys/systemcfg.h>
#endif

#ifdef HAVE_SYS_PROC_H
#include <sys/proc.h>
#endif

#ifdef HAVE_SYS_PROTOSW_H
#include <sys/protosw.h>
#endif

#ifdef HAVE_LIBPERFSTAT_H
#include <libperfstat.h>
#endif

#ifdef HAVE_UTMPX_H
#include <utmpx.h>
#endif

#include "ProcessTree.h"
#include "process_sysdep.h"

/**
 *  System dependent resource data collecting code for AIX
 *
 *  @file
 */

int getprocs64(void *, int, void *, int, pid_t *, int);
int getargs(struct procentry64 *processBuffer, int bufferLen, char *argsBuffer, int argsLen);

static int                page_size;
static int                cpu_initialized = 0;
static unsigned long long cpu_total_old = 0ULL;
static unsigned long long cpu_user_old  = 0ULL;
static unsigned long long cpu_syst_old  = 0ULL;
static unsigned long long cpu_wait_old  = 0ULL;


boolean_t init_process_info_sysdep(void) {
        perfstat_memory_total_t mem;

        if (perfstat_memory_total(NULL, &mem, sizeof(perfstat_memory_total_t), 1) < 1) {
                LogError("system statistic error -- perfstat_memory_total failed: %s\n", STRERROR);
                return false;
        }

        page_size = getpagesize();
        systeminfo.memory.size = (uint64_t)mem.real_total * (uint64_t)page_size;
        systeminfo.cpu.count = sysconf(_SC_NPROCESSORS_ONLN);

        setutxent();
        struct utmpx _booted = {.ut_type = BOOT_TIME};
        struct utmpx *booted = getutxid(&_booted);
        if (booted)
                systeminfo.booted = booted->ut_tv.tv_sec;
        endutxent();

        return true;
}


/**
 * This routine returns 'nelem' double precision floats containing
 * the load averages in 'loadv'; at most 3 values will be returned.
 * @param loadv destination of the load averages
 * @param nelem number of averages
 * @return: 0 if successful, -1 if failed (and all load averages are 0).
 */
int getloadavg_sysdep (double *loadv, int nelem) {
        perfstat_cpu_total_t cpu;

        if (perfstat_cpu_total(NULL, &cpu, sizeof(perfstat_cpu_total_t), 1) < 1) {
                LogError("system statistic error -- perfstat_cpu_total failed: %s\n", STRERROR);
                return -1;
        }

        switch (nelem) {
                case 3:
                        loadv[2] = (double)cpu.loadavg[2] / (double)(1 << SBITS);

                case 2:
                        loadv[1] = (double)cpu.loadavg[1] / (double)(1 << SBITS);

                case 1:
                        loadv[0] = (double)cpu.loadavg[0] / (double)(1 << SBITS);
        }

        return 0;
}


/**
 * Read all processes to initialize the process tree
 * @param reference  reference of ProcessTree
 * @param pflags Process engine flags
 * @return treesize > 0 if succeeded otherwise 0.
 */
int initprocesstree_sysdep(ProcessTree_T **reference, ProcessEngine_Flags pflags) {
        int treesize;
        pid_t firstproc = 0;
        if ((treesize = getprocs64(NULL, 0, NULL, 0, &firstproc, PID_MAX)) < 0) {
                LogError("system statistic error -- getprocs64 failed: %s\n", STRERROR);
                return 0;
        }

        struct procentry64 *procs = CALLOC(sizeof(struct procentry64), treesize);

        firstproc = 0;
        if ((treesize = getprocs64(procs, sizeof(struct procentry64), NULL, 0, &firstproc, treesize)) < 0) {
                FREE(procs);
                LogError("system statistic error -- getprocs64 failed: %s\n", STRERROR);
                return 0;
        }

        ProcessTree_T *pt = CALLOC(sizeof(ProcessTree_T), treesize);

        for (int i = 0; i < treesize; i++) {
                pt[i].pid              = procs[i].pi_pid;
                pt[i].ppid             = procs[i].pi_ppid;
                pt[i].cred.euid        = procs[i].pi_uid;
                pt[i].threads.self     = procs[i].pi_thcount;
                pt[i].uptime           = systeminfo.time / 10. - procs[i].pi_start;
                pt[i].memory.usage     = (uint64_t)(procs[i].pi_drss + procs[i].pi_trss) * (uint64_t)page_size;
                pt[i].cpu.time         = procs[i].pi_ru.ru_utime.tv_sec * 10 + (double)procs[i].pi_ru.ru_utime.tv_usec / 100000. + procs[i].pi_ru.ru_stime.tv_sec * 10 + (double)procs[i].pi_ru.ru_stime.tv_usec / 100000.;
                pt[i].read.operations  = procs[i].pi_ru.ru_inblock;
                pt[i].write.operations = procs[i].pi_ru.ru_oublock;
                pt[i].zombie           = procs[i].pi_state == SZOMB ? true: false;

                char filename[STRLEN];
                snprintf(filename, sizeof(filename), "/proc/%d/psinfo", pt[i].pid);
                int fd = open(filename, O_RDONLY);
                if (fd < 0) {
                        DEBUG("Cannot open proc file %s -- %s\n", filename, STRERROR);
                        continue;
                }
                struct psinfo ps;
                if (read(fd, &ps, sizeof(ps)) < 0) {
                        DEBUG("Cannot read proc file %s -- %s\n", filename, STRERROR);
                        if (close(fd) < 0)
                                LogError("Socket close failed -- %s\n", STRERROR);
                        continue;
                }
                if (close(fd) < 0)
                        LogError("Socket close failed -- %s\n", STRERROR);
                pt[i].cred.uid = ps.pr_uid;
                pt[i].cred.gid = ps.pr_gid;
                if (pflags & ProcessEngine_CollectCommandLine) {
                        if (ps.pr_argc == 0) {
                                pt[i].cmdline = Str_dup(procs[i].pi_comm); // Kernel thread
                        } else {
                                char command[4096];
                                if (! getargs(&procs[i], sizeof(struct procentry64), command, sizeof(command))) {
                                        // The arguments are separated with '\0' with the last one terminated by '\0\0' -> merge arguments into one string
                                        for (int i = 0; i < sizeof(command) - 1; i++) {
                                                if (command[i] == '\0') {
                                                        if (command[i + 1] == '\0')
                                                                break;
                                                        command[i] = ' ';
                                                }
                                        }
                                        pt[i].cmdline = Str_dup(command);
                                } else {
                                        pt[i].cmdline = Str_dup(procs[i].pi_comm);
                                }
                        }
                }
        }

        FREE(procs);
        *reference = pt;

        return treesize;
}


/**
 * This routine returns kbyte of real memory in use.
 * @return: true if successful, false if failed (or not available)
 */
boolean_t used_system_memory_sysdep(SystemInfo_T *si) {
        perfstat_memory_total_t  mem;

        /* Memory */
        if (perfstat_memory_total(NULL, &mem, sizeof(perfstat_memory_total_t), 1) < 1) {
                LogError("system statistic error -- perfstat_memory_total failed: %s\n", STRERROR);
                return false;
        }
        si->memory.usage.bytes = (uint64_t)(mem.real_total - mem.real_free - mem.numperm) * (uint64_t)page_size;

        /* Swap */
        si->swap.size   = (uint64_t)mem.pgsp_total * 4096;                   /* 4kB blocks */
        si->swap.usage.bytes = (uint64_t)(mem.pgsp_total - mem.pgsp_free) * 4096; /* 4kB blocks */

        return true;
}


/**
 * This routine returns system/user CPU time in use.
 * @return: true if successful, false if failed (or not available)
 */
boolean_t used_system_cpu_sysdep(SystemInfo_T *si) {
        perfstat_cpu_total_t cpu;
        unsigned long long cpu_total;
        unsigned long long cpu_total_new = 0ULL;
        unsigned long long cpu_user      = 0ULL;
        unsigned long long cpu_syst      = 0ULL;
        unsigned long long cpu_wait      = 0ULL;

        if (perfstat_cpu_total(NULL, &cpu, sizeof(perfstat_cpu_total_t), 1) < 0) {
                LogError("system statistic error -- perfstat_cpu_total failed: %s\n", STRERROR);
                return -1;
        }

        cpu_total_new = (cpu.user + cpu.sys + cpu.wait + cpu.idle) / cpu.ncpus;
        cpu_total     = cpu_total_new - cpu_total_old;
        cpu_total_old = cpu_total_new;
        cpu_user      = cpu.user / cpu.ncpus;
        cpu_syst      = cpu.sys / cpu.ncpus;
        cpu_wait      = cpu.wait / cpu.ncpus;

        if (cpu_initialized) {
                if (cpu_total > 0) {
                        si->cpu.usage.user = 100. * ((double)(cpu_user - cpu_user_old) / (double)cpu_total);
                        si->cpu.usage.system = 100. * ((double)(cpu_syst - cpu_syst_old) / (double)cpu_total);
                        si->cpu.usage.wait = 100. * ((double)(cpu_wait - cpu_wait_old) / (double)cpu_total);
                } else {
                        si->cpu.usage.user = 0.;
                        si->cpu.usage.system = 0.;
                        si->cpu.usage.wait = 0.;
                }
        }

        cpu_user_old = cpu_user;
        cpu_syst_old = cpu_syst;
        cpu_wait_old = cpu_wait;

        cpu_initialized = 1;

        return true;
}

