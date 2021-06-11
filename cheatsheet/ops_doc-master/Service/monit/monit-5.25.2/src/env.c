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

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif

#ifdef HAVE_PWD_H
#include <pwd.h>
#endif

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#ifdef HAVE_SYS_STAT_H
#include <sys/stat.h>
#endif

#ifdef HAVE_SYS_PARAM_H
#include <sys/param.h>
#endif

#ifdef HAVE_FCNTL_H
#include <fcntl.h>
#endif

#ifdef HAVE_CRT_EXTERNS_H
#include <crt_externs.h>
#endif

#include "monit.h"


// libmonit
#include "io/Dir.h"
#include "exceptions/AssertException.h"


/**
 * Initialize the program environment
 *
 * @see https://bitbucket.org/tildeslash/monit/commits/cd545838378517f84bdb0989cadf461a19d8ba11
 */
void init_env() {
        Util_closeFds();
        // Ensure that std descriptors (0, 1 and 2) are open
        int devnull = open("/dev/null", O_RDWR);
        if (devnull == -1) {
                THROW(AssertException, "Cannot open /dev/null -- %s", STRERROR);
        }
        for (int i = 0; i < 3; i++) {
                struct stat st;
                if (fstat(i, &st) == -1) {
                        if (dup2(devnull, i) < 0) {
                                close(devnull);
                                THROW(AssertException, "dup2 failed -- %s", STRERROR);
                        }
                }
        }
        close(devnull);
        // Get password struct with user info
        char buf[4096];
        struct passwd pw, *result = NULL;
        if (getpwuid_r(geteuid(), &pw, buf, sizeof(buf), &result) != 0 || ! result)
                THROW(AssertException, "getpwuid_r failed -- %s", STRERROR);
        Run.Env.home = Str_dup(pw.pw_dir);
        Run.Env.user = Str_dup(pw.pw_name);
        // Get CWD
        char t[PATH_MAX];
        if (! Dir_cwd(t, PATH_MAX))
                THROW(AssertException, "Monit: Cannot read current directory -- %s", STRERROR);
        Run.Env.cwd = Str_dup(t);
}


