/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 26 "src/p.y" /* yacc.c:339  */


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


#line 350 "src/y.tab.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "y.tab.h".  */
#ifndef YY_YY_SRC_Y_TAB_H_INCLUDED
# define YY_YY_SRC_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    IF = 258,
    ELSE = 259,
    THEN = 260,
    FAILED = 261,
    SET = 262,
    LOGFILE = 263,
    FACILITY = 264,
    DAEMON = 265,
    SYSLOG = 266,
    MAILSERVER = 267,
    HTTPD = 268,
    ALLOW = 269,
    REJECTOPT = 270,
    ADDRESS = 271,
    INIT = 272,
    TERMINAL = 273,
    BATCH = 274,
    READONLY = 275,
    CLEARTEXT = 276,
    MD5HASH = 277,
    SHA1HASH = 278,
    CRYPT = 279,
    DELAY = 280,
    PEMFILE = 281,
    ENABLE = 282,
    DISABLE = 283,
    SSL = 284,
    CIPHER = 285,
    CLIENTPEMFILE = 286,
    ALLOWSELFCERTIFICATION = 287,
    SELFSIGNED = 288,
    VERIFY = 289,
    CERTIFICATE = 290,
    CACERTIFICATEFILE = 291,
    CACERTIFICATEPATH = 292,
    VALID = 293,
    INTERFACE = 294,
    LINK = 295,
    PACKET = 296,
    BYTEIN = 297,
    BYTEOUT = 298,
    PACKETIN = 299,
    PACKETOUT = 300,
    SPEED = 301,
    SATURATION = 302,
    UPLOAD = 303,
    DOWNLOAD = 304,
    TOTAL = 305,
    IDFILE = 306,
    STATEFILE = 307,
    SEND = 308,
    EXPECT = 309,
    CYCLE = 310,
    COUNT = 311,
    REMINDER = 312,
    REPEAT = 313,
    LIMITS = 314,
    SENDEXPECTBUFFER = 315,
    EXPECTBUFFER = 316,
    FILECONTENTBUFFER = 317,
    HTTPCONTENTBUFFER = 318,
    PROGRAMOUTPUT = 319,
    NETWORKTIMEOUT = 320,
    PROGRAMTIMEOUT = 321,
    STARTTIMEOUT = 322,
    STOPTIMEOUT = 323,
    RESTARTTIMEOUT = 324,
    PIDFILE = 325,
    START = 326,
    STOP = 327,
    PATHTOK = 328,
    HOST = 329,
    HOSTNAME = 330,
    PORT = 331,
    IPV4 = 332,
    IPV6 = 333,
    TYPE = 334,
    UDP = 335,
    TCP = 336,
    TCPSSL = 337,
    PROTOCOL = 338,
    CONNECTION = 339,
    ALERT = 340,
    NOALERT = 341,
    MAILFORMAT = 342,
    UNIXSOCKET = 343,
    SIGNATURE = 344,
    TIMEOUT = 345,
    RETRY = 346,
    RESTART = 347,
    CHECKSUM = 348,
    EVERY = 349,
    NOTEVERY = 350,
    DEFAULT = 351,
    HTTP = 352,
    HTTPS = 353,
    APACHESTATUS = 354,
    FTP = 355,
    SMTP = 356,
    SMTPS = 357,
    POP = 358,
    POPS = 359,
    IMAP = 360,
    IMAPS = 361,
    CLAMAV = 362,
    NNTP = 363,
    NTP3 = 364,
    MYSQL = 365,
    DNS = 366,
    WEBSOCKET = 367,
    SSH = 368,
    DWP = 369,
    LDAP2 = 370,
    LDAP3 = 371,
    RDATE = 372,
    RSYNC = 373,
    TNS = 374,
    PGSQL = 375,
    POSTFIXPOLICY = 376,
    SIP = 377,
    LMTP = 378,
    GPS = 379,
    RADIUS = 380,
    MEMCACHE = 381,
    REDIS = 382,
    MONGODB = 383,
    SIEVE = 384,
    SPAMASSASSIN = 385,
    FAIL2BAN = 386,
    STRING = 387,
    PATH = 388,
    MAILADDR = 389,
    MAILFROM = 390,
    MAILREPLYTO = 391,
    MAILSUBJECT = 392,
    MAILBODY = 393,
    SERVICENAME = 394,
    STRINGNAME = 395,
    NUMBER = 396,
    PERCENT = 397,
    LOGLIMIT = 398,
    CLOSELIMIT = 399,
    DNSLIMIT = 400,
    KEEPALIVELIMIT = 401,
    REPLYLIMIT = 402,
    REQUESTLIMIT = 403,
    STARTLIMIT = 404,
    WAITLIMIT = 405,
    GRACEFULLIMIT = 406,
    CLEANUPLIMIT = 407,
    REAL = 408,
    CHECKPROC = 409,
    CHECKFILESYS = 410,
    CHECKFILE = 411,
    CHECKDIR = 412,
    CHECKHOST = 413,
    CHECKSYSTEM = 414,
    CHECKFIFO = 415,
    CHECKPROGRAM = 416,
    CHECKNET = 417,
    THREADS = 418,
    CHILDREN = 419,
    METHOD = 420,
    GET = 421,
    HEAD = 422,
    STATUS = 423,
    ORIGIN = 424,
    VERSIONOPT = 425,
    READ = 426,
    WRITE = 427,
    OPERATION = 428,
    SERVICETIME = 429,
    DISK = 430,
    RESOURCE = 431,
    MEMORY = 432,
    TOTALMEMORY = 433,
    LOADAVG1 = 434,
    LOADAVG5 = 435,
    LOADAVG15 = 436,
    SWAP = 437,
    MODE = 438,
    ACTIVE = 439,
    PASSIVE = 440,
    MANUAL = 441,
    ONREBOOT = 442,
    NOSTART = 443,
    LASTSTATE = 444,
    CPU = 445,
    TOTALCPU = 446,
    CPUUSER = 447,
    CPUSYSTEM = 448,
    CPUWAIT = 449,
    GROUP = 450,
    REQUEST = 451,
    DEPENDS = 452,
    BASEDIR = 453,
    SLOT = 454,
    EVENTQUEUE = 455,
    SECRET = 456,
    HOSTHEADER = 457,
    UID = 458,
    EUID = 459,
    GID = 460,
    MMONIT = 461,
    INSTANCE = 462,
    USERNAME = 463,
    PASSWORD = 464,
    TIME = 465,
    ATIME = 466,
    CTIME = 467,
    MTIME = 468,
    CHANGED = 469,
    MILLISECOND = 470,
    SECOND = 471,
    MINUTE = 472,
    HOUR = 473,
    DAY = 474,
    MONTH = 475,
    SSLAUTO = 476,
    SSLV2 = 477,
    SSLV3 = 478,
    TLSV1 = 479,
    TLSV11 = 480,
    TLSV12 = 481,
    TLSV13 = 482,
    CERTMD5 = 483,
    AUTO = 484,
    BYTE = 485,
    KILOBYTE = 486,
    MEGABYTE = 487,
    GIGABYTE = 488,
    INODE = 489,
    SPACE = 490,
    TFREE = 491,
    PERMISSION = 492,
    SIZE = 493,
    MATCH = 494,
    NOT = 495,
    IGNORE = 496,
    ACTION = 497,
    UPTIME = 498,
    EXEC = 499,
    UNMONITOR = 500,
    PING = 501,
    PING4 = 502,
    PING6 = 503,
    ICMP = 504,
    ICMPECHO = 505,
    NONEXIST = 506,
    EXIST = 507,
    INVALID = 508,
    DATA = 509,
    RECOVERED = 510,
    PASSED = 511,
    SUCCEEDED = 512,
    URL = 513,
    CONTENT = 514,
    PID = 515,
    PPID = 516,
    FSFLAG = 517,
    REGISTER = 518,
    CREDENTIALS = 519,
    URLOBJECT = 520,
    ADDRESSOBJECT = 521,
    TARGET = 522,
    TIMESPEC = 523,
    HTTPHEADER = 524,
    MAXFORWARD = 525,
    FIPS = 526,
    SECURITY = 527,
    ATTRIBUTE = 528,
    GREATER = 529,
    GREATEROREQUAL = 530,
    LESS = 531,
    LESSOREQUAL = 532,
    EQUAL = 533,
    NOTEQUAL = 534
  };
#endif
/* Tokens.  */
#define IF 258
#define ELSE 259
#define THEN 260
#define FAILED 261
#define SET 262
#define LOGFILE 263
#define FACILITY 264
#define DAEMON 265
#define SYSLOG 266
#define MAILSERVER 267
#define HTTPD 268
#define ALLOW 269
#define REJECTOPT 270
#define ADDRESS 271
#define INIT 272
#define TERMINAL 273
#define BATCH 274
#define READONLY 275
#define CLEARTEXT 276
#define MD5HASH 277
#define SHA1HASH 278
#define CRYPT 279
#define DELAY 280
#define PEMFILE 281
#define ENABLE 282
#define DISABLE 283
#define SSL 284
#define CIPHER 285
#define CLIENTPEMFILE 286
#define ALLOWSELFCERTIFICATION 287
#define SELFSIGNED 288
#define VERIFY 289
#define CERTIFICATE 290
#define CACERTIFICATEFILE 291
#define CACERTIFICATEPATH 292
#define VALID 293
#define INTERFACE 294
#define LINK 295
#define PACKET 296
#define BYTEIN 297
#define BYTEOUT 298
#define PACKETIN 299
#define PACKETOUT 300
#define SPEED 301
#define SATURATION 302
#define UPLOAD 303
#define DOWNLOAD 304
#define TOTAL 305
#define IDFILE 306
#define STATEFILE 307
#define SEND 308
#define EXPECT 309
#define CYCLE 310
#define COUNT 311
#define REMINDER 312
#define REPEAT 313
#define LIMITS 314
#define SENDEXPECTBUFFER 315
#define EXPECTBUFFER 316
#define FILECONTENTBUFFER 317
#define HTTPCONTENTBUFFER 318
#define PROGRAMOUTPUT 319
#define NETWORKTIMEOUT 320
#define PROGRAMTIMEOUT 321
#define STARTTIMEOUT 322
#define STOPTIMEOUT 323
#define RESTARTTIMEOUT 324
#define PIDFILE 325
#define START 326
#define STOP 327
#define PATHTOK 328
#define HOST 329
#define HOSTNAME 330
#define PORT 331
#define IPV4 332
#define IPV6 333
#define TYPE 334
#define UDP 335
#define TCP 336
#define TCPSSL 337
#define PROTOCOL 338
#define CONNECTION 339
#define ALERT 340
#define NOALERT 341
#define MAILFORMAT 342
#define UNIXSOCKET 343
#define SIGNATURE 344
#define TIMEOUT 345
#define RETRY 346
#define RESTART 347
#define CHECKSUM 348
#define EVERY 349
#define NOTEVERY 350
#define DEFAULT 351
#define HTTP 352
#define HTTPS 353
#define APACHESTATUS 354
#define FTP 355
#define SMTP 356
#define SMTPS 357
#define POP 358
#define POPS 359
#define IMAP 360
#define IMAPS 361
#define CLAMAV 362
#define NNTP 363
#define NTP3 364
#define MYSQL 365
#define DNS 366
#define WEBSOCKET 367
#define SSH 368
#define DWP 369
#define LDAP2 370
#define LDAP3 371
#define RDATE 372
#define RSYNC 373
#define TNS 374
#define PGSQL 375
#define POSTFIXPOLICY 376
#define SIP 377
#define LMTP 378
#define GPS 379
#define RADIUS 380
#define MEMCACHE 381
#define REDIS 382
#define MONGODB 383
#define SIEVE 384
#define SPAMASSASSIN 385
#define FAIL2BAN 386
#define STRING 387
#define PATH 388
#define MAILADDR 389
#define MAILFROM 390
#define MAILREPLYTO 391
#define MAILSUBJECT 392
#define MAILBODY 393
#define SERVICENAME 394
#define STRINGNAME 395
#define NUMBER 396
#define PERCENT 397
#define LOGLIMIT 398
#define CLOSELIMIT 399
#define DNSLIMIT 400
#define KEEPALIVELIMIT 401
#define REPLYLIMIT 402
#define REQUESTLIMIT 403
#define STARTLIMIT 404
#define WAITLIMIT 405
#define GRACEFULLIMIT 406
#define CLEANUPLIMIT 407
#define REAL 408
#define CHECKPROC 409
#define CHECKFILESYS 410
#define CHECKFILE 411
#define CHECKDIR 412
#define CHECKHOST 413
#define CHECKSYSTEM 414
#define CHECKFIFO 415
#define CHECKPROGRAM 416
#define CHECKNET 417
#define THREADS 418
#define CHILDREN 419
#define METHOD 420
#define GET 421
#define HEAD 422
#define STATUS 423
#define ORIGIN 424
#define VERSIONOPT 425
#define READ 426
#define WRITE 427
#define OPERATION 428
#define SERVICETIME 429
#define DISK 430
#define RESOURCE 431
#define MEMORY 432
#define TOTALMEMORY 433
#define LOADAVG1 434
#define LOADAVG5 435
#define LOADAVG15 436
#define SWAP 437
#define MODE 438
#define ACTIVE 439
#define PASSIVE 440
#define MANUAL 441
#define ONREBOOT 442
#define NOSTART 443
#define LASTSTATE 444
#define CPU 445
#define TOTALCPU 446
#define CPUUSER 447
#define CPUSYSTEM 448
#define CPUWAIT 449
#define GROUP 450
#define REQUEST 451
#define DEPENDS 452
#define BASEDIR 453
#define SLOT 454
#define EVENTQUEUE 455
#define SECRET 456
#define HOSTHEADER 457
#define UID 458
#define EUID 459
#define GID 460
#define MMONIT 461
#define INSTANCE 462
#define USERNAME 463
#define PASSWORD 464
#define TIME 465
#define ATIME 466
#define CTIME 467
#define MTIME 468
#define CHANGED 469
#define MILLISECOND 470
#define SECOND 471
#define MINUTE 472
#define HOUR 473
#define DAY 474
#define MONTH 475
#define SSLAUTO 476
#define SSLV2 477
#define SSLV3 478
#define TLSV1 479
#define TLSV11 480
#define TLSV12 481
#define TLSV13 482
#define CERTMD5 483
#define AUTO 484
#define BYTE 485
#define KILOBYTE 486
#define MEGABYTE 487
#define GIGABYTE 488
#define INODE 489
#define SPACE 490
#define TFREE 491
#define PERMISSION 492
#define SIZE 493
#define MATCH 494
#define NOT 495
#define IGNORE 496
#define ACTION 497
#define UPTIME 498
#define EXEC 499
#define UNMONITOR 500
#define PING 501
#define PING4 502
#define PING6 503
#define ICMP 504
#define ICMPECHO 505
#define NONEXIST 506
#define EXIST 507
#define INVALID 508
#define DATA 509
#define RECOVERED 510
#define PASSED 511
#define SUCCEEDED 512
#define URL 513
#define CONTENT 514
#define PID 515
#define PPID 516
#define FSFLAG 517
#define REGISTER 518
#define CREDENTIALS 519
#define URLOBJECT 520
#define ADDRESSOBJECT 521
#define TARGET 522
#define TIMESPEC 523
#define HTTPHEADER 524
#define MAXFORWARD 525
#define FIPS 526
#define SECURITY 527
#define ATTRIBUTE 528
#define GREATER 529
#define GREATEROREQUAL 530
#define LESS 531
#define LESSOREQUAL 532
#define EQUAL 533
#define NOTEQUAL 534

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 310 "src/p.y" /* yacc.c:355  */

        URL_T url;
        Address_T address;
        float real;
        int   number;
        char *string;

#line 956 "src/y.tab.c" /* yacc.c:355  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SRC_Y_TAB_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 973 "src/y.tab.c" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  69
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1703

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  286
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  238
/* YYNRULES -- Number of rules.  */
#define YYNRULES  776
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  1453

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   534

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint16 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,   282,     2,
       2,     2,     2,     2,   283,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,   284,     2,   285,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,   280,     2,   281,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
      85,    86,    87,    88,    89,    90,    91,    92,    93,    94,
      95,    96,    97,    98,    99,   100,   101,   102,   103,   104,
     105,   106,   107,   108,   109,   110,   111,   112,   113,   114,
     115,   116,   117,   118,   119,   120,   121,   122,   123,   124,
     125,   126,   127,   128,   129,   130,   131,   132,   133,   134,
     135,   136,   137,   138,   139,   140,   141,   142,   143,   144,
     145,   146,   147,   148,   149,   150,   151,   152,   153,   154,
     155,   156,   157,   158,   159,   160,   161,   162,   163,   164,
     165,   166,   167,   168,   169,   170,   171,   172,   173,   174,
     175,   176,   177,   178,   179,   180,   181,   182,   183,   184,
     185,   186,   187,   188,   189,   190,   191,   192,   193,   194,
     195,   196,   197,   198,   199,   200,   201,   202,   203,   204,
     205,   206,   207,   208,   209,   210,   211,   212,   213,   214,
     215,   216,   217,   218,   219,   220,   221,   222,   223,   224,
     225,   226,   227,   228,   229,   230,   231,   232,   233,   234,
     235,   236,   237,   238,   239,   240,   241,   242,   243,   244,
     245,   246,   247,   248,   249,   250,   251,   252,   253,   254,
     255,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   361,   361,   362,   365,   366,   369,   370,   371,   372,
     373,   374,   375,   376,   377,   378,   379,   380,   381,   382,
     383,   384,   385,   386,   387,   388,   389,   390,   391,   392,
     393,   394,   395,   398,   399,   402,   403,   404,   405,   406,
     407,   408,   409,   410,   411,   412,   413,   414,   415,   416,
     417,   418,   419,   420,   421,   422,   423,   426,   427,   430,
     431,   432,   433,   434,   435,   436,   437,   438,   439,   440,
     441,   442,   443,   444,   445,   446,   447,   450,   451,   454,
     455,   456,   457,   458,   459,   460,   461,   462,   463,   464,
     465,   466,   467,   468,   469,   470,   471,   472,   473,   476,
     477,   480,   481,   482,   483,   484,   485,   486,   487,   488,
     489,   490,   491,   492,   493,   494,   497,   498,   501,   502,
     503,   504,   505,   506,   507,   508,   509,   510,   511,   512,
     513,   516,   517,   520,   521,   522,   523,   524,   525,   526,
     527,   528,   529,   530,   531,   532,   533,   534,   537,   538,
     541,   542,   543,   544,   545,   546,   547,   548,   549,   550,
     551,   552,   555,   556,   559,   560,   561,   562,   563,   564,
     565,   566,   567,   568,   569,   570,   571,   572,   573,   576,
     577,   580,   581,   582,   583,   584,   585,   586,   587,   588,
     589,   590,   593,   597,   600,   606,   616,   621,   624,   629,
     634,   637,   640,   645,   651,   654,   655,   658,   661,   664,
     667,   670,   673,   676,   679,   682,   685,   688,   691,   694,
     697,   702,   707,   715,   718,   723,   726,   730,   736,   741,
     746,   754,   757,   758,   761,   767,   768,   771,   774,   775,
     776,   777,   780,   781,   786,   791,   794,   797,   798,   801,
     805,   809,   813,   817,   820,   824,   827,   830,   833,   838,
     844,   845,   848,   862,   869,   878,   879,   882,   886,   890,
     894,   902,   910,   919,   923,   929,   938,   945,   960,   961,
     964,   973,   984,   985,   988,   991,   994,   995,   996,   997,
    1000,  1017,  1018,  1021,  1022,  1023,  1024,  1025,  1026,  1027,
    1028,  1029,  1033,  1039,  1045,  1051,  1057,  1063,  1064,  1067,
    1072,  1077,  1081,  1085,  1091,  1092,  1095,  1096,  1099,  1102,
    1107,  1112,  1115,  1123,  1127,  1131,  1135,  1139,  1139,  1146,
    1146,  1153,  1153,  1160,  1160,  1167,  1174,  1175,  1178,  1184,
    1187,  1192,  1195,  1198,  1205,  1214,  1219,  1222,  1227,  1232,
    1237,  1245,  1251,  1266,  1271,  1279,  1289,  1292,  1297,  1300,
    1306,  1309,  1314,  1315,  1318,  1319,  1322,  1325,  1330,  1334,
    1338,  1341,  1346,  1349,  1354,  1359,  1362,  1367,  1376,  1377,
    1380,  1381,  1382,  1383,  1384,  1385,  1386,  1387,  1388,  1389,
    1390,  1393,  1400,  1401,  1404,  1405,  1406,  1407,  1408,  1409,
    1412,  1418,  1419,  1422,  1423,  1424,  1425,  1426,  1429,  1435,
    1440,  1445,  1452,  1453,  1456,  1457,  1458,  1459,  1462,  1465,
    1470,  1475,  1481,  1484,  1489,  1492,  1496,  1501,  1502,  1505,
    1506,  1509,  1514,  1517,  1520,  1523,  1526,  1529,  1532,  1535,
    1540,  1543,  1548,  1551,  1554,  1557,  1560,  1563,  1566,  1569,
    1573,  1576,  1579,  1584,  1587,  1590,  1595,  1598,  1601,  1604,
    1607,  1610,  1613,  1616,  1619,  1622,  1625,  1628,  1633,  1641,
    1651,  1652,  1655,  1658,  1661,  1664,  1669,  1670,  1673,  1676,
    1681,  1682,  1685,  1693,  1698,  1701,  1706,  1711,  1712,  1715,
    1718,  1723,  1724,  1727,  1730,  1733,  1734,  1735,  1736,  1737,
    1738,  1741,  1751,  1754,  1759,  1763,  1769,  1774,  1780,  1781,
    1786,  1791,  1792,  1795,  1800,  1801,  1804,  1807,  1810,  1813,
    1817,  1821,  1825,  1829,  1833,  1837,  1841,  1845,  1849,  1855,
    1859,  1866,  1872,  1878,  1885,  1890,  1900,  1905,  1910,  1913,
    1918,  1921,  1926,  1929,  1934,  1937,  1942,  1945,  1950,  1955,
    1960,  1966,  1974,  1980,  1981,  1984,  1988,  1991,  1995,  2000,
    2003,  2006,  2007,  2010,  2011,  2012,  2013,  2014,  2015,  2016,
    2017,  2018,  2019,  2020,  2021,  2022,  2023,  2024,  2025,  2026,
    2027,  2028,  2029,  2030,  2031,  2032,  2033,  2034,  2035,  2036,
    2037,  2038,  2039,  2042,  2043,  2046,  2047,  2050,  2051,  2052,
    2053,  2056,  2060,  2064,  2070,  2073,  2076,  2082,  2085,  2089,
    2094,  2101,  2104,  2105,  2108,  2111,  2118,  2127,  2133,  2134,
    2137,  2138,  2139,  2140,  2141,  2142,  2143,  2146,  2152,  2153,
    2156,  2157,  2158,  2159,  2162,  2167,  2174,  2181,  2182,  2183,
    2184,  2187,  2192,  2199,  2204,  2209,  2214,  2221,  2226,  2233,
    2240,  2247,  2254,  2255,  2256,  2259,  2264,  2271,  2276,  2283,
    2284,  2287,  2288,  2289,  2290,  2293,  2300,  2308,  2309,  2310,
    2311,  2312,  2313,  2314,  2315,  2318,  2319,  2320,  2321,  2322,
    2323,  2326,  2327,  2328,  2330,  2331,  2333,  2336,  2339,  2347,
    2350,  2353,  2357,  2360,  2363,  2366,  2371,  2382,  2393,  2403,
    2415,  2416,  2421,  2428,  2429,  2434,  2441,  2444,  2447,  2450,
    2455,  2459,  2466,  2472,  2473,  2474,  2477,  2484,  2491,  2498,
    2507,  2514,  2521,  2528,  2537,  2544,  2553,  2560,  2569,  2576,
    2585,  2591,  2592,  2593,  2594,  2595,  2598,  2603,  2610,  2618,
    2625,  2633,  2641,  2648,  2654,  2661,  2669,  2672,  2678,  2684,
    2691,  2697,  2704,  2710,  2717,  2720,  2725,  2731,  2738,  2744,
    2749,  2757,  2765,  2773,  2781,  2789,  2797,  2807,  2815,  2823,
    2831,  2839,  2847,  2857,  2860,  2861,  2862
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "IF", "ELSE", "THEN", "FAILED", "SET",
  "LOGFILE", "FACILITY", "DAEMON", "SYSLOG", "MAILSERVER", "HTTPD",
  "ALLOW", "REJECTOPT", "ADDRESS", "INIT", "TERMINAL", "BATCH", "READONLY",
  "CLEARTEXT", "MD5HASH", "SHA1HASH", "CRYPT", "DELAY", "PEMFILE",
  "ENABLE", "DISABLE", "SSL", "CIPHER", "CLIENTPEMFILE",
  "ALLOWSELFCERTIFICATION", "SELFSIGNED", "VERIFY", "CERTIFICATE",
  "CACERTIFICATEFILE", "CACERTIFICATEPATH", "VALID", "INTERFACE", "LINK",
  "PACKET", "BYTEIN", "BYTEOUT", "PACKETIN", "PACKETOUT", "SPEED",
  "SATURATION", "UPLOAD", "DOWNLOAD", "TOTAL", "IDFILE", "STATEFILE",
  "SEND", "EXPECT", "CYCLE", "COUNT", "REMINDER", "REPEAT", "LIMITS",
  "SENDEXPECTBUFFER", "EXPECTBUFFER", "FILECONTENTBUFFER",
  "HTTPCONTENTBUFFER", "PROGRAMOUTPUT", "NETWORKTIMEOUT", "PROGRAMTIMEOUT",
  "STARTTIMEOUT", "STOPTIMEOUT", "RESTARTTIMEOUT", "PIDFILE", "START",
  "STOP", "PATHTOK", "HOST", "HOSTNAME", "PORT", "IPV4", "IPV6", "TYPE",
  "UDP", "TCP", "TCPSSL", "PROTOCOL", "CONNECTION", "ALERT", "NOALERT",
  "MAILFORMAT", "UNIXSOCKET", "SIGNATURE", "TIMEOUT", "RETRY", "RESTART",
  "CHECKSUM", "EVERY", "NOTEVERY", "DEFAULT", "HTTP", "HTTPS",
  "APACHESTATUS", "FTP", "SMTP", "SMTPS", "POP", "POPS", "IMAP", "IMAPS",
  "CLAMAV", "NNTP", "NTP3", "MYSQL", "DNS", "WEBSOCKET", "SSH", "DWP",
  "LDAP2", "LDAP3", "RDATE", "RSYNC", "TNS", "PGSQL", "POSTFIXPOLICY",
  "SIP", "LMTP", "GPS", "RADIUS", "MEMCACHE", "REDIS", "MONGODB", "SIEVE",
  "SPAMASSASSIN", "FAIL2BAN", "STRING", "PATH", "MAILADDR", "MAILFROM",
  "MAILREPLYTO", "MAILSUBJECT", "MAILBODY", "SERVICENAME", "STRINGNAME",
  "NUMBER", "PERCENT", "LOGLIMIT", "CLOSELIMIT", "DNSLIMIT",
  "KEEPALIVELIMIT", "REPLYLIMIT", "REQUESTLIMIT", "STARTLIMIT",
  "WAITLIMIT", "GRACEFULLIMIT", "CLEANUPLIMIT", "REAL", "CHECKPROC",
  "CHECKFILESYS", "CHECKFILE", "CHECKDIR", "CHECKHOST", "CHECKSYSTEM",
  "CHECKFIFO", "CHECKPROGRAM", "CHECKNET", "THREADS", "CHILDREN", "METHOD",
  "GET", "HEAD", "STATUS", "ORIGIN", "VERSIONOPT", "READ", "WRITE",
  "OPERATION", "SERVICETIME", "DISK", "RESOURCE", "MEMORY", "TOTALMEMORY",
  "LOADAVG1", "LOADAVG5", "LOADAVG15", "SWAP", "MODE", "ACTIVE", "PASSIVE",
  "MANUAL", "ONREBOOT", "NOSTART", "LASTSTATE", "CPU", "TOTALCPU",
  "CPUUSER", "CPUSYSTEM", "CPUWAIT", "GROUP", "REQUEST", "DEPENDS",
  "BASEDIR", "SLOT", "EVENTQUEUE", "SECRET", "HOSTHEADER", "UID", "EUID",
  "GID", "MMONIT", "INSTANCE", "USERNAME", "PASSWORD", "TIME", "ATIME",
  "CTIME", "MTIME", "CHANGED", "MILLISECOND", "SECOND", "MINUTE", "HOUR",
  "DAY", "MONTH", "SSLAUTO", "SSLV2", "SSLV3", "TLSV1", "TLSV11", "TLSV12",
  "TLSV13", "CERTMD5", "AUTO", "BYTE", "KILOBYTE", "MEGABYTE", "GIGABYTE",
  "INODE", "SPACE", "TFREE", "PERMISSION", "SIZE", "MATCH", "NOT",
  "IGNORE", "ACTION", "UPTIME", "EXEC", "UNMONITOR", "PING", "PING4",
  "PING6", "ICMP", "ICMPECHO", "NONEXIST", "EXIST", "INVALID", "DATA",
  "RECOVERED", "PASSED", "SUCCEEDED", "URL", "CONTENT", "PID", "PPID",
  "FSFLAG", "REGISTER", "CREDENTIALS", "URLOBJECT", "ADDRESSOBJECT",
  "TARGET", "TIMESPEC", "HTTPHEADER", "MAXFORWARD", "FIPS", "SECURITY",
  "ATTRIBUTE", "GREATER", "GREATEROREQUAL", "LESS", "LESSOREQUAL", "EQUAL",
  "NOTEQUAL", "'{'", "'}'", "':'", "'@'", "'['", "']'", "$accept",
  "cfgfile", "statement_list", "statement", "optproclist", "optproc",
  "optfilelist", "optfile", "optfilesyslist", "optfilesys", "optdirlist",
  "optdir", "opthostlist", "opthost", "optnetlist", "optnet",
  "optsystemlist", "optsystem", "optfifolist", "optfifo", "optprogramlist",
  "optprogram", "setalert", "setdaemon", "setterminal", "startdelay",
  "setinit", "setonreboot", "setexpectbuffer", "setlimits", "limitlist",
  "limit", "setfips", "setlog", "seteventqueue", "setidfile",
  "setstatefile", "setpid", "setmmonits", "mmonitlist", "mmonit",
  "mmonitoptlist", "mmonitopt", "credentials", "setssl", "ssl",
  "ssloptionlist", "ssloption", "sslexpire", "expireoperator",
  "sslchecksum", "checksumoperator", "sslversion", "certmd5",
  "setmailservers", "setmailformat", "mailserverlist", "mailserver",
  "mailserveroptlist", "mailserveropt", "sethttpd", "httpdlist",
  "httpdoption", "pemfile", "clientpemfile", "allowselfcert", "httpdport",
  "httpdsocket", "httpdsocketoptionlist", "httpdsocketoption", "sigenable",
  "sigdisable", "signature", "bindaddress", "allow", "$@1", "$@2", "$@3",
  "$@4", "allowuserlist", "allowuser", "readonly", "checkproc",
  "checkfile", "checkfilesys", "checkdir", "checkhost", "checknet",
  "checksystem", "checkfifo", "checkprogram", "start", "stop", "restart",
  "argumentlist", "useroptionlist", "argument", "useroption", "username",
  "password", "hostname", "connection", "connectionoptlist",
  "connectionopt", "connectionurl", "connectionurloptlist",
  "connectionurlopt", "connectionunix", "connectionuxoptlist",
  "connectionuxopt", "icmp", "icmpoptlist", "icmpopt", "host", "port",
  "unixsocket", "ip", "type", "typeoptlist", "typeopt", "outgoing",
  "protocol", "sendexpect", "websocketlist", "websocket", "smtplist",
  "smtp", "mysqllist", "mysql", "target", "maxforward", "siplist", "sip",
  "httplist", "http", "status", "method", "request", "responsesum",
  "hostheader", "httpheaderlist", "secret", "radiuslist", "radius",
  "apache_stat_list", "apache_stat", "exist", "pid", "ppid", "uptime",
  "icmpcount", "icmpsize", "icmptimeout", "icmpoutgoing", "stoptimeout",
  "starttimeout", "restarttimeout", "programtimeout", "nettimeout",
  "connectiontimeout", "retry", "actionrate", "urloption", "urloperator",
  "alert", "alertmail", "noalertmail", "eventoptionlist", "eventoption",
  "formatlist", "formatoptionlist", "formatoption", "every", "mode",
  "onreboot", "group", "depend", "dependlist", "dependant", "statusvalue",
  "resourceprocess", "resourceprocesslist", "resourceprocessopt",
  "resourcesystem", "resourcesystemlist", "resourcesystemopt",
  "resourcecpuproc", "resourcecpu", "resourcecpuid", "resourcemem",
  "resourcememproc", "resourceswap", "resourcethreads", "resourcechild",
  "resourceload", "resourceloadavg", "resourceread", "resourcewrite",
  "value", "timestamptype", "timestamp", "operator", "time", "totaltime",
  "currenttime", "repeat", "action", "action1", "action2", "rateXcycles",
  "rateXYcycles", "rate1", "rate2", "recovery", "checksum", "hashtype",
  "inode", "space", "read", "write", "servicetime", "fsflag", "unit",
  "permission", "match", "matchflagnot", "size", "uid", "euid", "secattr",
  "gid", "linkstatus", "linkspeed", "linksaturation", "upload", "download",
  "icmptype", "reminder", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321,   322,   323,   324,
     325,   326,   327,   328,   329,   330,   331,   332,   333,   334,
     335,   336,   337,   338,   339,   340,   341,   342,   343,   344,
     345,   346,   347,   348,   349,   350,   351,   352,   353,   354,
     355,   356,   357,   358,   359,   360,   361,   362,   363,   364,
     365,   366,   367,   368,   369,   370,   371,   372,   373,   374,
     375,   376,   377,   378,   379,   380,   381,   382,   383,   384,
     385,   386,   387,   388,   389,   390,   391,   392,   393,   394,
     395,   396,   397,   398,   399,   400,   401,   402,   403,   404,
     405,   406,   407,   408,   409,   410,   411,   412,   413,   414,
     415,   416,   417,   418,   419,   420,   421,   422,   423,   424,
     425,   426,   427,   428,   429,   430,   431,   432,   433,   434,
     435,   436,   437,   438,   439,   440,   441,   442,   443,   444,
     445,   446,   447,   448,   449,   450,   451,   452,   453,   454,
     455,   456,   457,   458,   459,   460,   461,   462,   463,   464,
     465,   466,   467,   468,   469,   470,   471,   472,   473,   474,
     475,   476,   477,   478,   479,   480,   481,   482,   483,   484,
     485,   486,   487,   488,   489,   490,   491,   492,   493,   494,
     495,   496,   497,   498,   499,   500,   501,   502,   503,   504,
     505,   506,   507,   508,   509,   510,   511,   512,   513,   514,
     515,   516,   517,   518,   519,   520,   521,   522,   523,   524,
     525,   526,   527,   528,   529,   530,   531,   532,   533,   534,
     123,   125,    58,    64,    91,    93
};
# endif

#define YYPACT_NINF -783

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-783)))

#define YYTABLE_NINF -701

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     539,    82,   -87,   -42,   -24,   -14,    -9,    50,    75,   102,
     120,   172,   539,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,    80,   159,   179,  -783,  -783,   326,    67,   233,   239,
     130,   276,   310,   320,   182,    83,   334,   202,  -783,   -55,
       5,   391,   397,   405,   470,  -783,   415,   420,   101,  -783,
    -783,   482,   224,   776,   870,   987,  1196,  1213,   870,  1326,
     502,  -783,   454,   469,     3,  -783,  1234,  -783,  -783,  -783,
    -783,  -783,   404,  -783,  -783,   614,  -783,  -783,  -783,   422,
     407,  -783,   202,   296,   283,   293,  1294,   518,   445,   449,
     512,   554,   465,   479,   494,   491,   557,   507,   522,   199,
     557,   557,   530,   557,   -95,   398,   544,   136,   536,   541,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,   -37,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,   116,  -117,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,    49,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,   121,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,    55,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
      33,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,   805,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,   254,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
     546,   657,  -783,   561,   434,   563,  -783,   609,     4,   585,
     633,   681,   691,   493,   659,  -783,   654,   680,   694,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,    11,   169,  -783,  -783,  -783,  -783,  -783,   551,   573,
    -783,  -783,    13,  -783,   608,  -783,   514,   296,   577,  -783,
     614,  1294,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,   888,  -783,   686,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,   298,  -783,
    -783,  -783,    -4,   751,   753,   753,   553,   753,   753,  -783,
    -783,  -783,   753,   753,   473,   593,   753,   713,  1408,  -783,
    -783,  -783,  -783,  -783,  -783,   753,  -783,  -783,   366,   376,
    -783,   424,   797,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,   541,  -783,   576,  1294,   518,    37,  -783,
    -783,  -783,  -783,   171,   753,   593,   467,   753,   630,  -783,
     467,   644,   -84,   753,   753,   753,  -134,   885,   931,   373,
     154,   832,   753,   753,   753,   728,   845,   753,   753,  -783,
    -783,  -783,  -783,  1385,  -783,  -783,   753,  -783,  -783,  -783,
     753,   733,  -783,   777,  -783,   827,    72,   790,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,   792,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,   729,   820,  -783,   796,   821,   835,
     678,   844,   848,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,   695,   697,   701,   706,   709,   710,   719,
     720,  -783,  -783,   735,   742,   752,   764,   768,   770,   779,
     786,   788,  -783,  -783,  -783,  -783,  -783,  -783,   892,   894,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,    74,   976,   906,
    -783,   999,   930,   123,   176,   -21,  -783,  -783,  -783,   948,
     951,   226,   255,   284,   823,   813,  1014,  -783,   953,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,   955,   956,   753,   753,
      24,    24,    24,    24,   713,   713,   713,   959,   -15,  -783,
    -783,  1087,  -783,  1098,    24,   965,   201,  -783,   966,   270,
    -783,   968,   274,  -783,  -783,  -783,  1294,  1111,  -783,  -783,
    -783,   970,  1015,   713,   713,   713,  1022,   975,  -783,  -783,
     671,   978,   717,   727,   731,   245,   279,   300,   713,   753,
     308,   753,    24,  -783,  -783,  -783,  1038,   713,   982,   988,
     992,   753,   753,   713,    24,    24,  -783,  1129,    24,   994,
     713,  -783,   434,     7,  -783,  -783,  -783,  -783,  -783,  -783,
    1004,  1006,  1011,  1033,  1034,  1126,    76,   252,  1035,  1039,
    1040,   852,   847,  1042,  1043,   967,  1031,  1036,  1037,  1044,
    1046,  1056,  1057,  1059,  1061,  -783,   964,  -783,   906,   518,
    -783,   995,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
     713,   713,   713,   713,   713,   713,  -783,   745,  1062,  -783,
     972,  1157,  -783,  -783,   343,   375,  -783,  -783,   287,   416,
    1073,  1075,  1216,  1217,  1218,   858,  -783,  1169,   352,   352,
    -783,  1010,  -783,  1016,  -783,  1017,  -783,  1199,   906,   713,
      25,  1226,  1229,  1235,   713,   404,   713,   713,   858,   713,
     713,  -783,  -783,  -783,  -783,  1074,   404,  1076,   404,  1041,
    1064,  1246,   383,    29,  1110,    24,   602,    42,    42,    42,
    1003,  -783,  1249,  1113,    45,    90,  1117,  1118,  1259,   666,
     673,   352,  1136,   713,  1281,  1018,  1018,  -783,  1161,  1034,
    1034,  1034,  1126,  -783,  1034,  -783,  -783,  -783,  -783,   374,
     403,  1153,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,   404,   404,   404,   404,   665,   674,   696,
     711,   721,  -783,   518,  -783,  -783,  1290,  1292,  1295,  1296,
    1297,  1298,    14,   713,   713,  -783,    85,  1172,  1174,   702,
    1516,  1168,  1170,  -783,  -783,  -783,  -783,  -783,  -783,  1307,
    1308,  1142,   404,  1144,   404,  -783,  -783,  -783,  -783,  -783,
    -783,   352,   352,   352,  -783,  -783,  -783,  -783,  -783,   713,
    -783,  -783,  -783,  -783,  -783,   557,  -783,  -783,  1315,  1315,
    -783,  -783,  -783,   906,   518,  1319,  1188,  1320,   352,   352,
     352,  1321,   713,  1322,  1323,   713,  1325,  1327,   713,  1115,
     713,  1115,   713,   713,   352,    29,  1191,  1330,   713,   677,
     713,   713,  1210,  1202,  1203,  1204,  -783,  -783,  -783,  -783,
    -783,  1341,  1342,  1345,  -783,    42,   352,   713,  1115,  1115,
    1115,  1115,   106,   161,   352,  -783,  -783,  -783,  -783,  1315,
    -783,  1346,   352,  1220,  1224,  -783,  1034,  1034,  1034,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,   352,   352,   352,   352,   352,   352,    78,   467,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  1352,  1353,  1354,  1236,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  1356,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,   893,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,    22,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  1150,  -783,   352,   355,
    -783,  1115,  -783,  1115,  -783,  -783,  1315,  1364,   390,  1371,
    -783,  -783,   518,  -783,   352,   713,   352,  1315,  -783,  -783,
     352,  1372,   352,   352,  1375,   352,   352,  1376,  -783,   713,
    1377,   713,  1380,  1381,  -783,  1383,   713,   352,  1384,   713,
     713,  1389,  1390,  -783,  -783,  1160,  -783,   352,   352,   352,
    1394,  1315,  1396,   713,   713,   713,   713,   -73,   264,   273,
     333,  1315,  -783,   352,  -783,  -783,  -783,  1315,  1315,  1315,
    1315,  1315,  1315,  1116,  1271,   352,   352,   352,  -783,   352,
    1048,   250,   250,  1272,   753,   753,   753,   753,   753,   753,
     753,   753,   753,   753,  -783,  -783,   893,  -783,   684,   684,
     684,  1275,  1282,  1274,  1280,    22,  -783,   -48,  1215,  -783,
    1315,  -783,  -783,  -783,  -783,  -783,   352,  1328,   -25,  -783,
     533,  -783,  1315,  1412,  1315,  -783,  -783,   352,  -783,  -783,
     352,  -783,  -783,   352,  1414,   352,  1418,   352,   352,   352,
    1419,  1315,   352,  1420,  1421,   352,   352,  -783,  1315,  1315,
    1315,   352,  -783,   352,  1425,  1426,  1427,  1428,   592,  -783,
    -783,  -783,   713,   592,   713,   592,   713,   592,   713,  -783,
    1315,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  1293,  -783,
    1315,  1315,  1315,  1315,  -783,  -783,  -783,  1303,   772,   753,
     811,  1306,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  1304,  1305,  1313,  1314,  1316,  1324,  1333,  1334,
    1336,  1338,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,   117,  1348,  -783,  -783,  -783,  1312,
    -783,  -783,  -783,  1315,    19,  -783,   713,   713,   713,  -783,
     352,  -783,  1315,  1315,  1315,   352,  1315,   352,  1315,  1315,
    1315,   352,  -783,  1315,   352,   352,  1315,  1315,  -783,  -783,
    -783,  1315,  1315,   352,   352,   352,   352,   713,  1434,   713,
    1442,   713,  1444,   713,  1451,  -783,  1244,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  1351,  -783,  -783,  -783,  -161,  1358,
    1360,  1361,  1363,  1365,  1366,  1368,  1369,  1370,  1373,  -783,
    -783,  -783,  -783,  -783,  -783,  1411,  -783,  -783,  1459,  1462,
    1463,  1315,  -783,  -783,  -783,  1315,  -783,  1315,  -783,  -783,
    -783,  1315,  -783,  1315,  1315,  -783,  -783,  -783,  -783,  1315,
    1315,  1315,  1315,  1464,   352,  1488,   352,  1490,   352,  1491,
     352,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,   352,   352,   352,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,   352,
    1315,   352,  1315,   352,  1315,   352,  1315,  -783,  -783,  -783,
    -783,  1315,  -783,  1315,  -783,  1315,  -783,  1315,  -783,  -783,
    -783,  -783,  -783
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint16 yydefact[] =
{
       2,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     3,     4,     6,     8,     9,    20,    22,    19,
      21,    23,    10,    11,    17,    18,    16,    12,     7,    13,
      14,    15,    33,    57,    77,    99,   116,   131,   148,   162,
     179,     0,     0,     0,   291,   199,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,   221,   593,
       0,     0,     0,     0,     0,   352,     0,     0,     0,     1,
       5,    24,    25,    26,    27,    28,    32,    29,    30,    31,
     223,   222,   197,   282,   546,   278,   290,   196,   247,   228,
     229,   205,   731,   230,   559,     0,   200,   201,   202,     0,
       0,   235,   231,   242,     0,     0,     0,   774,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      34,    35,    36,    37,    46,    47,    48,    38,    39,    40,
      45,    49,    50,   593,   558,    51,    52,    53,    54,    55,
      56,    41,    42,    43,    44,   746,   746,    58,    59,    60,
      61,    62,    64,    66,    65,    73,    74,    75,    76,    63,
      70,    67,    72,    71,    68,    69,     0,    78,    79,    80,
      81,    82,    83,    85,    84,    89,    90,    91,    92,    93,
      94,    95,    96,    97,    98,    86,    87,    88,     0,   100,
     101,   102,   103,   104,   106,   108,   107,   112,   113,   114,
     115,   105,   109,   110,   111,     0,   117,   118,   119,   120,
     121,   122,   123,   124,   125,   126,   127,   128,   129,   130,
       0,   132,   133,   134,   135,   141,   145,   142,   143,   144,
     146,   147,   136,   137,   138,   139,   140,     0,   149,   150,
     151,   152,   161,   153,   154,   155,   156,   157,   158,   159,
     160,   163,   164,   165,   166,   167,   169,   171,   170,   175,
     176,   177,   178,   168,   172,   173,   174,     0,   180,   181,
     182,   183,   184,   185,   186,   187,   188,   189,   190,   191,
       0,     0,   195,     0,   280,     0,   279,   375,     0,     0,
       0,     0,     0,   245,     0,   304,     0,     0,     0,   293,
     292,   294,   295,   296,   300,   301,   318,   319,   297,   298,
     299,     0,     0,   732,   733,   734,   735,   203,     0,     0,
     599,   600,     0,   595,   225,   227,   234,   242,     0,   232,
       0,     0,   577,   564,   565,   579,   580,   587,   585,   567,
     589,   566,   588,   584,   591,   573,   575,   590,   581,   586,
     563,   592,   570,   574,   578,   571,   576,   569,   568,   582,
     583,   572,     0,   561,     0,   192,   341,   342,   343,   344,
     347,   346,   345,   348,   349,   353,   366,   367,   544,   362,
     350,   351,   418,     0,   667,   667,     0,   667,   667,   652,
     653,   654,   667,   667,     0,     0,   667,   700,   700,   618,
     620,   621,   622,   623,   624,   667,   625,   626,   540,   538,
     560,   542,     0,   602,   603,   604,   605,   606,   607,   608,
     609,   610,   614,   611,   612,     0,     0,   774,   713,   661,
     662,   663,   664,   713,   667,   747,     0,   667,     0,   747,
       0,     0,     0,   667,   667,   667,     0,   667,   667,     0,
     418,     0,   667,   667,   667,     0,     0,   667,   667,   640,
     637,   638,   639,   700,   628,   633,   667,   631,   632,   630,
     667,     0,   224,     0,   282,     0,     0,     0,   273,   267,
     268,   269,   270,   271,   272,     0,   274,   286,   287,   288,
     289,   283,   284,   285,     0,     0,   276,     0,     0,     0,
     335,   323,     0,   320,   302,   315,   317,   247,   303,   305,
     307,   314,   316,     0,     0,     0,     0,     0,     0,     0,
       0,   244,   248,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   204,   206,   597,   598,   277,   596,     0,     0,
     236,   238,   239,   240,   241,   233,   243,     0,     0,   593,
     562,   775,     0,     0,     0,   544,   363,   364,   354,     0,
       0,     0,     0,     0,     0,     0,     0,   401,     0,   674,
     668,   669,   670,   671,   672,   673,     0,     0,   667,   667,
       0,     0,     0,     0,   700,   700,   700,     0,     0,   701,
     702,     0,   619,     0,     0,     0,   540,   356,     0,   538,
     358,     0,   542,   360,   601,   613,     0,     0,   555,   714,
     715,     0,     0,   700,   700,   700,     0,     0,   553,   554,
       0,     0,     0,     0,     0,     0,     0,     0,   700,   667,
       0,   667,     0,   412,   412,   412,     0,   700,     0,     0,
       0,   667,   667,   700,     0,     0,   629,     0,     0,     0,
     700,   198,   281,   265,   373,   372,   374,   275,   547,   376,
     324,   325,   326,     0,     0,   339,     0,   306,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,   226,     0,   594,   593,   774,
     776,     0,   368,   370,   369,   371,   365,   355,   419,   421,
     700,   700,   700,   700,   700,   700,   392,     0,     0,   378,
     700,     0,   649,   650,     0,     0,   660,   659,   731,   731,
       0,     0,     0,     0,     0,   675,   698,     0,     0,     0,
     651,     0,   357,     0,   359,     0,   361,     0,   593,   700,
     700,     0,     0,     0,   700,   731,   700,   700,   675,   700,
     700,   741,   740,   745,   744,   660,   731,   660,   731,   660,
       0,     0,     0,   660,     0,     0,   731,   700,   700,   700,
       0,   412,     0,     0,   731,   731,     0,     0,     0,   731,
     731,     0,     0,   700,     0,   265,   265,   266,     0,     0,
       0,     0,   339,   338,   328,   336,   340,   322,   246,     0,
       0,     0,   308,   255,   254,   256,   251,   252,   249,   250,
     257,   258,   253,   731,   731,   731,   731,     0,     0,     0,
       0,     0,   237,   774,   193,   545,     0,     0,     0,     0,
       0,     0,   700,   700,   700,   420,   700,     0,     0,     0,
       0,     0,     0,   402,   403,   404,   405,   406,   407,     0,
       0,   660,   731,   660,   731,   644,   643,   646,   645,   634,
     635,     0,     0,     0,   676,   677,   678,   679,   680,   700,
     699,   693,   694,   689,   692,     0,   695,   696,   706,   706,
     541,   539,   543,   593,   774,     0,     0,     0,     0,     0,
       0,     0,   700,     0,     0,   700,     0,     0,   700,   684,
     700,   684,   700,   700,     0,   660,     0,     0,   700,   731,
     700,   700,     0,     0,     0,     0,   413,   414,   415,   416,
     417,     0,     0,     0,   773,   700,     0,   700,   684,   684,
     684,   684,   731,   731,     0,   642,   641,   648,   647,   706,
     636,     0,     0,     0,     0,   262,   330,   332,   334,   321,
     337,   309,   311,   310,   312,   313,   207,   208,   209,   210,
     211,   212,   213,   214,   217,   218,   215,   216,   219,   220,
     194,     0,     0,     0,     0,     0,     0,     0,     0,   397,
     399,   398,   393,   395,   396,   394,     0,     0,     0,     0,
     422,   423,   388,   390,   389,   379,   380,   381,   386,   382,
     383,   385,   387,   384,     0,   468,   469,   426,   424,   427,
     433,   491,   491,     0,   437,   476,   476,   451,   452,   440,
     441,   442,   448,   449,   480,   434,     0,   457,   435,   443,
     444,   458,   460,   461,   462,   450,   487,   463,   464,   511,
     466,   459,   445,   453,   456,   436,     0,   549,     0,     0,
     656,   684,   658,   684,   531,   532,   706,     0,   686,     0,
     530,   617,   774,   556,     0,   700,     0,   706,   749,   666,
       0,     0,     0,     0,     0,     0,     0,     0,   685,   700,
       0,   700,     0,     0,   730,     0,   700,     0,     0,   700,
     700,     0,     0,   537,   534,     0,   535,     0,     0,     0,
       0,   706,     0,   700,   700,   700,   700,     0,     0,     0,
       0,   706,   627,     0,   616,   263,   264,   706,   706,   706,
     706,   706,   706,   260,     0,     0,     0,     0,   431,     0,
     425,   438,   439,     0,   667,   667,   667,   667,   667,   667,
     667,   667,   667,   667,   516,   517,   432,   514,   454,   455,
     446,     0,     0,     0,     0,   467,   470,   447,   465,   548,
     706,   551,   550,   655,   657,   529,     0,     0,   686,   690,
       0,   557,   706,     0,   706,   737,   712,     0,   739,   738,
       0,   743,   742,     0,     0,     0,     0,     0,     0,     0,
       0,   706,     0,     0,     0,     0,     0,   536,   706,   706,
     706,     0,   758,     0,     0,     0,     0,     0,     0,   681,
     682,   683,   700,     0,   700,     0,   700,     0,   700,   759,
     706,   750,   751,   752,   753,   756,   757,   261,     0,   552,
     706,   706,   706,   706,   429,   430,   428,     0,     0,   667,
       0,     0,   508,   493,   494,   492,   497,   498,   495,   496,
     499,   518,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,   515,   478,   479,   477,   482,   483,   481,   474,
     472,   475,   473,   471,     0,     0,   489,   490,   488,     0,
     513,   512,   400,   706,     0,   691,   703,   703,   703,   736,
       0,   710,   706,   706,   706,     0,   706,     0,   706,   706,
     706,     0,   716,   706,     0,     0,   706,   706,   409,   410,
     411,   706,   706,     0,     0,     0,     0,   700,     0,   700,
       0,   700,     0,   700,     0,   615,     0,   391,   754,   755,
     377,   506,   502,   503,     0,   505,   504,   507,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   485,
     484,   486,   510,   533,   687,     0,   704,   705,     0,     0,
       0,   706,   748,   665,   725,   706,   727,   706,   728,   729,
     718,   706,   717,   706,   706,   721,   720,   408,   760,   706,
     706,   706,   706,     0,     0,     0,     0,     0,     0,     0,
       0,   259,   501,   509,   500,   519,   520,   521,   522,   523,
     524,   525,   526,   527,   528,   688,     0,     0,     0,   711,
     724,   726,   719,   723,   722,   764,   761,   770,   767,     0,
     706,     0,   706,     0,   706,     0,   706,   697,   707,   708,
     709,   706,   765,   706,   762,   706,   771,   706,   768,   766,
     763,   772,   769
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -783,  -783,  -783,  1486,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    1404,  -783,  -783,  1177,  -783,   -78,  1000,  -783,   670,  -783,
    -316,   152,  -335,  -334,  -783,  -783,  -783,  1435,  1045,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,    30,
    -643,   716,  -783,  -783,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  1409,  1518,  1528,  -107,  -400,  -383,  -555,  -551,  -528,
    -783,  1445,  -783,  -783,  1447,  -783,  -783,  -783,  -783,  -783,
    -783,  -557,  -783,  -783,  -783,  -783,  -783,   679,  -783,  -783,
    -783,   682,   687,  -783,   359,   501,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,   508,  -783,  -783,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -783,   378,   492,  -783,  -783,  1458,
    -783,  -783,  -783,  -783,   932,   933,   928,   977,  -783,  -576,
    -556,  1576,   698,  -441,  1584,  1549,  -783,  -318,  -350,  -126,
    1211,  -301,  1592,  1600,  1608,  1616,  1624,  -783,  1119,  -783,
    -783,  -783,  1149,  -783,  -783,  1085,  -783,  -783,  -783,  -783,
    -783,  -783,  -783,  -783,  -220,  -783,  -783,  -783,   836,  -264,
     219,  -391,   801,  -113,  -782,   385,  -595,  -311,  -468,  -460,
    -381,  -408,  -340,  -590,  -783,  1125,  -783,  -783,  -783,  -783,
    -783,  -783,   185,   528,  -783,  1413,  -783,   543,  -783,  -783,
     637,  -783,  -783,  -783,  -783,  -783,  -783,  -434
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,    11,    12,    13,    71,   130,    72,   157,    73,   177,
      74,   199,    75,   216,    76,   231,    77,   248,    78,   261,
      79,   278,    14,    15,    16,   292,    17,    18,    19,    20,
     322,   543,    21,    22,    23,    24,    25,    26,    27,   102,
     103,   336,   550,   339,    28,   497,   321,   532,   990,  1238,
     498,   798,   499,   500,    29,    30,    84,    85,   294,   501,
      31,    86,   310,   311,   312,   313,   314,   315,   677,   812,
     316,   317,   318,   319,   320,   674,   799,   800,   801,   804,
     805,   807,    32,    33,    34,    35,    36,    37,    38,    39,
      40,   131,   132,   133,   388,   565,   389,   567,   502,   503,
     506,   134,   846,  1005,   135,   842,   992,   136,   720,   853,
     222,   777,   926,   576,   719,   577,  1006,   854,  1140,  1246,
    1008,   855,   856,  1165,  1166,  1158,  1275,  1160,  1278,  1286,
    1287,  1167,  1288,  1141,  1255,  1256,  1257,  1258,  1259,  1260,
    1348,  1290,  1168,  1291,  1156,  1157,   137,   138,   139,   140,
     927,   928,   929,   930,   610,   607,   613,   568,   297,   857,
     858,   141,   995,   630,   142,   143,   144,   372,   373,   107,
     332,   333,   145,   146,   147,   148,   149,   433,   434,   289,
     150,   408,   409,   260,   473,   474,   410,   475,   476,   477,
     411,   478,   412,   413,   414,   415,   416,   417,   728,   447,
     169,   586,   879,  1222,  1089,  1179,   887,   888,  1438,   599,
     600,   601,  1368,  1070,   170,   622,   189,   190,   191,   192,
     193,   194,   327,   171,   172,   448,   173,   151,   152,   153,
     154,   242,   243,   244,   245,   246,   781,   375
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
     603,   553,   554,   618,   587,   566,   590,   591,   309,   633,
     706,   592,   593,   418,   419,   597,   421,   437,   606,   609,
     552,   612,   560,   558,   604,   507,   508,   479,   509,   795,
     796,   547,   104,  1177,  -700,   566,   566,   523,   566,   461,
     736,   524,   525,   303,   526,   527,   422,   528,   529,   987,
     104,   706,    60,   627,   706,   452,   631,   706,   922,   619,
     620,   460,   635,   636,   637,   657,   640,   642,  1218,   562,
     569,   648,   649,   650,  1364,   108,   654,   655,   109,   896,
     462,   463,   464,   465,   570,   658,   938,   778,   779,   659,
      41,    80,    42,   295,    43,    44,  1161,    61,   923,    45,
      46,   999,   523,   623,   851,   852,   524,   525,  1403,   526,
     527,    47,   528,   529,   303,    62,  1133,   117,   617,   571,
     987,   573,   438,   449,  1404,    63,   737,   452,   638,  1091,
      64,   940,   924,    48,    49,    83,   510,   511,   847,   848,
     118,    50,   450,    51,  1219,  1220,  1221,  1117,   328,   329,
     330,   331,    52,   621,    96,   598,  1113,  1114,  1115,  1116,
    1365,   960,  1000,  1001,   849,   726,   598,    53,   850,    54,
     598,   663,    69,   423,   393,   851,   852,   727,   563,   625,
     564,   530,   563,   598,   564,   105,   732,   733,   734,    65,
     393,  1162,  1163,   619,   620,   625,   393,   724,   725,   571,
     572,   573,  1119,   435,   664,   392,   665,   428,   560,   328,
     329,   330,   331,    81,    66,   751,   752,   753,  1164,  1284,
     453,   454,  1285,   455,   935,   106,   598,   155,   569,   533,
     771,   534,   535,   536,   537,   538,   539,   540,   541,   782,
     571,    67,   573,   436,   110,   788,   530,   466,   772,  1359,
     775,  1360,   794,   479,   574,   702,   547,   393,   551,    68,
     786,   787,   393,   456,   703,   834,   993,   560,   575,    55,
    1011,    97,    98,   988,   621,   323,   324,   325,   326,  1173,
     925,  1174,    56,   457,   458,   797,   994,   512,    57,   405,
    1012,   605,   531,   211,   546,   120,   121,   273,   747,  1071,
      82,   407,   836,   837,   838,   839,   840,   841,   704,    53,
     122,    83,   859,   960,   960,   960,   123,   705,   124,   125,
     323,   324,   325,   326,   429,   430,   439,   440,   441,   442,
     443,   439,   440,   441,   442,   459,   323,   324,   325,   326,
     393,   895,   897,  1247,   988,    87,   901,    88,   903,   904,
     822,   906,   907,    58,   444,   697,   445,   808,   710,  1122,
     608,   405,   394,   395,   611,   917,    89,   711,   407,   931,
     932,   933,    90,   407,   396,   446,   397,   398,   399,   400,
     401,   439,   440,   441,   442,   951,   765,   712,   562,   402,
     403,   323,   324,   325,   326,   393,   713,   560,   727,   980,
     643,   644,   645,   646,   563,  1223,   564,   126,   623,   624,
      91,   127,   574,   404,  1225,  1248,   714,    92,  1249,   128,
     767,   129,   480,   881,   882,   715,   881,   882,   889,   865,
     386,   387,   727,   699,   996,   997,   998,   883,  1014,   405,
     883,   769,   406,    93,   884,  1171,  1250,   884,  1177,   773,
     542,   407,  1251,   727,    94,   809,   605,   810,   486,   487,
    1073,   727,    95,   303,   111,   156,   608,   101,   481,   485,
     112,  1067,  1154,   563,  1227,   564,  1175,   563,   113,   564,
     949,  1219,  1220,  1221,   861,   119,   114,  1185,   115,   811,
    1219,  1220,  1221,   116,  1081,  1155,   727,  1084,   386,   387,
    1087,   563,  1090,   564,  1092,  1093,   961,  1095,   386,   387,
    1098,   290,  1101,  1102,   611,   962,   863,   323,   324,   325,
     326,  1212,   386,   387,   915,   291,   991,  1110,   727,  1112,
    1004,  1229,    99,   100,  1252,   963,   727,  1231,  1232,  1233,
    1234,  1235,  1236,   303,   964,   293,     1,  1134,   335,   485,
    1219,  1220,  1221,   120,   121,   334,   386,   387,   867,   338,
    1064,  1065,  1066,   340,   161,   181,   203,    53,   122,   563,
     265,   564,   833,   341,   123,   374,   124,   125,   376,   563,
    1292,   564,   377,   439,   440,   441,   442,  1077,  1078,  1079,
    1253,  1253,  1299,   563,  1301,   564,   885,   886,   382,   885,
     886,   195,   212,  1094,   549,  1154,   274,  1273,  1273,  1276,
     623,  1312,   383,  1254,  1254,   174,   196,   213,  1318,  1319,
    1320,   275,   894,   706,   385,  1111,   384,   563,  1155,   564,
    1274,  1274,  1277,  1121,   323,   324,   325,   326,  1181,   390,
    1335,  1124,   486,   487,   378,   379,   323,   324,   325,   326,
    1337,  1338,  1339,  1340,   391,   488,   489,   490,   491,   492,
     493,   494,   495,   496,   420,   126,   424,  1183,  1178,   127,
    1127,  1128,  1129,  1130,  1131,  1132,   431,   128,   482,   129,
     432,  1194,   483,  1196,   505,   566,   380,   381,  1200,   386,
     387,  1203,  1204,     2,     3,     4,     5,     6,     7,     8,
       9,    10,   484,  1363,   504,  1214,  1215,  1216,  1217,   175,
     197,   214,  1372,  1373,  1374,   276,  1376,   513,  1378,  1379,
    1380,   521,   522,  1382,   588,   589,  1385,  1386,   425,   426,
     427,  1387,  1388,   594,   595,   488,   489,   490,   491,   492,
     493,   494,   495,   496,   920,   628,   629,  1170,  1172,   328,
     329,   330,   331,  1262,  1263,  1264,  1265,  1266,  1267,  1268,
    1269,  1270,  1271,  1182,   989,  1184,   514,  1072,  1002,  1186,
     515,  1188,  1189,   517,  1191,  1192,   651,   652,  1068,   176,
     516,  1419,  1017,  1018,  1019,  1420,  1201,  1421,  1296,  1297,
    1298,  1422,   518,  1423,  1424,   519,  1208,  1209,  1210,  1425,
    1426,  1427,  1428,   756,   757,  1244,  1245,   548,   945,  1219,
    1220,  1221,  1230,   520,  1328,   947,  1330,   544,  1332,  1099,
    1334,  1437,  1437,  1437,  1240,  1241,  1242,   561,  1243,   956,
     957,   958,   323,   324,   325,   326,  1366,  1366,  1366,   545,
    1442,   556,  1444,   578,  1446,   596,  1448,   120,   121,   759,
     760,  1449,   614,  1450,   598,  1451,   616,  1452,  1344,   761,
     762,    53,   122,   763,   764,  1293,   816,   817,   123,   632,
     124,   125,   647,   198,   818,   819,  1302,   843,   844,  1303,
     970,   971,  1304,   634,  1306,   653,  1308,  1309,  1310,   972,
     973,  1313,   486,   487,  1316,  1317,   323,   324,   325,   326,
    1321,   660,  1322,   323,   324,   325,   326,   323,   324,   325,
     326,   974,   975,   866,   868,  1367,  1367,  1367,   661,  1393,
     663,  1395,   666,  1397,   667,  1399,   976,   977,   342,   670,
     343,   344,   345,   346,   347,   348,   978,   979,  1342,  1343,
     902,   120,   121,  1345,  1346,   668,   393,   953,   954,  1439,
    1440,   909,   669,   911,   671,    53,   122,  1369,  1370,   126,
     673,   921,   123,   127,   124,   125,  1143,   579,   672,   939,
     941,   128,   349,   129,   946,   948,  -327,   678,   350,   679,
     675,   351,   467,   680,   399,   400,   401,   468,   681,  1371,
     215,   682,   683,   104,  1375,   469,  1377,   470,   471,   472,
    1381,   684,   685,  1383,  1384,  1224,  1226,  1228,   966,   967,
     968,   969,  1389,  1390,  1391,  1392,   342,   686,   343,   344,
     345,   346,   347,   348,   687,   847,   848,   580,   581,   582,
     583,   584,   585,   695,   688,   696,  1144,  1145,  1146,  1147,
    1148,  1149,  1150,  1151,  1152,  1153,   689,  1061,   406,  1063,
     690,   849,   691,   126,   700,   850,   352,   127,   120,   121,
     349,   692,   851,   852,   353,   128,   350,   129,   693,   351,
     694,   701,    53,   122,   874,   875,   876,   877,   878,   123,
     708,   124,   125,  1430,   709,  1432,   717,  1434,   716,  1436,
     718,   354,   738,   355,   721,   356,   722,   723,   357,   579,
     735,   486,   487,   739,  1100,  1327,   741,   743,   750,   745,
    1329,   749,  1331,   598,  1333,   754,   755,   780,  1441,   758,
    1443,   639,  1445,   783,  1447,   358,   359,  1118,  1120,   784,
     360,   361,   362,   785,   791,   793,  -329,   363,  -331,   364,
     365,   366,   367,  -333,   352,   579,   806,   368,   369,   370,
     371,   342,   353,   343,   344,   345,   346,   347,   348,   580,
     581,   582,   583,   584,   585,   802,   803,   641,   813,   559,
     126,   814,   823,   815,   127,   820,   821,   824,   825,   354,
     832,   355,   128,   356,   129,   826,   357,   827,   488,   489,
     490,   491,   492,   493,   494,   349,   496,   828,   829,   230,
     830,   350,   831,   845,   351,   580,   581,   582,   583,   584,
     585,   835,   860,   358,   359,   869,   247,   870,   360,   361,
     362,   871,   872,   873,   880,   363,   890,   364,   365,   366,
     367,   898,   891,   892,   899,   368,   369,   370,   371,   342,
     900,   343,   344,   345,   346,   347,   348,   908,   298,   910,
     299,   914,   918,   934,   936,   937,   912,   698,   942,   943,
     300,   301,   302,   303,   944,   304,   305,   120,   121,   488,
     489,   490,   491,   492,   493,   494,   495,   496,   950,   352,
     913,    53,   122,   349,   120,   121,   952,   353,   123,   350,
     124,   125,   351,   955,   965,   981,   797,   982,    53,   122,
     983,   984,   985,   986,  1015,   123,  1016,   124,   125,  1056,
     306,  1057,  1058,  1059,   354,  1060,   355,  1062,   356,  1069,
    1075,   357,   307,   308,  1074,  1076,  1080,  1082,  1083,   277,
    1085,  1088,  1086,  1096,   342,  1097,   343,   344,   345,   346,
     347,   348,  1103,  1104,  1105,  1106,  1107,  1108,   358,   359,
    1109,  1123,  1125,   360,   361,   362,  1126,  1135,  1136,  1137,
     363,  1139,   364,   365,   366,   367,  1169,   352,  1138,  1176,
     368,   369,   370,   371,  1180,   353,  1207,  1187,   349,   126,
    1190,  1193,  1195,   127,   350,  1197,  1198,   351,  1199,  1202,
    1237,   128,   748,   129,  1205,  1206,   126,   120,   121,  1211,
     127,  1213,   354,  1239,   355,  1261,   356,  1279,   128,   357,
     129,    53,   122,  1282,  1280,  1281,  1289,  1300,   123,  1305,
     124,   125,  1294,  1307,  1311,  1314,  1315,   729,   730,   731,
    1323,  1324,  1325,  1326,  1336,  1341,   358,   359,  1347,  1394,
     740,   360,   361,   362,  1362,  1349,  1350,  1396,   363,  1398,
     364,   365,   366,   367,  1351,  1352,  1400,  1353,   368,   369,
     370,   371,   352,  1401,  1416,  1354,  1415,  1417,  1418,  1429,
     353,   766,   768,   770,  1355,  1356,   774,  1357,   776,  1358,
     893,   158,   178,   200,   217,   232,   249,   262,   279,  1361,
     789,   790,  1402,  1431,   792,  1433,  1435,   354,    70,   355,
    1405,   356,  1406,  1407,   357,  1408,   337,  1409,  1410,   126,
    1411,  1412,  1413,   127,   555,  1414,  1003,   676,   959,   296,
     220,   128,   221,   129,  1283,  1007,   598,  1159,  1009,   662,
    1142,   358,   359,  1010,  1272,   252,   360,   361,   362,   742,
     746,   744,   707,   363,  1013,   364,   365,   366,   367,   598,
      59,   557,   615,   368,   369,   370,   371,   602,   656,   905,
     862,   864,   467,  1295,   399,   400,   401,   468,   626,   451,
       0,   394,   395,     0,     0,   469,     0,   470,   471,   472,
       0,     0,     0,   396,     0,   397,   398,   399,   400,   401,
     159,   179,   201,   218,   233,   250,   263,   280,   402,   403,
     160,   180,   202,   219,   234,   251,   264,   281,   916,     0,
       0,   919,  1020,  1021,  1022,  1023,  1024,  1025,  1026,  1027,
    1028,  1029,  1030,  1031,  1032,  1033,  1034,  1035,  1036,  1037,
    1038,  1039,  1040,  1041,  1042,  1043,  1044,  1045,  1046,  1047,
    1048,  1049,  1050,  1051,  1052,  1053,  1054,  1055,   162,   182,
     204,   223,   235,   253,   266,   282,   163,   183,   205,   224,
     236,   254,   267,   283,   164,   184,   206,   225,   237,   255,
     268,   284,   165,   185,   207,   226,   238,   256,   269,   285,
     166,   186,   208,   227,   239,   257,   270,   286,   167,   187,
     209,   228,   240,   258,   271,   287,   168,   188,   210,   229,
     241,   259,   272,   288
};

static const yytype_int16 yycheck[] =
{
     408,   336,   336,   437,   395,   388,   397,   398,    86,   450,
     565,   402,   403,   120,   121,   406,   123,   143,   418,   419,
     336,   421,   372,   341,   415,    21,    22,   247,    24,    22,
      23,   332,    87,    58,     5,   418,   419,    26,   421,     6,
      55,    30,    31,    29,    33,    34,   141,    36,    37,    35,
      87,   606,   139,   444,   609,     6,   447,   612,    16,    22,
      23,     6,   453,   454,   455,   473,   457,   458,   141,    90,
      74,   462,   463,   464,    55,    70,   467,   468,    73,    54,
      47,    48,    49,    50,    88,   476,    41,   644,   645,   480,
       8,    11,    10,    90,    12,    13,    74,   139,    56,    17,
      18,    16,    26,   237,    90,    91,    30,    31,   269,    33,
      34,    29,    36,    37,    29,   139,    38,    16,   436,   203,
      35,   205,     6,   240,   285,   139,   141,     6,   262,   911,
     139,    41,    90,    51,    52,   132,   132,   133,    53,    54,
      39,    59,   259,    61,   217,   218,   219,    41,   135,   136,
     137,   138,    70,   237,    71,   141,   938,   939,   940,   941,
     141,   804,    77,    78,    79,   141,   141,    85,    83,    87,
     141,    93,     0,   268,   141,    90,    91,   153,   203,   443,
     205,   170,   203,   141,   205,   240,   594,   595,   596,   139,
     141,   169,   170,    22,    23,   459,   141,   588,   589,   203,
     204,   205,    41,   240,   132,     6,   134,    71,   558,   135,
     136,   137,   138,   133,   139,   623,   624,   625,   196,   267,
     171,   172,   270,   174,   781,   280,   141,     3,    74,    60,
     638,    62,    63,    64,    65,    66,    67,    68,    69,   647,
     203,   139,   205,   280,   239,   653,   170,   214,   639,   132,
     641,   134,   660,   473,   258,   132,   557,   141,   336,   139,
     651,   652,   141,   214,   141,   699,   842,   617,   272,   187,
     846,   188,   189,   259,   237,   230,   231,   232,   233,  1061,
     238,  1063,   200,   234,   235,   278,   842,   283,   206,   240,
     846,    90,   281,    74,   281,    71,    72,    78,   616,   889,
     141,   252,   710,   711,   712,   713,   714,   715,   132,    85,
      86,   132,   720,   956,   957,   958,    92,   141,    94,    95,
     230,   231,   232,   233,   188,   189,   210,   211,   212,   213,
     214,   210,   211,   212,   213,   214,   230,   231,   232,   233,
     141,   749,   750,    93,   259,    19,   754,   280,   756,   757,
     685,   759,   760,   271,   238,   281,   240,   281,   132,   949,
      90,   240,   163,   164,    90,   773,   133,   141,   252,   777,
     778,   779,   133,   252,   175,   259,   177,   178,   179,   180,
     181,   210,   211,   212,   213,   793,   141,   132,    90,   190,
     191,   230,   231,   232,   233,   141,   141,   747,   153,   833,
     246,   247,   248,   249,   203,   141,   205,   183,   237,   238,
     280,   187,   258,   214,   141,   165,   132,   141,   168,   195,
     141,   197,   168,    71,    72,   141,    71,    72,   739,   142,
     132,   133,   153,   559,   842,   843,   844,    85,   846,   240,
      85,   141,   243,   133,    92,    90,   196,    92,    58,   141,
     281,   252,   202,   153,   134,   203,    90,   205,   208,   209,
     894,   153,   280,    29,    73,   241,    90,   265,   214,    35,
      73,   879,  1023,   203,   141,   205,  1066,   203,    73,   205,
     791,   217,   218,   219,   141,     3,    16,  1077,    73,   237,
     217,   218,   219,    73,   902,  1023,   153,   905,   132,   133,
     908,   203,   910,   205,   912,   913,   132,   915,   132,   133,
     918,     9,   920,   921,    90,   141,   141,   230,   231,   232,
     233,  1111,   132,   133,   141,    71,   842,   935,   153,   937,
     846,  1121,   198,   199,   284,   132,   153,  1127,  1128,  1129,
    1130,  1131,  1132,    29,   141,    76,     7,   988,   141,    35,
     217,   218,   219,    71,    72,   133,   132,   133,   142,   263,
     871,   872,   873,   280,    72,    73,    74,    85,    86,   203,
      78,   205,   698,   280,    92,    57,    94,    95,   133,   203,
    1170,   205,   133,   210,   211,   212,   213,   898,   899,   900,
    1141,  1142,  1182,   203,  1184,   205,   244,   245,   133,   244,
     245,    73,    74,   914,    90,  1156,    78,  1158,  1159,  1160,
     237,  1201,   133,  1141,  1142,    72,    73,    74,  1208,  1209,
    1210,    78,   748,  1178,   133,   936,   132,   203,  1156,   205,
    1158,  1159,  1160,   944,   230,   231,   232,   233,  1072,   132,
    1230,   952,   208,   209,   132,   133,   230,   231,   232,   233,
    1240,  1241,  1242,  1243,   132,   221,   222,   223,   224,   225,
     226,   227,   228,   229,   134,   183,   268,  1075,  1068,   187,
     981,   982,   983,   984,   985,   986,   140,   195,   132,   197,
     139,  1089,    25,  1091,    75,  1068,   132,   133,  1096,   132,
     133,  1099,  1100,   154,   155,   156,   157,   158,   159,   160,
     161,   162,   141,  1293,   141,  1113,  1114,  1115,  1116,    72,
      73,    74,  1302,  1303,  1304,    78,  1306,   132,  1308,  1309,
    1310,    27,    28,  1313,   171,   172,  1316,  1317,   184,   185,
     186,  1321,  1322,   260,   261,   221,   222,   223,   224,   225,
     226,   227,   228,   229,   142,   278,   279,  1058,  1059,   135,
     136,   137,   138,  1144,  1145,  1146,  1147,  1148,  1149,  1150,
    1151,  1152,  1153,  1074,   842,  1076,   133,   893,   846,  1080,
      89,  1082,  1083,   280,  1085,  1086,    48,    49,   885,     3,
      89,  1371,    80,    81,    82,  1375,  1097,  1377,   255,   256,
     257,  1381,   133,  1383,  1384,   141,  1107,  1108,  1109,  1389,
    1390,  1391,  1392,   132,   133,  1140,  1140,   199,   142,   217,
     218,   219,  1123,   133,  1222,   142,  1224,   266,  1226,   142,
    1228,  1416,  1417,  1418,  1135,  1136,  1137,   141,  1139,   799,
     800,   801,   230,   231,   232,   233,  1296,  1297,  1298,   266,
    1430,   264,  1432,    92,  1434,   252,  1436,    71,    72,   132,
     133,  1441,    55,  1443,   141,  1445,   280,  1447,  1249,   132,
     133,    85,    86,   132,   133,  1176,    14,    15,    92,   239,
      94,    95,    40,     3,    27,    28,  1187,   132,   133,  1190,
     215,   216,  1193,   239,  1195,    40,  1197,  1198,  1199,   215,
     216,  1202,   208,   209,  1205,  1206,   230,   231,   232,   233,
    1211,   168,  1213,   230,   231,   232,   233,   230,   231,   232,
     233,   215,   216,   728,   729,  1296,  1297,  1298,   141,  1327,
      93,  1329,   132,  1331,   132,  1333,   215,   216,    40,   133,
      42,    43,    44,    45,    46,    47,   215,   216,   166,   167,
     755,    71,    72,   132,   133,   216,   141,   795,   796,  1417,
    1418,   766,   132,   768,   133,    85,    86,  1297,  1298,   183,
     282,   776,    92,   187,    94,    95,    73,   214,   133,   784,
     785,   195,    84,   197,   789,   790,   132,   282,    90,   282,
     132,    93,   177,   282,   179,   180,   181,   182,   282,  1300,
       3,   282,   282,    87,  1305,   190,  1307,   192,   193,   194,
    1311,   282,   282,  1314,  1315,  1118,  1119,  1120,   823,   824,
     825,   826,  1323,  1324,  1325,  1326,    40,   282,    42,    43,
      44,    45,    46,    47,   282,    53,    54,   274,   275,   276,
     277,   278,   279,   141,   282,   141,   143,   144,   145,   146,
     147,   148,   149,   150,   151,   152,   282,   862,   243,   864,
     282,    79,   282,   183,    55,    83,   168,   187,    71,    72,
      84,   282,    90,    91,   176,   195,    90,   197,   282,    93,
     282,   141,    85,    86,   216,   217,   218,   219,   220,    92,
     132,    94,    95,  1394,   133,  1396,   273,  1398,   265,  1400,
      76,   203,     5,   205,   141,   207,   141,   141,   210,   214,
     141,   208,   209,     5,   919,  1218,   141,   141,    93,   141,
    1223,   141,  1225,   141,  1227,    93,   141,    79,  1429,   141,
    1431,   236,  1433,   141,  1435,   237,   238,   942,   943,   141,
     242,   243,   244,   141,     5,   141,   132,   249,   132,   251,
     252,   253,   254,   132,   168,   214,    20,   259,   260,   261,
     262,    40,   176,    42,    43,    44,    45,    46,    47,   274,
     275,   276,   277,   278,   279,   132,   132,   236,   133,   281,
     183,   132,   141,   133,   187,   133,   133,   141,   141,   203,
     216,   205,   195,   207,   197,   141,   210,   141,   221,   222,
     223,   224,   225,   226,   227,    84,   229,   141,   141,     3,
     141,    90,   141,   141,    93,   274,   275,   276,   277,   278,
     279,   216,    55,   237,   238,   142,     3,   142,   242,   243,
     244,     5,     5,     5,    55,   249,   216,   251,   252,   253,
     254,     5,   216,   216,     5,   259,   260,   261,   262,    40,
       5,    42,    43,    44,    45,    46,    47,   173,    14,   173,
      16,     5,   142,   250,     5,   142,   215,   281,   141,   141,
      26,    27,    28,    29,     5,    31,    32,    71,    72,   221,
     222,   223,   224,   225,   226,   227,   228,   229,   142,   168,
     216,    85,    86,    84,    71,    72,     5,   176,    92,    90,
      94,    95,    93,   132,   141,     5,   278,     5,    85,    86,
       5,     5,     5,     5,   132,    92,   132,    94,    95,   141,
      76,   141,     5,     5,   203,   173,   205,   173,   207,     4,
     132,   210,    88,    89,     5,     5,     5,     5,     5,     3,
       5,   216,     5,   142,    40,     5,    42,    43,    44,    45,
      46,    47,   132,   141,   141,   141,     5,     5,   237,   238,
       5,     5,   132,   242,   243,   244,   132,     5,     5,     5,
     249,     5,   251,   252,   253,   254,   216,   168,   132,     5,
     259,   260,   261,   262,     3,   176,   216,     5,    84,   183,
       5,     5,     5,   187,    90,     5,     5,    93,     5,     5,
     274,   195,   281,   197,     5,     5,   183,    71,    72,     5,
     187,     5,   203,   132,   205,   133,   207,   132,   195,   210,
     197,    85,    86,   133,   132,   141,   201,     5,    92,     5,
      94,    95,    94,     5,     5,     5,     5,   591,   592,   593,
       5,     5,     5,     5,   141,   132,   237,   238,   132,     5,
     604,   242,   243,   244,   132,   141,   141,     5,   249,     5,
     251,   252,   253,   254,   141,   141,     5,   141,   259,   260,
     261,   262,   168,   219,     5,   141,    55,     5,     5,     5,
     176,   635,   636,   637,   141,   141,   640,   141,   642,   141,
     281,    72,    73,    74,    75,    76,    77,    78,    79,   141,
     654,   655,   141,     5,   658,     5,     5,   203,    12,   205,
     142,   207,   142,   142,   210,   142,   102,   142,   142,   183,
     142,   142,   142,   187,   337,   142,   846,   517,   802,    84,
      75,   195,    75,   197,  1165,   846,   141,  1026,   846,   484,
    1022,   237,   238,   846,  1156,    77,   242,   243,   244,   606,
     612,   609,   565,   249,   846,   251,   252,   253,   254,   141,
       1,   340,   433,   259,   260,   261,   262,   408,   473,   758,
     724,   725,   177,  1178,   179,   180,   181,   182,   443,   156,
      -1,   163,   164,    -1,    -1,   190,    -1,   192,   193,   194,
      -1,    -1,    -1,   175,    -1,   177,   178,   179,   180,   181,
      72,    73,    74,    75,    76,    77,    78,    79,   190,   191,
      72,    73,    74,    75,    76,    77,    78,    79,   772,    -1,
      -1,   775,    96,    97,    98,    99,   100,   101,   102,   103,
     104,   105,   106,   107,   108,   109,   110,   111,   112,   113,
     114,   115,   116,   117,   118,   119,   120,   121,   122,   123,
     124,   125,   126,   127,   128,   129,   130,   131,    72,    73,
      74,    75,    76,    77,    78,    79,    72,    73,    74,    75,
      76,    77,    78,    79,    72,    73,    74,    75,    76,    77,
      78,    79,    72,    73,    74,    75,    76,    77,    78,    79,
      72,    73,    74,    75,    76,    77,    78,    79,    72,    73,
      74,    75,    76,    77,    78,    79,    72,    73,    74,    75,
      76,    77,    78,    79
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint16 yystos[] =
{
       0,     7,   154,   155,   156,   157,   158,   159,   160,   161,
     162,   287,   288,   289,   308,   309,   310,   312,   313,   314,
     315,   318,   319,   320,   321,   322,   323,   324,   330,   340,
     341,   346,   368,   369,   370,   371,   372,   373,   374,   375,
     376,     8,    10,    12,    13,    17,    18,    29,    51,    52,
      59,    61,    70,    85,    87,   187,   200,   206,   271,   451,
     139,   139,   139,   139,   139,   139,   139,   139,   139,     0,
     289,   290,   292,   294,   296,   298,   300,   302,   304,   306,
      11,   133,   141,   132,   342,   343,   347,    19,   280,   133,
     133,   280,   141,   133,   134,   280,    71,   188,   189,   198,
     199,   265,   325,   326,    87,   240,   280,   455,    70,    73,
     239,    73,    73,    73,    16,    73,    73,    16,    39,     3,
      71,    72,    86,    92,    94,    95,   183,   187,   195,   197,
     291,   377,   378,   379,   387,   390,   393,   432,   433,   434,
     435,   447,   450,   451,   452,   458,   459,   460,   461,   462,
     466,   513,   514,   515,   516,     3,   241,   293,   377,   378,
     379,   432,   447,   450,   458,   459,   460,   461,   462,   486,
     500,   509,   510,   512,   513,   516,     3,   295,   377,   378,
     379,   432,   447,   450,   458,   459,   460,   461,   462,   502,
     503,   504,   505,   506,   507,   509,   513,   516,     3,   297,
     377,   378,   379,   432,   447,   450,   458,   459,   460,   461,
     462,   486,   509,   513,   516,     3,   299,   377,   378,   379,
     387,   390,   396,   447,   450,   458,   459,   460,   461,   462,
       3,   301,   377,   378,   379,   447,   450,   458,   459,   460,
     461,   462,   517,   518,   519,   520,   521,     3,   303,   377,
     378,   379,   435,   447,   450,   458,   459,   460,   461,   462,
     469,   305,   377,   378,   379,   432,   447,   450,   458,   459,
     460,   461,   462,   486,   509,   513,   516,     3,   307,   377,
     378,   379,   447,   450,   458,   459,   460,   461,   462,   465,
       9,    71,   311,    76,   344,    90,   343,   444,    14,    16,
      26,    27,    28,    29,    31,    32,    76,    88,    89,   331,
     348,   349,   350,   351,   352,   353,   356,   357,   358,   359,
     360,   332,   316,   230,   231,   232,   233,   508,   135,   136,
     137,   138,   456,   457,   133,   141,   327,   326,   263,   329,
     280,   280,    40,    42,    43,    44,    45,    46,    47,    84,
      90,    93,   168,   176,   203,   205,   207,   210,   237,   238,
     242,   243,   244,   249,   251,   252,   253,   254,   259,   260,
     261,   262,   453,   454,    57,   523,   133,   133,   132,   133,
     132,   133,   133,   133,   132,   133,   132,   133,   380,   382,
     132,   132,     6,   141,   163,   164,   175,   177,   178,   179,
     180,   181,   190,   191,   214,   240,   243,   252,   467,   468,
     472,   476,   478,   479,   480,   481,   482,   483,   380,   380,
     134,   380,   141,   268,   268,   184,   185,   186,    71,   188,
     189,   140,   139,   463,   464,   240,   280,   455,     6,   210,
     211,   212,   213,   214,   238,   240,   259,   485,   511,   240,
     259,   511,     6,   171,   172,   174,   214,   234,   235,   214,
       6,     6,    47,    48,    49,    50,   214,   177,   182,   190,
     192,   193,   194,   470,   471,   473,   474,   475,   477,   480,
     168,   214,   132,    25,   141,    35,   208,   209,   221,   222,
     223,   224,   225,   226,   227,   228,   229,   331,   336,   338,
     339,   345,   384,   385,   141,    75,   386,    21,    22,    24,
     132,   133,   283,   132,   133,    89,    89,   280,   133,   141,
     133,    27,    28,    26,    30,    31,    33,    34,    36,    37,
     170,   281,   333,    60,    62,    63,    64,    65,    66,    67,
      68,    69,   281,   317,   266,   266,   281,   457,   199,    90,
     328,   331,   336,   338,   339,   329,   264,   456,   453,   281,
     454,   141,    90,   203,   205,   381,   382,   383,   443,    74,
      88,   203,   204,   205,   258,   272,   399,   401,    92,   214,
     274,   275,   276,   277,   278,   279,   487,   487,   171,   172,
     487,   487,   487,   487,   260,   261,   252,   487,   141,   495,
     496,   497,   468,   497,   487,    90,   381,   441,    90,   381,
     440,    90,   381,   442,    55,   464,   280,   453,   523,    22,
      23,   237,   501,   237,   238,   485,   501,   487,   278,   279,
     449,   487,   239,   449,   239,   487,   487,   487,   262,   236,
     487,   236,   487,   246,   247,   248,   249,    40,   487,   487,
     487,    48,    49,    40,   487,   487,   471,   497,   487,   487,
     168,   141,   344,    93,   132,   134,   132,   132,   216,   132,
     133,   133,   133,   282,   361,   132,   332,   354,   282,   282,
     282,   282,   282,   282,   282,   282,   282,   282,   282,   282,
     282,   282,   282,   282,   282,   141,   141,   281,   281,   455,
      55,   141,   132,   141,   132,   141,   383,   443,   132,   133,
     132,   141,   132,   141,   132,   141,   265,   273,    76,   400,
     394,   141,   141,   141,   487,   487,   141,   153,   484,   484,
     484,   484,   497,   497,   497,   141,    55,   141,     5,     5,
     484,   141,   441,   141,   440,   141,   442,   453,   281,   141,
      93,   497,   497,   497,    93,   141,   132,   133,   141,   132,
     133,   132,   133,   132,   133,   141,   484,   141,   484,   141,
     484,   497,   487,   141,   484,   487,   484,   397,   397,   397,
      79,   522,   497,   141,   141,   141,   487,   487,   497,   484,
     484,     5,   484,   141,   497,    22,    23,   278,   337,   362,
     363,   364,   132,   132,   365,   366,    20,   367,   281,   203,
     205,   237,   355,   133,   132,   133,    14,    15,    27,    28,
     133,   133,   338,   141,   141,   141,   141,   141,   141,   141,
     141,   141,   216,   455,   523,   216,   497,   497,   497,   497,
     497,   497,   391,   132,   133,   141,   388,    53,    54,    79,
      83,    90,    91,   395,   403,   407,   408,   445,   446,   497,
      55,   141,   484,   141,   484,   142,   508,   142,   508,   142,
     142,     5,     5,     5,   216,   217,   218,   219,   220,   488,
      55,    71,    72,    85,    92,   244,   245,   492,   493,   493,
     216,   216,   216,   281,   455,   497,    54,   497,     5,     5,
       5,   497,   508,   497,   497,   488,   497,   497,   173,   508,
     173,   508,   215,   216,     5,   141,   484,   497,   142,   484,
     142,   508,    16,    56,    90,   238,   398,   436,   437,   438,
     439,   497,   497,   497,   250,   397,     5,   142,    41,   508,
      41,   508,   141,   141,     5,   142,   508,   142,   508,   493,
     142,   497,     5,   337,   337,   132,   365,   365,   365,   367,
     366,   132,   141,   132,   141,   141,   508,   508,   508,   508,
     215,   216,   215,   216,   215,   216,   215,   216,   215,   216,
     523,     5,     5,     5,     5,     5,     5,    35,   259,   331,
     334,   336,   392,   445,   446,   448,   497,   497,   497,    16,
      77,    78,   331,   334,   336,   389,   402,   403,   406,   407,
     408,   445,   446,   448,   497,   132,   132,    80,    81,    82,
      96,    97,    98,    99,   100,   101,   102,   103,   104,   105,
     106,   107,   108,   109,   110,   111,   112,   113,   114,   115,
     116,   117,   118,   119,   120,   121,   122,   123,   124,   125,
     126,   127,   128,   129,   130,   131,   141,   141,     5,     5,
     173,   508,   173,   508,   493,   493,   493,   497,   380,     4,
     499,   499,   455,   523,     5,   132,     5,   493,   493,   493,
       5,   497,     5,     5,   497,     5,     5,   497,   216,   490,
     497,   490,   497,   497,   493,   497,   142,     5,   497,   142,
     508,   497,   497,   132,   141,   141,   141,     5,     5,     5,
     497,   493,   497,   490,   490,   490,   490,    41,   508,    41,
     508,   493,   499,     5,   493,   132,   132,   493,   493,   493,
     493,   493,   493,    38,   449,     5,     5,     5,   132,     5,
     404,   419,   419,    73,   143,   144,   145,   146,   147,   148,
     149,   150,   151,   152,   384,   385,   430,   431,   411,   411,
     413,    74,   169,   170,   196,   409,   410,   417,   428,   216,
     493,    90,   493,   490,   490,   499,     5,    58,   381,   491,
       3,   523,   493,   497,   493,   499,   493,     5,   493,   493,
       5,   493,   493,     5,   497,     5,   497,     5,     5,     5,
     497,   493,     5,   497,   497,     5,     5,   216,   493,   493,
     493,     5,   499,     5,   497,   497,   497,   497,   141,   217,
     218,   219,   489,   141,   489,   141,   489,   141,   489,   499,
     493,   499,   499,   499,   499,   499,   499,   274,   335,   132,
     493,   493,   493,   493,   338,   339,   405,    93,   165,   168,
     196,   202,   284,   384,   385,   420,   421,   422,   423,   424,
     425,   133,   487,   487,   487,   487,   487,   487,   487,   487,
     487,   487,   431,   384,   385,   412,   384,   385,   414,   132,
     132,   141,   133,   410,   267,   270,   415,   416,   418,   201,
     427,   429,   499,   493,    94,   491,   255,   256,   257,   499,
       5,   499,   493,   493,   493,     5,   493,     5,   493,   493,
     493,     5,   499,   493,     5,     5,   493,   493,   499,   499,
     499,   493,   493,     5,     5,     5,     5,   489,   497,   489,
     497,   489,   497,   489,   497,   499,   141,   499,   499,   499,
     499,   132,   166,   167,   487,   132,   133,   132,   426,   141,
     141,   141,   141,   141,   141,   141,   141,   141,   141,   132,
     134,   141,   132,   499,    55,   141,   495,   496,   498,   498,
     498,   493,   499,   499,   499,   493,   499,   493,   499,   499,
     499,   493,   499,   493,   493,   499,   499,   499,   499,   493,
     493,   493,   493,   497,     5,   497,     5,   497,     5,   497,
       5,   219,   141,   269,   285,   142,   142,   142,   142,   142,
     142,   142,   142,   142,   142,    55,     5,     5,     5,   499,
     499,   499,   499,   499,   499,   499,   499,   499,   499,     5,
     493,     5,   493,     5,   493,     5,   493,   492,   494,   494,
     494,   493,   499,   493,   499,   493,   499,   493,   499,   499,
     499,   499,   499
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint16 yyr1[] =
{
       0,   286,   287,   287,   288,   288,   289,   289,   289,   289,
     289,   289,   289,   289,   289,   289,   289,   289,   289,   289,
     289,   289,   289,   289,   289,   289,   289,   289,   289,   289,
     289,   289,   289,   290,   290,   291,   291,   291,   291,   291,
     291,   291,   291,   291,   291,   291,   291,   291,   291,   291,
     291,   291,   291,   291,   291,   291,   291,   292,   292,   293,
     293,   293,   293,   293,   293,   293,   293,   293,   293,   293,
     293,   293,   293,   293,   293,   293,   293,   294,   294,   295,
     295,   295,   295,   295,   295,   295,   295,   295,   295,   295,
     295,   295,   295,   295,   295,   295,   295,   295,   295,   296,
     296,   297,   297,   297,   297,   297,   297,   297,   297,   297,
     297,   297,   297,   297,   297,   297,   298,   298,   299,   299,
     299,   299,   299,   299,   299,   299,   299,   299,   299,   299,
     299,   300,   300,   301,   301,   301,   301,   301,   301,   301,
     301,   301,   301,   301,   301,   301,   301,   301,   302,   302,
     303,   303,   303,   303,   303,   303,   303,   303,   303,   303,
     303,   303,   304,   304,   305,   305,   305,   305,   305,   305,
     305,   305,   305,   305,   305,   305,   305,   305,   305,   306,
     306,   307,   307,   307,   307,   307,   307,   307,   307,   307,
     307,   307,   308,   308,   308,   309,   310,   311,   311,   312,
     313,   313,   313,   314,   315,   316,   316,   317,   317,   317,
     317,   317,   317,   317,   317,   317,   317,   317,   317,   317,
     317,   318,   319,   319,   319,   320,   320,   320,   321,   322,
     323,   324,   325,   325,   326,   327,   327,   328,   328,   328,
     328,   328,   329,   329,   330,   331,   331,   332,   332,   333,
     333,   333,   333,   333,   333,   333,   333,   333,   333,   334,
     335,   335,   336,   336,   336,   337,   337,   338,   338,   338,
     338,   338,   338,   338,   338,   339,   340,   341,   342,   342,
     343,   343,   344,   344,   345,   345,   345,   345,   345,   345,
     346,   347,   347,   348,   348,   348,   348,   348,   348,   348,
     348,   348,   349,   350,   351,   352,   353,   354,   354,   355,
     355,   355,   355,   355,   356,   356,   357,   357,   358,   358,
     359,   360,   360,   360,   360,   360,   360,   361,   360,   362,
     360,   363,   360,   364,   360,   360,   365,   365,   366,   367,
     367,   368,   368,   368,   368,   369,   370,   370,   371,   372,
     373,   373,   374,   375,   376,   376,   377,   377,   378,   378,
     379,   379,   380,   380,   381,   381,   382,   382,   383,   383,
     383,   383,   384,   384,   385,   386,   386,   387,   388,   388,
     389,   389,   389,   389,   389,   389,   389,   389,   389,   389,
     389,   390,   391,   391,   392,   392,   392,   392,   392,   392,
     393,   394,   394,   395,   395,   395,   395,   395,   396,   396,
     396,   396,   397,   397,   398,   398,   398,   398,   399,   399,
     400,   401,   402,   402,   403,   403,   403,   404,   404,   405,
     405,   406,   407,   407,   407,   407,   407,   407,   407,   407,
     407,   407,   407,   407,   407,   407,   407,   407,   407,   407,
     407,   407,   407,   407,   407,   407,   407,   407,   407,   407,
     407,   407,   407,   407,   407,   407,   407,   407,   408,   408,
     409,   409,   410,   410,   410,   410,   411,   411,   412,   412,
     413,   413,   414,   414,   415,   415,   416,   417,   417,   418,
     418,   419,   419,   420,   420,   420,   420,   420,   420,   420,
     420,   421,   422,   422,   423,   423,   424,   425,   426,   426,
     427,   428,   428,   429,   430,   430,   431,   431,   431,   431,
     431,   431,   431,   431,   431,   431,   431,   431,   431,   432,
     432,   433,   434,   435,   436,   437,   438,   439,   440,   440,
     441,   441,   442,   442,   443,   443,   444,   444,   445,   446,
     447,   447,   448,   449,   449,   450,   450,   450,   450,   451,
     452,   453,   453,   454,   454,   454,   454,   454,   454,   454,
     454,   454,   454,   454,   454,   454,   454,   454,   454,   454,
     454,   454,   454,   454,   454,   454,   454,   454,   454,   454,
     454,   454,   454,   455,   455,   456,   456,   457,   457,   457,
     457,   458,   458,   458,   459,   459,   459,   460,   460,   460,
     461,   462,   463,   463,   464,   465,   465,   466,   467,   467,
     468,   468,   468,   468,   468,   468,   468,   469,   470,   470,
     471,   471,   471,   471,   472,   472,   473,   474,   474,   474,
     474,   475,   475,   476,   476,   476,   476,   477,   477,   478,
     479,   480,   481,   481,   481,   482,   482,   483,   483,   484,
     484,   485,   485,   485,   485,   486,   486,   487,   487,   487,
     487,   487,   487,   487,   487,   488,   488,   488,   488,   488,
     488,   489,   489,   489,   490,   490,   491,   491,   491,   492,
     492,   492,   492,   492,   492,   492,   493,   494,   495,   496,
     497,   497,   497,   498,   498,   498,   499,   499,   499,   499,
     500,   500,   500,   501,   501,   501,   502,   502,   502,   502,
     503,   503,   503,   503,   504,   504,   505,   505,   506,   506,
     507,   508,   508,   508,   508,   508,   509,   509,   510,   510,
     510,   510,   510,   510,   510,   510,   511,   511,   512,   512,
     513,   513,   514,   514,   515,   515,   516,   516,   517,   518,
     519,   520,   520,   520,   520,   520,   520,   521,   521,   521,
     521,   521,   521,   522,   523,   523,   523
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     0,     1,     1,     2,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     0,     2,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     0,     2,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     0,     2,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     0,
       2,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     0,     2,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     0,     2,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     0,     2,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     0,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     0,
       2,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     4,     7,     8,     4,     3,     0,     3,     2,
       3,     3,     3,     4,     5,     0,     2,     4,     4,     4,
       4,     4,     4,     4,     4,     4,     4,     4,     4,     4,
       4,     2,     3,     3,     5,     4,     6,     4,     3,     3,
       3,     3,     2,     3,     2,     0,     2,     3,     1,     1,
       1,     1,     0,     2,     5,     1,     4,     0,     2,     3,
       3,     3,     3,     3,     3,     3,     3,     3,     3,     5,
       0,     1,     4,     5,     5,     0,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     2,     5,     5,     1,     2,
       2,     4,     0,     2,     1,     1,     1,     1,     1,     1,
       3,     0,     2,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     2,     2,     1,     2,     3,     0,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     1,     1,
       2,     5,     4,     2,     3,     3,     3,     0,     4,     0,
       5,     0,     5,     0,     5,     2,     1,     2,     1,     0,
       1,     4,     4,     4,     4,     4,     4,     4,     4,     4,
       4,     4,     2,     4,     5,     6,     3,     4,     3,     4,
       3,     4,     1,     2,     1,     2,     1,     1,     2,     2,
       2,     2,     2,     2,     2,     0,     2,     9,     0,     2,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     9,     0,     2,     1,     1,     1,     1,     1,     1,
       8,     0,     2,     1,     1,     1,     1,     1,     9,     8,
       8,     8,     0,     2,     1,     1,     1,     1,     0,     2,
       2,     2,     1,     1,     2,     3,     2,     0,     2,     1,
       1,     2,     3,     2,     2,     2,     2,     2,     3,     3,
       2,     2,     2,     2,     2,     2,     3,     3,     2,     2,
       2,     2,     2,     2,     3,     3,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     3,     2,     3,     2,     2,
       1,     2,     2,     2,     2,     2,     0,     2,     1,     1,
       0,     2,     1,     1,     2,     2,     2,     0,     2,     1,
       1,     0,     2,     1,     1,     1,     1,     1,     1,     1,
       3,     3,     2,     2,     2,     2,     2,     2,     0,     2,
       2,     0,     2,     1,     1,     2,     1,     1,     2,     4,
       4,     4,     4,     4,     4,     4,     4,     4,     4,     7,
       6,     6,     6,     9,     2,     2,     3,     2,     0,     3,
       0,     3,     0,     3,     0,     3,     0,     3,     3,     2,
       7,     7,     3,     1,     1,     3,     6,     7,     1,     2,
       2,     1,     2,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     0,     4,     1,     2,     2,     2,     1,
       1,     3,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     1,     2,     1,     8,     6,     6,     1,     2,
       1,     1,     1,     1,     1,     1,     1,     6,     1,     2,
       1,     1,     1,     1,     4,     4,     4,     1,     1,     1,
       1,     4,     4,     4,     4,     4,     4,     4,     4,     3,
       3,     3,     1,     1,     1,     6,     5,     6,     5,     1,
       1,     1,     1,     1,     1,     9,     6,     0,     1,     1,
       1,     1,     1,     1,     1,     0,     1,     1,     1,     1,
       1,     1,     1,     1,     0,     1,     0,     3,     4,     1,
       3,     4,     1,     1,     1,     1,     1,     1,     2,     3,
       0,     1,     1,     0,     1,     1,     0,     6,     6,     6,
       8,    10,     7,     0,     1,     1,     8,     9,     9,    10,
       9,     9,    10,    10,    10,     9,    10,     9,     9,     9,
       6,     0,     1,     1,     1,     1,     8,     7,     7,     7,
       4,     4,     7,     7,     4,     4,     0,     1,     9,     6,
       8,     8,     8,     8,     9,     9,     8,     8,     7,     7,
       9,    10,    11,    12,    10,    11,    12,    10,    11,    12,
      10,    11,    12,     2,     0,     2,     3
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 192:
#line 593 "src/p.y" /* yacc.c:1646  */
    {
                        mailset.events = Event_All;
                        addmail((yyvsp[-2].string), &mailset, &Run.maillist);
                  }
#line 3241 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 193:
#line 597 "src/p.y" /* yacc.c:1646  */
    {
                        addmail((yyvsp[-5].string), &mailset, &Run.maillist);
                  }
#line 3249 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 194:
#line 600 "src/p.y" /* yacc.c:1646  */
    {
                        mailset.events = ~mailset.events;
                        addmail((yyvsp[-6].string), &mailset, &Run.maillist);
                  }
#line 3258 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 195:
#line 606 "src/p.y" /* yacc.c:1646  */
    {
                        if (! (Run.flags & Run_Daemon) || ihp.daemon) {
                                ihp.daemon     = true;
                                Run.flags      |= Run_Daemon;
                                Run.polltime   = (yyvsp[-1].number);
                                Run.startdelay = (yyvsp[0].number);
                        }
                  }
#line 3271 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 196:
#line 616 "src/p.y" /* yacc.c:1646  */
    {
                        Run.flags |= Run_Batch;
                  }
#line 3279 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 197:
#line 621 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = START_DELAY;
                  }
#line 3287 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 198:
#line 624 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = (yyvsp[0].number);
                  }
#line 3295 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 199:
#line 629 "src/p.y" /* yacc.c:1646  */
    {
                        Run.flags |= Run_Foreground;
                  }
#line 3303 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 200:
#line 634 "src/p.y" /* yacc.c:1646  */
    {
                        Run.onreboot = Onreboot_Start;
                  }
#line 3311 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 201:
#line 637 "src/p.y" /* yacc.c:1646  */
    {
                        Run.onreboot = Onreboot_Nostart;
                  }
#line 3319 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 202:
#line 640 "src/p.y" /* yacc.c:1646  */
    {
                        Run.onreboot = Onreboot_Laststate;
                  }
#line 3327 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 203:
#line 645 "src/p.y" /* yacc.c:1646  */
    {
                        // Note: deprecated (replaced by "set limits" statement's "sendExpectBuffer" option)
                        Run.limits.sendExpectBuffer = (yyvsp[-1].number) * (yyvsp[0].number);
                  }
#line 3336 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 207:
#line 658 "src/p.y" /* yacc.c:1646  */
    {
                        Run.limits.sendExpectBuffer = (yyvsp[-1].number) * (yyvsp[0].number);
                  }
#line 3344 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 208:
#line 661 "src/p.y" /* yacc.c:1646  */
    {
                        Run.limits.fileContentBuffer = (yyvsp[-1].number) * (yyvsp[0].number);
                  }
#line 3352 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 209:
#line 664 "src/p.y" /* yacc.c:1646  */
    {
                        Run.limits.httpContentBuffer = (yyvsp[-1].number) * (yyvsp[0].number);
                  }
#line 3360 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 210:
#line 667 "src/p.y" /* yacc.c:1646  */
    {
                        Run.limits.programOutput = (yyvsp[-1].number) * (yyvsp[0].number);
                  }
#line 3368 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 211:
#line 670 "src/p.y" /* yacc.c:1646  */
    {
                        Run.limits.networkTimeout = (yyvsp[-1].number);
                  }
#line 3376 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 212:
#line 673 "src/p.y" /* yacc.c:1646  */
    {
                        Run.limits.networkTimeout = (yyvsp[-1].number) * 1000;
                  }
#line 3384 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 213:
#line 676 "src/p.y" /* yacc.c:1646  */
    {
                        Run.limits.programTimeout = (yyvsp[-1].number);
                  }
#line 3392 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 214:
#line 679 "src/p.y" /* yacc.c:1646  */
    {
                        Run.limits.programTimeout = (yyvsp[-1].number) * 1000;
                  }
#line 3400 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 215:
#line 682 "src/p.y" /* yacc.c:1646  */
    {
                        Run.limits.stopTimeout = (yyvsp[-1].number);
                  }
#line 3408 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 216:
#line 685 "src/p.y" /* yacc.c:1646  */
    {
                        Run.limits.stopTimeout = (yyvsp[-1].number) * 1000;
                  }
#line 3416 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 217:
#line 688 "src/p.y" /* yacc.c:1646  */
    {
                        Run.limits.startTimeout = (yyvsp[-1].number);
                  }
#line 3424 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 218:
#line 691 "src/p.y" /* yacc.c:1646  */
    {
                        Run.limits.startTimeout = (yyvsp[-1].number) * 1000;
                  }
#line 3432 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 219:
#line 694 "src/p.y" /* yacc.c:1646  */
    {
                        Run.limits.restartTimeout = (yyvsp[-1].number);
                  }
#line 3440 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 220:
#line 697 "src/p.y" /* yacc.c:1646  */
    {
                        Run.limits.restartTimeout = (yyvsp[-1].number) * 1000;
                  }
#line 3448 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 221:
#line 702 "src/p.y" /* yacc.c:1646  */
    {
                        Run.flags |= Run_FipsEnabled;
                  }
#line 3456 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 222:
#line 707 "src/p.y" /* yacc.c:1646  */
    {
                        if (! Run.files.log || ihp.logfile) {
                                ihp.logfile = true;
                                setlogfile((yyvsp[0].string));
                                Run.flags &= ~Run_UseSyslog;
                                Run.flags |= Run_Log;
                        }
                  }
#line 3469 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 223:
#line 715 "src/p.y" /* yacc.c:1646  */
    {
                        setsyslog(NULL);
                  }
#line 3477 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 224:
#line 718 "src/p.y" /* yacc.c:1646  */
    {
                        setsyslog((yyvsp[0].string)); FREE((yyvsp[0].string));
                  }
#line 3485 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 225:
#line 723 "src/p.y" /* yacc.c:1646  */
    {
                        Run.eventlist_dir = (yyvsp[0].string);
                  }
#line 3493 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 226:
#line 726 "src/p.y" /* yacc.c:1646  */
    {
                        Run.eventlist_dir = (yyvsp[-2].string);
                        Run.eventlist_slots = (yyvsp[0].number);
                  }
#line 3502 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 227:
#line 730 "src/p.y" /* yacc.c:1646  */
    {
                        Run.eventlist_dir = Str_dup(MYEVENTLISTBASE);
                        Run.eventlist_slots = (yyvsp[0].number);
                  }
#line 3511 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 228:
#line 736 "src/p.y" /* yacc.c:1646  */
    {
                        Run.files.id = (yyvsp[0].string);
                  }
#line 3519 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 229:
#line 741 "src/p.y" /* yacc.c:1646  */
    {
                        Run.files.state = (yyvsp[0].string);
                  }
#line 3527 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 230:
#line 746 "src/p.y" /* yacc.c:1646  */
    {
                        if (! Run.files.pid || ihp.pidfile) {
                                ihp.pidfile = true;
                                setpidfile((yyvsp[0].string));
                        }
                  }
#line 3538 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 234:
#line 761 "src/p.y" /* yacc.c:1646  */
    {
                        mmonitset.url = (yyvsp[-1].url);
                        addmmonit(&mmonitset);
                  }
#line 3547 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 237:
#line 771 "src/p.y" /* yacc.c:1646  */
    {
                        mmonitset.timeout = (yyvsp[-1].number) * 1000; // net timeout is in milliseconds internally
                  }
#line 3555 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 243:
#line 781 "src/p.y" /* yacc.c:1646  */
    {
                        Run.flags &= ~Run_MmonitCredentials;
                  }
#line 3563 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 244:
#line 786 "src/p.y" /* yacc.c:1646  */
    {
                        _setSSLOptions(&(Run.ssl));
                  }
#line 3571 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 245:
#line 791 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                  }
#line 3579 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 249:
#line 801 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                        sslset.verify = true;
                  }
#line 3588 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 250:
#line 805 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                        sslset.verify = false;
                  }
#line 3597 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 251:
#line 809 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                        sslset.allowSelfSigned = true;
                  }
#line 3606 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 252:
#line 813 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                        sslset.allowSelfSigned = false;
                  }
#line 3615 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 253:
#line 817 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                  }
#line 3623 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 254:
#line 820 "src/p.y" /* yacc.c:1646  */
    {
                        FREE(sslset.ciphers);
                        sslset.ciphers = (yyvsp[0].string);
                  }
#line 3632 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 255:
#line 824 "src/p.y" /* yacc.c:1646  */
    {
                        _setPEM(&(sslset.pemfile), (yyvsp[0].string), "SSL server PEM file", true);
                  }
#line 3640 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 256:
#line 827 "src/p.y" /* yacc.c:1646  */
    {
                        _setPEM(&(sslset.clientpemfile), (yyvsp[0].string), "SSL client PEM file", true);
                  }
#line 3648 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 257:
#line 830 "src/p.y" /* yacc.c:1646  */
    {
                        _setPEM(&(sslset.CACertificateFile), (yyvsp[0].string), "SSL CA certificates file", true);
                  }
#line 3656 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 258:
#line 833 "src/p.y" /* yacc.c:1646  */
    {
                        _setPEM(&(sslset.CACertificatePath), (yyvsp[0].string), "SSL CA certificates directory", false);
                  }
#line 3664 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 259:
#line 838 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                        portset.target.net.ssl.certificate.minimumDays = (yyvsp[-1].number);
                  }
#line 3673 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 262:
#line 848 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                        sslset.checksum = (yyvsp[0].string);
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
#line 3692 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 263:
#line 862 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                        sslset.checksum = (yyvsp[0].string);
                        if (cleanup_hash_string(sslset.checksum) != 32)
                                yyerror2("Unknown checksum type: [%s] is not MD5", sslset.checksum);
                        sslset.checksumType = Hash_Md5;
                  }
#line 3704 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 264:
#line 869 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                        sslset.checksum = (yyvsp[0].string);
                        if (cleanup_hash_string(sslset.checksum) != 40)
                                yyerror2("Unknown checksum type: [%s] is not SHA1", sslset.checksum);
                        sslset.checksumType = Hash_Sha1;
                  }
#line 3716 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 267:
#line 882 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_V2;
                  }
#line 3725 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 268:
#line 886 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_V3;
                  }
#line 3734 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 269:
#line 890 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_TLSV1;
                  }
#line 3743 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 270:
#line 895 "src/p.y" /* yacc.c:1646  */
    {
#ifndef HAVE_TLSV1_1
                        yyerror("Your SSL Library does not support TLS version 1.1");
#endif
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_TLSV11;
                }
#line 3755 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 271:
#line 903 "src/p.y" /* yacc.c:1646  */
    {
#ifndef HAVE_TLSV1_2
                        yyerror("Your SSL Library does not support TLS version 1.2");
#endif
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_TLSV12;
                }
#line 3767 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 272:
#line 911 "src/p.y" /* yacc.c:1646  */
    {
#ifndef HAVE_TLSV1_3
                        yyerror("Your SSL Library does not support TLS version 1.3");
#endif
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_TLSV13;
                }
#line 3779 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 273:
#line 919 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_Auto;
                  }
#line 3788 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 274:
#line 923 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_Auto;
                  }
#line 3797 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 275:
#line 929 "src/p.y" /* yacc.c:1646  */
    { // Backward compatibility
                        sslset.flags = SSL_Enabled;
                        sslset.checksum = (yyvsp[0].string);
                        if (cleanup_hash_string(sslset.checksum) != 32)
                                yyerror2("Unknown checksum type: [%s] is not MD5", sslset.checksum);
                        sslset.checksumType = Hash_Md5;
                  }
#line 3809 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 276:
#line 938 "src/p.y" /* yacc.c:1646  */
    {
                        if (((yyvsp[-1].number)) > SMTP_TIMEOUT)
                                Run.mailserver_timeout = (yyvsp[-1].number);
                        Run.mail_hostname = (yyvsp[0].string);
                  }
#line 3819 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 277:
#line 945 "src/p.y" /* yacc.c:1646  */
    {
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
#line 3837 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 280:
#line 964 "src/p.y" /* yacc.c:1646  */
    {
                        /* Restore the current text overriden by lookahead */
                        FREE(argyytext);
                        argyytext = Str_dup((yyvsp[-1].string));

                        mailserverset.host = (yyvsp[-1].string);
                        mailserverset.port = PORT_SMTP;
                        addmailserver(&mailserverset);
                  }
#line 3851 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 281:
#line 973 "src/p.y" /* yacc.c:1646  */
    {
                        /* Restore the current text overriden by lookahead */
                        FREE(argyytext);
                        argyytext = Str_dup((yyvsp[-3].string));

                        mailserverset.host = (yyvsp[-3].string);
                        mailserverset.port = (yyvsp[-1].number);
                        addmailserver(&mailserverset);
                  }
#line 3865 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 284:
#line 988 "src/p.y" /* yacc.c:1646  */
    {
                        mailserverset.username = (yyvsp[0].string);
                  }
#line 3873 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 285:
#line 991 "src/p.y" /* yacc.c:1646  */
    {
                        mailserverset.password = (yyvsp[0].string);
                  }
#line 3881 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 290:
#line 1000 "src/p.y" /* yacc.c:1646  */
    {
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
#line 3901 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 302:
#line 1033 "src/p.y" /* yacc.c:1646  */
    {
                        _setPEM(&(sslset.pemfile), (yyvsp[0].string), "SSL server PEM file", true);
                  }
#line 3909 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 303:
#line 1039 "src/p.y" /* yacc.c:1646  */
    {
                        _setPEM(&(sslset.clientpemfile), (yyvsp[0].string), "SSL client PEM file", true);
                  }
#line 3917 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 304:
#line 1045 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                        sslset.allowSelfSigned = true;
                  }
#line 3926 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 305:
#line 1051 "src/p.y" /* yacc.c:1646  */
    {
                        Run.httpd.flags |= Httpd_Net;
                        Run.httpd.socket.net.port = (yyvsp[0].number);
                  }
#line 3935 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 306:
#line 1057 "src/p.y" /* yacc.c:1646  */
    {
                        Run.httpd.flags |= Httpd_Unix;
                        Run.httpd.socket.unix.path = (yyvsp[-1].string);
                  }
#line 3944 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 309:
#line 1067 "src/p.y" /* yacc.c:1646  */
    {
                        Run.httpd.flags |= Httpd_UnixUid;
                        Run.httpd.socket.unix.uid = get_uid((yyvsp[0].string), 0);
                        FREE((yyvsp[0].string));
                    }
#line 3954 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 310:
#line 1072 "src/p.y" /* yacc.c:1646  */
    {
                        Run.httpd.flags |= Httpd_UnixGid;
                        Run.httpd.socket.unix.gid = get_gid((yyvsp[0].string), 0);
                        FREE((yyvsp[0].string));
                    }
#line 3964 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 311:
#line 1077 "src/p.y" /* yacc.c:1646  */
    {
                        Run.httpd.flags |= Httpd_UnixUid;
                        Run.httpd.socket.unix.uid = get_uid(NULL, (yyvsp[0].number));
                    }
#line 3973 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 312:
#line 1081 "src/p.y" /* yacc.c:1646  */
    {
                        Run.httpd.flags |= Httpd_UnixGid;
                        Run.httpd.socket.unix.gid = get_gid(NULL, (yyvsp[0].number));
                    }
#line 3982 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 313:
#line 1085 "src/p.y" /* yacc.c:1646  */
    {
                        Run.httpd.flags |= Httpd_UnixPermission;
                        Run.httpd.socket.unix.permission = check_perm((yyvsp[0].number));
                    }
#line 3991 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 318:
#line 1099 "src/p.y" /* yacc.c:1646  */
    {
                        Run.httpd.flags |= Httpd_Signature;
                  }
#line 3999 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 319:
#line 1102 "src/p.y" /* yacc.c:1646  */
    {
                        Run.httpd.flags &= ~Httpd_Signature;
                  }
#line 4007 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 320:
#line 1107 "src/p.y" /* yacc.c:1646  */
    {
                        Run.httpd.socket.net.address = (yyvsp[0].string);
                  }
#line 4015 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 321:
#line 1112 "src/p.y" /* yacc.c:1646  */
    {
                        addcredentials((yyvsp[-3].string), (yyvsp[-1].string), Digest_Cleartext, (yyvsp[0].number));
                  }
#line 4023 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 322:
#line 1115 "src/p.y" /* yacc.c:1646  */
    {
#ifdef HAVE_LIBPAM
                        addpamauth((yyvsp[-1].string), (yyvsp[0].number));
#else
                        yyerror("PAM is not supported");
                        FREE((yyvsp[-1].string));
#endif
                  }
#line 4036 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 323:
#line 1123 "src/p.y" /* yacc.c:1646  */
    {
                        addhtpasswdentry((yyvsp[0].string), NULL, Digest_Cleartext);
                        FREE((yyvsp[0].string));
                  }
#line 4045 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 324:
#line 1127 "src/p.y" /* yacc.c:1646  */
    {
                        addhtpasswdentry((yyvsp[0].string), NULL, Digest_Cleartext);
                        FREE((yyvsp[0].string));
                  }
#line 4054 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 325:
#line 1131 "src/p.y" /* yacc.c:1646  */
    {
                        addhtpasswdentry((yyvsp[0].string), NULL, Digest_Md5);
                        FREE((yyvsp[0].string));
                  }
#line 4063 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 326:
#line 1135 "src/p.y" /* yacc.c:1646  */
    {
                        addhtpasswdentry((yyvsp[0].string), NULL, Digest_Crypt);
                        FREE((yyvsp[0].string));
                  }
#line 4072 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 327:
#line 1139 "src/p.y" /* yacc.c:1646  */
    {
                        htpasswd_file = (yyvsp[0].string);
                        digesttype = Digest_Cleartext;
                  }
#line 4081 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 328:
#line 1143 "src/p.y" /* yacc.c:1646  */
    {
                        FREE(htpasswd_file);
                  }
#line 4089 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 329:
#line 1146 "src/p.y" /* yacc.c:1646  */
    {
                        htpasswd_file = (yyvsp[0].string);
                        digesttype = Digest_Cleartext;
                  }
#line 4098 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 330:
#line 1150 "src/p.y" /* yacc.c:1646  */
    {
                        FREE(htpasswd_file);
                  }
#line 4106 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 331:
#line 1153 "src/p.y" /* yacc.c:1646  */
    {
                        htpasswd_file = (yyvsp[0].string);
                        digesttype = Digest_Md5;
                  }
#line 4115 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 332:
#line 1157 "src/p.y" /* yacc.c:1646  */
    {
                        FREE(htpasswd_file);
                  }
#line 4123 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 333:
#line 1160 "src/p.y" /* yacc.c:1646  */
    {
                        htpasswd_file = (yyvsp[0].string);
                        digesttype = Digest_Crypt;
                  }
#line 4132 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 334:
#line 1164 "src/p.y" /* yacc.c:1646  */
    {
                        FREE(htpasswd_file);
                  }
#line 4140 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 335:
#line 1167 "src/p.y" /* yacc.c:1646  */
    {
                        if (! Engine_addAllow((yyvsp[0].string)))
                                yywarning2("invalid allow option", (yyvsp[0].string));
                        FREE((yyvsp[0].string));
                  }
#line 4150 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 338:
#line 1178 "src/p.y" /* yacc.c:1646  */
    {
                        addhtpasswdentry(htpasswd_file, (yyvsp[0].string), digesttype);
                        FREE((yyvsp[0].string));
                  }
#line 4159 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 339:
#line 1184 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = false;
                  }
#line 4167 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 340:
#line 1187 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = true;
                  }
#line 4175 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 341:
#line 1192 "src/p.y" /* yacc.c:1646  */
    {
                        createservice(Service_Process, (yyvsp[-2].string), (yyvsp[0].string), check_process);
                  }
#line 4183 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 342:
#line 1195 "src/p.y" /* yacc.c:1646  */
    {
                        createservice(Service_Process, (yyvsp[-2].string), (yyvsp[0].string), check_process);
                  }
#line 4191 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 343:
#line 1198 "src/p.y" /* yacc.c:1646  */
    {
                        createservice(Service_Process, (yyvsp[-2].string), (yyvsp[0].string), check_process);
                        matchset.ignore = false;
                        matchset.match_path = NULL;
                        matchset.match_string = Str_dup((yyvsp[0].string));
                        addmatch(&matchset, Action_Ignored, 0);
                  }
#line 4203 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 344:
#line 1205 "src/p.y" /* yacc.c:1646  */
    {
                        createservice(Service_Process, (yyvsp[-2].string), (yyvsp[0].string), check_process);
                        matchset.ignore = false;
                        matchset.match_path = NULL;
                        matchset.match_string = Str_dup((yyvsp[0].string));
                        addmatch(&matchset, Action_Ignored, 0);
                  }
#line 4215 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 345:
#line 1214 "src/p.y" /* yacc.c:1646  */
    {
                        createservice(Service_File, (yyvsp[-2].string), (yyvsp[0].string), check_file);
                  }
#line 4223 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 346:
#line 1219 "src/p.y" /* yacc.c:1646  */
    {
                        createservice(Service_Filesystem, (yyvsp[-2].string), (yyvsp[0].string), check_filesystem);
                  }
#line 4231 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 347:
#line 1222 "src/p.y" /* yacc.c:1646  */
    {
                        createservice(Service_Filesystem, (yyvsp[-2].string), (yyvsp[0].string), check_filesystem);
                  }
#line 4239 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 348:
#line 1227 "src/p.y" /* yacc.c:1646  */
    {
                        createservice(Service_Directory, (yyvsp[-2].string), (yyvsp[0].string), check_directory);
                  }
#line 4247 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 349:
#line 1232 "src/p.y" /* yacc.c:1646  */
    {
                        createservice(Service_Host, (yyvsp[-2].string), (yyvsp[0].string), check_remote_host);
                  }
#line 4255 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 350:
#line 1237 "src/p.y" /* yacc.c:1646  */
    {
                        if (Link_isGetByAddressSupported()) {
                                createservice(Service_Net, (yyvsp[-2].string), (yyvsp[0].string), check_net);
                                current->inf.net->stats = Link_createForAddress((yyvsp[0].string));
                        } else {
                                yyerror("Network monitoring by IP address is not supported on this platform, please use 'check network <foo> with interface <bar>' instead");
                        }
                  }
#line 4268 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 351:
#line 1245 "src/p.y" /* yacc.c:1646  */
    {
                        createservice(Service_Net, (yyvsp[-2].string), (yyvsp[0].string), check_net);
                        current->inf.net->stats = Link_createForInterface((yyvsp[0].string));
                  }
#line 4277 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 352:
#line 1251 "src/p.y" /* yacc.c:1646  */
    {
                        char *servicename = (yyvsp[0].string);
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
#line 4295 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 353:
#line 1266 "src/p.y" /* yacc.c:1646  */
    {
                        createservice(Service_Fifo, (yyvsp[-2].string), (yyvsp[0].string), check_fifo);
                  }
#line 4303 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 354:
#line 1271 "src/p.y" /* yacc.c:1646  */
    {
                        command_t c = command; // Current command
                        check_exec(c->arg[0]);
                        createservice(Service_Program, (yyvsp[-3].string), NULL, check_program);
                        current->program->timeout = (yyvsp[0].number);
                        current->program->lastOutput = StringBuffer_create(64);
                        current->program->inprogressOutput = StringBuffer_create(64);
                 }
#line 4316 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 355:
#line 1279 "src/p.y" /* yacc.c:1646  */
    {
                        command_t c = command; // Current command
                        check_exec(c->arg[0]);
                        createservice(Service_Program, (yyvsp[-4].string), NULL, check_program);
                        current->program->timeout = (yyvsp[0].number);
                        current->program->lastOutput = StringBuffer_create(64);
                        current->program->inprogressOutput = StringBuffer_create(64);
                 }
#line 4329 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 356:
#line 1289 "src/p.y" /* yacc.c:1646  */
    {
                        addcommand(START, (yyvsp[0].number));
                  }
#line 4337 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 357:
#line 1292 "src/p.y" /* yacc.c:1646  */
    {
                        addcommand(START, (yyvsp[0].number));
                  }
#line 4345 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 358:
#line 1297 "src/p.y" /* yacc.c:1646  */
    {
                        addcommand(STOP, (yyvsp[0].number));
                  }
#line 4353 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 359:
#line 1300 "src/p.y" /* yacc.c:1646  */
    {
                        addcommand(STOP, (yyvsp[0].number));
                  }
#line 4361 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 360:
#line 1306 "src/p.y" /* yacc.c:1646  */
    {
                        addcommand(RESTART, (yyvsp[0].number));
                  }
#line 4369 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 361:
#line 1309 "src/p.y" /* yacc.c:1646  */
    {
                        addcommand(RESTART, (yyvsp[0].number));
                  }
#line 4377 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 366:
#line 1322 "src/p.y" /* yacc.c:1646  */
    {
                        addargument((yyvsp[0].string));
                  }
#line 4385 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 367:
#line 1325 "src/p.y" /* yacc.c:1646  */
    {
                        addargument((yyvsp[0].string));
                  }
#line 4393 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 368:
#line 1330 "src/p.y" /* yacc.c:1646  */
    {
                        addeuid(get_uid((yyvsp[0].string), 0));
                        FREE((yyvsp[0].string));
                  }
#line 4402 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 369:
#line 1334 "src/p.y" /* yacc.c:1646  */
    {
                        addegid(get_gid((yyvsp[0].string), 0));
                        FREE((yyvsp[0].string));
                  }
#line 4411 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 370:
#line 1338 "src/p.y" /* yacc.c:1646  */
    {
                        addeuid(get_uid(NULL, (yyvsp[0].number)));
                  }
#line 4419 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 371:
#line 1341 "src/p.y" /* yacc.c:1646  */
    {
                        addegid(get_gid(NULL, (yyvsp[0].number)));
                  }
#line 4427 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 372:
#line 1346 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.string) = (yyvsp[0].string);
                  }
#line 4435 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 373:
#line 1349 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.string) = (yyvsp[0].string);
                  }
#line 4443 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 374:
#line 1354 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.string) = (yyvsp[0].string);
                  }
#line 4451 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 375:
#line 1359 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.string) = NULL;
                  }
#line 4459 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 376:
#line 1362 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.string) = (yyvsp[0].string);
                  }
#line 4467 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 377:
#line 1367 "src/p.y" /* yacc.c:1646  */
    {
                        /* This is a workaround to support content match without having to create an URL object. 'urloption' creates the Request_T object we need minus the URL object, but with enough information to perform content test.
                           TODO: Parser is in need of refactoring */
                        portset.url_request = urlrequest;
                        addeventaction(&(portset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addport(&(current->portlist), &portset);
                  }
#line 4479 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 391:
#line 1393 "src/p.y" /* yacc.c:1646  */
    {
                        prepare_urlrequest((yyvsp[-5].url));
                        addeventaction(&(portset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addport(&(current->portlist), &portset);
                  }
#line 4489 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 400:
#line 1412 "src/p.y" /* yacc.c:1646  */
    {
                        addeventaction(&(portset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addport(&(current->socketlist), &portset);
                  }
#line 4498 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 408:
#line 1429 "src/p.y" /* yacc.c:1646  */
    {
                        icmpset.family = Socket_Ip;
                        icmpset.type = (yyvsp[-5].number);
                        addeventaction(&(icmpset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addicmp(&icmpset);
                  }
#line 4509 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 409:
#line 1435 "src/p.y" /* yacc.c:1646  */
    {
                        icmpset.family = Socket_Ip;
                        addeventaction(&(icmpset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addicmp(&icmpset);
                 }
#line 4519 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 410:
#line 1440 "src/p.y" /* yacc.c:1646  */
    {
                        icmpset.family = Socket_Ip4;
                        addeventaction(&(icmpset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addicmp(&icmpset);
                 }
#line 4529 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 411:
#line 1445 "src/p.y" /* yacc.c:1646  */
    {
                        icmpset.family = Socket_Ip6;
                        addeventaction(&(icmpset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addicmp(&icmpset);
                 }
#line 4539 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 418:
#line 1462 "src/p.y" /* yacc.c:1646  */
    {
                        portset.hostname = Str_dup(current->type == Service_Host ? current->path : LOCALHOST);
                  }
#line 4547 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 419:
#line 1465 "src/p.y" /* yacc.c:1646  */
    {
                        portset.hostname = (yyvsp[0].string);
                  }
#line 4555 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 420:
#line 1470 "src/p.y" /* yacc.c:1646  */
    {
                        portset.target.net.port = (yyvsp[0].number);
                  }
#line 4563 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 421:
#line 1475 "src/p.y" /* yacc.c:1646  */
    {
                        portset.family = Socket_Unix;
                        portset.target.unix.pathname = (yyvsp[0].string);
                  }
#line 4572 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 422:
#line 1481 "src/p.y" /* yacc.c:1646  */
    {
                        portset.family = Socket_Ip4;
                  }
#line 4580 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 423:
#line 1484 "src/p.y" /* yacc.c:1646  */
    {
                        portset.family = Socket_Ip6;
                  }
#line 4588 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 424:
#line 1489 "src/p.y" /* yacc.c:1646  */
    {
                        portset.type = Socket_Tcp;
                  }
#line 4596 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 425:
#line 1492 "src/p.y" /* yacc.c:1646  */
    { // The typelist is kept for backward compatibility (replaced by ssloptionlist)
                        portset.type = Socket_Tcp;
                        sslset.flags = SSL_Enabled;
                  }
#line 4605 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 426:
#line 1496 "src/p.y" /* yacc.c:1646  */
    {
                        portset.type = Socket_Udp;
                  }
#line 4613 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 431:
#line 1509 "src/p.y" /* yacc.c:1646  */
    {
                        _parseOutgoingAddress((yyvsp[0].string), &(portset.outgoing));
                  }
#line 4621 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 432:
#line 1514 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_APACHESTATUS);
                  }
#line 4629 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 433:
#line 1517 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_DEFAULT);
                  }
#line 4637 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 434:
#line 1520 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_DNS);
                  }
#line 4645 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 435:
#line 1523 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_DWP);
                  }
#line 4653 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 436:
#line 1526 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_FAIL2BAN);
                }
#line 4661 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 437:
#line 1529 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_FTP);
                  }
#line 4669 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 438:
#line 1532 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_HTTP);
                  }
#line 4677 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 439:
#line 1535 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                        portset.type = Socket_Tcp;
                        portset.protocol = Protocol_get(Protocol_HTTP);
                 }
#line 4687 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 440:
#line 1540 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_IMAP);
                  }
#line 4695 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 441:
#line 1543 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                        portset.type = Socket_Tcp;
                        portset.protocol = Protocol_get(Protocol_IMAP);
                  }
#line 4705 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 442:
#line 1548 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_CLAMAV);
                  }
#line 4713 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 443:
#line 1551 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_LDAP2);
                  }
#line 4721 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 444:
#line 1554 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_LDAP3);
                  }
#line 4729 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 445:
#line 1557 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_MONGODB);
                  }
#line 4737 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 446:
#line 1560 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_MYSQL);
                  }
#line 4745 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 447:
#line 1563 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_SIP);
                  }
#line 4753 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 448:
#line 1566 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_NNTP);
                  }
#line 4761 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 449:
#line 1569 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_NTP3);
                        portset.type = Socket_Udp;
                  }
#line 4770 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 450:
#line 1573 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_POSTFIXPOLICY);
                  }
#line 4778 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 451:
#line 1576 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_POP);
                  }
#line 4786 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 452:
#line 1579 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                        portset.type = Socket_Tcp;
                        portset.protocol = Protocol_get(Protocol_POP);
                  }
#line 4796 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 453:
#line 1584 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_SIEVE);
                  }
#line 4804 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 454:
#line 1587 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_SMTP);
                  }
#line 4812 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 455:
#line 1590 "src/p.y" /* yacc.c:1646  */
    {
                        sslset.flags = SSL_Enabled;
                        portset.type = Socket_Tcp;
                        portset.protocol = Protocol_get(Protocol_SMTP);
                 }
#line 4822 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 456:
#line 1595 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_SPAMASSASSIN);
                  }
#line 4830 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 457:
#line 1598 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_SSH);
                  }
#line 4838 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 458:
#line 1601 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_RDATE);
                  }
#line 4846 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 459:
#line 1604 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_REDIS);
                  }
#line 4854 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 460:
#line 1607 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_RSYNC);
                  }
#line 4862 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 461:
#line 1610 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_TNS);
                  }
#line 4870 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 462:
#line 1613 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_PGSQL);
                  }
#line 4878 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 463:
#line 1616 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_LMTP);
                  }
#line 4886 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 464:
#line 1619 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_GPS);
                  }
#line 4894 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 465:
#line 1622 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_RADIUS);
                  }
#line 4902 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 466:
#line 1625 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_MEMCACHE);
                  }
#line 4910 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 467:
#line 1628 "src/p.y" /* yacc.c:1646  */
    {
                        portset.protocol = Protocol_get(Protocol_WEBSOCKET);
                  }
#line 4918 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 468:
#line 1633 "src/p.y" /* yacc.c:1646  */
    {
                        if (portset.protocol->check == check_default || portset.protocol->check == check_generic) {
                                portset.protocol = Protocol_get(Protocol_GENERIC);
                                addgeneric(&portset, (yyvsp[0].string), NULL);
                        } else {
                                yyerror("The SEND statement is not allowed in the %s protocol context", portset.protocol->name);
                        }
                  }
#line 4931 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 469:
#line 1641 "src/p.y" /* yacc.c:1646  */
    {
                        if (portset.protocol->check == check_default || portset.protocol->check == check_generic) {
                                portset.protocol = Protocol_get(Protocol_GENERIC);
                                addgeneric(&portset, NULL, (yyvsp[0].string));
                        } else {
                                yyerror("The EXPECT statement is not allowed in the %s protocol context", portset.protocol->name);
                        }
                  }
#line 4944 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 472:
#line 1655 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.websocket.origin = (yyvsp[0].string);
                  }
#line 4952 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 473:
#line 1658 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.websocket.request = (yyvsp[0].string);
                  }
#line 4960 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 474:
#line 1661 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.websocket.host = (yyvsp[0].string);
                  }
#line 4968 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 475:
#line 1664 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.websocket.version = (yyvsp[0].number);
                  }
#line 4976 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 478:
#line 1673 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.smtp.username = (yyvsp[0].string);
                  }
#line 4984 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 479:
#line 1676 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.smtp.password = (yyvsp[0].string);
                  }
#line 4992 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 482:
#line 1685 "src/p.y" /* yacc.c:1646  */
    {
                        if ((yyvsp[0].string)) {
                                if (strlen((yyvsp[0].string)) > 16)
                                        yyerror2("Username too long -- Maximum MySQL username length is 16 characters");
                                else
                                        portset.parameters.mysql.username = (yyvsp[0].string);
                        }
                  }
#line 5005 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 483:
#line 1693 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.mysql.password = (yyvsp[0].string);
                  }
#line 5013 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 484:
#line 1698 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.string) = (yyvsp[0].string);
                  }
#line 5021 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 485:
#line 1701 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.string) = (yyvsp[0].string);
                  }
#line 5029 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 486:
#line 1706 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = verifyMaxForward((yyvsp[0].number));
                  }
#line 5037 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 489:
#line 1715 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.sip.target = (yyvsp[0].string);
                  }
#line 5045 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 490:
#line 1718 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.sip.maxforward = (yyvsp[0].number);
                  }
#line 5053 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 493:
#line 1727 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.http.username = (yyvsp[0].string);
                  }
#line 5061 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 494:
#line 1730 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.http.password = (yyvsp[0].string);
                  }
#line 5069 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 501:
#line 1741 "src/p.y" /* yacc.c:1646  */
    {
                        if ((yyvsp[0].number) < 0) {
                                yyerror2("The status value must be greater or equal to 0");
                        }
                        portset.parameters.http.operator = (yyvsp[-1].number);
                        portset.parameters.http.status = (yyvsp[0].number);
                        portset.parameters.http.hasStatus = true;
                  }
#line 5082 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 502:
#line 1751 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.http.method = Http_Get;
                  }
#line 5090 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 503:
#line 1754 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.http.method = Http_Head;
                  }
#line 5098 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 504:
#line 1759 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.http.request = Util_urlEncode((yyvsp[0].string), false);
                        FREE((yyvsp[0].string));
                  }
#line 5107 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 505:
#line 1763 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.http.request = Util_urlEncode((yyvsp[0].string), false);
                        FREE((yyvsp[0].string));
                  }
#line 5116 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 506:
#line 1769 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.http.checksum = (yyvsp[0].string);
                  }
#line 5124 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 507:
#line 1774 "src/p.y" /* yacc.c:1646  */
    {
                        addhttpheader(&portset, Str_cat("Host:%s", (yyvsp[0].string)));
                        FREE((yyvsp[0].string));
                  }
#line 5133 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 509:
#line 1781 "src/p.y" /* yacc.c:1646  */
    {
                        addhttpheader(&portset, (yyvsp[0].string));
                 }
#line 5141 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 510:
#line 1786 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.string) = (yyvsp[0].string);
                  }
#line 5149 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 513:
#line 1795 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.radius.secret = (yyvsp[0].string);
                  }
#line 5157 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 516:
#line 1804 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.apachestatus.username = (yyvsp[0].string);
                  }
#line 5165 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 517:
#line 1807 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.apachestatus.password = (yyvsp[0].string);
                  }
#line 5173 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 518:
#line 1810 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.apachestatus.path = (yyvsp[0].string);
                  }
#line 5181 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 519:
#line 1813 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.apachestatus.loglimitOP = (yyvsp[-2].number);
                        portset.parameters.apachestatus.loglimit = (yyvsp[-1].number);
                  }
#line 5190 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 520:
#line 1817 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.apachestatus.closelimitOP = (yyvsp[-2].number);
                        portset.parameters.apachestatus.closelimit = (yyvsp[-1].number);
                  }
#line 5199 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 521:
#line 1821 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.apachestatus.dnslimitOP = (yyvsp[-2].number);
                        portset.parameters.apachestatus.dnslimit = (yyvsp[-1].number);
                  }
#line 5208 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 522:
#line 1825 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.apachestatus.keepalivelimitOP = (yyvsp[-2].number);
                        portset.parameters.apachestatus.keepalivelimit = (yyvsp[-1].number);
                  }
#line 5217 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 523:
#line 1829 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.apachestatus.replylimitOP = (yyvsp[-2].number);
                        portset.parameters.apachestatus.replylimit = (yyvsp[-1].number);
                  }
#line 5226 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 524:
#line 1833 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.apachestatus.requestlimitOP = (yyvsp[-2].number);
                        portset.parameters.apachestatus.requestlimit = (yyvsp[-1].number);
                  }
#line 5235 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 525:
#line 1837 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.apachestatus.startlimitOP = (yyvsp[-2].number);
                        portset.parameters.apachestatus.startlimit = (yyvsp[-1].number);
                  }
#line 5244 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 526:
#line 1841 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.apachestatus.waitlimitOP = (yyvsp[-2].number);
                        portset.parameters.apachestatus.waitlimit = (yyvsp[-1].number);
                  }
#line 5253 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 527:
#line 1845 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.apachestatus.gracefullimitOP = (yyvsp[-2].number);
                        portset.parameters.apachestatus.gracefullimit = (yyvsp[-1].number);
                  }
#line 5262 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 528:
#line 1849 "src/p.y" /* yacc.c:1646  */
    {
                        portset.parameters.apachestatus.cleanuplimitOP = (yyvsp[-2].number);
                        portset.parameters.apachestatus.cleanuplimit = (yyvsp[-1].number);
                  }
#line 5271 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 529:
#line 1855 "src/p.y" /* yacc.c:1646  */
    {
                        addeventaction(&(nonexistset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addnonexist(&nonexistset);
                  }
#line 5280 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 530:
#line 1859 "src/p.y" /* yacc.c:1646  */
    {
                        addeventaction(&(existset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addexist(&existset);
                  }
#line 5289 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 531:
#line 1866 "src/p.y" /* yacc.c:1646  */
    {
                        addeventaction(&(pidset).action, (yyvsp[0].number), Action_Ignored);
                        addpid(&pidset);
                  }
#line 5298 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 532:
#line 1872 "src/p.y" /* yacc.c:1646  */
    {
                        addeventaction(&(ppidset).action, (yyvsp[0].number), Action_Ignored);
                        addppid(&ppidset);
                  }
#line 5307 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 533:
#line 1878 "src/p.y" /* yacc.c:1646  */
    {
                        uptimeset.operator = (yyvsp[-6].number);
                        uptimeset.uptime = ((unsigned long long)(yyvsp[-5].number) * (yyvsp[-4].number));
                        addeventaction(&(uptimeset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        adduptime(&uptimeset);
                  }
#line 5318 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 534:
#line 1885 "src/p.y" /* yacc.c:1646  */
    {
                        icmpset.count = (yyvsp[0].number);
                 }
#line 5326 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 535:
#line 1890 "src/p.y" /* yacc.c:1646  */
    {
                        icmpset.size = (yyvsp[0].number);
                        if (icmpset.size < 8) {
                                yyerror2("The minimum ping size is 8 bytes");
                        } else if (icmpset.size > 1492) {
                                yyerror2("The maximum ping size is 1492 bytes");
                        }
                 }
#line 5339 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 536:
#line 1900 "src/p.y" /* yacc.c:1646  */
    {
                        icmpset.timeout = (yyvsp[-1].number) * 1000; // timeout is in milliseconds internally
                    }
#line 5347 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 537:
#line 1905 "src/p.y" /* yacc.c:1646  */
    {
                        _parseOutgoingAddress((yyvsp[0].string), &(icmpset.outgoing));
                  }
#line 5355 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 538:
#line 1910 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = Run.limits.stopTimeout;
                  }
#line 5363 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 539:
#line 1913 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = (yyvsp[-1].number) * 1000; // milliseconds internally
                  }
#line 5371 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 540:
#line 1918 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = Run.limits.startTimeout;
                  }
#line 5379 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 541:
#line 1921 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = (yyvsp[-1].number) * 1000; // milliseconds internally
                  }
#line 5387 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 542:
#line 1926 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = Run.limits.restartTimeout;
                  }
#line 5395 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 543:
#line 1929 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = (yyvsp[-1].number) * 1000; // milliseconds internally
                  }
#line 5403 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 544:
#line 1934 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = Run.limits.programTimeout;
                  }
#line 5411 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 545:
#line 1937 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = (yyvsp[-1].number) * 1000; // milliseconds internally
                  }
#line 5419 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 546:
#line 1942 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = Run.limits.networkTimeout;
                  }
#line 5427 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 547:
#line 1945 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = (yyvsp[-1].number) * 1000; // net timeout is in milliseconds internally
                  }
#line 5435 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 548:
#line 1950 "src/p.y" /* yacc.c:1646  */
    {
                        portset.timeout = (yyvsp[-1].number) * 1000; // timeout is in milliseconds internally
                    }
#line 5443 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 549:
#line 1955 "src/p.y" /* yacc.c:1646  */
    {
                        portset.retry = (yyvsp[0].number);
                  }
#line 5451 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 550:
#line 1960 "src/p.y" /* yacc.c:1646  */
    {
                        actionrateset.count = (yyvsp[-5].number);
                        actionrateset.cycle = (yyvsp[-3].number);
                        addeventaction(&(actionrateset).action, (yyvsp[0].number), Action_Alert);
                        addactionrate(&actionrateset);
                  }
#line 5462 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 551:
#line 1966 "src/p.y" /* yacc.c:1646  */
    {
                        actionrateset.count = (yyvsp[-5].number);
                        actionrateset.cycle = (yyvsp[-3].number);
                        addeventaction(&(actionrateset).action, Action_Unmonitor, Action_Alert);
                        addactionrate(&actionrateset);
                  }
#line 5473 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 552:
#line 1974 "src/p.y" /* yacc.c:1646  */
    {
                        seturlrequest((yyvsp[-1].number), (yyvsp[0].string));
                        FREE((yyvsp[0].string));
                  }
#line 5482 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 553:
#line 1980 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Operator_Equal; }
#line 5488 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 554:
#line 1981 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Operator_NotEqual; }
#line 5494 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 555:
#line 1984 "src/p.y" /* yacc.c:1646  */
    {
                        mailset.events = Event_All;
                        addmail((yyvsp[-2].string), &mailset, &current->maillist);
                  }
#line 5503 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 556:
#line 1988 "src/p.y" /* yacc.c:1646  */
    {
                        addmail((yyvsp[-5].string), &mailset, &current->maillist);
                  }
#line 5511 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 557:
#line 1991 "src/p.y" /* yacc.c:1646  */
    {
                        mailset.events = ~mailset.events;
                        addmail((yyvsp[-6].string), &mailset, &current->maillist);
                  }
#line 5520 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 558:
#line 1995 "src/p.y" /* yacc.c:1646  */
    {
                        addmail((yyvsp[0].string), &mailset, &current->maillist);
                  }
#line 5528 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 559:
#line 2000 "src/p.y" /* yacc.c:1646  */
    { (yyval.string) = (yyvsp[0].string); }
#line 5534 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 560:
#line 2003 "src/p.y" /* yacc.c:1646  */
    { (yyval.string) = (yyvsp[0].string); }
#line 5540 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 563:
#line 2010 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Action; }
#line 5546 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 564:
#line 2011 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_ByteIn; }
#line 5552 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 565:
#line 2012 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_ByteOut; }
#line 5558 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 566:
#line 2013 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Checksum; }
#line 5564 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 567:
#line 2014 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Connection; }
#line 5570 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 568:
#line 2015 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Content; }
#line 5576 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 569:
#line 2016 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Data; }
#line 5582 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 570:
#line 2017 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Exec; }
#line 5588 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 571:
#line 2018 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Exist; }
#line 5594 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 572:
#line 2019 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_FsFlag; }
#line 5600 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 573:
#line 2020 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Gid; }
#line 5606 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 574:
#line 2021 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Icmp; }
#line 5612 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 575:
#line 2022 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Instance; }
#line 5618 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 576:
#line 2023 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Invalid; }
#line 5624 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 577:
#line 2024 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Link; }
#line 5630 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 578:
#line 2025 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_NonExist; }
#line 5636 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 579:
#line 2026 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_PacketIn; }
#line 5642 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 580:
#line 2027 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_PacketOut; }
#line 5648 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 581:
#line 2028 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Permission; }
#line 5654 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 582:
#line 2029 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Pid; }
#line 5660 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 583:
#line 2030 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_PPid; }
#line 5666 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 584:
#line 2031 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Resource; }
#line 5672 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 585:
#line 2032 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Saturation; }
#line 5678 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 586:
#line 2033 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Size; }
#line 5684 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 587:
#line 2034 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Speed; }
#line 5690 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 588:
#line 2035 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Status; }
#line 5696 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 589:
#line 2036 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Timeout; }
#line 5702 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 590:
#line 2037 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Timestamp; }
#line 5708 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 591:
#line 2038 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Uid; }
#line 5714 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 592:
#line 2039 "src/p.y" /* yacc.c:1646  */
    { mailset.events |= Event_Uptime; }
#line 5720 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 597:
#line 2050 "src/p.y" /* yacc.c:1646  */
    { mailset.from = (yyvsp[-1].address); }
#line 5726 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 598:
#line 2051 "src/p.y" /* yacc.c:1646  */
    { mailset.replyto = (yyvsp[-1].address); }
#line 5732 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 599:
#line 2052 "src/p.y" /* yacc.c:1646  */
    { mailset.subject = (yyvsp[0].string); }
#line 5738 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 600:
#line 2053 "src/p.y" /* yacc.c:1646  */
    { mailset.message = (yyvsp[0].string); }
#line 5744 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 601:
#line 2056 "src/p.y" /* yacc.c:1646  */
    {
                        current->every.type = Every_SkipCycles;
                        current->every.spec.cycle.counter = current->every.spec.cycle.number = (yyvsp[-1].number);
                 }
#line 5753 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 602:
#line 2060 "src/p.y" /* yacc.c:1646  */
    {
                        current->every.type = Every_Cron;
                        current->every.spec.cron = (yyvsp[0].string);
                 }
#line 5762 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 603:
#line 2064 "src/p.y" /* yacc.c:1646  */
    {
                        current->every.type = Every_NotInCron;
                        current->every.spec.cron = (yyvsp[0].string);
                 }
#line 5771 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 604:
#line 2070 "src/p.y" /* yacc.c:1646  */
    {
                        current->mode = Monitor_Active;
                  }
#line 5779 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 605:
#line 2073 "src/p.y" /* yacc.c:1646  */
    {
                        current->mode = Monitor_Passive;
                  }
#line 5787 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 606:
#line 2076 "src/p.y" /* yacc.c:1646  */
    {
                        // Deprecated since monit 5.18
                        current->onreboot = Onreboot_Laststate;
                  }
#line 5796 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 607:
#line 2082 "src/p.y" /* yacc.c:1646  */
    {
                        current->onreboot = Onreboot_Start;
                  }
#line 5804 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 608:
#line 2085 "src/p.y" /* yacc.c:1646  */
    {
                        current->onreboot = Onreboot_Nostart;
                        current->monitor = Monitor_Not;
                  }
#line 5813 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 609:
#line 2089 "src/p.y" /* yacc.c:1646  */
    {
                        current->onreboot = Onreboot_Laststate;
                  }
#line 5821 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 610:
#line 2094 "src/p.y" /* yacc.c:1646  */
    {
                        addservicegroup((yyvsp[0].string));
                        FREE((yyvsp[0].string));
                  }
#line 5830 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 614:
#line 2108 "src/p.y" /* yacc.c:1646  */
    { adddependant((yyvsp[0].string)); }
#line 5836 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 615:
#line 2111 "src/p.y" /* yacc.c:1646  */
    {
                        statusset.initialized = true;
                        statusset.operator = (yyvsp[-5].number);
                        statusset.return_value = (yyvsp[-4].number);
                        addeventaction(&(statusset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addstatus(&statusset);
                   }
#line 5848 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 616:
#line 2118 "src/p.y" /* yacc.c:1646  */
    {
                        statusset.initialized = false;
                        statusset.operator = Operator_Changed;
                        statusset.return_value = 0;
                        addeventaction(&(statusset).action, (yyvsp[0].number), Action_Ignored);
                        addstatus(&statusset);
                   }
#line 5860 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 617:
#line 2127 "src/p.y" /* yacc.c:1646  */
    {
                        addeventaction(&(resourceset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addresource(&resourceset);
                   }
#line 5869 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 627:
#line 2146 "src/p.y" /* yacc.c:1646  */
    {
                        addeventaction(&(resourceset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addresource(&resourceset);
                   }
#line 5878 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 634:
#line 2162 "src/p.y" /* yacc.c:1646  */
    {
                        resourceset.resource_id = Resource_CpuPercent;
                        resourceset.operator = (yyvsp[-2].number);
                        resourceset.limit = (yyvsp[-1].real);
                  }
#line 5888 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 635:
#line 2167 "src/p.y" /* yacc.c:1646  */
    {
                        resourceset.resource_id = Resource_CpuPercentTotal;
                        resourceset.operator = (yyvsp[-2].number);
                        resourceset.limit = (yyvsp[-1].real);
                  }
#line 5898 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 636:
#line 2174 "src/p.y" /* yacc.c:1646  */
    {
                        resourceset.resource_id = (yyvsp[-3].number);
                        resourceset.operator = (yyvsp[-2].number);
                        resourceset.limit = (yyvsp[-1].real);
                  }
#line 5908 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 637:
#line 2181 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Resource_CpuUser; }
#line 5914 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 638:
#line 2182 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Resource_CpuSystem; }
#line 5920 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 639:
#line 2183 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Resource_CpuWait; }
#line 5926 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 640:
#line 2184 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Resource_CpuPercent; }
#line 5932 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 641:
#line 2187 "src/p.y" /* yacc.c:1646  */
    {
                        resourceset.resource_id = Resource_MemoryKbyte;
                        resourceset.operator = (yyvsp[-2].number);
                        resourceset.limit = (yyvsp[-1].real) * (yyvsp[0].number);
                  }
#line 5942 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 642:
#line 2192 "src/p.y" /* yacc.c:1646  */
    {
                        resourceset.resource_id = Resource_MemoryPercent;
                        resourceset.operator = (yyvsp[-2].number);
                        resourceset.limit = (yyvsp[-1].real);
                  }
#line 5952 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 643:
#line 2199 "src/p.y" /* yacc.c:1646  */
    {
                        resourceset.resource_id = Resource_MemoryKbyte;
                        resourceset.operator = (yyvsp[-2].number);
                        resourceset.limit = (yyvsp[-1].real) * (yyvsp[0].number);
                  }
#line 5962 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 644:
#line 2204 "src/p.y" /* yacc.c:1646  */
    {
                        resourceset.resource_id = Resource_MemoryPercent;
                        resourceset.operator = (yyvsp[-2].number);
                        resourceset.limit = (yyvsp[-1].real);
                  }
#line 5972 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 645:
#line 2209 "src/p.y" /* yacc.c:1646  */
    {
                        resourceset.resource_id = Resource_MemoryKbyteTotal;
                        resourceset.operator = (yyvsp[-2].number);
                        resourceset.limit = (yyvsp[-1].real) * (yyvsp[0].number);
                  }
#line 5982 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 646:
#line 2214 "src/p.y" /* yacc.c:1646  */
    {
                        resourceset.resource_id = Resource_MemoryPercentTotal;
                        resourceset.operator = (yyvsp[-2].number);
                        resourceset.limit = (yyvsp[-1].real);
                  }
#line 5992 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 647:
#line 2221 "src/p.y" /* yacc.c:1646  */
    {
                        resourceset.resource_id = Resource_SwapKbyte;
                        resourceset.operator = (yyvsp[-2].number);
                        resourceset.limit = (yyvsp[-1].real) * (yyvsp[0].number);
                  }
#line 6002 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 648:
#line 2226 "src/p.y" /* yacc.c:1646  */
    {
                        resourceset.resource_id = Resource_SwapPercent;
                        resourceset.operator = (yyvsp[-2].number);
                        resourceset.limit = (yyvsp[-1].real);
                  }
#line 6012 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 649:
#line 2233 "src/p.y" /* yacc.c:1646  */
    {
                        resourceset.resource_id = Resource_Threads;
                        resourceset.operator = (yyvsp[-1].number);
                        resourceset.limit = (yyvsp[0].number);
                  }
#line 6022 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 650:
#line 2240 "src/p.y" /* yacc.c:1646  */
    {
                        resourceset.resource_id = Resource_Children;
                        resourceset.operator = (yyvsp[-1].number);
                        resourceset.limit = (yyvsp[0].number);
                  }
#line 6032 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 651:
#line 2247 "src/p.y" /* yacc.c:1646  */
    {
                        resourceset.resource_id = (yyvsp[-2].number);
                        resourceset.operator = (yyvsp[-1].number);
                        resourceset.limit = (yyvsp[0].real);
                  }
#line 6042 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 652:
#line 2254 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Resource_LoadAverage1m; }
#line 6048 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 653:
#line 2255 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Resource_LoadAverage5m; }
#line 6054 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 654:
#line 2256 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Resource_LoadAverage15m; }
#line 6060 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 655:
#line 2259 "src/p.y" /* yacc.c:1646  */
    {
                        resourceset.resource_id = Resource_ReadBytes;
                        resourceset.operator = (yyvsp[-3].number);
                        resourceset.limit = (yyvsp[-2].real) * (yyvsp[-1].number);
                  }
#line 6070 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 656:
#line 2264 "src/p.y" /* yacc.c:1646  */
    {
                        resourceset.resource_id = Resource_ReadOperations;
                        resourceset.operator = (yyvsp[-2].number);
                        resourceset.limit = (yyvsp[-1].number);
                  }
#line 6080 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 657:
#line 2271 "src/p.y" /* yacc.c:1646  */
    {
                        resourceset.resource_id = Resource_WriteBytes;
                        resourceset.operator = (yyvsp[-3].number);
                        resourceset.limit = (yyvsp[-2].real) * (yyvsp[-1].number);
                  }
#line 6090 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 658:
#line 2276 "src/p.y" /* yacc.c:1646  */
    {
                        resourceset.resource_id = Resource_WriteOperations;
                        resourceset.operator = (yyvsp[-2].number);
                        resourceset.limit = (yyvsp[-1].number);
                  }
#line 6100 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 659:
#line 2283 "src/p.y" /* yacc.c:1646  */
    { (yyval.real) = (yyvsp[0].real); }
#line 6106 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 660:
#line 2284 "src/p.y" /* yacc.c:1646  */
    { (yyval.real) = (float) (yyvsp[0].number); }
#line 6112 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 661:
#line 2287 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Timestamp_Default; }
#line 6118 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 662:
#line 2288 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Timestamp_Access; }
#line 6124 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 663:
#line 2289 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Timestamp_Change; }
#line 6130 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 664:
#line 2290 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Timestamp_Modification; }
#line 6136 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 665:
#line 2293 "src/p.y" /* yacc.c:1646  */
    {
                        timestampset.type = (yyvsp[-7].number);
                        timestampset.operator = (yyvsp[-6].number);
                        timestampset.time = ((yyvsp[-5].number) * (yyvsp[-4].number));
                        addeventaction(&(timestampset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addtimestamp(&timestampset);
                  }
#line 6148 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 666:
#line 2300 "src/p.y" /* yacc.c:1646  */
    {
                        timestampset.type = (yyvsp[-3].number);
                        timestampset.test_changes = true;
                        addeventaction(&(timestampset).action, (yyvsp[0].number), Action_Ignored);
                        addtimestamp(&timestampset);
                  }
#line 6159 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 667:
#line 2308 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Operator_Equal; }
#line 6165 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 668:
#line 2309 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Operator_Greater; }
#line 6171 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 669:
#line 2310 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Operator_GreaterOrEqual; }
#line 6177 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 670:
#line 2311 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Operator_Less; }
#line 6183 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 671:
#line 2312 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Operator_LessOrEqual; }
#line 6189 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 672:
#line 2313 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Operator_Equal; }
#line 6195 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 673:
#line 2314 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Operator_NotEqual; }
#line 6201 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 674:
#line 2315 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Operator_Changed; }
#line 6207 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 675:
#line 2318 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Time_Second; }
#line 6213 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 676:
#line 2319 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Time_Second; }
#line 6219 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 677:
#line 2320 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Time_Minute; }
#line 6225 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 678:
#line 2321 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Time_Hour; }
#line 6231 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 679:
#line 2322 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Time_Day; }
#line 6237 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 680:
#line 2323 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Time_Month; }
#line 6243 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 681:
#line 2326 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Time_Minute; }
#line 6249 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 682:
#line 2327 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Time_Hour; }
#line 6255 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 683:
#line 2328 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Time_Day; }
#line 6261 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 684:
#line 2330 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Time_Second; }
#line 6267 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 685:
#line 2331 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Time_Second; }
#line 6273 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 686:
#line 2333 "src/p.y" /* yacc.c:1646  */
    {
                        repeat = 0;
                  }
#line 6281 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 687:
#line 2336 "src/p.y" /* yacc.c:1646  */
    {
                        repeat = 1;
                  }
#line 6289 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 688:
#line 2339 "src/p.y" /* yacc.c:1646  */
    {
                        if ((yyvsp[-1].number) < 0) {
                                yyerror2("The number of repeat cycles must be greater or equal to 0");
                        }
                        repeat = (yyvsp[-1].number);
                  }
#line 6300 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 689:
#line 2347 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = Action_Alert;
                  }
#line 6308 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 690:
#line 2350 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = Action_Exec;
                  }
#line 6316 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 691:
#line 2354 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = Action_Exec;
                  }
#line 6324 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 692:
#line 2357 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = Action_Restart;
                  }
#line 6332 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 693:
#line 2360 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = Action_Start;
                  }
#line 6340 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 694:
#line 2363 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = Action_Stop;
                  }
#line 6348 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 695:
#line 2366 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = Action_Unmonitor;
                  }
#line 6356 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 696:
#line 2371 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = (yyvsp[0].number);
                        if ((yyvsp[0].number) == Action_Exec && command) {
                                repeat1 = repeat;
                                repeat = 0;
                                command1 = command;
                                command = NULL;
                        }
                  }
#line 6370 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 697:
#line 2382 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = (yyvsp[0].number);
                        if ((yyvsp[0].number) == Action_Exec && command) {
                                repeat2 = repeat;
                                repeat = 0;
                                command2 = command;
                                command = NULL;
                        }
                  }
#line 6384 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 698:
#line 2393 "src/p.y" /* yacc.c:1646  */
    {
                        if ((yyvsp[-1].number) < 1 || (yyvsp[-1].number) > BITMAP_MAX) {
                                yyerror2("The number of cycles must be between 1 and %d", BITMAP_MAX);
                        } else {
                                rate.count  = (yyvsp[-1].number);
                                rate.cycles = (yyvsp[-1].number);
                        }
                  }
#line 6397 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 699:
#line 2403 "src/p.y" /* yacc.c:1646  */
    {
                        if ((yyvsp[-1].number) < 1 || (yyvsp[-1].number) > BITMAP_MAX) {
                                yyerror2("The number of cycles must be between 1 and %d", BITMAP_MAX);
                        } else if ((yyvsp[-2].number) < 1 || (yyvsp[-2].number) > (yyvsp[-1].number)) {
                                yyerror2("The number of events must be between 1 and less then poll cycles");
                        } else {
                                rate.count  = (yyvsp[-2].number);
                                rate.cycles = (yyvsp[-1].number);
                        }
                  }
#line 6412 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 701:
#line 2416 "src/p.y" /* yacc.c:1646  */
    {
                        rate1.count = rate.count;
                        rate1.cycles = rate.cycles;
                        reset_rateset(&rate);
                  }
#line 6422 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 702:
#line 2421 "src/p.y" /* yacc.c:1646  */
    {
                        rate1.count = rate.count;
                        rate1.cycles = rate.cycles;
                        reset_rateset(&rate);
                }
#line 6432 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 704:
#line 2429 "src/p.y" /* yacc.c:1646  */
    {
                        rate2.count = rate.count;
                        rate2.cycles = rate.cycles;
                        reset_rateset(&rate);
                  }
#line 6442 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 705:
#line 2434 "src/p.y" /* yacc.c:1646  */
    {
                        rate2.count = rate.count;
                        rate2.cycles = rate.cycles;
                        reset_rateset(&rate);
                }
#line 6452 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 706:
#line 2441 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = Action_Alert;
                  }
#line 6460 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 707:
#line 2444 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = (yyvsp[0].number);
                  }
#line 6468 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 708:
#line 2447 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = (yyvsp[0].number);
                  }
#line 6476 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 709:
#line 2450 "src/p.y" /* yacc.c:1646  */
    {
                        (yyval.number) = (yyvsp[0].number);
                  }
#line 6484 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 710:
#line 2455 "src/p.y" /* yacc.c:1646  */
    {
                        addeventaction(&(checksumset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addchecksum(&checksumset);
                  }
#line 6493 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 711:
#line 2460 "src/p.y" /* yacc.c:1646  */
    {
                        snprintf(checksumset.hash, sizeof(checksumset.hash), "%s", (yyvsp[-4].string));
                        FREE((yyvsp[-4].string));
                        addeventaction(&(checksumset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addchecksum(&checksumset);
                  }
#line 6504 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 712:
#line 2466 "src/p.y" /* yacc.c:1646  */
    {
                        checksumset.test_changes = true;
                        addeventaction(&(checksumset).action, (yyvsp[0].number), Action_Ignored);
                        addchecksum(&checksumset);
                  }
#line 6514 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 713:
#line 2472 "src/p.y" /* yacc.c:1646  */
    { checksumset.type = Hash_Unknown; }
#line 6520 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 714:
#line 2473 "src/p.y" /* yacc.c:1646  */
    { checksumset.type = Hash_Md5; }
#line 6526 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 715:
#line 2474 "src/p.y" /* yacc.c:1646  */
    { checksumset.type = Hash_Sha1; }
#line 6532 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 716:
#line 2477 "src/p.y" /* yacc.c:1646  */
    {
                        filesystemset.resource = Resource_Inode;
                        filesystemset.operator = (yyvsp[-5].number);
                        filesystemset.limit_absolute = (yyvsp[-4].number);
                        addeventaction(&(filesystemset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addfilesystem(&filesystemset);
                  }
#line 6544 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 717:
#line 2484 "src/p.y" /* yacc.c:1646  */
    {
                        filesystemset.resource = Resource_Inode;
                        filesystemset.operator = (yyvsp[-6].number);
                        filesystemset.limit_percent = (yyvsp[-5].real);
                        addeventaction(&(filesystemset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addfilesystem(&filesystemset);
                  }
#line 6556 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 718:
#line 2491 "src/p.y" /* yacc.c:1646  */
    {
                        filesystemset.resource = Resource_InodeFree;
                        filesystemset.operator = (yyvsp[-5].number);
                        filesystemset.limit_absolute = (yyvsp[-4].number);
                        addeventaction(&(filesystemset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addfilesystem(&filesystemset);
                  }
#line 6568 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 719:
#line 2498 "src/p.y" /* yacc.c:1646  */
    {
                        filesystemset.resource = Resource_InodeFree;
                        filesystemset.operator = (yyvsp[-6].number);
                        filesystemset.limit_percent = (yyvsp[-5].real);
                        addeventaction(&(filesystemset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addfilesystem(&filesystemset);
                  }
#line 6580 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 720:
#line 2507 "src/p.y" /* yacc.c:1646  */
    {
                        filesystemset.resource = Resource_Space;
                        filesystemset.operator = (yyvsp[-6].number);
                        filesystemset.limit_absolute = (yyvsp[-5].real) * (yyvsp[-4].number);
                        addeventaction(&(filesystemset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addfilesystem(&filesystemset);
                  }
#line 6592 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 721:
#line 2514 "src/p.y" /* yacc.c:1646  */
    {
                        filesystemset.resource = Resource_Space;
                        filesystemset.operator = (yyvsp[-6].number);
                        filesystemset.limit_percent = (yyvsp[-5].real);
                        addeventaction(&(filesystemset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addfilesystem(&filesystemset);
                  }
#line 6604 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 722:
#line 2521 "src/p.y" /* yacc.c:1646  */
    {
                        filesystemset.resource = Resource_SpaceFree;
                        filesystemset.operator = (yyvsp[-6].number);
                        filesystemset.limit_absolute = (yyvsp[-5].real) * (yyvsp[-4].number);
                        addeventaction(&(filesystemset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addfilesystem(&filesystemset);
                  }
#line 6616 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 723:
#line 2528 "src/p.y" /* yacc.c:1646  */
    {
                        filesystemset.resource = Resource_SpaceFree;
                        filesystemset.operator = (yyvsp[-6].number);
                        filesystemset.limit_percent = (yyvsp[-5].real);
                        addeventaction(&(filesystemset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addfilesystem(&filesystemset);
                  }
#line 6628 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 724:
#line 2537 "src/p.y" /* yacc.c:1646  */
    {
                        filesystemset.resource = Resource_ReadBytes;
                        filesystemset.operator = (yyvsp[-7].number);
                        filesystemset.limit_absolute = (yyvsp[-6].real) * (yyvsp[-5].number);
                        addeventaction(&(filesystemset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addfilesystem(&filesystemset);
                  }
#line 6640 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 725:
#line 2544 "src/p.y" /* yacc.c:1646  */
    {
                        filesystemset.resource = Resource_ReadOperations;
                        filesystemset.operator = (yyvsp[-6].number);
                        filesystemset.limit_absolute = (yyvsp[-5].number);
                        addeventaction(&(filesystemset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addfilesystem(&filesystemset);
                  }
#line 6652 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 726:
#line 2553 "src/p.y" /* yacc.c:1646  */
    {
                        filesystemset.resource = Resource_WriteBytes;
                        filesystemset.operator = (yyvsp[-7].number);
                        filesystemset.limit_absolute = (yyvsp[-6].real) * (yyvsp[-5].number);
                        addeventaction(&(filesystemset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addfilesystem(&filesystemset);
                  }
#line 6664 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 727:
#line 2560 "src/p.y" /* yacc.c:1646  */
    {
                        filesystemset.resource = Resource_WriteOperations;
                        filesystemset.operator = (yyvsp[-6].number);
                        filesystemset.limit_absolute = (yyvsp[-5].number);
                        addeventaction(&(filesystemset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addfilesystem(&filesystemset);
                  }
#line 6676 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 728:
#line 2569 "src/p.y" /* yacc.c:1646  */
    {
                        filesystemset.resource = Resource_ServiceTime;
                        filesystemset.operator = (yyvsp[-6].number);
                        filesystemset.limit_absolute = (yyvsp[-5].number);
                        addeventaction(&(filesystemset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addfilesystem(&filesystemset);
                  }
#line 6688 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 729:
#line 2576 "src/p.y" /* yacc.c:1646  */
    {
                        filesystemset.resource = Resource_ServiceTime;
                        filesystemset.operator = (yyvsp[-6].number);
                        filesystemset.limit_absolute = (yyvsp[-5].real) * 1000;
                        addeventaction(&(filesystemset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addfilesystem(&filesystemset);
                  }
#line 6700 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 730:
#line 2585 "src/p.y" /* yacc.c:1646  */
    {
                        addeventaction(&(fsflagset).action, (yyvsp[0].number), Action_Ignored);
                        addfsflag(&fsflagset);
                  }
#line 6709 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 731:
#line 2591 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Unit_Byte; }
#line 6715 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 732:
#line 2592 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Unit_Byte; }
#line 6721 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 733:
#line 2593 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Unit_Kilobyte; }
#line 6727 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 734:
#line 2594 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Unit_Megabyte; }
#line 6733 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 735:
#line 2595 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = Unit_Gigabyte; }
#line 6739 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 736:
#line 2598 "src/p.y" /* yacc.c:1646  */
    {
                        permset.perm = check_perm((yyvsp[-4].number));
                        addeventaction(&(permset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addperm(&permset);
                  }
#line 6749 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 737:
#line 2603 "src/p.y" /* yacc.c:1646  */
    {
                        permset.test_changes = true;
                        addeventaction(&(permset).action, (yyvsp[-1].number), Action_Ignored);
                        addperm(&permset);
                  }
#line 6759 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 738:
#line 2610 "src/p.y" /* yacc.c:1646  */
    {
                        matchset.not = (yyvsp[-4].number) == Operator_Equal ? false : true;
                        matchset.ignore = false;
                        matchset.match_path = (yyvsp[-3].string);
                        matchset.match_string = NULL;
                        addmatchpath(&matchset, (yyvsp[0].number));
                        FREE((yyvsp[-3].string));
                  }
#line 6772 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 739:
#line 2618 "src/p.y" /* yacc.c:1646  */
    {
                        matchset.not = (yyvsp[-4].number) == Operator_Equal ? false : true;
                        matchset.ignore = false;
                        matchset.match_path = NULL;
                        matchset.match_string = (yyvsp[-3].string);
                        addmatch(&matchset, (yyvsp[0].number), 0);
                  }
#line 6784 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 740:
#line 2625 "src/p.y" /* yacc.c:1646  */
    {
                        matchset.not = (yyvsp[-1].number) == Operator_Equal ? false : true;
                        matchset.ignore = true;
                        matchset.match_path = (yyvsp[0].string);
                        matchset.match_string = NULL;
                        addmatchpath(&matchset, Action_Ignored);
                        FREE((yyvsp[0].string));
                  }
#line 6797 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 741:
#line 2633 "src/p.y" /* yacc.c:1646  */
    {
                        matchset.not = (yyvsp[-1].number) == Operator_Equal ? false : true;
                        matchset.ignore = true;
                        matchset.match_path = NULL;
                        matchset.match_string = (yyvsp[0].string);
                        addmatch(&matchset, Action_Ignored, 0);
                  }
#line 6809 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 742:
#line 2641 "src/p.y" /* yacc.c:1646  */
    {
                        matchset.ignore = false;
                        matchset.match_path = (yyvsp[-3].string);
                        matchset.match_string = NULL;
                        addmatchpath(&matchset, (yyvsp[0].number));
                        FREE((yyvsp[-3].string));
                  }
#line 6821 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 743:
#line 2648 "src/p.y" /* yacc.c:1646  */
    {
                        matchset.ignore = false;
                        matchset.match_path = NULL;
                        matchset.match_string = (yyvsp[-3].string);
                        addmatch(&matchset, (yyvsp[0].number), 0);
                  }
#line 6832 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 744:
#line 2654 "src/p.y" /* yacc.c:1646  */
    {
                        matchset.ignore = true;
                        matchset.match_path = (yyvsp[0].string);
                        matchset.match_string = NULL;
                        addmatchpath(&matchset, Action_Ignored);
                        FREE((yyvsp[0].string));
                  }
#line 6844 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 745:
#line 2661 "src/p.y" /* yacc.c:1646  */
    {
                        matchset.ignore = true;
                        matchset.match_path = NULL;
                        matchset.match_string = (yyvsp[0].string);
                        addmatch(&matchset, Action_Ignored, 0);
                  }
#line 6855 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 746:
#line 2669 "src/p.y" /* yacc.c:1646  */
    {
                        matchset.not = false;
                  }
#line 6863 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 747:
#line 2672 "src/p.y" /* yacc.c:1646  */
    {
                        matchset.not = true;
                  }
#line 6871 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 748:
#line 2678 "src/p.y" /* yacc.c:1646  */
    {
                        sizeset.operator = (yyvsp[-6].number);
                        sizeset.size = ((unsigned long long)(yyvsp[-5].number) * (yyvsp[-4].number));
                        addeventaction(&(sizeset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addsize(&sizeset);
                  }
#line 6882 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 749:
#line 2684 "src/p.y" /* yacc.c:1646  */
    {
                        sizeset.test_changes = true;
                        addeventaction(&(sizeset).action, (yyvsp[0].number), Action_Ignored);
                        addsize(&sizeset);
                  }
#line 6892 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 750:
#line 2691 "src/p.y" /* yacc.c:1646  */
    {
                        uidset.uid = get_uid((yyvsp[-4].string), 0);
                        addeventaction(&(uidset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        current->uid = adduid(&uidset);
                        FREE((yyvsp[-4].string));
                  }
#line 6903 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 751:
#line 2697 "src/p.y" /* yacc.c:1646  */
    {
                    uidset.uid = get_uid(NULL, (yyvsp[-4].number));
                    addeventaction(&(uidset).action, (yyvsp[-1].number), (yyvsp[0].number));
                    current->uid = adduid(&uidset);
                  }
#line 6913 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 752:
#line 2704 "src/p.y" /* yacc.c:1646  */
    {
                        uidset.uid = get_uid((yyvsp[-4].string), 0);
                        addeventaction(&(uidset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        current->euid = adduid(&uidset);
                        FREE((yyvsp[-4].string));
                  }
#line 6924 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 753:
#line 2710 "src/p.y" /* yacc.c:1646  */
    {
                        uidset.uid = get_uid(NULL, (yyvsp[-4].number));
                        addeventaction(&(uidset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        current->euid = adduid(&uidset);
                  }
#line 6934 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 754:
#line 2717 "src/p.y" /* yacc.c:1646  */
    {
                        addsecurityattribute((yyvsp[-4].string), (yyvsp[-1].number), (yyvsp[0].number));
                  }
#line 6942 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 755:
#line 2720 "src/p.y" /* yacc.c:1646  */
    {
                        addsecurityattribute((yyvsp[-4].string), (yyvsp[-1].number), (yyvsp[0].number));
                  }
#line 6950 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 756:
#line 2725 "src/p.y" /* yacc.c:1646  */
    {
                        gidset.gid = get_gid((yyvsp[-4].string), 0);
                        addeventaction(&(gidset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        current->gid = addgid(&gidset);
                        FREE((yyvsp[-4].string));
                  }
#line 6961 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 757:
#line 2731 "src/p.y" /* yacc.c:1646  */
    {
                        gidset.gid = get_gid(NULL, (yyvsp[-4].number));
                        addeventaction(&(gidset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        current->gid = addgid(&gidset);
                  }
#line 6971 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 758:
#line 2738 "src/p.y" /* yacc.c:1646  */
    {
                        addeventaction(&(linkstatusset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addlinkstatus(current, &linkstatusset);
                  }
#line 6980 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 759:
#line 2744 "src/p.y" /* yacc.c:1646  */
    {
                        addeventaction(&(linkspeedset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addlinkspeed(current, &linkspeedset);
                  }
#line 6989 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 760:
#line 2749 "src/p.y" /* yacc.c:1646  */
    {
                        linksaturationset.operator = (yyvsp[-6].number);
                        linksaturationset.limit = (unsigned long long)(yyvsp[-5].number);
                        addeventaction(&(linksaturationset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addlinksaturation(current, &linksaturationset);
                  }
#line 7000 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 761:
#line 2757 "src/p.y" /* yacc.c:1646  */
    {
                        bandwidthset.operator = (yyvsp[-7].number);
                        bandwidthset.limit = ((unsigned long long)(yyvsp[-6].number) * (yyvsp[-5].number));
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = (yyvsp[-4].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addbandwidth(&(current->uploadbyteslist), &bandwidthset);
                  }
#line 7013 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 762:
#line 2765 "src/p.y" /* yacc.c:1646  */
    {
                        bandwidthset.operator = (yyvsp[-7].number);
                        bandwidthset.limit = ((unsigned long long)(yyvsp[-6].number) * (yyvsp[-5].number));
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = (yyvsp[-4].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addbandwidth(&(current->uploadbyteslist), &bandwidthset);
                  }
#line 7026 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 763:
#line 2773 "src/p.y" /* yacc.c:1646  */
    {
                        bandwidthset.operator = (yyvsp[-8].number);
                        bandwidthset.limit = ((unsigned long long)(yyvsp[-7].number) * (yyvsp[-6].number));
                        bandwidthset.rangecount = (yyvsp[-5].number);
                        bandwidthset.range = (yyvsp[-4].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addbandwidth(&(current->uploadbyteslist), &bandwidthset);
                  }
#line 7039 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 764:
#line 2781 "src/p.y" /* yacc.c:1646  */
    {
                        bandwidthset.operator = (yyvsp[-7].number);
                        bandwidthset.limit = (unsigned long long)(yyvsp[-6].number);
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = (yyvsp[-4].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addbandwidth(&(current->uploadpacketslist), &bandwidthset);
                  }
#line 7052 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 765:
#line 2789 "src/p.y" /* yacc.c:1646  */
    {
                        bandwidthset.operator = (yyvsp[-7].number);
                        bandwidthset.limit = (unsigned long long)(yyvsp[-6].number);
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = (yyvsp[-4].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addbandwidth(&(current->uploadpacketslist), &bandwidthset);
                  }
#line 7065 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 766:
#line 2797 "src/p.y" /* yacc.c:1646  */
    {
                        bandwidthset.operator = (yyvsp[-8].number);
                        bandwidthset.limit = (unsigned long long)(yyvsp[-7].number);
                        bandwidthset.rangecount = (yyvsp[-5].number);
                        bandwidthset.range = (yyvsp[-4].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addbandwidth(&(current->uploadpacketslist), &bandwidthset);
                  }
#line 7078 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 767:
#line 2807 "src/p.y" /* yacc.c:1646  */
    {
                        bandwidthset.operator = (yyvsp[-7].number);
                        bandwidthset.limit = ((unsigned long long)(yyvsp[-6].number) * (yyvsp[-5].number));
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = (yyvsp[-4].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addbandwidth(&(current->downloadbyteslist), &bandwidthset);
                  }
#line 7091 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 768:
#line 2815 "src/p.y" /* yacc.c:1646  */
    {
                        bandwidthset.operator = (yyvsp[-7].number);
                        bandwidthset.limit = ((unsigned long long)(yyvsp[-6].number) * (yyvsp[-5].number));
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = (yyvsp[-4].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addbandwidth(&(current->downloadbyteslist), &bandwidthset);
                  }
#line 7104 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 769:
#line 2823 "src/p.y" /* yacc.c:1646  */
    {
                        bandwidthset.operator = (yyvsp[-8].number);
                        bandwidthset.limit = ((unsigned long long)(yyvsp[-7].number) * (yyvsp[-6].number));
                        bandwidthset.rangecount = (yyvsp[-5].number);
                        bandwidthset.range = (yyvsp[-4].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addbandwidth(&(current->downloadbyteslist), &bandwidthset);
                  }
#line 7117 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 770:
#line 2831 "src/p.y" /* yacc.c:1646  */
    {
                        bandwidthset.operator = (yyvsp[-7].number);
                        bandwidthset.limit = (unsigned long long)(yyvsp[-6].number);
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = (yyvsp[-4].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addbandwidth(&(current->downloadpacketslist), &bandwidthset);
                  }
#line 7130 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 771:
#line 2839 "src/p.y" /* yacc.c:1646  */
    {
                        bandwidthset.operator = (yyvsp[-7].number);
                        bandwidthset.limit = (unsigned long long)(yyvsp[-6].number);
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = (yyvsp[-4].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addbandwidth(&(current->downloadpacketslist), &bandwidthset);
                  }
#line 7143 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 772:
#line 2847 "src/p.y" /* yacc.c:1646  */
    {
                        bandwidthset.operator = (yyvsp[-8].number);
                        bandwidthset.limit = (unsigned long long)(yyvsp[-7].number);
                        bandwidthset.rangecount = (yyvsp[-5].number);
                        bandwidthset.range = (yyvsp[-4].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[-1].number), (yyvsp[0].number));
                        addbandwidth(&(current->downloadpacketslist), &bandwidthset);
                  }
#line 7156 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 773:
#line 2857 "src/p.y" /* yacc.c:1646  */
    { (yyval.number) = ICMP_ECHO; }
#line 7162 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 774:
#line 2860 "src/p.y" /* yacc.c:1646  */
    { mailset.reminder = 0; }
#line 7168 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 775:
#line 2861 "src/p.y" /* yacc.c:1646  */
    { mailset.reminder = (yyvsp[0].number); }
#line 7174 "src/y.tab.c" /* yacc.c:1646  */
    break;

  case 776:
#line 2862 "src/p.y" /* yacc.c:1646  */
    { mailset.reminder = (yyvsp[-1].number); }
#line 7180 "src/y.tab.c" /* yacc.c:1646  */
    break;


#line 7184 "src/y.tab.c" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 2865 "src/p.y" /* yacc.c:1906  */



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

