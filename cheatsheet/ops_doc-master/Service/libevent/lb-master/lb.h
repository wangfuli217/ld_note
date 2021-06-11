/*
 * lb.h - Constants, types and functions defined and used by 'lb'
 *
 * -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 *                          _ _
 *                         | | |__
 *                         | | '_ \
 *                         | | |_) |
 *                         |_|_.__/
 *
 * 'lb' is a Libevent-based benchmarking tool for HTTP servers
 *
 *                (C) Copyright 2009-2016
 *         Rocco Carbone <rocco /at/ tecsiel /dot/ it>
 *
 * Released under the terms of 3-clause BSD License.
 * See included LICENSE file for details.
 *
 * -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 *
 */


#if !defined(_LB_H)
#define _LB_H

#if defined(HAVE_CONFIG_H)
#include "site-lb.h"
#endif /* HAVE_CONFIG_H */

/* Operating System header file(s) */
#include <stdio.h>
#include <stdint.h>

/* Libevent public header file(s) */
#include "event2/event.h"
#include "event2/event_struct.h"
#include "event2/http.h"
#include "event2/http_struct.h"

/* Just in case */
#undef MIN
#undef MAX

/* MIN/MAX --- return minimum/maximum of two numbers */
#define MIN(a, b) ((a) < (b) ? (a) : (b))
#define MAX(a, b) ((a) > (b) ? (a) : (b))


/* In the following definitions "-" means standard output while "*" means none */
#define DEFAULT_SERVERS_FILE   "*"

/* Total number of requests to perform */
#define DEFAULT_REQUESTS          1        /* 0 means unlimited */

/* Number of concurrent requests to perform at a time */
#define DEFAULT_CONCURRENCY       1        /* 0 is illegal */

/* Max # of retries before to mark the host as definitely down */
#define DEFAULT_MAX_RETRY         3        /* 0 means none */

/* Intervals and timeouts (all are in milliseconds unless otherwise specified) */
#define DEFAULT_INITIAL_TIMEOUT   0        /* 0 means immediately          */
#define DEFAULT_REPLY_TIMEOUT     2000     /* 2 secs - 0 is illegal        */
#define DEFAULT_DURATION_TIMEOUT  0        /* 0 means no time limits       */

/* Common headers added to header in all the requests */
#define DEFAULT_USERAGENT         PACKAGE_NAME"/"PACKAGE_VERSION
#define DEFAULT_ACCEPT            "*/*"


#define DEFAULT_PROXY_PORT        3128


/* Definition for various types of counters */
typedef uint64_t counter_t;


/* How to full identify a URI */
typedef struct
{
  /* Both Userid and Password are mandatory in the event of authentication is in effect */
  char * protocol;          /* Optional */
  char * userid;            /* Optional */
  char * passwd;            /* Optional */
  char * hostname;
  char * port;
  char * path;              /* Optional - default "/" */

} uri_t;


/* How to keep track of each HTTP request */
struct server_t;
typedef struct
{
  struct timeval started;            /* Time the request has been started                   */
  struct server_t * server;          /* HTTP server reference that this request belongs to  */
  struct evhttp_connection * evcon;  /* The HTTP connection over which the request is made  */
  struct evhttp_request * evreq;     /* The HTTP request itself                             */

} req_t;


/* How to keep track of each HTTP server to benchmark */
typedef struct server_t
{
  /* Identifiers */
  char * full;                        /* Server identifier as given by user (read from file) */

  /* HTTP Resource identifiers as decoded from the user specification */
  uri_t * uri;

  /* HTTP Protocol identifiers as received from the server */
  char * servername;                 /* Server name as returned in the HTTP reply           */
  uint64_t length;                   /* Document length as returned in the HTTP reply       */

  /* HTTP Protocol */
  u_char keepalive;                  /* Boolean to enable keep-alive requests               */
  u_char head;                       /* Boolean to enable HTTP requests                     */
  char * proxyname;                  /* Proxy server hostname                               */
  int proxyport;                     /* Proxy port                                          */
  char * authproxy;                  /* Basic proxy authentication (user:password)          */

  /* Application limits */
  counter_t todo;                    /* # of requests to perform                            */
  unsigned concurrency;              /* # of concurrent requests to perform at a time       */
  unsigned maxretry;                 /* # of times a request should be resent - 0 no retry  */

  /* Timeouts */
  struct timeval reply_tv;           /* HTTP Reply timeout                                  */

  /* Timers */
  struct event req_evt;              /* Variable to benchmark HTTP server at given time     */

  /* Request/Reply counters */
  counter_t issued;                  /* Total # of HTTP requests issued                     */
  counter_t failed;                  /* Total # of HTTP requests failed to send             */
  counter_t done;                    /* Total # of HTTP replies received                    */
  counter_t bad;                     /* Total # of HTTP requests completed with errors      */
  counter_t dropped;                 /* Total # of HTTP connections dropped by the remote   */

  /* Bytes counters */
  counter_t sentbytes;               /* Total # of bytes sent                               */
  counter_t totalread;               /* Total # of bytes received                           */
  counter_t totalbread;              /* Total amount HTML entity body read                  */

  /* Timestamps */
  struct timeval firstsent;          /* Time first HTTP request was sent                    */
  struct timeval lastsent;           /* Time last HTTP request was sent                     */
  struct timeval firstrecv;          /* Time first HTTP reply was received                  */
  struct timeval lastrecv;           /* Time last HTTP reply was received                   */

  /* Counters for statistics */
  double min;                        /* Shortest reply time                                 */
  double sum;                        /* Sum of reply times                                  */
  double max;                        /* Longest reply time                                  */

  req_t ** argv;                     /* The array of requests for this server               */

} server_t;


/* Run-time parameters */
typedef struct
{
  /* Identifiers */
  struct timeval started;            /* The time program was started                        */
  char * progname;                   /* The name of the program                             */
  char * nodename;                   /* The system the application was started on           */
  pid_t pid;                         /* Process pid                                         */

  u_char quiet;                      /* Quiet output                                        */

  /* Files */
  char * serversfile;                /* Server file (in any)                                */

  /* Application limits */
  unsigned todo;                     /* # of requests to perform foreach server             */
  unsigned concurrency;              /* # of concurrent requests to perform at a time       */
  unsigned maxretry;                 /* # of times a request should be resent - 0 no retry  */

  /* HTTP Protocol */
  u_char keepalive;                  /* Boolean to enable keep-alive requests               */
  u_char head;                       /* Boolean to enable HTTP requests                     */
  char * proxy;                      /* Proxy server (hostname:port)                        */
  char * authproxy;                  /* Basic proxy authentication (user:password)          */

  /* Protocol and application timeouts in milliseconds (unless otherwise specified) */
  time_t reply;                      /* HTTP Reply timeout                                  */
  struct timeval initial_tv;         /* Initial delay timeout before to start benchmarking  */
  struct timeval duration_tv;        /* Duration timeout before to stop benchmarking        */

  /* Periodic time intervals in milliseconds (unless otherwise specified) */
  struct event bench_evt;

  unsigned httpargc;                 /* # of HTTP servers currently benchmarked             */
  server_t ** httpargv;              /* Array of HTTP servers currently benchmarked         */
  unsigned next;                     /* Index in the array of HTTP servers                  */

  struct event_base * base;          /* Libevent main base                                  */

  struct timeval begin;              /* The time benchmark was initiated                    */
  struct timeval end;                /* The time benchmark was completed                    */

  /* Optional and arbitrary user-defined headers to be added in all the requests */
  char ** headers;

  /* Optional and arbitrary user-defined cookies to be added in all the requests */
  char ** cookies;

} runtime_t;


/* Global variable to keep run-time parameters all in one */
extern runtime_t * run;


/* Public functions in file callbacks.c */
void reply_cb (struct evhttp_request * req, void * arg);
void server_cb (int unused, const short event, void * server);
void benchmark_cb (int unused, const short event, void * none);


/* Public functions in file requests.c */
req_t * mkreq (struct event_base * base, server_t * server);
void initreq (req_t * request, struct event_base * base, server_t * server);
void rmreq (void * req);
req_t ** morereq (req_t * argv [], req_t * item);
req_t ** lessreq (req_t * argv [], req_t * item, void (* rmitem) (void *));
req_t ** cleanupreq (req_t * argv [], void (* rmitem) (void *));
req_t * nextreq (req_t * argv []);


/* Public functions in file servers.c */
server_t * mkserver (char * full, counter_t todo, unsigned concurrency, unsigned maxretry, time_t reply,
		     u_char keepalive, u_char head, char * proxy, char * authproxy);
void rmserver (void * server);
server_t ** moreserver (server_t * argv [], server_t * item);
server_t ** lessserver (server_t * argv [], server_t * item, void (* rmitem) (void *));
server_t ** cleanupserver (server_t * argv [], void (* rmitem) (void *));
int finished (server_t * argv []);
void lbstats (server_t * s []);


/* Public functions in file slurp.c */
int slurp (char * serversfile);


/* Public functions in file uri.c */
uri_t * splituri (char * name);
void freeuri (uri_t * uri);


/* Public functions in file utils.c */
runtime_t * defaultrun (char * progname);
void nomorerun (runtime_t * rc);
char * ppcnt (counter_t value);
char * ppbytes (counter_t bytes);
void ato64 (char * s, char * d);


/* Public functions in file time.c */
double tvtof (const struct timeval * tv);
double tvtomsecs (struct timeval * tv);
char * tvtoa (struct timeval * tv);
void msecstotv (time_t msecs, struct timeval * tv);
time_t atomsec (char * value);
time_t delta_usecs (struct timeval * t2, struct timeval * t1);
time_t delta_msecs (struct timeval * t2, struct timeval * t1);


/* Public functions in file varrays.c */
void * safefree (void * a);
void * safedup (void * a, void * b);
int valen (void * argv []);
void ** vamore (void * argv [], void * item);
int valookup (void * argv [], void * item);
void ** valess (void * argv [], void * item, void (* rmitem) (void *));
void ** vacleanup (void * argv [], void (* rmitem) (void *));
void ** vadup (void * argv [], int size);
char ** argsadd (char * argv [], char * item);
char ** argsfree (char * argv []);
char * argsfind (char * argv [], char * item);


#endif /* _LB_H */
