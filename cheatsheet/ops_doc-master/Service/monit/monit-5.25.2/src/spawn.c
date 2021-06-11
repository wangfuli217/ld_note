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

#ifdef HAVE_SIGNAL_H
#include <signal.h>
#endif

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#ifdef HAVE_STRINGS_H
#include <strings.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#ifdef HAVE_SYS_WAIT_H
#include <sys/wait.h>
#endif

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#ifdef HAVE_SYS_STAT_H
#include <sys/stat.h>
#endif

#ifdef HAVE_FCNTL_H
#include <fcntl.h>
#endif

#ifdef HAVE_PWD_H
#include <pwd.h>
#endif

#ifdef HAVE_GRP_H
#include <grp.h>
#endif

#include "event.h"
#include "alert.h"
#include "monit.h"
#include "engine.h"

// libmonit
#include "util/Str.h"
#include "system/Time.h"


/**
 *  Function for spawning of a process. This function fork's twice to
 *  avoid creating any zombie processes. Inspired by code from
 *  W. Richard Stevens book, APUE.
 *
 *  @file
 */


/* ------------------------------------------------------------- Definitions */


/* Do not exceed 8 bits here */
enum ExitStatus_E {
        setgid_ERROR     = 0x1,
        setuid_ERROR     = 0x2,
        initgroups_ERROR = 0x4,
        redirect_ERROR   = 0x8,
        fork_ERROR       = 0x10,
        getpwuid_ERROR   = 0x20
} __attribute__((__packed__));


/* ----------------------------------------------------------------- Private */


/*
 * Setup the environment with special MONIT_xxx variables. The program
 * executed may use such variable for various purposes.
 */
static void _setMonitEnvironment(Service_T S, command_t C, Event_T E, const char *date) {
        setenv("MONIT_DATE", date, 1);
        setenv("MONIT_SERVICE", S->name, 1);
        setenv("MONIT_HOST", Run.system->name, 1);
        setenv("MONIT_EVENT", E ? Event_get_description(E) : C == S->start ? "Started" : C == S->stop ? "Stopped" : "No Event", 1);
        setenv("MONIT_DESCRIPTION", E ? E->message : C == S->start ? "Started" : C == S->stop ? "Stopped" : "No Event", 1);
        switch (S->type) {
                case Service_Process:
                        putenv(Str_cat("MONIT_PROCESS_PID=%d", S->inf.process->pid));
                        putenv(Str_cat("MONIT_PROCESS_MEMORY=%llu", (unsigned long long)((double)S->inf.process->mem / 1024.)));
                        putenv(Str_cat("MONIT_PROCESS_CHILDREN=%d", S->inf.process->children));
                        putenv(Str_cat("MONIT_PROCESS_CPU_PERCENT=%.1f", S->inf.process->cpu_percent));
                        break;
                case Service_Program:
                        putenv(Str_cat("MONIT_PROGRAM_STATUS=%d", S->program->exitStatus));
                        break;
                default:
                        break;
        }
}


/* ------------------------------------------------------------------ Public */


/**
 * Execute the given command. If the execution fails, the wait_start()
 * thread in control.c should notice this and send an alert message.
 * @param S A Service object
 * @param C A Command object
 * @param E An optional event object. May be NULL.
 */
void spawn(Service_T S, command_t C, Event_T E) {
        pid_t pid;
        sigset_t mask;
        sigset_t save;
        int stat_loc = 0;
        int exit_status;
        char date[42];

        ASSERT(S);
        ASSERT(C);

        if (access(C->arg[0], X_OK) != 0) {
                LogError("Error: Could not execute %s\n", C->arg[0]);
                return;
        }

        /*
         * Block SIGCHLD
         */
        sigemptyset(&mask);
        sigaddset(&mask, SIGCHLD);
        pthread_sigmask(SIG_BLOCK, &mask, &save);

        Time_string(Time_now(), date);
        pid = fork();
        if (pid < 0) {
                LogError("Cannot fork a new process -- %s\n", STRERROR);
                pthread_sigmask(SIG_SETMASK, &save, NULL);
                return;
        }

        if (pid == 0) {
                if (C->has_gid) {
                        if (setgid(C->gid) != 0) {
                                stat_loc |= setgid_ERROR;
                        }
                }
                if (C->has_uid) {
                        struct passwd *user = getpwuid(C->uid);
                        if (user) {
                                setenv("HOME", user->pw_dir, 1);
                                if (initgroups(user->pw_name, getgid()) == 0) {
                                        if (setuid(C->uid) != 0) {
                                                stat_loc |= setuid_ERROR;
                                        }
                                } else {
                                        stat_loc |= initgroups_ERROR;
                                }
                        } else {
                                stat_loc |= getpwuid_ERROR;
                        }
                }

                _setMonitEnvironment(S, C, E, date);

                if (! (Run.flags & Run_Daemon)) {
                        for (int i = 0; i < 3; i++)
                                if (close(i) == -1 || open("/dev/null", O_RDWR) != i)
                                        stat_loc |= redirect_ERROR;
                }

                Util_closeFds();

                setsid();

                pid = fork();
                if (pid < 0) {
                        stat_loc |= fork_ERROR;
                        _exit(stat_loc);
                }

                if (pid == 0) {
                        /*
                         * Reset all signals, so the spawned process is *not* created
                         * with any inherited SIG_BLOCKs
                         */
                        sigemptyset(&mask);
                        pthread_sigmask(SIG_SETMASK, &mask, NULL);
                        signal(SIGINT, SIG_DFL);
                        signal(SIGHUP, SIG_DFL);
                        signal(SIGTERM, SIG_DFL);
                        signal(SIGUSR1, SIG_DFL);
                        signal(SIGPIPE, SIG_DFL);

                        (void) execv(C->arg[0], C->arg);
                        _exit(errno);
                }

                /* Exit first child and return errors to parent */
                _exit(stat_loc);
        }

        /* Wait for first child - aka second parent, to exit */
        if (waitpid(pid, &stat_loc, 0) != pid) {
                LogError("Waitpid error\n");
        }

        exit_status = WEXITSTATUS(stat_loc);
        if (exit_status & setgid_ERROR)
                LogError("Failed to change gid to '%d' for '%s'\n", C->gid, C->arg[0]);
        if (exit_status & setuid_ERROR)
                LogError("Failed to change uid to '%d' for '%s'\n", C->uid, C->arg[0]);
        if (exit_status & initgroups_ERROR)
                LogError("initgroups for UID %d failed when executing '%s'\n", C->uid, C->arg[0]);
        if (exit_status & fork_ERROR)
                LogError("Cannot fork a new process for '%s'\n", C->arg[0]);
        if (exit_status & redirect_ERROR)
                LogError("Cannot redirect IO to /dev/null for '%s'\n", C->arg[0]);
        if (exit_status & getpwuid_ERROR)
                LogError("UID %d not found on the system when executing '%s'\n", C->uid, C->arg[0]);

        /*
         * Restore the signal mask
         */
        pthread_sigmask(SIG_SETMASK, &save, NULL);

        /*
         * We do not need to wait for the second child since we forked twice,
         * the init system-process will wait for it. So we just return
         */

}

