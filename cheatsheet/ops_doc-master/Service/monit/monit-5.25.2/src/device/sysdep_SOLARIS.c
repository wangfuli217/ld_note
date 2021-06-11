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

/**
 *  System dependent filesystem methods.
 *
 *  @file
 */

#include "config.h"

#ifdef HAVE_STDIO_H
#include <stdio.h>
#endif

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif

#ifdef HAVE_STRINGS_H
#include <strings.h>
#endif

#ifdef HAVE_KSTAT_H
#include <kstat.h>
#endif

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#ifdef HAVE_SYS_STATVFS_H
#include <sys/statvfs.h>
#endif

#ifdef HAVE_SYS_MNTENT_H
#include <sys/mntent.h>
#endif

#ifdef HAVE_SYS_MNTTAB_H
#include <sys/mnttab.h>
#endif

#ifdef HAVE_LIBZFS_H
#include <libzfs.h>
#endif

#ifdef HAVE_NVPAIR_H
#include <sys/nvpair.h>
#endif

#ifdef HAVE_FS_ZFS_H
#include <sys/fs/zfs.h>
#endif

#include "monit.h"

// libmonit
#include "system/Time.h"
#include "io/File.h"


/* ------------------------------------------------------------- Definitions */


#define PATHTOINST "/etc/path_to_inst"


static struct {
        int generation;     // Increment each time the mount table is changed
        uint64_t timestamp; // /etc/mnttab timestamp [ms] (changed on mount/unmount)
} _statistics = {};


/* ----------------------------------------------------------------- Private */


static boolean_t _getDummyDiskActivity(void *_inf) {
        return true;
}


static boolean_t _getZfsDiskActivity(void *_inf) {
        Info_T inf = _inf;
        boolean_t rv = false;
        libzfs_handle_t *z = libzfs_init();
        libzfs_print_on_error(z, 1);
        zpool_handle_t *zp = zpool_open_canfail(z, inf->filesystem->object.key);
        if (zp) {
                nvlist_t *zpoolConfig = zpool_get_config(zp, NULL);
                nvlist_t *zpoolVdevTree = NULL;
                if (nvlist_lookup_nvlist(zpoolConfig, ZPOOL_CONFIG_VDEV_TREE, &zpoolVdevTree) == 0) {
                        vdev_stat_t *zpoolStatistics = NULL;
                        uint_t zpoolStatisticsCount = 0;
                        if (nvlist_lookup_uint64_array(zpoolVdevTree, ZPOOL_CONFIG_VDEV_STATS, (uint64_t **)&zpoolStatistics, &zpoolStatisticsCount) == 0) {
                                //FIXME: if the zpool state has error, trigger the fs event, can also report number of read/write/checksum errors (see vdev_stat_t in /usr/include/sys/fs/zfs.h)
                                DEBUG("ZFS pool '%s' state: %s\n", inf->filesystem->object.key, zpool_state_to_name(zpoolStatistics->vs_state, zpoolStatistics->vs_aux));
                                uint64_t now = Time_milli();
                                Statistics_update(&(inf->filesystem->read.bytes), now, zpoolStatistics->vs_bytes[ZIO_TYPE_READ]);
                                Statistics_update(&(inf->filesystem->write.bytes), now, zpoolStatistics->vs_bytes[ZIO_TYPE_WRITE]);
                                Statistics_update(&(inf->filesystem->read.operations),  now, zpoolStatistics->vs_ops[ZIO_TYPE_READ]);
                                Statistics_update(&(inf->filesystem->write.operations), now, zpoolStatistics->vs_ops[ZIO_TYPE_WRITE]);
                                rv = true;
                        }
                }
                zpool_close(zp);
        }
        libzfs_fini(z);
        return rv;
}


static boolean_t _getKstatDiskActivity(void *_inf) {
        Info_T inf = _inf;
        boolean_t rv = false;
        kstat_ctl_t *kctl = kstat_open();
        if (kctl) {
                kstat_t *kstat;
                for (kstat = kctl->kc_chain; kstat; kstat = kstat->ks_next) {
                        if (kstat->ks_type == KSTAT_TYPE_IO && kstat->ks_instance == inf->filesystem->object.instance && IS(kstat->ks_module, inf->filesystem->object.module) && IS(kstat->ks_name, inf->filesystem->object.key)) {
                                static kstat_io_t kio;
                                if (kstat_read(kctl, kstat, &kio) == -1) {
                                        LogError("filesystem statistics error: kstat_read failed -- %s\n", STRERROR);
                                } else {
                                        uint64_t now = Time_milli();
                                        Statistics_update(&(inf->filesystem->read.bytes), now, kio.nread);
                                        Statistics_update(&(inf->filesystem->write.bytes), now, kio.nwritten);
                                        Statistics_update(&(inf->filesystem->read.operations),  now, kio.reads);
                                        Statistics_update(&(inf->filesystem->write.operations), now, kio.writes);
                                        Statistics_update(&(inf->filesystem->time.wait), now, kio.wtime / 1000000.);
                                        Statistics_update(&(inf->filesystem->time.run), now, kio.rtime / 1000000.);
                                        rv = true;
                                }
                        }
                }
                kstat_close(kctl);
        }
        return rv;
}


static boolean_t _getDiskUsage(void *_inf) {
        Info_T inf = _inf;
        struct statvfs usage;
        if (statvfs(inf->filesystem->object.mountpoint, &usage) != 0) {
                LogError("Error getting usage statistics for filesystem '%s' -- %s\n", inf->filesystem->object.mountpoint, STRERROR);
                return false;
        }
        int size = usage.f_frsize ? (usage.f_bsize / usage.f_frsize) : 1;
        inf->filesystem->f_bsize = usage.f_bsize;
        inf->filesystem->f_blocks = usage.f_blocks / size;
        inf->filesystem->f_blocksfree = usage.f_bavail / size;
        inf->filesystem->f_blocksfreetotal = usage.f_bfree  / size;
        inf->filesystem->f_files = usage.f_files;
        inf->filesystem->f_filesfree = usage.f_ffree;
        return true;
}


static boolean_t _compareMountpoint(const char *mountpoint, struct extmnttab *mnt) {
        return IS(mountpoint, mnt->mnt_mountp);
}


static boolean_t _compareDevice(const char *device, struct extmnttab *mnt) {
        char target[PATH_MAX] = {};
        return (IS(device, mnt->mnt_special) || (realpath(mnt->mnt_special, target) && IS(device, target)));
}


static boolean_t _setDevice(Info_T inf, const char *path, boolean_t (*compare)(const char *path, struct extmnttab *mnt)) {
        FILE *f = fopen(MNTTAB, "r");
        if (! f) {
                LogError("Cannot open %s\n", MNTTAB);
                return false;
        }
        resetmnttab(f);
        struct extmnttab mnt;
        boolean_t rv = false;
        inf->filesystem->object.generation = _statistics.generation;
        while (getextmntent(f, &mnt, sizeof(struct extmnttab)) == 0) {
                if (compare(path, &mnt)) {
                        strncpy(inf->filesystem->object.device, mnt.mnt_special, sizeof(inf->filesystem->object.device) - 1);
                        strncpy(inf->filesystem->object.mountpoint, mnt.mnt_mountp, sizeof(inf->filesystem->object.mountpoint) - 1);
                        strncpy(inf->filesystem->object.type, mnt.mnt_fstype, sizeof(inf->filesystem->object.type) - 1);
                        inf->filesystem->object.getDiskUsage = _getDiskUsage; // The disk usage method is common for all filesystem types
                        if (! IS(mnt.mnt_mntopts, inf->filesystem->flags)) {
                                if (*(inf->filesystem->flags)) {
                                        inf->filesystem->flagsChanged = true;
                                }
                                snprintf(inf->filesystem->flags, sizeof(inf->filesystem->flags), "%s", mnt.mnt_mntopts);
                        }
                        if (Str_startsWith(mnt.mnt_fstype, MNTTYPE_NFS)) {
                                strncpy(inf->filesystem->object.module, "nfs", sizeof(inf->filesystem->object.module) - 1);
                                snprintf(inf->filesystem->object.key, sizeof(inf->filesystem->object.key), "nfs%d", mnt.mnt_minor);
                                inf->filesystem->object.instance = mnt.mnt_minor;
                                inf->filesystem->object.getDiskActivity = _getKstatDiskActivity;
                                rv = true;
                        } else if (IS(mnt.mnt_fstype, MNTTYPE_ZFS)) {
                                strncpy(inf->filesystem->object.module, "zfs", sizeof(inf->filesystem->object.module) - 1);
                                char *slash = strchr(mnt.mnt_special, '/');
                                strncpy(inf->filesystem->object.key, mnt.mnt_special, slash ? slash - mnt.mnt_special : sizeof(inf->filesystem->object.key) - 1);
                                inf->filesystem->object.getDiskActivity = _getZfsDiskActivity;
                                rv = true;
                        } else if (IS(mnt.mnt_fstype, MNTTYPE_UFS)) {
                                char special[PATH_MAX];
                                if (! realpath(mnt.mnt_special, special)) {
                                        // If the file doesn't exist it's a virtual filesystem -> ENOENT doesn't mean error
                                        if (errno != ENOENT && errno != ENOTDIR)
                                                LogError("Lookup for '%s' filesystem failed -- %s\n", path, STRERROR);
                                } else if (! Str_startsWith(special, "/devices/")) {
                                        LogError("Lookup for '%s' filesystem -- invalid device %s\n", path, special);
                                } else {
                                        // Strip "/devices" prefix and :X partition postfix: /devices/pci@0,0/pci15ad,1976@10/sd@0,0:a -> /pci@0,0/pci15ad,1976@10/sd@0,0
                                        int speclen = strlen(special);
                                        int devlen = strlen("/devices");
                                        int len = speclen - devlen - 2;
                                        inf->filesystem->object.partition = *(special + speclen - 1);
                                        memmove(special, special + devlen, len);
                                        special[len] = 0;
                                        char line[PATH_MAX] = {};
                                        FILE *pti = fopen(PATHTOINST, "r");
                                        if (! pti) {
                                                LogError("Cannot open %s\n", PATHTOINST);
                                        } else {
                                                while (fgets(line, sizeof(line), pti)) {
                                                        char path[1024] = {};
                                                        if (sscanf(line, "\"%1023[^\"]\" %d \"%255[^\"]\"", path, &(inf->filesystem->object.instance), inf->filesystem->object.module) == 3) {
                                                                if (IS(path, special)) {
                                                                        if (IS(inf->filesystem->object.module, "cmdk")) {
                                                                                // the "common disk driver" has no "partition" iostat class, only whole "disk" (at least on Solaris 10)
                                                                                snprintf(inf->filesystem->object.key, sizeof(inf->filesystem->object.key), "%s%d", inf->filesystem->object.module, inf->filesystem->object.instance);
                                                                        } else {
                                                                                // use partition for other drivers
                                                                                snprintf(inf->filesystem->object.key, sizeof(inf->filesystem->object.key), "%s%d,%c", inf->filesystem->object.module, inf->filesystem->object.instance, inf->filesystem->object.partition);
                                                                        }
                                                                        inf->filesystem->object.getDiskActivity = _getKstatDiskActivity;
                                                                        rv = true;
                                                                        break;
                                                                }
                                                        }
                                                }
                                                fclose(pti);
                                        }
                                }
                        } else {
                                inf->filesystem->object.getDiskActivity = _getDummyDiskActivity;
                                rv = true;
                        }
                        fclose(f);
                        inf->filesystem->object.mounted = rv;
                        return rv;
                }
        }
        LogError("Lookup for '%s' filesystem failed  -- not found in %s\n", path, MNTTAB);
        fclose(f);
        inf->filesystem->object.mounted = false;
        return false;
}


static boolean_t _getDevice(Info_T inf, const char *path, boolean_t (*compare)(const char *path, struct extmnttab *mnt)) {
        struct stat sb;
        if (stat(MNTTAB, &sb) != 0 || _statistics.timestamp != (uint64_t)((double)sb.st_mtim.tv_sec * 1000. + (double)sb.st_mtim.tv_nsec / 1000000.)) {
                DEBUG("Mount notification: change detected\n");
                _statistics.timestamp = (double)sb.st_mtim.tv_sec * 1000. + (double)sb.st_mtim.tv_nsec / 1000000.;
                _statistics.generation++; // Increment, so all other filesystems can see the generation has changed
        }
        if (inf->filesystem->object.generation != _statistics.generation) {
                _setDevice(inf, path, compare); // The mount table has changed => refresh
        }
        if (inf->filesystem->object.mounted) {
                return (inf->filesystem->object.getDiskUsage(inf) && inf->filesystem->object.getDiskActivity(inf));
        }
        return false;
}


/* ------------------------------------------------------------------ Public */


boolean_t Filesystem_getByMountpoint(Info_T inf, const char *path) {
        ASSERT(inf);
        ASSERT(path);
        return _getDevice(inf, path, _compareMountpoint);
}


boolean_t Filesystem_getByDevice(Info_T inf, const char *path) {
        ASSERT(inf);
        ASSERT(path);
        return _getDevice(inf, path, _compareDevice);
}

