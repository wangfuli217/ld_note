/*
 * servers.c - Utilities to keep in memory libevent-driven HTTP servers
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
 *                 (C) Copyright 2009-2016
 *         Rocco Carbone <rocco /at/ tecsiel /dot/ it>
 *
 * Released under the terms of 3-clause BSD License.
 * See included LICENSE file for details.
 *
 * -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
 *
 */


/* Private header file(s) */
#include "lb.h"

/* Operating System header file(s) */
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include <values.h>


/* Allocate and initialize new HTTP server identified by its hostname/ip address for outgoing benchmark activities */
server_t * mkserver (char * full, counter_t todo, unsigned concurrency, unsigned maxretry, time_t reply,
		     u_char keepalive, u_char head, char * proxy, char * authproxy)
{
  server_t * s;
  char * p;
  int i;

  /* Attempt to parse and split 'url' into pieces */
  uri_t * uri = splituri (full);
  if (! uri)
    {
      printf ("%s: syntax error while processing [%s]\n", run -> progname, full);
      return NULL;
    }

  s = calloc (sizeof (server_t), 1);
  s -> full        = strdup (full);
  s -> uri         = uri;
  s -> todo        = todo;
  s -> concurrency = concurrency;
  s -> maxretry    = maxretry;
  msecstotv (reply, & s -> reply_tv);
  s -> keepalive   = keepalive;
  s -> head        = head;

  /* Split proxy passed in the format hostname[:port] into their components hostname and port */
  if (proxy)
    {
      p = strchr (proxy, ':');
      if (p)
	* p = '\0';
      s -> proxyname = strdup (proxy);
      s -> proxyport = p ? atoi (p + 1) : DEFAULT_PROXY_PORT;
      if (p)
	* p = ':';
    }
      
  s -> authproxy   = authproxy ? strdup (authproxy) : NULL;

  /* Allocate the table of concurrent requests for this server */
  for (i = 0; i < concurrency; i ++)
    s -> argv = morereq (s -> argv, mkreq (run -> base, s));

  /* Define here the callback to benchmark the HTTP server */
  evtimer_assign (& s -> req_evt, run -> base, server_cb, s);

  s -> min = MAXINT;

  return s;
}


/* Free allocated memory and resources used to keep a HTTP server */
void rmserver (void * server)
{
  server_t * s = (server_t *) server;
  if (! s)
    return;

  safefree (s -> full);
  freeuri (s -> uri);
  safefree (s -> servername);
  safefree (s -> proxyname);
  safefree (s -> authproxy);

  cleanupreq (s -> argv, rmreq);

  free (s);
}


/* Add an item to the array */
server_t ** moreserver (server_t * argv [], server_t * item)
{
  return (server_t **) vamore ((void **) argv, item);
}


/* Remove an item from the array */
server_t ** lessserver (server_t * argv [], server_t * item, void (* rmitem) (void *))
{
  return (server_t **) valess ((void **) argv, item, rmitem);
}


/* Free the whole array */
server_t ** cleanupserver (server_t * argv [], void (* rmitem) (void *))
{
  return (server_t **) vacleanup ((void **) argv, rmitem);
}


/* Give an indication if all the requests for all the servers have been completed */
int finished (server_t * argv [])
{
  server_t ** s = argv;
  while (s && * s)
    if ((* s) -> done != (* s) -> todo)
      return 0;
    else
      s ++;
  return 1;
}


/* Print out per HTTP server statistics in the same format used by 'ab' */
static void lbstat (server_t * s)
{
  /* Compute time difference to calculate the time elapsed */
  struct timeval elapsed;
  double msecs;

  evutil_timersub (& s -> lastrecv, & s -> firstsent, & elapsed);
  msecs = tvtomsecs (& elapsed);

  printf ("Server Software:        %s\n", s -> servername ? s -> servername : "Unknown");
  printf ("Server Hostname:        %s\n", s -> uri -> hostname);
  printf ("Server Port:            %s\n", s -> uri -> port);
  printf ("\n");
  printf ("Document Path:          %s\n", s -> uri -> path);
  printf ("Document Length:        %" PRIu64 " bytes (%s)\n", s -> length, ppbytes (s -> length));
  printf ("\n");
  printf ("Concurrency Level:      %d\n", s -> concurrency);
  printf ("Time taken for tests:   %s\n", tvtoa (& elapsed));
  printf ("Complete requests:      %" PRIu64 "\n", s -> done);
  printf ("Failed requests:        %" PRIu64 "\n", s -> bad);
  if (s -> bad)
    printf ("   (Connect: NA, Length: NA, Exceptions: NA)\n");
  printf ("Write errors:           %" PRIu64 "\n", s -> failed);
  printf ("Total transferred:      %" PRIu64 " bytes (%s)\n", s -> totalread, ppbytes (s -> totalread));
  printf ("HTML transferred:       %" PRIu64 " bytes (%s)\n", s -> totalbread, ppbytes (s -> totalbread));

  /* Avoid division by zero */
  if (s -> done)
    {
      printf ("Requests per second:    %.2f [#/sec] (mean)\n",
	      s -> done * 1000.0 / tvtomsecs (& elapsed));
      printf ("Time per request:       %.3f [ms] (mean)\n",
	      s -> concurrency * msecs / s -> done);
      if (s -> concurrency > 1)
	printf ("Time per request:       %.3f [ms] (mean, across all concurrent requests)\n",
		msecs / s -> done);
      printf ("Transfer rate:          %.2f [Kbytes/sec] received\n",
	      (s -> totalread / 1024) / (msecs / 1000.0));
      printf ("Time per request:       %.2f/%.2f/%.2f min/avg/max [msec]\n",
	      s -> min / 1000.0, (s -> sum / 1000.0) / s -> done, s -> max / 1000.0);
    }
  printf ("\n");
}


/* Print out statistics for all HTTP servers */
void lbstats (server_t * argv [])
{
  server_t ** s = argv;
  while (s && * s)
    lbstat (* s ++);
}
