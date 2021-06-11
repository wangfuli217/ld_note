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

#ifdef HAVE_STRINGS_H
#include <strings.h>
#endif

#ifdef HAVE_MNTENT_H
#include <mntent.h>
#endif

#ifdef HAVE_SYS_STATFS_H
#include <sys/statfs.h>
#endif

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#ifdef HAVE_SYS_VAR_H
#include <sys/var.h>
#endif

#ifdef HAVE_SYS_PROTOSW_H
#include <sys/protosw.h>
#endif

#ifdef HAVE_LIBPERFSTAT_H
#include <libperfstat.h>
#endif

#ifdef HAVE_LVM_H
#include <lvm.h>
#endif

#include "monit.h"


/* ------------------------------------------------------------- Definitions */


static struct {
        boolean_t iostatEnabled;
} _statistics = {};


/* --------------------------------------- Static constructor and destructor */


static void __attribute__ ((constructor)) _constructor() {
        // Check if iostat is enabled (disabled by default)
        struct vario v;
        sys_parm(SYSP_GET, SYSP_V_IOSTRUN, &v);
        _statistics.iostatEnabled = v.v.v_iostrun.value;
        if (! _statistics.iostatEnabled) {
                DEBUG("Enabling iostat\n");
                v.v.v_iostrun.value = 1;
                sys_parm(SYSP_SET, SYSP_V_IOSTRUN, &v);
        }
}


static void __attribute__ ((destructor)) _destructor() {
        // Return the iostat settings back to its original settings on exit
        if (! _statistics.iostatEnabled) {
                DEBUG("Disabling iostat\n");
                struct vario v;
                v.v.v_iostrun.value = 0;
                sys_parm(SYSP_SET, SYSP_V_IOSTRUN, &v);
        }
}


/* ----------------------------------------------------------------- Private */


static boolean_t _getDummyDiskActivity(void *_inf) {
        return true;
}


static boolean_t _getDiskActivity(void *_inf) {
        /*
         * FIXME:
         *
         * The libperfstat provides interface to the disk IO statistics per physical device (for example "hdisk0),
         * but the filesystem/volumes are usually part of LVM and thus we need to map physical device to LVM volume
         * and reflect the RAID configuration too.
         *
         * Example of volume group rootvg, which contains only one physical volume/disk (hdisk0) and multiple logical
         * volumes on top:
         *
         *    # lsvg -p rootvg
         *    rootvg:
         *    PV_NAME           PV STATE          TOTAL PPs   FREE PPs    FREE DISTRIBUTION
         *    hdisk0            active            542         100         00..00..00..00..100
         *
         *    # lsvg -l rootvg
         *    rootvg:
         *    LV NAME             TYPE       LPs     PPs     PVs  LV STATE      MOUNT POINT
         *    hd5                 boot       1       1       1    closed/syncd  N/A
         *    hd6                 paging     16      16      1    open/syncd    N/A
         *    hd8                 jfs2log    1       1       1    open/syncd    N/A
         *    hd4                 jfs2       106     106     1    open/syncd    /
         *    hd2                 jfs2       152     152     1    open/syncd    /usr
         *    hd9var              jfs2       3       3       1    open/syncd    /var
         *    hd3                 jfs2       2       2       1    open/syncd    /tmp
         *    hd1                 jfs2       1       1       1    open/syncd    /home
         *    hd10opt             jfs2       124     124     1    open/syncd    /opt
         *    hd11admin           jfs2       4       4       1    open/syncd    /admin
         *    lg_dumplv           sysdump    32      32      1    open/syncd    N/A
         *
         * The mntent which we use in _setDevice() doesn't provide mapping between the physical and logical volume, example:
         *
         *    mnt_fsname=/dev/hd1, mnt_dir=/home, mnt_type=jfs2, mnt_opts=rw,log=/dev/hd8
         *
         * The libperfstat provides perfstat_disk() interface -> perfstat_disk_t entry example:
         *
         *    name=hdisk0, description=16 Bit LVD SCSI Disk Drive, vgname=rootvg, adapter=sisscsia0
         *
         * We can use liblvm (lvm_queryvgs() and lvm_queryvg()) to do the physical-logical mapping (note: it can be many-to-many
         * layout in the case of RAID).
         */
        return true;
}


static boolean_t _getDiskUsage(void *_inf) {
        Info_T inf = _inf;
        struct statfs usage;
        if (statfs(inf->filesystem->object.mountpoint, &usage) != 0) {
                LogError("Error getting usage statistics for filesystem '%s' -- %s\n", inf->filesystem->object.mountpoint, STRERROR);
                return false;
        }
        inf->filesystem->f_bsize = usage.f_bsize;
        inf->filesystem->f_blocks = usage.f_blocks;
        inf->filesystem->f_blocksfree = usage.f_bavail;
        inf->filesystem->f_blocksfreetotal = usage.f_bfree;
        inf->filesystem->f_files = usage.f_files;
        inf->filesystem->f_filesfree = usage.f_ffree;
        return true;
}


static boolean_t _compareMountpoint(const char *mountpoint, struct mntent *mnt) {
        return IS(mountpoint, mnt->mnt_dir);
}


static boolean_t _compareDevice(const char *device, struct mntent *mnt) {
        return IS(device, mnt->mnt_fsname);
}


static boolean_t _setDevice(Info_T inf, const char *path, boolean_t (*compare)(const char *path, struct mntent *mnt)) {
        FILE *f = setmntent(MOUNTED, "r");
        if (! f) {
                LogError("Cannot open %s\n", MOUNTED);
                return false;
        }
        struct mntent *mnt;
        while ((mnt = getmntent(f))) {
                if (compare(path, mnt)) {
                        strncpy(inf->filesystem->object.device, mnt->mnt_fsname, sizeof(inf->filesystem->object.device) - 1);
                        strncpy(inf->filesystem->object.mountpoint, mnt->mnt_dir, sizeof(inf->filesystem->object.mountpoint) - 1);
                        strncpy(inf->filesystem->object.type, mnt->mnt_type, sizeof(inf->filesystem->object.type) - 1);
                        if (! IS(mnt->mnt_opts, inf->filesystem->flags)) {
                                if (*(inf->filesystem->flags)) {
                                        inf->filesystem->flagsChanged = true;
                                }
                                snprintf(inf->filesystem->flags, sizeof(inf->filesystem->flags), "%s", mnt->mnt_opts);
                        }
                        inf->filesystem->object.getDiskUsage = _getDiskUsage;
                        if (Str_startsWith(mnt->mnt_type, "jfs")) {
                                inf->filesystem->object.getDiskActivity = _getDiskActivity;
                        } else {
                                inf->filesystem->object.getDiskActivity = _getDummyDiskActivity;
                        }
                        endmntent(f);
                        inf->filesystem->object.mounted = true;
                        return true;
                }
        }
        LogError("Lookup for '%s' filesystem failed  -- not found in %s\n", path, MOUNTED);
        endmntent(f);
        inf->filesystem->object.mounted = false;
        return false;
}


static boolean_t _getDevice(Info_T inf, const char *path, boolean_t (*compare)(const char *path, struct mntent *mnt)) {
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

