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


#ifndef MONIT_H
#define MONIT_H

#include "config.h"
#include <assert.h>

#ifdef HAVE_KINFO_H
#include <kinfo.h>
#endif

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#ifdef HAVE_SYS_STAT_H
#include <sys/stat.h>
#endif

#ifdef HAVE_SIGNAL_H
#include <signal.h>
#endif

#ifdef HAVE_PTHREAD_H
#include <pthread.h>
#endif

#ifdef HAVE_STDARG_H
#include <stdarg.h>
#endif

#ifdef HAVE_STDIO_H
#include <stdio.h>
#endif

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_REGEX_H
#include <regex.h>
#endif

#ifdef HAVE_SYSLOG_H
#include <syslog.h>
#endif

#ifdef HAVE_LIMITS_H
#include <limits.h>
#endif

#ifdef HAVE_SYS_UTSNAME_H
#include <sys/utsname.h>
#endif

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif

#ifdef HAVE_NETDB_H
#include <netdb.h>
#endif

#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif

#ifdef HAVE_MACH_BOOLEAN_H
#include <mach/boolean.h>
#endif
#ifdef HAVE_UVM_UVM_PARAM_H
#include <uvm/uvm_param.h>
#endif
#ifdef HAVE_VM_VM_H
#include <vm/vm.h>
#endif
#ifdef HAVE_INTTYPES_H
#include <inttypes.h>
#else
#define PRIu64 "llu"
#endif


//FIXME: we can export this type in libmonit
#ifndef HAVE_BOOLEAN_T
#undef true
#undef false
typedef enum {
        false = 0,
        true
} __attribute__((__packed__)) boolean_t;
#else
#define false 0
#define true  1
#endif


#include "Ssl.h"
#include "Address.h"


// libmonit
#include "system/Command.h"
#include "system/Process.h"
#include "util/Str.h"
#include "util/StringBuffer.h"
#include "system/Link.h"
#include "statistics/Statistics.h"
#include "thread/Thread.h"


#define MONITRC            "monitrc"
#define TIMEFORMAT         "%Z %b %e %T"
#define STRERROR            strerror(errno)
#define STRLEN             256
#ifndef USEC_PER_SEC
#define USEC_PER_SEC       1000000L
#endif
#define USEC_PER_MSEC      1000L

#define ARGMAX             64
#define MYPIDDIR           PIDDIR
#define MYPIDFILE          "monit.pid"
#define MYSTATEFILE        "monit.state"
#define MYIDFILE           "monit.id"
#define MYEVENTLISTBASE    "/var/monit"

#define LOCALHOST          "localhost"

#define PORT_SMTP          25
#define PORT_SMTPS         465
#define PORT_HTTP          80
#define PORT_HTTPS         443

#define SSL_TIMEOUT        15000
#define SMTP_TIMEOUT       30000

#define START_DELAY        0


//FIXME: refactor Run_Flags to bit field
typedef enum {
        Run_Once                 = 0x1,                   /**< Run Monit only once */
        Run_Foreground           = 0x2,                 /**< Don't daemonize Monit */ //FIXME: cleanup: Run_Foreground and Run_Daemon are mutually exclusive => no need for 2 flags
        Run_Daemon               = 0x4,                       /**< Daemonize Monit */ //FIXME: cleanup: Run_Foreground and Run_Daemon are mutually exclusive => no need for 2 flags
        Run_Log                  = 0x8,                           /**< Log enabled */
        Run_UseSyslog            = 0x10,                           /**< Use syslog */ //FIXME: cleanup: no need for standalone flag ... if syslog is enabled, don't set Run.files.log, then (Run.flags&Run_Log && ! Run.files.log => syslog)
        Run_FipsEnabled          = 0x20,                 /** FIPS-140 mode enabled */
        Run_HandlerInit          = 0x40,    /**< The handlers queue initialization */
        Run_ProcessEngineEnabled = 0x80,    /**< Process monitoring engine enabled */
        Run_ActionPending        = 0x100,              /**< Service action pending */
        Run_MmonitCredentials    = 0x200,      /**< Should set M/Monit credentials */
        Run_Stopped              = 0x400,                          /**< Stop Monit */
        Run_DoReload             = 0x800,                        /**< Reload Monit */
        Run_DoWakeup             = 0x1000,                       /**< Wakeup Monit */
        Run_Batch                = 0x2000                      /**< CLI batch mode */
} __attribute__((__packed__)) Run_Flags;


typedef enum {
        ProcessEngine_None               = 0x0,
        ProcessEngine_CollectCommandLine = 0x1
} __attribute__((__packed__)) ProcessEngine_Flags;


typedef enum {
        Httpd_Start = 1,
        Httpd_Stop
} __attribute__((__packed__)) Httpd_Action;


typedef enum {
        Every_Cycle = 0,
        Every_SkipCycles,
        Every_Cron,
        Every_NotInCron
} __attribute__((__packed__)) Every_Type;


typedef enum {
        State_Succeeded  = 0x0,
        State_Failed     = 0x1,
        State_Changed    = 0x2,
        State_ChangedNot = 0x4,
        State_Init       = 0x8,
        State_None       = State_Init // Alias
} __attribute__((__packed__)) State_Type;


typedef enum {
        Operator_Less = 0,
        Operator_LessOrEqual,
        Operator_Greater,
        Operator_GreaterOrEqual,
        Operator_Equal,
        Operator_NotEqual,
        Operator_Changed
} __attribute__((__packed__)) Operator_Type;


typedef enum {
        Timestamp_Default = 0,
        Timestamp_Access,
        Timestamp_Change,
        Timestamp_Modification
} __attribute__((__packed__)) Timestamp_Type;


typedef enum {
        Httpd_Disabled                    = 0x0,
        Httpd_Net                         = 0x1,  // IP
        Httpd_Unix                        = 0x2,  // Unix socket
        Httpd_UnixUid                     = 0x4,  // Unix socket: override UID
        Httpd_UnixGid                     = 0x8,  // Unix socket: override GID
        Httpd_UnixPermission              = 0x10, // Unix socket: override permissions
        Httpd_Signature                   = 0x20  // Server Signature enabled
} __attribute__((__packed__)) Httpd_Flags;


typedef enum {
        Http_Head = 1,
        Http_Get
} __attribute__((__packed__)) Http_Method;


typedef enum {
        Time_Second = 1,
        Time_Minute = 60,
        Time_Hour   = 3600,
        Time_Day    = 86400,
        Time_Month  = 2678400
} __attribute__((__packed__)) Time_Type;


typedef enum {
        Action_Ignored = 0,
        Action_Alert,
        Action_Restart,
        Action_Stop,
        Action_Exec,
        Action_Unmonitor,
        Action_Start,
        Action_Monitor
} __attribute__((__packed__)) Action_Type;


typedef enum {
        Monitor_Active = 0,
        Monitor_Passive
} __attribute__((__packed__)) Monitor_Mode;


typedef enum {
        Onreboot_Start = 0,
        Onreboot_Nostart,
        Onreboot_Laststate
} __attribute__((__packed__)) Onreboot_Type;


typedef enum {
        Monitor_Not     = 0x0,
        Monitor_Yes     = 0x1,
        Monitor_Init    = 0x2,
        Monitor_Waiting = 0x4
} __attribute__((__packed__)) Monitor_State;


typedef enum {
        Connection_Failed = 0,
        Connection_Ok,
        Connection_Init
} __attribute__((__packed__)) Connection_State;


typedef enum {
        Service_Filesystem = 0,
        Service_Directory,
        Service_File,
        Service_Process,
        Service_Host,
        Service_System,
        Service_Fifo,
        Service_Program,
        Service_Net,
        Service_Last = Service_Net
} __attribute__((__packed__)) Service_Type;


typedef enum {
        Resource_CpuPercent = 1,
        Resource_MemoryPercent,
        Resource_MemoryKbyte,
        Resource_LoadAverage1m,
        Resource_LoadAverage5m,
        Resource_LoadAverage15m,
        Resource_Children,
        Resource_MemoryKbyteTotal,
        Resource_MemoryPercentTotal,
        Resource_Inode,
        Resource_InodeFree,
        Resource_Space,
        Resource_SpaceFree,
        Resource_CpuUser,
        Resource_CpuSystem,
        Resource_CpuWait,
        Resource_CpuPercentTotal,
        Resource_SwapPercent,
        Resource_SwapKbyte,
        Resource_Threads,
        Resource_ReadBytes,
        Resource_ReadOperations,
        Resource_WriteBytes,
        Resource_WriteOperations,
        Resource_ServiceTime
} __attribute__((__packed__)) Resource_Type;



typedef enum {
        Digest_Cleartext = 1,
        Digest_Crypt,
        Digest_Md5,
        Digest_Pam
} __attribute__((__packed__)) Digest_Type;


typedef enum {
        Unit_Byte     = 1,
        Unit_Kilobyte = 1024,
        Unit_Megabyte = 1048576,
        Unit_Gigabyte = 1073741824
} __attribute__((__packed__)) Unit_Type;


typedef enum {
        Hash_Unknown = 0,
        Hash_Md5,
        Hash_Sha1,
        Hash_Default = Hash_Md5
} __attribute__((__packed__)) Hash_Type;


typedef enum {
        Handler_Succeeded = 0x0,
        Handler_Alert     = 0x1,
        Handler_Mmonit    = 0x2,
        Handler_Max       = Handler_Mmonit
} __attribute__((__packed__)) Handler_Type;


typedef enum {
        MmonitCompress_Init = 0,
        MmonitCompress_No,
        MmonitCompress_Yes
} __attribute__((__packed__)) MmonitCompress_Type;


/* Length of the longest message digest in bytes */
#define MD_SIZE 65


#define ICMP_SIZE 64
#define ICMP_MAXSIZE 1500
#define ICMP_ATTEMPT_COUNT 3


/* Default limits */
#define LIMIT_SENDEXPECTBUFFER  256
#define LIMIT_FILECONTENTBUFFER 512
#define LIMIT_PROGRAMOUTPUT     512
#define LIMIT_HTTPCONTENTBUFFER 1048576
#define LIMIT_NETWORKTIMEOUT    5000
#define LIMIT_PROGRAMTIMEOUT    300000
#define LIMIT_STOPTIMEOUT       30000
#define LIMIT_STARTTIMEOUT      30000
#define LIMIT_RESTARTTIMEOUT    30000


#include "socket.h"


/** ------------------------------------------------- Special purpose macros */


/* Replace the standard signal function with a more reliable using
 * sigaction. Taken from Stevens APUE book. */
typedef void Sigfunc(int);
Sigfunc *signal(int signo, Sigfunc * func);
#if defined(SIG_IGN) && !defined(SIG_ERR)
#define SIG_ERR ((Sigfunc *)-1)
#endif


/** ------------------------------------------------- General purpose macros */


#undef MAX
#define MAX(x,y) ((x) > (y) ? (x) : (y))
#undef MIN
#define MIN(x,y) ((x) < (y) ? (x) : (y))
#define IS(a,b)  ((a && b) ? Str_isEqual(a, b) : false)
#define DEBUG LogDebug
#define FLAG(x, y) (x & y) == y
#define NVLSTR(x) (x ? x : "")


/** ------------------------------------------ Simple Assert Exception macro */


#define ASSERT(e) do { if (!(e)) { LogCritical("AssertException: " #e \
" at %s:%d\naborting..\n", __FILE__, __LINE__); abort(); } } while (0)


/* --------------------------------------------------------- Data structures */


/** Message Digest type with size for the longest digest we will compute */
typedef char MD_T[MD_SIZE];


/** Defines monit limits object */
typedef struct Limits_T {
        uint32_t sendExpectBuffer;  /**< Maximum send/expect response length [B] */
        uint32_t fileContentBuffer;  /**< Maximum tested file content length [B] */
        uint32_t httpContentBuffer;  /**< Maximum tested HTTP content length [B] */
        uint32_t programOutput;           /**< Program output truncate limit [B] */
        uint32_t networkTimeout;               /**< Default network timeout [ms] */
        uint32_t programTimeout;               /**< Default program timeout [ms] */
        uint32_t stopTimeout;                     /**< Default stop timeout [ms] */
        uint32_t startTimeout;                   /**< Default start timeout [ms] */
        uint32_t restartTimeout;               /**< Default restart timeout [ms] */
} Limits_T;


/**
 * Defines a Command with ARGMAX optional arguments. The arguments
 * array must be NULL terminated and the first entry is the program
 * itself. In addition, a user and group may be set for the Command
 * which means that the Command should run as a certain user and with
 * certain group. To avoid name collision with Command_T in libmonit 
 * this structure uses lower case.
 */
typedef struct command_t {
        char *arg[ARGMAX];                             /**< Program with arguments */
        short length;                       /**< The length of the arguments array */
        boolean_t has_uid;      /**< true if a new uid is defined for this Command */
        boolean_t has_gid;      /**< true if a new gid is defined for this Command */
        uid_t uid;         /**< The user id to switch to when running this Command */
        gid_t gid;        /**< The group id to switch to when running this Command */
        unsigned timeout;     /**< Max seconds which we wait for method to execute */
} *command_t;


/** Defines an event action object */
typedef struct Action_T {
        Action_Type id;                                   /**< Action to be done */
        uint8_t count;             /**< Event count needed to trigger the action */
        uint8_t cycles;      /**< Cycles during which count limit can be reached */
        uint8_t repeat;                         /*< Repeat action each Xth cycle */
        command_t exec;                     /**< Optional command to be executed */
} *Action_T;


/** Defines event's up and down actions */
typedef struct EventAction_T {
        Action_T  failed;                  /**< Action in the case of failure down */
        Action_T  succeeded;                    /**< Action in the case of failure up */
} *EventAction_T;


/** Defines an url object */
typedef struct URL_T {
        char *url;                                                  /**< Full URL */
        char *protocol;                                    /**< URL protocol type */
        char *user;                                        /**< URL user     part */
        char *password;                                    /**< URL password part */
        char *hostname;                                    /**< URL hostname part */
        char *path;                                        /**< URL path     part */
        char *query;                                       /**< URL query    part */
        int   port;                                        /**< URL port     part */
        boolean_t ipv6;
} *URL_T;


/** Defines a HTTP client request object */
typedef struct Request_T {
        URL_T url;                                               /**< URL request */
        Operator_Type operator;         /**< Response content comparison operator */
        regex_t *regex;                   /* regex used to test the response body */
} *Request_T;


/** Defines an event notification and status receiver object */
typedef struct Mmonit_T {
        URL_T url;                                             /**< URL definition */
        struct SslOptions_T ssl;                               /**< SSL definition */
        int timeout;                /**< The timeout to wait for connection or i/o */
        MmonitCompress_Type compress;                        /**< Compression flag */

        /** For internal use */
        struct Mmonit_T *next;                         /**< next receiver in chain */
} *Mmonit_T;


/** Defines a mailinglist object */
typedef struct Mail_T {
        char *to;                         /**< Mail address for alert notification */
        Address_T from;                                 /**< The mail from address */
        Address_T replyto;                          /**< Optional reply-to address */
        char *subject;                                       /**< The mail subject */
        char *message;                                       /**< The mail message */
        char *host;                                             /**< FQDN hostname */
        unsigned int events;  /*< Events for which this mail object should be sent */
        unsigned int reminder;              /*< Send error reminder each Xth cycle */

        /** For internal use */
        struct Mail_T *next;                          /**< next recipient in chain */
} *Mail_T;


/** Defines a mail server address */
typedef struct MailServer_T {
        char *host;     /**< Server host address, may be a IP or a hostname string */
        int   port;                                               /**< Server port */
        char *username;                               /** < Username for SMTP_AUTH */
        char *password;                               /** < Password for SMTP_AUTH */
        struct SslOptions_T ssl;                               /**< SSL definition */
        Socket_T socket;                                     /**< Connected socket */

        /** For internal use */
        struct MailServer_T *next;        /**< Next server to try on connect error */
} *MailServer_T;


typedef struct Auth_T {
        char *uname;                  /**< User allowed to connect to monit httpd */
        char *passwd;                                /**< The users password data */
        char *groupname;                                      /**< PAM group name */
        Digest_Type digesttype;                /**< How did we store the password */
        boolean_t is_readonly; /**< true if this is a read-only authenticated user*/
        struct Auth_T *next;                 /**< Next credential or NULL if last */
} *Auth_T;


/** Defines data for systemwide statistic */
typedef struct SystemInfo_T {
        struct {
                int count;                                      /**< Number of CPUs */
                struct {
                        float user;         /**< Total CPU in use in user space [%] */
                        float system;     /**< Total CPU in use in kernel space [%] */
                        float wait;            /**< Total CPU in use in waiting [%] */
                } usage;
        } cpu;
        struct {
                uint64_t size;                      /**< Maximal system real memory */
                struct {
                        float percent;  /**< Total real memory in use in the system */
                        uint64_t bytes; /**< Total real memory in use in the system */
                } usage;
        } memory;
        struct {
                uint64_t size;                                       /**< Swap size */
                struct {
                        float percent;         /**< Total swap in use in the system */
                        uint64_t bytes;        /**< Total swap in use in the system */
                } usage;
        } swap;
        size_t argmax;                                                   /**< Program arguments maximum [B] */
        double loadavg[3];                                                         /**< Load average triple */
        struct utsname uname;                                 /**< Platform information provided by uname() */
        struct timeval collected;                                             /**< When were data collected */
        uint64_t booted; /**< System boot time (seconds since UNIX epoch, using platform-agnostic uint64_t) */
        double time;                                                                      /**< 1/10 seconds */
        double time_prev;                                                                 /**< 1/10 seconds */
} SystemInfo_T;


/** Defines a protocol object with protocol functions */
typedef struct Protocol_T {
        const char *name;                                       /**< Protocol name */
        void (*check)(Socket_T);          /**< Protocol verification function */
} *Protocol_T;


/** Defines a send/expect object used for generic protocol tests */
typedef struct Generic_T {
        char *send;                           /* string to send, or NULL if expect */
        regex_t *expect;                  /* regex code to expect, or NULL if send */
        /** For internal use */
        struct Generic_T *next;
} *Generic_T;


typedef struct Outgoing_T {
        char *ip;                                         /**< Outgoing IP address */
        struct sockaddr_storage addr;
        socklen_t addrlen;
} Outgoing_T;


/** Defines a port object */
typedef struct Port_T {
        char *hostname;                                     /**< Hostname to check */
        union {
                struct {
                        char *pathname;                  /**< Unix socket pathname */
                } unix;
                struct {
                        int port;                                 /**< Port number */
                        struct {
                                struct SslOptions_T options;
                                struct {
                                        int validDays;
                                        int minimumDays;
                                } certificate;
                        } ssl;
                } net;
        } target;
        Outgoing_T outgoing;                                 /**< Outgoing address */
        int timeout;      /**< The timeout in [ms] to wait for connect or read i/o */
        int retry;       /**< Number of connection retry before reporting an error */
        volatile int socket;                       /**< Socket used for connection */
        double response;                 /**< Socket connection response time [ms] */
        Socket_Type type;           /**< Socket type used for connection (UDP/TCP) */
        Socket_Family family;    /**< Socket family used for connection (NET/UNIX) */
        Connection_State is_available;               /**< Server/port availability */
        EventAction_T action;  /**< Description of the action upon event occurence */
        /** Protocol specific parameters */
        union {
                struct {
                        char *username;
                        char *password;
                        char *path;                                              /**< status path */
                        short loglimit;                  /**< Max percentage of logging processes */
                        short closelimit;             /**< Max percentage of closinging processes */
                        short dnslimit;         /**< Max percentage of processes doing DNS lookup */
                        short keepalivelimit;          /**< Max percentage of keepalive processes */
                        short replylimit;               /**< Max percentage of replying processes */
                        short requestlimit;     /**< Max percentage of processes reading requests */
                        short startlimit;            /**< Max percentage of processes starting up */
                        short waitlimit;  /**< Min percentage of processes waiting for connection */
                        short gracefullimit;/**< Max percentage of processes gracefully finishing */
                        short cleanuplimit;      /**< Max percentage of processes in idle cleanup */
                        Operator_Type loglimitOP;                          /**< loglimit operator */
                        Operator_Type closelimitOP;                      /**< closelimit operator */
                        Operator_Type dnslimitOP;                          /**< dnslimit operator */
                        Operator_Type keepalivelimitOP;              /**< keepalivelimit operator */
                        Operator_Type replylimitOP;                      /**< replylimit operator */
                        Operator_Type requestlimitOP;                  /**< requestlimit operator */
                        Operator_Type startlimitOP;                      /**< startlimit operator */
                        Operator_Type waitlimitOP;                        /**< waitlimit operator */
                        Operator_Type gracefullimitOP;                /**< gracefullimit operator */
                        Operator_Type cleanuplimitOP;                  /**< cleanuplimit operator */
                } apachestatus;
                struct {
                        Generic_T sendexpect;
                } generic;
                struct {
                        Hash_Type hashtype;           /**< Type of hash for a checksum (optional) */
                        boolean_t hasStatus;                    /**< Is explicit HTTP status set? */
                        Operator_Type operator;                         /**< HTTP status operator */
                        Http_Method method;
                        int status;                                              /**< HTTP status */
                        char *username;
                        char *password;
                        char *request;                                          /**< HTTP request */
                        char *checksum;                         /**< Document checksum (optional) */
                        List_T headers;      /**< List of headers to send with request (optional) */
                } http;
                struct {
                        char *username;
                        char *password;
                } mysql;
                struct {
                        char *secret;
                } radius;
                struct {
                        int maxforward;
                        char *target;
                } sip;
                struct {
                        char *username;
                        char *password;
                } smtp;
                struct {
                        int version;
                        char *host;
                        char *origin;
                        char *request;
                } websocket;
        } parameters;
        Protocol_T protocol;     /**< Protocol object for testing a port's service */
        Request_T url_request;             /**< Optional url client request object */

        /** For internal use */
        struct Port_T *next;                               /**< next port in chain */
} *Port_T;


/** Defines a ICMP/Ping object */
typedef struct Icmp_T {
        int type;                                              /**< ICMP type used */
        int size;                                     /**< ICMP echo requests size */
        int count;                                   /**< ICMP echo requests count */
        int timeout;         /**< The timeout in milliseconds to wait for response */
        Connection_State is_available;    /**< Flag for the server is availability */
        Socket_Family family;                 /**< ICMP family used for connection */
        double response;                         /**< ICMP ECHO response time [ms] */
        Outgoing_T outgoing;                                 /**< Outgoing address */
        EventAction_T action;  /**< Description of the action upon event occurence */

        /** For internal use */
        struct Icmp_T *next;                               /**< next icmp in chain */
} *Icmp_T;


typedef struct Dependant_T {
        char *dependant;                            /**< name of dependant service */

        /** For internal use */
        struct Dependant_T *next;             /**< next dependant service in chain */
} *Dependant_T;


/** Defines resource data */
typedef struct Resource_T {
        Resource_Type resource_id;                     /**< Which value is checked */
        Operator_Type operator;                           /**< Comparison operator */
        double limit;                                   /**< Limit of the resource */
        EventAction_T action;  /**< Description of the action upon event occurence */

        /** For internal use */
        struct Resource_T *next;                       /**< next resource in chain */
} *Resource_T;


/** Defines timestamp object */
typedef struct Timestamp_T {
        boolean_t initialized;              /**< true if timestamp was initialized */
        boolean_t test_changes;       /**< true if we only should test for changes */
        Timestamp_Type type;
        Operator_Type operator;                           /**< Comparison operator */
        uint64_t time;                                    /**< Timestamp watermark */
        time_t lastTimestamp;        /**< Last timestamp (context depends on type) */
        EventAction_T action;  /**< Description of the action upon event occurence */

        /** For internal use */
        struct Timestamp_T *next;                     /**< next timestamp in chain */
} *Timestamp_T;


/** Defines action rate object */
typedef struct ActionRate_T {
        int  count;                                            /**< Action counter */
        int  cycle;                                             /**< Cycle counter */
        EventAction_T action;    /**< Description of the action upon matching rate */

        /** For internal use */
        struct ActionRate_T *next;                   /**< next actionrate in chain */
} *ActionRate_T;


/** Defines when to run a check for a service. This type suports both the old
 cycle based every statement and the new cron-format version */
typedef struct Every_T {
        Every_Type type; /**< 0 = not set, 1 = cycle, 2 = cron, 3 = negated cron */
        time_t last_run;
        union {
                struct {
                        int number; /**< Check this program at a given cycles */
                        int counter; /**< Counter for number. When counter == number, check */
                } cycle; /**< Old cycle based every check */
                char *cron; /* A crontab format string */
        } spec;
} Every_T;


typedef struct Status_T {
        boolean_t initialized;                 /**< true if status was initialized */
        Operator_Type operator;                           /**< Comparison operator */
        int return_value;                /**< Return value of the program to check */
        EventAction_T action;  /**< Description of the action upon event occurence */

        /** For internal use */
        struct Status_T *next;                       /**< next exit value in chain */
} *Status_T;


typedef struct Program_T {
        Process_T P;          /**< A Process_T object representing the sub-process */
        Command_T C;          /**< A Command_T object for creating the sub-process */
        command_t args;                                     /**< Program arguments */
        time_t started;                      /**< When the sub-process was started */
        int timeout;           /**< Seconds the program may run until it is killed */
        int exitStatus;                 /**< Sub-process exit status for reporting */
        StringBuffer_T lastOutput;                        /**< Last program output */
        StringBuffer_T inprogressOutput; /**< Output of the pending program instance */
} *Program_T;


/** Defines size object */
typedef struct Size_T {
        boolean_t initialized;                   /**< true if size was initialized */
        boolean_t test_changes;       /**< true if we only should test for changes */
        Operator_Type operator;                           /**< Comparison operator */
        unsigned long long size;                               /**< Size watermark */
        EventAction_T action;  /**< Description of the action upon event occurence */

        /** For internal use */
        struct Size_T *next;                               /**< next size in chain */
} *Size_T;


/** Defines uptime object */
typedef struct Uptime_T {
        Operator_Type operator;                           /**< Comparison operator */
        unsigned long long uptime;                           /**< Uptime watermark */
        EventAction_T action;  /**< Description of the action upon event occurence */

        /** For internal use */
        struct Uptime_T *next;                           /**< next uptime in chain */
} *Uptime_T;


typedef struct LinkStatus_T {
        EventAction_T action;  /**< Description of the action upon event occurence */

        /** For internal use */
        struct LinkStatus_T *next;                      /**< next link in chain */
} *LinkStatus_T;


typedef struct LinkSpeed_T {
        int duplex;                                        /**< Last duplex status */
        long long speed;                                     /**< Last speed [bps] */
        EventAction_T action;  /**< Description of the action upon event occurence */

        /** For internal use */
        struct LinkSpeed_T *next;                       /**< next link in chain */
} *LinkSpeed_T;


typedef struct LinkSaturation_T {
        Operator_Type operator;                           /**< Comparison operator */
        float limit;                                     /**< Saturation limit [%] */
        EventAction_T action;  /**< Description of the action upon event occurence */

        /** For internal use */
        struct LinkSaturation_T *next;                  /**< next link in chain */
} *LinkSaturation_T;


typedef struct Bandwidth_T {
        Operator_Type operator;                           /**< Comparison operator */
        Time_Type range;                            /**< Time range to watch: unit */
        int rangecount;                            /**< Time range to watch: count */
        unsigned long long limit;                              /**< Data watermark */
        EventAction_T action;  /**< Description of the action upon event occurence */

        /** For internal use */
        struct Bandwidth_T *next;                     /**< next bandwidth in chain */
} *Bandwidth_T;


/** Defines checksum object */
typedef struct Checksum_T {
        boolean_t initialized;               /**< true if checksum was initialized */
        boolean_t test_changes;       /**< true if we only should test for changes */
        Hash_Type type;                   /**< The type of hash (e.g. md5 or sha1) */
        int   length;                                      /**< Length of the hash */
        MD_T  hash;                     /**< A checksum hash computed for the path */
        EventAction_T action;  /**< Description of the action upon event occurence */
} *Checksum_T;


/** Defines permission object */
typedef struct Perm_T {
        boolean_t test_changes;       /**< true if we only should test for changes */
        int perm;                                           /**< Access permission */
        EventAction_T action;  /**< Description of the action upon event occurence */
} *Perm_T;

/** Defines match object */
typedef struct Match_T {
        boolean_t ignore;                                        /**< Ignore match */
        boolean_t not;                                           /**< Invert match */
        char    *match_string;                                   /**< Match string */ //FIXME: union?
        char    *match_path;                         /**< File with matching rules */ //FIXME: union?
        regex_t *regex_comp;                                    /**< Match compile */
        StringBuffer_T log;    /**< The temporary buffer used to record the matches */
        EventAction_T action;  /**< Description of the action upon event occurence */

        /** For internal use */
        struct Match_T *next;                             /**< next match in chain */
} *Match_T;


/** Defines uid object */
typedef struct Uid_T {
        uid_t     uid;                                            /**< Owner's uid */
        EventAction_T action;  /**< Description of the action upon event occurence */
} *Uid_T;


/** Defines gid object */
typedef struct Gid_T {
        gid_t     gid;                                            /**< Owner's gid */
        EventAction_T action;  /**< Description of the action upon event occurence */
} *Gid_T;


typedef struct SecurityAttribute_T {
        char *attribute;                                   /**< Security attribute */
        EventAction_T action;  /**< Description of the action upon event occurence */

        /** For internal use */
        struct SecurityAttribute_T *next;
} *SecurityAttribute_T;


/** Defines pid object */
typedef struct Pid_T {
        EventAction_T action;  /**< Description of the action upon event occurence */

        /** For internal use */
        struct Pid_T *next;                                 /**< next pid in chain */
} *Pid_T;


typedef struct FsFlag_T {
        EventAction_T action;  /**< Description of the action upon event occurence */

        /** For internal use */
        struct FsFlag_T *next;
} *FsFlag_T;


typedef struct NonExist_T {
        EventAction_T action;  /**< Description of the action upon event occurence */

        /** For internal use */
        struct NonExist_T *next;
} *NonExist_T;


typedef struct Exist_T {
        EventAction_T action;  /**< Description of the action upon event occurence */

        /** For internal use */
        struct Exist_T *next;
} *Exist_T;


/** Defines filesystem configuration */
typedef struct FileSystem_T {
        Resource_Type resource;               /**< Whether to check inode or space */
        Operator_Type operator;                           /**< Comparison operator */
        //FIXME: union
        long long limit_absolute;                          /**< Watermark - blocks */
        float limit_percent;                              /**< Watermark - percent */
        EventAction_T action;  /**< Description of the action upon event occurence */

        /** For internal use */
        struct FileSystem_T *next;                   /**< next filesystem in chain */
} *FileSystem_T;


typedef struct IOStatistics_T {
        struct Statistics_T operations;        /**< Number of operations completed */
        struct Statistics_T bytes;      /**< Number of bytes handled by operations */
} *IOStatistics_T;


typedef struct Device_T {
        boolean_t mounted;
        int generation;
        int instance;
        char partition;
        char device[PATH_MAX];
        char mountpoint[PATH_MAX];
        char key[PATH_MAX];
        char module[256];
        char type[64];
        uint64_t flags;
        boolean_t (*getDiskUsage)(void *);
        boolean_t (*getDiskActivity)(void *);
} *Device_T;


typedef struct TimestampInfo_T {
        uint64_t access;
        uint64_t change;
        uint64_t modify;
} *TimestampInfo_T;


typedef struct FileSystemInfo_T {
        long long  f_blocks;              /**< Total data blocks in filesystem */
        long long  f_blocksfree;   /**< Free blocks available to non-superuser */
        long long  f_blocksfreetotal;           /**< Free blocks in filesystem */
        long long  f_blocksused;                  /**< Used space total blocks */
        long long  f_files;                /**< Total file nodes in filesystem */
        long long  f_filesfree;             /**< Free file nodes in filesystem */
        long long  f_filesused;                  /**< Used inode total objects */
        float inode_percent;                        /**< Used inode percentage */
        float space_percent;                        /**< Used space percentage */
        int f_bsize;                                  /**< Transfer block size */
        int uid;                                              /**< Owner's uid */
        int gid;                                              /**< Owner's gid */
        int mode;                                              /**< Permission */
        char flags[STRLEN];                              /**< Filesystem flags */
        boolean_t flagsChanged;          /**< True if filesystem flags changed */
        struct IOStatistics_T read;                       /**< Read statistics */
        struct IOStatistics_T write;                     /**< Write statistics */
        struct {
                struct Statistics_T read;         /**< Time spend by read [ms] */
                struct Statistics_T write;       /**< Time spend by write [ms] */
                struct Statistics_T wait;   /**< Time spend in wait queue [ms] */
                struct Statistics_T run;     /**< Time spend in run queue [ms] */
        } time;
        struct Device_T object;                             /**< Device object */
} *FileSystemInfo_T;


typedef struct FileInfo_T {
        struct TimestampInfo_T timestamp;
        int mode;                                              /**< Permission */
        int uid;                                              /**< Owner's uid */
        int gid;                                              /**< Owner's gid */
        off_t size;                                                  /**< Size */
        off_t readpos;                        /**< Position for regex matching */
        ino_t inode;                                                /**< Inode */
        ino_t inode_prev;               /**< Previous inode for regex matching */
        MD_T  cs_sum;                                            /**< Checksum */ //FIXME: allocate dynamically only when necessary
} *FileInfo_T;


typedef struct DirectoryInfo_T {
        struct TimestampInfo_T timestamp;
        int mode;                                              /**< Permission */
        int uid;                                              /**< Owner's uid */
        int gid;                                              /**< Owner's gid */
} *DirectoryInfo_T;


typedef struct FifoInfo_T {
        struct TimestampInfo_T timestamp;
        int mode;                                              /**< Permission */
        int uid;                                              /**< Owner's uid */
        int gid;                                              /**< Owner's gid */
} *FifoInfo_T;


typedef struct ProcessInfo_T {
        boolean_t zombie;
        pid_t _pid;                           /**< Process PID from last cycle */
        pid_t _ppid;                   /**< Process parent PID from last cycle */
        pid_t pid;                          /**< Process PID from actual cycle */
        pid_t ppid;                  /**< Process parent PID from actual cycle */
        int uid;                                              /**< Process UID */
        int euid;                                   /**< Effective Process UID */
        int gid;                                              /**< Process GID */
        int threads;
        int children;
        uint64_t mem;
        uint64_t total_mem;
        float mem_percent;                                     /**< percentage */
        float total_mem_percent;                               /**< percentage */
        float cpu_percent;                                     /**< percentage */
        float total_cpu_percent;                               /**< percentage */
        time_t uptime;                                     /**< Process uptime */
        struct IOStatistics_T read;                       /**< Read statistics */
        struct IOStatistics_T write;                     /**< Write statistics */
        char secattr[STRLEN];                         /**< Security attributes */
} *ProcessInfo_T;


typedef struct NetInfo_T {
        Link_T stats;
} *NetInfo_T;


/** Defines service data */
typedef union Info_T {
        //FIXME: move global SystemInfo_T systeminfo here (for System service context)
        DirectoryInfo_T  directory;
        FifoInfo_T       fifo;
        FileInfo_T       file;
        FileSystemInfo_T filesystem;
        NetInfo_T        net;
        ProcessInfo_T    process;
} *Info_T;


/** Defines service data */
//FIXME: use union for type-specific rules
typedef struct Service_T {

        /** Common parameters */
        char *name;                                  /**< Service descriptive name */
        State_Type (*check)(struct Service_T *);/**< Service verification function */
        boolean_t visited; /**< Service visited flag, set if dependencies are used */
        Service_Type type;                             /**< Monitored service type */
        Monitor_State monitor;                             /**< Monitor state flag */
        Monitor_Mode mode;                    /**< Monitoring mode for the service */
        Onreboot_Type onreboot;                                /**< On reboot mode */
        Action_Type doaction;                 /**< Action scheduled by http thread */
        int  ncycle;                          /**< The number of the current cycle */
        int  nstart;           /**< The number of current starts with this service */
        Every_T every;              /**< Timespec for when to run check of service */
        command_t start;                    /**< The start command for the service */
        command_t stop;                      /**< The stop command for the service */
        command_t restart;                /**< The restart command for the service */
        Program_T program;                            /**< Program execution check */

        Dependant_T dependantlist;                     /**< Dependant service list */
        Mail_T maillist;                       /**< Alert notification mailinglist */

        /** Test rules and event handlers */
        ActionRate_T actionratelist;                    /**< ActionRate check list */
        Checksum_T  checksum;                                  /**< Checksum check */
        FileSystem_T filesystemlist;                    /**< Filesystem check list */
        Icmp_T      icmplist;                                 /**< ICMP check list */
        Perm_T      perm;                                    /**< Permission check */
        Port_T      portlist;                            /**< Portnumbers to check */
        Port_T      socketlist;                         /**< Unix sockets to check */
        Resource_T  resourcelist;                          /**< Resouce check list */
        Size_T      sizelist;                                 /**< Size check list */
        Uptime_T    uptimelist;                             /**< Uptime check list */
        Match_T     matchlist;                             /**< Content Match list */
        Match_T     matchignorelist;                /**< Content Match ignore list */
        Timestamp_T timestamplist;                       /**< Timestamp check list */
        Pid_T       pidlist;                                   /**< Pid check list */
        Pid_T       ppidlist;                                 /**< PPid check list */
        Status_T    statuslist;           /**< Program execution status check list */
        FsFlag_T    fsflaglist;           /**< Action upon filesystem flags change */
        NonExist_T  nonexistlist;      /**< Actions if test subject does not exist */
        Exist_T     existlist;                  /**< Actions if test subject exist */
        Uid_T       uid;                                            /**< Uid check */
        Uid_T       euid;                                 /**< Effective Uid check */
        Gid_T       gid;                                            /**< Gid check */
        SecurityAttribute_T secattrlist;             /**< Security attributes list */
        LinkStatus_T linkstatuslist;                 /**< Network link status list */
        LinkSpeed_T linkspeedlist;                    /**< Network link speed list */
        LinkSaturation_T linksaturationlist;     /**< Network link saturation list */
        Bandwidth_T uploadbyteslist;                  /**< Upload bytes check list */
        Bandwidth_T uploadpacketslist;              /**< Upload packets check list */
        Bandwidth_T downloadbyteslist;              /**< Download bytes check list */
        Bandwidth_T downloadpacketslist;          /**< Download packets check list */

        /** General event handlers */
        EventAction_T action_DATA;       /**< Description of the action upon event */
        EventAction_T action_EXEC;       /**< Description of the action upon event */
        EventAction_T action_INVALID;    /**< Description of the action upon event */

        /** Internal monit events */
        EventAction_T action_MONIT_START;  /**< Monit instance start/reload action */
        EventAction_T action_MONIT_STOP;           /**< Monit instance stop action */
        EventAction_T action_ACTION;           /**< Action requested by CLI or GUI */

        /** Runtime parameters */
        int                error;                          /**< Error flags bitmap */
        int                error_hint;   /**< Failed/Changed hint for error bitmap */
        union Info_T       inf;                          /**< Service check result */
        struct timeval     collected;                /**< When were data collected */ //FIXME: replace with uint64_t? (all places where timeval is used) ... Time_milli()?
        char              *token;                                /**< Action token */

        /** Events */
        struct myevent {
                #define           EVENT_VERSION  4      /**< The event structure version */
                long              id;                      /**< The event identification */
                struct timeval    collected;                /**< When the event occurred */
                struct Service_T *source;                              /**< Event source */
                Monitor_Mode      mode;             /**< Monitoring mode for the service */
                Service_Type      type;                      /**< Monitored service type */
                State_Type        state;                                 /**< Test state */
                boolean_t         state_changed;              /**< true if state changed */
                Handler_Type      flag;                     /**< The handlers state flag */
                long long         state_map;           /**< Event bitmap for last cycles */
                unsigned int      count;                             /**< The event rate */
                char             *message;    /**< Optional message describing the event */
                EventAction_T     action;           /**< Description of the event action */
                /** For internal use */
                struct myevent   *next;                         /**< next event in chain */
        } *eventlist;                                     /**< Pending events list */

        /** Context specific parameters */
        char *path;  /**< Path to the filesys, file, directory or process pid file */

        /** For internal use */
        Mutex_T mutex;                  /**< Mutex used for action synchronization */
        struct Service_T *next;                         /**< next service in chain */
        struct Service_T *next_conf;      /**< next service according to conf file */
        struct Service_T *next_depend;           /**< next depend service in chain */
} *Service_T;


typedef struct myevent *Event_T;


typedef struct ServiceGroup_T {
        char *name;                                     /**< name of service group */
        List_T members;                                 /**< Service group members */

        /** For internal use */
        struct ServiceGroup_T *next;              /**< next service group in chain */
} *ServiceGroup_T;


/** Data for application runtime */
struct Run_T {
        uint8_t debug;                                            /**< Debug level */
        volatile Run_Flags flags;
        Handler_Type handler_flag;                    /**< The handlers state flag */
        Onreboot_Type onreboot;
        struct {
                char *control;            /**< The file to read configuration from */
                char *log;                     /**< The file to write logdata into */
                char *pid;                              /**< This programs pidfile */
                char *id;                       /**< The file with unique monit id */
                char *state;            /**< The file with the saved runtime state */
        } files;
        char *mygroup;                              /**< Group Name of the Service */
        MD_T id;                                              /**< Unique monit id */
        Limits_T limits;                                       /**< Default limits */
        struct SslOptions_T ssl;                          /**< Default SSL options */
        int  polltime;        /**< In deamon mode, the sleeptime (sec) between run */
        int  startdelay;                    /**< the sleeptime (sec) after startup */
        int  facility;              /** The facility to use when running openlog() */
        int  eventlist_slots;          /**< The event queue size - number of slots */
        int mailserver_timeout; /**< Connect and read timeout ms for a SMTP server */
        time_t incarnation;              /**< Unique ID for running monit instance */
        int  handler_queue[Handler_Max + 1];       /**< The handlers queue counter */
        Service_T system;                          /**< The general system service */
        char *eventlist_dir;                   /**< The event queue base directory */

        /** An object holding Monit HTTP interface setup */
        struct {
                Httpd_Flags flags;
                struct {
                        struct {
                                int  port;
                                char *address;
                                struct SslOptions_T ssl;
                        } net;
                        struct {
                                int uid;
                                int gid;
                                int permission;
                                char *path;
                        } unix;
                } socket;
                Auth_T credentials;
        } httpd;

        /** An object holding program relevant "environment" data, see: env.c */
        struct myenvironment {
                char *user;             /**< The the effective user running this program */
                char *home;                                    /**< Users home directory */
                char *cwd;                                /**< Current working directory */
        } Env;

        char *mail_hostname;    /**< Used in HELO/EHLO/MessageID when sending mail */
        Mail_T maillist;                /**< Global alert notification mailinglist */
        MailServer_T mailservers;    /**< List of MTAs used for alert notification */
        Mmonit_T mmonits;        /**< Event notification and status receivers list */
        Auth_T mmonitcredentials;     /**< Pointer to selected credentials or NULL */
        /** User selected standard mail format */
        struct myformat {
                Address_T from;                      /**< The standard mail from address */
                Address_T replyto;                         /**< Optional reply-to header */
                char *subject;                            /**< The standard mail subject */
                char *message;                            /**< The standard mail message */
        } MailFormat;

        Mutex_T mutex;            /**< Mutex used for service data synchronization */
};


/* -------------------------------------------------------- Global variables */


extern const char    *prog;
extern struct Run_T   Run;
extern Service_T      servicelist;
extern Service_T      servicelist_conf;
extern ServiceGroup_T servicegrouplist;
extern SystemInfo_T   systeminfo;

extern char *actionnames[];
extern char *modenames[];
extern char *onrebootnames[];
extern char *checksumnames[];
extern char *operatornames[];
extern char *operatorshortnames[];
extern char *servicetypes[];
extern char *pathnames[];
extern char *icmpnames[];
extern char *sslnames[];
extern char *socketnames[];
extern char *timestampnames[];
extern char *httpmethod[];


/* ------------------------------------------------------- Public prototypes */

#include "util.h"
#include "file.h"

// libmonit
#include "system/Mem.h"


/* FIXME: move remaining prototypes into seperate header-files */

boolean_t parse(char *);
boolean_t control_service(const char *, Action_Type);
boolean_t control_service_string(List_T, const char *);
void  spawn(Service_T, command_t, Event_T);
boolean_t log_init(void);
void  LogEmergency(const char *, ...) __attribute__((format (printf, 1, 2)));
void  LogAlert(const char *, ...) __attribute__((format (printf, 1, 2)));
void  LogCritical(const char *, ...) __attribute__((format (printf, 1, 2)));
void  LogError(const char *, ...) __attribute__((format (printf, 1, 2)));
void  LogWarning(const char *, ...) __attribute__((format (printf, 1, 2)));
void  LogNotice(const char *, ...) __attribute__((format (printf, 1, 2)));
void  LogInfo(const char *, ...) __attribute__((format (printf, 1, 2)));
void  LogDebug(const char *, ...) __attribute__((format (printf, 1, 2)));
void  vLogEmergency(const char *, va_list ap);
void  vLogAlert(const char *, va_list ap);
void  vLogCritical(const char *, va_list ap);
void  vLogError(const char *, va_list ap);
void  vLogWarning(const char *,va_list ap);
void  vLogNotice(const char *, va_list ap);
void  vLogInfo(const char *, va_list ap);
void  vLogDebug(const char *, va_list ap);
void  vLogAbortHandler(const char *s, va_list ap);
void  log_close(void);
#ifndef HAVE_VSYSLOG
#ifdef HAVE_SYSLOG
void vsyslog (int, const char *, va_list);
#endif /* HAVE_SYSLOG */
#endif /* HAVE_VSYSLOG */
int   validate(void);
void  daemonize(void);
void  gc(void);
void  gc_mail_list(Mail_T *);
void  gccmd(command_t *);
void  gc_event(Event_T *e);
boolean_t kill_daemon(int);
int   exist_daemon(void);
boolean_t sendmail(Mail_T);
void  init_env(void);
void  monit_http(Httpd_Action);
boolean_t can_http(void);
void set_signal_block(void);
State_Type check_process(Service_T);
State_Type check_filesystem(Service_T);
State_Type check_file(Service_T);
State_Type check_directory(Service_T);
State_Type check_remote_host(Service_T);
State_Type check_system(Service_T);
State_Type check_fifo(Service_T);
State_Type check_program(Service_T);
State_Type check_net(Service_T);
int  check_URL(Service_T s);
void status_xml(StringBuffer_T, Event_T, int, const char *);
boolean_t  do_wakeupcall(void);
boolean_t interrupt(void);

#endif
