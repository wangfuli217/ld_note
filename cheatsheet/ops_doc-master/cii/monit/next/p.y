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


%{

/*
 * DESCRIPTION
 *   Simple context-free grammar for parsing the control file.
 *
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

#ifdef HAVE_CTYPE_H
#include <ctype.h>
#endif

#ifdef HAVE_PWD_H
#include <pwd.h>
#endif

#ifdef HAVE_GRP_H
#include <grp.h>
#endif

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#ifdef HAVE_SYS_TIME_H
#include <sys/time.h>
#endif

#ifdef HAVE_TIME_H
#include <time.h>
#endif

#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif

#ifdef HAVE_ASM_PARAM_H
#include <asm/param.h>
#endif

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#ifdef HAVE_STRINGS_H
#include <strings.h>
#endif

#ifdef HAVE_NETDB_H
#include <netdb.h>
#endif

#ifdef HAVE_SYSLOG_H
#include <syslog.h>
#endif

#ifdef HAVE_NETINET_IN_SYSTM_H
#include <netinet/in_systm.h>
#endif

#ifdef HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif

#ifdef HAVE_NETINET_IP_H
#include <netinet/ip.h>
#endif

#ifdef HAVE_NETINET_IP_ICMP_H
#include <netinet/ip_icmp.h>
#endif

#ifdef HAVE_REGEX_H
#include <regex.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#include "net.h"
#include "monit.h"
#include "protocol.h"
#include "engine.h"
#include "alert.h"
#include "ProcessTree.h"
#include "device.h"
#include "processor.h"

// libmonit
#include "io/File.h"
#include "util/Str.h"
#include "thread/Thread.h"


/* ------------------------------------------------------------- Definitions */


struct precedence_t {
        boolean_t daemon;
        boolean_t logfile;
        boolean_t pidfile;
};

struct rate_t {
        unsigned count;
        unsigned cycles;
};

/* yacc interface */
void  yyerror(const char *,...);
void  yyerror2(const char *,...);
void  yywarning(const char *,...);
void  yywarning2(const char *,...);

/* lexer interface */
int yylex(void);
extern FILE *yyin;
extern int lineno;
extern int arglineno;
extern char *yytext;
extern char *argyytext;
extern char *currentfile;
extern char *argcurrentfile;
extern int buffer_stack_ptr;

/* Local variables */
static int cfg_errflag = 0;
static Service_T tail = NULL;
static Service_T current = NULL;
static Request_T urlrequest = NULL;
static command_t command = NULL;
static command_t command1 = NULL;
static command_t command2 = NULL;
static Service_T depend_list = NULL;
static struct Uid_T uidset = {};
static struct Gid_T gidset = {};
static struct Pid_T pidset = {};
static struct Pid_T ppidset = {};
static struct FsFlag_T fsflagset = {};
static struct NonExist_T nonexistset = {};
static struct Exist_T existset = {};
static struct Status_T statusset = {};
static struct Perm_T permset = {};
static struct Size_T sizeset = {};
static struct Uptime_T uptimeset = {};
static struct LinkStatus_T linkstatusset = {};
static struct LinkSpeed_T linkspeedset = {};
static struct LinkSaturation_T linksaturationset = {};
static struct Bandwidth_T bandwidthset = {};
static struct Match_T matchset = {};
static struct Icmp_T icmpset = {};
static struct Mail_T mailset = {};
static struct SslOptions_T sslset = {};
static struct Port_T portset = {};
static struct MailServer_T mailserverset = {};
static struct Mmonit_T mmonitset = {};
static struct FileSystem_T filesystemset = {};
static struct Resource_T resourceset = {};
static struct Checksum_T checksumset = {};
static struct Timestamp_T timestampset = {};
static struct ActionRate_T actionrateset = {};
static struct precedence_t ihp = {false, false, false};
static struct rate_t rate = {1, 1};
static struct rate_t rate1 = {1, 1};
static struct rate_t rate2 = {1, 1};
static char * htpasswd_file = NULL;
static unsigned repeat = 0;
static unsigned repeat1 = 0;
static unsigned repeat2 = 0;
static Digest_Type digesttype = Digest_Cleartext;

#define BITMAP_MAX (sizeof(long long) * 8)


/* -------------------------------------------------------------- Prototypes */

static void  preparse(void);
static void  postparse(void);
static boolean_t _parseOutgoingAddress(const char *ip, Outgoing_T *outgoing);
static void  addmail(char *, Mail_T, Mail_T *);
static Service_T createservice(Service_Type, char *, char *, State_Type (*)(Service_T));
static void  addservice(Service_T);
static void  adddependant(char *);
static void  addservicegroup(char *);
static void  addport(Port_T *, Port_T);
static void  addhttpheader(Port_T, const char *);
static void  addresource(Resource_T);
static void  addtimestamp(Timestamp_T);
static void  addactionrate(ActionRate_T);
static void  addsize(Size_T);
static void  adduptime(Uptime_T);
static void  addpid(Pid_T);
static void  addppid(Pid_T);
static void  addfsflag(FsFlag_T);
static void  addnonexist(NonExist_T);
static void  addexist(Exist_T);
static void  addlinkstatus(Service_T, LinkStatus_T);
static void  addlinkspeed(Service_T, LinkSpeed_T);
static void  addlinksaturation(Service_T, LinkSaturation_T);
static void  addbandwidth(Bandwidth_T *, Bandwidth_T);
static void  addfilesystem(FileSystem_T);
static void  addicmp(Icmp_T);
static void  addgeneric(Port_T, char*, char*);
static void  addcommand(int, unsigned);
static void  addargument(char *);
static void  addmmonit(Mmonit_T);
static void  addmailserver(MailServer_T);
static boolean_t addcredentials(char *, char *, Digest_Type, boolean_t);
#ifdef HAVE_LIBPAM
static void  addpamauth(char *, int);
#endif
static void  addhtpasswdentry(char *, char *, Digest_Type);
static uid_t get_uid(char *, uid_t);
static gid_t get_gid(char *, gid_t);
static void  addchecksum(Checksum_T);
static void  addperm(Perm_T);
static void  addmatch(Match_T, int, int);
static void  addmatchpath(Match_T, Action_Type);
static void  addstatus(Status_T);
static Uid_T adduid(Uid_T);
static Gid_T addgid(Gid_T);
static void  addeuid(uid_t);
static void  addegid(gid_t);
static void  addeventaction(EventAction_T *, Action_Type, Action_Type);
static void  prepare_urlrequest(URL_T U);
static void  seturlrequest(int, char *);
static void  setlogfile(char *);
static void  setpidfile(char *);
static void  reset_sslset(void);
static void  reset_mailset(void);
static void  reset_mailserverset(void);
static void  reset_mmonitset(void);
static void  reset_portset(void);
static void  reset_resourceset(void);
static void  reset_timestampset(void);
static void  reset_actionrateset(void);
static void  reset_sizeset(void);
static void  reset_uptimeset(void);
static void  reset_pidset(void);
static void  reset_ppidset(void);
static void  reset_fsflagset(void);
static void  reset_nonexistset(void);
static void  reset_existset(void);
static void  reset_linkstatusset(void);
static void  reset_linkspeedset(void);
static void  reset_linksaturationset(void);
static void  reset_bandwidthset(void);
static void  reset_checksumset(void);
static void  reset_permset(void);
static void  reset_uidset(void);
static void  reset_gidset(void);
static void  reset_statusset(void);
static void  reset_filesystemset(void);
static void  reset_icmpset(void);
static void  reset_rateset(struct rate_t *);
static void  check_name(char *);
static int   check_perm(int);
static void  check_exec(char *);
static int   cleanup_hash_string(char *);
static void  check_depend(void);
static void  setsyslog(char *);
static command_t copycommand(command_t);
static int verifyMaxForward(int);
static void _setPEM(char **store, char *path, const char *description, boolean_t isFile);
static void _setSSLOptions(SslOptions_T options);
static void addsecurityattribute(char *, Action_Type, Action_Type);

%}

%union {
        URL_T url;
        Address_T address;
        float real;
        int   number;
        char *string;
}

%token IF ELSE THEN FAILED
%token SET LOGFILE FACILITY DAEMON SYSLOG MAILSERVER HTTPD ALLOW REJECTOPT ADDRESS INIT TERMINAL BATCH
%token READONLY CLEARTEXT MD5HASH SHA1HASH CRYPT DELAY
%token PEMFILE ENABLE DISABLE SSL CIPHER CLIENTPEMFILE ALLOWSELFCERTIFICATION SELFSIGNED VERIFY CERTIFICATE CACERTIFICATEFILE CACERTIFICATEPATH VALID
%token INTERFACE LINK PACKET BYTEIN BYTEOUT PACKETIN PACKETOUT SPEED SATURATION UPLOAD DOWNLOAD TOTAL
%token IDFILE STATEFILE SEND EXPECT CYCLE COUNT REMINDER REPEAT
%token LIMITS SENDEXPECTBUFFER EXPECTBUFFER FILECONTENTBUFFER HTTPCONTENTBUFFER PROGRAMOUTPUT NETWORKTIMEOUT PROGRAMTIMEOUT STARTTIMEOUT STOPTIMEOUT RESTARTTIMEOUT
%token PIDFILE START STOP PATHTOK
%token HOST HOSTNAME PORT IPV4 IPV6 TYPE UDP TCP TCPSSL PROTOCOL CONNECTION
%token ALERT NOALERT MAILFORMAT UNIXSOCKET SIGNATURE
%token TIMEOUT RETRY RESTART CHECKSUM EVERY NOTEVERY
%token DEFAULT HTTP HTTPS APACHESTATUS FTP SMTP SMTPS POP POPS IMAP IMAPS CLAMAV NNTP NTP3 MYSQL DNS WEBSOCKET
%token SSH DWP LDAP2 LDAP3 RDATE RSYNC TNS PGSQL POSTFIXPOLICY SIP LMTP GPS RADIUS MEMCACHE REDIS MONGODB SIEVE SPAMASSASSIN FAIL2BAN
%token <string> STRING PATH MAILADDR MAILFROM MAILREPLYTO MAILSUBJECT
%token <string> MAILBODY SERVICENAME STRINGNAME
%token <number> NUMBER PERCENT LOGLIMIT CLOSELIMIT DNSLIMIT KEEPALIVELIMIT
%token <number> REPLYLIMIT REQUESTLIMIT STARTLIMIT WAITLIMIT GRACEFULLIMIT
%token <number> CLEANUPLIMIT
%token <real> REAL
%token CHECKPROC CHECKFILESYS CHECKFILE CHECKDIR CHECKHOST CHECKSYSTEM CHECKFIFO CHECKPROGRAM CHECKNET
%token THREADS CHILDREN METHOD GET HEAD STATUS ORIGIN VERSIONOPT READ WRITE OPERATION SERVICETIME DISK
%token RESOURCE MEMORY TOTALMEMORY LOADAVG1 LOADAVG5 LOADAVG15 SWAP
%token MODE ACTIVE PASSIVE MANUAL ONREBOOT NOSTART LASTSTATE CPU TOTALCPU CPUUSER CPUSYSTEM CPUWAIT
%token GROUP REQUEST DEPENDS BASEDIR SLOT EVENTQUEUE SECRET HOSTHEADER
%token UID EUID GID MMONIT INSTANCE USERNAME PASSWORD
%token TIME ATIME CTIME MTIME CHANGED MILLISECOND SECOND MINUTE HOUR DAY MONTH
%token SSLAUTO SSLV2 SSLV3 TLSV1 TLSV11 TLSV12 TLSV13 CERTMD5 AUTO
%token BYTE KILOBYTE MEGABYTE GIGABYTE
%token INODE SPACE TFREE PERMISSION SIZE MATCH NOT IGNORE ACTION UPTIME
%token EXEC UNMONITOR PING PING4 PING6 ICMP ICMPECHO NONEXIST EXIST INVALID DATA RECOVERED PASSED SUCCEEDED
%token URL CONTENT PID PPID FSFLAG
%token REGISTER CREDENTIALS
%token <url> URLOBJECT
%token <address> ADDRESSOBJECT
%token <string> TARGET TIMESPEC HTTPHEADER
%token <number> MAXFORWARD
%token FIPS
%token SECURITY ATTRIBUTE

%left GREATER GREATEROREQUAL LESS LESSOREQUAL EQUAL NOTEQUAL


%%
cfgfile         : /* EMPTY */
                | statement_list
                ;

statement_list  : statement
                | statement_list statement
                ;

statement       : setalert
                | setssl
                | setdaemon
                | setterminal
                | setlog
                | seteventqueue
                | setmmonits
                | setmailservers
                | setmailformat
                | sethttpd
                | setpid
                | setidfile
                | setstatefile
                | setexpectbuffer
                | setinit
                | setlimits
                | setonreboot
                | setfips
                | checkproc optproclist
                | checkfile optfilelist
                | checkfilesys optfilesyslist
                | checkdir optdirlist
                | checkhost opthostlist
                | checksystem optsystemlist
                | checkfifo optfifolist
                | checkprogram optprogramlist
                | checknet optnetlist
                ;

optproclist     : /* EMPTY */
                | optproclist optproc
                ;

optproc         : start
                | stop
                | restart
                | exist
                | pid
                | ppid
                | uid
                | euid
                | secattr
                | gid
                | uptime
                | connection
                | connectionurl
                | connectionunix
                | actionrate
                | alert
                | every
                | mode
                | onreboot
                | group
                | depend
                | resourceprocess
                ;

optfilelist      : /* EMPTY */
                | optfilelist optfile
                ;

optfile         : start
                | stop
                | restart
                | exist
                | timestamp
                | actionrate
                | every
                | alert
                | permission
                | uid
                | gid
                | checksum
                | size
                | match
                | mode
                | onreboot
                | group
                | depend
                ;

optfilesyslist  : /* EMPTY */
                | optfilesyslist optfilesys
                ;

optfilesys      : start
                | stop
                | restart
                | exist
                | actionrate
                | every
                | alert
                | permission
                | uid
                | gid
                | mode
                | onreboot
                | group
                | depend
                | inode
                | space
                | read
                | write
                | servicetime
                | fsflag
                ;

optdirlist      : /* EMPTY */
                | optdirlist optdir
                ;

optdir          : start
                | stop
                | restart
                | exist
                | timestamp
                | actionrate
                | every
                | alert
                | permission
                | uid
                | gid
                | mode
                | onreboot
                | group
                | depend
                ;

opthostlist     : /* EMPTY */
                | opthostlist opthost
                ;

opthost         : start
                | stop
                | restart
                | connection
                | connectionurl
                | icmp
                | actionrate
                | alert
                | every
                | mode
                | onreboot
                | group
                | depend
                ;

optnetlist      : /* EMPTY */
                | optnetlist optnet
                ;

optnet          : start
                | stop
                | restart
                | linkstatus
                | linkspeed
                | linksaturation
                | upload
                | download
                | actionrate
                | every
                | mode
                | onreboot
                | alert
                | group
                | depend
                ;

optsystemlist   : /* EMPTY */
                | optsystemlist optsystem
                ;

optsystem       : start
                | stop
                | restart
                | actionrate
                | alert
                | every
                | mode
                | onreboot
                | group
                | depend
                | resourcesystem
                | uptime
                ;

optfifolist     : /* EMPTY */
                | optfifolist optfifo
                ;

optfifo         : start
                | stop
                | restart
                | exist
                | timestamp
                | actionrate
                | every
                | alert
                | permission
                | uid
                | gid
                | mode
                | onreboot
                | group
                | depend
                ;

optprogramlist  : /* EMPTY */
                | optprogramlist optprogram
                ;

optprogram      : start
                | stop
                | restart
                | actionrate
                | alert
                | every
                | mode
                | onreboot
                | group
                | depend
                | statusvalue
                ;

setalert        : SET alertmail formatlist reminder {
                        mailset.events = Event_All;
                        addmail($<string>2, &mailset, &Run.maillist);
                  }
                | SET alertmail '{' eventoptionlist '}' formatlist reminder {
                        addmail($<string>2, &mailset, &Run.maillist);
                  }
                | SET alertmail NOT '{' eventoptionlist '}' formatlist reminder {
                        mailset.events = ~mailset.events;
                        addmail($<string>2, &mailset, &Run.maillist);
                  }
                ;

setdaemon       : SET DAEMON NUMBER startdelay {
                        if (! (Run.flags & Run_Daemon) || ihp.daemon) {
                                ihp.daemon     = true;
                                Run.flags      |= Run_Daemon;
                                Run.polltime   = $3;
                                Run.startdelay = $<number>4;
                        }
                  }
                ;

setterminal     : SET TERMINAL BATCH {
                        Run.flags |= Run_Batch;
                  }
                ;

startdelay      : /* EMPTY */ {
                        $<number>$ = START_DELAY;
                  }
                | START DELAY NUMBER {
                        $<number>$ = $3;
                  }
                ;

setinit         : SET INIT {
                        Run.flags |= Run_Foreground;
                  }
                ;

setonreboot     : SET ONREBOOT START {
                        Run.onreboot = Onreboot_Start;
                  }
                | SET ONREBOOT NOSTART {
                        Run.onreboot = Onreboot_Nostart;
                  }
                | SET ONREBOOT LASTSTATE {
                        Run.onreboot = Onreboot_Laststate;
                  }
                ;

setexpectbuffer : SET EXPECTBUFFER NUMBER unit {
                        // Note: deprecated (replaced by "set limits" statement's "sendExpectBuffer" option)
                        Run.limits.sendExpectBuffer = $3 * $<number>4;
                  }
                ;

setlimits       : SET LIMITS '{' limitlist '}'
                ;

limitlist       : /* EMPTY */
                | limitlist limit
                ;

limit           : SENDEXPECTBUFFER ':' NUMBER unit {
                        Run.limits.sendExpectBuffer = $3 * $<number>4;
                  }
                | FILECONTENTBUFFER ':' NUMBER unit {
                        Run.limits.fileContentBuffer = $3 * $<number>4;
                  }
                | HTTPCONTENTBUFFER ':' NUMBER unit {
                        Run.limits.httpContentBuffer = $3 * $<number>4;
                  }
                | PROGRAMOUTPUT ':' NUMBER unit {
                        Run.limits.programOutput = $3 * $<number>4;
                  }
                | NETWORKTIMEOUT ':' NUMBER MILLISECOND {
                        Run.limits.networkTimeout = $3;
                  }
                | NETWORKTIMEOUT ':' NUMBER SECOND {
                        Run.limits.networkTimeout = $3 * 1000;
                  }
                | PROGRAMTIMEOUT ':' NUMBER MILLISECOND {
                        Run.limits.programTimeout = $3;
                  }
                | PROGRAMTIMEOUT ':' NUMBER SECOND {
                        Run.limits.programTimeout = $3 * 1000;
                  }
                | STOPTIMEOUT ':' NUMBER MILLISECOND {
                        Run.limits.stopTimeout = $3;
                  }
                | STOPTIMEOUT ':' NUMBER SECOND {
                        Run.limits.stopTimeout = $3 * 1000;
                  }
                | STARTTIMEOUT ':' NUMBER MILLISECOND {
                        Run.limits.startTimeout = $3;
                  }
                | STARTTIMEOUT ':' NUMBER SECOND {
                        Run.limits.startTimeout = $3 * 1000;
                  }
                | RESTARTTIMEOUT ':' NUMBER MILLISECOND {
                        Run.limits.restartTimeout = $3;
                  }
                | RESTARTTIMEOUT ':' NUMBER SECOND {
                        Run.limits.restartTimeout = $3 * 1000;
                  }
                ;

setfips         : SET FIPS {
                        Run.flags |= Run_FipsEnabled;
                  }
                ;

setlog          : SET LOGFILE PATH   {
                        if (! Run.files.log || ihp.logfile) {
                                ihp.logfile = true;
                                setlogfile($3);
                                Run.flags &= ~Run_UseSyslog;
                                Run.flags |= Run_Log;
                        }
                  }
                | SET LOGFILE SYSLOG {
                        setsyslog(NULL);
                  }
                | SET LOGFILE SYSLOG FACILITY STRING {
                        setsyslog($5); FREE($5);
                  }
                ;

seteventqueue   : SET EVENTQUEUE BASEDIR PATH {
                        Run.eventlist_dir = $4;
                  }
                | SET EVENTQUEUE BASEDIR PATH SLOT NUMBER {
                        Run.eventlist_dir = $4;
                        Run.eventlist_slots = $6;
                  }
                | SET EVENTQUEUE SLOT NUMBER {
                        Run.eventlist_dir = Str_dup(MYEVENTLISTBASE);
                        Run.eventlist_slots = $4;
                  }
                ;

setidfile       : SET IDFILE PATH {
                        Run.files.id = $3;
                  }
                ;

setstatefile    : SET STATEFILE PATH {
                        Run.files.state = $3;
                  }
                ;

setpid          : SET PIDFILE PATH {
                        if (! Run.files.pid || ihp.pidfile) {
                                ihp.pidfile = true;
                                setpidfile($3);
                        }
                  }
                ;

setmmonits      : SET MMONIT mmonitlist
                ;

mmonitlist      : mmonit credentials
                | mmonitlist mmonit credentials
                ;

mmonit          : URLOBJECT mmonitoptlist {
                        mmonitset.url = $<url>1;
                        addmmonit(&mmonitset);
                  }
                ;

mmonitoptlist : /* EMPTY */
                | mmonitoptlist mmonitopt
                ;

mmonitopt       : TIMEOUT NUMBER SECOND {
                        mmonitset.timeout = $<number>2 * 1000; // net timeout is in milliseconds internally
                  }
                | ssl
                | sslchecksum
                | sslversion
                | certmd5
                ;

credentials     : /* EMPTY */
                | REGISTER CREDENTIALS {
                        Run.flags &= ~Run_MmonitCredentials;
                  }
                ;

setssl          : SET SSL '{' ssloptionlist '}' {
                        _setSSLOptions(&(Run.ssl));
                  }
                ;

ssl             : SSL {
                        sslset.flags = SSL_Enabled;
                  }
                | SSL '{' ssloptionlist '}'
                ;

ssloptionlist   : /* EMPTY */
                | ssloptionlist ssloption
                ;

ssloption       : VERIFY ':' ENABLE {
                        sslset.flags = SSL_Enabled;
                        sslset.verify = true;
                  }
                | VERIFY ':' DISABLE {
                        sslset.flags = SSL_Enabled;
                        sslset.verify = false;
                  }
                | SELFSIGNED ':' ALLOW {
                        sslset.flags = SSL_Enabled;
                        sslset.allowSelfSigned = true;
                  }
                | SELFSIGNED ':' REJECTOPT {
                        sslset.flags = SSL_Enabled;
                        sslset.allowSelfSigned = false;
                  }
                | VERSIONOPT ':' sslversion {
                        sslset.flags = SSL_Enabled;
                  }
                | CIPHER ':' STRING {
                        FREE(sslset.ciphers);
                        sslset.ciphers = $<string>3;
                  }
                | PEMFILE ':' PATH {
                        _setPEM(&(sslset.pemfile), $3, "SSL server PEM file", true);
                  }
                | CLIENTPEMFILE ':' PATH {
                        _setPEM(&(sslset.clientpemfile), $3, "SSL client PEM file", true);
                  }
                | CACERTIFICATEFILE ':' PATH {
                        _setPEM(&(sslset.CACertificateFile), $3, "SSL CA certificates file", true);
                  }
                | CACERTIFICATEPATH ':' PATH {
                        _setPEM(&(sslset.CACertificatePath), $3, "SSL CA certificates directory", false);
                  }
                ;

sslexpire       : CERTIFICATE VALID expireoperator NUMBER DAY {
                        sslset.flags = SSL_Enabled;
                        portset.target.net.ssl.certificate.minimumDays = $<number>4;
                  }
                ;

expireoperator  : /* EMPTY */
                | GREATER
                ;

sslchecksum     : CERTIFICATE CHECKSUM checksumoperator STRING {
                        sslset.flags = SSL_Enabled;
                        sslset.checksum = $<string>4;
                        switch (cleanup_hash_string(sslset.checksum)) {
                                case 32:
                                        sslset.checksumType = Hash_Md5;
                                        break;
                                case 40:
                                        sslset.checksumType = Hash_Sha1;
                                        break;
                                default:
                                        yyerror2("Unknown checksum type: [%s] is not MD5 nor SHA1", sslset.checksum);
                        }
                  }
                | CERTIFICATE CHECKSUM MD5HASH checksumoperator STRING {
                        sslset.flags = SSL_Enabled;
                        sslset.checksum = $<string>5;
                        if (cleanup_hash_string(sslset.checksum) != 32)
                                yyerror2("Unknown checksum type: [%s] is not MD5", sslset.checksum);
                        sslset.checksumType = Hash_Md5;
                  }
                | CERTIFICATE CHECKSUM SHA1HASH checksumoperator STRING {
                        sslset.flags = SSL_Enabled;
                        sslset.checksum = $<string>5;
                        if (cleanup_hash_string(sslset.checksum) != 40)
                                yyerror2("Unknown checksum type: [%s] is not SHA1", sslset.checksum);
                        sslset.checksumType = Hash_Sha1;
                  }
                ;

checksumoperator : /* EMPTY */
                 | EQUAL
                 ;

sslversion      : SSLV2 {
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_V2;
                  }
                | SSLV3 {
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_V3;
                  }
                | TLSV1 {
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_TLSV1;
                  }
                | TLSV11
                {
#ifndef HAVE_TLSV1_1
                        yyerror("Your SSL Library does not support TLS version 1.1");
#endif
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_TLSV11;
                }
                | TLSV12
                {
#ifndef HAVE_TLSV1_2
                        yyerror("Your SSL Library does not support TLS version 1.2");
#endif
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_TLSV12;
                }
                | TLSV13
                {
#ifndef HAVE_TLSV1_3
                        yyerror("Your SSL Library does not support TLS version 1.3");
#endif
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_TLSV13;
                }

                | SSLAUTO {
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_Auto;
                  }
                | AUTO {
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_Auto;
                  }
                ;

certmd5         : CERTMD5 STRING { // Backward compatibility
                        sslset.flags = SSL_Enabled;
                        sslset.checksum = $<string>2;
                        if (cleanup_hash_string(sslset.checksum) != 32)
                                yyerror2("Unknown checksum type: [%s] is not MD5", sslset.checksum);
                        sslset.checksumType = Hash_Md5;
                  }
                ;

setmailservers  : SET MAILSERVER mailserverlist nettimeout hostname {
                        if (($<number>4) > SMTP_TIMEOUT)
                                Run.mailserver_timeout = $<number>4;
                        Run.mail_hostname = $<string>5;
                  }
                ;

setmailformat   : SET MAILFORMAT '{' formatoptionlist '}' {
                        if (mailset.from) {
                                Run.MailFormat.from = mailset.from;
                        } else {
                                Run.MailFormat.from = Address_new();
                                Run.MailFormat.from->address = Str_dup(ALERT_FROM);
                        }
                        if (mailset.replyto)
                                Run.MailFormat.replyto = mailset.replyto;
                        Run.MailFormat.subject = mailset.subject ?  mailset.subject : Str_dup(ALERT_SUBJECT);
                        Run.MailFormat.message = mailset.message ?  mailset.message : Str_dup(ALERT_MESSAGE);
                        reset_mailset();
                  }
                ;

mailserverlist  : mailserver
                | mailserverlist mailserver
                ;

mailserver      : STRING mailserveroptlist {
                        /* Restore the current text overriden by lookahead */
                        FREE(argyytext);
                        argyytext = Str_dup($1);

                        mailserverset.host = $1;
                        mailserverset.port = PORT_SMTP;
                        addmailserver(&mailserverset);
                  }
                | STRING PORT NUMBER mailserveroptlist {
                        /* Restore the current text overriden by lookahead */
                        FREE(argyytext);
                        argyytext = Str_dup($1);

                        mailserverset.host = $1;
                        mailserverset.port = $<number>3;
                        addmailserver(&mailserverset);
                  }
                ;

mailserveroptlist : /* EMPTY */
                  | mailserveroptlist mailserveropt
                  ;

mailserveropt   : username {
                        mailserverset.username = $<string>1;
                  }
                | password {
                        mailserverset.password = $<string>1;
                  }
                | ssl
                | sslchecksum
                | sslversion
                | certmd5
                ;

sethttpd        : SET HTTPD httpdlist {
                        if (sslset.flags & SSL_Enabled) {
#ifdef HAVE_OPENSSL
                                if (! sslset.pemfile) {
                                        yyerror("SSL server PEM file is required (please use ssl pemfile option)");
                                } else if (! file_checkStat(sslset.pemfile, "SSL server PEM file", S_IRWXU)) {
                                        yyerror("SSL server PEM file permissions check failed");
                                } else  {
                                        _setSSLOptions(&(Run.httpd.socket.net.ssl));
                                }
#else
                                yyerror("SSL is not supported");
#endif
                        }
                  }
                ;

httpdlist       : /* EMPTY */
                | httpdlist httpdoption
                ;

httpdoption     : ssl
                | pemfile
                | clientpemfile
                | allowselfcert
                | signature
                | bindaddress
                | allow
                | httpdport
                | httpdsocket
                ;

/* deprecated by "ssl" options since monit 5.21 (kept for backward compatibility) */
pemfile         : PEMFILE PATH {
                        _setPEM(&(sslset.pemfile), $2, "SSL server PEM file", true);
                  }
                ;

/* deprecated by "ssl" options since monit 5.21 (kept for backward compatibility) */
clientpemfile   : CLIENTPEMFILE PATH {
                        _setPEM(&(sslset.clientpemfile), $2, "SSL client PEM file", true);
                  }
                ;

/* deprecated by "ssl" options since monit 5.21 (kept for backward compatibility) */
allowselfcert   : ALLOWSELFCERTIFICATION {
                        sslset.flags = SSL_Enabled;
                        sslset.allowSelfSigned = true;
                  }
                ;

httpdport       : PORT NUMBER {
                        Run.httpd.flags |= Httpd_Net;
                        Run.httpd.socket.net.port = $2;
                  }
                ;

httpdsocket     : UNIXSOCKET PATH httpdsocketoptionlist {
                        Run.httpd.flags |= Httpd_Unix;
                        Run.httpd.socket.unix.path = $2;
                  }
                ;

httpdsocketoptionlist : /* EMPTY */
                      | httpdsocketoptionlist httpdsocketoption
                      ;

httpdsocketoption : UID STRING {
                        Run.httpd.flags |= Httpd_UnixUid;
                        Run.httpd.socket.unix.uid = get_uid($2, 0);
                        FREE($2);
                    }
                  | GID STRING {
                        Run.httpd.flags |= Httpd_UnixGid;
                        Run.httpd.socket.unix.gid = get_gid($2, 0);
                        FREE($2);
                    }
                  | UID NUMBER {
                        Run.httpd.flags |= Httpd_UnixUid;
                        Run.httpd.socket.unix.uid = get_uid(NULL, $2);
                    }
                  | GID NUMBER {
                        Run.httpd.flags |= Httpd_UnixGid;
                        Run.httpd.socket.unix.gid = get_gid(NULL, $2);
                    }
                  | PERMISSION NUMBER {
                        Run.httpd.flags |= Httpd_UnixPermission;
                        Run.httpd.socket.unix.permission = check_perm($2);
                    }
                  ;

sigenable       : SIGNATURE ENABLE
                | ENABLE SIGNATURE
                ;

sigdisable      : SIGNATURE DISABLE
                | DISABLE SIGNATURE
                ;

signature       : sigenable  {
                        Run.httpd.flags |= Httpd_Signature;
                  }
                | sigdisable {
                        Run.httpd.flags &= ~Httpd_Signature;
                  }
                ;

bindaddress     : ADDRESS STRING {
                        Run.httpd.socket.net.address = $2;
                  }
                ;

allow           : ALLOW STRING':'STRING readonly {
                        addcredentials($2, $4, Digest_Cleartext, $<number>5);
                  }
                | ALLOW '@'STRING readonly {
#ifdef HAVE_LIBPAM
                        addpamauth($3, $<number>4);
#else
                        yyerror("PAM is not supported");
                        FREE($3);
#endif
                  }
                | ALLOW PATH {
                        addhtpasswdentry($2, NULL, Digest_Cleartext);
                        FREE($2);
                  }
                | ALLOW CLEARTEXT PATH {
                        addhtpasswdentry($3, NULL, Digest_Cleartext);
                        FREE($3);
                  }
                | ALLOW MD5HASH PATH {
                        addhtpasswdentry($3, NULL, Digest_Md5);
                        FREE($3);
                  }
                | ALLOW CRYPT PATH {
                        addhtpasswdentry($3, NULL, Digest_Crypt);
                        FREE($3);
                  }
                | ALLOW PATH {
                        htpasswd_file = $2;
                        digesttype = Digest_Cleartext;
                  }
                  allowuserlist {
                        FREE(htpasswd_file);
                  }
                | ALLOW CLEARTEXT PATH {
                        htpasswd_file = $3;
                        digesttype = Digest_Cleartext;
                  }
                  allowuserlist {
                        FREE(htpasswd_file);
                  }
                | ALLOW MD5HASH PATH {
                        htpasswd_file = $3;
                        digesttype = Digest_Md5;
                  }
                  allowuserlist {
                        FREE(htpasswd_file);
                  }
                | ALLOW CRYPT PATH {
                        htpasswd_file = $3;
                        digesttype = Digest_Crypt;
                  }
                  allowuserlist {
                        FREE(htpasswd_file);
                  }
                | ALLOW STRING {
                        if (! Engine_addAllow($2))
                                yywarning2("invalid allow option", $2);
                        FREE($2);
                  }
                ;

allowuserlist   : allowuser
                | allowuserlist allowuser
                ;

allowuser       : STRING {
                        addhtpasswdentry(htpasswd_file, $1, digesttype);
                        FREE($1);
                  }
                ;

readonly        : /* EMPTY */ {
                        $<number>$ = false;
                  }
                | READONLY {
                        $<number>$ = true;
                  }
                ;

checkproc       : CHECKPROC SERVICENAME PIDFILE PATH {
                        createservice(Service_Process, $<string>2, $4, check_process);
                  }
                | CHECKPROC SERVICENAME PATHTOK PATH {
                        createservice(Service_Process, $<string>2, $4, check_process);
                  }
                | CHECKPROC SERVICENAME MATCH STRING {
                        createservice(Service_Process, $<string>2, $4, check_process);
                        matchset.ignore = false;
                        matchset.match_path = NULL;
                        matchset.match_string = Str_dup($4);
                        addmatch(&matchset, Action_Ignored, 0);
                  }
                | CHECKPROC SERVICENAME MATCH PATH {
                        createservice(Service_Process, $<string>2, $4, check_process);
                        matchset.ignore = false;
                        matchset.match_path = NULL;
                        matchset.match_string = Str_dup($4);
                        addmatch(&matchset, Action_Ignored, 0);
                  }
                ;

checkfile       : CHECKFILE SERVICENAME PATHTOK PATH {
                        createservice(Service_File, $<string>2, $4, check_file);
                  }
                ;

checkfilesys    : CHECKFILESYS SERVICENAME PATHTOK PATH {
                        createservice(Service_Filesystem, $<string>2, $4, check_filesystem);
                  }
                | CHECKFILESYS SERVICENAME PATHTOK STRING {
                        createservice(Service_Filesystem, $<string>2, $4, check_filesystem);
                  }
                ;

checkdir        : CHECKDIR SERVICENAME PATHTOK PATH {
                        createservice(Service_Directory, $<string>2, $4, check_directory);
                  }
                ;

checkhost       : CHECKHOST SERVICENAME ADDRESS STRING {
                        createservice(Service_Host, $<string>2, $4, check_remote_host);
                  }
                ;

checknet        : CHECKNET SERVICENAME ADDRESS STRING {
                        if (Link_isGetByAddressSupported()) {
                                createservice(Service_Net, $<string>2, $4, check_net);
                                current->inf.net->stats = Link_createForAddress($4);
                        } else {
                                yyerror("Network monitoring by IP address is not supported on this platform, please use 'check network <foo> with interface <bar>' instead");
                        }
                  }
                | CHECKNET SERVICENAME INTERFACE STRING {
                        createservice(Service_Net, $<string>2, $4, check_net);
                        current->inf.net->stats = Link_createForInterface($4);
                  }
                ;

checksystem     : CHECKSYSTEM SERVICENAME {
                        char *servicename = $<string>2;
                        if (Str_sub(servicename, "$HOST")) {
                                char hostname[STRLEN];
                                if (gethostname(hostname, sizeof(hostname))) {
                                        LogError("System hostname error -- %s\n", STRERROR);
                                        cfg_errflag++;
                                } else {
                                        Util_replaceString(&servicename, "$HOST", hostname);
                                }
                        }
                        Run.system = createservice(Service_System, servicename, NULL, check_system); // The name given in the 'check system' statement overrides system hostname
                  }
                ;

checkfifo       : CHECKFIFO SERVICENAME PATHTOK PATH {
                        createservice(Service_Fifo, $<string>2, $4, check_fifo);
                  }
                ;

checkprogram    : CHECKPROGRAM SERVICENAME PATHTOK argumentlist programtimeout {
                        command_t c = command; // Current command
                        check_exec(c->arg[0]);
                        createservice(Service_Program, $<string>2, NULL, check_program);
                        current->program->timeout = $<number>5;
                        current->program->lastOutput = StringBuffer_create(64);
                        current->program->inprogressOutput = StringBuffer_create(64);
                 }
                | CHECKPROGRAM SERVICENAME PATHTOK argumentlist useroptionlist programtimeout {
                        command_t c = command; // Current command
                        check_exec(c->arg[0]);
                        createservice(Service_Program, $<string>2, NULL, check_program);
                        current->program->timeout = $<number>6;
                        current->program->lastOutput = StringBuffer_create(64);
                        current->program->inprogressOutput = StringBuffer_create(64);
                 }
                ;

start           : START argumentlist starttimeout {
                        addcommand(START, $<number>3);
                  }
                | START argumentlist useroptionlist starttimeout {
                        addcommand(START, $<number>4);
                  }
                ;

stop            : STOP argumentlist stoptimeout {
                        addcommand(STOP, $<number>3);
                  }
                | STOP argumentlist useroptionlist stoptimeout {
                        addcommand(STOP, $<number>4);
                  }
                ;


restart         : RESTART argumentlist restarttimeout {
                        addcommand(RESTART, $<number>3);
                  }
                | RESTART argumentlist useroptionlist restarttimeout {
                        addcommand(RESTART, $<number>4);
                  }
                ;

argumentlist    : argument
                | argumentlist argument
                ;

useroptionlist  : useroption
                | useroptionlist useroption
                ;

argument        : STRING {
                        addargument($1);
                  }
                | PATH {
                        addargument($1);
                  }
                ;

useroption      : UID STRING {
                        addeuid(get_uid($2, 0));
                        FREE($2);
                  }
                | GID STRING {
                        addegid(get_gid($2, 0));
                        FREE($2);
                  }
                | UID NUMBER {
                        addeuid(get_uid(NULL, $2));
                  }
                | GID NUMBER {
                        addegid(get_gid(NULL, $2));
                  }
                ;

username        : USERNAME MAILADDR {
                        $<string>$ = $2;
                  }
                | USERNAME STRING {
                        $<string>$ = $2;
                  }
                ;

password        : PASSWORD STRING {
                        $<string>$ = $2;
                  }
                ;

hostname        : /* EMPTY */     {
                        $<string>$ = NULL;
                  }
                | HOSTNAME STRING {
                        $<string>$ = $2;
                  }
                ;

connection      : IF FAILED host port connectionoptlist rate1 THEN action1 recovery {
                        /* This is a workaround to support content match without having to create an URL object. 'urloption' creates the Request_T object we need minus the URL object, but with enough information to perform content test.
                           TODO: Parser is in need of refactoring */
                        portset.url_request = urlrequest;
                        addeventaction(&(portset).action, $<number>8, $<number>9);
                        addport(&(current->portlist), &portset);
                  }
                ;

connectionoptlist : /* EMPTY */
                | connectionoptlist connectionopt
                ;

connectionopt   : ip
                | type
                | protocol
                | sendexpect
                | urloption
                | connectiontimeout
                | outgoing
                | retry
                | ssl
                | sslchecksum
                | sslexpire
                ;

connectionurl   : IF FAILED URL URLOBJECT connectionurloptlist rate1 THEN action1 recovery {
                        prepare_urlrequest($<url>4);
                        addeventaction(&(portset).action, $<number>8, $<number>9);
                        addport(&(current->portlist), &portset);
                  }
                ;

connectionurloptlist : /* EMPTY */
                | connectionurloptlist connectionurlopt
                ;

connectionurlopt : urloption
                 | connectiontimeout
                 | retry
                 | ssl
                 | sslchecksum
                 | sslexpire
                 ;

connectionunix  : IF FAILED unixsocket connectionuxoptlist rate1 THEN action1 recovery {
                        addeventaction(&(portset).action, $<number>7, $<number>8);
                        addport(&(current->socketlist), &portset);
                  }
                ;

connectionuxoptlist : /* EMPTY */
                | connectionuxoptlist connectionuxopt
                ;

connectionuxopt : type
                | protocol
                | sendexpect
                | connectiontimeout
                | retry
                ;

icmp            : IF FAILED ICMP icmptype icmpoptlist rate1 THEN action1 recovery {
                        icmpset.family = Socket_Ip;
                        icmpset.type = $<number>4;
                        addeventaction(&(icmpset).action, $<number>8, $<number>9);
                        addicmp(&icmpset);
                  }
                | IF FAILED PING icmpoptlist rate1 THEN action1 recovery {
                        icmpset.family = Socket_Ip;
                        addeventaction(&(icmpset).action, $<number>7, $<number>8);
                        addicmp(&icmpset);
                 }
                | IF FAILED PING4 icmpoptlist rate1 THEN action1 recovery {
                        icmpset.family = Socket_Ip4;
                        addeventaction(&(icmpset).action, $<number>7, $<number>8);
                        addicmp(&icmpset);
                 }
                | IF FAILED PING6 icmpoptlist rate1 THEN action1 recovery {
                        icmpset.family = Socket_Ip6;
                        addeventaction(&(icmpset).action, $<number>7, $<number>8);
                        addicmp(&icmpset);
                 }
                ;

icmpoptlist     : /* EMPTY */
                | icmpoptlist icmpopt
                ;

icmpopt         : icmpcount
                | icmpsize
                | icmptimeout
                | icmpoutgoing
                ;

host            : /* EMPTY */ {
                        portset.hostname = Str_dup(current->type == Service_Host ? current->path : LOCALHOST);
                  }
                | HOST STRING {
                        portset.hostname = $2;
                  }
                ;

port            : PORT NUMBER {
                        portset.target.net.port = $2;
                  }
                ;

unixsocket      : UNIXSOCKET PATH {
                        portset.family = Socket_Unix;
                        portset.target.unix.pathname = $2;
                  }
                ;

ip              : IPV4 {
                        portset.family = Socket_Ip4;
                  }
                | IPV6 {
                        portset.family = Socket_Ip6;
                  }
                ;

type            : TYPE TCP {
                        portset.type = Socket_Tcp;
                  }
                | TYPE TCPSSL typeoptlist { // The typelist is kept for backward compatibility (replaced by ssloptionlist)
                        portset.type = Socket_Tcp;
                        sslset.flags = SSL_Enabled;
                  }
                | TYPE UDP {
                        portset.type = Socket_Udp;
                  }
                ;

typeoptlist     : /* EMPTY */
                | typeoptlist typeopt
                ;

typeopt         : sslversion
                | certmd5
                ;

outgoing        : ADDRESS STRING {
                        _parseOutgoingAddress($<string>2, &(portset.outgoing));
                  }
                ;

protocol        : PROTOCOL APACHESTATUS apache_stat_list {
                        portset.protocol = Protocol_get(Protocol_APACHESTATUS);
                  }
                | PROTOCOL DEFAULT {
                        portset.protocol = Protocol_get(Protocol_DEFAULT);
                  }
                | PROTOCOL DNS {
                        portset.protocol = Protocol_get(Protocol_DNS);
                  }
                | PROTOCOL DWP  {
                        portset.protocol = Protocol_get(Protocol_DWP);
                  }
                | PROTOCOL FAIL2BAN {
                        portset.protocol = Protocol_get(Protocol_FAIL2BAN);
                }
                | PROTOCOL FTP {
                        portset.protocol = Protocol_get(Protocol_FTP);
                  }
                | PROTOCOL HTTP httplist {
                        portset.protocol = Protocol_get(Protocol_HTTP);
                  }
                | PROTOCOL HTTPS httplist {
                        sslset.flags = SSL_Enabled;
                        portset.type = Socket_Tcp;
                        portset.protocol = Protocol_get(Protocol_HTTP);
                 }
                | PROTOCOL IMAP {
                        portset.protocol = Protocol_get(Protocol_IMAP);
                  }
                | PROTOCOL IMAPS {
                        sslset.flags = SSL_Enabled;
                        portset.type = Socket_Tcp;
                        portset.protocol = Protocol_get(Protocol_IMAP);
                  }
                | PROTOCOL CLAMAV {
                        portset.protocol = Protocol_get(Protocol_CLAMAV);
                  }
                | PROTOCOL LDAP2 {
                        portset.protocol = Protocol_get(Protocol_LDAP2);
                  }
                | PROTOCOL LDAP3 {
                        portset.protocol = Protocol_get(Protocol_LDAP3);
                  }
                | PROTOCOL MONGODB  {
                        portset.protocol = Protocol_get(Protocol_MONGODB);
                  }
                | PROTOCOL MYSQL mysqllist {
                        portset.protocol = Protocol_get(Protocol_MYSQL);
                  }
                | PROTOCOL SIP siplist {
                        portset.protocol = Protocol_get(Protocol_SIP);
                  }
                | PROTOCOL NNTP {
                        portset.protocol = Protocol_get(Protocol_NNTP);
                  }
                | PROTOCOL NTP3  {
                        portset.protocol = Protocol_get(Protocol_NTP3);
                        portset.type = Socket_Udp;
                  }
                | PROTOCOL POSTFIXPOLICY {
                        portset.protocol = Protocol_get(Protocol_POSTFIXPOLICY);
                  }
                | PROTOCOL POP {
                        portset.protocol = Protocol_get(Protocol_POP);
                  }
                | PROTOCOL POPS {
                        sslset.flags = SSL_Enabled;
                        portset.type = Socket_Tcp;
                        portset.protocol = Protocol_get(Protocol_POP);
                  }
                | PROTOCOL SIEVE {
                        portset.protocol = Protocol_get(Protocol_SIEVE);
                  }
                | PROTOCOL SMTP smtplist {
                        portset.protocol = Protocol_get(Protocol_SMTP);
                  }
                | PROTOCOL SMTPS smtplist {
                        sslset.flags = SSL_Enabled;
                        portset.type = Socket_Tcp;
                        portset.protocol = Protocol_get(Protocol_SMTP);
                 }
                | PROTOCOL SPAMASSASSIN {
                        portset.protocol = Protocol_get(Protocol_SPAMASSASSIN);
                  }
                | PROTOCOL SSH  {
                        portset.protocol = Protocol_get(Protocol_SSH);
                  }
                | PROTOCOL RDATE {
                        portset.protocol = Protocol_get(Protocol_RDATE);
                  }
                | PROTOCOL REDIS  {
                        portset.protocol = Protocol_get(Protocol_REDIS);
                  }
                | PROTOCOL RSYNC {
                        portset.protocol = Protocol_get(Protocol_RSYNC);
                  }
                | PROTOCOL TNS {
                        portset.protocol = Protocol_get(Protocol_TNS);
                  }
                | PROTOCOL PGSQL {
                        portset.protocol = Protocol_get(Protocol_PGSQL);
                  }
                | PROTOCOL LMTP {
                        portset.protocol = Protocol_get(Protocol_LMTP);
                  }
                | PROTOCOL GPS {
                        portset.protocol = Protocol_get(Protocol_GPS);
                  }
                | PROTOCOL RADIUS radiuslist {
                        portset.protocol = Protocol_get(Protocol_RADIUS);
                  }
                | PROTOCOL MEMCACHE {
                        portset.protocol = Protocol_get(Protocol_MEMCACHE);
                  }
                | PROTOCOL WEBSOCKET websocketlist {
                        portset.protocol = Protocol_get(Protocol_WEBSOCKET);
                  }
                ;

sendexpect      : SEND STRING {
                        if (portset.protocol->check == check_default || portset.protocol->check == check_generic) {
                                portset.protocol = Protocol_get(Protocol_GENERIC);
                                addgeneric(&portset, $2, NULL);
                        } else {
                                yyerror("The SEND statement is not allowed in the %s protocol context", portset.protocol->name);
                        }
                  }
                | EXPECT STRING {
                        if (portset.protocol->check == check_default || portset.protocol->check == check_generic) {
                                portset.protocol = Protocol_get(Protocol_GENERIC);
                                addgeneric(&portset, NULL, $2);
                        } else {
                                yyerror("The EXPECT statement is not allowed in the %s protocol context", portset.protocol->name);
                        }
                  }
                ;

websocketlist   : websocket
                | websocketlist websocket
                ;

websocket       : ORIGIN STRING {
                        portset.parameters.websocket.origin = $<string>2;
                  }
                | REQUEST PATH {
                        portset.parameters.websocket.request = $<string>2;
                  }
                | HOST STRING {
                        portset.parameters.websocket.host = $<string>2;
                  }
                | VERSIONOPT NUMBER {
                        portset.parameters.websocket.version = $<number>2;
                  }
                ;

smtplist        : /* EMPTY */
                | smtplist smtp
                ;

smtp            : username {
                        portset.parameters.smtp.username = $<string>1;
                  }
                | password {
                        portset.parameters.smtp.password = $<string>1;
                  }
                ;

mysqllist       : /* EMPTY */
                | mysqllist mysql
                ;

mysql           : username {
                        if ($<string>1) {
                                if (strlen($<string>1) > 16)
                                        yyerror2("Username too long -- Maximum MySQL username length is 16 characters");
                                else
                                        portset.parameters.mysql.username = $<string>1;
                        }
                  }
                | password {
                        portset.parameters.mysql.password = $<string>1;
                  }
                ;

target          : TARGET MAILADDR {
                        $<string>$ = $2;
                  }
                | TARGET STRING {
                        $<string>$ = $2;
                  }
                ;

maxforward      : MAXFORWARD NUMBER {
                        $<number>$ = verifyMaxForward($2);
                  }
                ;

siplist         : /* EMPTY */
                | siplist sip
                ;

sip             : target {
                        portset.parameters.sip.target = $<string>1;
                  }
                | maxforward {
                        portset.parameters.sip.maxforward = $<number>1;
                  }
                ;

httplist        : /* EMPTY */
                | httplist http
                ;

http            : username {
                        portset.parameters.http.username = $<string>1;
                  }
                | password {
                        portset.parameters.http.password = $<string>1;
                  }
                | request
                | responsesum
                | status
                | method
                | hostheader
                | '[' httpheaderlist ']'
                ;

status          : STATUS operator NUMBER {
                        if ($<number>3 < 0) {
                                yyerror2("The status value must be greater or equal to 0");
                        }
                        portset.parameters.http.operator = $<number>2;
                        portset.parameters.http.status = $<number>3;
                        portset.parameters.http.hasStatus = true;
                  }
                ;

method          : METHOD GET {
                        portset.parameters.http.method = Http_Get;
                  }
                | METHOD HEAD {
                        portset.parameters.http.method = Http_Head;
                  }
                ;

request         : REQUEST PATH {
                        portset.parameters.http.request = Util_urlEncode($2, false);
                        FREE($2);
                  }
                | REQUEST STRING {
                        portset.parameters.http.request = Util_urlEncode($2, false);
                        FREE($2);
                  }
                ;

responsesum     : CHECKSUM STRING {
                        portset.parameters.http.checksum = $2;
                  }
                ;

hostheader      : HOSTHEADER STRING {
                        addhttpheader(&portset, Str_cat("Host:%s", $2));
                        FREE($2);
                  }
                ;

httpheaderlist  : /* EMPTY */
                | httpheaderlist HTTPHEADER {
                        addhttpheader(&portset, $2);
                 }
                ;

secret          : SECRET STRING {
                        $<string>$ = $2;
                  }
                ;

radiuslist      : /* EMPTY */
                | radiuslist radius
                ;

radius          : secret {
                        portset.parameters.radius.secret = $<string>1;
                  }
                ;

apache_stat_list: apache_stat
                | apache_stat_list apache_stat
                ;

apache_stat     : username {
                        portset.parameters.apachestatus.username = $<string>1;
                  }
                | password {
                        portset.parameters.apachestatus.password = $<string>1;
                  }
                | PATHTOK PATH {
                        portset.parameters.apachestatus.path = $<string>2;
                  }
                | LOGLIMIT operator NUMBER PERCENT {
                        portset.parameters.apachestatus.loglimitOP = $<number>2;
                        portset.parameters.apachestatus.loglimit = $<number>3;
                  }
                | CLOSELIMIT operator NUMBER PERCENT {
                        portset.parameters.apachestatus.closelimitOP = $<number>2;
                        portset.parameters.apachestatus.closelimit = $<number>3;
                  }
                | DNSLIMIT operator NUMBER PERCENT {
                        portset.parameters.apachestatus.dnslimitOP = $<number>2;
                        portset.parameters.apachestatus.dnslimit = $<number>3;
                  }
                | KEEPALIVELIMIT operator NUMBER PERCENT {
                        portset.parameters.apachestatus.keepalivelimitOP = $<number>2;
                        portset.parameters.apachestatus.keepalivelimit = $<number>3;
                  }
                | REPLYLIMIT operator NUMBER PERCENT {
                        portset.parameters.apachestatus.replylimitOP = $<number>2;
                        portset.parameters.apachestatus.replylimit = $<number>3;
                  }
                | REQUESTLIMIT operator NUMBER PERCENT {
                        portset.parameters.apachestatus.requestlimitOP = $<number>2;
                        portset.parameters.apachestatus.requestlimit = $<number>3;
                  }
                | STARTLIMIT operator NUMBER PERCENT {
                        portset.parameters.apachestatus.startlimitOP = $<number>2;
                        portset.parameters.apachestatus.startlimit = $<number>3;
                  }
                | WAITLIMIT operator NUMBER PERCENT {
                        portset.parameters.apachestatus.waitlimitOP = $<number>2;
                        portset.parameters.apachestatus.waitlimit = $<number>3;
                  }
                | GRACEFULLIMIT operator NUMBER PERCENT {
                        portset.parameters.apachestatus.gracefullimitOP = $<number>2;
                        portset.parameters.apachestatus.gracefullimit = $<number>3;
                  }
                | CLEANUPLIMIT operator NUMBER PERCENT {
                        portset.parameters.apachestatus.cleanuplimitOP = $<number>2;
                        portset.parameters.apachestatus.cleanuplimit = $<number>3;
                  }
                ;

exist           : IF NOT EXIST rate1 THEN action1 recovery {
                        addeventaction(&(nonexistset).action, $<number>6, $<number>7);
                        addnonexist(&nonexistset);
                  }
                | IF EXIST rate1 THEN action1 recovery {
                        addeventaction(&(existset).action, $<number>5, $<number>6);
                        addexist(&existset);
                  }
                ;


pid             : IF CHANGED PID rate1 THEN action1 {
                        addeventaction(&(pidset).action, $<number>6, Action_Ignored);
                        addpid(&pidset);
                  }
                ;

ppid            : IF CHANGED PPID rate1 THEN action1 {
                        addeventaction(&(ppidset).action, $<number>6, Action_Ignored);
                        addppid(&ppidset);
                  }
                ;

uptime          : IF UPTIME operator NUMBER time rate1 THEN action1 recovery {
                        uptimeset.operator = $<number>3;
                        uptimeset.uptime = ((unsigned long long)$4 * $<number>5);
                        addeventaction(&(uptimeset).action, $<number>8, $<number>9);
                        adduptime(&uptimeset);
                  }

icmpcount       : COUNT NUMBER {
                        icmpset.count = $<number>2;
                 }
                ;

icmpsize        : SIZE NUMBER {
                        icmpset.size = $<number>2;
                        if (icmpset.size < 8) {
                                yyerror2("The minimum ping size is 8 bytes");
                        } else if (icmpset.size > 1492) {
                                yyerror2("The maximum ping size is 1492 bytes");
                        }
                 }
                ;

icmptimeout     : TIMEOUT NUMBER SECOND {
                        icmpset.timeout = $<number>2 * 1000; // timeout is in milliseconds internally
                    }
                  ;

icmpoutgoing    : ADDRESS STRING {
                        _parseOutgoingAddress($<string>2, &(icmpset.outgoing));
                  }
                ;

stoptimeout     : /* EMPTY */ {
                        $<number>$ = Run.limits.stopTimeout;
                  }
                | TIMEOUT NUMBER SECOND {
                        $<number>$ = $2 * 1000; // milliseconds internally
                  }
                ;

starttimeout    : /* EMPTY */ {
                        $<number>$ = Run.limits.startTimeout;
                  }
                | TIMEOUT NUMBER SECOND {
                        $<number>$ = $2 * 1000; // milliseconds internally
                  }
                ;

restarttimeout  : /* EMPTY */ {
                        $<number>$ = Run.limits.restartTimeout;
                  }
                | TIMEOUT NUMBER SECOND {
                        $<number>$ = $2 * 1000; // milliseconds internally
                  }
                ;

programtimeout  : /* EMPTY */ {
                        $<number>$ = Run.limits.programTimeout;
                  }
                | TIMEOUT NUMBER SECOND {
                        $<number>$ = $2 * 1000; // milliseconds internally
                  }
                ;

nettimeout      : /* EMPTY */ {
                        $<number>$ = Run.limits.networkTimeout;
                  }
                | TIMEOUT NUMBER SECOND {
                        $<number>$ = $2 * 1000; // net timeout is in milliseconds internally
                  }
                ;

connectiontimeout : TIMEOUT NUMBER SECOND {
                        portset.timeout = $<number>2 * 1000; // timeout is in milliseconds internally
                    }
                  ;

retry           : RETRY NUMBER {
                        portset.retry = $2;
                  }
                ;

actionrate      : IF NUMBER RESTART NUMBER CYCLE THEN action1 {
                        actionrateset.count = $2;
                        actionrateset.cycle = $4;
                        addeventaction(&(actionrateset).action, $<number>7, Action_Alert);
                        addactionrate(&actionrateset);
                  }
                | IF NUMBER RESTART NUMBER CYCLE THEN TIMEOUT {
                        actionrateset.count = $2;
                        actionrateset.cycle = $4;
                        addeventaction(&(actionrateset).action, Action_Unmonitor, Action_Alert);
                        addactionrate(&actionrateset);
                  }
                ;

urloption       : CONTENT urloperator STRING {
                        seturlrequest($<number>2, $<string>3);
                        FREE($3);
                  }
                ;

urloperator     : EQUAL    { $<number>$ = Operator_Equal; }
                | NOTEQUAL { $<number>$ = Operator_NotEqual; }
                ;

alert           : alertmail formatlist reminder {
                        mailset.events = Event_All;
                        addmail($<string>1, &mailset, &current->maillist);
                  }
                | alertmail '{' eventoptionlist '}' formatlist reminder {
                        addmail($<string>1, &mailset, &current->maillist);
                  }
                | alertmail NOT '{' eventoptionlist '}' formatlist reminder {
                        mailset.events = ~mailset.events;
                        addmail($<string>1, &mailset, &current->maillist);
                  }
                | noalertmail {
                        addmail($<string>1, &mailset, &current->maillist);
                  }
                ;

alertmail       : ALERT MAILADDR { $<string>$ = $2; }
                ;

noalertmail     : NOALERT MAILADDR { $<string>$ = $2; }
                ;

eventoptionlist : eventoption
                | eventoptionlist eventoption
                ;

eventoption     : ACTION          { mailset.events |= Event_Action; }
                | BYTEIN          { mailset.events |= Event_ByteIn; }
                | BYTEOUT         { mailset.events |= Event_ByteOut; }
                | CHECKSUM        { mailset.events |= Event_Checksum; }
                | CONNECTION      { mailset.events |= Event_Connection; }
                | CONTENT         { mailset.events |= Event_Content; }
                | DATA            { mailset.events |= Event_Data; }
                | EXEC            { mailset.events |= Event_Exec; }
                | EXIST           { mailset.events |= Event_Exist; }
                | FSFLAG          { mailset.events |= Event_FsFlag; }
                | GID             { mailset.events |= Event_Gid; }
                | ICMP            { mailset.events |= Event_Icmp; }
                | INSTANCE        { mailset.events |= Event_Instance; }
                | INVALID         { mailset.events |= Event_Invalid; }
                | LINK            { mailset.events |= Event_Link; }
                | NONEXIST        { mailset.events |= Event_NonExist; }
                | PACKETIN        { mailset.events |= Event_PacketIn; }
                | PACKETOUT       { mailset.events |= Event_PacketOut; }
                | PERMISSION      { mailset.events |= Event_Permission; }
                | PID             { mailset.events |= Event_Pid; }
                | PPID            { mailset.events |= Event_PPid; }
                | RESOURCE        { mailset.events |= Event_Resource; }
                | SATURATION      { mailset.events |= Event_Saturation; }
                | SIZE            { mailset.events |= Event_Size; }
                | SPEED           { mailset.events |= Event_Speed; }
                | STATUS          { mailset.events |= Event_Status; }
                | TIMEOUT         { mailset.events |= Event_Timeout; }
                | TIME            { mailset.events |= Event_Timestamp; }
                | UID             { mailset.events |= Event_Uid; }
                | UPTIME          { mailset.events |= Event_Uptime; }
                ;

formatlist      : /* EMPTY */
                | MAILFORMAT '{' formatoptionlist '}'
                ;

formatoptionlist: formatoption
                | formatoptionlist formatoption
                ;

formatoption    : MAILFROM ADDRESSOBJECT { mailset.from = $<address>1; }
                | MAILREPLYTO ADDRESSOBJECT { mailset.replyto = $<address>1; }
                | MAILSUBJECT { mailset.subject = $1; }
                | MAILBODY { mailset.message = $1; }
                ;

every           : EVERY NUMBER CYCLE {
                        current->every.type = Every_SkipCycles;
                        current->every.spec.cycle.counter = current->every.spec.cycle.number = $2;
                 }
                | EVERY TIMESPEC {
                        current->every.type = Every_Cron;
                        current->every.spec.cron = $2;
                 }
                | NOTEVERY TIMESPEC {
                        current->every.type = Every_NotInCron;
                        current->every.spec.cron = $2;
                 }
                ;

mode            : MODE ACTIVE {
                        current->mode = Monitor_Active;
                  }
                | MODE PASSIVE {
                        current->mode = Monitor_Passive;
                  }
                | MODE MANUAL {
                        // Deprecated since monit 5.18
                        current->onreboot = Onreboot_Laststate;
                  }
                ;

onreboot        : ONREBOOT START {
                        current->onreboot = Onreboot_Start;
                  }
                | ONREBOOT NOSTART {
                        current->onreboot = Onreboot_Nostart;
                        current->monitor = Monitor_Not;
                  }
                | ONREBOOT LASTSTATE {
                        current->onreboot = Onreboot_Laststate;
                  }
                ;

group           : GROUP STRINGNAME {
                        addservicegroup($2);
                        FREE($2);
                  }
                ;


depend          : DEPENDS dependlist
                ;

dependlist      : dependant
                | dependlist dependant
                ;

dependant       : SERVICENAME { adddependant($<string>1); }
                ;

statusvalue     : IF STATUS operator NUMBER rate1 THEN action1 recovery {
                        statusset.initialized = true;
                        statusset.operator = $<number>3;
                        statusset.return_value = $<number>4;
                        addeventaction(&(statusset).action, $<number>7, $<number>8);
                        addstatus(&statusset);
                   }
                | IF CHANGED STATUS rate1 THEN action1 {
                        statusset.initialized = false;
                        statusset.operator = Operator_Changed;
                        statusset.return_value = 0;
                        addeventaction(&(statusset).action, $<number>6, Action_Ignored);
                        addstatus(&statusset);
                   }
                ;

resourceprocess : IF resourceprocesslist rate1 THEN action1 recovery {
                        addeventaction(&(resourceset).action, $<number>5, $<number>6);
                        addresource(&resourceset);
                   }
                ;

resourceprocesslist : resourceprocessopt
                    | resourceprocesslist resourceprocessopt
                    ;

resourceprocessopt  : resourcecpuproc
                    | resourcememproc
                    | resourcethreads
                    | resourcechild
                    | resourceload
                    | resourceread
                    | resourcewrite
                    ;

resourcesystem  : IF resourcesystemlist rate1 THEN action1 recovery {
                        addeventaction(&(resourceset).action, $<number>5, $<number>6);
                        addresource(&resourceset);
                   }
                ;

resourcesystemlist : resourcesystemopt
                   | resourcesystemlist resourcesystemopt
                   ;

resourcesystemopt  : resourceload
                   | resourcemem
                   | resourceswap
                   | resourcecpu
                   ;

resourcecpuproc : CPU operator value PERCENT {
                        resourceset.resource_id = Resource_CpuPercent;
                        resourceset.operator = $<number>2;
                        resourceset.limit = $<real>3;
                  }
                | TOTALCPU operator value PERCENT {
                        resourceset.resource_id = Resource_CpuPercentTotal;
                        resourceset.operator = $<number>2;
                        resourceset.limit = $<real>3;
                  }
                ;

resourcecpu     : resourcecpuid operator value PERCENT {
                        resourceset.resource_id = $<number>1;
                        resourceset.operator = $<number>2;
                        resourceset.limit = $<real>3;
                  }
                ;

resourcecpuid   : CPUUSER   { $<number>$ = Resource_CpuUser; }
                | CPUSYSTEM { $<number>$ = Resource_CpuSystem; }
                | CPUWAIT   { $<number>$ = Resource_CpuWait; }
                | CPU       { $<number>$ = Resource_CpuPercent; }
                ;

resourcemem     : MEMORY operator value unit {
                        resourceset.resource_id = Resource_MemoryKbyte;
                        resourceset.operator = $<number>2;
                        resourceset.limit = $<real>3 * $<number>4;
                  }
                | MEMORY operator value PERCENT {
                        resourceset.resource_id = Resource_MemoryPercent;
                        resourceset.operator = $<number>2;
                        resourceset.limit = $<real>3;
                  }
                ;

resourcememproc : MEMORY operator value unit {
                        resourceset.resource_id = Resource_MemoryKbyte;
                        resourceset.operator = $<number>2;
                        resourceset.limit = $<real>3 * $<number>4;
                  }
                | MEMORY operator value PERCENT {
                        resourceset.resource_id = Resource_MemoryPercent;
                        resourceset.operator = $<number>2;
                        resourceset.limit = $<real>3;
                  }
                | TOTALMEMORY operator value unit {
                        resourceset.resource_id = Resource_MemoryKbyteTotal;
                        resourceset.operator = $<number>2;
                        resourceset.limit = $<real>3 * $<number>4;
                  }
                | TOTALMEMORY operator value PERCENT  {
                        resourceset.resource_id = Resource_MemoryPercentTotal;
                        resourceset.operator = $<number>2;
                        resourceset.limit = $<real>3;
                  }
                ;

resourceswap    : SWAP operator value unit {
                        resourceset.resource_id = Resource_SwapKbyte;
                        resourceset.operator = $<number>2;
                        resourceset.limit = $<real>3 * $<number>4;
                  }
                | SWAP operator value PERCENT {
                        resourceset.resource_id = Resource_SwapPercent;
                        resourceset.operator = $<number>2;
                        resourceset.limit = $<real>3;
                  }
                ;

resourcethreads : THREADS operator NUMBER {
                        resourceset.resource_id = Resource_Threads;
                        resourceset.operator = $<number>2;
                        resourceset.limit = $<number>3;
                  }
                ;

resourcechild   : CHILDREN operator NUMBER {
                        resourceset.resource_id = Resource_Children;
                        resourceset.operator = $<number>2;
                        resourceset.limit = $<number>3;
                  }
                ;

resourceload    : resourceloadavg operator value {
                        resourceset.resource_id = $<number>1;
                        resourceset.operator = $<number>2;
                        resourceset.limit = $<real>3;
                  }
                ;

resourceloadavg : LOADAVG1  { $<number>$ = Resource_LoadAverage1m; }
                | LOADAVG5  { $<number>$ = Resource_LoadAverage5m; }
                | LOADAVG15 { $<number>$ = Resource_LoadAverage15m; }
                ;

resourceread    : DISK READ operator value unit currenttime {
                        resourceset.resource_id = Resource_ReadBytes;
                        resourceset.operator = $<number>3;
                        resourceset.limit = $<real>4 * $<number>5;
                  }
                | DISK READ operator NUMBER OPERATION {
                        resourceset.resource_id = Resource_ReadOperations;
                        resourceset.operator = $<number>3;
                        resourceset.limit = $<number>4;
                  }
                ;

resourcewrite   : DISK WRITE operator value unit currenttime {
                        resourceset.resource_id = Resource_WriteBytes;
                        resourceset.operator = $<number>3;
                        resourceset.limit = $<real>4 * $<number>5;
                  }
                | DISK WRITE operator NUMBER OPERATION {
                        resourceset.resource_id = Resource_WriteOperations;
                        resourceset.operator = $<number>3;
                        resourceset.limit = $<number>4;
                  }
                ;

value           : REAL { $<real>$ = $1; }
                | NUMBER { $<real>$ = (float) $1; }
                ;

timestamptype   : TIME  { $<number>$ = Timestamp_Default; }
                | ATIME { $<number>$ = Timestamp_Access; }
                | CTIME { $<number>$ = Timestamp_Change; }
                | MTIME { $<number>$ = Timestamp_Modification; }
                ;

timestamp       : IF timestamptype operator NUMBER time rate1 THEN action1 recovery {
                        timestampset.type = $<number>2;
                        timestampset.operator = $<number>3;
                        timestampset.time = ($4 * $<number>5);
                        addeventaction(&(timestampset).action, $<number>8, $<number>9);
                        addtimestamp(&timestampset);
                  }
                | IF CHANGED timestamptype rate1 THEN action1 {
                        timestampset.type = $<number>3;
                        timestampset.test_changes = true;
                        addeventaction(&(timestampset).action, $<number>6, Action_Ignored);
                        addtimestamp(&timestampset);
                  }
                ;

operator        : /* EMPTY */    { $<number>$ = Operator_Equal; }
                | GREATER        { $<number>$ = Operator_Greater; }
                | GREATEROREQUAL { $<number>$ = Operator_GreaterOrEqual; }
                | LESS           { $<number>$ = Operator_Less; }
                | LESSOREQUAL    { $<number>$ = Operator_LessOrEqual; }
                | EQUAL          { $<number>$ = Operator_Equal; }
                | NOTEQUAL       { $<number>$ = Operator_NotEqual; }
                | CHANGED        { $<number>$ = Operator_Changed; }
                ;

time            : /* EMPTY */ { $<number>$ = Time_Second; }
                | SECOND      { $<number>$ = Time_Second; }
                | MINUTE      { $<number>$ = Time_Minute; }
                | HOUR        { $<number>$ = Time_Hour; }
                | DAY         { $<number>$ = Time_Day; }
                | MONTH       { $<number>$ = Time_Month; }
                ;

totaltime       : MINUTE      { $<number>$ = Time_Minute; }
                | HOUR        { $<number>$ = Time_Hour; }
                | DAY         { $<number>$ = Time_Day; }

currenttime     : /* EMPTY */ { $<number>$ = Time_Second; }
                | SECOND      { $<number>$ = Time_Second; }

repeat          : /* EMPTY */ {
                        repeat = 0;
                  }
                | REPEAT EVERY CYCLE {
                        repeat = 1;
                  }
                | REPEAT EVERY NUMBER CYCLE {
                        if ($<number>3 < 0) {
                                yyerror2("The number of repeat cycles must be greater or equal to 0");
                        }
                        repeat = $<number>3;
                  }
                ;

action          : ALERT {
                        $<number>$ = Action_Alert;
                  }
                | EXEC argumentlist repeat {
                        $<number>$ = Action_Exec;
                  }
                | EXEC argumentlist useroptionlist repeat
                  {
                        $<number>$ = Action_Exec;
                  }
                | RESTART {
                        $<number>$ = Action_Restart;
                  }
                | START {
                        $<number>$ = Action_Start;
                  }
                | STOP {
                        $<number>$ = Action_Stop;
                  }
                | UNMONITOR {
                        $<number>$ = Action_Unmonitor;
                  }
                ;

action1         : action {
                        $<number>$ = $<number>1;
                        if ($<number>1 == Action_Exec && command) {
                                repeat1 = repeat;
                                repeat = 0;
                                command1 = command;
                                command = NULL;
                        }
                  }
                ;

action2         : action {
                        $<number>$ = $<number>1;
                        if ($<number>1 == Action_Exec && command) {
                                repeat2 = repeat;
                                repeat = 0;
                                command2 = command;
                                command = NULL;
                        }
                  }
                ;

rateXcycles     : NUMBER CYCLE {
                        if ($<number>1 < 1 || $<number>1 > BITMAP_MAX) {
                                yyerror2("The number of cycles must be between 1 and %d", BITMAP_MAX);
                        } else {
                                rate.count  = $<number>1;
                                rate.cycles = $<number>1;
                        }
                  }
                ;

rateXYcycles    : NUMBER NUMBER CYCLE {
                        if ($<number>2 < 1 || $<number>2 > BITMAP_MAX) {
                                yyerror2("The number of cycles must be between 1 and %d", BITMAP_MAX);
                        } else if ($<number>1 < 1 || $<number>1 > $<number>2) {
                                yyerror2("The number of events must be between 1 and less then poll cycles");
                        } else {
                                rate.count  = $<number>1;
                                rate.cycles = $<number>2;
                        }
                  }
                ;

rate1           : /* EMPTY */
                | rateXcycles {
                        rate1.count = rate.count;
                        rate1.cycles = rate.cycles;
                        reset_rateset(&rate);
                  }
                | rateXYcycles {
                        rate1.count = rate.count;
                        rate1.cycles = rate.cycles;
                        reset_rateset(&rate);
                }
                ;

rate2           : /* EMPTY */
                | rateXcycles {
                        rate2.count = rate.count;
                        rate2.cycles = rate.cycles;
                        reset_rateset(&rate);
                  }
                | rateXYcycles {
                        rate2.count = rate.count;
                        rate2.cycles = rate.cycles;
                        reset_rateset(&rate);
                }
                ;

recovery        : /* EMPTY */ {
                        $<number>$ = Action_Alert;
                  }
                | ELSE IF RECOVERED rate2 THEN action2 {
                        $<number>$ = $<number>6;
                  }
                | ELSE IF PASSED rate2 THEN action2 {
                        $<number>$ = $<number>6;
                  }
                | ELSE IF SUCCEEDED rate2 THEN action2 {
                        $<number>$ = $<number>6;
                  }
                ;

checksum        : IF FAILED hashtype CHECKSUM rate1 THEN action1 recovery {
                        addeventaction(&(checksumset).action, $<number>7, $<number>8);
                        addchecksum(&checksumset);
                  }
                | IF FAILED hashtype CHECKSUM EXPECT STRING rate1 THEN action1
                  recovery {
                        snprintf(checksumset.hash, sizeof(checksumset.hash), "%s", $6);
                        FREE($6);
                        addeventaction(&(checksumset).action, $<number>9, $<number>10);
                        addchecksum(&checksumset);
                  }
                | IF CHANGED hashtype CHECKSUM rate1 THEN action1 {
                        checksumset.test_changes = true;
                        addeventaction(&(checksumset).action, $<number>7, Action_Ignored);
                        addchecksum(&checksumset);
                  }
                ;
hashtype        : /* EMPTY */ { checksumset.type = Hash_Unknown; }
                | MD5HASH     { checksumset.type = Hash_Md5; }
                | SHA1HASH    { checksumset.type = Hash_Sha1; }
                ;

inode           : IF INODE operator NUMBER rate1 THEN action1 recovery {
                        filesystemset.resource = Resource_Inode;
                        filesystemset.operator = $<number>3;
                        filesystemset.limit_absolute = $4;
                        addeventaction(&(filesystemset).action, $<number>7, $<number>8);
                        addfilesystem(&filesystemset);
                  }
                | IF INODE operator value PERCENT rate1 THEN action1 recovery {
                        filesystemset.resource = Resource_Inode;
                        filesystemset.operator = $<number>3;
                        filesystemset.limit_percent = $<real>4;
                        addeventaction(&(filesystemset).action, $<number>8, $<number>9);
                        addfilesystem(&filesystemset);
                  }
                | IF INODE TFREE operator NUMBER rate1 THEN action1 recovery {
                        filesystemset.resource = Resource_InodeFree;
                        filesystemset.operator = $<number>4;
                        filesystemset.limit_absolute = $5;
                        addeventaction(&(filesystemset).action, $<number>8, $<number>9);
                        addfilesystem(&filesystemset);
                  }
                | IF INODE TFREE operator value PERCENT rate1 THEN action1 recovery {
                        filesystemset.resource = Resource_InodeFree;
                        filesystemset.operator = $<number>4;
                        filesystemset.limit_percent = $<real>5;
                        addeventaction(&(filesystemset).action, $<number>9, $<number>10);
                        addfilesystem(&filesystemset);
                  }
                ;

space           : IF SPACE operator value unit rate1 THEN action1 recovery {
                        filesystemset.resource = Resource_Space;
                        filesystemset.operator = $<number>3;
                        filesystemset.limit_absolute = $<real>4 * $<number>5;
                        addeventaction(&(filesystemset).action, $<number>8, $<number>9);
                        addfilesystem(&filesystemset);
                  }
                | IF SPACE operator value PERCENT rate1 THEN action1 recovery {
                        filesystemset.resource = Resource_Space;
                        filesystemset.operator = $<number>3;
                        filesystemset.limit_percent = $<real>4;
                        addeventaction(&(filesystemset).action, $<number>8, $<number>9);
                        addfilesystem(&filesystemset);
                  }
                | IF SPACE TFREE operator value unit rate1 THEN action1 recovery {
                        filesystemset.resource = Resource_SpaceFree;
                        filesystemset.operator = $<number>4;
                        filesystemset.limit_absolute = $<real>5 * $<number>6;
                        addeventaction(&(filesystemset).action, $<number>9, $<number>10);
                        addfilesystem(&filesystemset);
                  }
                | IF SPACE TFREE operator value PERCENT rate1 THEN action1 recovery {
                        filesystemset.resource = Resource_SpaceFree;
                        filesystemset.operator = $<number>4;
                        filesystemset.limit_percent = $<real>5;
                        addeventaction(&(filesystemset).action, $<number>9, $<number>10);
                        addfilesystem(&filesystemset);
                  }
                ;

read            : IF READ operator value unit currenttime rate1 THEN action1 recovery {
                        filesystemset.resource = Resource_ReadBytes;
                        filesystemset.operator = $<number>3;
                        filesystemset.limit_absolute = $<real>4 * $<number>5;
                        addeventaction(&(filesystemset).action, $<number>9, $<number>10);
                        addfilesystem(&filesystemset);
                  }
                | IF READ operator NUMBER OPERATION rate1 THEN action1 recovery {
                        filesystemset.resource = Resource_ReadOperations;
                        filesystemset.operator = $<number>3;
                        filesystemset.limit_absolute = $<number>4;
                        addeventaction(&(filesystemset).action, $<number>8, $<number>9);
                        addfilesystem(&filesystemset);
                  }
                ;

write           : IF WRITE operator value unit currenttime rate1 THEN action1 recovery {
                        filesystemset.resource = Resource_WriteBytes;
                        filesystemset.operator = $<number>3;
                        filesystemset.limit_absolute = $<real>4 * $<number>5;
                        addeventaction(&(filesystemset).action, $<number>9, $<number>10);
                        addfilesystem(&filesystemset);
                  }
                | IF WRITE operator NUMBER OPERATION rate1 THEN action1 recovery {
                        filesystemset.resource = Resource_WriteOperations;
                        filesystemset.operator = $<number>3;
                        filesystemset.limit_absolute = $<number>4;
                        addeventaction(&(filesystemset).action, $<number>8, $<number>9);
                        addfilesystem(&filesystemset);
                  }
                ;

servicetime     : IF SERVICETIME operator NUMBER MILLISECOND rate1 THEN action1 recovery {
                        filesystemset.resource = Resource_ServiceTime;
                        filesystemset.operator = $<number>3;
                        filesystemset.limit_absolute = $<number>4;
                        addeventaction(&(filesystemset).action, $<number>8, $<number>9);
                        addfilesystem(&filesystemset);
                  }
                | IF SERVICETIME operator value SECOND rate1 THEN action1 recovery {
                        filesystemset.resource = Resource_ServiceTime;
                        filesystemset.operator = $<number>3;
                        filesystemset.limit_absolute = $<real>4 * 1000;
                        addeventaction(&(filesystemset).action, $<number>8, $<number>9);
                        addfilesystem(&filesystemset);
                  }
                ;

fsflag          : IF CHANGED FSFLAG rate1 THEN action1 {
                        addeventaction(&(fsflagset).action, $<number>6, Action_Ignored);
                        addfsflag(&fsflagset);
                  }
                ;

unit            : /* empty */  { $<number>$ = Unit_Byte; }
                | BYTE         { $<number>$ = Unit_Byte; }
                | KILOBYTE     { $<number>$ = Unit_Kilobyte; }
                | MEGABYTE     { $<number>$ = Unit_Megabyte; }
                | GIGABYTE     { $<number>$ = Unit_Gigabyte; }
                ;

permission      : IF FAILED PERMISSION NUMBER rate1 THEN action1 recovery {
                        permset.perm = check_perm($4);
                        addeventaction(&(permset).action, $<number>7, $<number>8);
                        addperm(&permset);
                  }
                | IF CHANGED PERMISSION rate1 THEN action1 recovery {
                        permset.test_changes = true;
                        addeventaction(&(permset).action, $<number>6, Action_Ignored);
                        addperm(&permset);
                  }
                ;

match           : IF CONTENT urloperator PATH rate1 THEN action1 {
                        matchset.not = $<number>3 == Operator_Equal ? false : true;
                        matchset.ignore = false;
                        matchset.match_path = $4;
                        matchset.match_string = NULL;
                        addmatchpath(&matchset, $<number>7);
                        FREE($4);
                  }
                | IF CONTENT urloperator STRING rate1 THEN action1 {
                        matchset.not = $<number>3 == Operator_Equal ? false : true;
                        matchset.ignore = false;
                        matchset.match_path = NULL;
                        matchset.match_string = $4;
                        addmatch(&matchset, $<number>7, 0);
                  }
                | IGNORE CONTENT urloperator PATH {
                        matchset.not = $<number>3 == Operator_Equal ? false : true;
                        matchset.ignore = true;
                        matchset.match_path = $4;
                        matchset.match_string = NULL;
                        addmatchpath(&matchset, Action_Ignored);
                        FREE($4);
                  }
                | IGNORE CONTENT urloperator STRING {
                        matchset.not = $<number>3 == Operator_Equal ? false : true;
                        matchset.ignore = true;
                        matchset.match_path = NULL;
                        matchset.match_string = $4;
                        addmatch(&matchset, Action_Ignored, 0);
                  }
                /* The below MATCH statement is deprecated (replaced by CONTENT) */
                | IF matchflagnot MATCH PATH rate1 THEN action1 {
                        matchset.ignore = false;
                        matchset.match_path = $4;
                        matchset.match_string = NULL;
                        addmatchpath(&matchset, $<number>7);
                        FREE($4);
                  }
                | IF matchflagnot MATCH STRING rate1 THEN action1 {
                        matchset.ignore = false;
                        matchset.match_path = NULL;
                        matchset.match_string = $4;
                        addmatch(&matchset, $<number>7, 0);
                  }
                | IGNORE matchflagnot MATCH PATH {
                        matchset.ignore = true;
                        matchset.match_path = $4;
                        matchset.match_string = NULL;
                        addmatchpath(&matchset, Action_Ignored);
                        FREE($4);
                  }
                | IGNORE matchflagnot MATCH STRING {
                        matchset.ignore = true;
                        matchset.match_path = NULL;
                        matchset.match_string = $4;
                        addmatch(&matchset, Action_Ignored, 0);
                  }
                ;

matchflagnot    : /* EMPTY */ {
                        matchset.not = false;
                  }
                | NOT {
                        matchset.not = true;
                  }
                ;


size            : IF SIZE operator NUMBER unit rate1 THEN action1 recovery {
                        sizeset.operator = $<number>3;
                        sizeset.size = ((unsigned long long)$4 * $<number>5);
                        addeventaction(&(sizeset).action, $<number>8, $<number>9);
                        addsize(&sizeset);
                  }
                | IF CHANGED SIZE rate1 THEN action1 {
                        sizeset.test_changes = true;
                        addeventaction(&(sizeset).action, $<number>6, Action_Ignored);
                        addsize(&sizeset);
                  }
                ;

uid             : IF FAILED UID STRING rate1 THEN action1 recovery {
                        uidset.uid = get_uid($4, 0);
                        addeventaction(&(uidset).action, $<number>7, $<number>8);
                        current->uid = adduid(&uidset);
                        FREE($4);
                  }
                | IF FAILED UID NUMBER rate1 THEN action1 recovery {
                    uidset.uid = get_uid(NULL, $4);
                    addeventaction(&(uidset).action, $<number>7, $<number>8);
                    current->uid = adduid(&uidset);
                  }
                ;

euid            : IF FAILED EUID STRING rate1 THEN action1 recovery {
                        uidset.uid = get_uid($4, 0);
                        addeventaction(&(uidset).action, $<number>7, $<number>8);
                        current->euid = adduid(&uidset);
                        FREE($4);
                  }
                | IF FAILED EUID NUMBER rate1 THEN action1 recovery {
                        uidset.uid = get_uid(NULL, $4);
                        addeventaction(&(uidset).action, $<number>7, $<number>8);
                        current->euid = adduid(&uidset);
                  }
                ;

secattr         : IF FAILED SECURITY ATTRIBUTE STRING rate1 THEN action1 recovery {
                        addsecurityattribute($5, $<number>8, $<number>9);
                  }
                | IF FAILED SECURITY ATTRIBUTE PATH rate1 THEN action1 recovery {
                        addsecurityattribute($5, $<number>8, $<number>9);
                  }
                ;

gid             : IF FAILED GID STRING rate1 THEN action1 recovery {
                        gidset.gid = get_gid($4, 0);
                        addeventaction(&(gidset).action, $<number>7, $<number>8);
                        current->gid = addgid(&gidset);
                        FREE($4);
                  }
                | IF FAILED GID NUMBER rate1 THEN action1 recovery {
                        gidset.gid = get_gid(NULL, $4);
                        addeventaction(&(gidset).action, $<number>7, $<number>8);
                        current->gid = addgid(&gidset);
                  }
                ;

linkstatus   : IF FAILED LINK rate1 THEN action1 recovery {
                        addeventaction(&(linkstatusset).action, $<number>6, $<number>7);
                        addlinkstatus(current, &linkstatusset);
                  }
                ;

linkspeed    : IF CHANGED LINK rate1 THEN action1 recovery {
                        addeventaction(&(linkspeedset).action, $<number>6, $<number>7);
                        addlinkspeed(current, &linkspeedset);
                  }

linksaturation : IF SATURATION operator NUMBER PERCENT rate1 THEN action1 recovery {
                        linksaturationset.operator = $<number>3;
                        linksaturationset.limit = (unsigned long long)$4;
                        addeventaction(&(linksaturationset).action, $<number>8, $<number>9);
                        addlinksaturation(current, &linksaturationset);
                  }
                ;

upload          : IF UPLOAD operator NUMBER unit currenttime rate1 THEN action1 recovery {
                        bandwidthset.operator = $<number>3;
                        bandwidthset.limit = ((unsigned long long)$4 * $<number>5);
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = $<number>6;
                        addeventaction(&(bandwidthset).action, $<number>9, $<number>10);
                        addbandwidth(&(current->uploadbyteslist), &bandwidthset);
                  }
                | IF TOTAL UPLOAD operator NUMBER unit totaltime rate1 THEN action1 recovery {
                        bandwidthset.operator = $<number>4;
                        bandwidthset.limit = ((unsigned long long)$5 * $<number>6);
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = $<number>7;
                        addeventaction(&(bandwidthset).action, $<number>10, $<number>11);
                        addbandwidth(&(current->uploadbyteslist), &bandwidthset);
                  }
                | IF TOTAL UPLOAD operator NUMBER unit NUMBER totaltime rate1 THEN action1 recovery {
                        bandwidthset.operator = $<number>4;
                        bandwidthset.limit = ((unsigned long long)$5 * $<number>6);
                        bandwidthset.rangecount = $7;
                        bandwidthset.range = $<number>8;
                        addeventaction(&(bandwidthset).action, $<number>11, $<number>12);
                        addbandwidth(&(current->uploadbyteslist), &bandwidthset);
                  }
                | IF UPLOAD operator NUMBER PACKET currenttime rate1 THEN action1 recovery {
                        bandwidthset.operator = $<number>3;
                        bandwidthset.limit = (unsigned long long)$4;
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = $<number>6;
                        addeventaction(&(bandwidthset).action, $<number>9, $<number>10);
                        addbandwidth(&(current->uploadpacketslist), &bandwidthset);
                  }
                | IF TOTAL UPLOAD operator NUMBER PACKET totaltime rate1 THEN action1 recovery {
                        bandwidthset.operator = $<number>4;
                        bandwidthset.limit = (unsigned long long)$5;
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = $<number>7;
                        addeventaction(&(bandwidthset).action, $<number>10, $<number>11);
                        addbandwidth(&(current->uploadpacketslist), &bandwidthset);
                  }
                | IF TOTAL UPLOAD operator NUMBER PACKET NUMBER totaltime rate1 THEN action1 recovery {
                        bandwidthset.operator = $<number>4;
                        bandwidthset.limit = (unsigned long long)$5;
                        bandwidthset.rangecount = $7;
                        bandwidthset.range = $<number>8;
                        addeventaction(&(bandwidthset).action, $<number>11, $<number>12);
                        addbandwidth(&(current->uploadpacketslist), &bandwidthset);
                  }
                ;

download        : IF DOWNLOAD operator NUMBER unit currenttime rate1 THEN action1 recovery {
                        bandwidthset.operator = $<number>3;
                        bandwidthset.limit = ((unsigned long long)$4 * $<number>5);
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = $<number>6;
                        addeventaction(&(bandwidthset).action, $<number>9, $<number>10);
                        addbandwidth(&(current->downloadbyteslist), &bandwidthset);
                  }
                | IF TOTAL DOWNLOAD operator NUMBER unit totaltime rate1 THEN action1 recovery {
                        bandwidthset.operator = $<number>4;
                        bandwidthset.limit = ((unsigned long long)$5 * $<number>6);
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = $<number>7;
                        addeventaction(&(bandwidthset).action, $<number>10, $<number>11);
                        addbandwidth(&(current->downloadbyteslist), &bandwidthset);
                  }
                | IF TOTAL DOWNLOAD operator NUMBER unit NUMBER totaltime rate1 THEN action1 recovery {
                        bandwidthset.operator = $<number>4;
                        bandwidthset.limit = ((unsigned long long)$5 * $<number>6);
                        bandwidthset.rangecount = $7;
                        bandwidthset.range = $<number>8;
                        addeventaction(&(bandwidthset).action, $<number>11, $<number>12);
                        addbandwidth(&(current->downloadbyteslist), &bandwidthset);
                  }
                | IF DOWNLOAD operator NUMBER PACKET currenttime rate1 THEN action1 recovery {
                        bandwidthset.operator = $<number>3;
                        bandwidthset.limit = (unsigned long long)$4;
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = $<number>6;
                        addeventaction(&(bandwidthset).action, $<number>9, $<number>10);
                        addbandwidth(&(current->downloadpacketslist), &bandwidthset);
                  }
                | IF TOTAL DOWNLOAD operator NUMBER PACKET totaltime rate1 THEN action1 recovery {
                        bandwidthset.operator = $<number>4;
                        bandwidthset.limit = (unsigned long long)$5;
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = $<number>7;
                        addeventaction(&(bandwidthset).action, $<number>10, $<number>11);
                        addbandwidth(&(current->downloadpacketslist), &bandwidthset);
                  }
                | IF TOTAL DOWNLOAD operator NUMBER PACKET NUMBER totaltime rate1 THEN action1 recovery {
                        bandwidthset.operator = $<number>4;
                        bandwidthset.limit = (unsigned long long)$5;
                        bandwidthset.rangecount = $7;
                        bandwidthset.range = $<number>8;
                        addeventaction(&(bandwidthset).action, $<number>11, $<number>12);
                        addbandwidth(&(current->downloadpacketslist), &bandwidthset);
                  }
                ;

icmptype        : TYPE ICMPECHO { $<number>$ = ICMP_ECHO; }
                ;

reminder        : /* EMPTY */           { mailset.reminder = 0; }
                | REMINDER NUMBER       { mailset.reminder = $<number>2; }
                | REMINDER NUMBER CYCLE { mailset.reminder = $<number>2; }
                ;

%%


/* -------------------------------------------------------- Parser interface */


/**
 * Syntactic error routine
 *
 * This routine is automatically called by the lexer!
 */
void yyerror(const char *s, ...) {
        ASSERT(s);
        char *msg = NULL;
        va_list ap;
        va_start(ap, s);
        msg = Str_vcat(s, ap);
        va_end(ap);
        LogError("%s:%i: %s '%s'\n", currentfile, lineno, msg, yytext);
        cfg_errflag++;
        FREE(msg);
}


/**
 * Syntactical warning routine
 */
void yywarning(const char *s, ...) {
        ASSERT(s);
        char *msg = NULL;
        va_list ap;
        va_start(ap, s);
        msg = Str_vcat(s, ap);
        va_end(ap);
        LogWarning("%s:%i: %s '%s'\n", currentfile, lineno, msg, yytext);
        FREE(msg);
}


/**
 * Argument error routine
 */
void yyerror2(const char *s, ...) {
        ASSERT(s);
        char *msg = NULL;
        va_list ap;
        va_start(ap, s);
        msg = Str_vcat(s, ap);
        va_end(ap);
        LogError("%s:%i: %s '%s'\n", argcurrentfile, arglineno, msg, argyytext);
        cfg_errflag++;
        FREE(msg);
}


/**
 * Argument warning routine
 */
void yywarning2(const char *s, ...) {
        ASSERT(s);
        char *msg = NULL;
        va_list ap;
        va_start(ap, s);
        msg = Str_vcat(s, ap);
        va_end(ap);
        LogWarning("%s:%i: %s '%s'\n", argcurrentfile, arglineno, msg, argyytext);
        FREE(msg);
}


/*
 * The Parser hook - start parsing the control file
 * Returns true if parsing succeeded, otherwise false
 */
boolean_t parse(char *controlfile) {
        ASSERT(controlfile);

        servicelist = tail = current = NULL;

        if ((yyin = fopen(controlfile,"r")) == (FILE *)NULL) {
                LogError("Cannot open the control file '%s' -- %s\n", controlfile, STRERROR);
                return false;
        }

        currentfile = Str_dup(controlfile);

        /*
         * Creation of the global service list is synchronized
         */
        LOCK(Run.mutex)
        {
                preparse();
                yyparse();
                fclose(yyin);
                postparse();
        }
        END_LOCK;

        FREE(currentfile);

        if (argyytext != NULL)
                FREE(argyytext);

        /*
         * Secure check the monitrc file. The run control file must have the
         * same uid as the REAL uid of this process, it must have permissions
         * no greater than 700 and it must not be a symbolic link.
         */
        if (! file_checkStat(controlfile, "control file", S_IRUSR|S_IWUSR|S_IXUSR))
                return false;

        return cfg_errflag == 0;
}


/* ----------------------------------------------------------------- Private */


/**
 * Initialize objects used by the parser.
 */
static void preparse() {
        /* Set instance incarnation ID */
        time(&Run.incarnation);
        /* Reset lexer */
        buffer_stack_ptr            = 0;
        lineno                      = 1;
        arglineno                   = 1;
        argcurrentfile              = NULL;
        argyytext                   = NULL;
        /* Reset parser */
        Run.limits.sendExpectBuffer  = LIMIT_SENDEXPECTBUFFER;
        Run.limits.fileContentBuffer = LIMIT_FILECONTENTBUFFER;
        Run.limits.httpContentBuffer = LIMIT_HTTPCONTENTBUFFER;
        Run.limits.programOutput     = LIMIT_PROGRAMOUTPUT;
        Run.limits.networkTimeout    = LIMIT_NETWORKTIMEOUT;
        Run.limits.programTimeout    = LIMIT_PROGRAMTIMEOUT;
        Run.limits.stopTimeout       = LIMIT_STOPTIMEOUT;
        Run.limits.startTimeout      = LIMIT_STARTTIMEOUT;
        Run.limits.restartTimeout    = LIMIT_RESTARTTIMEOUT;
        Run.onreboot                 = Onreboot_Start;
        Run.mmonitcredentials        = NULL;
        Run.httpd.flags              = Httpd_Disabled | Httpd_Signature;
        Run.httpd.credentials        = NULL;
        memset(&(Run.httpd.socket), 0, sizeof(Run.httpd.socket));
        Run.mailserver_timeout       = SMTP_TIMEOUT;
        Run.eventlist_dir            = NULL;
        Run.eventlist_slots          = -1;
        Run.system                   = NULL;
        Run.mmonits                  = NULL;
        Run.maillist                 = NULL;
        Run.mailservers              = NULL;
        Run.MailFormat.from          = NULL;
        Run.MailFormat.replyto       = NULL;
        Run.MailFormat.subject       = NULL;
        Run.MailFormat.message       = NULL;
        depend_list                  = NULL;
        Run.flags |= Run_HandlerInit | Run_MmonitCredentials;
        for (int i = 0; i <= Handler_Max; i++)
                Run.handler_queue[i] = 0;

        /*
         * Initialize objects
         */
        reset_uidset();
        reset_gidset();
        reset_statusset();
        reset_sizeset();
        reset_mailset();
        reset_sslset();
        reset_mailserverset();
        reset_mmonitset();
        reset_portset();
        reset_permset();
        reset_icmpset();
        reset_linkstatusset();
        reset_linkspeedset();
        reset_linksaturationset();
        reset_bandwidthset();
        reset_rateset(&rate);
        reset_rateset(&rate1);
        reset_rateset(&rate2);
        reset_filesystemset();
        reset_resourceset();
        reset_checksumset();
        reset_timestampset();
        reset_actionrateset();
}


/*
 * Check that values are reasonable after parsing
 */
static void postparse() {
        if (cfg_errflag)
                return;

        /* If defined - add the last service to the service list */
        if (current)
                addservice(current);

        /* Check that we do not start monit in daemon mode without having a poll time */
        if (! Run.polltime && ((Run.flags & Run_Daemon) || (Run.flags & Run_Foreground))) {
                LogError("Poll time is invalid or not defined. Please define poll time in the control file\nas a number (> 0)  or use the -d option when starting monit\n");
                cfg_errflag++;
        }

        if (Run.files.log)
                Run.flags |= Run_Log;

        /* Add the default general system service if not specified explicitly: service name default to hostname */
        if (! Run.system) {
                char hostname[STRLEN];
                if (gethostname(hostname, sizeof(hostname))) {
                        LogError("Cannot get system hostname -- please add 'check system <name>'\n");
                        cfg_errflag++;
                }
                if (Util_existService(hostname)) {
                        LogError("'check system' not defined in control file, failed to add automatic configuration (service name %s is used already) -- please add 'check system <name>' manually\n", hostname);
                        cfg_errflag++;
                }
                Run.system = createservice(Service_System, Str_dup(hostname), NULL, check_system);
                addservice(Run.system);
        }
        addeventaction(&(Run.system->action_MONIT_START), Action_Start, Action_Ignored);
        addeventaction(&(Run.system->action_MONIT_STOP), Action_Stop,  Action_Ignored);

        if (Run.mmonits) {
                if (Run.httpd.flags & Httpd_Net) {
                        if (Run.flags & Run_MmonitCredentials) {
                                Auth_T c;
                                for (c = Run.httpd.credentials; c; c = c->next) {
                                        if (c->digesttype == Digest_Cleartext && ! c->is_readonly) {
                                                Run.mmonitcredentials = c;
                                                break;
                                        }
                                }
                                if (! Run.mmonitcredentials)
                                        LogWarning("M/Monit registration with credentials enabled, but no suitable credentials found in monit configuration file -- please add 'allow user:password' option to 'set httpd' statement\n");
                        }
                } else if (Run.httpd.flags & Httpd_Unix) {
                        LogWarning("M/Monit enabled but Monit httpd is using unix socket -- please change 'set httpd' statement to use TCP port in order to be able to manage services on Monit\n");
                } else {
                        LogWarning("M/Monit enabled but no httpd allowed -- please add 'set httpd' statement\n");
                }
        }

        /* Check the sanity of any dependency graph */
        check_depend();

#ifdef HAVE_OPENSSL
        Ssl_setFipsMode(Run.flags & Run_FipsEnabled);
#endif

        Processor_setHttpPostLimit();
}


static boolean_t _parseOutgoingAddress(const char *ip, Outgoing_T *outgoing) {
        struct addrinfo *result, hints = {.ai_flags = AI_NUMERICHOST};
        int status = getaddrinfo(ip, NULL, &hints, &result);
        if (status == 0) {
                outgoing->ip = (char *)ip;
                outgoing->addrlen = result->ai_addrlen;
                memcpy(&(outgoing->addr), result->ai_addr, result->ai_addrlen);
                freeaddrinfo(result);
                return true;
        } else {
                yyerror2("IP address parsing failed -- %s", ip, status == EAI_SYSTEM ? STRERROR : gai_strerror(status));
        }
        return false;
}


/*
 * Create a new service object and add any current objects to the
 * service list.
 */
static Service_T createservice(Service_Type type, char *name, char *value, State_Type (*check)(Service_T s)) {
        ASSERT(name);

        check_name(name);

        if (current)
                addservice(current);

        NEW(current);
        current->type = type;
        switch (type) {
                case Service_Directory:
                        NEW(current->inf.directory);
                        break;
                case Service_Fifo:
                        NEW(current->inf.fifo);
                        break;
                case Service_File:
                        NEW(current->inf.file);
                        break;
                case Service_Filesystem:
                        NEW(current->inf.filesystem);
                        break;
                case Service_Net:
                        NEW(current->inf.net);
                        break;
                case Service_Process:
                        NEW(current->inf.process);
                        break;
                default:
                        break;
        }
        Util_resetInfo(current);

        if (type == Service_Program) {
                NEW(current->program);
                current->program->args = command;
                command = NULL;
                current->program->timeout = Run.limits.programTimeout;
        }

        /* Set default values */
        current->mode     = Monitor_Active;
        current->monitor  = Monitor_Init;
        current->onreboot = Run.onreboot;
        current->name     = name;
        current->check    = check;
        current->path     = value;

        /* Initialize general event handlers */
        addeventaction(&(current)->action_DATA,     Action_Alert,     Action_Alert);
        addeventaction(&(current)->action_EXEC,     Action_Alert,     Action_Alert);
        addeventaction(&(current)->action_INVALID,  Action_Restart,   Action_Alert);

        /* Initialize internal event handlers */
        addeventaction(&(current)->action_ACTION,       Action_Alert, Action_Ignored);

        gettimeofday(&current->collected, NULL);

        return current;
}


/*
 * Add a service object to the servicelist
 */
static void addservice(Service_T s) {
        ASSERT(s);

        // Test sanity check
        switch (s->type) {
                case Service_Host:
                        // Verify that a remote service has a port or an icmp list
                        if (! s->portlist && ! s->icmplist) {
                                LogError("'check host' statement is incomplete: Please specify a port number to test\n or an icmp test at the remote host: '%s'\n", s->name);
                                cfg_errflag++;
                        }
                        break;
                case Service_Program:
                        // Verify that a program test has a status test
                        if (! s->statuslist) {
                                LogError("'check program %s' is incomplete: Please add an 'if status != n' test\n", s->name);
                                cfg_errflag++;
                        }
                        // Create the Command object
                        char program[PATH_MAX];
                        strncpy(program, s->program->args->arg[0], sizeof(program) - 1);
                        s->program->C = Command_new(program, NULL);
                        for (int i = 1; i < s->program->args->length; i++) {
                                Command_appendArgument(s->program->C, s->program->args->arg[i]);
                                snprintf(program + strlen(program), sizeof(program) - strlen(program) - 1, " %s", s->program->args->arg[i]);
                        }
                        s->path = Str_dup(program);
                        if (s->program->args->has_uid)
                                Command_setUid(s->program->C, s->program->args->uid);
                        if (s->program->args->has_gid)
                                Command_setGid(s->program->C, s->program->args->gid);
                        // Set environment
                        Command_setEnv(s->program->C, "MONIT_SERVICE", s->name);
                        break;
                case Service_Net:
                        if (! s->linkstatuslist) {
                                // Add link status test if not defined
                                addeventaction(&(linkstatusset).action, Action_Alert, Action_Alert);
                                addlinkstatus(s, &linkstatusset);
                        }
                        break;
                case Service_Filesystem:
                        if (! s->nonexistlist && ! s->existlist) {
                                // Add non-existence test if not defined
                                addeventaction(&(nonexistset).action, Action_Restart, Action_Alert);
                                addnonexist(&nonexistset);
                        }
                        if (! s->fsflaglist) {
                                // Add filesystem flags change test if not defined
                                addeventaction(&(fsflagset).action, Action_Alert, Action_Ignored);
                                addfsflag(&fsflagset);
                        }
                        break;
                case Service_Directory:
                case Service_Fifo:
                case Service_File:
                case Service_Process:
                        if (! s->nonexistlist && ! s->existlist) {
                                // Add existence test if not defined
                                addeventaction(&(nonexistset).action, Action_Restart, Action_Alert);
                                addnonexist(&nonexistset);
                        }
                        break;
                default:
                        break;
        }

        /* Add the service to the end of the service list */
        if (tail != NULL) {
                tail->next = s;
                tail->next_conf = s;
        } else {
                servicelist = s;
                servicelist_conf = s;
        }
        tail = s;
}


/*
 * Add entry to service group list
 */
static void addservicegroup(char *name) {
        ServiceGroup_T g;

        ASSERT(name);

        /* Check if service group with the same name is defined already */
        for (g = servicegrouplist; g; g = g->next)
                if (IS(g->name, name))
                        break;

        if (! g) {
                NEW(g);
                g->name = Str_dup(name);
                g->members = List_new();
                g->next = servicegrouplist;
                servicegrouplist = g;
        }

        List_append(g->members, current);
}


/*
 * Add a dependant entry to the current service dependant list
 *
 */
static void adddependant(char *dependant) {
        Dependant_T d;

        ASSERT(dependant);

        NEW(d);

        if (current->dependantlist)
                d->next = current->dependantlist;

        d->dependant = dependant;
        current->dependantlist = d;

}


/*
 * Add the given mailaddress with the appropriate alert notification
 * values and mail attributes to the given mailinglist.
 */
static void addmail(char *mailto, Mail_T f, Mail_T *l) {
        Mail_T m;

        ASSERT(mailto);

        NEW(m);
        m->to       = mailto;
        m->from     = f->from;
        m->replyto  = f->replyto;
        m->subject  = f->subject;
        m->message  = f->message;
        m->events   = f->events;
        m->reminder = f->reminder;

        m->next = *l;
        *l = m;

        reset_mailset();
}


/*
 * Add the given portset to the current service's portlist
 */
static void addport(Port_T *list, Port_T port) {
        ASSERT(port);

        if (port->protocol->check == check_radius && port->type != Socket_Udp)
                yyerror("Radius protocol test supports UDP only");

        Port_T p;
        NEW(p);
        p->is_available       = Connection_Init;
        p->type               = port->type;
        p->socket             = port->socket;
        p->family             = port->family;
        p->action             = port->action;
        p->timeout            = port->timeout;
        p->retry              = port->retry;
        p->protocol           = port->protocol;
        p->hostname           = port->hostname;
        p->url_request        = port->url_request;
        p->outgoing           = port->outgoing;
        if (p->family == Socket_Unix) {
                p->target.unix.pathname = port->target.unix.pathname;
        } else {
                p->target.net.port = port->target.net.port;
                if (sslset.flags) {
#ifdef HAVE_OPENSSL
                        p->target.net.ssl.certificate.minimumDays = port->target.net.ssl.certificate.minimumDays;
                        if (sslset.flags && (p->target.net.port == 25 || p->target.net.port == 587))
                                sslset.flags = SSL_StartTLS;
                        _setSSLOptions(&(p->target.net.ssl.options));
#else
                        yyerror("SSL check cannot be activated -- Monit was not built with SSL support");
#endif
                }
        }
        memcpy(&p->parameters, &port->parameters, sizeof(port->parameters));

        if (p->protocol->check == check_http) {
                if (p->parameters.http.checksum) {
                        cleanup_hash_string(p->parameters.http.checksum);
                        if (strlen(p->parameters.http.checksum) == 32)
                                p->parameters.http.hashtype = Hash_Md5;
                        else if (strlen(p->parameters.http.checksum) == 40)
                                p->parameters.http.hashtype = Hash_Sha1;
                        else
                                yyerror2("invalid checksum [%s]", p->parameters.http.checksum);
                } else {
                        p->parameters.http.hashtype = Hash_Unknown;
                }
                if (! p->parameters.http.method) {
                        p->parameters.http.method = Http_Get;
                } else if (p->parameters.http.method == Http_Head) {
                        // Sanity check: if content or checksum test is used, the method Http_Head is not allowed, as we need the content
                        if ((p->url_request && p->url_request->regex) || p->parameters.http.checksum) {
                                yyerror2("if response content or checksum test is enabled, the HEAD method is not allowed");
                        }
                }
        }

        p->next = *list;
        *list = p;

        reset_sslset();
        reset_portset();

}


static void addhttpheader(Port_T port, const char *header) {
        if (! port->parameters.http.headers) {
                port->parameters.http.headers = List_new();
        }
        if (Str_startsWith(header, "Connection:") && ! Str_sub(header, "close")) {
                yywarning("We don't recommend setting the Connection header. Monit will always close the connection even if 'keep-alive' is set\n");
        }
        List_append(port->parameters.http.headers, (char *)header);
}


/*
 * Add a new resource object to the current service resource list
 */
static void addresource(Resource_T rr) {
        ASSERT(rr);
        if (Run.flags & Run_ProcessEngineEnabled) {
                Resource_T r;
                NEW(r);
                r->resource_id = rr->resource_id;
                r->limit       = rr->limit;
                r->action      = rr->action;
                r->operator    = rr->operator;
                r->next        = current->resourcelist;
                current->resourcelist = r;
        } else {
                yywarning("Cannot activate service check. The process status engine was disabled. On certain systems you must run monit as root to utilize this feature)\n");
        }
        reset_resourceset();
}


/*
 * Add a new file object to the current service timestamp list
 */
static void addtimestamp(Timestamp_T ts) {
        ASSERT(ts);

        Timestamp_T t;
        NEW(t);
        t->type         = ts->type;
        t->operator     = ts->operator;
        t->time         = ts->time;
        t->action       = ts->action;
        t->test_changes = ts->test_changes;

        t->next = current->timestamplist;
        current->timestamplist = t;

        reset_timestampset();
}


/*
 * Add a new object to the current service actionrate list
 */
static void addactionrate(ActionRate_T ar) {
        ActionRate_T a;

        ASSERT(ar);

        if (ar->count > ar->cycle)
                yyerror2("The number of restarts must be less than poll cycles");
        if (ar->count <= 0 || ar->cycle <= 0)
                yyerror2("Zero or negative values not allowed in a action rate statement");

        NEW(a);
        a->count  = ar->count;
        a->cycle  = ar->cycle;
        a->action = ar->action;

        a->next = current->actionratelist;
        current->actionratelist = a;

        reset_actionrateset();
}



/*
 * Add a new Size object to the current service size list
 */
static void addsize(Size_T ss) {
        Size_T s;
        struct stat buf;

        ASSERT(ss);

        NEW(s);
        s->operator     = ss->operator;
        s->size         = ss->size;
        s->action       = ss->action;
        s->test_changes = ss->test_changes;
        /* Get the initial size for future comparision, if the file exists */
        if (s->test_changes) {
                s->initialized = ! stat(current->path, &buf);
                if (s->initialized)
                        s->size = (unsigned long long)buf.st_size;
        }

        s->next = current->sizelist;
        current->sizelist = s;

        reset_sizeset();
}


/*
 * Add a new Uptime object to the current service uptime list
 */
static void adduptime(Uptime_T uu) {
        Uptime_T u;

        ASSERT(uu);

        NEW(u);
        u->operator = uu->operator;
        u->uptime = uu->uptime;
        u->action = uu->action;

        u->next = current->uptimelist;
        current->uptimelist = u;

        reset_uptimeset();
}


/*
 * Add a new Pid object to the current service pid list
 */
static void addpid(Pid_T pp) {
        ASSERT(pp);

        Pid_T p;
        NEW(p);
        p->action = pp->action;

        p->next = current->pidlist;
        current->pidlist = p;

        reset_pidset();
}


/*
 * Add a new PPid object to the current service ppid list
 */
static void addppid(Pid_T pp) {
        ASSERT(pp);

        Pid_T p;
        NEW(p);
        p->action = pp->action;

        p->next = current->ppidlist;
        current->ppidlist = p;

        reset_ppidset();
}


/*
 * Add a new Fsflag object to the current service fsflag list
 */
static void addfsflag(FsFlag_T ff) {
        ASSERT(ff);

        FsFlag_T f;
        NEW(f);
        f->action = ff->action;

        f->next = current->fsflaglist;
        current->fsflaglist = f;

        reset_fsflagset();
}


/*
 * Add a new Nonexist object to the current service list
 */
static void addnonexist(NonExist_T ff) {
        ASSERT(ff);

        NonExist_T f;
        NEW(f);
        f->action = ff->action;

        f->next = current->nonexistlist;
        current->nonexistlist = f;

        reset_nonexistset();
}


static void addexist(Exist_T rule) {
        ASSERT(rule);
        Exist_T r;
        NEW(r);
        r->action = rule->action;
        r->next = current->existlist;
        current->existlist = r;
        reset_existset();
}


/*
 * Set Checksum object in the current service
 */
static void addchecksum(Checksum_T cs) {
        ASSERT(cs);

        cs->initialized = true;

        if (STR_UNDEF(cs->hash)) {
                if (cs->type == Hash_Unknown)
                        cs->type = Hash_Default;
                if (! (Util_getChecksum(current->path, cs->type, cs->hash, sizeof(cs->hash)))) {
                        /* If the file doesn't exist, set dummy value */
                        snprintf(cs->hash, sizeof(cs->hash), cs->type == Hash_Md5 ? "00000000000000000000000000000000" : "0000000000000000000000000000000000000000");
                        cs->initialized = false;
                        yywarning2("Cannot compute a checksum for file %s", current->path);
                }
        }

        int len = cleanup_hash_string(cs->hash);
        if (cs->type == Hash_Unknown) {
                if (len == 32) {
                        cs->type = Hash_Md5;
                } else if (len == 40) {
                        cs->type = Hash_Sha1;
                } else {
                        yyerror2("Unknown checksum type [%s] for file %s", cs->hash, current->path);
                        reset_checksumset();
                        return;
                }
        } else if ((cs->type == Hash_Md5 && len != 32) || (cs->type == Hash_Sha1 && len != 40)) {
                yyerror2("Invalid checksum [%s] for file %s", cs->hash, current->path);
                reset_checksumset();
                return;
        }

        Checksum_T c;
        NEW(c);
        c->type         = cs->type;
        c->test_changes = cs->test_changes;
        c->initialized  = cs->initialized;
        c->action       = cs->action;
        snprintf(c->hash, sizeof(c->hash), "%s", cs->hash);

        current->checksum = c;

        reset_checksumset();

}


/*
 * Set Perm object in the current service
 */
static void addperm(Perm_T ps) {
        ASSERT(ps);

        Perm_T p;
        NEW(p);
        p->action = ps->action;
        p->test_changes = ps->test_changes;
        if (p->test_changes) {
                if (! File_exist(current->path))
                        DEBUG("The path '%s' used in the PERMISSION statement refer to a non-existing object\n", current->path);
                else if ((p->perm = File_mod(current->path)) < 0)
                        yyerror2("Cannot get the timestamp for '%s'", current->path);
                else
                        p->perm &= 07777;
        } else {
                p->perm = ps->perm;
        }
        current->perm = p;
        reset_permset();
}


static void addlinkstatus(Service_T s, LinkStatus_T L) {
        ASSERT(L);
        
        LinkStatus_T l;
        NEW(l);
        l->action = L->action;
        
        l->next = s->linkstatuslist;
        s->linkstatuslist = l;
        
        reset_linkstatusset();
}


static void addlinkspeed(Service_T s, LinkSpeed_T L) {
        ASSERT(L);
        
        LinkSpeed_T l;
        NEW(l);
        l->action = L->action;
        
        l->next = s->linkspeedlist;
        s->linkspeedlist = l;
        
        reset_linkspeedset();
}


static void addlinksaturation(Service_T s, LinkSaturation_T L) {
        ASSERT(L);
        
        LinkSaturation_T l;
        NEW(l);
        l->operator = L->operator;
        l->limit = L->limit;
        l->action = L->action;
        
        l->next = s->linksaturationlist;
        s->linksaturationlist = l;
        
        reset_linksaturationset();
}


/*
 * Return Bandwidth object
 */
static void addbandwidth(Bandwidth_T *list, Bandwidth_T b) {
        ASSERT(list);
        ASSERT(b);

        if (b->rangecount * b->range > 24 * Time_Hour) {
                yyerror2("Maximum range for total test is 24 hours");
        } else if (b->range == Time_Minute && b->rangecount > 60) {
                yyerror2("Maximum value for [minute(s)] unit is 60");
        } else if (b->range == Time_Hour && b->rangecount > 24) {
                yyerror2("Maximum value for [hour(s)] unit is 24");
        } else if (b->range == Time_Day && b->rangecount > 1) {
                yyerror2("Maximum value for [day(s)] unit is 1");
        } else {
                if (b->range == Time_Day) {
                        // translate last day -> last 24 hours
                        b->rangecount = 24;
                        b->range = Time_Hour;
                }
                Bandwidth_T bandwidth;
                NEW(bandwidth);
                bandwidth->operator = b->operator;
                bandwidth->limit = b->limit;
                bandwidth->rangecount = b->rangecount;
                bandwidth->range = b->range;
                bandwidth->action = b->action;
                bandwidth->next = *list;
                *list = bandwidth;
        }
        reset_bandwidthset();
}


static void appendmatch(Match_T *list, Match_T item) {
        if (*list) {
                /* Find the end of the list (keep the same patterns order as in the config file) */
                Match_T last;
                for (last = *list; last->next; last = last->next)
                        ;
                last->next = item;
        } else {
                *list = item;
        }
}


/*
 * Set Match object in the current service
 */
static void addmatch(Match_T ms, int actionnumber, int linenumber) {
        Match_T m;

        ASSERT(ms);

        NEW(m);
        NEW(m->regex_comp);

        m->match_string = ms->match_string;
        m->match_path   = ms->match_path ? Str_dup(ms->match_path) : NULL;
        m->action       = ms->action;
        m->not          = ms->not;
        m->ignore       = ms->ignore;
        m->next         = NULL;

        addeventaction(&(m->action), actionnumber, Action_Ignored);

        int reg_return = regcomp(m->regex_comp, ms->match_string, REG_NOSUB|REG_EXTENDED);

        if (reg_return != 0) {
                char errbuf[STRLEN];
                regerror(reg_return, ms->regex_comp, errbuf, STRLEN);
                if (m->match_path != NULL)
                        yyerror2("Regex parsing error: %s on line %i of", errbuf, linenumber);
                else
                        yyerror2("Regex parsing error: %s", errbuf);
        }
        appendmatch(m->ignore ? &current->matchignorelist : &current->matchlist, m);
}


static void addmatchpath(Match_T ms, Action_Type actionnumber) {
        ASSERT(ms->match_path);

        FILE *handle = fopen(ms->match_path, "r");
        if (handle == NULL) {
                yyerror2("Cannot read regex match file (%s)", ms->match_path);
                return;
        }

        // The addeventaction() called from addmatch() will reset the command1 to NULL, but we need to duplicate the command for each line, thus need to save it here
        command_t savecommand = command1;
        for (int linenumber = 1; ! feof(handle); linenumber++) {
                char buf[2048];

                if (! fgets(buf, sizeof(buf), handle))
                        continue;

                size_t len = strlen(buf);

                if (len == 0 || buf[0] == '\n')
                        continue;

                if (buf[len - 1] == '\n')
                        buf[len - 1] = 0;

                ms->match_string = Str_dup(buf);

                if (actionnumber == Action_Exec) {
                        if (command1 == NULL) {
                                ASSERT(savecommand);
                                command1 = copycommand(savecommand);
                        }
                }
                
                addmatch(ms, actionnumber, linenumber);
        }
        if (actionnumber == Action_Exec && savecommand)
                gccmd(&savecommand);
        
        fclose(handle);
}


/*
 * Set exit status test object in the current service
 */
static void addstatus(Status_T status) {
        Status_T s;
        ASSERT(status);
        NEW(s);
        s->initialized = status->initialized;
        s->return_value = status->return_value;
        s->operator = status->operator;
        s->action = status->action;
        s->next = current->statuslist;
        current->statuslist = s;

        reset_statusset();
}


/*
 * Set Uid object in the current service
 */
static Uid_T adduid(Uid_T u) {
        ASSERT(u);

        Uid_T uid;
        NEW(uid);
        uid->uid = u->uid;
        uid->action = u->action;
        reset_uidset();
        return uid;
}


/*
 * Set Gid object in the current service
 */
static Gid_T addgid(Gid_T g) {
        ASSERT(g);

        Gid_T gid;
        NEW(gid);
        gid->gid = g->gid;
        gid->action = g->action;
        reset_gidset();
        return gid;
}


/*
 * Add a new filesystem to the current service's filesystem list
 */
static void addfilesystem(FileSystem_T ds) {
        FileSystem_T dev;

        ASSERT(ds);

        NEW(dev);
        dev->resource           = ds->resource;
        dev->operator           = ds->operator;
        dev->limit_absolute     = ds->limit_absolute;
        dev->limit_percent      = ds->limit_percent;
        dev->action             = ds->action;

        dev->next               = current->filesystemlist;
        current->filesystemlist = dev;
        
        reset_filesystemset();

}


/*
 * Add a new icmp object to the current service's icmp list
 */
static void addicmp(Icmp_T is) {
        Icmp_T icmp;

        ASSERT(is);

        NEW(icmp);
        icmp->family       = is->family;
        icmp->type         = is->type;
        icmp->size         = is->size;
        icmp->count        = is->count;
        icmp->timeout      = is->timeout;
        icmp->action       = is->action;
        icmp->outgoing     = is->outgoing;
        icmp->is_available = Connection_Init;
        icmp->response     = -1;

        icmp->next         = current->icmplist;
        current->icmplist  = icmp;

        reset_icmpset();
}


/*
 * Set EventAction object
 */
static void addeventaction(EventAction_T *_ea, Action_Type failed, Action_Type succeeded) {
        EventAction_T ea;

        ASSERT(_ea);

        NEW(ea);
        NEW(ea->failed);
        NEW(ea->succeeded);

        ea->failed->id = failed;
        ea->failed->repeat = repeat1;
        ea->failed->count = rate1.count;
        ea->failed->cycles = rate1.cycles;
        if (failed == Action_Exec) {
                ASSERT(command1);
                ea->failed->exec = command1;
                command1 = NULL;
        }

        ea->succeeded->id = succeeded;
        ea->succeeded->repeat = repeat2;
        ea->succeeded->count = rate2.count;
        ea->succeeded->cycles = rate2.cycles;
        if (succeeded == Action_Exec) {
                ASSERT(command2);
                ea->succeeded->exec = command2;
                command2 = NULL;
        }
        *_ea = ea;
        reset_rateset(&rate);
        reset_rateset(&rate1);
        reset_rateset(&rate2);
        repeat = repeat1 = repeat2 = 0;
}


/*
 * Add a generic protocol handler to
 */
static void addgeneric(Port_T port, char *send, char *expect) {
        Generic_T g = port->parameters.generic.sendexpect;
        if (! g) {
                NEW(g);
                port->parameters.generic.sendexpect = g;
        } else {
                while (g->next)
                        g = g->next;
                NEW(g->next);
                g = g->next;
        }
        if (send) {
                g->send = send;
                g->expect = NULL;
        } else if (expect) {
                int reg_return;
                NEW(g->expect);
                reg_return = regcomp(g->expect, expect, REG_NOSUB|REG_EXTENDED);
                FREE(expect);
                if (reg_return != 0) {
                        char errbuf[STRLEN];
                        regerror(reg_return, g->expect, errbuf, STRLEN);
                        yyerror2("Regex parsing error: %s", errbuf);
                }
                g->send = NULL;
        }
}


/*
 * Add the current command object to the current service object's
 * start or stop program.
 */
static void addcommand(int what, unsigned timeout) {

        switch (what) {
                case START:   current->start = command; break;
                case STOP:    current->stop = command; break;
                case RESTART: current->restart = command; break;
        }

        command->timeout = timeout;
        
        command = NULL;

}


/*
 * Add a new argument to the argument list
 */
static void addargument(char *argument) {

        ASSERT(argument);

        if (! command) {

                NEW(command);
                check_exec(argument);

        }

        command->arg[command->length++] = argument;
        command->arg[command->length] = NULL;

        if (command->length >= ARGMAX)
                yyerror("Exceeded maximum number of program arguments");

}


/*
 * Setup a url request for the current port object
 */
static void prepare_urlrequest(URL_T U) {

        ASSERT(U);

        /* Only the HTTP protocol is supported for URLs currently. See also the lexer if this is to be changed in the future */
        portset.protocol = Protocol_get(Protocol_HTTP);

        if (urlrequest == NULL)
                NEW(urlrequest);
        urlrequest->url = U;
        portset.hostname = Str_dup(U->hostname);
        portset.target.net.port = U->port;
        portset.url_request = urlrequest;
        portset.type = Socket_Tcp;
        portset.parameters.http.request = Str_cat("%s%s%s", U->path, U->query ? "?" : "", U->query ? U->query : "");
        if (IS(U->protocol, "https"))
                sslset.flags = SSL_Enabled;
}


/*
 * Set the url request for a port
 */
static void  seturlrequest(int operator, char *regex) {

        ASSERT(regex);

        if (! urlrequest)
                NEW(urlrequest);
        urlrequest->operator = operator;
        int reg_return;
        NEW(urlrequest->regex);
        reg_return = regcomp(urlrequest->regex, regex, REG_NOSUB|REG_EXTENDED);
        if (reg_return != 0) {
                char errbuf[STRLEN];
                regerror(reg_return, urlrequest->regex, errbuf, STRLEN);
                yyerror2("Regex parsing error: %s", errbuf);
        }
}


/*
 * Add a new data recipient server to the mmonit server list
 */
static void addmmonit(Mmonit_T mmonit) {
        ASSERT(mmonit->url);

        Mmonit_T c;
        NEW(c);
        c->url = mmonit->url;
        c->compress = MmonitCompress_Init;
        _setSSLOptions(&(c->ssl));
        if (IS(c->url->protocol, "https")) {
#ifdef HAVE_OPENSSL
                c->ssl.flags = SSL_Enabled;
#else
                yyerror("SSL check cannot be activated -- SSL disabled");
#endif
        }
        c->timeout = mmonit->timeout;
        c->next = NULL;

        if (Run.mmonits) {
                Mmonit_T C;
                for (C = Run.mmonits; C->next; C = C->next)
                        /* Empty */ ;
                C->next = c;
        } else {
                Run.mmonits = c;
        }
        reset_sslset();
        reset_mmonitset();
}


/*
 * Add a new smtp server to the mail server list
 */
static void addmailserver(MailServer_T mailserver) {

        MailServer_T s;

        ASSERT(mailserver->host);

        NEW(s);
        s->host        = mailserver->host;
        s->port        = mailserver->port;
        s->username    = mailserver->username;
        s->password    = mailserver->password;

        if (sslset.flags && (mailserver->port == 25 || mailserver->port == 587))
                sslset.flags = SSL_StartTLS;
        _setSSLOptions(&(s->ssl));

        s->next = NULL;

        if (Run.mailservers) {
                MailServer_T l;
                for (l = Run.mailservers; l->next; l = l->next)
                        /* empty */;
                l->next = s;
        } else {
                Run.mailservers = s;
        }
        reset_mailserverset();
}


/*
 * Return uid if found on the system. If the parameter user is NULL
 * the uid parameter is used for looking up the user id on the system,
 * otherwise the user parameter is used.
 */
static uid_t get_uid(char *user, uid_t uid) {
        char buf[4096];
        struct passwd pwd, *result = NULL;
        if (user) {
                if (getpwnam_r(user, &pwd, buf, sizeof(buf), &result) != 0 || ! result) {
                        yyerror2("Requested user not found on the system");
                        return(0);
                }
        } else {
                if (getpwuid_r(uid, &pwd, buf, sizeof(buf), &result) != 0 || ! result) {
                        yyerror2("Requested uid not found on the system");
                        return(0);
                }
        }
        return(pwd.pw_uid);
}


/*
 * Return gid if found on the system. If the parameter group is NULL
 * the gid parameter is used for looking up the group id on the system,
 * otherwise the group parameter is used.
 */
static gid_t get_gid(char *group, gid_t gid) {
        struct group *grd;

        if (group) {
                grd = getgrnam(group);

                if (! grd) {
                        yyerror2("Requested group not found on the system");
                        return(0);
                }

        } else {

                if (! (grd = getgrgid(gid))) {
                        yyerror2("Requested gid not found on the system");
                        return(0);
                }

        }

        return(grd->gr_gid);

}


/*
 * Add a new user id to the current command object.
 */
static void addeuid(uid_t uid) {
        if (! getuid()) {
                command->has_uid = true;
                command->uid = uid;
        } else {
                yyerror("UID statement requires root privileges");
        }
}


/*
 * Add a new group id to the current command object.
 */
static void addegid(gid_t gid) {
        if (! getuid()) {
                command->has_gid = true;
                command->gid = gid;
        } else {
                yyerror("GID statement requires root privileges");
        }
}


/*
 * Reset the logfile if changed
 */
static void setlogfile(char *logfile) {
        if (Run.files.log) {
                if (IS(Run.files.log, logfile)) {
                        FREE(logfile);
                        return;
                } else {
                        FREE(Run.files.log);
                }
        }
        Run.files.log = logfile;
}


/*
 * Reset the pidfile if changed
 */
static void setpidfile(char *pidfile) {
        if (Run.files.pid) {
                if (IS(Run.files.pid, pidfile)) {
                        FREE(pidfile);
                        return;
                } else {
                        FREE(Run.files.pid);
                }
        }
        Run.files.pid = pidfile;
}


/*
 * Read a apache htpasswd file and add credentials found for username
 */
static void addhtpasswdentry(char *filename, char *username, Digest_Type dtype) {
        char *ht_username = NULL;
        char *ht_passwd = NULL;
        char buf[STRLEN];
        FILE *handle = NULL;
        int credentials_added = 0;

        ASSERT(filename);

        handle = fopen(filename, "r");

        if (handle == NULL) {
                if (username != NULL)
                        yyerror2("Cannot read htpasswd (%s)", filename);
                else
                        yyerror2("Cannot read htpasswd", filename);
                return;
        }

        while (! feof(handle)) {
                char *colonindex = NULL;

                if (! fgets(buf, STRLEN, handle))
                        continue;

                Str_rtrim(buf);
                Str_curtail(buf, "#");

                if (NULL == (colonindex = strchr(buf, ':')))
                continue;

                ht_passwd = Str_dup(colonindex+1);
                *colonindex = '\0';

                /* In case we have a file in /etc/passwd or /etc/shadow style we
                 *  want to remove ":.*$" and Crypt and MD5 hashed dont have a colon
                 */

                if ((NULL != (colonindex = strchr(ht_passwd, ':'))) && (dtype != Digest_Cleartext))
                        *colonindex = '\0';

                ht_username = Str_dup(buf);

                if (username == NULL) {
                        if (addcredentials(ht_username, ht_passwd, dtype, false))
                                credentials_added++;
                } else if (Str_cmp(username, ht_username) == 0)  {
                        if (addcredentials(ht_username, ht_passwd, dtype, false))
                                credentials_added++;
                } else {
                        FREE(ht_passwd);
                        FREE(ht_username);
                }
        }

        if (credentials_added == 0) {
                if (username == NULL)
                        yywarning2("htpasswd file (%s) has no usable credentials", filename);
                else
                        yywarning2("htpasswd file (%s) has no usable credentials for user %s", filename, username);
        }
        fclose(handle);
}


#ifdef HAVE_LIBPAM
static void addpamauth(char* groupname, int readonly) {
        Auth_T prev = NULL;

        ASSERT(groupname);

        if (! Run.httpd.credentials)
                NEW(Run.httpd.credentials);

        Auth_T c = Run.httpd.credentials;
        do {
                if (c->groupname != NULL && IS(c->groupname, groupname)) {
                        yywarning2("PAM group %s was added already, entry ignored", groupname);
                        FREE(groupname);
                        return;
                }
                prev = c;
                c = c->next;
        } while (c != NULL);

        NEW(prev->next);
        c = prev->next;

        c->next        = NULL;
        c->uname       = NULL;
        c->passwd      = NULL;
        c->groupname   = groupname;
        c->digesttype  = Digest_Pam;
        c->is_readonly = readonly;

        DEBUG("Adding PAM group '%s'\n", groupname);

        return;
}
#endif


/*
 * Add Basic Authentication credentials
 */
static boolean_t addcredentials(char *uname, char *passwd, Digest_Type dtype, boolean_t readonly) {
        Auth_T c;

        ASSERT(uname);
        ASSERT(passwd);

        if (strlen(passwd) > MAX_CONSTANT_TIME_STRING_LENGTH) {
                yyerror2("Password for user %s is too long, maximum %d allowed", uname, MAX_CONSTANT_TIME_STRING_LENGTH);
                FREE(uname);
                FREE(passwd);
                return false;
        }

        if (! Run.httpd.credentials) {
                NEW(Run.httpd.credentials);
                c = Run.httpd.credentials;
        } else {
                if (Util_getUserCredentials(uname) != NULL) {
                        yywarning2("Credentials for user %s were already added, entry ignored", uname);
                        FREE(uname);
                        FREE(passwd);
                        return false;
                }
                c = Run.httpd.credentials;
                while (c->next != NULL)
                        c = c->next;
                NEW(c->next);
                c = c->next;
        }

        c->next        = NULL;
        c->uname       = uname;
        c->passwd      = passwd;
        c->groupname   = NULL;
        c->digesttype  = dtype;
        c->is_readonly = readonly;

        DEBUG("Adding credentials for user '%s'\n", uname);

        return true;

}


/*
 * Set the syslog and the facilities to be used
 */
static void setsyslog(char *facility) {

        if (! Run.files.log || ihp.logfile) {
                ihp.logfile = true;
                setlogfile(Str_dup("syslog"));
                Run.flags |= Run_UseSyslog;
                Run.flags |= Run_Log;
        }

        if (facility) {
                if (IS(facility,"log_local0"))
                        Run.facility = LOG_LOCAL0;
                else if (IS(facility, "log_local1"))
                        Run.facility = LOG_LOCAL1;
                else if (IS(facility, "log_local2"))
                        Run.facility = LOG_LOCAL2;
                else if (IS(facility, "log_local3"))
                        Run.facility = LOG_LOCAL3;
                else if (IS(facility, "log_local4"))
                        Run.facility = LOG_LOCAL4;
                else if (IS(facility, "log_local5"))
                        Run.facility = LOG_LOCAL5;
                else if (IS(facility, "log_local6"))
                        Run.facility = LOG_LOCAL6;
                else if (IS(facility, "log_local7"))
                        Run.facility = LOG_LOCAL7;
                else if (IS(facility, "log_daemon"))
                        Run.facility = LOG_DAEMON;
                else
                        yyerror2("Invalid syslog facility");
        } else {
                Run.facility = LOG_USER;
        }

}


/*
 * Reset the current sslset for reuse
 */
static void reset_sslset() {
        memset(&sslset, 0, sizeof(struct SslOptions_T));
        sslset.version = sslset.verify = sslset.allowSelfSigned = -1;
}


/*
 * Reset the current mailset for reuse
 */
static void reset_mailset() {
        memset(&mailset, 0, sizeof(struct Mail_T));
}


/*
 * Reset the mailserver set to default values
 */
static void reset_mailserverset() {
        memset(&mailserverset, 0, sizeof(struct MailServer_T));
        mailserverset.port = PORT_SMTP;
}


/*
 * Reset the mmonit set to default values
 */
static void reset_mmonitset() {
        memset(&mmonitset, 0, sizeof(struct Mmonit_T));
        mmonitset.timeout = Run.limits.networkTimeout;
}


/*
 * Reset the Port set to default values
 */
static void reset_portset() {
        memset(&portset, 0, sizeof(struct Port_T));
        portset.socket = -1;
        portset.type = Socket_Tcp;
        portset.family = Socket_Ip;
        portset.timeout = Run.limits.networkTimeout;
        portset.retry = 1;
        portset.protocol = Protocol_get(Protocol_DEFAULT);
        urlrequest = NULL;
}


/*
 * Reset the Proc set to default values
 */
static void reset_resourceset() {
        resourceset.resource_id = 0;
        resourceset.limit = 0;
        resourceset.action = NULL;
        resourceset.operator = Operator_Equal;
}


/*
 * Reset the Timestamp set to default values
 */
static void reset_timestampset() {
        timestampset.type = Timestamp_Default;
        timestampset.operator = Operator_Equal;
        timestampset.time = 0;
        timestampset.test_changes = false;
        timestampset.initialized = false;
        timestampset.action = NULL;
}


/*
 * Reset the ActionRate set to default values
 */
static void reset_actionrateset() {
        actionrateset.count = 0;
        actionrateset.cycle = 0;
        actionrateset.action = NULL;
}


/*
 * Reset the Size set to default values
 */
static void reset_sizeset() {
        sizeset.operator = Operator_Equal;
        sizeset.size = 0;
        sizeset.test_changes = false;
        sizeset.action = NULL;
}


/*
 * Reset the Uptime set to default values
 */
static void reset_uptimeset() {
        uptimeset.operator = Operator_Equal;
        uptimeset.uptime = 0;
        uptimeset.action = NULL;
}


static void reset_linkstatusset() {
        linkstatusset.action = NULL;
}


static void reset_linkspeedset() {
        linkspeedset.action = NULL;
}


static void reset_linksaturationset() {
        linksaturationset.limit = 0.;
        linksaturationset.operator = Operator_Equal;
        linksaturationset.action = NULL;
}


/*
 * Reset the Bandwidth set to default values
 */
static void reset_bandwidthset() {
        bandwidthset.operator = Operator_Equal;
        bandwidthset.limit = 0ULL;
        bandwidthset.action = NULL;
}


/*
 * Reset the Pid set to default values
 */
static void reset_pidset() {
        pidset.action = NULL;
}


/*
 * Reset the PPid set to default values
 */
static void reset_ppidset() {
        ppidset.action = NULL;
}


/*
 * Reset the Fsflag set to default values
 */
static void reset_fsflagset() {
        fsflagset.action = NULL;
}


/*
 * Reset the Nonexist set to default values
 */
static void reset_nonexistset() {
        nonexistset.action = NULL;
}


static void reset_existset() {
        existset.action = NULL;
}


/*
 * Reset the Checksum set to default values
 */
static void reset_checksumset() {
        checksumset.type         = Hash_Unknown;
        checksumset.test_changes = false;
        checksumset.action       = NULL;
        *checksumset.hash        = 0;
}


/*
 * Reset the Perm set to default values
 */
static void reset_permset() {
        permset.test_changes = false;
        permset.perm = 0;
        permset.action = NULL;
}


/*
 * Reset the Status set to default values
 */
static void reset_statusset() {
        statusset.initialized = false;
        statusset.return_value = 0;
        statusset.operator = Operator_Equal;
        statusset.action = NULL;
}


/*
 * Reset the Uid set to default values
 */
static void reset_uidset() {
        uidset.uid = 0;
        uidset.action = NULL;
}


/*
 * Reset the Gid set to default values
 */
static void reset_gidset() {
        gidset.gid = 0;
        gidset.action = NULL;
}


/*
 * Reset the Filesystem set to default values
 */
static void reset_filesystemset() {
        filesystemset.resource = 0;
        filesystemset.operator = Operator_Equal;
        filesystemset.limit_absolute = -1;
        filesystemset.limit_percent = -1.;
        filesystemset.action = NULL;
}


/*
 * Reset the ICMP set to default values
 */
static void reset_icmpset() {
        icmpset.type = ICMP_ECHO;
        icmpset.size = ICMP_SIZE;
        icmpset.count = ICMP_ATTEMPT_COUNT;
        icmpset.timeout = Run.limits.networkTimeout;
        icmpset.action = NULL;
}


/*
 * Reset the Rate set to default values
 */
static void reset_rateset(struct rate_t *r) {
        r->count = 1;
        r->cycles = 1;
}


/* ---------------------------------------------------------------- Checkers */


/*
 * Check for unique service name
 */
static void check_name(char *name) {
        ASSERT(name);

        if (Util_existService(name) || (current && IS(name, current->name)))
                yyerror2("Service name conflict, %s already defined", name);
        if (name && *name == '/')
                yyerror2("Service name '%s' must not start with '/' -- ", name);
}


/*
 * Permission statement semantic check
 */
static int check_perm(int perm) {
        int result;
        char *status;
        char buf[STRLEN];

        snprintf(buf, STRLEN, "%d", perm);

        result = (int)strtol(buf, &status, 8);

        if (*status != '\0' || result < 0 || result > 07777)
                yyerror2("Permission statements must have an octal value between 0 and 7777");

        return result;
}


/*
 * Check the dependency graph for errors
 * by doing a topological sort, thereby finding any cycles.
 * Assures that graph is a Directed Acyclic Graph (DAG).
 */
static void check_depend() {
        Service_T s;
        Service_T depends_on = NULL;
        Service_T* dlt = &depend_list; /* the current tail of it                                 */
        boolean_t done;                /* no unvisited nodes left?                               */
        boolean_t found_some;          /* last iteration found anything new ?                    */
        depend_list = NULL;            /* depend_list will be the topological sorted servicelist */

        do {
                done = true;
                found_some = false;
                for (s = servicelist; s; s = s->next) {
                        Dependant_T d;
                        if (s->visited)
                                continue;
                        done = false; // still unvisited nodes
                        depends_on = NULL;
                        for (d = s->dependantlist; d; d = d->next) {
                                Service_T dp = Util_getService(d->dependant);
                                if (! dp) {
                                        LogError("Depend service '%s' is not defined in the control file\n", d->dependant);
                                        exit(1);
                                }
                                if (! dp->visited) {
                                        depends_on = dp;
                                }
                        }

                        if (! depends_on) {
                                s->visited = true;
                                found_some = true;
                                *dlt = s;
                                dlt = &s->next_depend;
                        }
                }
        } while (found_some && ! done);

        if (! done) {
                ASSERT(depends_on);
                LogError("Found a depend loop in the control file involving the service '%s'\n", depends_on->name);
                exit(1);
        }

        ASSERT(depend_list);
        servicelist = depend_list;

        for (s = depend_list; s; s = s->next_depend)
                s->next = s->next_depend;
}


/*
 * Check if the executable exist
 */
static void check_exec(char *exec) {
        if (! File_exist(exec))
                yywarning2("Program does not exist:");
        else if (! File_isExecutable(exec))
                yywarning2("Program is not executable:");
}


/* Return a valid max forward value for SIP header */
static int verifyMaxForward(int mf) {
        if (mf == 0) {
                return INT_MAX; // Differentiate unitialized (0) and explicit zero
        } else if (mf > 0 && mf <= 255) {
                return mf;
        }
        yywarning2("SIP max forward is outside the range [0..255]. Setting max forward to 70");
        return 70;
}


/* -------------------------------------------------------------------- Misc */


/*
 * Cleans up a hash string, tolower and remove byte separators
 */
static int cleanup_hash_string(char *hashstring) {
        int i = 0, j = 0;

        ASSERT(hashstring);

        while (hashstring[i]) {
                if (isxdigit((int)hashstring[i])) {
                        hashstring[j] = tolower((int)hashstring[i]);
                        j++;
                }
                i++;
        }
        hashstring[j] = 0;
        return j;
}


/* Return deep copy of the command */
static command_t copycommand(command_t source) {
        int i;
        command_t copy = NULL;

        NEW(copy);
        copy->length = source->length;
        copy->has_uid = source->has_uid;
        copy->uid = source->uid;
        copy->has_gid = source->has_gid;
        copy->gid = source->gid;
        copy->timeout = source->timeout;
        for (i = 0; i < copy->length; i++)
                copy->arg[i] = Str_dup(source->arg[i]);
        copy->arg[copy->length] = NULL;

        return copy;
}


static void _setPEM(char **store, char *path, const char *description, boolean_t isFile) {
        if (*store) {
                yyerror2("Duplicate %s", description);
        } else if (! File_exist(path)) {
                yyerror2("%s doesn't exist", description);
        } else if (! (isFile ? File_isFile(path) : File_isDirectory(path))) {
                yyerror2("%s is not a %s", description, isFile ? "file" : "directory");
        } else if (! File_isReadable(path)) {
                yyerror2("Cannot read %s", description);
        } else {
                sslset.flags = SSL_Enabled;
                *store = path;
        }
}


static void _setSSLOptions(SslOptions_T options) {
        options->allowSelfSigned = sslset.allowSelfSigned;
        options->CACertificateFile = sslset.CACertificateFile;
        options->CACertificatePath = sslset.CACertificatePath;
        options->checksum = sslset.checksum;
        options->checksumType = sslset.checksumType;
        options->ciphers = sslset.ciphers;
        options->clientpemfile = sslset.clientpemfile;
        options->flags = sslset.flags;
        options->pemfile = sslset.pemfile;
        options->verify = sslset.verify;
        options->version = sslset.version;
        reset_sslset();
}

static void addsecurityattribute(char *value, Action_Type failed, Action_Type succeeded) {
        SecurityAttribute_T attr;
        NEW(attr);
        addeventaction(&(attr->action), failed, succeeded);
        attr->attribute = value;
        attr->next = current->secattrlist;
        current->secattrlist = attr;
}

