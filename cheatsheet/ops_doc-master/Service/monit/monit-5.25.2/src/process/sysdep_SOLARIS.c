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

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
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

#ifdef HAVE_SYS_LOADAVG_H
#include <sys/loadavg.h>
#endif

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#ifdef HAVE_PROCFS_H
#include <procfs.h>
#endif

#ifdef HAVE_GLOB_H
#include <glob.h>
#endif

#ifdef HAVE_KSTAT_H
#include <kstat.h>
#endif

#ifdef HAVE_SYS_SWAP_H
#define _SYS_VNODE_H
#include <sys/swap.h>
#endif

#ifdef HAVE_SYS_SYSINFO_H
#include <sys/sysinfo.h>
#endif

#ifdef HAVE_ZONE_H
#include <zone.h>
#endif

#ifdef HAVE_SYS_VM_USAGE_H
#include <sys/vm_usage.h>
#endif

#include "monit.h"
#include "ProcessTree.h"
#include "process_sysdep.h"

/**
 *  System dependent resource data collecting code for Solaris.
 *
 *  @file
 */

static int    page_size;
static long   old_cpu_user = 0;
static long   old_cpu_syst = 0;
static long   old_cpu_wait = 0;
static long   old_total = 0;

#define MAXSTRSIZE 80

boolean_t init_process_info_sysdep(void) {
        systeminfo.cpu.count = sysconf( _SC_NPROCESSORS_ONLN);
        page_size = getpagesize();
        systeminfo.memory.size = (uint64_t)sysconf(_SC_PHYS_PAGES) * (uint64_t)page_size;
        kstat_ctl_t *kctl = kstat_open();
        if (kctl) {
                kstat_t *kstat = kstat_lookup(kctl, "unix", 0, "system_misc");
                if (kstat) {
                        if (kstat_read(kctl, kstat, 0) != -1) {
                                kstat_named_t *knamed = kstat_data_lookup(kstat, "boot_time");
                                if (knamed)
                                        systeminfo.booted = (uint64_t)knamed->value.ul;
                        }
                }
                kstat_close(kctl);
        }
        return true;
}

double timestruc_to_tseconds(timestruc_t t) {
        return  t.tv_sec * 10 + t.tv_nsec / 100000000.0;
}


/**
 * Read all processes of the proc files system to initialize the process tree
 * @param reference reference of ProcessTree
 * @param pflags Process engine flags
 * @return treesize > 0 if succeeded otherwise 0
 */
int initprocesstree_sysdep(ProcessTree_T **reference, ProcessEngine_Flags pflags) {
        ASSERT(reference);

        /* Find all processes in the /proc directory */
        glob_t globbuf;
        int rv = glob("/proc/[0-9]*", 0, NULL, &globbuf);
        if (rv != 0) {
                LogError("system statistic error -- glob failed: %d (%s)\n", rv, STRERROR);
                return 0;
        }

        int treesize = globbuf.gl_pathc;

        /* Allocate the tree */
        ProcessTree_T *pt = CALLOC(sizeof(ProcessTree_T), treesize);

        char buf[4096];
        for (int i = 0; i < treesize; i++) {
                pt[i].pid = atoi(globbuf.gl_pathv[i] + strlen("/proc/"));
                if (file_readProc(buf, sizeof(buf), "psinfo", pt[i].pid, NULL)) {
                        psinfo_t *psinfo = (psinfo_t *)&buf;
                        pt[i].ppid         = psinfo->pr_ppid;
                        pt[i].cred.uid     = psinfo->pr_uid;
                        pt[i].cred.euid    = psinfo->pr_euid;
                        pt[i].cred.gid     = psinfo->pr_gid;
                        pt[i].uptime       = systeminfo.time / 10. - psinfo->pr_start.tv_sec;
                        pt[i].zombie       = psinfo->pr_nlwp == 0 ? true : false; // If we don't have any light-weight processes (LWP) then we are definitely a zombie
                        pt[i].memory.usage = (uint64_t)psinfo->pr_rssize * 1024;
                        if (pflags & ProcessEngine_CollectCommandLine) {
                                pt[i].cmdline = Str_dup(psinfo->pr_psargs);
                                if (STR_UNDEF(pt[i].cmdline)) {
                                        FREE(pt[i].cmdline);
                                        pt[i].cmdline = Str_dup(psinfo->pr_fname);
                                }
                        }
                        if (file_readProc(buf, sizeof(buf), "status", pt[i].pid, NULL)) {
                                pstatus_t *pstatus = (pstatus_t *)&buf;
                                pt[i].cpu.time = timestruc_to_tseconds(pstatus->pr_utime) + timestruc_to_tseconds(pstatus->pr_stime);
                                pt[i].threads.self = pstatus->pr_nlwp;
                        }
                        if (file_readProc(buf, sizeof(buf), "usage", pt[i].pid, NULL)) {
                                struct prusage *usage = (struct prusage *)&buf;
                                pt[i].read.operations = usage->pr_inblk;
                                pt[i].write.operations = usage->pr_oublk;
                        }
                }
        }

        *reference = pt;

        /* Free globbing buffer */
        globfree(&globbuf);

        return treesize;
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
 * This routine returns kbyte of real memory in use.
 * @return: true if successful, false if failed (or not available)
 */
boolean_t used_system_memory_sysdep(SystemInfo_T *si) {
        int                 n, num;
        kstat_ctl_t        *kctl;
        kstat_named_t      *knamed;
        kstat_t            *kstat;
        swaptbl_t          *s;
        char               *strtab;
        unsigned long long  total = 0ULL;
        unsigned long long  used  = 0ULL;

        /* Memory */
        kctl = kstat_open();
        zoneid_t zoneid = getzoneid();
        if (zoneid != GLOBAL_ZONEID) {
                /* Zone */
                if ((kstat = kstat_lookup(kctl, "memory_cap", -1, NULL))) {
                        /* Joyent SmartOS zone: reports wrong unix::system_pages:freemem in the zone - shows global zone freemem, switch to SmartOS specific memory_cap kstat, which is more effective then common getvmusage() */
                        if (kstat_read(kctl, kstat, NULL) == -1) {
                                LogError("system statistic error -- memory_cap usage data collection failed\n");
                                kstat_close(kctl);
                                return false;
                        }
                        kstat_named_t *rss = kstat_data_lookup(kstat, "rss");
                        if (rss)
                                si->memory.usage.bytes = (uint64_t)rss->value.i64;
                } else {
                        /* Solaris Zone */
                        size_t nres;
                        vmusage_t result;
                        if (getvmusage(VMUSAGE_ZONE, Run.polltime, &result, &nres) != 0) {
                                LogError("system statistic error -- getvmusage failed\n");
                                kstat_close(kctl);
                                return false;
                        }
                        si->memory.usage.bytes = (uint64_t)result.vmu_rss_all;
                }
        } else {
                kstat = kstat_lookup(kctl, "unix", 0, "system_pages");
                if (kstat_read(kctl, kstat, 0) == -1) {
                        LogError("system statistic error -- memory usage data collection failed\n");
                        kstat_close(kctl);
                        return false;
                }
                knamed = kstat_data_lookup(kstat, "freemem");
                if (knamed) {
                        uint64_t freemem = (uint64_t)knamed->value.ul * (uint64_t)page_size, arcsize = 0ULL;
                        kstat = kstat_lookup(kctl, "zfs", 0, "arcstats");
                        if (kstat_read(kctl, kstat, 0) != -1) {
                                knamed = kstat_data_lookup(kstat, "size");
                                arcsize = (uint64_t)knamed->value.ul;
                        }
                        si->memory.usage.bytes = systeminfo.memory.size - freemem - arcsize;
                }
        }
        kstat_close(kctl);

        /* Swap */
again:
        if ((num = swapctl(SC_GETNSWP, 0)) == -1) {
                LogError("system statistic error -- swap usage data collection failed: %s\n", STRERROR);
                return false;
        }
        if (num == 0) {
                DEBUG("system statistic -- no swap configured\n");
                si->swap.size = 0ULL;
                return true;
        }
        s = (swaptbl_t *)ALLOC(num * sizeof(swapent_t) + sizeof(struct swaptable));
        strtab = (char *)ALLOC((num + 1) * MAXSTRSIZE);
        for (int i = 0; i < (num + 1); i++)
                s->swt_ent[i].ste_path = strtab + (i * MAXSTRSIZE);
        s->swt_n = num + 1;
        if ((n = swapctl(SC_LIST, s)) < 0) {
                LogError("system statistic error -- swap usage data collection failed: %s\n", STRERROR);
                si->swap.size = 0ULL;
                FREE(s);
                FREE(strtab);
                return false;
        }
        if (n > num) {
                DEBUG("system statistic -- new swap added: deferring swap usage statistics to next cycle\n");
                FREE(s);
                FREE(strtab);
                goto again;
        }
        for (int i = 0; i < n; i++) {
                if (! (s->swt_ent[i].ste_flags & ST_INDEL) && ! (s->swt_ent[i].ste_flags & ST_DOINGDEL)) {
                        total += s->swt_ent[i].ste_pages;
                        used  += s->swt_ent[i].ste_pages - s->swt_ent[i].ste_free;
                }
        }
        FREE(s);
        FREE(strtab);
        si->swap.size = (uint64_t)total * (uint64_t)page_size;
        si->swap.usage.bytes = (uint64_t)used * (uint64_t)page_size;

        return true;
}


/**
 * This routine returns system/user CPU time in use.
 * @return: true if successful, false if failed (or not available)
 */
boolean_t used_system_cpu_sysdep(SystemInfo_T *si) {
        int             ncpu = 0, ncpus;
        long            cpu_user = 0, cpu_syst = 0, cpu_wait = 0, total = 0, diff_total;
        kstat_ctl_t    *kctl;
        kstat_named_t  *knamed;
        kstat_t        *kstat;
        kstat_t       **cpu_ks;
        cpu_stat_t     *cpu_stat;

        si->cpu.usage.user = si->cpu.usage.system = si->cpu.usage.wait = 0;

        kctl  = kstat_open();
        kstat = kstat_lookup(kctl, "unix", 0, "system_misc");
        if (kstat_read(kctl, kstat, 0) == -1) {
                LogError("system statistic -- failed to lookup unix::system_misc kstat\n");
                goto error;
        }

        if (NULL == (knamed = kstat_data_lookup(kstat, "ncpus"))) {
                LogError("system statistic -- ncpus kstat lookup failed\n");
                goto error;
        }

        if ((ncpus = knamed->value.ui32) == 0) {
                LogError("system statistic -- ncpus is 0\n");
                goto error;
        }

        cpu_ks   = (kstat_t **)ALLOC(ncpus * sizeof(kstat_t *));
        cpu_stat = (cpu_stat_t *)ALLOC(ncpus * sizeof(cpu_stat_t));

        for (kstat = kctl->kc_chain; kstat; kstat = kstat->ks_next) {
                if (strncmp(kstat->ks_name, "cpu_stat", 8) == 0) {
                        if (-1 == kstat_read(kctl, kstat, NULL)) {
                                LogError("system statistic -- failed to read cpu_stat kstat\n");
                                goto error2;
                        }
                        cpu_ks[ncpu] = kstat;
                        if (++ncpu > ncpus) {
                                LogError("system statistic -- cpu count mismatch\n");
                                goto error2;
                        }
                }
        }

        for (int i = 0; i < ncpu; i++) {
                if (-1 == kstat_read(kctl, cpu_ks[i], &cpu_stat[i])) {
                        LogError("system statistic -- failed to read cpu_stat kstat for cpu %d\n", i);
                        goto error2;
                }
                cpu_user += cpu_stat[i].cpu_sysinfo.cpu[CPU_USER];
                cpu_syst += cpu_stat[i].cpu_sysinfo.cpu[CPU_KERNEL];
                cpu_wait += cpu_stat[i].cpu_sysinfo.cpu[CPU_WAIT];
                total    += (cpu_stat[i].cpu_sysinfo.cpu[0] + cpu_stat[i].cpu_sysinfo.cpu[1] + cpu_stat[i].cpu_sysinfo.cpu[2] + cpu_stat[i].cpu_sysinfo.cpu[3]);
        }

        if (old_total == 0) {
                si->cpu.usage.user = si->cpu.usage.system = si->cpu.usage.wait = -1.;
        } else if ((diff_total = total - old_total) > 0) {
                si->cpu.usage.user = (100. * (cpu_user - old_cpu_user)) / diff_total;
                si->cpu.usage.system = (100. * (cpu_syst - old_cpu_syst)) / diff_total;
                si->cpu.usage.wait = (100. * (cpu_wait - old_cpu_wait)) / diff_total;
        }

        old_cpu_user = cpu_user;
        old_cpu_syst = cpu_syst;
        old_cpu_wait = cpu_wait;
        old_total    = total;

        FREE(cpu_ks);
        FREE(cpu_stat);
        kstat_close(kctl);
        return true;

error2:
        old_total = 0;
        FREE(cpu_ks);
        FREE(cpu_stat);

error:
        kstat_close(kctl);
        return false;
}

