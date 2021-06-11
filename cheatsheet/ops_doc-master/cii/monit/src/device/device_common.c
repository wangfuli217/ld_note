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
 *  System independent filesystem methods.
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

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#ifdef HAVE_SYS_STAT_H
#include <sys/stat.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#include "monit.h"
#include "device.h"


boolean_t filesystem_usage(Service_T s) {
        ASSERT(s);
        struct stat sb;
        boolean_t rv = false;
        int st = lstat(s->path, &sb);
        if (st == 0) {
                if (S_ISLNK(sb.st_mode)) {
                        // Symbolic link: dereference
                        char buf[PATH_MAX] = {};
                        if (! realpath(s->path, buf)) {
                                LogError("Cannot dereference filesystem '%s' (symlink) -- %s\n", s->path, STRERROR);
                                return false;
                        }
                        st = stat(buf, &sb);
                }
        }
        if (st != 0) {
                // The path string is not existing block/character device nor mountpoint - could be:
                //   1. either a filesystem connection string such as NFS/CIFS/SSHFS path
                //   2. or it is mountpoint which doesn't exist (subdirectory of parent filesystem which is not mounted itself or the mountpoint was deleted)
                //   3. or it is a hotplug device which was unconfigured from the system
                // Try to use the Filesystem_getByDevice() which will find case #1 above and keep the error for cases #2 and #3
                if (Filesystem_getByDevice(&(s->inf), s->path)) {
                        // If the device connection string was found, get uid/gid/mode of the mountpoint (connection string itself cannot be stated)
                        if (stat(s->inf.filesystem->object.mountpoint, &sb) == 0) {
                                rv = true;
                        }
                }
        } else {
                char buf[PATH_MAX] = {};
                if (realpath(s->path, buf)) {
                        if (S_ISDIR(sb.st_mode)) {
                                // Directory -> mountpoint
                                rv = Filesystem_getByMountpoint(&(s->inf), buf);
                        } else if (S_ISBLK(sb.st_mode) || S_ISCHR(sb.st_mode)) {
                                // Block or character device
                                rv = Filesystem_getByDevice(&(s->inf), buf);
                        }
                }
        }
        if (rv) {
                s->inf.filesystem->mode = sb.st_mode;
                s->inf.filesystem->uid = sb.st_uid;
                s->inf.filesystem->gid = sb.st_gid;
                s->inf.filesystem->f_filesused = s->inf.filesystem->f_files - s->inf.filesystem->f_filesfree;
                s->inf.filesystem->f_blocksused = s->inf.filesystem->f_blocks - s->inf.filesystem->f_blocksfreetotal;
                s->inf.filesystem->inode_percent = s->inf.filesystem->f_files > 0 ? 100. * (double)s->inf.filesystem->f_filesused / (double)s->inf.filesystem->f_files : 0.;
                s->inf.filesystem->space_percent = s->inf.filesystem->f_blocks > 0 ? 100. * (double)s->inf.filesystem->f_blocksused / (double)s->inf.filesystem->f_blocks : 0.;
        } else {
                Statistics_reset(&(s->inf.filesystem->read.bytes));
                Statistics_reset(&(s->inf.filesystem->read.operations));
                Statistics_reset(&(s->inf.filesystem->write.bytes));
                Statistics_reset(&(s->inf.filesystem->write.operations));
                Statistics_reset(&(s->inf.filesystem->time.read));
                Statistics_reset(&(s->inf.filesystem->time.write));
                Statistics_reset(&(s->inf.filesystem->time.wait));
                Statistics_reset(&(s->inf.filesystem->time.run));
                LogError("Filesystem '%s' not mounted\n", s->path);
        }
        return rv;
}

