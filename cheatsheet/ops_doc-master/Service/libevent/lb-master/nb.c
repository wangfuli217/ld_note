/*
 * nb.c - Nick's simple HTTP client benchmark
 *
 *        Heavily based on bench_httpclient.c from the Libevent distribution
 *        but with output 'ab'-like to be parseable by scripts for comparison
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

#include <string.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <getopt.h>

typedef uint64_t counter_t;

char * tvtoa (struct timeval * tv);
double tvtomsecs (struct timeval * tv);

static u_char quiet = 0;
static char * server = "127.0.0.1";
static int port = 1234;
static int length = 0;



/*
 * Copyright 2009-2012 Niels Provos and Nick Mathewson
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 4. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#include <sys/types.h>
#ifdef WIN32
#include <winsock2.h>
#else
#include <sys/socket.h>
#include <netinet/in.h>
# ifdef _XOPEN_SOURCE_EXTENDED
#  include <arpa/inet.h>
# endif
#endif
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include "event2/event.h"
#include "event2/bufferevent.h"
#include "event2/buffer.h"
#include "event2/util.h"

/* for EVUTIL_ERR_CONNECT_RETRIABLE macro */
#include "util-internal.h"

const char *resource = NULL;
struct event_base *base = NULL;

int total_n_handled = 0;
int total_n_errors = 0;
int total_n_launched = 0;
size_t total_n_bytes = 0;
struct timeval total_time = {0,0};
int n_errors = 0;

int PARALLELISM = 200;
int N_REQUESTS = 20000;

struct request_info {
	size_t n_read;
	struct timeval started;
};

static int launch_request(char * server, int port);
static void readcb(struct bufferevent *b, void *arg);
static void errorcb(struct bufferevent *b, short what, void *arg);

static void
readcb(struct bufferevent *b, void *arg)
{
	struct request_info *ri = arg;
	struct evbuffer *input = bufferevent_get_input(b);
	size_t n = evbuffer_get_length(input);

	ri->n_read += n;
	evbuffer_drain(input, n);
}

static void
errorcb(struct bufferevent *b, short what, void *arg)
{
	struct request_info *ri = arg;
	struct timeval now, diff;
	if (what & BEV_EVENT_EOF) {
		++total_n_handled;
		total_n_bytes += ri->n_read;
		evutil_gettimeofday(&now, NULL);
		evutil_timersub(&now, &ri->started, &diff);
		evutil_timeradd(&diff, &total_time, &total_time);

		if (total_n_handled && (total_n_handled%1000)==0 && ! quiet)
			printf("%d requests done\n",total_n_handled);

		if (total_n_launched < N_REQUESTS) {
			if (launch_request(server, port) < 0)
				perror("Can't launch");
		}
	} else {
		++total_n_errors;
		perror("Unexpected error");
	}

	bufferevent_setcb(b, NULL, NULL, NULL, NULL);
	free(ri);
	bufferevent_disable(b, EV_READ|EV_WRITE);
	bufferevent_free(b);
}

static void
frob_socket(evutil_socket_t sock)
{
	struct linger l;
	int one = 1;
	if (setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, (void*)&one, sizeof(one))<0)
		perror("setsockopt(SO_REUSEADDR)");
	l.l_onoff = 1;
	l.l_linger = 0;
	if (setsockopt(sock, SOL_SOCKET, SO_LINGER, (void*)&l, sizeof(l))<0)
		perror("setsockopt(SO_LINGER)");
}

static int
launch_request(char * server, int port)
{
	evutil_socket_t sock;
	struct sockaddr_in sin;
	struct bufferevent *b;

	struct request_info *ri;

	struct hostent * host;

	memset(&sin, 0, sizeof(sin));

	host = gethostbyname (server);
	if (host)
	  memcpy (& sin . sin_addr, host -> h_addr_list [0], host -> h_length);
	else
	  sin . sin_addr . s_addr = inet_addr (server);
	if (sin . sin_addr . s_addr == -1)
	  return -1;

	++total_n_launched;

	sin.sin_family = AF_INET;
	sin.sin_port = htons(port);
	if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0)
		return -1;
	if (evutil_make_socket_nonblocking(sock) < 0)
		return -1;
	frob_socket(sock);
	if (connect(sock, (struct sockaddr*)&sin, sizeof(sin)) < 0) {
		int e = errno;
		if (! EVUTIL_ERR_CONNECT_RETRIABLE(e)) {
			return -1;
		}
	}

	ri = malloc(sizeof(*ri));
	ri->n_read = 0;
	evutil_gettimeofday(&ri->started, NULL);

	b = bufferevent_socket_new(base, sock, BEV_OPT_CLOSE_ON_FREE);

	bufferevent_setcb(b, readcb, NULL, errorcb, ri);
	bufferevent_enable(b, EV_READ|EV_WRITE);

	evbuffer_add_printf(bufferevent_get_output(b),
	    "GET %s HTTP/1.0\r\n\r\n", resource);

	return 0;
}


/* Definitions for local buffers used to pretty format and display counters for both requests and bytes */
#define BUFFERS     12
#define BUFFERSIZE  32

/* Pretty print generic counters */
char * ppcnt (counter_t value)
{
  static char buffer [BUFFERS] [BUFFERSIZE];
  static short which = -1;

  which = (which + 1) % BUFFERS;   /* round-robin in the array of local buffers */

  if (value < 1000)
    sprintf (buffer [which], "%lu", (unsigned long) value);
  else if (value < 1000000)
    sprintf (buffer [which], "%lu,%03lu", (unsigned long) value / 1000, (unsigned long) value % 1000);
  else
    sprintf (buffer [which], "%lu,%03lu,%03lu",
	     (unsigned long) (value / 1000000),
	     (unsigned long) (value - (value / 1000000) * 1000000) / 1000,
	     (unsigned long) value % 1000);

  return buffer [which];
}


/* Pretty print bytes counters */
char * ppbytes (counter_t bytes)
{
  static char buffer [BUFFERS] [BUFFERSIZE];
  static short which = -1;

  which = (which + 1) % BUFFERS;   /* round-robin in the array of local buffers */

  if (bytes < 1024)
    sprintf (buffer [which], "%lu Bytes", (unsigned long) bytes);
  else if (bytes < 1048576)
    sprintf (buffer [which], "%5.1f Kb", (float) bytes / 1024);
  else
    {
      float mega = bytes / 1048576;
      if (mega < 1024)
	sprintf (buffer [which], "%5.1f MB", mega);
      else
	{
	  mega /= 1024;
	  if (mega < 1024)
	    sprintf (buffer [which], "%5.1f GB", mega);
	  else
	    sprintf (buffer [which], "%.1f TB", mega / 1024);
	}
    }
  return buffer [which];
}


int main (int argc, char **argv)
{
  int i;
  struct timeval start, end, total;
  resource = "/";

  int option;
  double msecs;
  char * progname = strrchr (argv [0], '/');
  progname = ! progname ? progname : progname + 1;

  setvbuf (stdout, NULL, _IONBF, 0);

#define OPTSTRING "qs:p:r:n:c:"
  while ((option = getopt (argc, argv, OPTSTRING)) != EOF)
    {
      switch (option)
        {
        default: return 1;

        case 'q': quiet = 1; break;                                                  /* Quiet output                         */
	case 's': server = optarg; break;                                            /* server address                       */
	case 'p': port = atoi (optarg); break;                                       /* server port                          */
	case 'r': resource = optarg; break;                                          /* server resource                      */

	case 'n': N_REQUESTS = atoi (optarg); break;                                 /* Total # of requests - 0 unlimited    */

	case 'c': PARALLELISM = atoi (optarg);                                       /* # of concurrent requests - 0 illegal */
	  if (! PARALLELISM)
	    {
	      printf ("%s: illegal # of concurrency requests [%s]\n", progname, optarg);
	      return 1;
	    }
	  break;
	}
    }

  base = event_base_new ();

  for (i = 0; i < PARALLELISM; ++i)
    {
      if (launch_request (server, port) < 0)
	perror ("launch");
    }

  gettimeofday (&start, NULL);

  event_base_dispatch (base);

  gettimeofday (&end, NULL);

  evutil_timersub (&end, &start, &total);
  msecs = tvtomsecs (& total);

  if (! total_n_handled)
    {
      puts ("Nothing worked.  You probably did something dumb.");
      return 0;
    }

  printf ("Server Software:        %s\n", "Unknown");
  printf ("Server Hostname:        %s\n", server);
  printf ("Server Port:            %d\n", port);
  printf ("\n");
  printf ("Document Path:          %s\n", resource);
  printf ("Document Length:        %d bytes (%s)\n", length, ppbytes (length));
  printf ("\n");
  printf ("Concurrency Level:      %d\n", PARALLELISM);
  printf ("Time taken for tests:   %s\n", tvtoa (& total));
  printf ("Complete requests:      %d\n", total_n_handled);
  printf ("Failed requests:        %d\n", total_n_errors);
  if (total_n_errors)
    printf ("   (Connect: NA, Length: NA, Exceptions: NA)\n");
  printf ("Write errors:           %d\n", total_n_errors);
  printf ("Total transferred:      %zd bytes (%s)\n", total_n_bytes, ppbytes (total_n_bytes));
  printf ("HTML transferred:       %zd bytes (%s)\n", total_n_bytes, ppbytes (total_n_bytes));

  /* Avoid division by zero */
  if (total_n_handled)
    {
      printf ("Requests per second:    %.2f [#/sec] (mean)\n",
	      total_n_handled * 1000.0 / tvtomsecs (& total));
      printf ("Time per request:       %.3f [ms] (mean)\n",
	      PARALLELISM * msecs / total_n_handled);
      if (PARALLELISM > 1)
	printf ("Time per request:       %.3f [ms] (mean, across all concurrent requests)\n",
		msecs / total_n_handled);
      printf ("Transfer rate:          %.2f [Kbytes/sec] received\n",
	      (total_n_bytes / 1024) / (msecs / 1000.0));
    }
  printf ("\n");

  return 0;
}
