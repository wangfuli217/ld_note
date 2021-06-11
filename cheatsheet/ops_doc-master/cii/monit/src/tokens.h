/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

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
#line 310 "src/p.y" /* yacc.c:1909  */

        URL_T url;
        Address_T address;
        float real;
        int   number;
        char *string;

#line 620 "src/y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SRC_Y_TAB_H_INCLUDED  */
