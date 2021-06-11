
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
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
#define YYBISON_VERSION "2.4.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1

/* Using locations.  */
#define YYLSP_NEEDED 0



/* Copy the first part of user declarations.  */

/* Line 189 of yacc.c  */
#line 26 "src/p.y"


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



/* Line 189 of yacc.c  */
#line 358 "src/y.tab.c"

/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
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
     NOTEQUAL = 529,
     EQUAL = 530,
     LESSOREQUAL = 531,
     LESS = 532,
     GREATEROREQUAL = 533,
     GREATER = 534
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
#define NOTEQUAL 529
#define EQUAL 530
#define LESSOREQUAL 531
#define LESS 532
#define GREATEROREQUAL 533
#define GREATER 534




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 214 of yacc.c  */
#line 310 "src/p.y"

        URL_T url;
        Address_T address;
        float real;
        int   number;
        char *string;



/* Line 214 of yacc.c  */
#line 962 "src/y.tab.c"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif


/* Copy the second part of user declarations.  */


/* Line 264 of yacc.c  */
#line 974 "src/y.tab.c"

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
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
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
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int yyi)
#else
static int
YYID (yyi)
    int yyi;
#endif
{
  return yyi;
}
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
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
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
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
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

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)				\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack_alloc, Stack, yysize);			\
	Stack = &yyptr->Stack_alloc;					\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  69
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1695

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  286
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  238
/* YYNRULES -- Number of rules.  */
#define YYNRULES  776
/* YYNRULES -- Number of states.  */
#define YYNSTATES  1453

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   534

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
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
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     4,     6,     8,    11,    13,    15,    17,
      19,    21,    23,    25,    27,    29,    31,    33,    35,    37,
      39,    41,    43,    45,    47,    50,    53,    56,    59,    62,
      65,    68,    71,    74,    75,    78,    80,    82,    84,    86,
      88,    90,    92,    94,    96,    98,   100,   102,   104,   106,
     108,   110,   112,   114,   116,   118,   120,   122,   123,   126,
     128,   130,   132,   134,   136,   138,   140,   142,   144,   146,
     148,   150,   152,   154,   156,   158,   160,   162,   163,   166,
     168,   170,   172,   174,   176,   178,   180,   182,   184,   186,
     188,   190,   192,   194,   196,   198,   200,   202,   204,   206,
     207,   210,   212,   214,   216,   218,   220,   222,   224,   226,
     228,   230,   232,   234,   236,   238,   240,   241,   244,   246,
     248,   250,   252,   254,   256,   258,   260,   262,   264,   266,
     268,   270,   271,   274,   276,   278,   280,   282,   284,   286,
     288,   290,   292,   294,   296,   298,   300,   302,   304,   305,
     308,   310,   312,   314,   316,   318,   320,   322,   324,   326,
     328,   330,   332,   333,   336,   338,   340,   342,   344,   346,
     348,   350,   352,   354,   356,   358,   360,   362,   364,   366,
     367,   370,   372,   374,   376,   378,   380,   382,   384,   386,
     388,   390,   392,   397,   405,   414,   419,   423,   424,   428,
     431,   435,   439,   443,   448,   454,   455,   458,   463,   468,
     473,   478,   483,   488,   493,   498,   503,   508,   513,   518,
     523,   528,   531,   535,   539,   545,   550,   557,   562,   566,
     570,   574,   578,   581,   585,   588,   589,   592,   596,   598,
     600,   602,   604,   605,   608,   614,   616,   621,   622,   625,
     629,   633,   637,   641,   645,   649,   653,   657,   661,   665,
     671,   672,   674,   679,   685,   691,   692,   694,   696,   698,
     700,   702,   704,   706,   708,   710,   713,   719,   725,   727,
     730,   733,   738,   739,   742,   744,   746,   748,   750,   752,
     754,   758,   759,   762,   764,   766,   768,   770,   772,   774,
     776,   778,   780,   783,   786,   788,   791,   795,   796,   799,
     802,   805,   808,   811,   814,   817,   820,   823,   826,   828,
     830,   833,   839,   844,   847,   851,   855,   859,   860,   865,
     866,   872,   873,   879,   880,   886,   889,   891,   894,   896,
     897,   899,   904,   909,   914,   919,   924,   929,   934,   939,
     944,   949,   954,   957,   962,   968,   975,   979,   984,   988,
     993,   997,  1002,  1004,  1007,  1009,  1012,  1014,  1016,  1019,
    1022,  1025,  1028,  1031,  1034,  1037,  1038,  1041,  1051,  1052,
    1055,  1057,  1059,  1061,  1063,  1065,  1067,  1069,  1071,  1073,
    1075,  1077,  1087,  1088,  1091,  1093,  1095,  1097,  1099,  1101,
    1103,  1112,  1113,  1116,  1118,  1120,  1122,  1124,  1126,  1136,
    1145,  1154,  1163,  1164,  1167,  1169,  1171,  1173,  1175,  1176,
    1179,  1182,  1185,  1187,  1189,  1192,  1196,  1199,  1200,  1203,
    1205,  1207,  1210,  1214,  1217,  1220,  1223,  1226,  1229,  1233,
    1237,  1240,  1243,  1246,  1249,  1252,  1255,  1259,  1263,  1266,
    1269,  1272,  1275,  1278,  1281,  1285,  1289,  1292,  1295,  1298,
    1301,  1304,  1307,  1310,  1313,  1316,  1320,  1323,  1327,  1330,
    1333,  1335,  1338,  1341,  1344,  1347,  1350,  1351,  1354,  1356,
    1358,  1359,  1362,  1364,  1366,  1369,  1372,  1375,  1376,  1379,
    1381,  1383,  1384,  1387,  1389,  1391,  1393,  1395,  1397,  1399,
    1401,  1405,  1409,  1412,  1415,  1418,  1421,  1424,  1427,  1428,
    1431,  1434,  1435,  1438,  1440,  1442,  1445,  1447,  1449,  1452,
    1457,  1462,  1467,  1472,  1477,  1482,  1487,  1492,  1497,  1502,
    1510,  1517,  1524,  1531,  1541,  1544,  1547,  1551,  1554,  1555,
    1559,  1560,  1564,  1565,  1569,  1570,  1574,  1575,  1579,  1583,
    1586,  1594,  1602,  1606,  1608,  1610,  1614,  1621,  1629,  1631,
    1634,  1637,  1639,  1642,  1644,  1646,  1648,  1650,  1652,  1654,
    1656,  1658,  1660,  1662,  1664,  1666,  1668,  1670,  1672,  1674,
    1676,  1678,  1680,  1682,  1684,  1686,  1688,  1690,  1692,  1694,
    1696,  1698,  1700,  1702,  1703,  1708,  1710,  1713,  1716,  1719,
    1721,  1723,  1727,  1730,  1733,  1736,  1739,  1742,  1745,  1748,
    1751,  1754,  1757,  1759,  1762,  1764,  1773,  1780,  1787,  1789,
    1792,  1794,  1796,  1798,  1800,  1802,  1804,  1806,  1813,  1815,
    1818,  1820,  1822,  1824,  1826,  1831,  1836,  1841,  1843,  1845,
    1847,  1849,  1854,  1859,  1864,  1869,  1874,  1879,  1884,  1889,
    1893,  1897,  1901,  1903,  1905,  1907,  1914,  1920,  1927,  1933,
    1935,  1937,  1939,  1941,  1943,  1945,  1955,  1962,  1963,  1965,
    1967,  1969,  1971,  1973,  1975,  1977,  1978,  1980,  1982,  1984,
    1986,  1988,  1990,  1992,  1994,  1995,  1997,  1998,  2002,  2007,
    2009,  2013,  2018,  2020,  2022,  2024,  2026,  2028,  2030,  2033,
    2037,  2038,  2040,  2042,  2043,  2045,  2047,  2048,  2055,  2062,
    2069,  2078,  2089,  2097,  2098,  2100,  2102,  2111,  2121,  2131,
    2142,  2152,  2162,  2173,  2184,  2195,  2205,  2216,  2226,  2236,
    2246,  2253,  2254,  2256,  2258,  2260,  2262,  2271,  2279,  2287,
    2295,  2300,  2305,  2313,  2321,  2326,  2331,  2332,  2334,  2344,
    2351,  2360,  2369,  2378,  2387,  2397,  2407,  2416,  2425,  2433,
    2441,  2451,  2462,  2474,  2487,  2498,  2510,  2523,  2534,  2546,
    2559,  2570,  2582,  2595,  2598,  2599,  2602
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int16 yyrhs[] =
{
     287,     0,    -1,    -1,   288,    -1,   289,    -1,   288,   289,
      -1,   308,    -1,   330,    -1,   309,    -1,   310,    -1,   319,
      -1,   320,    -1,   324,    -1,   340,    -1,   341,    -1,   346,
      -1,   323,    -1,   321,    -1,   322,    -1,   314,    -1,   312,
      -1,   315,    -1,   313,    -1,   318,    -1,   368,   290,    -1,
     369,   292,    -1,   370,   294,    -1,   371,   296,    -1,   372,
     298,    -1,   374,   302,    -1,   375,   304,    -1,   376,   306,
      -1,   373,   300,    -1,    -1,   290,   291,    -1,   377,    -1,
     378,    -1,   379,    -1,   432,    -1,   433,    -1,   434,    -1,
     513,    -1,   514,    -1,   515,    -1,   516,    -1,   435,    -1,
     387,    -1,   390,    -1,   393,    -1,   447,    -1,   450,    -1,
     458,    -1,   459,    -1,   460,    -1,   461,    -1,   462,    -1,
     466,    -1,    -1,   292,   293,    -1,   377,    -1,   378,    -1,
     379,    -1,   432,    -1,   486,    -1,   447,    -1,   458,    -1,
     450,    -1,   509,    -1,   513,    -1,   516,    -1,   500,    -1,
     512,    -1,   510,    -1,   459,    -1,   460,    -1,   461,    -1,
     462,    -1,    -1,   294,   295,    -1,   377,    -1,   378,    -1,
     379,    -1,   432,    -1,   447,    -1,   458,    -1,   450,    -1,
     509,    -1,   513,    -1,   516,    -1,   459,    -1,   460,    -1,
     461,    -1,   462,    -1,   502,    -1,   503,    -1,   504,    -1,
     505,    -1,   506,    -1,   507,    -1,    -1,   296,   297,    -1,
     377,    -1,   378,    -1,   379,    -1,   432,    -1,   486,    -1,
     447,    -1,   458,    -1,   450,    -1,   509,    -1,   513,    -1,
     516,    -1,   459,    -1,   460,    -1,   461,    -1,   462,    -1,
      -1,   298,   299,    -1,   377,    -1,   378,    -1,   379,    -1,
     387,    -1,   390,    -1,   396,    -1,   447,    -1,   450,    -1,
     458,    -1,   459,    -1,   460,    -1,   461,    -1,   462,    -1,
      -1,   300,   301,    -1,   377,    -1,   378,    -1,   379,    -1,
     517,    -1,   518,    -1,   519,    -1,   520,    -1,   521,    -1,
     447,    -1,   458,    -1,   459,    -1,   460,    -1,   450,    -1,
     461,    -1,   462,    -1,    -1,   302,   303,    -1,   377,    -1,
     378,    -1,   379,    -1,   447,    -1,   450,    -1,   458,    -1,
     459,    -1,   460,    -1,   461,    -1,   462,    -1,   469,    -1,
     435,    -1,    -1,   304,   305,    -1,   377,    -1,   378,    -1,
     379,    -1,   432,    -1,   486,    -1,   447,    -1,   458,    -1,
     450,    -1,   509,    -1,   513,    -1,   516,    -1,   459,    -1,
     460,    -1,   461,    -1,   462,    -1,    -1,   306,   307,    -1,
     377,    -1,   378,    -1,   379,    -1,   447,    -1,   450,    -1,
     458,    -1,   459,    -1,   460,    -1,   461,    -1,   462,    -1,
     465,    -1,     7,   451,   455,   523,    -1,     7,   451,   280,
     453,   281,   455,   523,    -1,     7,   451,   240,   280,   453,
     281,   455,   523,    -1,     7,    10,   141,   311,    -1,     7,
      18,    19,    -1,    -1,    71,    25,   141,    -1,     7,    17,
      -1,     7,   187,    71,    -1,     7,   187,   188,    -1,     7,
     187,   189,    -1,     7,    61,   141,   508,    -1,     7,    59,
     280,   316,   281,    -1,    -1,   316,   317,    -1,    60,   282,
     141,   508,    -1,    62,   282,   141,   508,    -1,    63,   282,
     141,   508,    -1,    64,   282,   141,   508,    -1,    65,   282,
     141,   215,    -1,    65,   282,   141,   216,    -1,    66,   282,
     141,   215,    -1,    66,   282,   141,   216,    -1,    68,   282,
     141,   215,    -1,    68,   282,   141,   216,    -1,    67,   282,
     141,   215,    -1,    67,   282,   141,   216,    -1,    69,   282,
     141,   215,    -1,    69,   282,   141,   216,    -1,     7,   271,
      -1,     7,     8,   133,    -1,     7,     8,    11,    -1,     7,
       8,    11,     9,   132,    -1,     7,   200,   198,   133,    -1,
       7,   200,   198,   133,   199,   141,    -1,     7,   200,   199,
     141,    -1,     7,    51,   133,    -1,     7,    52,   133,    -1,
       7,    70,   133,    -1,     7,   206,   325,    -1,   326,   329,
      -1,   325,   326,   329,    -1,   265,   327,    -1,    -1,   327,
     328,    -1,    90,   141,   216,    -1,   331,    -1,   336,    -1,
     338,    -1,   339,    -1,    -1,   263,   264,    -1,     7,    29,
     280,   332,   281,    -1,    29,    -1,    29,   280,   332,   281,
      -1,    -1,   332,   333,    -1,    34,   282,    27,    -1,    34,
     282,    28,    -1,    33,   282,    14,    -1,    33,   282,    15,
      -1,   170,   282,   338,    -1,    30,   282,   132,    -1,    26,
     282,   133,    -1,    31,   282,   133,    -1,    36,   282,   133,
      -1,    37,   282,   133,    -1,    35,    38,   335,   141,   219,
      -1,    -1,   279,    -1,    35,    93,   337,   132,    -1,    35,
      93,    22,   337,   132,    -1,    35,    93,    23,   337,   132,
      -1,    -1,   275,    -1,   222,    -1,   223,    -1,   224,    -1,
     225,    -1,   226,    -1,   227,    -1,   221,    -1,   229,    -1,
     228,   132,    -1,     7,    12,   342,   444,   386,    -1,     7,
      87,   280,   456,   281,    -1,   343,    -1,   342,   343,    -1,
     132,   344,    -1,   132,    76,   141,   344,    -1,    -1,   344,
     345,    -1,   384,    -1,   385,    -1,   331,    -1,   336,    -1,
     338,    -1,   339,    -1,     7,    13,   347,    -1,    -1,   347,
     348,    -1,   331,    -1,   349,    -1,   350,    -1,   351,    -1,
     358,    -1,   359,    -1,   360,    -1,   352,    -1,   353,    -1,
      26,   133,    -1,    31,   133,    -1,    32,    -1,    76,   141,
      -1,    88,   133,   354,    -1,    -1,   354,   355,    -1,   203,
     132,    -1,   205,   132,    -1,   203,   141,    -1,   205,   141,
      -1,   237,   141,    -1,    89,    27,    -1,    27,    89,    -1,
      89,    28,    -1,    28,    89,    -1,   356,    -1,   357,    -1,
      16,   132,    -1,    14,   132,   282,   132,   367,    -1,    14,
     283,   132,   367,    -1,    14,   133,    -1,    14,    21,   133,
      -1,    14,    22,   133,    -1,    14,    24,   133,    -1,    -1,
      14,   133,   361,   365,    -1,    -1,    14,    21,   133,   362,
     365,    -1,    -1,    14,    22,   133,   363,   365,    -1,    -1,
      14,    24,   133,   364,   365,    -1,    14,   132,    -1,   366,
      -1,   365,   366,    -1,   132,    -1,    -1,    20,    -1,   154,
     139,    70,   133,    -1,   154,   139,    73,   133,    -1,   154,
     139,   239,   132,    -1,   154,   139,   239,   133,    -1,   156,
     139,    73,   133,    -1,   155,   139,    73,   133,    -1,   155,
     139,    73,   132,    -1,   157,   139,    73,   133,    -1,   158,
     139,    16,   132,    -1,   162,   139,    16,   132,    -1,   162,
     139,    39,   132,    -1,   159,   139,    -1,   160,   139,    73,
     133,    -1,   161,   139,    73,   380,   443,    -1,   161,   139,
      73,   380,   381,   443,    -1,    71,   380,   441,    -1,    71,
     380,   381,   441,    -1,    72,   380,   440,    -1,    72,   380,
     381,   440,    -1,    92,   380,   442,    -1,    92,   380,   381,
     442,    -1,   382,    -1,   380,   382,    -1,   383,    -1,   381,
     383,    -1,   132,    -1,   133,    -1,   203,   132,    -1,   205,
     132,    -1,   203,   141,    -1,   205,   141,    -1,   208,   134,
      -1,   208,   132,    -1,   209,   132,    -1,    -1,    75,   132,
      -1,     3,     6,   399,   400,   388,   497,     5,   493,   499,
      -1,    -1,   388,   389,    -1,   402,    -1,   403,    -1,   407,
      -1,   408,    -1,   448,    -1,   445,    -1,   406,    -1,   446,
      -1,   331,    -1,   336,    -1,   334,    -1,     3,     6,   258,
     265,   391,   497,     5,   493,   499,    -1,    -1,   391,   392,
      -1,   448,    -1,   445,    -1,   446,    -1,   331,    -1,   336,
      -1,   334,    -1,     3,     6,   401,   394,   497,     5,   493,
     499,    -1,    -1,   394,   395,    -1,   403,    -1,   407,    -1,
     408,    -1,   445,    -1,   446,    -1,     3,     6,   249,   522,
     397,   497,     5,   493,   499,    -1,     3,     6,   246,   397,
     497,     5,   493,   499,    -1,     3,     6,   247,   397,   497,
       5,   493,   499,    -1,     3,     6,   248,   397,   497,     5,
     493,   499,    -1,    -1,   397,   398,    -1,   436,    -1,   437,
      -1,   438,    -1,   439,    -1,    -1,    74,   132,    -1,    76,
     141,    -1,    88,   133,    -1,    77,    -1,    78,    -1,    79,
      81,    -1,    79,    82,   404,    -1,    79,    80,    -1,    -1,
     404,   405,    -1,   338,    -1,   339,    -1,    16,   132,    -1,
      83,    99,   430,    -1,    83,    96,    -1,    83,   111,    -1,
      83,   114,    -1,    83,   131,    -1,    83,   100,    -1,    83,
      97,   419,    -1,    83,    98,   419,    -1,    83,   105,    -1,
      83,   106,    -1,    83,   107,    -1,    83,   115,    -1,    83,
     116,    -1,    83,   128,    -1,    83,   110,   413,    -1,    83,
     122,   417,    -1,    83,   108,    -1,    83,   109,    -1,    83,
     121,    -1,    83,   103,    -1,    83,   104,    -1,    83,   129,
      -1,    83,   101,   411,    -1,    83,   102,   411,    -1,    83,
     130,    -1,    83,   113,    -1,    83,   117,    -1,    83,   127,
      -1,    83,   118,    -1,    83,   119,    -1,    83,   120,    -1,
      83,   123,    -1,    83,   124,    -1,    83,   125,   428,    -1,
      83,   126,    -1,    83,   112,   409,    -1,    53,   132,    -1,
      54,   132,    -1,   410,    -1,   409,   410,    -1,   169,   132,
      -1,   196,   133,    -1,    74,   132,    -1,   170,   141,    -1,
      -1,   411,   412,    -1,   384,    -1,   385,    -1,    -1,   413,
     414,    -1,   384,    -1,   385,    -1,   267,   134,    -1,   267,
     132,    -1,   270,   141,    -1,    -1,   417,   418,    -1,   415,
      -1,   416,    -1,    -1,   419,   420,    -1,   384,    -1,   385,
      -1,   423,    -1,   424,    -1,   421,    -1,   422,    -1,   425,
      -1,   284,   426,   285,    -1,   168,   487,   141,    -1,   165,
     166,    -1,   165,   167,    -1,   196,   133,    -1,   196,   132,
      -1,    93,   132,    -1,   202,   132,    -1,    -1,   426,   269,
      -1,   201,   132,    -1,    -1,   428,   429,    -1,   427,    -1,
     431,    -1,   430,   431,    -1,   384,    -1,   385,    -1,    73,
     133,    -1,   143,   487,   141,   142,    -1,   144,   487,   141,
     142,    -1,   145,   487,   141,   142,    -1,   146,   487,   141,
     142,    -1,   147,   487,   141,   142,    -1,   148,   487,   141,
     142,    -1,   149,   487,   141,   142,    -1,   150,   487,   141,
     142,    -1,   151,   487,   141,   142,    -1,   152,   487,   141,
     142,    -1,     3,   240,   252,   497,     5,   493,   499,    -1,
       3,   252,   497,     5,   493,   499,    -1,     3,   214,   260,
     497,     5,   493,    -1,     3,   214,   261,   497,     5,   493,
      -1,     3,   243,   487,   141,   488,   497,     5,   493,   499,
      -1,    56,   141,    -1,   238,   141,    -1,    90,   141,   216,
      -1,    16,   132,    -1,    -1,    90,   141,   216,    -1,    -1,
      90,   141,   216,    -1,    -1,    90,   141,   216,    -1,    -1,
      90,   141,   216,    -1,    -1,    90,   141,   216,    -1,    90,
     141,   216,    -1,    91,   141,    -1,     3,   141,    92,   141,
      55,     5,   493,    -1,     3,   141,    92,   141,    55,     5,
      90,    -1,   259,   449,   132,    -1,   275,    -1,   274,    -1,
     451,   455,   523,    -1,   451,   280,   453,   281,   455,   523,
      -1,   451,   240,   280,   453,   281,   455,   523,    -1,   452,
      -1,    85,   134,    -1,    86,   134,    -1,   454,    -1,   453,
     454,    -1,   242,    -1,    42,    -1,    43,    -1,    93,    -1,
      84,    -1,   259,    -1,   254,    -1,   244,    -1,   252,    -1,
     262,    -1,   205,    -1,   249,    -1,   207,    -1,   253,    -1,
      40,    -1,   251,    -1,    44,    -1,    45,    -1,   237,    -1,
     260,    -1,   261,    -1,   176,    -1,    47,    -1,   238,    -1,
      46,    -1,   168,    -1,    90,    -1,   210,    -1,   203,    -1,
     243,    -1,    -1,    87,   280,   456,   281,    -1,   457,    -1,
     456,   457,    -1,   135,   266,    -1,   136,   266,    -1,   137,
      -1,   138,    -1,    94,   141,    55,    -1,    94,   268,    -1,
      95,   268,    -1,   183,   184,    -1,   183,   185,    -1,   183,
     186,    -1,   187,    71,    -1,   187,   188,    -1,   187,   189,
      -1,   195,   140,    -1,   197,   463,    -1,   464,    -1,   463,
     464,    -1,   139,    -1,     3,   168,   487,   141,   497,     5,
     493,   499,    -1,     3,   214,   168,   497,     5,   493,    -1,
       3,   467,   497,     5,   493,   499,    -1,   468,    -1,   467,
     468,    -1,   472,    -1,   476,    -1,   478,    -1,   479,    -1,
     480,    -1,   482,    -1,   483,    -1,     3,   470,   497,     5,
     493,   499,    -1,   471,    -1,   470,   471,    -1,   480,    -1,
     475,    -1,   477,    -1,   473,    -1,   190,   487,   484,   142,
      -1,   191,   487,   484,   142,    -1,   474,   487,   484,   142,
      -1,   192,    -1,   193,    -1,   194,    -1,   190,    -1,   177,
     487,   484,   508,    -1,   177,   487,   484,   142,    -1,   177,
     487,   484,   508,    -1,   177,   487,   484,   142,    -1,   178,
     487,   484,   508,    -1,   178,   487,   484,   142,    -1,   182,
     487,   484,   508,    -1,   182,   487,   484,   142,    -1,   163,
     487,   141,    -1,   164,   487,   141,    -1,   481,   487,   484,
      -1,   179,    -1,   180,    -1,   181,    -1,   175,   171,   487,
     484,   508,   490,    -1,   175,   171,   487,   141,   173,    -1,
     175,   172,   487,   484,   508,   490,    -1,   175,   172,   487,
     141,   173,    -1,   153,    -1,   141,    -1,   210,    -1,   211,
      -1,   212,    -1,   213,    -1,     3,   485,   487,   141,   488,
     497,     5,   493,   499,    -1,     3,   214,   485,   497,     5,
     493,    -1,    -1,   279,    -1,   278,    -1,   277,    -1,   276,
      -1,   275,    -1,   274,    -1,   214,    -1,    -1,   216,    -1,
     217,    -1,   218,    -1,   219,    -1,   220,    -1,   217,    -1,
     218,    -1,   219,    -1,    -1,   216,    -1,    -1,    58,    94,
      55,    -1,    58,    94,   141,    55,    -1,    85,    -1,   244,
     380,   491,    -1,   244,   380,   381,   491,    -1,    92,    -1,
      71,    -1,    72,    -1,   245,    -1,   492,    -1,   492,    -1,
     141,    55,    -1,   141,   141,    55,    -1,    -1,   495,    -1,
     496,    -1,    -1,   495,    -1,   496,    -1,    -1,     4,     3,
     255,   498,     5,   494,    -1,     4,     3,   256,   498,     5,
     494,    -1,     4,     3,   257,   498,     5,   494,    -1,     3,
       6,   501,    93,   497,     5,   493,   499,    -1,     3,     6,
     501,    93,    54,   132,   497,     5,   493,   499,    -1,     3,
     214,   501,    93,   497,     5,   493,    -1,    -1,    22,    -1,
      23,    -1,     3,   234,   487,   141,   497,     5,   493,   499,
      -1,     3,   234,   487,   484,   142,   497,     5,   493,   499,
      -1,     3,   234,   236,   487,   141,   497,     5,   493,   499,
      -1,     3,   234,   236,   487,   484,   142,   497,     5,   493,
     499,    -1,     3,   235,   487,   484,   508,   497,     5,   493,
     499,    -1,     3,   235,   487,   484,   142,   497,     5,   493,
     499,    -1,     3,   235,   236,   487,   484,   508,   497,     5,
     493,   499,    -1,     3,   235,   236,   487,   484,   142,   497,
       5,   493,   499,    -1,     3,   171,   487,   484,   508,   490,
     497,     5,   493,   499,    -1,     3,   171,   487,   141,   173,
     497,     5,   493,   499,    -1,     3,   172,   487,   484,   508,
     490,   497,     5,   493,   499,    -1,     3,   172,   487,   141,
     173,   497,     5,   493,   499,    -1,     3,   174,   487,   141,
     215,   497,     5,   493,   499,    -1,     3,   174,   487,   484,
     216,   497,     5,   493,   499,    -1,     3,   214,   262,   497,
       5,   493,    -1,    -1,   230,    -1,   231,    -1,   232,    -1,
     233,    -1,     3,     6,   237,   141,   497,     5,   493,   499,
      -1,     3,   214,   237,   497,     5,   493,   499,    -1,     3,
     259,   449,   133,   497,     5,   493,    -1,     3,   259,   449,
     132,   497,     5,   493,    -1,   241,   259,   449,   133,    -1,
     241,   259,   449,   132,    -1,     3,   511,   239,   133,   497,
       5,   493,    -1,     3,   511,   239,   132,   497,     5,   493,
      -1,   241,   511,   239,   133,    -1,   241,   511,   239,   132,
      -1,    -1,   240,    -1,     3,   238,   487,   141,   508,   497,
       5,   493,   499,    -1,     3,   214,   238,   497,     5,   493,
      -1,     3,     6,   203,   132,   497,     5,   493,   499,    -1,
       3,     6,   203,   141,   497,     5,   493,   499,    -1,     3,
       6,   204,   132,   497,     5,   493,   499,    -1,     3,     6,
     204,   141,   497,     5,   493,   499,    -1,     3,     6,   272,
     273,   132,   497,     5,   493,   499,    -1,     3,     6,   272,
     273,   133,   497,     5,   493,   499,    -1,     3,     6,   205,
     132,   497,     5,   493,   499,    -1,     3,     6,   205,   141,
     497,     5,   493,   499,    -1,     3,     6,    40,   497,     5,
     493,   499,    -1,     3,   214,    40,   497,     5,   493,   499,
      -1,     3,    47,   487,   141,   142,   497,     5,   493,   499,
      -1,     3,    48,   487,   141,   508,   490,   497,     5,   493,
     499,    -1,     3,    50,    48,   487,   141,   508,   489,   497,
       5,   493,   499,    -1,     3,    50,    48,   487,   141,   508,
     141,   489,   497,     5,   493,   499,    -1,     3,    48,   487,
     141,    41,   490,   497,     5,   493,   499,    -1,     3,    50,
      48,   487,   141,    41,   489,   497,     5,   493,   499,    -1,
       3,    50,    48,   487,   141,    41,   141,   489,   497,     5,
     493,   499,    -1,     3,    49,   487,   141,   508,   490,   497,
       5,   493,   499,    -1,     3,    50,    49,   487,   141,   508,
     489,   497,     5,   493,   499,    -1,     3,    50,    49,   487,
     141,   508,   141,   489,   497,     5,   493,   499,    -1,     3,
      49,   487,   141,    41,   490,   497,     5,   493,   499,    -1,
       3,    50,    49,   487,   141,    41,   489,   497,     5,   493,
     499,    -1,     3,    50,    49,   487,   141,    41,   141,   489,
     497,     5,   493,   499,    -1,    79,   250,    -1,    -1,    57,
     141,    -1,    57,   141,    55,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
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

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
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
  "ATTRIBUTE", "NOTEQUAL", "EQUAL", "LESSOREQUAL", "LESS",
  "GREATEROREQUAL", "GREATER", "'{'", "'}'", "':'", "'@'", "'['", "']'",
  "$accept", "cfgfile", "statement_list", "statement", "optproclist",
  "optproc", "optfilelist", "optfile", "optfilesyslist", "optfilesys",
  "optdirlist", "optdir", "opthostlist", "opthost", "optnetlist", "optnet",
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
  "icmptype", "reminder", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
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

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
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

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
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
     673,   672,   671,   670,   669,   668,     0,     0,   667,   667,
       0,     0,     0,     0,   700,   700,   700,     0,     0,   701,
     702,     0,   619,     0,     0,     0,   540,   356,     0,   538,
     358,     0,   542,   360,   601,   613,     0,     0,   555,   714,
     715,     0,     0,   700,   700,   700,     0,     0,   554,   553,
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

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -765
static const yytype_int16 yypact[] =
{
     579,    82,   -55,   -48,   -41,   -31,    36,    71,   120,   133,
     154,   213,   579,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,    68,   204,   226,  -765,  -765,   342,    96,   281,   284,
     147,   302,   335,   303,   223,    92,    44,   244,  -765,   -29,
      87,   441,   447,   452,   516,  -765,   455,   479,   210,  -765,
    -765,   776,   229,   866,   913,   987,  1196,  1213,   913,  1326,
     550,  -765,   485,   493,     3,  -765,   948,  -765,  -765,  -765,
    -765,  -765,   199,  -765,  -765,   818,  -765,  -765,  -765,   440,
     430,  -765,   244,   327,   322,   324,  1294,   549,   482,   488,
     352,   413,   496,   501,   507,   514,   476,   517,   537,   153,
     476,   476,   548,   476,   -91,   416,   471,    97,   546,   551,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,    -9,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,    24,  -185,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,   148,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,   167,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,    55,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
      33,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  1070,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,   -53,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
     565,   674,  -765,   563,   437,   576,  -765,   653,     4,   598,
     616,   662,   681,   486,   640,  -765,   639,   659,   666,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,    11,    59,  -765,  -765,  -765,  -765,  -765,   529,   541,
    -765,  -765,    -6,  -765,   614,  -765,   228,   327,   553,  -765,
     818,  1294,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,   888,  -765,   678,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,   402,  -765,
    -765,  -765,   286,   735,   768,   768,   530,   768,   768,  -765,
    -765,  -765,   768,   768,   461,   589,   768,   704,  1408,  -765,
    -765,  -765,  -765,  -765,  -765,   768,  -765,  -765,   421,   484,
    -765,   547,   788,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,   551,  -765,   572,  1294,   549,    74,  -765,
    -765,  -765,  -765,   126,   768,   589,   502,   768,   615,  -765,
     502,   644,   -65,   768,   768,   768,   -86,   838,   885,   619,
     216,   861,   768,   768,   768,   734,   882,   768,   768,  -765,
    -765,  -765,  -765,  1385,  -765,  -765,   768,  -765,  -765,  -765,
     768,   722,  -765,   779,  -765,   831,   347,   797,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,   804,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,   726,   814,  -765,   824,   837,   858,
     701,   863,   865,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,   729,   756,   757,   758,   759,   766,   769,
     772,  -765,  -765,   773,   775,   780,   783,   785,   786,   789,
     794,   795,  -765,  -765,  -765,  -765,  -765,  -765,   876,   909,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,   304,   976,   919,
    -765,  1015,   934,   279,   326,   124,  -765,  -765,  -765,   946,
     947,   374,   392,   438,   819,   813,  1012,  -765,   949,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,   951,   953,   768,   768,
     103,   103,   103,   103,   704,   704,   704,   956,    48,  -765,
    -765,  1106,  -765,  1114,   103,   982,   220,  -765,   986,   283,
    -765,   992,   296,  -765,  -765,  -765,  1294,  1111,  -765,  -765,
    -765,   994,  1035,   704,   704,   704,  1050,  1004,  -765,  -765,
     671,  1005,   706,   717,   731,   156,   172,   194,   704,   768,
     231,   768,   103,  -765,  -765,  -765,  1086,   704,  1025,  1026,
    1027,   768,   768,   704,   103,   103,  -765,  1166,   103,  1031,
     704,  -765,   437,     9,  -765,  -765,  -765,  -765,  -765,  -765,
    1041,  1043,  1044,  1045,  1046,  1160,    76,   390,  1052,  1064,
    1065,   852,   850,  1067,  1069,   880,  1056,  1062,  1071,  1074,
    1076,  1080,  1081,  1082,  1083,  -765,  1010,  -765,   919,   549,
    -765,  1016,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
     704,   704,   704,   704,   704,   704,  -765,   748,  1090,  -765,
     806,  1155,  -765,  -765,   234,   257,  -765,  -765,   333,   351,
    1091,  1092,  1235,  1243,  1248,   989,  -765,  1200,   451,   451,
    -765,  1038,  -765,  1040,  -765,  1042,  -765,  1199,   919,   704,
      -2,  1254,  1256,  1260,   704,   199,   704,   704,   989,   704,
     704,  -765,  -765,  -765,  -765,  1093,   199,  1105,   199,  1078,
    1079,  1275,   265,    29,  1144,   103,   366,    30,    30,    30,
    1047,  -765,  1289,  1154,    -8,   159,  1159,  1161,  1296,   512,
     604,   451,  1162,   704,  1298,  1034,  1034,  -765,  1174,  1046,
    1046,  1046,  1160,  -765,  1046,  -765,  -765,  -765,  -765,   459,
     469,  1169,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,   199,   199,   199,   199,   677,   683,   702,
     724,   777,  -765,   549,  -765,  -765,  1306,  1307,  1310,  1312,
    1314,  1315,    14,   704,   704,  -765,   150,  1190,  1191,   596,
    1516,  1183,  1184,  -765,  -765,  -765,  -765,  -765,  -765,  1321,
    1322,  1157,   199,  1158,   199,  -765,  -765,  -765,  -765,  -765,
    -765,   451,   451,   451,  -765,  -765,  -765,  -765,  -765,   704,
    -765,  -765,  -765,  -765,  -765,   476,  -765,  -765,  1324,  1324,
    -765,  -765,  -765,   919,   549,  1327,  1201,  1330,   451,   451,
     451,  1337,   704,  1338,  1339,   704,  1340,  1341,   704,  1131,
     704,  1131,   704,   704,   451,    29,  1208,  1346,   704,   642,
     704,   704,  1220,  1215,  1216,  1217,  -765,  -765,  -765,  -765,
    -765,  1354,  1356,  1361,  -765,    30,   451,   704,  1131,  1131,
    1131,  1131,   171,   214,   451,  -765,  -765,  -765,  -765,  1324,
    -765,  1363,   451,  1237,  1242,  -765,  1046,  1046,  1046,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,   451,   451,   451,   451,   451,   451,    21,   502,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  1371,  1372,  1375,  1249,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  1377,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,   760,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,    13,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  1170,  -765,   451,   323,
    -765,  1131,  -765,  1131,  -765,  -765,  1324,  1380,   163,  1386,
    -765,  -765,   549,  -765,   451,   704,   451,  1324,  -765,  -765,
     451,  1383,   451,   451,  1389,   451,   451,  1390,  -765,   704,
    1394,   704,  1396,  1398,  -765,  1400,   704,   451,  1402,   704,
     704,  1410,  1411,  -765,  -765,  1197,  -765,   451,   451,   451,
    1412,  1324,  1414,   704,   704,   704,   704,   -73,     1,   137,
     332,  1324,  -765,   451,  -765,  -765,  -765,  1324,  1324,  1324,
    1324,  1324,  1324,  1135,  1258,   451,   451,   451,  -765,   451,
    1048,   -18,   -18,  1290,   768,   768,   768,   768,   768,   768,
     768,   768,   768,   768,  -765,  -765,   760,  -765,   793,   793,
     793,  1292,  1293,  1281,  1297,    13,  -765,  -114,  1225,  -765,
    1324,  -765,  -765,  -765,  -765,  -765,   451,  1344,     2,  -765,
     533,  -765,  1324,  1426,  1324,  -765,  -765,   451,  -765,  -765,
     451,  -765,  -765,   451,  1427,   451,  1428,   451,   451,   451,
    1429,  1324,   451,  1430,  1434,   451,   451,  -765,  1324,  1324,
    1324,   451,  -765,   451,  1439,  1440,  1441,  1442,   696,  -765,
    -765,  -765,   704,   696,   704,   696,   704,   696,   704,  -765,
    1324,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  1308,  -765,
    1324,  1324,  1324,  1324,  -765,  -765,  -765,  1323,   843,   768,
     893,  1325,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  1313,  1328,  1333,  1334,  1336,  1348,  1351,  1352,
    1355,  1357,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,   364,  1359,  -765,  -765,  -765,  1331,
    -765,  -765,  -765,  1324,    61,  -765,   704,   704,   704,  -765,
     451,  -765,  1324,  1324,  1324,   451,  1324,   451,  1324,  1324,
    1324,   451,  -765,  1324,   451,   451,  1324,  1324,  -765,  -765,
    -765,  1324,  1324,   451,   451,   451,   451,   704,  1451,   704,
    1459,   704,  1460,   704,  1461,  -765,  1276,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  1362,  -765,  -765,  -765,  -168,  1360,
    1364,  1365,  1366,  1368,  1369,  1370,  1373,  1374,  1376,  -765,
    -765,  -765,  -765,  -765,  -765,  1413,  -765,  -765,  1462,  1474,
    1500,  1324,  -765,  -765,  -765,  1324,  -765,  1324,  -765,  -765,
    -765,  1324,  -765,  1324,  1324,  -765,  -765,  -765,  -765,  1324,
    1324,  1324,  1324,  1509,   451,  1512,   451,  1514,   451,  1515,
     451,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,   451,   451,   451,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,   451,
    1324,   451,  1324,   451,  1324,   451,  1324,  -765,  -765,  -765,
    -765,  1324,  -765,  1324,  -765,  1324,  -765,  1324,  -765,  -765,
    -765,  -765,  -765
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -765,  -765,  -765,  1510,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    1422,  -765,  -765,  1188,  -765,   -78,  1011,  -765,   684,  -765,
    -316,   232,  -335,  -334,  -765,  -765,  -765,  1443,  1049,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,    22,
    -764,   727,  -765,  -765,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  1115,  1409,  1518,  -107,  -400,  -383,  -555,  -528,  -215,
    -765,  1464,  -765,  -765,  1465,  -765,  -765,  -765,  -765,  -765,
    -765,  -575,  -765,  -765,  -765,  -765,  -765,   688,  -765,  -765,
    -765,   689,   695,  -765,   377,   518,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,   528,  -765,  -765,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -765,   395,   570,  -765,  -765,  1475,
    -765,  -765,  -765,  -765,   950,   952,   945,   998,  -765,  -684,
    -647,  1528,   723,  -441,  1576,  1567,  -765,  -318,  -350,  -126,
    1230,  -303,  1584,  1592,  1600,  1608,  1616,  -765,  1140,  -765,
    -765,  -765,  1168,  -765,  -765,  1101,  -765,  -765,  -765,  -765,
    -765,  -765,  -765,  -765,  -220,  -765,  -765,  -765,   836,  -279,
     196,  -391,   822,   -89,  -363,   403,  -468,  -311,  -385,  -331,
    -310,  -408,  -263,  -590,  -765,  1139,  -765,  -765,  -765,  -765,
    -765,  -765,  -307,   651,  -765,  1453,  -765,   637,  -765,  -765,
     737,  -765,  -765,  -765,  -765,  -765,  -765,  -434
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -701
static const yytype_int16 yytable[] =
{
     603,   553,   554,   618,   587,   566,   590,   591,   309,   633,
     706,   592,   593,   418,   419,   597,   421,   437,   606,   609,
     552,   612,   560,   558,   604,   507,   508,   479,   509,   547,
     438,   795,   796,   938,  -700,   566,   566,   523,   566,   461,
     960,   524,   525,   303,   526,   527,   922,   528,   529,   987,
     422,   706,   896,   627,   706,   449,   631,   706,   104,  1133,
    1177,   460,   635,   636,   637,   657,   640,   642,  1218,   778,
     779,   648,   649,   650,   450,  1247,   654,   655,   104,    80,
     462,   463,   464,   465,    60,   658,   923,  1161,   393,   659,
      41,    61,    42,   295,    43,    44,   619,   620,    62,    45,
      46,  1403,   523,   736,   851,   852,   524,   525,    63,   526,
     527,    47,   528,   529,   663,   480,  1364,  1404,   617,   533,
     924,   534,   535,   536,   537,   538,   539,   540,   541,   328,
     329,   330,   331,    48,    49,    83,   510,   511,   571,   598,
     573,    50,  1223,    51,  1219,  1220,  1221,  1248,   619,   620,
    1249,   623,    52,  1284,   452,   598,  1285,   108,   993,   392,
     109,   481,  1011,    96,   625,   393,   999,    53,   428,    54,
     598,   598,   621,   452,   393,    64,   638,   423,  1250,   303,
     625,   530,  1162,  1163,  1251,   987,   732,   733,   734,   737,
     486,   487,   960,   960,   960,   994,   393,   724,   725,  1012,
     940,    81,  1365,   847,   848,   563,   935,   564,   560,  1164,
      65,   105,  1117,    69,   562,   751,   752,   753,  1219,  1220,
    1221,  1177,   323,   324,   325,   326,   117,  1000,  1001,   849,
     771,   435,   155,   850,   439,   440,   441,   442,   443,   782,
     851,   852,    99,   100,   726,   788,   530,   466,   772,   118,
     775,   106,   794,   479,   547,  1119,   727,   303,   551,    66,
     786,   787,   444,   485,   445,   834,  1252,   560,   925,    55,
     211,   436,    67,   988,   273,   546,   407,   571,  1225,   573,
      97,    98,    56,   446,   797,   429,   430,   512,    57,   393,
     569,   598,   531,    68,   393,   386,   387,   765,   747,  1071,
     120,   121,   836,   837,   838,   839,   840,   841,   393,   727,
     605,   621,   859,   767,    53,   122,   394,   395,   549,   453,
     454,   123,   455,   124,   125,   727,   110,   563,   396,   564,
     397,   398,   399,   400,   401,   769,   439,   440,   441,   442,
     542,   895,   897,   402,   403,    82,   901,   727,   903,   904,
     822,   906,   907,    58,  1219,  1220,  1221,   808,    83,  1122,
     569,    87,   456,   623,   624,   917,   563,   404,   564,   931,
     932,   933,   773,   608,   570,   861,    88,   439,   440,   441,
     442,   459,   457,   458,   727,   951,   611,   727,   405,   323,
     324,   325,   326,   405,   881,   882,   406,   560,   863,   980,
     407,   323,   324,   325,   326,   407,   915,   405,   883,   988,
     727,   702,   126,  1171,    89,   884,   127,    90,   727,   407,
     703,   866,   868,   563,   128,   564,   129,    91,   889,   323,
     324,   325,   326,   699,   996,   997,   998,    94,  1014,   328,
     329,   330,   331,    92,   323,   324,   325,   326,   902,   488,
     489,   490,   491,   492,   493,   494,   495,   496,   704,   909,
    1073,   911,   643,   644,   645,   646,   303,   705,    93,   921,
     156,  1067,   485,  1227,   574,   865,  1175,   939,   941,   664,
     949,   665,   946,   948,   378,   379,   563,  1185,   564,   571,
     572,   573,   562,   867,  1081,  1154,  1359,  1084,  1360,   563,
    1087,   564,  1090,    95,  1092,  1093,   710,  1095,   920,   101,
    1098,   605,  1101,  1102,   111,   711,   966,   967,   968,   969,
     112,  1212,   881,   882,   712,   113,   991,  1110,   115,  1112,
    1004,  1229,   114,   713,   386,   387,   883,  1231,  1232,  1233,
    1234,  1235,  1236,   884,   574,   380,   381,  1134,  1091,  1219,
    1220,  1221,   116,   386,   387,  1061,   291,  1063,   575,   290,
    1064,  1065,  1066,   323,   324,   325,   326,   885,   886,   293,
     714,   335,   833,   334,   608,  1113,  1114,  1115,  1116,   715,
    1292,   323,   324,   325,   326,   697,     1,  1077,  1078,  1079,
     338,   961,  1299,   809,  1301,   810,   323,   324,   325,   326,
     962,   963,   340,  1094,   341,   563,   374,   564,   386,   387,
     964,  1312,  1100,  1253,  1253,   376,   386,   387,  1318,  1319,
    1320,   377,   894,   706,   563,  1111,   564,   811,  1154,   382,
    1273,  1273,  1276,  1121,   383,  1118,  1120,   611,  1181,   384,
    1335,  1124,   161,   181,   203,   486,   487,   385,   265,   390,
    1337,  1338,  1339,  1340,   945,   425,   426,   427,   488,   489,
     490,   491,   492,   493,   494,   495,   496,  1183,  1178,   391,
    1127,  1128,  1129,  1130,  1131,  1132,  1017,  1018,  1019,   386,
     387,  1194,   420,  1196,   424,   566,   431,   563,  1200,   564,
     432,  1203,  1204,   521,   522,   885,   886,   482,  1173,   483,
    1174,   588,   589,  1363,   484,  1214,  1215,  1216,  1217,   174,
     196,   213,  1372,  1373,  1374,   275,  1376,   504,  1378,  1379,
    1380,   594,   595,  1382,   195,   212,  1385,  1386,   505,   274,
     513,  1387,  1388,     2,     3,     4,     5,     6,     7,     8,
       9,    10,   323,   324,   325,   326,   947,  1170,  1172,   514,
     563,   515,   564,  1262,  1263,  1264,  1265,  1266,  1267,  1268,
    1269,  1270,  1271,  1182,   989,  1184,   517,  1072,  1002,  1186,
     516,  1188,  1189,   518,  1191,  1192,   628,   629,  1068,   119,
     519,  1419,   651,   652,  1099,  1420,  1201,  1421,  1296,  1297,
    1298,  1422,   520,  1423,  1424,   544,  1208,  1209,  1210,  1425,
    1426,  1427,  1428,   756,   757,  1244,  1245,   545,  1155,   175,
     197,   214,  1230,   548,  1328,   276,  1330,   556,  1332,   561,
    1334,   956,   957,   958,  1240,  1241,  1242,   578,  1243,   439,
     440,   441,   442,  1143,   323,   324,   325,   326,   759,   760,
    1442,   596,  1444,   614,  1446,   598,  1448,   120,   121,   761,
     762,  1449,   616,  1450,   632,  1451,   623,  1452,  1344,   847,
     848,    53,   122,   763,   764,  1293,   816,   817,   123,   176,
     124,   125,   323,   324,   325,   326,  1302,   818,   819,  1303,
     843,   844,  1304,   634,  1306,   849,  1308,  1309,  1310,   850,
     660,  1313,   970,   971,  1316,  1317,   851,   852,   972,   973,
    1321,   647,  1322,  1144,  1145,  1146,  1147,  1148,  1149,  1150,
    1151,  1152,  1153,  1219,  1220,  1221,   198,   974,   975,  1393,
     661,  1395,   653,  1397,   663,  1399,  1254,  1254,   342,   666,
     343,   344,   345,   346,   347,   348,   667,   120,   121,   976,
     977,  1155,   668,  1274,  1274,  1277,   669,   598,  1437,  1437,
    1437,    53,   122,   328,   329,   330,   331,   670,   123,   126,
     124,   125,   298,   127,   299,  1366,  1366,  1366,   486,   487,
     671,   128,   349,   129,   300,   301,   302,   303,   350,   304,
     305,   351,   579,   673,   120,   121,  1367,  1367,  1367,  1371,
     215,   672,   978,   979,  1375,  -327,  1377,   675,    53,   122,
    1381,   486,   487,  1383,  1384,   123,   104,   124,   125,  1342,
    1343,   678,  1389,  1390,  1391,  1392,   342,   695,   343,   344,
     345,   346,   347,   348,   306,  1345,  1346,   953,   954,  1224,
    1226,  1228,  1439,  1440,  1369,  1370,   307,   308,   679,   680,
     681,   682,   580,   581,   582,   583,   584,   585,   683,   126,
     696,   684,   579,   127,   685,   686,   352,   687,   120,   121,
     349,   128,   688,   129,   353,   689,   350,   690,   691,   351,
     700,   692,    53,   122,   639,   701,   693,   694,   708,   123,
     709,   124,   125,  1430,   716,  1432,   717,  1434,   718,  1436,
     721,   354,   722,   355,   723,   356,   126,   735,   357,   579,
     127,   488,   489,   490,   491,   492,   493,   494,   128,   496,
     129,   738,   580,   581,   582,   583,   584,   585,  1441,   739,
    1443,   641,  1445,   741,  1447,   358,   359,   743,   750,  1327,
     360,   361,   362,   745,  1329,   749,  1331,   363,  1333,   364,
     365,   366,   367,   754,   352,   755,   758,   368,   369,   370,
     371,   342,   353,   343,   344,   345,   346,   347,   348,   580,
     581,   582,   583,   584,   585,   780,   783,   784,   785,   559,
     126,   791,   793,  -329,   127,  -331,  -333,   802,   803,   354,
     806,   355,   128,   356,   129,   813,   357,   158,   178,   200,
     217,   232,   249,   262,   279,   349,   814,   823,   815,   230,
     820,   350,   821,   824,   351,   874,   875,   876,   877,   878,
     860,   393,   825,   358,   359,   826,   247,   827,   360,   361,
     362,   828,   829,   830,   831,   363,   832,   364,   365,   366,
     367,   845,   835,   869,   870,   368,   369,   370,   371,   342,
     871,   343,   344,   345,   346,   347,   348,   467,   872,   399,
     400,   401,   468,   873,   890,   880,   891,   698,   892,   898,
     469,   899,   470,   471,   472,   900,   908,   120,   121,   488,
     489,   490,   491,   492,   493,   494,   495,   496,   910,   352,
     914,    53,   122,   349,   120,   121,   918,   353,   123,   350,
     124,   125,   351,   912,   936,   913,   937,   934,    53,   122,
     942,   944,   943,   952,   950,   123,   955,   124,   125,   797,
     965,   981,   982,   406,   354,   983,   355,   984,   356,   985,
     986,   357,  1015,  1016,  1056,  1057,  1058,  1059,  1069,   277,
    1060,  1062,  1074,  1075,   342,  1076,   343,   344,   345,   346,
     347,   348,  1080,  1082,  1083,  1085,  1086,  1088,   358,   359,
    1096,  1097,  1103,   360,   361,   362,  1104,  1105,  1106,  1107,
     363,  1108,   364,   365,   366,   367,  1109,   352,  1123,  1125,
     368,   369,   370,   371,  1126,   353,  1135,  1136,   349,   126,
    1137,  1138,  1139,   127,   350,  1176,  1169,   351,  1187,  1180,
    1239,   128,   748,   129,  1190,  1193,   126,   120,   121,  1195,
     127,  1197,   354,  1198,   355,  1199,   356,  1202,   128,   357,
     129,    53,   122,  1207,  1237,  1205,  1206,  1211,   123,  1213,
     124,   125,  1281,  1261,  1279,  1280,  1289,   729,   730,   731,
    1282,  1300,  1305,  1307,  1311,  1314,   358,   359,  1294,  1315,
     740,   360,   361,   362,  1323,  1324,  1325,  1326,   363,  1336,
     364,   365,   366,   367,  1349,  1341,  1394,  1347,   368,   369,
     370,   371,   352,  1362,  1396,  1398,  1400,  1416,  1415,  1350,
     353,   766,   768,   770,  1351,  1352,   774,  1353,   776,  1417,
     893,   159,   179,   201,   218,   233,   250,   263,   280,  1354,
     789,   790,  1355,  1356,   792,  1401,  1357,   354,  1358,   355,
    1361,   356,  1405,  1402,   357,  1418,  1406,  1407,  1408,   126,
    1409,  1410,  1411,   127,  1429,  1412,  1413,  1431,  1414,  1433,
    1435,   128,    70,   129,   337,   555,   598,   296,   676,   959,
    1003,   358,   359,   662,  1007,  1009,   360,   361,   362,   220,
     221,  1010,  1283,   363,  1159,   364,   365,   366,   367,   598,
    1142,  1272,   252,   368,   369,   370,   371,   746,   742,   744,
     862,   864,   467,   707,   399,   400,   401,   468,    59,  1013,
     557,   394,   395,   615,   656,   469,   602,   470,   471,   472,
     905,  1295,   626,   396,     0,   397,   398,   399,   400,   401,
     160,   180,   202,   219,   234,   251,   264,   281,   402,   403,
     162,   182,   204,   223,   235,   253,   266,   282,   916,   451,
       0,   919,  1020,  1021,  1022,  1023,  1024,  1025,  1026,  1027,
    1028,  1029,  1030,  1031,  1032,  1033,  1034,  1035,  1036,  1037,
    1038,  1039,  1040,  1041,  1042,  1043,  1044,  1045,  1046,  1047,
    1048,  1049,  1050,  1051,  1052,  1053,  1054,  1055,   163,   183,
     205,   224,   236,   254,   267,   283,   164,   184,   206,   225,
     237,   255,   268,   284,   165,   185,   207,   226,   238,   256,
     269,   285,   166,   186,   208,   227,   239,   257,   270,   286,
     167,   187,   209,   228,   240,   258,   271,   287,   168,   188,
     210,   229,   241,   259,   272,   288
};

static const yytype_int16 yycheck[] =
{
     408,   336,   336,   437,   395,   388,   397,   398,    86,   450,
     565,   402,   403,   120,   121,   406,   123,   143,   418,   419,
     336,   421,   372,   341,   415,    21,    22,   247,    24,   332,
       6,    22,    23,    41,     5,   418,   419,    26,   421,     6,
     804,    30,    31,    29,    33,    34,    16,    36,    37,    35,
     141,   606,    54,   444,   609,   240,   447,   612,    87,    38,
      58,     6,   453,   454,   455,   473,   457,   458,   141,   644,
     645,   462,   463,   464,   259,    93,   467,   468,    87,    11,
      47,    48,    49,    50,   139,   476,    56,    74,   141,   480,
       8,   139,    10,    90,    12,    13,    22,    23,   139,    17,
      18,   269,    26,    55,    90,    91,    30,    31,   139,    33,
      34,    29,    36,    37,    93,   168,    55,   285,   436,    60,
      90,    62,    63,    64,    65,    66,    67,    68,    69,   135,
     136,   137,   138,    51,    52,   132,   132,   133,   203,   141,
     205,    59,   141,    61,   217,   218,   219,   165,    22,    23,
     168,   237,    70,   267,     6,   141,   270,    70,   842,     6,
      73,   214,   846,    71,   443,   141,    16,    85,    71,    87,
     141,   141,   237,     6,   141,   139,   262,   268,   196,    29,
     459,   170,   169,   170,   202,    35,   594,   595,   596,   141,
     208,   209,   956,   957,   958,   842,   141,   588,   589,   846,
      41,   133,   141,    53,    54,   203,   781,   205,   558,   196,
     139,   240,    41,     0,    90,   623,   624,   625,   217,   218,
     219,    58,   230,   231,   232,   233,    16,    77,    78,    79,
     638,   240,     3,    83,   210,   211,   212,   213,   214,   647,
      90,    91,   198,   199,   141,   653,   170,   214,   639,    39,
     641,   280,   660,   473,   557,    41,   153,    29,   336,   139,
     651,   652,   238,    35,   240,   699,   284,   617,   238,   187,
      74,   280,   139,   259,    78,   281,   252,   203,   141,   205,
     188,   189,   200,   259,   275,   188,   189,   283,   206,   141,
      74,   141,   281,   139,   141,   132,   133,   141,   616,   889,
      71,    72,   710,   711,   712,   713,   714,   715,   141,   153,
      90,   237,   720,   141,    85,    86,   163,   164,    90,   171,
     172,    92,   174,    94,    95,   153,   239,   203,   175,   205,
     177,   178,   179,   180,   181,   141,   210,   211,   212,   213,
     281,   749,   750,   190,   191,   141,   754,   153,   756,   757,
     685,   759,   760,   271,   217,   218,   219,   281,   132,   949,
      74,    19,   214,   237,   238,   773,   203,   214,   205,   777,
     778,   779,   141,    90,    88,   141,   280,   210,   211,   212,
     213,   214,   234,   235,   153,   793,    90,   153,   240,   230,
     231,   232,   233,   240,    71,    72,   243,   747,   141,   833,
     252,   230,   231,   232,   233,   252,   141,   240,    85,   259,
     153,   132,   183,    90,   133,    92,   187,   133,   153,   252,
     141,   728,   729,   203,   195,   205,   197,   280,   739,   230,
     231,   232,   233,   559,   842,   843,   844,   134,   846,   135,
     136,   137,   138,   141,   230,   231,   232,   233,   755,   221,
     222,   223,   224,   225,   226,   227,   228,   229,   132,   766,
     894,   768,   246,   247,   248,   249,    29,   141,   133,   776,
     241,   879,    35,   141,   258,   142,  1066,   784,   785,   132,
     791,   134,   789,   790,   132,   133,   203,  1077,   205,   203,
     204,   205,    90,   142,   902,  1023,   132,   905,   134,   203,
     908,   205,   910,   280,   912,   913,   132,   915,   142,   265,
     918,    90,   920,   921,    73,   141,   823,   824,   825,   826,
      73,  1111,    71,    72,   132,    73,   842,   935,    73,   937,
     846,  1121,    16,   141,   132,   133,    85,  1127,  1128,  1129,
    1130,  1131,  1132,    92,   258,   132,   133,   988,   911,   217,
     218,   219,    73,   132,   133,   862,    71,   864,   272,     9,
     871,   872,   873,   230,   231,   232,   233,   244,   245,    76,
     132,   141,   698,   133,    90,   938,   939,   940,   941,   141,
    1170,   230,   231,   232,   233,   281,     7,   898,   899,   900,
     263,   132,  1182,   203,  1184,   205,   230,   231,   232,   233,
     141,   132,   280,   914,   280,   203,    57,   205,   132,   133,
     141,  1201,   919,  1141,  1142,   133,   132,   133,  1208,  1209,
    1210,   133,   748,  1178,   203,   936,   205,   237,  1156,   133,
    1158,  1159,  1160,   944,   133,   942,   943,    90,  1072,   132,
    1230,   952,    72,    73,    74,   208,   209,   133,    78,   132,
    1240,  1241,  1242,  1243,   142,   184,   185,   186,   221,   222,
     223,   224,   225,   226,   227,   228,   229,  1075,  1068,   132,
     981,   982,   983,   984,   985,   986,    80,    81,    82,   132,
     133,  1089,   134,  1091,   268,  1068,   140,   203,  1096,   205,
     139,  1099,  1100,    27,    28,   244,   245,   132,  1061,    25,
    1063,   171,   172,  1293,   141,  1113,  1114,  1115,  1116,    72,
      73,    74,  1302,  1303,  1304,    78,  1306,   141,  1308,  1309,
    1310,   260,   261,  1313,    73,    74,  1316,  1317,    75,    78,
     132,  1321,  1322,   154,   155,   156,   157,   158,   159,   160,
     161,   162,   230,   231,   232,   233,   142,  1058,  1059,   133,
     203,    89,   205,  1144,  1145,  1146,  1147,  1148,  1149,  1150,
    1151,  1152,  1153,  1074,   842,  1076,   280,   893,   846,  1080,
      89,  1082,  1083,   133,  1085,  1086,   274,   275,   885,     3,
     141,  1371,    48,    49,   142,  1375,  1097,  1377,   255,   256,
     257,  1381,   133,  1383,  1384,   266,  1107,  1108,  1109,  1389,
    1390,  1391,  1392,   132,   133,  1140,  1140,   266,  1023,    72,
      73,    74,  1123,   199,  1222,    78,  1224,   264,  1226,   141,
    1228,   799,   800,   801,  1135,  1136,  1137,    92,  1139,   210,
     211,   212,   213,    73,   230,   231,   232,   233,   132,   133,
    1430,   252,  1432,    55,  1434,   141,  1436,    71,    72,   132,
     133,  1441,   280,  1443,   239,  1445,   237,  1447,  1249,    53,
      54,    85,    86,   132,   133,  1176,    14,    15,    92,     3,
      94,    95,   230,   231,   232,   233,  1187,    27,    28,  1190,
     132,   133,  1193,   239,  1195,    79,  1197,  1198,  1199,    83,
     168,  1202,   215,   216,  1205,  1206,    90,    91,   215,   216,
    1211,    40,  1213,   143,   144,   145,   146,   147,   148,   149,
     150,   151,   152,   217,   218,   219,     3,   215,   216,  1327,
     141,  1329,    40,  1331,    93,  1333,  1141,  1142,    40,   132,
      42,    43,    44,    45,    46,    47,   132,    71,    72,   215,
     216,  1156,   216,  1158,  1159,  1160,   132,   141,  1416,  1417,
    1418,    85,    86,   135,   136,   137,   138,   133,    92,   183,
      94,    95,    14,   187,    16,  1296,  1297,  1298,   208,   209,
     133,   195,    84,   197,    26,    27,    28,    29,    90,    31,
      32,    93,   214,   282,    71,    72,  1296,  1297,  1298,  1300,
       3,   133,   215,   216,  1305,   132,  1307,   132,    85,    86,
    1311,   208,   209,  1314,  1315,    92,    87,    94,    95,   166,
     167,   282,  1323,  1324,  1325,  1326,    40,   141,    42,    43,
      44,    45,    46,    47,    76,   132,   133,   795,   796,  1118,
    1119,  1120,  1417,  1418,  1297,  1298,    88,    89,   282,   282,
     282,   282,   274,   275,   276,   277,   278,   279,   282,   183,
     141,   282,   214,   187,   282,   282,   168,   282,    71,    72,
      84,   195,   282,   197,   176,   282,    90,   282,   282,    93,
      55,   282,    85,    86,   236,   141,   282,   282,   132,    92,
     133,    94,    95,  1394,   265,  1396,   273,  1398,    76,  1400,
     141,   203,   141,   205,   141,   207,   183,   141,   210,   214,
     187,   221,   222,   223,   224,   225,   226,   227,   195,   229,
     197,     5,   274,   275,   276,   277,   278,   279,  1429,     5,
    1431,   236,  1433,   141,  1435,   237,   238,   141,    93,  1218,
     242,   243,   244,   141,  1223,   141,  1225,   249,  1227,   251,
     252,   253,   254,    93,   168,   141,   141,   259,   260,   261,
     262,    40,   176,    42,    43,    44,    45,    46,    47,   274,
     275,   276,   277,   278,   279,    79,   141,   141,   141,   281,
     183,     5,   141,   132,   187,   132,   132,   132,   132,   203,
      20,   205,   195,   207,   197,   133,   210,    72,    73,    74,
      75,    76,    77,    78,    79,    84,   132,   141,   133,     3,
     133,    90,   133,   141,    93,   216,   217,   218,   219,   220,
      55,   141,   141,   237,   238,   141,     3,   141,   242,   243,
     244,   141,   141,   141,   141,   249,   216,   251,   252,   253,
     254,   141,   216,   142,   142,   259,   260,   261,   262,    40,
       5,    42,    43,    44,    45,    46,    47,   177,     5,   179,
     180,   181,   182,     5,   216,    55,   216,   281,   216,     5,
     190,     5,   192,   193,   194,     5,   173,    71,    72,   221,
     222,   223,   224,   225,   226,   227,   228,   229,   173,   168,
       5,    85,    86,    84,    71,    72,   142,   176,    92,    90,
      94,    95,    93,   215,     5,   216,   142,   250,    85,    86,
     141,     5,   141,     5,   142,    92,   132,    94,    95,   275,
     141,     5,     5,   243,   203,     5,   205,     5,   207,     5,
       5,   210,   132,   132,   141,   141,     5,     5,     4,     3,
     173,   173,     5,   132,    40,     5,    42,    43,    44,    45,
      46,    47,     5,     5,     5,     5,     5,   216,   237,   238,
     142,     5,   132,   242,   243,   244,   141,   141,   141,     5,
     249,     5,   251,   252,   253,   254,     5,   168,     5,   132,
     259,   260,   261,   262,   132,   176,     5,     5,    84,   183,
       5,   132,     5,   187,    90,     5,   216,    93,     5,     3,
     132,   195,   281,   197,     5,     5,   183,    71,    72,     5,
     187,     5,   203,     5,   205,     5,   207,     5,   195,   210,
     197,    85,    86,   216,   279,     5,     5,     5,    92,     5,
      94,    95,   141,   133,   132,   132,   201,   591,   592,   593,
     133,     5,     5,     5,     5,     5,   237,   238,    94,     5,
     604,   242,   243,   244,     5,     5,     5,     5,   249,   141,
     251,   252,   253,   254,   141,   132,     5,   132,   259,   260,
     261,   262,   168,   132,     5,     5,     5,     5,    55,   141,
     176,   635,   636,   637,   141,   141,   640,   141,   642,     5,
     281,    72,    73,    74,    75,    76,    77,    78,    79,   141,
     654,   655,   141,   141,   658,   219,   141,   203,   141,   205,
     141,   207,   142,   141,   210,     5,   142,   142,   142,   183,
     142,   142,   142,   187,     5,   142,   142,     5,   142,     5,
       5,   195,    12,   197,   102,   337,   141,    84,   517,   802,
     846,   237,   238,   484,   846,   846,   242,   243,   244,    75,
      75,   846,  1165,   249,  1026,   251,   252,   253,   254,   141,
    1022,  1156,    77,   259,   260,   261,   262,   612,   606,   609,
     724,   725,   177,   565,   179,   180,   181,   182,     1,   846,
     340,   163,   164,   433,   473,   190,   408,   192,   193,   194,
     758,  1178,   443,   175,    -1,   177,   178,   179,   180,   181,
      72,    73,    74,    75,    76,    77,    78,    79,   190,   191,
      72,    73,    74,    75,    76,    77,    78,    79,   772,   156,
      -1,   775,    96,    97,    98,    99,   100,   101,   102,   103,
     104,   105,   106,   107,   108,   109,   110,   111,   112,   113,
     114,   115,   116,   117,   118,   119,   120,   121,   122,   123,
     124,   125,   126,   127,   128,   129,   130,   131,    72,    73,
      74,    75,    76,    77,    78,    79,    72,    73,    74,    75,
      76,    77,    78,    79,    72,    73,    74,    75,    76,    77,
      78,    79,    72,    73,    74,    75,    76,    77,    78,    79,
      72,    73,    74,    75,    76,    77,    78,    79,    72,    73,
      74,    75,    76,    77,    78,    79
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
      23,   237,   501,   237,   238,   485,   501,   487,   274,   275,
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
     484,     5,   484,   141,   497,    22,    23,   275,   337,   362,
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
     493,   499,   499,   499,   499,   499,   499,   279,   335,   132,
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

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
#else
static void
yy_stack_print (yybottom, yytop)
    yytype_int16 *yybottom;
    yytype_int16 *yytop;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

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
#ifndef	YYINITDEPTH
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
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
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
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
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

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}

/* Prevent warnings from -Wmissing-prototypes.  */
#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */


/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*-------------------------.
| yyparse or yypush_parse.  |
`-------------------------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{


    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       `yyss': related to states.
       `yyvs': related to semantic values.

       Refer to the stacks thru separate pointers, to allow yyoverflow
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
  int yytoken;
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

  yytoken = 0;
  yyss = yyssa;
  yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */
  yyssp = yyss;
  yyvsp = yyvs;

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
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
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
      if (yyn == 0 || yyn == YYTABLE_NINF)
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
  *++yyvsp = yylval;

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
     `$$ = $1'.

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

/* Line 1455 of yacc.c  */
#line 593 "src/p.y"
    {
                        mailset.events = Event_All;
                        addmail((yyvsp[(2) - (4)].string), &mailset, &Run.maillist);
                  }
    break;

  case 193:

/* Line 1455 of yacc.c  */
#line 597 "src/p.y"
    {
                        addmail((yyvsp[(2) - (7)].string), &mailset, &Run.maillist);
                  }
    break;

  case 194:

/* Line 1455 of yacc.c  */
#line 600 "src/p.y"
    {
                        mailset.events = ~mailset.events;
                        addmail((yyvsp[(2) - (8)].string), &mailset, &Run.maillist);
                  }
    break;

  case 195:

/* Line 1455 of yacc.c  */
#line 606 "src/p.y"
    {
                        if (! (Run.flags & Run_Daemon) || ihp.daemon) {
                                ihp.daemon     = true;
                                Run.flags      |= Run_Daemon;
                                Run.polltime   = (yyvsp[(3) - (4)].number);
                                Run.startdelay = (yyvsp[(4) - (4)].number);
                        }
                  }
    break;

  case 196:

/* Line 1455 of yacc.c  */
#line 616 "src/p.y"
    {
                        Run.flags |= Run_Batch;
                  }
    break;

  case 197:

/* Line 1455 of yacc.c  */
#line 621 "src/p.y"
    {
                        (yyval.number) = START_DELAY;
                  }
    break;

  case 198:

/* Line 1455 of yacc.c  */
#line 624 "src/p.y"
    {
                        (yyval.number) = (yyvsp[(3) - (3)].number);
                  }
    break;

  case 199:

/* Line 1455 of yacc.c  */
#line 629 "src/p.y"
    {
                        Run.flags |= Run_Foreground;
                  }
    break;

  case 200:

/* Line 1455 of yacc.c  */
#line 634 "src/p.y"
    {
                        Run.onreboot = Onreboot_Start;
                  }
    break;

  case 201:

/* Line 1455 of yacc.c  */
#line 637 "src/p.y"
    {
                        Run.onreboot = Onreboot_Nostart;
                  }
    break;

  case 202:

/* Line 1455 of yacc.c  */
#line 640 "src/p.y"
    {
                        Run.onreboot = Onreboot_Laststate;
                  }
    break;

  case 203:

/* Line 1455 of yacc.c  */
#line 645 "src/p.y"
    {
                        // Note: deprecated (replaced by "set limits" statement's "sendExpectBuffer" option)
                        Run.limits.sendExpectBuffer = (yyvsp[(3) - (4)].number) * (yyvsp[(4) - (4)].number);
                  }
    break;

  case 207:

/* Line 1455 of yacc.c  */
#line 658 "src/p.y"
    {
                        Run.limits.sendExpectBuffer = (yyvsp[(3) - (4)].number) * (yyvsp[(4) - (4)].number);
                  }
    break;

  case 208:

/* Line 1455 of yacc.c  */
#line 661 "src/p.y"
    {
                        Run.limits.fileContentBuffer = (yyvsp[(3) - (4)].number) * (yyvsp[(4) - (4)].number);
                  }
    break;

  case 209:

/* Line 1455 of yacc.c  */
#line 664 "src/p.y"
    {
                        Run.limits.httpContentBuffer = (yyvsp[(3) - (4)].number) * (yyvsp[(4) - (4)].number);
                  }
    break;

  case 210:

/* Line 1455 of yacc.c  */
#line 667 "src/p.y"
    {
                        Run.limits.programOutput = (yyvsp[(3) - (4)].number) * (yyvsp[(4) - (4)].number);
                  }
    break;

  case 211:

/* Line 1455 of yacc.c  */
#line 670 "src/p.y"
    {
                        Run.limits.networkTimeout = (yyvsp[(3) - (4)].number);
                  }
    break;

  case 212:

/* Line 1455 of yacc.c  */
#line 673 "src/p.y"
    {
                        Run.limits.networkTimeout = (yyvsp[(3) - (4)].number) * 1000;
                  }
    break;

  case 213:

/* Line 1455 of yacc.c  */
#line 676 "src/p.y"
    {
                        Run.limits.programTimeout = (yyvsp[(3) - (4)].number);
                  }
    break;

  case 214:

/* Line 1455 of yacc.c  */
#line 679 "src/p.y"
    {
                        Run.limits.programTimeout = (yyvsp[(3) - (4)].number) * 1000;
                  }
    break;

  case 215:

/* Line 1455 of yacc.c  */
#line 682 "src/p.y"
    {
                        Run.limits.stopTimeout = (yyvsp[(3) - (4)].number);
                  }
    break;

  case 216:

/* Line 1455 of yacc.c  */
#line 685 "src/p.y"
    {
                        Run.limits.stopTimeout = (yyvsp[(3) - (4)].number) * 1000;
                  }
    break;

  case 217:

/* Line 1455 of yacc.c  */
#line 688 "src/p.y"
    {
                        Run.limits.startTimeout = (yyvsp[(3) - (4)].number);
                  }
    break;

  case 218:

/* Line 1455 of yacc.c  */
#line 691 "src/p.y"
    {
                        Run.limits.startTimeout = (yyvsp[(3) - (4)].number) * 1000;
                  }
    break;

  case 219:

/* Line 1455 of yacc.c  */
#line 694 "src/p.y"
    {
                        Run.limits.restartTimeout = (yyvsp[(3) - (4)].number);
                  }
    break;

  case 220:

/* Line 1455 of yacc.c  */
#line 697 "src/p.y"
    {
                        Run.limits.restartTimeout = (yyvsp[(3) - (4)].number) * 1000;
                  }
    break;

  case 221:

/* Line 1455 of yacc.c  */
#line 702 "src/p.y"
    {
                        Run.flags |= Run_FipsEnabled;
                  }
    break;

  case 222:

/* Line 1455 of yacc.c  */
#line 707 "src/p.y"
    {
                        if (! Run.files.log || ihp.logfile) {
                                ihp.logfile = true;
                                setlogfile((yyvsp[(3) - (3)].string));
                                Run.flags &= ~Run_UseSyslog;
                                Run.flags |= Run_Log;
                        }
                  }
    break;

  case 223:

/* Line 1455 of yacc.c  */
#line 715 "src/p.y"
    {
                        setsyslog(NULL);
                  }
    break;

  case 224:

/* Line 1455 of yacc.c  */
#line 718 "src/p.y"
    {
                        setsyslog((yyvsp[(5) - (5)].string)); FREE((yyvsp[(5) - (5)].string));
                  }
    break;

  case 225:

/* Line 1455 of yacc.c  */
#line 723 "src/p.y"
    {
                        Run.eventlist_dir = (yyvsp[(4) - (4)].string);
                  }
    break;

  case 226:

/* Line 1455 of yacc.c  */
#line 726 "src/p.y"
    {
                        Run.eventlist_dir = (yyvsp[(4) - (6)].string);
                        Run.eventlist_slots = (yyvsp[(6) - (6)].number);
                  }
    break;

  case 227:

/* Line 1455 of yacc.c  */
#line 730 "src/p.y"
    {
                        Run.eventlist_dir = Str_dup(MYEVENTLISTBASE);
                        Run.eventlist_slots = (yyvsp[(4) - (4)].number);
                  }
    break;

  case 228:

/* Line 1455 of yacc.c  */
#line 736 "src/p.y"
    {
                        Run.files.id = (yyvsp[(3) - (3)].string);
                  }
    break;

  case 229:

/* Line 1455 of yacc.c  */
#line 741 "src/p.y"
    {
                        Run.files.state = (yyvsp[(3) - (3)].string);
                  }
    break;

  case 230:

/* Line 1455 of yacc.c  */
#line 746 "src/p.y"
    {
                        if (! Run.files.pid || ihp.pidfile) {
                                ihp.pidfile = true;
                                setpidfile((yyvsp[(3) - (3)].string));
                        }
                  }
    break;

  case 234:

/* Line 1455 of yacc.c  */
#line 761 "src/p.y"
    {
                        mmonitset.url = (yyvsp[(1) - (2)].url);
                        addmmonit(&mmonitset);
                  }
    break;

  case 237:

/* Line 1455 of yacc.c  */
#line 771 "src/p.y"
    {
                        mmonitset.timeout = (yyvsp[(2) - (3)].number) * 1000; // net timeout is in milliseconds internally
                  }
    break;

  case 243:

/* Line 1455 of yacc.c  */
#line 781 "src/p.y"
    {
                        Run.flags &= ~Run_MmonitCredentials;
                  }
    break;

  case 244:

/* Line 1455 of yacc.c  */
#line 786 "src/p.y"
    {
                        _setSSLOptions(&(Run.ssl));
                  }
    break;

  case 245:

/* Line 1455 of yacc.c  */
#line 791 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                  }
    break;

  case 249:

/* Line 1455 of yacc.c  */
#line 801 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                        sslset.verify = true;
                  }
    break;

  case 250:

/* Line 1455 of yacc.c  */
#line 805 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                        sslset.verify = false;
                  }
    break;

  case 251:

/* Line 1455 of yacc.c  */
#line 809 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                        sslset.allowSelfSigned = true;
                  }
    break;

  case 252:

/* Line 1455 of yacc.c  */
#line 813 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                        sslset.allowSelfSigned = false;
                  }
    break;

  case 253:

/* Line 1455 of yacc.c  */
#line 817 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                  }
    break;

  case 254:

/* Line 1455 of yacc.c  */
#line 820 "src/p.y"
    {
                        FREE(sslset.ciphers);
                        sslset.ciphers = (yyvsp[(3) - (3)].string);
                  }
    break;

  case 255:

/* Line 1455 of yacc.c  */
#line 824 "src/p.y"
    {
                        _setPEM(&(sslset.pemfile), (yyvsp[(3) - (3)].string), "SSL server PEM file", true);
                  }
    break;

  case 256:

/* Line 1455 of yacc.c  */
#line 827 "src/p.y"
    {
                        _setPEM(&(sslset.clientpemfile), (yyvsp[(3) - (3)].string), "SSL client PEM file", true);
                  }
    break;

  case 257:

/* Line 1455 of yacc.c  */
#line 830 "src/p.y"
    {
                        _setPEM(&(sslset.CACertificateFile), (yyvsp[(3) - (3)].string), "SSL CA certificates file", true);
                  }
    break;

  case 258:

/* Line 1455 of yacc.c  */
#line 833 "src/p.y"
    {
                        _setPEM(&(sslset.CACertificatePath), (yyvsp[(3) - (3)].string), "SSL CA certificates directory", false);
                  }
    break;

  case 259:

/* Line 1455 of yacc.c  */
#line 838 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                        portset.target.net.ssl.certificate.minimumDays = (yyvsp[(4) - (5)].number);
                  }
    break;

  case 262:

/* Line 1455 of yacc.c  */
#line 848 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                        sslset.checksum = (yyvsp[(4) - (4)].string);
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
    break;

  case 263:

/* Line 1455 of yacc.c  */
#line 862 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                        sslset.checksum = (yyvsp[(5) - (5)].string);
                        if (cleanup_hash_string(sslset.checksum) != 32)
                                yyerror2("Unknown checksum type: [%s] is not MD5", sslset.checksum);
                        sslset.checksumType = Hash_Md5;
                  }
    break;

  case 264:

/* Line 1455 of yacc.c  */
#line 869 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                        sslset.checksum = (yyvsp[(5) - (5)].string);
                        if (cleanup_hash_string(sslset.checksum) != 40)
                                yyerror2("Unknown checksum type: [%s] is not SHA1", sslset.checksum);
                        sslset.checksumType = Hash_Sha1;
                  }
    break;

  case 267:

/* Line 1455 of yacc.c  */
#line 882 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_V2;
                  }
    break;

  case 268:

/* Line 1455 of yacc.c  */
#line 886 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_V3;
                  }
    break;

  case 269:

/* Line 1455 of yacc.c  */
#line 890 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_TLSV1;
                  }
    break;

  case 270:

/* Line 1455 of yacc.c  */
#line 895 "src/p.y"
    {
#ifndef HAVE_TLSV1_1
                        yyerror("Your SSL Library does not support TLS version 1.1");
#endif
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_TLSV11;
                }
    break;

  case 271:

/* Line 1455 of yacc.c  */
#line 903 "src/p.y"
    {
#ifndef HAVE_TLSV1_2
                        yyerror("Your SSL Library does not support TLS version 1.2");
#endif
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_TLSV12;
                }
    break;

  case 272:

/* Line 1455 of yacc.c  */
#line 911 "src/p.y"
    {
#ifndef HAVE_TLSV1_3
                        yyerror("Your SSL Library does not support TLS version 1.3");
#endif
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_TLSV13;
                }
    break;

  case 273:

/* Line 1455 of yacc.c  */
#line 919 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_Auto;
                  }
    break;

  case 274:

/* Line 1455 of yacc.c  */
#line 923 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                        sslset.version = SSL_Auto;
                  }
    break;

  case 275:

/* Line 1455 of yacc.c  */
#line 929 "src/p.y"
    { // Backward compatibility
                        sslset.flags = SSL_Enabled;
                        sslset.checksum = (yyvsp[(2) - (2)].string);
                        if (cleanup_hash_string(sslset.checksum) != 32)
                                yyerror2("Unknown checksum type: [%s] is not MD5", sslset.checksum);
                        sslset.checksumType = Hash_Md5;
                  }
    break;

  case 276:

/* Line 1455 of yacc.c  */
#line 938 "src/p.y"
    {
                        if (((yyvsp[(4) - (5)].number)) > SMTP_TIMEOUT)
                                Run.mailserver_timeout = (yyvsp[(4) - (5)].number);
                        Run.mail_hostname = (yyvsp[(5) - (5)].string);
                  }
    break;

  case 277:

/* Line 1455 of yacc.c  */
#line 945 "src/p.y"
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
    break;

  case 280:

/* Line 1455 of yacc.c  */
#line 964 "src/p.y"
    {
                        /* Restore the current text overriden by lookahead */
                        FREE(argyytext);
                        argyytext = Str_dup((yyvsp[(1) - (2)].string));

                        mailserverset.host = (yyvsp[(1) - (2)].string);
                        mailserverset.port = PORT_SMTP;
                        addmailserver(&mailserverset);
                  }
    break;

  case 281:

/* Line 1455 of yacc.c  */
#line 973 "src/p.y"
    {
                        /* Restore the current text overriden by lookahead */
                        FREE(argyytext);
                        argyytext = Str_dup((yyvsp[(1) - (4)].string));

                        mailserverset.host = (yyvsp[(1) - (4)].string);
                        mailserverset.port = (yyvsp[(3) - (4)].number);
                        addmailserver(&mailserverset);
                  }
    break;

  case 284:

/* Line 1455 of yacc.c  */
#line 988 "src/p.y"
    {
                        mailserverset.username = (yyvsp[(1) - (1)].string);
                  }
    break;

  case 285:

/* Line 1455 of yacc.c  */
#line 991 "src/p.y"
    {
                        mailserverset.password = (yyvsp[(1) - (1)].string);
                  }
    break;

  case 290:

/* Line 1455 of yacc.c  */
#line 1000 "src/p.y"
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
    break;

  case 302:

/* Line 1455 of yacc.c  */
#line 1033 "src/p.y"
    {
                        _setPEM(&(sslset.pemfile), (yyvsp[(2) - (2)].string), "SSL server PEM file", true);
                  }
    break;

  case 303:

/* Line 1455 of yacc.c  */
#line 1039 "src/p.y"
    {
                        _setPEM(&(sslset.clientpemfile), (yyvsp[(2) - (2)].string), "SSL client PEM file", true);
                  }
    break;

  case 304:

/* Line 1455 of yacc.c  */
#line 1045 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                        sslset.allowSelfSigned = true;
                  }
    break;

  case 305:

/* Line 1455 of yacc.c  */
#line 1051 "src/p.y"
    {
                        Run.httpd.flags |= Httpd_Net;
                        Run.httpd.socket.net.port = (yyvsp[(2) - (2)].number);
                  }
    break;

  case 306:

/* Line 1455 of yacc.c  */
#line 1057 "src/p.y"
    {
                        Run.httpd.flags |= Httpd_Unix;
                        Run.httpd.socket.unix.path = (yyvsp[(2) - (3)].string);
                  }
    break;

  case 309:

/* Line 1455 of yacc.c  */
#line 1067 "src/p.y"
    {
                        Run.httpd.flags |= Httpd_UnixUid;
                        Run.httpd.socket.unix.uid = get_uid((yyvsp[(2) - (2)].string), 0);
                        FREE((yyvsp[(2) - (2)].string));
                    }
    break;

  case 310:

/* Line 1455 of yacc.c  */
#line 1072 "src/p.y"
    {
                        Run.httpd.flags |= Httpd_UnixGid;
                        Run.httpd.socket.unix.gid = get_gid((yyvsp[(2) - (2)].string), 0);
                        FREE((yyvsp[(2) - (2)].string));
                    }
    break;

  case 311:

/* Line 1455 of yacc.c  */
#line 1077 "src/p.y"
    {
                        Run.httpd.flags |= Httpd_UnixUid;
                        Run.httpd.socket.unix.uid = get_uid(NULL, (yyvsp[(2) - (2)].number));
                    }
    break;

  case 312:

/* Line 1455 of yacc.c  */
#line 1081 "src/p.y"
    {
                        Run.httpd.flags |= Httpd_UnixGid;
                        Run.httpd.socket.unix.gid = get_gid(NULL, (yyvsp[(2) - (2)].number));
                    }
    break;

  case 313:

/* Line 1455 of yacc.c  */
#line 1085 "src/p.y"
    {
                        Run.httpd.flags |= Httpd_UnixPermission;
                        Run.httpd.socket.unix.permission = check_perm((yyvsp[(2) - (2)].number));
                    }
    break;

  case 318:

/* Line 1455 of yacc.c  */
#line 1099 "src/p.y"
    {
                        Run.httpd.flags |= Httpd_Signature;
                  }
    break;

  case 319:

/* Line 1455 of yacc.c  */
#line 1102 "src/p.y"
    {
                        Run.httpd.flags &= ~Httpd_Signature;
                  }
    break;

  case 320:

/* Line 1455 of yacc.c  */
#line 1107 "src/p.y"
    {
                        Run.httpd.socket.net.address = (yyvsp[(2) - (2)].string);
                  }
    break;

  case 321:

/* Line 1455 of yacc.c  */
#line 1112 "src/p.y"
    {
                        addcredentials((yyvsp[(2) - (5)].string), (yyvsp[(4) - (5)].string), Digest_Cleartext, (yyvsp[(5) - (5)].number));
                  }
    break;

  case 322:

/* Line 1455 of yacc.c  */
#line 1115 "src/p.y"
    {
#ifdef HAVE_LIBPAM
                        addpamauth((yyvsp[(3) - (4)].string), (yyvsp[(4) - (4)].number));
#else
                        yyerror("PAM is not supported");
                        FREE((yyvsp[(3) - (4)].string));
#endif
                  }
    break;

  case 323:

/* Line 1455 of yacc.c  */
#line 1123 "src/p.y"
    {
                        addhtpasswdentry((yyvsp[(2) - (2)].string), NULL, Digest_Cleartext);
                        FREE((yyvsp[(2) - (2)].string));
                  }
    break;

  case 324:

/* Line 1455 of yacc.c  */
#line 1127 "src/p.y"
    {
                        addhtpasswdentry((yyvsp[(3) - (3)].string), NULL, Digest_Cleartext);
                        FREE((yyvsp[(3) - (3)].string));
                  }
    break;

  case 325:

/* Line 1455 of yacc.c  */
#line 1131 "src/p.y"
    {
                        addhtpasswdentry((yyvsp[(3) - (3)].string), NULL, Digest_Md5);
                        FREE((yyvsp[(3) - (3)].string));
                  }
    break;

  case 326:

/* Line 1455 of yacc.c  */
#line 1135 "src/p.y"
    {
                        addhtpasswdentry((yyvsp[(3) - (3)].string), NULL, Digest_Crypt);
                        FREE((yyvsp[(3) - (3)].string));
                  }
    break;

  case 327:

/* Line 1455 of yacc.c  */
#line 1139 "src/p.y"
    {
                        htpasswd_file = (yyvsp[(2) - (2)].string);
                        digesttype = Digest_Cleartext;
                  }
    break;

  case 328:

/* Line 1455 of yacc.c  */
#line 1143 "src/p.y"
    {
                        FREE(htpasswd_file);
                  }
    break;

  case 329:

/* Line 1455 of yacc.c  */
#line 1146 "src/p.y"
    {
                        htpasswd_file = (yyvsp[(3) - (3)].string);
                        digesttype = Digest_Cleartext;
                  }
    break;

  case 330:

/* Line 1455 of yacc.c  */
#line 1150 "src/p.y"
    {
                        FREE(htpasswd_file);
                  }
    break;

  case 331:

/* Line 1455 of yacc.c  */
#line 1153 "src/p.y"
    {
                        htpasswd_file = (yyvsp[(3) - (3)].string);
                        digesttype = Digest_Md5;
                  }
    break;

  case 332:

/* Line 1455 of yacc.c  */
#line 1157 "src/p.y"
    {
                        FREE(htpasswd_file);
                  }
    break;

  case 333:

/* Line 1455 of yacc.c  */
#line 1160 "src/p.y"
    {
                        htpasswd_file = (yyvsp[(3) - (3)].string);
                        digesttype = Digest_Crypt;
                  }
    break;

  case 334:

/* Line 1455 of yacc.c  */
#line 1164 "src/p.y"
    {
                        FREE(htpasswd_file);
                  }
    break;

  case 335:

/* Line 1455 of yacc.c  */
#line 1167 "src/p.y"
    {
                        if (! Engine_addAllow((yyvsp[(2) - (2)].string)))
                                yywarning2("invalid allow option", (yyvsp[(2) - (2)].string));
                        FREE((yyvsp[(2) - (2)].string));
                  }
    break;

  case 338:

/* Line 1455 of yacc.c  */
#line 1178 "src/p.y"
    {
                        addhtpasswdentry(htpasswd_file, (yyvsp[(1) - (1)].string), digesttype);
                        FREE((yyvsp[(1) - (1)].string));
                  }
    break;

  case 339:

/* Line 1455 of yacc.c  */
#line 1184 "src/p.y"
    {
                        (yyval.number) = false;
                  }
    break;

  case 340:

/* Line 1455 of yacc.c  */
#line 1187 "src/p.y"
    {
                        (yyval.number) = true;
                  }
    break;

  case 341:

/* Line 1455 of yacc.c  */
#line 1192 "src/p.y"
    {
                        createservice(Service_Process, (yyvsp[(2) - (4)].string), (yyvsp[(4) - (4)].string), check_process);
                  }
    break;

  case 342:

/* Line 1455 of yacc.c  */
#line 1195 "src/p.y"
    {
                        createservice(Service_Process, (yyvsp[(2) - (4)].string), (yyvsp[(4) - (4)].string), check_process);
                  }
    break;

  case 343:

/* Line 1455 of yacc.c  */
#line 1198 "src/p.y"
    {
                        createservice(Service_Process, (yyvsp[(2) - (4)].string), (yyvsp[(4) - (4)].string), check_process);
                        matchset.ignore = false;
                        matchset.match_path = NULL;
                        matchset.match_string = Str_dup((yyvsp[(4) - (4)].string));
                        addmatch(&matchset, Action_Ignored, 0);
                  }
    break;

  case 344:

/* Line 1455 of yacc.c  */
#line 1205 "src/p.y"
    {
                        createservice(Service_Process, (yyvsp[(2) - (4)].string), (yyvsp[(4) - (4)].string), check_process);
                        matchset.ignore = false;
                        matchset.match_path = NULL;
                        matchset.match_string = Str_dup((yyvsp[(4) - (4)].string));
                        addmatch(&matchset, Action_Ignored, 0);
                  }
    break;

  case 345:

/* Line 1455 of yacc.c  */
#line 1214 "src/p.y"
    {
                        createservice(Service_File, (yyvsp[(2) - (4)].string), (yyvsp[(4) - (4)].string), check_file);
                  }
    break;

  case 346:

/* Line 1455 of yacc.c  */
#line 1219 "src/p.y"
    {
                        createservice(Service_Filesystem, (yyvsp[(2) - (4)].string), (yyvsp[(4) - (4)].string), check_filesystem);
                  }
    break;

  case 347:

/* Line 1455 of yacc.c  */
#line 1222 "src/p.y"
    {
                        createservice(Service_Filesystem, (yyvsp[(2) - (4)].string), (yyvsp[(4) - (4)].string), check_filesystem);
                  }
    break;

  case 348:

/* Line 1455 of yacc.c  */
#line 1227 "src/p.y"
    {
                        createservice(Service_Directory, (yyvsp[(2) - (4)].string), (yyvsp[(4) - (4)].string), check_directory);
                  }
    break;

  case 349:

/* Line 1455 of yacc.c  */
#line 1232 "src/p.y"
    {
                        createservice(Service_Host, (yyvsp[(2) - (4)].string), (yyvsp[(4) - (4)].string), check_remote_host);
                  }
    break;

  case 350:

/* Line 1455 of yacc.c  */
#line 1237 "src/p.y"
    {
                        if (Link_isGetByAddressSupported()) {
                                createservice(Service_Net, (yyvsp[(2) - (4)].string), (yyvsp[(4) - (4)].string), check_net);
                                current->inf.net->stats = Link_createForAddress((yyvsp[(4) - (4)].string));
                        } else {
                                yyerror("Network monitoring by IP address is not supported on this platform, please use 'check network <foo> with interface <bar>' instead");
                        }
                  }
    break;

  case 351:

/* Line 1455 of yacc.c  */
#line 1245 "src/p.y"
    {
                        createservice(Service_Net, (yyvsp[(2) - (4)].string), (yyvsp[(4) - (4)].string), check_net);
                        current->inf.net->stats = Link_createForInterface((yyvsp[(4) - (4)].string));
                  }
    break;

  case 352:

/* Line 1455 of yacc.c  */
#line 1251 "src/p.y"
    {
                        char *servicename = (yyvsp[(2) - (2)].string);
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
    break;

  case 353:

/* Line 1455 of yacc.c  */
#line 1266 "src/p.y"
    {
                        createservice(Service_Fifo, (yyvsp[(2) - (4)].string), (yyvsp[(4) - (4)].string), check_fifo);
                  }
    break;

  case 354:

/* Line 1455 of yacc.c  */
#line 1271 "src/p.y"
    {
                        command_t c = command; // Current command
                        check_exec(c->arg[0]);
                        createservice(Service_Program, (yyvsp[(2) - (5)].string), NULL, check_program);
                        current->program->timeout = (yyvsp[(5) - (5)].number);
                        current->program->lastOutput = StringBuffer_create(64);
                        current->program->inprogressOutput = StringBuffer_create(64);
                 }
    break;

  case 355:

/* Line 1455 of yacc.c  */
#line 1279 "src/p.y"
    {
                        command_t c = command; // Current command
                        check_exec(c->arg[0]);
                        createservice(Service_Program, (yyvsp[(2) - (6)].string), NULL, check_program);
                        current->program->timeout = (yyvsp[(6) - (6)].number);
                        current->program->lastOutput = StringBuffer_create(64);
                        current->program->inprogressOutput = StringBuffer_create(64);
                 }
    break;

  case 356:

/* Line 1455 of yacc.c  */
#line 1289 "src/p.y"
    {
                        addcommand(START, (yyvsp[(3) - (3)].number));
                  }
    break;

  case 357:

/* Line 1455 of yacc.c  */
#line 1292 "src/p.y"
    {
                        addcommand(START, (yyvsp[(4) - (4)].number));
                  }
    break;

  case 358:

/* Line 1455 of yacc.c  */
#line 1297 "src/p.y"
    {
                        addcommand(STOP, (yyvsp[(3) - (3)].number));
                  }
    break;

  case 359:

/* Line 1455 of yacc.c  */
#line 1300 "src/p.y"
    {
                        addcommand(STOP, (yyvsp[(4) - (4)].number));
                  }
    break;

  case 360:

/* Line 1455 of yacc.c  */
#line 1306 "src/p.y"
    {
                        addcommand(RESTART, (yyvsp[(3) - (3)].number));
                  }
    break;

  case 361:

/* Line 1455 of yacc.c  */
#line 1309 "src/p.y"
    {
                        addcommand(RESTART, (yyvsp[(4) - (4)].number));
                  }
    break;

  case 366:

/* Line 1455 of yacc.c  */
#line 1322 "src/p.y"
    {
                        addargument((yyvsp[(1) - (1)].string));
                  }
    break;

  case 367:

/* Line 1455 of yacc.c  */
#line 1325 "src/p.y"
    {
                        addargument((yyvsp[(1) - (1)].string));
                  }
    break;

  case 368:

/* Line 1455 of yacc.c  */
#line 1330 "src/p.y"
    {
                        addeuid(get_uid((yyvsp[(2) - (2)].string), 0));
                        FREE((yyvsp[(2) - (2)].string));
                  }
    break;

  case 369:

/* Line 1455 of yacc.c  */
#line 1334 "src/p.y"
    {
                        addegid(get_gid((yyvsp[(2) - (2)].string), 0));
                        FREE((yyvsp[(2) - (2)].string));
                  }
    break;

  case 370:

/* Line 1455 of yacc.c  */
#line 1338 "src/p.y"
    {
                        addeuid(get_uid(NULL, (yyvsp[(2) - (2)].number)));
                  }
    break;

  case 371:

/* Line 1455 of yacc.c  */
#line 1341 "src/p.y"
    {
                        addegid(get_gid(NULL, (yyvsp[(2) - (2)].number)));
                  }
    break;

  case 372:

/* Line 1455 of yacc.c  */
#line 1346 "src/p.y"
    {
                        (yyval.string) = (yyvsp[(2) - (2)].string);
                  }
    break;

  case 373:

/* Line 1455 of yacc.c  */
#line 1349 "src/p.y"
    {
                        (yyval.string) = (yyvsp[(2) - (2)].string);
                  }
    break;

  case 374:

/* Line 1455 of yacc.c  */
#line 1354 "src/p.y"
    {
                        (yyval.string) = (yyvsp[(2) - (2)].string);
                  }
    break;

  case 375:

/* Line 1455 of yacc.c  */
#line 1359 "src/p.y"
    {
                        (yyval.string) = NULL;
                  }
    break;

  case 376:

/* Line 1455 of yacc.c  */
#line 1362 "src/p.y"
    {
                        (yyval.string) = (yyvsp[(2) - (2)].string);
                  }
    break;

  case 377:

/* Line 1455 of yacc.c  */
#line 1367 "src/p.y"
    {
                        /* This is a workaround to support content match without having to create an URL object. 'urloption' creates the Request_T object we need minus the URL object, but with enough information to perform content test.
                           TODO: Parser is in need of refactoring */
                        portset.url_request = urlrequest;
                        addeventaction(&(portset).action, (yyvsp[(8) - (9)].number), (yyvsp[(9) - (9)].number));
                        addport(&(current->portlist), &portset);
                  }
    break;

  case 391:

/* Line 1455 of yacc.c  */
#line 1393 "src/p.y"
    {
                        prepare_urlrequest((yyvsp[(4) - (9)].url));
                        addeventaction(&(portset).action, (yyvsp[(8) - (9)].number), (yyvsp[(9) - (9)].number));
                        addport(&(current->portlist), &portset);
                  }
    break;

  case 400:

/* Line 1455 of yacc.c  */
#line 1412 "src/p.y"
    {
                        addeventaction(&(portset).action, (yyvsp[(7) - (8)].number), (yyvsp[(8) - (8)].number));
                        addport(&(current->socketlist), &portset);
                  }
    break;

  case 408:

/* Line 1455 of yacc.c  */
#line 1429 "src/p.y"
    {
                        icmpset.family = Socket_Ip;
                        icmpset.type = (yyvsp[(4) - (9)].number);
                        addeventaction(&(icmpset).action, (yyvsp[(8) - (9)].number), (yyvsp[(9) - (9)].number));
                        addicmp(&icmpset);
                  }
    break;

  case 409:

/* Line 1455 of yacc.c  */
#line 1435 "src/p.y"
    {
                        icmpset.family = Socket_Ip;
                        addeventaction(&(icmpset).action, (yyvsp[(7) - (8)].number), (yyvsp[(8) - (8)].number));
                        addicmp(&icmpset);
                 }
    break;

  case 410:

/* Line 1455 of yacc.c  */
#line 1440 "src/p.y"
    {
                        icmpset.family = Socket_Ip4;
                        addeventaction(&(icmpset).action, (yyvsp[(7) - (8)].number), (yyvsp[(8) - (8)].number));
                        addicmp(&icmpset);
                 }
    break;

  case 411:

/* Line 1455 of yacc.c  */
#line 1445 "src/p.y"
    {
                        icmpset.family = Socket_Ip6;
                        addeventaction(&(icmpset).action, (yyvsp[(7) - (8)].number), (yyvsp[(8) - (8)].number));
                        addicmp(&icmpset);
                 }
    break;

  case 418:

/* Line 1455 of yacc.c  */
#line 1462 "src/p.y"
    {
                        portset.hostname = Str_dup(current->type == Service_Host ? current->path : LOCALHOST);
                  }
    break;

  case 419:

/* Line 1455 of yacc.c  */
#line 1465 "src/p.y"
    {
                        portset.hostname = (yyvsp[(2) - (2)].string);
                  }
    break;

  case 420:

/* Line 1455 of yacc.c  */
#line 1470 "src/p.y"
    {
                        portset.target.net.port = (yyvsp[(2) - (2)].number);
                  }
    break;

  case 421:

/* Line 1455 of yacc.c  */
#line 1475 "src/p.y"
    {
                        portset.family = Socket_Unix;
                        portset.target.unix.pathname = (yyvsp[(2) - (2)].string);
                  }
    break;

  case 422:

/* Line 1455 of yacc.c  */
#line 1481 "src/p.y"
    {
                        portset.family = Socket_Ip4;
                  }
    break;

  case 423:

/* Line 1455 of yacc.c  */
#line 1484 "src/p.y"
    {
                        portset.family = Socket_Ip6;
                  }
    break;

  case 424:

/* Line 1455 of yacc.c  */
#line 1489 "src/p.y"
    {
                        portset.type = Socket_Tcp;
                  }
    break;

  case 425:

/* Line 1455 of yacc.c  */
#line 1492 "src/p.y"
    { // The typelist is kept for backward compatibility (replaced by ssloptionlist)
                        portset.type = Socket_Tcp;
                        sslset.flags = SSL_Enabled;
                  }
    break;

  case 426:

/* Line 1455 of yacc.c  */
#line 1496 "src/p.y"
    {
                        portset.type = Socket_Udp;
                  }
    break;

  case 431:

/* Line 1455 of yacc.c  */
#line 1509 "src/p.y"
    {
                        _parseOutgoingAddress((yyvsp[(2) - (2)].string), &(portset.outgoing));
                  }
    break;

  case 432:

/* Line 1455 of yacc.c  */
#line 1514 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_APACHESTATUS);
                  }
    break;

  case 433:

/* Line 1455 of yacc.c  */
#line 1517 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_DEFAULT);
                  }
    break;

  case 434:

/* Line 1455 of yacc.c  */
#line 1520 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_DNS);
                  }
    break;

  case 435:

/* Line 1455 of yacc.c  */
#line 1523 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_DWP);
                  }
    break;

  case 436:

/* Line 1455 of yacc.c  */
#line 1526 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_FAIL2BAN);
                }
    break;

  case 437:

/* Line 1455 of yacc.c  */
#line 1529 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_FTP);
                  }
    break;

  case 438:

/* Line 1455 of yacc.c  */
#line 1532 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_HTTP);
                  }
    break;

  case 439:

/* Line 1455 of yacc.c  */
#line 1535 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                        portset.type = Socket_Tcp;
                        portset.protocol = Protocol_get(Protocol_HTTP);
                 }
    break;

  case 440:

/* Line 1455 of yacc.c  */
#line 1540 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_IMAP);
                  }
    break;

  case 441:

/* Line 1455 of yacc.c  */
#line 1543 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                        portset.type = Socket_Tcp;
                        portset.protocol = Protocol_get(Protocol_IMAP);
                  }
    break;

  case 442:

/* Line 1455 of yacc.c  */
#line 1548 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_CLAMAV);
                  }
    break;

  case 443:

/* Line 1455 of yacc.c  */
#line 1551 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_LDAP2);
                  }
    break;

  case 444:

/* Line 1455 of yacc.c  */
#line 1554 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_LDAP3);
                  }
    break;

  case 445:

/* Line 1455 of yacc.c  */
#line 1557 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_MONGODB);
                  }
    break;

  case 446:

/* Line 1455 of yacc.c  */
#line 1560 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_MYSQL);
                  }
    break;

  case 447:

/* Line 1455 of yacc.c  */
#line 1563 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_SIP);
                  }
    break;

  case 448:

/* Line 1455 of yacc.c  */
#line 1566 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_NNTP);
                  }
    break;

  case 449:

/* Line 1455 of yacc.c  */
#line 1569 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_NTP3);
                        portset.type = Socket_Udp;
                  }
    break;

  case 450:

/* Line 1455 of yacc.c  */
#line 1573 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_POSTFIXPOLICY);
                  }
    break;

  case 451:

/* Line 1455 of yacc.c  */
#line 1576 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_POP);
                  }
    break;

  case 452:

/* Line 1455 of yacc.c  */
#line 1579 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                        portset.type = Socket_Tcp;
                        portset.protocol = Protocol_get(Protocol_POP);
                  }
    break;

  case 453:

/* Line 1455 of yacc.c  */
#line 1584 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_SIEVE);
                  }
    break;

  case 454:

/* Line 1455 of yacc.c  */
#line 1587 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_SMTP);
                  }
    break;

  case 455:

/* Line 1455 of yacc.c  */
#line 1590 "src/p.y"
    {
                        sslset.flags = SSL_Enabled;
                        portset.type = Socket_Tcp;
                        portset.protocol = Protocol_get(Protocol_SMTP);
                 }
    break;

  case 456:

/* Line 1455 of yacc.c  */
#line 1595 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_SPAMASSASSIN);
                  }
    break;

  case 457:

/* Line 1455 of yacc.c  */
#line 1598 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_SSH);
                  }
    break;

  case 458:

/* Line 1455 of yacc.c  */
#line 1601 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_RDATE);
                  }
    break;

  case 459:

/* Line 1455 of yacc.c  */
#line 1604 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_REDIS);
                  }
    break;

  case 460:

/* Line 1455 of yacc.c  */
#line 1607 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_RSYNC);
                  }
    break;

  case 461:

/* Line 1455 of yacc.c  */
#line 1610 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_TNS);
                  }
    break;

  case 462:

/* Line 1455 of yacc.c  */
#line 1613 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_PGSQL);
                  }
    break;

  case 463:

/* Line 1455 of yacc.c  */
#line 1616 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_LMTP);
                  }
    break;

  case 464:

/* Line 1455 of yacc.c  */
#line 1619 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_GPS);
                  }
    break;

  case 465:

/* Line 1455 of yacc.c  */
#line 1622 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_RADIUS);
                  }
    break;

  case 466:

/* Line 1455 of yacc.c  */
#line 1625 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_MEMCACHE);
                  }
    break;

  case 467:

/* Line 1455 of yacc.c  */
#line 1628 "src/p.y"
    {
                        portset.protocol = Protocol_get(Protocol_WEBSOCKET);
                  }
    break;

  case 468:

/* Line 1455 of yacc.c  */
#line 1633 "src/p.y"
    {
                        if (portset.protocol->check == check_default || portset.protocol->check == check_generic) {
                                portset.protocol = Protocol_get(Protocol_GENERIC);
                                addgeneric(&portset, (yyvsp[(2) - (2)].string), NULL);
                        } else {
                                yyerror("The SEND statement is not allowed in the %s protocol context", portset.protocol->name);
                        }
                  }
    break;

  case 469:

/* Line 1455 of yacc.c  */
#line 1641 "src/p.y"
    {
                        if (portset.protocol->check == check_default || portset.protocol->check == check_generic) {
                                portset.protocol = Protocol_get(Protocol_GENERIC);
                                addgeneric(&portset, NULL, (yyvsp[(2) - (2)].string));
                        } else {
                                yyerror("The EXPECT statement is not allowed in the %s protocol context", portset.protocol->name);
                        }
                  }
    break;

  case 472:

/* Line 1455 of yacc.c  */
#line 1655 "src/p.y"
    {
                        portset.parameters.websocket.origin = (yyvsp[(2) - (2)].string);
                  }
    break;

  case 473:

/* Line 1455 of yacc.c  */
#line 1658 "src/p.y"
    {
                        portset.parameters.websocket.request = (yyvsp[(2) - (2)].string);
                  }
    break;

  case 474:

/* Line 1455 of yacc.c  */
#line 1661 "src/p.y"
    {
                        portset.parameters.websocket.host = (yyvsp[(2) - (2)].string);
                  }
    break;

  case 475:

/* Line 1455 of yacc.c  */
#line 1664 "src/p.y"
    {
                        portset.parameters.websocket.version = (yyvsp[(2) - (2)].number);
                  }
    break;

  case 478:

/* Line 1455 of yacc.c  */
#line 1673 "src/p.y"
    {
                        portset.parameters.smtp.username = (yyvsp[(1) - (1)].string);
                  }
    break;

  case 479:

/* Line 1455 of yacc.c  */
#line 1676 "src/p.y"
    {
                        portset.parameters.smtp.password = (yyvsp[(1) - (1)].string);
                  }
    break;

  case 482:

/* Line 1455 of yacc.c  */
#line 1685 "src/p.y"
    {
                        if ((yyvsp[(1) - (1)].string)) {
                                if (strlen((yyvsp[(1) - (1)].string)) > 16)
                                        yyerror2("Username too long -- Maximum MySQL username length is 16 characters");
                                else
                                        portset.parameters.mysql.username = (yyvsp[(1) - (1)].string);
                        }
                  }
    break;

  case 483:

/* Line 1455 of yacc.c  */
#line 1693 "src/p.y"
    {
                        portset.parameters.mysql.password = (yyvsp[(1) - (1)].string);
                  }
    break;

  case 484:

/* Line 1455 of yacc.c  */
#line 1698 "src/p.y"
    {
                        (yyval.string) = (yyvsp[(2) - (2)].string);
                  }
    break;

  case 485:

/* Line 1455 of yacc.c  */
#line 1701 "src/p.y"
    {
                        (yyval.string) = (yyvsp[(2) - (2)].string);
                  }
    break;

  case 486:

/* Line 1455 of yacc.c  */
#line 1706 "src/p.y"
    {
                        (yyval.number) = verifyMaxForward((yyvsp[(2) - (2)].number));
                  }
    break;

  case 489:

/* Line 1455 of yacc.c  */
#line 1715 "src/p.y"
    {
                        portset.parameters.sip.target = (yyvsp[(1) - (1)].string);
                  }
    break;

  case 490:

/* Line 1455 of yacc.c  */
#line 1718 "src/p.y"
    {
                        portset.parameters.sip.maxforward = (yyvsp[(1) - (1)].number);
                  }
    break;

  case 493:

/* Line 1455 of yacc.c  */
#line 1727 "src/p.y"
    {
                        portset.parameters.http.username = (yyvsp[(1) - (1)].string);
                  }
    break;

  case 494:

/* Line 1455 of yacc.c  */
#line 1730 "src/p.y"
    {
                        portset.parameters.http.password = (yyvsp[(1) - (1)].string);
                  }
    break;

  case 501:

/* Line 1455 of yacc.c  */
#line 1741 "src/p.y"
    {
                        if ((yyvsp[(3) - (3)].number) < 0) {
                                yyerror2("The status value must be greater or equal to 0");
                        }
                        portset.parameters.http.operator = (yyvsp[(2) - (3)].number);
                        portset.parameters.http.status = (yyvsp[(3) - (3)].number);
                        portset.parameters.http.hasStatus = true;
                  }
    break;

  case 502:

/* Line 1455 of yacc.c  */
#line 1751 "src/p.y"
    {
                        portset.parameters.http.method = Http_Get;
                  }
    break;

  case 503:

/* Line 1455 of yacc.c  */
#line 1754 "src/p.y"
    {
                        portset.parameters.http.method = Http_Head;
                  }
    break;

  case 504:

/* Line 1455 of yacc.c  */
#line 1759 "src/p.y"
    {
                        portset.parameters.http.request = Util_urlEncode((yyvsp[(2) - (2)].string), false);
                        FREE((yyvsp[(2) - (2)].string));
                  }
    break;

  case 505:

/* Line 1455 of yacc.c  */
#line 1763 "src/p.y"
    {
                        portset.parameters.http.request = Util_urlEncode((yyvsp[(2) - (2)].string), false);
                        FREE((yyvsp[(2) - (2)].string));
                  }
    break;

  case 506:

/* Line 1455 of yacc.c  */
#line 1769 "src/p.y"
    {
                        portset.parameters.http.checksum = (yyvsp[(2) - (2)].string);
                  }
    break;

  case 507:

/* Line 1455 of yacc.c  */
#line 1774 "src/p.y"
    {
                        addhttpheader(&portset, Str_cat("Host:%s", (yyvsp[(2) - (2)].string)));
                        FREE((yyvsp[(2) - (2)].string));
                  }
    break;

  case 509:

/* Line 1455 of yacc.c  */
#line 1781 "src/p.y"
    {
                        addhttpheader(&portset, (yyvsp[(2) - (2)].string));
                 }
    break;

  case 510:

/* Line 1455 of yacc.c  */
#line 1786 "src/p.y"
    {
                        (yyval.string) = (yyvsp[(2) - (2)].string);
                  }
    break;

  case 513:

/* Line 1455 of yacc.c  */
#line 1795 "src/p.y"
    {
                        portset.parameters.radius.secret = (yyvsp[(1) - (1)].string);
                  }
    break;

  case 516:

/* Line 1455 of yacc.c  */
#line 1804 "src/p.y"
    {
                        portset.parameters.apachestatus.username = (yyvsp[(1) - (1)].string);
                  }
    break;

  case 517:

/* Line 1455 of yacc.c  */
#line 1807 "src/p.y"
    {
                        portset.parameters.apachestatus.password = (yyvsp[(1) - (1)].string);
                  }
    break;

  case 518:

/* Line 1455 of yacc.c  */
#line 1810 "src/p.y"
    {
                        portset.parameters.apachestatus.path = (yyvsp[(2) - (2)].string);
                  }
    break;

  case 519:

/* Line 1455 of yacc.c  */
#line 1813 "src/p.y"
    {
                        portset.parameters.apachestatus.loglimitOP = (yyvsp[(2) - (4)].number);
                        portset.parameters.apachestatus.loglimit = (yyvsp[(3) - (4)].number);
                  }
    break;

  case 520:

/* Line 1455 of yacc.c  */
#line 1817 "src/p.y"
    {
                        portset.parameters.apachestatus.closelimitOP = (yyvsp[(2) - (4)].number);
                        portset.parameters.apachestatus.closelimit = (yyvsp[(3) - (4)].number);
                  }
    break;

  case 521:

/* Line 1455 of yacc.c  */
#line 1821 "src/p.y"
    {
                        portset.parameters.apachestatus.dnslimitOP = (yyvsp[(2) - (4)].number);
                        portset.parameters.apachestatus.dnslimit = (yyvsp[(3) - (4)].number);
                  }
    break;

  case 522:

/* Line 1455 of yacc.c  */
#line 1825 "src/p.y"
    {
                        portset.parameters.apachestatus.keepalivelimitOP = (yyvsp[(2) - (4)].number);
                        portset.parameters.apachestatus.keepalivelimit = (yyvsp[(3) - (4)].number);
                  }
    break;

  case 523:

/* Line 1455 of yacc.c  */
#line 1829 "src/p.y"
    {
                        portset.parameters.apachestatus.replylimitOP = (yyvsp[(2) - (4)].number);
                        portset.parameters.apachestatus.replylimit = (yyvsp[(3) - (4)].number);
                  }
    break;

  case 524:

/* Line 1455 of yacc.c  */
#line 1833 "src/p.y"
    {
                        portset.parameters.apachestatus.requestlimitOP = (yyvsp[(2) - (4)].number);
                        portset.parameters.apachestatus.requestlimit = (yyvsp[(3) - (4)].number);
                  }
    break;

  case 525:

/* Line 1455 of yacc.c  */
#line 1837 "src/p.y"
    {
                        portset.parameters.apachestatus.startlimitOP = (yyvsp[(2) - (4)].number);
                        portset.parameters.apachestatus.startlimit = (yyvsp[(3) - (4)].number);
                  }
    break;

  case 526:

/* Line 1455 of yacc.c  */
#line 1841 "src/p.y"
    {
                        portset.parameters.apachestatus.waitlimitOP = (yyvsp[(2) - (4)].number);
                        portset.parameters.apachestatus.waitlimit = (yyvsp[(3) - (4)].number);
                  }
    break;

  case 527:

/* Line 1455 of yacc.c  */
#line 1845 "src/p.y"
    {
                        portset.parameters.apachestatus.gracefullimitOP = (yyvsp[(2) - (4)].number);
                        portset.parameters.apachestatus.gracefullimit = (yyvsp[(3) - (4)].number);
                  }
    break;

  case 528:

/* Line 1455 of yacc.c  */
#line 1849 "src/p.y"
    {
                        portset.parameters.apachestatus.cleanuplimitOP = (yyvsp[(2) - (4)].number);
                        portset.parameters.apachestatus.cleanuplimit = (yyvsp[(3) - (4)].number);
                  }
    break;

  case 529:

/* Line 1455 of yacc.c  */
#line 1855 "src/p.y"
    {
                        addeventaction(&(nonexistset).action, (yyvsp[(6) - (7)].number), (yyvsp[(7) - (7)].number));
                        addnonexist(&nonexistset);
                  }
    break;

  case 530:

/* Line 1455 of yacc.c  */
#line 1859 "src/p.y"
    {
                        addeventaction(&(existset).action, (yyvsp[(5) - (6)].number), (yyvsp[(6) - (6)].number));
                        addexist(&existset);
                  }
    break;

  case 531:

/* Line 1455 of yacc.c  */
#line 1866 "src/p.y"
    {
                        addeventaction(&(pidset).action, (yyvsp[(6) - (6)].number), Action_Ignored);
                        addpid(&pidset);
                  }
    break;

  case 532:

/* Line 1455 of yacc.c  */
#line 1872 "src/p.y"
    {
                        addeventaction(&(ppidset).action, (yyvsp[(6) - (6)].number), Action_Ignored);
                        addppid(&ppidset);
                  }
    break;

  case 533:

/* Line 1455 of yacc.c  */
#line 1878 "src/p.y"
    {
                        uptimeset.operator = (yyvsp[(3) - (9)].number);
                        uptimeset.uptime = ((unsigned long long)(yyvsp[(4) - (9)].number) * (yyvsp[(5) - (9)].number));
                        addeventaction(&(uptimeset).action, (yyvsp[(8) - (9)].number), (yyvsp[(9) - (9)].number));
                        adduptime(&uptimeset);
                  }
    break;

  case 534:

/* Line 1455 of yacc.c  */
#line 1885 "src/p.y"
    {
                        icmpset.count = (yyvsp[(2) - (2)].number);
                 }
    break;

  case 535:

/* Line 1455 of yacc.c  */
#line 1890 "src/p.y"
    {
                        icmpset.size = (yyvsp[(2) - (2)].number);
                        if (icmpset.size < 8) {
                                yyerror2("The minimum ping size is 8 bytes");
                        } else if (icmpset.size > 1492) {
                                yyerror2("The maximum ping size is 1492 bytes");
                        }
                 }
    break;

  case 536:

/* Line 1455 of yacc.c  */
#line 1900 "src/p.y"
    {
                        icmpset.timeout = (yyvsp[(2) - (3)].number) * 1000; // timeout is in milliseconds internally
                    }
    break;

  case 537:

/* Line 1455 of yacc.c  */
#line 1905 "src/p.y"
    {
                        _parseOutgoingAddress((yyvsp[(2) - (2)].string), &(icmpset.outgoing));
                  }
    break;

  case 538:

/* Line 1455 of yacc.c  */
#line 1910 "src/p.y"
    {
                        (yyval.number) = Run.limits.stopTimeout;
                  }
    break;

  case 539:

/* Line 1455 of yacc.c  */
#line 1913 "src/p.y"
    {
                        (yyval.number) = (yyvsp[(2) - (3)].number) * 1000; // milliseconds internally
                  }
    break;

  case 540:

/* Line 1455 of yacc.c  */
#line 1918 "src/p.y"
    {
                        (yyval.number) = Run.limits.startTimeout;
                  }
    break;

  case 541:

/* Line 1455 of yacc.c  */
#line 1921 "src/p.y"
    {
                        (yyval.number) = (yyvsp[(2) - (3)].number) * 1000; // milliseconds internally
                  }
    break;

  case 542:

/* Line 1455 of yacc.c  */
#line 1926 "src/p.y"
    {
                        (yyval.number) = Run.limits.restartTimeout;
                  }
    break;

  case 543:

/* Line 1455 of yacc.c  */
#line 1929 "src/p.y"
    {
                        (yyval.number) = (yyvsp[(2) - (3)].number) * 1000; // milliseconds internally
                  }
    break;

  case 544:

/* Line 1455 of yacc.c  */
#line 1934 "src/p.y"
    {
                        (yyval.number) = Run.limits.programTimeout;
                  }
    break;

  case 545:

/* Line 1455 of yacc.c  */
#line 1937 "src/p.y"
    {
                        (yyval.number) = (yyvsp[(2) - (3)].number) * 1000; // milliseconds internally
                  }
    break;

  case 546:

/* Line 1455 of yacc.c  */
#line 1942 "src/p.y"
    {
                        (yyval.number) = Run.limits.networkTimeout;
                  }
    break;

  case 547:

/* Line 1455 of yacc.c  */
#line 1945 "src/p.y"
    {
                        (yyval.number) = (yyvsp[(2) - (3)].number) * 1000; // net timeout is in milliseconds internally
                  }
    break;

  case 548:

/* Line 1455 of yacc.c  */
#line 1950 "src/p.y"
    {
                        portset.timeout = (yyvsp[(2) - (3)].number) * 1000; // timeout is in milliseconds internally
                    }
    break;

  case 549:

/* Line 1455 of yacc.c  */
#line 1955 "src/p.y"
    {
                        portset.retry = (yyvsp[(2) - (2)].number);
                  }
    break;

  case 550:

/* Line 1455 of yacc.c  */
#line 1960 "src/p.y"
    {
                        actionrateset.count = (yyvsp[(2) - (7)].number);
                        actionrateset.cycle = (yyvsp[(4) - (7)].number);
                        addeventaction(&(actionrateset).action, (yyvsp[(7) - (7)].number), Action_Alert);
                        addactionrate(&actionrateset);
                  }
    break;

  case 551:

/* Line 1455 of yacc.c  */
#line 1966 "src/p.y"
    {
                        actionrateset.count = (yyvsp[(2) - (7)].number);
                        actionrateset.cycle = (yyvsp[(4) - (7)].number);
                        addeventaction(&(actionrateset).action, Action_Unmonitor, Action_Alert);
                        addactionrate(&actionrateset);
                  }
    break;

  case 552:

/* Line 1455 of yacc.c  */
#line 1974 "src/p.y"
    {
                        seturlrequest((yyvsp[(2) - (3)].number), (yyvsp[(3) - (3)].string));
                        FREE((yyvsp[(3) - (3)].string));
                  }
    break;

  case 553:

/* Line 1455 of yacc.c  */
#line 1980 "src/p.y"
    { (yyval.number) = Operator_Equal; }
    break;

  case 554:

/* Line 1455 of yacc.c  */
#line 1981 "src/p.y"
    { (yyval.number) = Operator_NotEqual; }
    break;

  case 555:

/* Line 1455 of yacc.c  */
#line 1984 "src/p.y"
    {
                        mailset.events = Event_All;
                        addmail((yyvsp[(1) - (3)].string), &mailset, &current->maillist);
                  }
    break;

  case 556:

/* Line 1455 of yacc.c  */
#line 1988 "src/p.y"
    {
                        addmail((yyvsp[(1) - (6)].string), &mailset, &current->maillist);
                  }
    break;

  case 557:

/* Line 1455 of yacc.c  */
#line 1991 "src/p.y"
    {
                        mailset.events = ~mailset.events;
                        addmail((yyvsp[(1) - (7)].string), &mailset, &current->maillist);
                  }
    break;

  case 558:

/* Line 1455 of yacc.c  */
#line 1995 "src/p.y"
    {
                        addmail((yyvsp[(1) - (1)].string), &mailset, &current->maillist);
                  }
    break;

  case 559:

/* Line 1455 of yacc.c  */
#line 2000 "src/p.y"
    { (yyval.string) = (yyvsp[(2) - (2)].string); }
    break;

  case 560:

/* Line 1455 of yacc.c  */
#line 2003 "src/p.y"
    { (yyval.string) = (yyvsp[(2) - (2)].string); }
    break;

  case 563:

/* Line 1455 of yacc.c  */
#line 2010 "src/p.y"
    { mailset.events |= Event_Action; }
    break;

  case 564:

/* Line 1455 of yacc.c  */
#line 2011 "src/p.y"
    { mailset.events |= Event_ByteIn; }
    break;

  case 565:

/* Line 1455 of yacc.c  */
#line 2012 "src/p.y"
    { mailset.events |= Event_ByteOut; }
    break;

  case 566:

/* Line 1455 of yacc.c  */
#line 2013 "src/p.y"
    { mailset.events |= Event_Checksum; }
    break;

  case 567:

/* Line 1455 of yacc.c  */
#line 2014 "src/p.y"
    { mailset.events |= Event_Connection; }
    break;

  case 568:

/* Line 1455 of yacc.c  */
#line 2015 "src/p.y"
    { mailset.events |= Event_Content; }
    break;

  case 569:

/* Line 1455 of yacc.c  */
#line 2016 "src/p.y"
    { mailset.events |= Event_Data; }
    break;

  case 570:

/* Line 1455 of yacc.c  */
#line 2017 "src/p.y"
    { mailset.events |= Event_Exec; }
    break;

  case 571:

/* Line 1455 of yacc.c  */
#line 2018 "src/p.y"
    { mailset.events |= Event_Exist; }
    break;

  case 572:

/* Line 1455 of yacc.c  */
#line 2019 "src/p.y"
    { mailset.events |= Event_FsFlag; }
    break;

  case 573:

/* Line 1455 of yacc.c  */
#line 2020 "src/p.y"
    { mailset.events |= Event_Gid; }
    break;

  case 574:

/* Line 1455 of yacc.c  */
#line 2021 "src/p.y"
    { mailset.events |= Event_Icmp; }
    break;

  case 575:

/* Line 1455 of yacc.c  */
#line 2022 "src/p.y"
    { mailset.events |= Event_Instance; }
    break;

  case 576:

/* Line 1455 of yacc.c  */
#line 2023 "src/p.y"
    { mailset.events |= Event_Invalid; }
    break;

  case 577:

/* Line 1455 of yacc.c  */
#line 2024 "src/p.y"
    { mailset.events |= Event_Link; }
    break;

  case 578:

/* Line 1455 of yacc.c  */
#line 2025 "src/p.y"
    { mailset.events |= Event_NonExist; }
    break;

  case 579:

/* Line 1455 of yacc.c  */
#line 2026 "src/p.y"
    { mailset.events |= Event_PacketIn; }
    break;

  case 580:

/* Line 1455 of yacc.c  */
#line 2027 "src/p.y"
    { mailset.events |= Event_PacketOut; }
    break;

  case 581:

/* Line 1455 of yacc.c  */
#line 2028 "src/p.y"
    { mailset.events |= Event_Permission; }
    break;

  case 582:

/* Line 1455 of yacc.c  */
#line 2029 "src/p.y"
    { mailset.events |= Event_Pid; }
    break;

  case 583:

/* Line 1455 of yacc.c  */
#line 2030 "src/p.y"
    { mailset.events |= Event_PPid; }
    break;

  case 584:

/* Line 1455 of yacc.c  */
#line 2031 "src/p.y"
    { mailset.events |= Event_Resource; }
    break;

  case 585:

/* Line 1455 of yacc.c  */
#line 2032 "src/p.y"
    { mailset.events |= Event_Saturation; }
    break;

  case 586:

/* Line 1455 of yacc.c  */
#line 2033 "src/p.y"
    { mailset.events |= Event_Size; }
    break;

  case 587:

/* Line 1455 of yacc.c  */
#line 2034 "src/p.y"
    { mailset.events |= Event_Speed; }
    break;

  case 588:

/* Line 1455 of yacc.c  */
#line 2035 "src/p.y"
    { mailset.events |= Event_Status; }
    break;

  case 589:

/* Line 1455 of yacc.c  */
#line 2036 "src/p.y"
    { mailset.events |= Event_Timeout; }
    break;

  case 590:

/* Line 1455 of yacc.c  */
#line 2037 "src/p.y"
    { mailset.events |= Event_Timestamp; }
    break;

  case 591:

/* Line 1455 of yacc.c  */
#line 2038 "src/p.y"
    { mailset.events |= Event_Uid; }
    break;

  case 592:

/* Line 1455 of yacc.c  */
#line 2039 "src/p.y"
    { mailset.events |= Event_Uptime; }
    break;

  case 597:

/* Line 1455 of yacc.c  */
#line 2050 "src/p.y"
    { mailset.from = (yyvsp[(1) - (2)].address); }
    break;

  case 598:

/* Line 1455 of yacc.c  */
#line 2051 "src/p.y"
    { mailset.replyto = (yyvsp[(1) - (2)].address); }
    break;

  case 599:

/* Line 1455 of yacc.c  */
#line 2052 "src/p.y"
    { mailset.subject = (yyvsp[(1) - (1)].string); }
    break;

  case 600:

/* Line 1455 of yacc.c  */
#line 2053 "src/p.y"
    { mailset.message = (yyvsp[(1) - (1)].string); }
    break;

  case 601:

/* Line 1455 of yacc.c  */
#line 2056 "src/p.y"
    {
                        current->every.type = Every_SkipCycles;
                        current->every.spec.cycle.counter = current->every.spec.cycle.number = (yyvsp[(2) - (3)].number);
                 }
    break;

  case 602:

/* Line 1455 of yacc.c  */
#line 2060 "src/p.y"
    {
                        current->every.type = Every_Cron;
                        current->every.spec.cron = (yyvsp[(2) - (2)].string);
                 }
    break;

  case 603:

/* Line 1455 of yacc.c  */
#line 2064 "src/p.y"
    {
                        current->every.type = Every_NotInCron;
                        current->every.spec.cron = (yyvsp[(2) - (2)].string);
                 }
    break;

  case 604:

/* Line 1455 of yacc.c  */
#line 2070 "src/p.y"
    {
                        current->mode = Monitor_Active;
                  }
    break;

  case 605:

/* Line 1455 of yacc.c  */
#line 2073 "src/p.y"
    {
                        current->mode = Monitor_Passive;
                  }
    break;

  case 606:

/* Line 1455 of yacc.c  */
#line 2076 "src/p.y"
    {
                        // Deprecated since monit 5.18
                        current->onreboot = Onreboot_Laststate;
                  }
    break;

  case 607:

/* Line 1455 of yacc.c  */
#line 2082 "src/p.y"
    {
                        current->onreboot = Onreboot_Start;
                  }
    break;

  case 608:

/* Line 1455 of yacc.c  */
#line 2085 "src/p.y"
    {
                        current->onreboot = Onreboot_Nostart;
                        current->monitor = Monitor_Not;
                  }
    break;

  case 609:

/* Line 1455 of yacc.c  */
#line 2089 "src/p.y"
    {
                        current->onreboot = Onreboot_Laststate;
                  }
    break;

  case 610:

/* Line 1455 of yacc.c  */
#line 2094 "src/p.y"
    {
                        addservicegroup((yyvsp[(2) - (2)].string));
                        FREE((yyvsp[(2) - (2)].string));
                  }
    break;

  case 614:

/* Line 1455 of yacc.c  */
#line 2108 "src/p.y"
    { adddependant((yyvsp[(1) - (1)].string)); }
    break;

  case 615:

/* Line 1455 of yacc.c  */
#line 2111 "src/p.y"
    {
                        statusset.initialized = true;
                        statusset.operator = (yyvsp[(3) - (8)].number);
                        statusset.return_value = (yyvsp[(4) - (8)].number);
                        addeventaction(&(statusset).action, (yyvsp[(7) - (8)].number), (yyvsp[(8) - (8)].number));
                        addstatus(&statusset);
                   }
    break;

  case 616:

/* Line 1455 of yacc.c  */
#line 2118 "src/p.y"
    {
                        statusset.initialized = false;
                        statusset.operator = Operator_Changed;
                        statusset.return_value = 0;
                        addeventaction(&(statusset).action, (yyvsp[(6) - (6)].number), Action_Ignored);
                        addstatus(&statusset);
                   }
    break;

  case 617:

/* Line 1455 of yacc.c  */
#line 2127 "src/p.y"
    {
                        addeventaction(&(resourceset).action, (yyvsp[(5) - (6)].number), (yyvsp[(6) - (6)].number));
                        addresource(&resourceset);
                   }
    break;

  case 627:

/* Line 1455 of yacc.c  */
#line 2146 "src/p.y"
    {
                        addeventaction(&(resourceset).action, (yyvsp[(5) - (6)].number), (yyvsp[(6) - (6)].number));
                        addresource(&resourceset);
                   }
    break;

  case 634:

/* Line 1455 of yacc.c  */
#line 2162 "src/p.y"
    {
                        resourceset.resource_id = Resource_CpuPercent;
                        resourceset.operator = (yyvsp[(2) - (4)].number);
                        resourceset.limit = (yyvsp[(3) - (4)].real);
                  }
    break;

  case 635:

/* Line 1455 of yacc.c  */
#line 2167 "src/p.y"
    {
                        resourceset.resource_id = Resource_CpuPercentTotal;
                        resourceset.operator = (yyvsp[(2) - (4)].number);
                        resourceset.limit = (yyvsp[(3) - (4)].real);
                  }
    break;

  case 636:

/* Line 1455 of yacc.c  */
#line 2174 "src/p.y"
    {
                        resourceset.resource_id = (yyvsp[(1) - (4)].number);
                        resourceset.operator = (yyvsp[(2) - (4)].number);
                        resourceset.limit = (yyvsp[(3) - (4)].real);
                  }
    break;

  case 637:

/* Line 1455 of yacc.c  */
#line 2181 "src/p.y"
    { (yyval.number) = Resource_CpuUser; }
    break;

  case 638:

/* Line 1455 of yacc.c  */
#line 2182 "src/p.y"
    { (yyval.number) = Resource_CpuSystem; }
    break;

  case 639:

/* Line 1455 of yacc.c  */
#line 2183 "src/p.y"
    { (yyval.number) = Resource_CpuWait; }
    break;

  case 640:

/* Line 1455 of yacc.c  */
#line 2184 "src/p.y"
    { (yyval.number) = Resource_CpuPercent; }
    break;

  case 641:

/* Line 1455 of yacc.c  */
#line 2187 "src/p.y"
    {
                        resourceset.resource_id = Resource_MemoryKbyte;
                        resourceset.operator = (yyvsp[(2) - (4)].number);
                        resourceset.limit = (yyvsp[(3) - (4)].real) * (yyvsp[(4) - (4)].number);
                  }
    break;

  case 642:

/* Line 1455 of yacc.c  */
#line 2192 "src/p.y"
    {
                        resourceset.resource_id = Resource_MemoryPercent;
                        resourceset.operator = (yyvsp[(2) - (4)].number);
                        resourceset.limit = (yyvsp[(3) - (4)].real);
                  }
    break;

  case 643:

/* Line 1455 of yacc.c  */
#line 2199 "src/p.y"
    {
                        resourceset.resource_id = Resource_MemoryKbyte;
                        resourceset.operator = (yyvsp[(2) - (4)].number);
                        resourceset.limit = (yyvsp[(3) - (4)].real) * (yyvsp[(4) - (4)].number);
                  }
    break;

  case 644:

/* Line 1455 of yacc.c  */
#line 2204 "src/p.y"
    {
                        resourceset.resource_id = Resource_MemoryPercent;
                        resourceset.operator = (yyvsp[(2) - (4)].number);
                        resourceset.limit = (yyvsp[(3) - (4)].real);
                  }
    break;

  case 645:

/* Line 1455 of yacc.c  */
#line 2209 "src/p.y"
    {
                        resourceset.resource_id = Resource_MemoryKbyteTotal;
                        resourceset.operator = (yyvsp[(2) - (4)].number);
                        resourceset.limit = (yyvsp[(3) - (4)].real) * (yyvsp[(4) - (4)].number);
                  }
    break;

  case 646:

/* Line 1455 of yacc.c  */
#line 2214 "src/p.y"
    {
                        resourceset.resource_id = Resource_MemoryPercentTotal;
                        resourceset.operator = (yyvsp[(2) - (4)].number);
                        resourceset.limit = (yyvsp[(3) - (4)].real);
                  }
    break;

  case 647:

/* Line 1455 of yacc.c  */
#line 2221 "src/p.y"
    {
                        resourceset.resource_id = Resource_SwapKbyte;
                        resourceset.operator = (yyvsp[(2) - (4)].number);
                        resourceset.limit = (yyvsp[(3) - (4)].real) * (yyvsp[(4) - (4)].number);
                  }
    break;

  case 648:

/* Line 1455 of yacc.c  */
#line 2226 "src/p.y"
    {
                        resourceset.resource_id = Resource_SwapPercent;
                        resourceset.operator = (yyvsp[(2) - (4)].number);
                        resourceset.limit = (yyvsp[(3) - (4)].real);
                  }
    break;

  case 649:

/* Line 1455 of yacc.c  */
#line 2233 "src/p.y"
    {
                        resourceset.resource_id = Resource_Threads;
                        resourceset.operator = (yyvsp[(2) - (3)].number);
                        resourceset.limit = (yyvsp[(3) - (3)].number);
                  }
    break;

  case 650:

/* Line 1455 of yacc.c  */
#line 2240 "src/p.y"
    {
                        resourceset.resource_id = Resource_Children;
                        resourceset.operator = (yyvsp[(2) - (3)].number);
                        resourceset.limit = (yyvsp[(3) - (3)].number);
                  }
    break;

  case 651:

/* Line 1455 of yacc.c  */
#line 2247 "src/p.y"
    {
                        resourceset.resource_id = (yyvsp[(1) - (3)].number);
                        resourceset.operator = (yyvsp[(2) - (3)].number);
                        resourceset.limit = (yyvsp[(3) - (3)].real);
                  }
    break;

  case 652:

/* Line 1455 of yacc.c  */
#line 2254 "src/p.y"
    { (yyval.number) = Resource_LoadAverage1m; }
    break;

  case 653:

/* Line 1455 of yacc.c  */
#line 2255 "src/p.y"
    { (yyval.number) = Resource_LoadAverage5m; }
    break;

  case 654:

/* Line 1455 of yacc.c  */
#line 2256 "src/p.y"
    { (yyval.number) = Resource_LoadAverage15m; }
    break;

  case 655:

/* Line 1455 of yacc.c  */
#line 2259 "src/p.y"
    {
                        resourceset.resource_id = Resource_ReadBytes;
                        resourceset.operator = (yyvsp[(3) - (6)].number);
                        resourceset.limit = (yyvsp[(4) - (6)].real) * (yyvsp[(5) - (6)].number);
                  }
    break;

  case 656:

/* Line 1455 of yacc.c  */
#line 2264 "src/p.y"
    {
                        resourceset.resource_id = Resource_ReadOperations;
                        resourceset.operator = (yyvsp[(3) - (5)].number);
                        resourceset.limit = (yyvsp[(4) - (5)].number);
                  }
    break;

  case 657:

/* Line 1455 of yacc.c  */
#line 2271 "src/p.y"
    {
                        resourceset.resource_id = Resource_WriteBytes;
                        resourceset.operator = (yyvsp[(3) - (6)].number);
                        resourceset.limit = (yyvsp[(4) - (6)].real) * (yyvsp[(5) - (6)].number);
                  }
    break;

  case 658:

/* Line 1455 of yacc.c  */
#line 2276 "src/p.y"
    {
                        resourceset.resource_id = Resource_WriteOperations;
                        resourceset.operator = (yyvsp[(3) - (5)].number);
                        resourceset.limit = (yyvsp[(4) - (5)].number);
                  }
    break;

  case 659:

/* Line 1455 of yacc.c  */
#line 2283 "src/p.y"
    { (yyval.real) = (yyvsp[(1) - (1)].real); }
    break;

  case 660:

/* Line 1455 of yacc.c  */
#line 2284 "src/p.y"
    { (yyval.real) = (float) (yyvsp[(1) - (1)].number); }
    break;

  case 661:

/* Line 1455 of yacc.c  */
#line 2287 "src/p.y"
    { (yyval.number) = Timestamp_Default; }
    break;

  case 662:

/* Line 1455 of yacc.c  */
#line 2288 "src/p.y"
    { (yyval.number) = Timestamp_Access; }
    break;

  case 663:

/* Line 1455 of yacc.c  */
#line 2289 "src/p.y"
    { (yyval.number) = Timestamp_Change; }
    break;

  case 664:

/* Line 1455 of yacc.c  */
#line 2290 "src/p.y"
    { (yyval.number) = Timestamp_Modification; }
    break;

  case 665:

/* Line 1455 of yacc.c  */
#line 2293 "src/p.y"
    {
                        timestampset.type = (yyvsp[(2) - (9)].number);
                        timestampset.operator = (yyvsp[(3) - (9)].number);
                        timestampset.time = ((yyvsp[(4) - (9)].number) * (yyvsp[(5) - (9)].number));
                        addeventaction(&(timestampset).action, (yyvsp[(8) - (9)].number), (yyvsp[(9) - (9)].number));
                        addtimestamp(&timestampset);
                  }
    break;

  case 666:

/* Line 1455 of yacc.c  */
#line 2300 "src/p.y"
    {
                        timestampset.type = (yyvsp[(3) - (6)].number);
                        timestampset.test_changes = true;
                        addeventaction(&(timestampset).action, (yyvsp[(6) - (6)].number), Action_Ignored);
                        addtimestamp(&timestampset);
                  }
    break;

  case 667:

/* Line 1455 of yacc.c  */
#line 2308 "src/p.y"
    { (yyval.number) = Operator_Equal; }
    break;

  case 668:

/* Line 1455 of yacc.c  */
#line 2309 "src/p.y"
    { (yyval.number) = Operator_Greater; }
    break;

  case 669:

/* Line 1455 of yacc.c  */
#line 2310 "src/p.y"
    { (yyval.number) = Operator_GreaterOrEqual; }
    break;

  case 670:

/* Line 1455 of yacc.c  */
#line 2311 "src/p.y"
    { (yyval.number) = Operator_Less; }
    break;

  case 671:

/* Line 1455 of yacc.c  */
#line 2312 "src/p.y"
    { (yyval.number) = Operator_LessOrEqual; }
    break;

  case 672:

/* Line 1455 of yacc.c  */
#line 2313 "src/p.y"
    { (yyval.number) = Operator_Equal; }
    break;

  case 673:

/* Line 1455 of yacc.c  */
#line 2314 "src/p.y"
    { (yyval.number) = Operator_NotEqual; }
    break;

  case 674:

/* Line 1455 of yacc.c  */
#line 2315 "src/p.y"
    { (yyval.number) = Operator_Changed; }
    break;

  case 675:

/* Line 1455 of yacc.c  */
#line 2318 "src/p.y"
    { (yyval.number) = Time_Second; }
    break;

  case 676:

/* Line 1455 of yacc.c  */
#line 2319 "src/p.y"
    { (yyval.number) = Time_Second; }
    break;

  case 677:

/* Line 1455 of yacc.c  */
#line 2320 "src/p.y"
    { (yyval.number) = Time_Minute; }
    break;

  case 678:

/* Line 1455 of yacc.c  */
#line 2321 "src/p.y"
    { (yyval.number) = Time_Hour; }
    break;

  case 679:

/* Line 1455 of yacc.c  */
#line 2322 "src/p.y"
    { (yyval.number) = Time_Day; }
    break;

  case 680:

/* Line 1455 of yacc.c  */
#line 2323 "src/p.y"
    { (yyval.number) = Time_Month; }
    break;

  case 681:

/* Line 1455 of yacc.c  */
#line 2326 "src/p.y"
    { (yyval.number) = Time_Minute; }
    break;

  case 682:

/* Line 1455 of yacc.c  */
#line 2327 "src/p.y"
    { (yyval.number) = Time_Hour; }
    break;

  case 683:

/* Line 1455 of yacc.c  */
#line 2328 "src/p.y"
    { (yyval.number) = Time_Day; }
    break;

  case 684:

/* Line 1455 of yacc.c  */
#line 2330 "src/p.y"
    { (yyval.number) = Time_Second; }
    break;

  case 685:

/* Line 1455 of yacc.c  */
#line 2331 "src/p.y"
    { (yyval.number) = Time_Second; }
    break;

  case 686:

/* Line 1455 of yacc.c  */
#line 2333 "src/p.y"
    {
                        repeat = 0;
                  }
    break;

  case 687:

/* Line 1455 of yacc.c  */
#line 2336 "src/p.y"
    {
                        repeat = 1;
                  }
    break;

  case 688:

/* Line 1455 of yacc.c  */
#line 2339 "src/p.y"
    {
                        if ((yyvsp[(3) - (4)].number) < 0) {
                                yyerror2("The number of repeat cycles must be greater or equal to 0");
                        }
                        repeat = (yyvsp[(3) - (4)].number);
                  }
    break;

  case 689:

/* Line 1455 of yacc.c  */
#line 2347 "src/p.y"
    {
                        (yyval.number) = Action_Alert;
                  }
    break;

  case 690:

/* Line 1455 of yacc.c  */
#line 2350 "src/p.y"
    {
                        (yyval.number) = Action_Exec;
                  }
    break;

  case 691:

/* Line 1455 of yacc.c  */
#line 2354 "src/p.y"
    {
                        (yyval.number) = Action_Exec;
                  }
    break;

  case 692:

/* Line 1455 of yacc.c  */
#line 2357 "src/p.y"
    {
                        (yyval.number) = Action_Restart;
                  }
    break;

  case 693:

/* Line 1455 of yacc.c  */
#line 2360 "src/p.y"
    {
                        (yyval.number) = Action_Start;
                  }
    break;

  case 694:

/* Line 1455 of yacc.c  */
#line 2363 "src/p.y"
    {
                        (yyval.number) = Action_Stop;
                  }
    break;

  case 695:

/* Line 1455 of yacc.c  */
#line 2366 "src/p.y"
    {
                        (yyval.number) = Action_Unmonitor;
                  }
    break;

  case 696:

/* Line 1455 of yacc.c  */
#line 2371 "src/p.y"
    {
                        (yyval.number) = (yyvsp[(1) - (1)].number);
                        if ((yyvsp[(1) - (1)].number) == Action_Exec && command) {
                                repeat1 = repeat;
                                repeat = 0;
                                command1 = command;
                                command = NULL;
                        }
                  }
    break;

  case 697:

/* Line 1455 of yacc.c  */
#line 2382 "src/p.y"
    {
                        (yyval.number) = (yyvsp[(1) - (1)].number);
                        if ((yyvsp[(1) - (1)].number) == Action_Exec && command) {
                                repeat2 = repeat;
                                repeat = 0;
                                command2 = command;
                                command = NULL;
                        }
                  }
    break;

  case 698:

/* Line 1455 of yacc.c  */
#line 2393 "src/p.y"
    {
                        if ((yyvsp[(1) - (2)].number) < 1 || (yyvsp[(1) - (2)].number) > BITMAP_MAX) {
                                yyerror2("The number of cycles must be between 1 and %d", BITMAP_MAX);
                        } else {
                                rate.count  = (yyvsp[(1) - (2)].number);
                                rate.cycles = (yyvsp[(1) - (2)].number);
                        }
                  }
    break;

  case 699:

/* Line 1455 of yacc.c  */
#line 2403 "src/p.y"
    {
                        if ((yyvsp[(2) - (3)].number) < 1 || (yyvsp[(2) - (3)].number) > BITMAP_MAX) {
                                yyerror2("The number of cycles must be between 1 and %d", BITMAP_MAX);
                        } else if ((yyvsp[(1) - (3)].number) < 1 || (yyvsp[(1) - (3)].number) > (yyvsp[(2) - (3)].number)) {
                                yyerror2("The number of events must be between 1 and less then poll cycles");
                        } else {
                                rate.count  = (yyvsp[(1) - (3)].number);
                                rate.cycles = (yyvsp[(2) - (3)].number);
                        }
                  }
    break;

  case 701:

/* Line 1455 of yacc.c  */
#line 2416 "src/p.y"
    {
                        rate1.count = rate.count;
                        rate1.cycles = rate.cycles;
                        reset_rateset(&rate);
                  }
    break;

  case 702:

/* Line 1455 of yacc.c  */
#line 2421 "src/p.y"
    {
                        rate1.count = rate.count;
                        rate1.cycles = rate.cycles;
                        reset_rateset(&rate);
                }
    break;

  case 704:

/* Line 1455 of yacc.c  */
#line 2429 "src/p.y"
    {
                        rate2.count = rate.count;
                        rate2.cycles = rate.cycles;
                        reset_rateset(&rate);
                  }
    break;

  case 705:

/* Line 1455 of yacc.c  */
#line 2434 "src/p.y"
    {
                        rate2.count = rate.count;
                        rate2.cycles = rate.cycles;
                        reset_rateset(&rate);
                }
    break;

  case 706:

/* Line 1455 of yacc.c  */
#line 2441 "src/p.y"
    {
                        (yyval.number) = Action_Alert;
                  }
    break;

  case 707:

/* Line 1455 of yacc.c  */
#line 2444 "src/p.y"
    {
                        (yyval.number) = (yyvsp[(6) - (6)].number);
                  }
    break;

  case 708:

/* Line 1455 of yacc.c  */
#line 2447 "src/p.y"
    {
                        (yyval.number) = (yyvsp[(6) - (6)].number);
                  }
    break;

  case 709:

/* Line 1455 of yacc.c  */
#line 2450 "src/p.y"
    {
                        (yyval.number) = (yyvsp[(6) - (6)].number);
                  }
    break;

  case 710:

/* Line 1455 of yacc.c  */
#line 2455 "src/p.y"
    {
                        addeventaction(&(checksumset).action, (yyvsp[(7) - (8)].number), (yyvsp[(8) - (8)].number));
                        addchecksum(&checksumset);
                  }
    break;

  case 711:

/* Line 1455 of yacc.c  */
#line 2460 "src/p.y"
    {
                        snprintf(checksumset.hash, sizeof(checksumset.hash), "%s", (yyvsp[(6) - (10)].string));
                        FREE((yyvsp[(6) - (10)].string));
                        addeventaction(&(checksumset).action, (yyvsp[(9) - (10)].number), (yyvsp[(10) - (10)].number));
                        addchecksum(&checksumset);
                  }
    break;

  case 712:

/* Line 1455 of yacc.c  */
#line 2466 "src/p.y"
    {
                        checksumset.test_changes = true;
                        addeventaction(&(checksumset).action, (yyvsp[(7) - (7)].number), Action_Ignored);
                        addchecksum(&checksumset);
                  }
    break;

  case 713:

/* Line 1455 of yacc.c  */
#line 2472 "src/p.y"
    { checksumset.type = Hash_Unknown; }
    break;

  case 714:

/* Line 1455 of yacc.c  */
#line 2473 "src/p.y"
    { checksumset.type = Hash_Md5; }
    break;

  case 715:

/* Line 1455 of yacc.c  */
#line 2474 "src/p.y"
    { checksumset.type = Hash_Sha1; }
    break;

  case 716:

/* Line 1455 of yacc.c  */
#line 2477 "src/p.y"
    {
                        filesystemset.resource = Resource_Inode;
                        filesystemset.operator = (yyvsp[(3) - (8)].number);
                        filesystemset.limit_absolute = (yyvsp[(4) - (8)].number);
                        addeventaction(&(filesystemset).action, (yyvsp[(7) - (8)].number), (yyvsp[(8) - (8)].number));
                        addfilesystem(&filesystemset);
                  }
    break;

  case 717:

/* Line 1455 of yacc.c  */
#line 2484 "src/p.y"
    {
                        filesystemset.resource = Resource_Inode;
                        filesystemset.operator = (yyvsp[(3) - (9)].number);
                        filesystemset.limit_percent = (yyvsp[(4) - (9)].real);
                        addeventaction(&(filesystemset).action, (yyvsp[(8) - (9)].number), (yyvsp[(9) - (9)].number));
                        addfilesystem(&filesystemset);
                  }
    break;

  case 718:

/* Line 1455 of yacc.c  */
#line 2491 "src/p.y"
    {
                        filesystemset.resource = Resource_InodeFree;
                        filesystemset.operator = (yyvsp[(4) - (9)].number);
                        filesystemset.limit_absolute = (yyvsp[(5) - (9)].number);
                        addeventaction(&(filesystemset).action, (yyvsp[(8) - (9)].number), (yyvsp[(9) - (9)].number));
                        addfilesystem(&filesystemset);
                  }
    break;

  case 719:

/* Line 1455 of yacc.c  */
#line 2498 "src/p.y"
    {
                        filesystemset.resource = Resource_InodeFree;
                        filesystemset.operator = (yyvsp[(4) - (10)].number);
                        filesystemset.limit_percent = (yyvsp[(5) - (10)].real);
                        addeventaction(&(filesystemset).action, (yyvsp[(9) - (10)].number), (yyvsp[(10) - (10)].number));
                        addfilesystem(&filesystemset);
                  }
    break;

  case 720:

/* Line 1455 of yacc.c  */
#line 2507 "src/p.y"
    {
                        filesystemset.resource = Resource_Space;
                        filesystemset.operator = (yyvsp[(3) - (9)].number);
                        filesystemset.limit_absolute = (yyvsp[(4) - (9)].real) * (yyvsp[(5) - (9)].number);
                        addeventaction(&(filesystemset).action, (yyvsp[(8) - (9)].number), (yyvsp[(9) - (9)].number));
                        addfilesystem(&filesystemset);
                  }
    break;

  case 721:

/* Line 1455 of yacc.c  */
#line 2514 "src/p.y"
    {
                        filesystemset.resource = Resource_Space;
                        filesystemset.operator = (yyvsp[(3) - (9)].number);
                        filesystemset.limit_percent = (yyvsp[(4) - (9)].real);
                        addeventaction(&(filesystemset).action, (yyvsp[(8) - (9)].number), (yyvsp[(9) - (9)].number));
                        addfilesystem(&filesystemset);
                  }
    break;

  case 722:

/* Line 1455 of yacc.c  */
#line 2521 "src/p.y"
    {
                        filesystemset.resource = Resource_SpaceFree;
                        filesystemset.operator = (yyvsp[(4) - (10)].number);
                        filesystemset.limit_absolute = (yyvsp[(5) - (10)].real) * (yyvsp[(6) - (10)].number);
                        addeventaction(&(filesystemset).action, (yyvsp[(9) - (10)].number), (yyvsp[(10) - (10)].number));
                        addfilesystem(&filesystemset);
                  }
    break;

  case 723:

/* Line 1455 of yacc.c  */
#line 2528 "src/p.y"
    {
                        filesystemset.resource = Resource_SpaceFree;
                        filesystemset.operator = (yyvsp[(4) - (10)].number);
                        filesystemset.limit_percent = (yyvsp[(5) - (10)].real);
                        addeventaction(&(filesystemset).action, (yyvsp[(9) - (10)].number), (yyvsp[(10) - (10)].number));
                        addfilesystem(&filesystemset);
                  }
    break;

  case 724:

/* Line 1455 of yacc.c  */
#line 2537 "src/p.y"
    {
                        filesystemset.resource = Resource_ReadBytes;
                        filesystemset.operator = (yyvsp[(3) - (10)].number);
                        filesystemset.limit_absolute = (yyvsp[(4) - (10)].real) * (yyvsp[(5) - (10)].number);
                        addeventaction(&(filesystemset).action, (yyvsp[(9) - (10)].number), (yyvsp[(10) - (10)].number));
                        addfilesystem(&filesystemset);
                  }
    break;

  case 725:

/* Line 1455 of yacc.c  */
#line 2544 "src/p.y"
    {
                        filesystemset.resource = Resource_ReadOperations;
                        filesystemset.operator = (yyvsp[(3) - (9)].number);
                        filesystemset.limit_absolute = (yyvsp[(4) - (9)].number);
                        addeventaction(&(filesystemset).action, (yyvsp[(8) - (9)].number), (yyvsp[(9) - (9)].number));
                        addfilesystem(&filesystemset);
                  }
    break;

  case 726:

/* Line 1455 of yacc.c  */
#line 2553 "src/p.y"
    {
                        filesystemset.resource = Resource_WriteBytes;
                        filesystemset.operator = (yyvsp[(3) - (10)].number);
                        filesystemset.limit_absolute = (yyvsp[(4) - (10)].real) * (yyvsp[(5) - (10)].number);
                        addeventaction(&(filesystemset).action, (yyvsp[(9) - (10)].number), (yyvsp[(10) - (10)].number));
                        addfilesystem(&filesystemset);
                  }
    break;

  case 727:

/* Line 1455 of yacc.c  */
#line 2560 "src/p.y"
    {
                        filesystemset.resource = Resource_WriteOperations;
                        filesystemset.operator = (yyvsp[(3) - (9)].number);
                        filesystemset.limit_absolute = (yyvsp[(4) - (9)].number);
                        addeventaction(&(filesystemset).action, (yyvsp[(8) - (9)].number), (yyvsp[(9) - (9)].number));
                        addfilesystem(&filesystemset);
                  }
    break;

  case 728:

/* Line 1455 of yacc.c  */
#line 2569 "src/p.y"
    {
                        filesystemset.resource = Resource_ServiceTime;
                        filesystemset.operator = (yyvsp[(3) - (9)].number);
                        filesystemset.limit_absolute = (yyvsp[(4) - (9)].number);
                        addeventaction(&(filesystemset).action, (yyvsp[(8) - (9)].number), (yyvsp[(9) - (9)].number));
                        addfilesystem(&filesystemset);
                  }
    break;

  case 729:

/* Line 1455 of yacc.c  */
#line 2576 "src/p.y"
    {
                        filesystemset.resource = Resource_ServiceTime;
                        filesystemset.operator = (yyvsp[(3) - (9)].number);
                        filesystemset.limit_absolute = (yyvsp[(4) - (9)].real) * 1000;
                        addeventaction(&(filesystemset).action, (yyvsp[(8) - (9)].number), (yyvsp[(9) - (9)].number));
                        addfilesystem(&filesystemset);
                  }
    break;

  case 730:

/* Line 1455 of yacc.c  */
#line 2585 "src/p.y"
    {
                        addeventaction(&(fsflagset).action, (yyvsp[(6) - (6)].number), Action_Ignored);
                        addfsflag(&fsflagset);
                  }
    break;

  case 731:

/* Line 1455 of yacc.c  */
#line 2591 "src/p.y"
    { (yyval.number) = Unit_Byte; }
    break;

  case 732:

/* Line 1455 of yacc.c  */
#line 2592 "src/p.y"
    { (yyval.number) = Unit_Byte; }
    break;

  case 733:

/* Line 1455 of yacc.c  */
#line 2593 "src/p.y"
    { (yyval.number) = Unit_Kilobyte; }
    break;

  case 734:

/* Line 1455 of yacc.c  */
#line 2594 "src/p.y"
    { (yyval.number) = Unit_Megabyte; }
    break;

  case 735:

/* Line 1455 of yacc.c  */
#line 2595 "src/p.y"
    { (yyval.number) = Unit_Gigabyte; }
    break;

  case 736:

/* Line 1455 of yacc.c  */
#line 2598 "src/p.y"
    {
                        permset.perm = check_perm((yyvsp[(4) - (8)].number));
                        addeventaction(&(permset).action, (yyvsp[(7) - (8)].number), (yyvsp[(8) - (8)].number));
                        addperm(&permset);
                  }
    break;

  case 737:

/* Line 1455 of yacc.c  */
#line 2603 "src/p.y"
    {
                        permset.test_changes = true;
                        addeventaction(&(permset).action, (yyvsp[(6) - (7)].number), Action_Ignored);
                        addperm(&permset);
                  }
    break;

  case 738:

/* Line 1455 of yacc.c  */
#line 2610 "src/p.y"
    {
                        matchset.not = (yyvsp[(3) - (7)].number) == Operator_Equal ? false : true;
                        matchset.ignore = false;
                        matchset.match_path = (yyvsp[(4) - (7)].string);
                        matchset.match_string = NULL;
                        addmatchpath(&matchset, (yyvsp[(7) - (7)].number));
                        FREE((yyvsp[(4) - (7)].string));
                  }
    break;

  case 739:

/* Line 1455 of yacc.c  */
#line 2618 "src/p.y"
    {
                        matchset.not = (yyvsp[(3) - (7)].number) == Operator_Equal ? false : true;
                        matchset.ignore = false;
                        matchset.match_path = NULL;
                        matchset.match_string = (yyvsp[(4) - (7)].string);
                        addmatch(&matchset, (yyvsp[(7) - (7)].number), 0);
                  }
    break;

  case 740:

/* Line 1455 of yacc.c  */
#line 2625 "src/p.y"
    {
                        matchset.not = (yyvsp[(3) - (4)].number) == Operator_Equal ? false : true;
                        matchset.ignore = true;
                        matchset.match_path = (yyvsp[(4) - (4)].string);
                        matchset.match_string = NULL;
                        addmatchpath(&matchset, Action_Ignored);
                        FREE((yyvsp[(4) - (4)].string));
                  }
    break;

  case 741:

/* Line 1455 of yacc.c  */
#line 2633 "src/p.y"
    {
                        matchset.not = (yyvsp[(3) - (4)].number) == Operator_Equal ? false : true;
                        matchset.ignore = true;
                        matchset.match_path = NULL;
                        matchset.match_string = (yyvsp[(4) - (4)].string);
                        addmatch(&matchset, Action_Ignored, 0);
                  }
    break;

  case 742:

/* Line 1455 of yacc.c  */
#line 2641 "src/p.y"
    {
                        matchset.ignore = false;
                        matchset.match_path = (yyvsp[(4) - (7)].string);
                        matchset.match_string = NULL;
                        addmatchpath(&matchset, (yyvsp[(7) - (7)].number));
                        FREE((yyvsp[(4) - (7)].string));
                  }
    break;

  case 743:

/* Line 1455 of yacc.c  */
#line 2648 "src/p.y"
    {
                        matchset.ignore = false;
                        matchset.match_path = NULL;
                        matchset.match_string = (yyvsp[(4) - (7)].string);
                        addmatch(&matchset, (yyvsp[(7) - (7)].number), 0);
                  }
    break;

  case 744:

/* Line 1455 of yacc.c  */
#line 2654 "src/p.y"
    {
                        matchset.ignore = true;
                        matchset.match_path = (yyvsp[(4) - (4)].string);
                        matchset.match_string = NULL;
                        addmatchpath(&matchset, Action_Ignored);
                        FREE((yyvsp[(4) - (4)].string));
                  }
    break;

  case 745:

/* Line 1455 of yacc.c  */
#line 2661 "src/p.y"
    {
                        matchset.ignore = true;
                        matchset.match_path = NULL;
                        matchset.match_string = (yyvsp[(4) - (4)].string);
                        addmatch(&matchset, Action_Ignored, 0);
                  }
    break;

  case 746:

/* Line 1455 of yacc.c  */
#line 2669 "src/p.y"
    {
                        matchset.not = false;
                  }
    break;

  case 747:

/* Line 1455 of yacc.c  */
#line 2672 "src/p.y"
    {
                        matchset.not = true;
                  }
    break;

  case 748:

/* Line 1455 of yacc.c  */
#line 2678 "src/p.y"
    {
                        sizeset.operator = (yyvsp[(3) - (9)].number);
                        sizeset.size = ((unsigned long long)(yyvsp[(4) - (9)].number) * (yyvsp[(5) - (9)].number));
                        addeventaction(&(sizeset).action, (yyvsp[(8) - (9)].number), (yyvsp[(9) - (9)].number));
                        addsize(&sizeset);
                  }
    break;

  case 749:

/* Line 1455 of yacc.c  */
#line 2684 "src/p.y"
    {
                        sizeset.test_changes = true;
                        addeventaction(&(sizeset).action, (yyvsp[(6) - (6)].number), Action_Ignored);
                        addsize(&sizeset);
                  }
    break;

  case 750:

/* Line 1455 of yacc.c  */
#line 2691 "src/p.y"
    {
                        uidset.uid = get_uid((yyvsp[(4) - (8)].string), 0);
                        addeventaction(&(uidset).action, (yyvsp[(7) - (8)].number), (yyvsp[(8) - (8)].number));
                        current->uid = adduid(&uidset);
                        FREE((yyvsp[(4) - (8)].string));
                  }
    break;

  case 751:

/* Line 1455 of yacc.c  */
#line 2697 "src/p.y"
    {
                    uidset.uid = get_uid(NULL, (yyvsp[(4) - (8)].number));
                    addeventaction(&(uidset).action, (yyvsp[(7) - (8)].number), (yyvsp[(8) - (8)].number));
                    current->uid = adduid(&uidset);
                  }
    break;

  case 752:

/* Line 1455 of yacc.c  */
#line 2704 "src/p.y"
    {
                        uidset.uid = get_uid((yyvsp[(4) - (8)].string), 0);
                        addeventaction(&(uidset).action, (yyvsp[(7) - (8)].number), (yyvsp[(8) - (8)].number));
                        current->euid = adduid(&uidset);
                        FREE((yyvsp[(4) - (8)].string));
                  }
    break;

  case 753:

/* Line 1455 of yacc.c  */
#line 2710 "src/p.y"
    {
                        uidset.uid = get_uid(NULL, (yyvsp[(4) - (8)].number));
                        addeventaction(&(uidset).action, (yyvsp[(7) - (8)].number), (yyvsp[(8) - (8)].number));
                        current->euid = adduid(&uidset);
                  }
    break;

  case 754:

/* Line 1455 of yacc.c  */
#line 2717 "src/p.y"
    {
                        addsecurityattribute((yyvsp[(5) - (9)].string), (yyvsp[(8) - (9)].number), (yyvsp[(9) - (9)].number));
                  }
    break;

  case 755:

/* Line 1455 of yacc.c  */
#line 2720 "src/p.y"
    {
                        addsecurityattribute((yyvsp[(5) - (9)].string), (yyvsp[(8) - (9)].number), (yyvsp[(9) - (9)].number));
                  }
    break;

  case 756:

/* Line 1455 of yacc.c  */
#line 2725 "src/p.y"
    {
                        gidset.gid = get_gid((yyvsp[(4) - (8)].string), 0);
                        addeventaction(&(gidset).action, (yyvsp[(7) - (8)].number), (yyvsp[(8) - (8)].number));
                        current->gid = addgid(&gidset);
                        FREE((yyvsp[(4) - (8)].string));
                  }
    break;

  case 757:

/* Line 1455 of yacc.c  */
#line 2731 "src/p.y"
    {
                        gidset.gid = get_gid(NULL, (yyvsp[(4) - (8)].number));
                        addeventaction(&(gidset).action, (yyvsp[(7) - (8)].number), (yyvsp[(8) - (8)].number));
                        current->gid = addgid(&gidset);
                  }
    break;

  case 758:

/* Line 1455 of yacc.c  */
#line 2738 "src/p.y"
    {
                        addeventaction(&(linkstatusset).action, (yyvsp[(6) - (7)].number), (yyvsp[(7) - (7)].number));
                        addlinkstatus(current, &linkstatusset);
                  }
    break;

  case 759:

/* Line 1455 of yacc.c  */
#line 2744 "src/p.y"
    {
                        addeventaction(&(linkspeedset).action, (yyvsp[(6) - (7)].number), (yyvsp[(7) - (7)].number));
                        addlinkspeed(current, &linkspeedset);
                  }
    break;

  case 760:

/* Line 1455 of yacc.c  */
#line 2749 "src/p.y"
    {
                        linksaturationset.operator = (yyvsp[(3) - (9)].number);
                        linksaturationset.limit = (unsigned long long)(yyvsp[(4) - (9)].number);
                        addeventaction(&(linksaturationset).action, (yyvsp[(8) - (9)].number), (yyvsp[(9) - (9)].number));
                        addlinksaturation(current, &linksaturationset);
                  }
    break;

  case 761:

/* Line 1455 of yacc.c  */
#line 2757 "src/p.y"
    {
                        bandwidthset.operator = (yyvsp[(3) - (10)].number);
                        bandwidthset.limit = ((unsigned long long)(yyvsp[(4) - (10)].number) * (yyvsp[(5) - (10)].number));
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = (yyvsp[(6) - (10)].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[(9) - (10)].number), (yyvsp[(10) - (10)].number));
                        addbandwidth(&(current->uploadbyteslist), &bandwidthset);
                  }
    break;

  case 762:

/* Line 1455 of yacc.c  */
#line 2765 "src/p.y"
    {
                        bandwidthset.operator = (yyvsp[(4) - (11)].number);
                        bandwidthset.limit = ((unsigned long long)(yyvsp[(5) - (11)].number) * (yyvsp[(6) - (11)].number));
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = (yyvsp[(7) - (11)].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[(10) - (11)].number), (yyvsp[(11) - (11)].number));
                        addbandwidth(&(current->uploadbyteslist), &bandwidthset);
                  }
    break;

  case 763:

/* Line 1455 of yacc.c  */
#line 2773 "src/p.y"
    {
                        bandwidthset.operator = (yyvsp[(4) - (12)].number);
                        bandwidthset.limit = ((unsigned long long)(yyvsp[(5) - (12)].number) * (yyvsp[(6) - (12)].number));
                        bandwidthset.rangecount = (yyvsp[(7) - (12)].number);
                        bandwidthset.range = (yyvsp[(8) - (12)].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[(11) - (12)].number), (yyvsp[(12) - (12)].number));
                        addbandwidth(&(current->uploadbyteslist), &bandwidthset);
                  }
    break;

  case 764:

/* Line 1455 of yacc.c  */
#line 2781 "src/p.y"
    {
                        bandwidthset.operator = (yyvsp[(3) - (10)].number);
                        bandwidthset.limit = (unsigned long long)(yyvsp[(4) - (10)].number);
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = (yyvsp[(6) - (10)].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[(9) - (10)].number), (yyvsp[(10) - (10)].number));
                        addbandwidth(&(current->uploadpacketslist), &bandwidthset);
                  }
    break;

  case 765:

/* Line 1455 of yacc.c  */
#line 2789 "src/p.y"
    {
                        bandwidthset.operator = (yyvsp[(4) - (11)].number);
                        bandwidthset.limit = (unsigned long long)(yyvsp[(5) - (11)].number);
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = (yyvsp[(7) - (11)].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[(10) - (11)].number), (yyvsp[(11) - (11)].number));
                        addbandwidth(&(current->uploadpacketslist), &bandwidthset);
                  }
    break;

  case 766:

/* Line 1455 of yacc.c  */
#line 2797 "src/p.y"
    {
                        bandwidthset.operator = (yyvsp[(4) - (12)].number);
                        bandwidthset.limit = (unsigned long long)(yyvsp[(5) - (12)].number);
                        bandwidthset.rangecount = (yyvsp[(7) - (12)].number);
                        bandwidthset.range = (yyvsp[(8) - (12)].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[(11) - (12)].number), (yyvsp[(12) - (12)].number));
                        addbandwidth(&(current->uploadpacketslist), &bandwidthset);
                  }
    break;

  case 767:

/* Line 1455 of yacc.c  */
#line 2807 "src/p.y"
    {
                        bandwidthset.operator = (yyvsp[(3) - (10)].number);
                        bandwidthset.limit = ((unsigned long long)(yyvsp[(4) - (10)].number) * (yyvsp[(5) - (10)].number));
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = (yyvsp[(6) - (10)].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[(9) - (10)].number), (yyvsp[(10) - (10)].number));
                        addbandwidth(&(current->downloadbyteslist), &bandwidthset);
                  }
    break;

  case 768:

/* Line 1455 of yacc.c  */
#line 2815 "src/p.y"
    {
                        bandwidthset.operator = (yyvsp[(4) - (11)].number);
                        bandwidthset.limit = ((unsigned long long)(yyvsp[(5) - (11)].number) * (yyvsp[(6) - (11)].number));
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = (yyvsp[(7) - (11)].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[(10) - (11)].number), (yyvsp[(11) - (11)].number));
                        addbandwidth(&(current->downloadbyteslist), &bandwidthset);
                  }
    break;

  case 769:

/* Line 1455 of yacc.c  */
#line 2823 "src/p.y"
    {
                        bandwidthset.operator = (yyvsp[(4) - (12)].number);
                        bandwidthset.limit = ((unsigned long long)(yyvsp[(5) - (12)].number) * (yyvsp[(6) - (12)].number));
                        bandwidthset.rangecount = (yyvsp[(7) - (12)].number);
                        bandwidthset.range = (yyvsp[(8) - (12)].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[(11) - (12)].number), (yyvsp[(12) - (12)].number));
                        addbandwidth(&(current->downloadbyteslist), &bandwidthset);
                  }
    break;

  case 770:

/* Line 1455 of yacc.c  */
#line 2831 "src/p.y"
    {
                        bandwidthset.operator = (yyvsp[(3) - (10)].number);
                        bandwidthset.limit = (unsigned long long)(yyvsp[(4) - (10)].number);
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = (yyvsp[(6) - (10)].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[(9) - (10)].number), (yyvsp[(10) - (10)].number));
                        addbandwidth(&(current->downloadpacketslist), &bandwidthset);
                  }
    break;

  case 771:

/* Line 1455 of yacc.c  */
#line 2839 "src/p.y"
    {
                        bandwidthset.operator = (yyvsp[(4) - (11)].number);
                        bandwidthset.limit = (unsigned long long)(yyvsp[(5) - (11)].number);
                        bandwidthset.rangecount = 1;
                        bandwidthset.range = (yyvsp[(7) - (11)].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[(10) - (11)].number), (yyvsp[(11) - (11)].number));
                        addbandwidth(&(current->downloadpacketslist), &bandwidthset);
                  }
    break;

  case 772:

/* Line 1455 of yacc.c  */
#line 2847 "src/p.y"
    {
                        bandwidthset.operator = (yyvsp[(4) - (12)].number);
                        bandwidthset.limit = (unsigned long long)(yyvsp[(5) - (12)].number);
                        bandwidthset.rangecount = (yyvsp[(7) - (12)].number);
                        bandwidthset.range = (yyvsp[(8) - (12)].number);
                        addeventaction(&(bandwidthset).action, (yyvsp[(11) - (12)].number), (yyvsp[(12) - (12)].number));
                        addbandwidth(&(current->downloadpacketslist), &bandwidthset);
                  }
    break;

  case 773:

/* Line 1455 of yacc.c  */
#line 2857 "src/p.y"
    { (yyval.number) = ICMP_ECHO; }
    break;

  case 774:

/* Line 1455 of yacc.c  */
#line 2860 "src/p.y"
    { mailset.reminder = 0; }
    break;

  case 775:

/* Line 1455 of yacc.c  */
#line 2861 "src/p.y"
    { mailset.reminder = (yyvsp[(2) - (2)].number); }
    break;

  case 776:

/* Line 1455 of yacc.c  */
#line 2862 "src/p.y"
    { mailset.reminder = (yyvsp[(2) - (3)].number); }
    break;



/* Line 1455 of yacc.c  */
#line 8083 "src/y.tab.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
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

  /* Do not reclaim the symbols of the rule which action triggered
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
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
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

  *++yyvsp = yylval;


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

#if !defined(yyoverflow) || YYERROR_VERBOSE
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
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
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
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}



/* Line 1675 of yacc.c  */
#line 2865 "src/p.y"



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


