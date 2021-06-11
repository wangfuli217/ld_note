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

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#ifdef HAVE_ASM_PARAM_H
#include <asm/param.h>
#endif

#ifdef HAVE_GLOB_H
#include <glob.h>
#endif

#ifdef HAVE_SYS_SYSINFO_H
#include <sys/sysinfo.h>
#endif

#include "monit.h"
#include "ProcessTree.h"
#include "process_sysdep.h"

// libmonit
#include "system/Time.h"

/**
 *  System dependent resource data collection code for Linux.
 *
 *  @file
 */


/* ------------------------------------------------------------- Definitions */


static struct {
        int hasIOStatistics; // True if /proc/<PID>/io is present
} _statistics = {};


typedef struct Proc_T {
        int                 pid;
        int                 ppid;
        int                 uid;
        int                 euid;
        int                 gid;
        char                item_state;
        long                item_cutime;
        long                item_cstime;
        long                item_rss;
        int                 item_threads;
        unsigned long       item_utime;
        unsigned long       item_stime;
        unsigned long long  item_starttime;
        uint64_t            read_bytes;
        uint64_t            write_bytes;
        char                name[4096];
        char                secattr[STRLEN];
} *Proc_T;


/* --------------------------------------- Static constructor and destructor */


static void __attribute__ ((constructor)) _constructor() {
        struct stat sb;
        _statistics.hasIOStatistics = stat("/proc/self/io", &sb) == 0 ? true : false;
}


/* ----------------------------------------------------------------- Private */


#define NSEC_PER_SEC    1000000000L

static unsigned long long old_cpu_user     = 0;
static unsigned long long old_cpu_syst     = 0;
static unsigned long long old_cpu_wait     = 0;
static unsigned long long old_cpu_total    = 0;

static long page_size = 0;

static double hz = 0.;

/**
 * Get system start time
 * @return seconds since unix epoch
 */
static time_t _getStartTime() {
        struct sysinfo info;
        if (sysinfo(&info) < 0) {
                LogError("system statistic error -- cannot get system uptime: %s\n", STRERROR);
                return 0;
        }
        return Time_now() - info.uptime;
}


// parse /proc/PID/stat 
static boolean_t _parseProcPidStat(Proc_T proc) {
        char buf[4096];
        char *tmp = NULL;
        if (! file_readProc(buf, sizeof(buf), "stat", proc->pid, NULL)) {
                DEBUG("system statistic error -- cannot read /proc/%d/stat\n", proc->pid);
                return false;
        }
        if (! (tmp = strrchr(buf, ')'))) {
                DEBUG("system statistic error -- file /proc/%d/stat parse error\n", proc->pid);
                return false;
        }
        *tmp = 0;
        if (sscanf(buf, "%*d (%255s", proc->name) != 1) {
                DEBUG("system statistic error -- file /proc/%d/stat process name parse error\n", proc->pid);
                return false;
        }
        tmp += 2;
        if (sscanf(tmp,
                   "%c %d %*d %*d %*d %*d %*u %*u %*u %*u %*u %lu %lu %ld %ld %*d %*d %d %*u %llu %*u %ld %*u %*u %*u %*u %*u %*u %*u %*u %*u %*u %*u %*u %*u %*d %*d\n",
                   &(proc->item_state),
                   &(proc->ppid),
                   &(proc->item_utime),
                   &(proc->item_stime),
                   &(proc->item_cutime),
                   &(proc->item_cstime),
                   &(proc->item_threads),
                   &(proc->item_starttime),
                   &(proc->item_rss)) != 9) {
                DEBUG("system statistic error -- file /proc/%d/stat parse error\n", proc->pid);
                return false;
        }
        return true;
}


// parse /proc/PID/status
static boolean_t _parseProcPidStatus(Proc_T proc) {
        char buf[4096];
        char *tmp = NULL;
        if (! file_readProc(buf, sizeof(buf), "status", proc->pid, NULL)) {
                DEBUG("system statistic error -- cannot read /proc/%d/status\n", proc->pid);
                return false;
        }
        if (! (tmp = strstr(buf, "Uid:"))) {
                DEBUG("system statistic error -- cannot find process uid\n");
                return false;
        }
        if (sscanf(tmp + 4, "\t%d\t%d", &(proc->uid), &(proc->euid)) != 2) {
                DEBUG("system statistic error -- cannot read process uid\n");
                return false;
        }
        if (! (tmp = strstr(buf, "Gid:"))) {
                DEBUG("system statistic error -- cannot find process gid\n");
                return false;
        }
        if (sscanf(tmp + 4, "\t%d", &(proc->gid)) != 1) {
                DEBUG("system statistic error -- cannot read process gid\n");
                return false;
        }
        return true;
}


// parse /proc/PID/io
static boolean_t _parseProcPidIO(Proc_T proc) {
        char buf[4096];
        char *tmp = NULL;
        if (_statistics.hasIOStatistics) {
                if (file_readProc(buf, sizeof(buf), "io", proc->pid, NULL)) {
                        if (! (tmp = strstr(buf, "read_bytes:"))) {
                                DEBUG("system statistic error -- cannot find process read_bytes\n");
                                return false;
                        }
                        if (sscanf(tmp + 11, "\t%"PRIu64, &(proc->read_bytes)) != 1) {
                                DEBUG("system statistic error -- cannot get process read bytes\n");
                                return false;
                        }
                        if (! (tmp = strstr(buf, "write_bytes:"))) {
                                DEBUG("system statistic error -- cannot find process write_bytes\n");
                                return false;
                        }
                        if (sscanf(tmp + 12, "\t%"PRIu64, &(proc->write_bytes)) != 1) {
                                DEBUG("system statistic error -- cannot get process write bytes\n");
                                return false;
                        }
                }
        }
        return true;
}


// parse /proc/PID/cmdline
static boolean_t _parseProcPidCmdline(Proc_T proc, ProcessEngine_Flags pflags) {
        if (pflags & ProcessEngine_CollectCommandLine) {
                int bytes = 0;
                char buf[4096];
                if (! file_readProc(buf, sizeof(buf), "cmdline", proc->pid, &bytes)) {
                        DEBUG("system statistic error -- cannot read /proc/%d/cmdline\n", proc->pid);
                        return false;
                }
                for (int j = 0; j < (bytes - 1); j++) // The cmdline file contains argv elements/strings terminated separated by '\0' => join the string
                        if (buf[j] == 0)
                                buf[j] = ' ';
                if (*buf)
                        snprintf(proc->name, sizeof(proc->name), "%s", buf);
        }
        return true;
}


// parse /proc/PID/attr/current
static boolean_t _parseProcPidAttrCurrent(Proc_T proc) {
        if (file_readProc(proc->secattr, sizeof(proc->secattr), "attr/current", proc->pid, NULL)) {
                Str_trim(proc->secattr);
                return true;
        }
        return false;
}

/* ------------------------------------------------------------------ Public */


boolean_t init_process_info_sysdep(void) {
        if ((hz = sysconf(_SC_CLK_TCK)) <= 0.) {
                DEBUG("system statistic error -- cannot get hz: %s\n", STRERROR);
                return false;
        }

        if ((page_size = sysconf(_SC_PAGESIZE)) <= 0) {
                DEBUG("system statistic error -- cannot get page size: %s\n", STRERROR);
                return false;
        }

        if ((systeminfo.cpu.count = sysconf(_SC_NPROCESSORS_CONF)) < 0) {
                DEBUG("system statistic error -- cannot get cpu count: %s\n", STRERROR);
                return false;
        } else if (systeminfo.cpu.count == 0) {
                DEBUG("system reports cpu count 0, setting dummy cpu count 1\n");
                systeminfo.cpu.count = 1;
        }

        FILE *f = fopen("/proc/meminfo", "r");
        if (f) {
                char line[STRLEN];
                systeminfo.memory.size = 0L;
                while (fgets(line, sizeof(line), f)) {
                        if (sscanf(line, "MemTotal: %"PRIu64, &systeminfo.memory.size) == 1) {
                                systeminfo.memory.size *= 1024;
                                break;
                        }
                }
                fclose(f);
                if (! systeminfo.memory.size)
                        DEBUG("system statistic error -- cannot get real memory amount\n");
        } else {
                DEBUG("system statistic error -- cannot open /proc/meminfo\n");
        }

        f = fopen("/proc/stat", "r");
        if (f) {
                char line[STRLEN];
                systeminfo.booted = 0;
                while (fgets(line, sizeof(line), f)) {
                        if (sscanf(line, "btime %"PRIu64, &systeminfo.booted) == 1) {
                                break;
                        }
                }
                fclose(f);
                if (! systeminfo.booted)
                        DEBUG("system statistic error -- cannot get system boot time\n");
        } else {
                DEBUG("system statistic error -- cannot open /proc/stat\n");
        }

        return true;
}


/**
 * Read all processes of the proc files system to initialize the process tree
 * @param reference reference of ProcessTree
 * @param pflags Process engine flags
 * @return treesize > 0 if succeeded otherwise 0
 */
int initprocesstree_sysdep(ProcessTree_T **reference, ProcessEngine_Flags pflags) {
        ASSERT(reference);

        // Find all processes in the /proc directory
        glob_t globbuf;
        int rv = glob("/proc/[0-9]*", 0, NULL, &globbuf);
        if (rv) {
                LogError("system statistic error -- glob failed: %d (%s)\n", rv, STRERROR);
                return 0;
        }
        ProcessTree_T *pt = CALLOC(sizeof(ProcessTree_T), globbuf.gl_pathc);

        int count = 0;
        struct Proc_T proc = {};
        time_t starttime = _getStartTime();
        for (int i = 0; i < globbuf.gl_pathc; i++) {
                proc.pid = atoi(globbuf.gl_pathv[i] + 6); // skip "/proc/"
                if (_parseProcPidStat(&proc) && _parseProcPidStatus(&proc) && _parseProcPidIO(&proc) && _parseProcPidCmdline(&proc, pflags)) {
                        // Non-mandatory statistics (may not exist)
                        _parseProcPidAttrCurrent(&proc);
                        // Set the data in ptree only if all process related reads succeeded (prevent partial data in the case that continue was called during data collecting)
                        pt[count].pid = proc.pid;
                        pt[count].ppid = proc.ppid;
                        pt[count].cred.uid = proc.uid;
                        pt[count].cred.euid = proc.euid;
                        pt[count].cred.gid = proc.gid;
                        pt[count].threads.self = proc.item_threads;
                        pt[count].uptime = starttime > 0 ? (systeminfo.time / 10. - (starttime + (time_t)(proc.item_starttime / hz))) : 0;
                        pt[count].cpu.time = (double)(proc.item_utime + proc.item_stime) / hz * 10.; // jiffies -> seconds = 1/hz
                        pt[count].memory.usage = (uint64_t)proc.item_rss * (uint64_t)page_size;
                        pt[count].read.bytes = proc.read_bytes;
                        pt[count].write.bytes = proc.write_bytes;
                        pt[count].zombie = proc.item_state == 'Z' ? true : false;
                        pt[count].cmdline = Str_dup(proc.name);
                        pt[count].secattr = Str_dup(proc.secattr);
                        count++;
                        memset(&proc, 0, sizeof(struct Proc_T));
                }
        }

        *reference = pt;
        globfree(&globbuf);

        return count;
}


/**
 * This routine returns 'nelem' double precision floats containing
 * the load averages in 'loadv'; at most 3 values will be returned.
 * @param loadv destination of the load averages
 * @param nelem number of averages
 * @return: 0 if successful, -1 if failed (and all load averages are 0).
 */
int getloadavg_sysdep(double *loadv, int nelem) {
#ifdef HAVE_GETLOADAVG
        return getloadavg(loadv, nelem);
#else
        char buf[STRLEN];
        double load[3];
        if (! file_readProc(buf, sizeof(buf), "loadavg", -1, NULL))
                return -1;
        if (sscanf(buf, "%lf %lf %lf", &load[0], &load[1], &load[2]) != 3) {
                DEBUG("system statistic error -- cannot get load average\n");
                return -1;
        }
        for (int i = 0; i < nelem; i++)
                loadv[i] = load[i];
        return 0;
#endif
}


/**
 * This routine returns real memory in use.
 * @return: true if successful, false if failed
 */
boolean_t used_system_memory_sysdep(SystemInfo_T *si) {
        char          *ptr;
        char           buf[2048];
        unsigned long  mem_free = 0UL;
        unsigned long  buffers = 0UL;
        unsigned long  cached = 0UL;
        unsigned long  slabreclaimable = 0UL;
        unsigned long  swap_total = 0UL;
        unsigned long  swap_free = 0UL;
        uint64_t       zfsarcsize = 0ULL;

        if (! file_readProc(buf, sizeof(buf), "meminfo", -1, NULL)) {
                LogError("system statistic error -- cannot get real memory free amount\n");
                goto error;
        }

        /* Memory */
        if (! (ptr = strstr(buf, "MemFree:")) || sscanf(ptr + 8, "%ld", &mem_free) != 1) {
                LogError("system statistic error -- cannot get real memory free amount\n");
                goto error;
        }
        if (! (ptr = strstr(buf, "Buffers:")) || sscanf(ptr + 8, "%ld", &buffers) != 1)
                DEBUG("system statistic error -- cannot get real memory buffers amount\n");
        if (! (ptr = strstr(buf, "Cached:")) || sscanf(ptr + 7, "%ld", &cached) != 1)
                DEBUG("system statistic error -- cannot get real memory cache amount\n");
        if (! (ptr = strstr(buf, "SReclaimable:")) || sscanf(ptr + 13, "%ld", &slabreclaimable) != 1)
                DEBUG("system statistic error -- cannot get slab reclaimable memory amount\n");
        FILE *f = fopen("/proc/spl/kstat/zfs/arcstats", "r");
        if (f) {
                char line[STRLEN];
                while (fgets(line, sizeof(line), f)) {
                        if (sscanf(line, "size %*d %"PRIu64, &zfsarcsize) == 1) {
                                break;
                        }
                }
                fclose(f);
        }
        si->memory.usage.bytes = systeminfo.memory.size - zfsarcsize - (uint64_t)(mem_free + buffers + cached + slabreclaimable) * 1024;

        /* Swap */
        if (! (ptr = strstr(buf, "SwapTotal:")) || sscanf(ptr + 10, "%ld", &swap_total) != 1) {
                LogError("system statistic error -- cannot get swap total amount\n");
                goto error;
        }
        if (! (ptr = strstr(buf, "SwapFree:")) || sscanf(ptr + 9, "%ld", &swap_free) != 1) {
                LogError("system statistic error -- cannot get swap free amount\n");
                goto error;
        }
        si->swap.size = (uint64_t)swap_total * 1024;
        si->swap.usage.bytes = (uint64_t)(swap_total - swap_free) * 1024;

        return true;

error:
        si->memory.usage.bytes = 0ULL;
        si->swap.size = 0ULL;
        return false;
}


/**
 * This routine returns system/user CPU time in use.
 * @return: true if successful, false if failed (or not available)
 */
boolean_t used_system_cpu_sysdep(SystemInfo_T *si) {
        boolean_t rv;
        unsigned long long cpu_total;
        unsigned long long cpu_user;
        unsigned long long cpu_nice;
        unsigned long long cpu_syst;
        unsigned long long cpu_idle;
        unsigned long long cpu_wait;
        unsigned long long cpu_irq;
        unsigned long long cpu_softirq;
        char buf[STRLEN];

        if (! file_readProc(buf, sizeof(buf), "stat", -1, NULL)) {
                LogError("system statistic error -- cannot read /proc/stat\n");
                goto error;
        }

        rv = sscanf(buf, "cpu %llu %llu %llu %llu %llu %llu %llu",
                    &cpu_user,
                    &cpu_nice,
                    &cpu_syst,
                    &cpu_idle,
                    &cpu_wait,
                    &cpu_irq,
                    &cpu_softirq);
        if (rv < 4) {
                LogError("system statistic error -- cannot read cpu usage\n");
                goto error;
        } else if (rv == 4) {
                /* linux 2.4.x doesn't support these values */
                cpu_wait    = 0;
                cpu_irq     = 0;
                cpu_softirq = 0;
        }

        cpu_total = cpu_user + cpu_nice + cpu_syst + cpu_idle + cpu_wait + cpu_irq + cpu_softirq;
        cpu_user  = cpu_user + cpu_nice;

        if (old_cpu_total == 0) {
                si->cpu.usage.user = -1.;
                si->cpu.usage.system = -1.;
                si->cpu.usage.wait = -1.;
        } else {
                double delta = cpu_total - old_cpu_total;
                si->cpu.usage.user = (double)(cpu_user - old_cpu_user) / delta * 100.;
                si->cpu.usage.system = (double)(cpu_syst - old_cpu_syst) / delta * 100.;
                si->cpu.usage.wait = (double)(cpu_wait - old_cpu_wait) / delta * 100.;
        }

        old_cpu_user  = cpu_user;
        old_cpu_syst  = cpu_syst;
        old_cpu_wait  = cpu_wait;
        old_cpu_total = cpu_total;
        return true;

error:
        si->cpu.usage.user = 0.;
        si->cpu.usage.system = 0.;
        si->cpu.usage.wait = 0.;
        return false;
}


