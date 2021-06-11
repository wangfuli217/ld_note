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
#include <locale.h>

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

#ifdef HAVE_GETOPT_H
#include <getopt.h>
#endif

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#ifdef HAVE_STRINGS_H
#include <strings.h>
#endif

#ifdef HAVE_CTYPE_H
#include <ctype.h>
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

#ifdef HAVE_SYS_WAIT_H
#include <sys/wait.h>
#endif

#include "monit.h"
#include "net.h"
#include "ProcessTree.h"
#include "state.h"
#include "event.h"
#include "engine.h"
#include "client.h"
#include "MMonit.h"

// libmonit
#include "Bootstrap.h"
#include "io/Dir.h"
#include "io/File.h"
#include "system/Time.h"
#include "util/List.h"
#include "exceptions/AssertException.h"


/**
 *  DESCRIPTION
 *    monit - system for monitoring services on a Unix system
 *
 *  SYNOPSIS
 *    monit [options] {arguments}
 *
 *  @file
 */


/* -------------------------------------------------------------- Prototypes */


static void  do_init(void);                   /* Initialize this application */
static void  do_reinit(void);       /* Re-initialize the runtime application */
static void  do_action(int, char **);    /* Dispatch to the submitted action */
static void  do_exit(boolean_t);                           /* Finalize monit */
static void  do_default(void);                          /* Do default action */
static void  handle_options(int, char **);         /* Handle program options */
static void  help(void);             /* Print program help message to stdout */
static void  version(void);                     /* Print version information */
static void *heartbeat(void *args);              /* M/Monit heartbeat thread */
static RETSIGTYPE do_reload(int);       /* Signalhandler for a daemon reload */
static RETSIGTYPE do_destroy(int);   /* Signalhandler for monit finalization */
static RETSIGTYPE do_wakeup(int);  /* Signalhandler for a daemon wakeup call */
static void waitforchildren(void); /* Wait for any child process not running */



/* ------------------------------------------------------------------ Global */


const char *prog;                              /**< The Name of this Program */
struct Run_T Run;                      /**< Struct holding runtime constants */
Service_T servicelist;                /**< The service list (created in p.y) */
Service_T servicelist_conf;   /**< The service list in conf file (c. in p.y) */
ServiceGroup_T servicegrouplist;/**< The service group list (created in p.y) */
SystemInfo_T systeminfo;                              /**< System infomation */

Thread_T heartbeatThread;
Sem_T    heartbeatCond;
Mutex_T  heartbeatMutex;
static volatile boolean_t heartbeatRunning = false;

char *actionnames[] = {"ignore", "alert", "restart", "stop", "exec", "unmonitor", "start", "monitor", ""};
char *modenames[] = {"active", "passive"};
char *onrebootnames[] = {"start", "nostart", "laststate"};
char *checksumnames[] = {"UNKNOWN", "MD5", "SHA1"};
char *operatornames[] = {"less than", "less than or equal to", "greater than", "greater than or equal to", "equal to", "not equal to", "changed"};
char *operatorshortnames[] = {"<", "<=", ">", ">=", "=", "!=", "<>"};
char *servicetypes[] = {"Filesystem", "Directory", "File", "Process", "Remote Host", "System", "Fifo", "Program", "Network"};
char *pathnames[] = {"Path", "Path", "Path", "Pid file", "Path", "", "Path"};
char *icmpnames[] = {"Reply", "", "", "Destination Unreachable", "Source Quench", "Redirect", "", "", "Ping", "", "", "Time Exceeded", "Parameter Problem", "Timestamp Request", "Timestamp Reply", "Information Request", "Information Reply", "Address Mask Request", "Address Mask Reply"};
char *sslnames[] = {"auto", "v2", "v3", "tlsv1", "tlsv1.1", "tlsv1.2", "tlsv1.3"};
char *socketnames[] = {"unix", "IP", "IPv4", "IPv6"};
char *timestampnames[] = {"modify/change time", "access time", "change time", "modify time"};
char *httpmethod[] = {"", "HEAD", "GET"};


/* ------------------------------------------------------------------ Public */


/**
 * The Prime mover
 */
int main(int argc, char **argv) {
        Bootstrap(); // Bootstrap libmonit
        Bootstrap_setAbortHandler(vLogAbortHandler);  // Abort Monit on exceptions thrown by libmonit
        Bootstrap_setErrorHandler(vLogError);
        setlocale(LC_ALL, "C");
        prog = File_basename(argv[0]);
#ifdef HAVE_OPENSSL
        Ssl_start();
#endif
        init_env();
        handle_options(argc, argv);
        do_init();
        do_action(argc, argv);
        do_exit(false);
        return 0;
}


/**
 * Wakeup a sleeping monit daemon.
 * Returns true on success otherwise false
 */
boolean_t do_wakeupcall() {
        pid_t pid;

        if ((pid = exist_daemon()) > 0) {
                kill(pid, SIGUSR1);
                LogInfo("Monit daemon with PID %d awakened\n", pid);

                return true;
        }

        return false;
}


boolean_t interrupt() {
        return Run.flags & Run_Stopped || Run.flags & Run_DoReload;
}


/* ----------------------------------------------------------------- Private */


static void _validateOnce() {
        if (State_open()) {
                State_restore();
                validate();
                State_save();
                State_close();
        }
}


/**
 * Initialize this application - Register signal handlers,
 * Parse the control file and initialize the program's
 * datastructures and the log system.
 */
static void do_init() {
        /*
         * Register interest for the SIGTERM signal,
         * in case we run in daemon mode this signal
         * will terminate a running daemon.
         */
        signal(SIGTERM, do_destroy);

        /*
         * Register interest for the SIGUSER1 signal,
         * in case we run in daemon mode this signal
         * will wakeup a sleeping daemon.
         */
        signal(SIGUSR1, do_wakeup);

        /*
         * Register interest for the SIGINT signal,
         * in case we run as a server but not as a daemon
         * we need to catch this signal if the user pressed
         * CTRL^C in the terminal
         */
        signal(SIGINT, do_destroy);

        /*
         * Register interest for the SIGHUP signal,
         * in case we run in daemon mode this signal
         * will reload the configuration.
         */
        signal(SIGHUP, do_reload);

        /*
         * Register no interest for the SIGPIPE signal,
         */
        signal(SIGPIPE, SIG_IGN);

        /*
         * Initialize the random number generator
         */
        srandom((unsigned)(Time_now() + getpid()));

        /*
         * Initialize the Runtime mutex. This mutex
         * is used to synchronize handling of global
         * service data
         */
        Mutex_init(Run.mutex);

        /*
         * Initialize heartbeat mutex and condition
         */
        Mutex_init(heartbeatMutex);
        Sem_init(heartbeatCond);

        /*
         * Get the position of the control file
         */
        if (! Run.files.control)
                Run.files.control = file_findControlFile();

        /*
         * Initialize the system information data collecting interface
         */
        if (init_system_info())
                Run.flags |= Run_ProcessEngineEnabled;

        /*
         * Start the Parser and create the service list. This will also set
         * any Runtime constants defined in the controlfile.
         */
        if (! parse(Run.files.control))
                exit(1);

        /*
         * Initialize the log system
         */
        if (! log_init())
                exit(1);

        /*
         * Did we find any service ?
         */
        if (! servicelist) {
                LogError("No service has been specified\n");
                exit(0);
        }

        /*
         * Initialize Runtime file variables
         */
        file_init();

        /*
         * Should we print debug information ?
         */
        if (Run.debug) {
                Util_printRunList();
                Util_printServiceList();
        }

        /*
         * Reap any stray child processes we may have created
         */
        atexit(waitforchildren);
}


/**
 * Re-Initialize the application - called if a
 * monit daemon receives the SIGHUP signal.
 */
static void do_reinit() {
        LogInfo("Reinitializing Monit -- control file '%s'\n", Run.files.control);

        /* Wait non-blocking for any children that has exited. Since we
         reinitialize any information about children we have setup to wait
         for will be lost. This may create zombie processes until Monit
         itself exit. However, Monit will wait on all children that has exited
         before it ifself exit. TODO: Later refactored versions will use a
         globale process table which a sigchld handler can check */
        waitforchildren();

        if (Run.mmonits && heartbeatRunning) {
                Sem_signal(heartbeatCond);
                Thread_join(heartbeatThread);
                heartbeatRunning = false;
        }

        Run.flags &= ~Run_DoReload;

        /* Stop http interface */
        if (Run.httpd.flags & Httpd_Net || Run.httpd.flags & Httpd_Unix)
                monit_http(Httpd_Stop);

        /* Save the current state (no changes are possible now since the http thread is stopped) */
        State_save();
        State_close();

        /* Run the garbage collector */
        gc();

        if (! parse(Run.files.control)) {
                LogError("%s stopped -- error parsing configuration file\n", prog);
                exit(1);
        }

        /* Close the current log */
        log_close();

        /* Reinstall the log system */
        if (! log_init())
                exit(1);

        /* Did we find any services ?  */
        if (! servicelist) {
                LogError("No service has been specified\n");
                exit(0);
        }

        /* Reinitialize Runtime file variables */
        file_init();

        if (! file_createPidFile(Run.files.pid)) {
                LogError("%s stopped -- cannot create a pid file\n", prog);
                exit(1);
        }

        /* Update service data from the state repository */
        if (! State_open())
                exit(1);
        State_restore();

        /* Start http interface */
        if (can_http())
                monit_http(Httpd_Start);

        /* send the monit startup notification */
        Event_post(Run.system, Event_Instance, State_Changed, Run.system->action_MONIT_START, "Monit reloaded");

        if (Run.mmonits) {
                Thread_create(heartbeatThread, heartbeat, NULL);
                heartbeatRunning = true;
        }
}


/**
 * Dispatch to the submitted action - actions are program arguments
 */
static void do_action(int argc, char **args) {
        char *action = args[optind];

        Run.flags |= Run_Once;

        if (! action) {
                do_default();
        } else if (IS(action, "start")     ||
                   IS(action, "stop")      ||
                   IS(action, "monitor")   ||
                   IS(action, "unmonitor") ||
                   IS(action, "restart")) {
                char *service = args[++optind];
                if (Run.mygroup || service) {
                        int errors = 0;
                        List_T services = List_new();
                        if (Run.mygroup) {
                                for (ServiceGroup_T sg = servicegrouplist; sg; sg = sg->next) {
                                        if (IS(Run.mygroup, sg->name)) {
                                                for (list_t m = sg->members->head; m; m = m->next) {
                                                        Service_T s = m->e;
                                                        List_append(services, s->name);
                                                }
                                                break;
                                        }
                                }
                                if (List_length(services) == 0) {
                                        List_free(&services);
                                        LogError("Group '%s' not found\n", Run.mygroup);
                                        exit(1);
                                }
                        } else if (IS(service, "all")) {
                                for (Service_T s = servicelist; s; s = s->next)
                                        List_append(services, s->name);
                        } else {
                                List_append(services, service);
                        }
                        errors = exist_daemon() ? (HttpClient_action(action, services) ? 0 : 1) : control_service_string(services, action);
                        List_free(&services);
                        if (errors)
                                exit(1);
                } else {
                        LogError("Please specify a service name or 'all' after %s\n", action);
                        exit(1);
                }
        } else if (IS(action, "reload")) {
                LogInfo("Reinitializing %s daemon\n", prog);
                kill_daemon(SIGHUP);
        } else if (IS(action, "status")) {
                char *service = args[++optind];
                if (! HttpClient_status(Run.mygroup, service))
                        exit(1);
        } else if (IS(action, "summary")) {
                char *service = args[++optind];
                if (! HttpClient_summary(Run.mygroup, service))
                        exit(1);
        } else if (IS(action, "report")) {
                char *type = args[++optind];
                if (! HttpClient_report(type))
                        exit(1);
        } else if (IS(action, "procmatch")) {
                char *pattern = args[++optind];
                if (! pattern) {
                        printf("Invalid syntax - usage: procmatch \"<pattern>\"\n");
                        exit(1);
                }
                ProcessTree_testMatch(pattern);
        } else if (IS(action, "quit")) {
                kill_daemon(SIGTERM);
        } else if (IS(action, "validate")) {
                if (do_wakeupcall()) {
                        char *service = args[++optind];
                        HttpClient_status(Run.mygroup, service);
                } else {
                        _validateOnce();
                }
                exit(1);
        } else {
                LogError("Invalid argument -- %s  (-h will show valid arguments)\n", action);
                exit(1);
        }
}


/**
 * Finalize monit
 */
static void do_exit(boolean_t saveState) {
        set_signal_block();
        Run.flags |= Run_Stopped;
        if ((Run.flags & Run_Daemon) && ! (Run.flags & Run_Once)) {
                if (can_http())
                        monit_http(Httpd_Stop);

                if (Run.mmonits && heartbeatRunning) {
                        Sem_signal(heartbeatCond);
                        Thread_join(heartbeatThread);
                        heartbeatRunning = false;
                }

                LogInfo("Monit daemon with pid [%d] stopped\n", (int)getpid());

                /* send the monit stop notification */
                Event_post(Run.system, Event_Instance, State_Changed, Run.system->action_MONIT_STOP, "Monit %s stopped", VERSION);
        }
        if (saveState) {
                State_save();
        }
        gc();
#ifdef HAVE_OPENSSL
        Ssl_stop();
#endif
        exit(0);
}


/**
 * Default action - become a daemon if defined in the Run object and
 * run validate() between sleeps. If not, just run validate() once.
 * Also, if specified, start the monit http server if in deamon mode.
 */
static void do_default() {
        if (Run.flags & Run_Daemon) {
                if (do_wakeupcall())
                        exit(0);

                Run.flags &= ~Run_Once;
                if (can_http()) {
                        if (Run.httpd.flags & Httpd_Net)
                                LogInfo("Starting Monit %s daemon with http interface at [%s]:%d\n", VERSION, Run.httpd.socket.net.address ? Run.httpd.socket.net.address : "*", Run.httpd.socket.net.port);
                        else if (Run.httpd.flags & Httpd_Unix)
                                LogInfo("Starting Monit %s daemon with http interface at %s\n", VERSION, Run.httpd.socket.unix.path);
                } else {
                        LogInfo("Starting Monit %s daemon\n", VERSION);
                }

                if (Run.startdelay)
                        LogInfo("Monit start delay set to %ds\n", Run.startdelay);

                if (! (Run.flags & Run_Foreground))
                        daemonize();

                if (! file_createPidFile(Run.files.pid)) {
                        LogError("Monit daemon died\n");
                        exit(1);
                }

                if (! State_open())
                        exit(1);
                State_restore();

                atexit(file_finalize);

                if (Run.startdelay) {
                        time_t now = Time_now();
                        time_t delay = now + Run.startdelay;

                        /* sleep can be interrupted by signal => make sure we paused long enough */
                        while (now < delay) {
                                sleep((unsigned int)(delay - now));
                                if (Run.flags & Run_Stopped)
                                        do_exit(false);
                                now = Time_now();
                        }
                }

                if (can_http())
                        monit_http(Httpd_Start);

                /* send the monit startup notification */
                Event_post(Run.system, Event_Instance, State_Changed, Run.system->action_MONIT_START, "Monit %s started", VERSION);

                if (Run.mmonits) {
                        Thread_create(heartbeatThread, heartbeat, NULL);
                        heartbeatRunning = true;
                }

                while (true) {
                        validate();

                        /* In the case that there is no pending action then sleep */
                        if (! (Run.flags & Run_ActionPending) && ! interrupt())
                                sleep(Run.polltime);

                        if (Run.flags & Run_DoWakeup) {
                                Run.flags &= ~Run_DoWakeup;
                                LogInfo("Awakened by User defined signal 1\n");
                        }

                        if (Run.flags & Run_Stopped) {
                                do_exit(true);
                        } else if (Run.flags & Run_DoReload) {
                                do_reinit();
                        } else {
                                State_saveIfDirty();
                        }
                }
        } else {
                _validateOnce();
        }
}


/**
 * Handle program options - Options set from the commandline
 * takes precedence over those found in the control file
 */
static void handle_options(int argc, char **argv) {
        int opt;
        int deferred_opt = 0;
        opterr = 0;
        Run.mygroup = NULL;
        const char *shortopts = "c:d:g:l:p:s:HIirtvVhB";
#ifdef HAVE_GETOPT_LONG
        struct option longopts[] = {
                {"conf",        required_argument,      NULL,   'c'},
                {"daemon",      required_argument,      NULL,   'd'},
                {"group",       required_argument,      NULL,   'g'},
                {"logfile",     required_argument,      NULL,   'l'},
                {"pidfile",     required_argument,      NULL,   'p'},
                {"statefile",   required_argument,      NULL,   's'},
                {"hash",        optional_argument,      NULL,   'H'},
                {"id",          no_argument,            NULL,   'i'},
                {"help",        no_argument,            NULL,   'h'},
                {"resetid",     no_argument,            NULL,   'r'},
                {"test",        no_argument,            NULL,   't'},
                {"verbose",     no_argument,            NULL,   'v'},
                {"batch",       no_argument,            NULL,   'B'},
                {"interactive", no_argument,            NULL,   'I'},
                {"version",     no_argument,            NULL,   'V'},
                {0}
        };
        while ((opt = getopt_long(argc, argv, shortopts, longopts, NULL)) != -1)
#else
                while ((opt = getopt(argc, argv, shortopts)) != -1)
#endif
                {
                        switch (opt) {
                                case 'c':
                                {
                                        char *f = optarg;
                                        if (f[0] != SEPARATOR_CHAR)
                                                f = File_getRealPath(optarg, (char[PATH_MAX]){});
                                        if (! f)
                                                THROW(AssertException, "The control file '%s' does not exist at %s",
                                                      Str_trunc(optarg, 80), Dir_cwd((char[STRLEN]){}, STRLEN));
                                        if (! File_isFile(f))
                                                THROW(AssertException, "The control file '%s' is not a file", Str_trunc(f, 80));
                                        if (! File_isReadable(f))
                                                THROW(AssertException, "The control file '%s' is not readable", Str_trunc(f, 80));
                                        Run.files.control = Str_dup(f);
                                        break;
                                }
                                case 'd':
                                {
                                        Run.flags |= Run_Daemon;
                                        if (sscanf(optarg, "%d", &Run.polltime) != 1 || Run.polltime < 1) {
                                                LogError("Option -%c requires a natural number\n", opt);
                                                exit(1);
                                        }
                                        break;
                                }
                                case 'g':
                                {
                                        Run.mygroup = Str_dup(optarg);
                                        break;
                                }
                                case 'l':
                                {
                                        Run.files.log = Str_dup(optarg);
                                        if (IS(Run.files.log, "syslog"))
                                                Run.flags |= Run_UseSyslog;
                                        Run.flags |= Run_Log;
                                        break;
                                }
                                case 'p':
                                {
                                        Run.files.pid = Str_dup(optarg);
                                        break;
                                }
                                case 's':
                                {
                                        Run.files.state = Str_dup(optarg);
                                        break;
                                }
                                case 'I':
                                {
                                        Run.flags |= Run_Foreground;
                                        break;
                                }
                                case 'i':
                                {
                                        deferred_opt = 'i';
                                        break;
                                }
                                case 'r':
                                {
                                        deferred_opt = 'r';
                                        break;
                                }
                                case 't':
                                {
                                        deferred_opt = 't';
                                        break;
                                }
                                case 'v':
                                {
                                        Run.debug++;
                                        break;
                                }
                                case 'H':
                                {
                                        if (argc > optind)
                                                Util_printHash(argv[optind]);
                                        else
                                                Util_printHash(NULL);
                                        exit(0);
                                        break;
                                }
                                case 'V':
                                {
                                        version();
                                        exit(0);
                                        break;
                                }
                                case 'h':
                                {
                                        help();
                                        exit(0);
                                        break;
                                }
                                case 'B':
                                {
                                        Run.flags |= Run_Batch;
                                        break;
                                }
                                case '?':
                                {
                                        switch (optopt) {
                                                case 'c':
                                                case 'd':
                                                case 'g':
                                                case 'l':
                                                case 'p':
                                                case 's':
                                                {
                                                        LogError("Option -- %c requires an argument\n", optopt);
                                                        break;
                                                }
                                                default:
                                                {
                                                        LogError("Invalid option -- %c  (-h will show valid options)\n", optopt);
                                                }
                                        }
                                        exit(1);
                                }
                        }
                }
        /* Handle deferred options to make arguments to the program positional
         independent. These options are handled last, here as they represent exit
         points in the application and the control-file might be set with -c and
         these options need to respect the new control-file location as they call
         do_init */
        switch (deferred_opt) {
                case 't':
                {
                        do_init(); // Parses control file and initialize program, exit on error
                        printf("Control file syntax OK\n");
                        exit(0);
                        break;
                }
                case 'r':
                {
                        do_init();
                        assert(Run.id);
                        printf("Reset Monit Id? [y/N]> ");
                        if (tolower(getchar()) == 'y') {
                                File_delete(Run.files.id);
                                Util_monitId(Run.files.id);
                                kill_daemon(SIGHUP); // make any running Monit Daemon reload the new ID-File
                        }
                        exit(0);
                        break;
                }
                case 'i':
                {
                        do_init();
                        assert(Run.id);
                        printf("Monit ID: %s\n", Run.id);
                        exit(0);
                        break;
                }
        }
}


/**
 * Print the program's help message
 */
static void help() {
        printf(
               "Usage: %s [options]+ [command]\n"
               "Options are as follows:\n"
               " -c file       Use this control file\n"
               " -d n          Run as a daemon once per n seconds\n"
               " -g name       Set group name for monit commands\n"
               " -l logfile    Print log information to this file\n"
               " -p pidfile    Use this lock file in daemon mode\n"
               " -s statefile  Set the file monit should write state information to\n"
               " -I            Do not run in background (needed when run from init)\n"
               " --id          Print Monit's unique ID\n"
               " --resetid     Reset Monit's unique ID. Use with caution\n"
               " -B            Batch command line mode (do not output tables or colors)\n"
               " -t            Run syntax check for the control file\n"
               " -v            Verbose mode, work noisy (diagnostic output)\n"
               " -vv           Very verbose mode, same as -v plus log stacktrace on error\n"
               " -H [filename] Print SHA1 and MD5 hashes of the file or of stdin if the\n"
               "               filename is omited; monit will exit afterwards\n"
               " -V            Print version number and patchlevel\n"
               " -h            Print this text\n"
               "Optional commands are as follows:\n"
               " start all             - Start all services\n"
               " start <name>          - Only start the named service\n"
               " stop all              - Stop all services\n"
               " stop <name>           - Stop the named service\n"
               " restart all           - Stop and start all services\n"
               " restart <name>        - Only restart the named service\n"
               " monitor all           - Enable monitoring of all services\n"
               " monitor <name>        - Only enable monitoring of the named service\n"
               " unmonitor all         - Disable monitoring of all services\n"
               " unmonitor <name>      - Only disable monitoring of the named service\n"
               " reload                - Reinitialize monit\n"
               " status [name]         - Print full status information for service(s)\n"
               " summary [name]        - Print short status information for service(s)\n"
               " report [up|down|..]   - Report state of services. See manual for options\n"
               " quit                  - Kill the monit daemon process\n"
               " validate              - Check all services and start if not running\n"
               " procmatch <pattern>   - Test process matching pattern\n",
               prog);
}

/**
 * Print version information
 */
static void version() {
        printf("This is Monit version %s\n", VERSION);
        printf("Built with");
#ifndef HAVE_OPENSSL
        printf("out");
#endif
        printf(" ssl, with");
#ifndef HAVE_IPV6
        printf("out");
#endif
        printf(" ipv6, with");
#ifndef HAVE_LIBZ
        printf("out");
#endif
        printf(" compression, with");
#ifndef HAVE_LIBPAM
        printf("out");
#endif
        printf(" pam and with");
#ifndef HAVE_LARGEFILES
        printf("out");
#endif
        printf(" large files\n");
        printf("Copyright (C) 2001-2018 Tildeslash Ltd. All Rights Reserved.\n");
}


/**
 * M/Monit heartbeat thread
 */
static void *heartbeat(void *args) {
        set_signal_block();
        LogInfo("M/Monit heartbeat started\n");
        LOCK(heartbeatMutex)
        {
                while (! interrupt()) {
                        MMonit_send(NULL);
                        struct timespec wait = {.tv_sec = Time_now() + Run.polltime, .tv_nsec = 0};
                        Sem_timeWait(heartbeatCond, heartbeatMutex, wait);
                }
        }
        END_LOCK;
#ifdef HAVE_OPENSSL
        Ssl_threadCleanup();
#endif
        LogInfo("M/Monit heartbeat stopped\n");
        return NULL;
}


/**
 * Signalhandler for a daemon reload call
 */
static RETSIGTYPE do_reload(int sig) {
        Run.flags |= Run_DoReload;
}


/**
 * Signalhandler for monit finalization
 */
static RETSIGTYPE do_destroy(int sig) {
        Run.flags |= Run_Stopped;
}


/**
 * Signalhandler for a daemon wakeup call
 */
static RETSIGTYPE do_wakeup(int sig) {
        Run.flags |= Run_DoWakeup;
}


/* A simple non-blocking reaper to ensure that we wait-for and reap all/any stray child processes
 we may have created and not waited on, so we do not create any zombie processes at exit */
static void waitforchildren(void) {
        while (waitpid(-1, NULL, WNOHANG) > 0) ;
}
