/*
 * callbacks.c - Libevent-based callbacks to handle asynchronous events in 'lb'
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
 *               (C) Copyright 2009-2016
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
#include <string.h>
#include <time.h>

/* As soon as possibile */
static struct timeval asap = { 0, 0 };


/* Callback when a HTTP reply for a given request has been completed or an error occurred */
void reply_cb (struct evhttp_request * evreq, void * req)
{
  req_t * r = (req_t *) req;
  server_t * s = r -> server;

  if (evreq)
    {
      time_t usecs;
      const char * value;

      /* Update counters and timers for this HTTP server */
      gettimeofday (& s -> lastrecv, NULL);
      if (! s -> done)
	s -> firstrecv = s -> lastrecv;

      /* Update reply counter */
      s -> done ++;

      /* Evaluate time spent for this request and update min/sum/avg in microseconds */
      usecs = delta_usecs (& s -> lastrecv, & r -> started);

      s -> min = MIN (usecs, s -> min);
      s -> sum += usecs;
      s -> max = MAX (usecs, s -> max);

      /* Check for useful information in input headers */
      if (! s -> servername && (value = evhttp_find_header (evreq -> input_headers, "Server")))
	s -> servername = strdup (value);

      if ((value = evhttp_find_header (evreq -> input_headers, "Content-Length")))
	s -> length = atol (value);

      /* Update bytes counters */
      s -> totalbread += s -> length;
      s -> totalread += s -> length + 170;

      switch (evreq -> response_code)
	{
	case HTTP_OK:
	  break;
	case HTTP_NOTFOUND:
	  s -> failed ++;
	  break;
	default:
	  s -> failed ++;
	  break;
	}

      /* Unbound the request to allow be reusable for the next run */
      r -> server = NULL;
    }

  /* Check for termination events:
   *   o  restart pushing a new request to the other side if we have not finished with this server
   *   o  immediately exit the event loop if all the requests for all servers have been completed
   */
  if (s -> done != s -> todo)
    evtimer_add (& s -> req_evt, & asap);
  else if (finished (run -> httpargv))
    event_base_loopbreak (run -> base);
}


/* Push a HTTP Request to a server */
void push_cb (int unused, const short event, void * server)
{
  server_t * s = server;

  /* Get a new request */
  req_t * req = nextreq (s -> argv);

  if (req)
    {
      /* Initialize the request for being used with the server */
      initreq (req, run -> base, s);

      /* Make a HTTP request over the specified connection */
      if (evhttp_make_request (req -> evcon, req -> evreq,
			       s -> head ? EVHTTP_REQ_HEAD : EVHTTP_REQ_GET,
			       ! s -> proxyname ? s -> uri -> path : s -> full) != -1)
	{
	  /* Update counters and timers for this HTTP server */
	  if (! s -> issued)
	    gettimeofday (& s -> firstsent, NULL);
	  gettimeofday (& s -> lastsent, NULL);

	  /* Update request counter */
	  s -> issued ++;
	}
      else
	s -> failed ++;
    }
}


/* Start benchmarking a HTTP server */
void server_cb (int unused, const short event, void * server)
{
  server_t * s = server;
  int i;

  /* Change the callback definition to start pushing the current HTTP server that is the first in the chain */
  evtimer_assign (& s -> req_evt, run -> base, push_cb, s);

  /* Immediately ask libevent to push concurrent requests to the other side */
  for (i = 0; i < s -> concurrency; i ++)
    evtimer_add (& s -> req_evt, & asap);

  /*
   * Check if the benchmark for all the HTTP servers have not been initiated and
   * in the event immediately starts to benchmark the next HTTP server in the chain
   */
  run -> next ++;
  if (run -> next < run -> httpargc)
    evtimer_add (& run -> httpargv [run -> next] -> req_evt, & asap);
}


/* Start a new benchmark session at given time */
void benchmark_cb (int unused, const short event, void * none)
{
  time_t now = time (NULL);

  /* Always start from the first HTTP server in the array of known servers */
  run -> next = 0;

  if (! run -> quiet)
    printf ("%s: #%d HTTP server%s - benchmark session started at %24.24s\n",
	    run -> progname, run -> httpargc, run -> httpargc > 1 ? "s" : "", ctime (& now));

  /* Set the time the benchmark has started */
  gettimeofday (& run -> begin, NULL);

  /* Immediately start to push requests to the other side */
  evtimer_add (& run -> httpargv [run -> next] -> req_evt, & asap);
}
