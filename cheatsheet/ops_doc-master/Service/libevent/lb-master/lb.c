/*
 * lb.c - A very small and efficient Libevent-based benchmark tool for HTTP servers.
 *
 *        Like the so popular Apache benchmark tool 'ab' but:
 *         o based on the Libevent-2.x series for better performances
 *         o multi HTTP server at the same time
 *
 *        One or more HTTP servers to benchmark can be supplied:
 *         1. via arguments on the command line
 *         2. via a servers file using the -f switch on the command line
 *
 *        Command line arguments and file are mutually exclusive.
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


/* Private header file(s) */
#include "lb.h"
#include "version-lb.h"

/* Operating System header file(s) */
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <signal.h>
#if defined(HAVE_GETOPT_H)
#include <getopt.h>
#endif /* HAVE_GETOPT_H */


/* Version, authors and legal notice */
#define AUTHOR        "rocco@tecsiel.it"
#define COPYRIGHT     "Copyright (c) 2009-2016 Rocco Carbone, Pisa, Italy"
#define LICENCE       "Released under 3-clause BSD license"
#define URL           "https://github.com/rcarbone/lb"
#define RELEASE_DATE  __DATE__
#define TEMPLATE      "lb.servers"


/* Global variable to keep run-time parameters all in one */
runtime_t * run = NULL;


/* What should be done when the program execution is interrupted by a signal */
static void on_interrupt (int sig)
{
  signal (sig, SIG_IGN);

  switch (sig)
    {
    case SIGINT:    /* ^C */
    case SIGQUIT:   /* quit */
    case SIGTERM:   /* terminate */
      printf ("\n%s: Normal termination: caught signal [%d]\n", run -> progname, sig);
      break;

    default:
      printf ("\n%s: Unexpected signal caught [%d]\n", run -> progname, sig);
      break;
    }

  /* Immediately exit the event loop */
  event_base_loopbreak (run -> base);
}


/* Initialize the Libevent and read the HTTP servers file in memory */
static int initialize (char * argv [])
{
  /* Initialize a new event base */
  run -> base = event_base_new ();

  /* Check first for one or more HTTP servers passed as arguments on the command line */
  if (* argv)
    {
      /* Attempt to resolve hostnames passed on the command line and keep them in an internal array */
      while (* argv)
	{
	  server_t * server = mkserver (* argv ++, run -> todo, run -> concurrency,
					run -> maxretry, run -> reply, run -> keepalive, run -> head,
					run -> proxy, run -> authproxy);
	  if (server)
	    /*
	     * Add the HTTP server to the array of those currently being
	     * benchmarked and increment its number for the next run
	     */
	    run -> httpargv = moreserver (run -> httpargv, server),
	      run -> httpargc ++;
	}
    }
  else if (run -> serversfile)
    {
      /* HTTP server supplied via a servers file, go to eat file in memory */
      if (slurp (run -> serversfile))
	return 1;
    }

  /* Check if at least one HTTP server has been specified for being benckmarked */
  if (! run -> httpargc)
    {
      printf ("%s: No HTTP server to benchmark. Exiting!\n", run -> progname);
      return 1;
    }

  return 0;
}


/* Terminate the Libevent */
static void terminate (struct event_base * base)
{
  /* Terminate the Libevent library */
  if (base)
    event_base_free (base);
}


/* Announce to the world! */
static void helloworld (char * progname, char * nodename)
{
  printf ("This is %s ver. %s (compiled %s) running on %s\n", progname, VERSION, RELEASE_DATE, nodename);
  printf ("linked to libevent-%s\n", event_get_version ());
  printf ("%s - %s - %s\n\n", COPYRIGHT, LICENCE, URL);
}


/* Display the syntax for using this program */
static void usage (char * progname)
{
  printf ("%s %s, a very small and efficient Libevent-based benchmark tool for HTTP servers\n", progname, VERSION);
  printf ("Usage:\n");
  printf ("    %s [option(s)] url [url [url [url ... ]]]\n", progname);
  printf ("    %s [option(s)] -f serverfile\n", progname);
  printf ("\n");
  printf ("      Use the first syntax to specify any number of HTTP servers on the command line\n");
  printf ("      or the second to specify a file containing the lists of HTTP servers to benchmark.\n");
  printf ("\n");

  printf ("Startup:\n");
  printf ("   -h               show this help message and exit\n");
  printf ("   -v               show version number and exit\n");
  printf ("\n");

  printf ("Files:\n");
  printf ("   -f filename      file containing the list of servers to benchmark (default none)\n");
  printf ("\n");

  printf ("Limits:\n");
  printf ("   -n num           # of requests per benchmark to perform (default %d)\n", DEFAULT_REQUESTS);
  printf ("   -c num           # of multiple requests per server to perform at a time (default %d)\n", DEFAULT_CONCURRENCY);
  printf ("   -m num           max # of retries in the event a server does not respond\n");
  printf ("\n");

  printf ("HTTP Protocol:\n");
  printf ("   -i               enable HTTP HEAD instead of GET\n");
  printf ("   -k               enable HTTP Keep-Alive feature\n");
  printf ("   -H               add arbitrary HTTP header in colon separated key and value (repeteable)\n");
  printf ("   -C               add arbitrary HTTP cookie (repeteable)\n");
  printf ("   -X proxy:port    use HTTP proxy on given port\n");
  printf ("   -P user:passwd   use basic proxy authetication\n");
  printf ("\n");

  printf ("Timeouts:\n");
  printf ("   -r timeout       HTTP reply timeout\n");
  printf ("   -s timeout       initial timeout to start the benchmark session at (default 0 that means immediately)\n");
  printf ("   -t timeout       time limit execution (default 0 that means unlimited - could be an alternative to -n option)\n");
  printf ("\n");
  printf ("    timeout syntax is:\n");
  printf ("     value[l]  with value expressed in milliseconds\n");
  printf ("     value     with value expressed in seconds       (default suffix specification)\n");
  printf ("     value[s]  with value expressed in seconds\n");
  printf ("     value[m]  with value expressed in minutes\n");
  printf ("     value[h]  with value expressed in hours\n");
  printf ("\n");

  printf ("    url syntax is [http://[userid:passwd@]]hostname:port/path\n");
  printf ("\n");

  printf ("    Please take a look at the server template file '%s' for its syntax; it should be self-explanatory\n", TEMPLATE);
  printf ("\n");

  printf ("    Note: in the event both -n and -t options have been specified the benchmark\n");
  printf ("          will be interrupted by the termination event that will come first\n");
}


/* You are running this version of the software */
static void version (char * progname)
{
  printf ("%s ver. %s built on %s %s\n", progname, VERSION, __DATE__, __TIME__);
  printf ("%s\n", COPYRIGHT);
  printf ("%s - %s\n", LICENCE, URL);
}


/* Sirs and Ladies, here to you... lb!!! */
int main (int argc, char * argv [])
{
  int option;

  time_t msecs;
  struct event_base * base;
  time_t now;
  struct timeval duration;

  /* Exit code to the calling process */
  int exitcode = 0;

  /* Set unbuffered stdout */
  setvbuf (stdout, NULL, _IONBF, 0);

  /* Initialize run-time variables to default values */
  run = defaultrun (argv [0]);

#define OPTSTRING "hvqf:n:c:m:r:I:t:ikH:C:X:P:"
  while ((option = getopt (argc, argv, OPTSTRING)) != EOF)
    {
      switch (option)
        {
        default: usage (run -> progname); return 1;

        case 'h': usage (run -> progname);   return 0;
        case 'v': version (run -> progname); return 0;
        case 'q': run -> quiet = 1; break;                                           /* Quiet output                         */

        case 'f': run -> serversfile = safedup (optarg, run -> serversfile); break;  /* HTTP servers file                    */

	case 'n': run -> todo = atoi (optarg); break;                                /* Total # of requests - 0 unlimited    */

	case 'c': run -> concurrency = atoi (optarg);                                /* # of concurrent requests - 0 illegal */
	  if (! run -> concurrency)
	    {
	      printf ("%s: illegal # of concurrency requests [%s]\n", run -> progname, optarg);
	      exitcode = 1;
	      goto bye;
	    }
	  break;

	case 'm': run -> maxretry = atoi (optarg); break;                            /* Max # of retries - 0 none            */

	case 'r': run -> reply = atomsec (optarg);                                   /* HTTP Reply timeout - 0 illegal       */
	  if (run -> reply <= 0)
	    {
	      printf ("%s: illegal reply timeout [%s]\n", run -> progname, optarg);
	      exitcode = 1;
	      goto bye;
	    }
	  break;

	case 's': msecs = atomsec (optarg);                                          /* Initial delay timeout                */
	  if (msecs == -1)
	    {
	      printf ("%s: illegal initial timeout [%s]\n", run -> progname, optarg);
	      exitcode = 1;
	      goto bye;
	    }
	  msecstotv (msecs, & run -> initial_tv);
	  break;

	case 't': msecs = atomsec (optarg);                                          /* Time limit timeout                  */
	  if (msecs == -1)
	    {
	      printf ("%s: illegal time limit timeout [%s]\n", run -> progname, optarg);
	      exitcode = 1;
	      goto bye;
	    }
	  msecstotv (msecs, & run -> duration_tv);
	  break;

        case 'i': run -> head = 1; break;                                            /* Enable HTTP HEAD instead of GET     */
        case 'k': run -> keepalive = 1; break;                                       /* Enable HTTP keep-alive requests     */

	case 'H':                                                                    /* Add HTTP arbitrary headers          */
	  if (strchr (optarg, ':'))
	    run -> headers = argsadd (run -> headers, optarg);
	  else
	    printf ("%s: illegal header [%s] ignored\n", run -> progname, optarg);
	  break;

	case 'C':                                                                    /* Add HTTP arbitrary cookies         */
	  if (strchr (optarg, ':'))
	    run -> cookies = argsadd (run -> cookies, optarg);
	  else
	    printf ("%s: illegal cookie [%s] ignored\n", run -> progname, optarg);
	  break;

	case 'X':                                                                    /* Proxy server                       */
	  if (strchr (optarg, ':'))
	    run -> proxy = safedup (optarg, run -> proxy);
	  else
	    printf ("%s: illegal proxy server [%s] ignored\n", run -> progname, optarg);
	  break;

	case 'P':                                                                    /* Basic Proxy Authentication         */
	  if (strchr (optarg, ':'))
	    run -> authproxy = safedup (optarg, run -> authproxy);
	  else
	    printf ("%s: illegal proxy authentication [%s] ignored\n", run -> progname, optarg);
	  break;
	}
    }

  /* Move pointer to optional arguments (if any) passed on the command line */
  argv = & argv [optind];

  /* Check for mandatory arguments */
  if (! * argv && ! run -> serversfile)
    {
      printf ("%s: missing argument\n", run -> progname);
      usage (run -> progname);
      exitcode = 1;
      goto bye;
    }
  else if (* argv && run -> serversfile)
    {
      printf ("%s: command line arguments and file are mutually exclusive\n", run -> progname);
      usage (run -> progname);
      exitcode = 1;
      goto bye;
    }

  /* Not not allow a concurrency greater than the number of requests */
  if (run -> todo && run -> concurrency > run -> todo)
    run -> concurrency = run -> todo;

  /* Hey boys, lb speaking! */
  if (! run -> quiet)
    helloworld (run -> progname, run -> nodename);

  /* Initialize the Libevent with a new main base event, and optionally read the HTTP servers file in memory */
  if (initialize (argv))
    {
      exitcode = 1;
      goto bye;
    }

  /* Install signal handlers */
  signal (SIGPIPE, SIG_IGN);              /* Ignore writes to connections that have been closed at the other end */
  signal (SIGINT,  on_interrupt);         /* ^C */
  signal (SIGQUIT, on_interrupt);         /* quit */
  signal (SIGTERM, on_interrupt);         /* terminate */

  /* Define the callback and add the timer to start benchmarking after an initial delay timeout */
  evtimer_assign (& run -> bench_evt, run -> base, benchmark_cb, NULL);
  evtimer_add (& run -> bench_evt, & run -> initial_tv);

  /* Handle an optional duration timeout by scheduling a timeout-based loop exit condition */
  evutil_timeradd (& run -> initial_tv, & run -> duration_tv, & duration);
  if (timerisset (& duration))
    event_base_loopexit (run -> base, & duration);

  /* Event dispatching loop */
  event_base_dispatch (run -> base);

  now = time (NULL);
  if (! run -> quiet)
    printf ("%s: #%d HTTP server%s - benchmark session stopped at %24.24s\n\n",
	    run -> progname, run -> httpargc, run -> httpargc > 1 ? "s" : "", ctime (& now));

  /* Print per server statistics information */
  lbstats (run -> httpargv);

 bye:

  base = run -> base;

  /* Release resources and memory */
  nomorerun (run);

  /* Terminate the main base event */
  terminate (base);

  return exitcode;
}
