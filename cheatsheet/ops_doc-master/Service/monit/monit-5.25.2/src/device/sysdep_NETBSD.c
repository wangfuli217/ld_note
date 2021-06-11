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

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#ifdef HAVE_SYS_PARAM_H
#include <sys/param.h>
#endif

#ifdef HAVE_CTYPE_H
#include <ctype.h>
#endif

#ifdef HAVE_SYS_SYSCTL_H
#include <sys/sysctl.h>
#endif

#ifdef HAVE_SYS_MOUNT_H
#include <sys/mount.h>
#endif

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#ifdef HAVE_SYS_STATVFS_H
#include <sys/statvfs.h>
#endif

#ifdef HAVE_SYS_IOSTAT_H
#include <sys/iostat.h>
#endif


#include "monit.h"

// libmonit
#include "system/Time.h"
#include "io/File.h"


/* ------------------------------------------------------------- Definitions */


static struct {
        uint64_t timestamp;
        size_t diskCount;
        size_t diskLength;
        struct io_sysctl *disk;
} _statistics = {};


/* ------------------------------------------------------- Static destructor */


static void __attribute__ ((destructor)) _destructor() {
        FREE(_statistics.disk);
}


/* ----------------------------------------------------------------- Private */


// Parse the device path like /dev/sd0a -> sd0
static boolean_t _parseDevice(const char *path, Device_T device) {
        const unsigned char *base = File_basename(path);
        for (int len = strlen(base), i = len - 1; i >= 0; i--) {
                if (isdigit(*(base + i))) {
                        strncpy(device->key, base, i + 1 < sizeof(device->key) ? i + 1 : sizeof(device->key) - 1);
                        return true;
                }
        }
        return false;
}


static boolean_t _getStatistics(uint64_t now) {
        // Refresh only if the statistics are older then 1 second (handle also backward time jumps)
        if (now > _statistics.timestamp + 1000 || now < _statistics.timestamp - 1000) {
                size_t len = 0;
                int mib[3] = {CTL_HW, HW_IOSTATS, sizeof(struct io_sysctl)};
                if (sysctl(mib, 3, NULL, &len, NULL, 0) == -1) {
                        LogError("filesystem statistic error -- cannot get HW_IOSTATS size: %s\n", STRERROR);
                        return false;
                }
                if (_statistics.diskLength != len) {
                        _statistics.diskCount = len / mib[2];
                        _statistics.diskLength = len;
                        RESIZE(_statistics.disk, len);
                }
                if (sysctl(mib, 3, _statistics.disk, &(_statistics.diskLength), NULL, 0) == -1) {
                        LogError("filesystem statistic error -- cannot get HW_IOSTATS: %s\n", STRERROR);
                        return false;
                }
                _statistics.timestamp = now;
        }
        return true;
}


static boolean_t _getDummyDiskActivity(void *_inf) {
        return true;
}


static boolean_t _getBlockDiskActivity(void *_inf) {
        Info_T inf = _inf;
        uint64_t now = Time_milli();
        boolean_t rv = _getStatistics(now);
        if (rv) {
                for (int i = 0; i < _statistics.diskCount; i++)     {
                        if (Str_isEqual(inf->filesystem->object.key, _statistics.disk[i].name)) {
                                Statistics_update(&(inf->filesystem->read.bytes), now, _statistics.disk[i].rbytes);
                                Statistics_update(&(inf->filesystem->write.bytes), now, _statistics.disk[i].wbytes);
                                Statistics_update(&(inf->filesystem->read.operations),  now, _statistics.disk[i].rxfer);
                                Statistics_update(&(inf->filesystem->write.operations), now, _statistics.disk[i].wxfer);
                                Statistics_update(&(inf->filesystem->time.run), now, _statistics.disk[i].time_sec * 1000. + _statistics.disk[i].time_usec / 1000.);
                                break;
                        }
                }
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
        inf->filesystem->f_bsize = usage.f_frsize;
        inf->filesystem->f_blocks = usage.f_blocks;
        inf->filesystem->f_blocksfree = usage.f_bavail;
        inf->filesystem->f_blocksfreetotal = usage.f_bfree;
        inf->filesystem->f_files = usage.f_files;
        inf->filesystem->f_filesfree = usage.f_ffree;
        return true;
}


static boolean_t _compareMountpoint(const char *mountpoint, struct statvfs *mnt) {
        return IS(mountpoint, mnt->f_mntonname);
}


static boolean_t _compareDevice(const char *device, struct statvfs *mnt) {
        return IS(device, mnt->f_mntfromname);
}


static void _filesystemFlagsToString(Info_T inf, uint64_t flags) {
        struct mystable {
                uint64_t flag;
                char *description;
        } t[]= {
#ifdef MNT_DISCARD
                {MNT_DISCARD, "discard"},
#endif
                {MNT_RDONLY, "ro"},
                {MNT_SYNCHRONOUS, "synchronous"},
                {MNT_NOEXEC, "noexec"},
                {MNT_NOSUID, "nosuid"},
                {MNT_NODEV, "nodev"},
                {MNT_NODEVMTIME, "nodevmtime"},
                {MNT_EXTATTR, "extattr"},
                {MNT_IGNORE, "hidden"},
                {MNT_LOG, "log"},
                {MNT_RELATIME, "relatime"},
                {MNT_NOCOREDUMP, "nocoredump"},
                {MNT_ASYNC, "asynchronous"},
                {MNT_NOATIME, "noatime"},
                {MNT_EXRDONLY, "exported read only"},
                {MNT_EXPORTED, "exported"},
                {MNT_DEFEXPORTED, "exported to the world"},
                {MNT_EXPORTANON, "anon uid mapping"},
                {MNT_EXKERB, "exported with kerberos"},
                {MNT_EXPUBLIC, "public export"},
                {MNT_EXNORESPORT, "no reserved ports enforcement"},
                {MNT_LOCAL, "local"},
                {MNT_QUOTA, "quota"},
                {MNT_ROOTFS, "rootfs"},
                {MNT_SOFTDEP, "soft dependencies"},
                {MNT_SYMPERM, "symperm"},
                {MNT_UNION, "union"}
        };
        for (int i = 0, count = 0; i < sizeof(t) / sizeof(t[0]); i++) {
                if (flags & t[i].flag) {
                        snprintf(inf->filesystem->flags + strlen(inf->filesystem->flags), sizeof(inf->filesystem->flags) - strlen(inf->filesystem->flags) - 1, "%s%s", count++ ? ", " : "", t[i].description);
                }
        }
}


static boolean_t _setDevice(Info_T inf, const char *path, boolean_t (*compare)(const char *path, struct statvfs *mnt)) {
        int countfs = getvfsstat(NULL, 0, MNT_NOWAIT);
        if (countfs != -1) {
                struct statvfs *mnt = CALLOC(countfs, sizeof(struct statvfs));
                if ((countfs = getvfsstat(mnt, countfs * sizeof(struct statvfs), MNT_NOWAIT)) != -1) {
                        for (int i = 0; i < countfs; i++) {
                                struct statvfs *mntItem = mnt + i;
                                if (compare(path, mntItem)) {
                                        if (IS(mntItem->f_fstypename, "ffs")) {
                                                if (_parseDevice(mntItem->f_mntfromname, &(inf->filesystem->object))) {
                                                        inf->filesystem->object.getDiskActivity = _getBlockDiskActivity;
                                                } else {
                                                        inf->filesystem->object.getDiskActivity = _getDummyDiskActivity;
                                                        DEBUG("I/O monitoring for filesystem '%s' skipped - unable to parse the device %s", path, mntItem->f_mntfromname);
                                                }
                                        } else {
                                                //FIXME: NetBSD kernel has NFS statistics as well, but there is no clear mapping between the kernel label ("nfsX" style) and the NFS mount => we don't support NFS currently
                                                inf->filesystem->object.getDiskActivity = _getDummyDiskActivity;
                                        }
                                        if ((mntItem->f_flag & MNT_VISFLAGMASK) != inf->filesystem->object.flags) {
                                                if (inf->filesystem->object.flags) {
                                                        inf->filesystem->flagsChanged = true;
                                                }
                                                inf->filesystem->object.flags = mntItem->f_flag & MNT_VISFLAGMASK;
                                                _filesystemFlagsToString(inf, inf->filesystem->object.flags);
                                        }
                                        strncpy(inf->filesystem->object.device, mntItem->f_mntfromname, sizeof(inf->filesystem->object.device) - 1);
                                        strncpy(inf->filesystem->object.mountpoint, mntItem->f_mntonname, sizeof(inf->filesystem->object.mountpoint) - 1);
                                        strncpy(inf->filesystem->object.type, mntItem->f_fstypename, sizeof(inf->filesystem->object.type) - 1);
                                        inf->filesystem->object.getDiskUsage = _getDiskUsage;
                                        inf->filesystem->object.mounted = true;
                                        FREE(mnt);
                                        return true;
                                }
                        }
                }
                FREE(mnt);
        }
        LogError("Lookup for '%s' filesystem failed\n", path);
error:
        inf->filesystem->object.mounted = false;
        return false;
}


static boolean_t _getDevice(Info_T inf, const char *path, boolean_t (*compare)(const char *path, struct statvfs *mnt)) {
        if (_setDevice(inf, path, compare)) {
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

