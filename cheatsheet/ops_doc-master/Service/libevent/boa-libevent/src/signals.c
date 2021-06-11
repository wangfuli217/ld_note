/*
 *  Boa, an http server
 *  Copyright (C) 1995 Paul Phillips <paulp@go2net.com>
 *  Some changes Copyright (C) 1996 Larry Doolittle <ldoolitt@boa.org>
 *  Some changes Copyright (C) 1996-99 Jon Nelson <jnelson@boa.org>
 *  Some changes Copyright (C) 1997 Alain Magloire <alain.magloire@rcsm.ee.mcgill.ca>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 1, or (at your option)
 *  any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */



#include "boa.h"
#ifdef HAVE_SYS_WAIT_H
#include <sys/wait.h>           
#endif
#include <signal.h>             

sigjmp_buf env;
int handle_sigbus;

void sigsegv(evutil_socket_t fd, short what, void *arg);
void sigbus(evutil_socket_t fd, short what, void *arg);
void sigterm(evutil_socket_t fd, short what, void *arg);
void sighup(evutil_socket_t fd, short what, void *arg);
void sigint(evutil_socket_t fd, short what, void *arg);
void sigchld(evutil_socket_t fd, short what, void *arg);
void sigalrm(evutil_socket_t fd, short what, void *arg);

/*
 * Name: init_signals
 * Description: Sets up signal handlers for all our friends.
 */
#if 0
void init_signal(void)
{
    struct sigaction sa;

    sa.sa_flags = 0;

    sigemptyset(&sa.sa_mask);
    sigaddset(&sa.sa_mask, SIGSEGV);
    sigaddset(&sa.sa_mask, SIGBUS);
    sigaddset(&sa.sa_mask, SIGTERM);
    sigaddset(&sa.sa_mask, SIGHUP);
    sigaddset(&sa.sa_mask, SIGINT);
    sigaddset(&sa.sa_mask, SIGPIPE);
    sigaddset(&sa.sa_mask, SIGCHLD);
    sigaddset(&sa.sa_mask, SIGALRM);
    sigaddset(&sa.sa_mask, SIGUSR1);
    sigaddset(&sa.sa_mask, SIGUSR2);

    sa.sa_handler = sigsegv;
    sigaction(SIGSEGV, &sa, NULL);

    sa.sa_handler = sigbus;
    sigaction(SIGBUS, &sa, NULL);

    sa.sa_handler = sigterm;
    sigaction(SIGTERM, &sa, NULL);

    sa.sa_handler = sighup;
    sigaction(SIGHUP, &sa, NULL);

    sa.sa_handler = sigint;
    sigaction(SIGINT, &sa, NULL);

    sa.sa_handler = SIG_IGN;
    sigaction(SIGPIPE, &sa, NULL);

    sa.sa_handler = sigchld;
    sigaction(SIGCHLD, &sa, NULL);

    sa.sa_handler = sigalrm;
    sigaction(SIGALRM, &sa, NULL);

    sa.sa_handler = SIG_IGN;
    sigaction(SIGUSR1, &sa, NULL);

    sa.sa_handler = SIG_IGN;
    sigaction(SIGUSR2, &sa, NULL);
}
#endif 
void init_signals(void)
{
    struct sigaction sa;
    struct event *sigsegv_event, *sigbus_event, *sigint_event, *sigterm_event, *sighup_event, *sigalrm_event, *sigchld_event;

    sa.sa_flags = 0;

    sigemptyset(&sa.sa_mask);

    sigaddset(&sa.sa_mask, SIGTERM);
    sigaddset(&sa.sa_mask, SIGHUP);
    sigaddset(&sa.sa_mask, SIGPIPE);
    sigaddset(&sa.sa_mask, SIGCHLD);
    sigaddset(&sa.sa_mask, SIGALRM);
    sigaddset(&sa.sa_mask, SIGUSR1);
    sigaddset(&sa.sa_mask, SIGUSR2);
    
    sigsegv_event = event_new(boa_event_base, SIGSEGV, EV_SIGNAL|EV_PERSIST, sigsegv, NULL );
    event_add(sigsegv_event, NULL);

    sigbus_event = event_new(boa_event_base, SIGBUS, EV_SIGNAL|EV_PERSIST, sigbus, NULL );
    event_add(sigbus_event, NULL);

    sigint_event = event_new(boa_event_base, SIGINT, EV_SIGNAL|EV_PERSIST, sigint, NULL );
    event_add(sigint_event, NULL);

    sigterm_event = event_new(boa_event_base, SIGTERM, EV_SIGNAL|EV_PERSIST, sigterm, NULL );
    event_add(sigterm_event, NULL);

    sighup_event = event_new(boa_event_base, SIGHUP, EV_SIGNAL|EV_PERSIST, sighup, NULL );
    event_add(sighup_event, NULL);

    sigchld_event = event_new(boa_event_base, SIGCHLD, EV_SIGNAL|EV_PERSIST, sighup, NULL );
    event_add(sigchld_event, NULL);

    sigalrm_event = event_new(boa_event_base, SIGALRM, EV_SIGNAL|EV_PERSIST, sighup, NULL );
    event_add(sigalrm_event, NULL);

    sa.sa_handler = SIG_IGN;
    sigaction(SIGPIPE, &sa, NULL);
    sigaction(SIGUSR1, &sa, NULL);
    sigaction(SIGUSR2, &sa, NULL);
}

void sigsegv(evutil_socket_t fd, short what, void *arg)
{
    time(&current_time);
    log_error_time();
    fprintf(stderr, "caught SIGSEGV, dumping core in %s\n", tempdir);
    fclose(stderr);
    chdir(tempdir);
    abort();
}

extern sigjmp_buf env;
extern int handle_sigbus;

void sigbus(evutil_socket_t fd, short what, void *arg)
{
    if (handle_sigbus) {
        longjmp(env, 1);
    }
    time(&current_time);
    log_error_time();
    fprintf(stderr, "caught SIGBUS, dumping core in %s\n", tempdir);
    fclose(stderr);
    chdir(tempdir);
    abort();
}

void sigterm(evutil_socket_t fd, short what, void *arg)
{
    sigterm_flag = 1;
}

void sigterm_stage1_run(int server_s) 
{
    time(&current_time);
    log_error_time();
    fputs("caught SIGTERM, starting shutdown\n", stderr);
    FD_CLR(server_s, &block_read_fdset);
    close(server_s);
    sigterm_flag = 2;
}

void sigterm_stage2_run() 
{
    log_error_time();
    fprintf(stderr,
            "exiting Boa normally (uptime %d seconds)\n",
            (int) (current_time - start_time));
    chdir(tempdir);
    clear_common_env();
    dump_mime();
    dump_passwd();
    dump_alias();
    free_requests();
    exit(0);
}


void sighup(evutil_socket_t fd, short what, void *arg)
{
    sighup_flag = 1;
    sighup_run();
}

void sighup_run(void)
{
    sighup_flag = 0;
    time(&current_time);
    log_error_time();
    fputs("caught SIGHUP, restarting\n", stderr);

    /* Philosophy change for 0.92: don't close and attempt reopen of logfiles,
     * since usual permission structure prevents such reopening.
     */

    FD_ZERO(&block_read_fdset);
    FD_ZERO(&block_write_fdset);
    
    dump_mime();
    dump_passwd();
    dump_alias();
    free_requests();

    log_error_time();
    fputs("re-reading configuration files\n", stderr);
    read_config_files();

    log_error_time();
    fputs("successful restart\n", stderr);
}

void sigint(evutil_socket_t fd, short what, void *arg)
{
    time(&current_time);
    log_error_time();
    fputs("caught SIGINT: shutting down\n", stderr);
    fclose(stderr);
    chdir(tempdir);
    exit(1);
}

void sigchld(evutil_socket_t fd, short what, void *arg)
{
    sigchld_flag = 1;
    sigchld_run();
}

void sigchld_run(void)
{
    int status;
    pid_t pid;

    sigchld_flag = 0;

    while ((pid = waitpid(-1, &status, WNOHANG)) > 0)
        if (verbose_cgi_logs) {
            time(&current_time);
            log_error_time();
            fprintf(stderr, "reaping child %d: status %d\n", (int) pid, status);
        }
    return;
}

void sigalrm(evutil_socket_t fd, short what, void *arg)
{
    sigalrm_flag = 1;
    sigalrm_run();
}

void sigalrm_run(void)
{
    time(&current_time);
    log_error_time();
    fprintf(stderr, "%ld requests, %ld errors\n",
            status.requests, status.errors);
    show_hash_stats();
    sigalrm_flag = 0;
}
