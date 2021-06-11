/*
 * slurp.c - Read the HTTP servers file in memory
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
#include <string.h>
#include <time.h>
#include <netinet/in.h>
#include <arpa/inet.h>


/* Keywords recognized in the HTTP servers file */
#define REQUESTS        "Requests"
#define CONCURRENT      "Concurrent"
#define MAXRETRY        "MaxRetry"
#define REPLY_TIMEOUT   "ReplyTimeout"


/* Eat the HTTP servers file in memory */
int slurp (char * serversfile)
{
  FILE * in = stdin;
  int counter = 0;   /* a line counter */

  /* Open the HTTP servers file */
  if (strcmp (serversfile, "-") && ! (in = fopen (serversfile, "r")))
    {
      printf ("%s: cannot open '%s'\n", run -> progname, serversfile);
      return 1;
    }

  if (! run -> quiet)
    printf ("%s: reading HTTP servers file '%s' ... ", run -> progname, serversfile);

  /* Read all lines from the file */
  while (! feof (in))
    {
#define MAXLINE 1024
      char line [MAXLINE] = "";

      char a1 [MAXLINE] = "";      /* url                      */
      char b2 [MAXLINE] = "";      /* # of requests            */
      char c3 [MAXLINE] = "";      /* # of concurrent requests */
      char d4 [MAXLINE] = "";      /* # max retries            */
      char e5 [MAXLINE] = "";      /* HTTP reply timeout (> 0) */

      unsigned n = DEFAULT_REQUESTS;
      unsigned c = DEFAULT_CONCURRENCY;
      unsigned r = DEFAULT_MAX_RETRY;
      time_t t1 = DEFAULT_REPLY_TIMEOUT;
      time_t msecs;
      uri_t * uri;

      /* Read a line from the file... */
      fgets (line, sizeof (line), in);

      counter ++;

      /* Skip empty and comment lines */
      if (! * line || * line == '\n' || * line == '#')
	continue;

      /* Strip trailing \n */
      if (line [strlen (line) - 1] == '\n')
	line [strlen (line) - 1] = '\0';

      /* and parse it */
      switch (sscanf (line, "%s %s %s %s %s", a1, b2, c3, d4, e5))
	{
	  /* Check for IP vs non IP names.
	   * IP names are added to the array of those currently being benchmarked,
	   * hostnames are discarded
	   */
	case 1:
	  if ((uri = splituri (a1)))
	    run -> httpargv = moreserver (run -> httpargv, mkserver (a1, n, c, r, t1, 0, 0, NULL, NULL)),
	      run -> httpargc ++;
	  else
	    printf ("%s: %s:%d: warning - syntax error while processing [%s]. ignored ...\n", run -> progname,
		    strcmp (serversfile, "-") ? serversfile : "stdin", counter, a1);
	  break;

	case 2:
	  if (! strcmp (a1, CONCURRENT))
	    /* Evalute the new value for concurrency */
	    run -> concurrency = atoi (b2);
	  else if (! strcmp (a1, MAXRETRY))
	    /* Evalute the new value for max # of retries */
	    run -> maxretry = atoi (b2);
	  else if (! strcmp (a1, REPLY_TIMEOUT))
	    {
	      /* Evalute the new value for HTTP Reply timeout (0 is an illegal value) */
	      msecs = atomsec (b2);
	      if (msecs > 0)
		run -> reply = msecs;
	      else
		printf ("%s: %s:%d: warning - illegal HTTP Reply timeout [%s] ignored while reading '%s'\n",
			run -> progname, strcmp (serversfile, "-") ? serversfile : "stdin", counter, b2, a1);
	    }
	  else
	    {
	      /* Check for an optional and legal HTTP Reply timeout value */
	      if (strcmp (b2, "-") && ((t1 = atomsec (b2)) <= 0))
		{
		  printf ("%s: %s:%d: warning - illegal HTTP Reply timeout [%s] ignored while reading '%s'\n",
			  run -> progname, strcmp (serversfile, "-") ? serversfile : "stdin", counter, b2, a1);
		  msecs = DEFAULT_REPLY_TIMEOUT;
		}

	      if ((uri = splituri (a1)))
		run -> httpargv = moreserver (run -> httpargv, mkserver (a1, n, c, r, t1, 0, 0, NULL, NULL)),
		  run -> httpargc ++;
	      else
		printf ("%s: %s:%d: warning - syntax error while processing [%s]. ignored ...\n", run -> progname,
			strcmp (serversfile, "-") ? serversfile : "stdin", counter, a1);
	    }
	  break;

	case 4:
	  /* Check for an optional and legal HTTP Reply timeout value */
	  if (strcmp (b2, "-") && ((t1 = atomsec (b2)) <= 0))
	    {
	      printf ("%s: %s:%d: warning - illegal HTTP Reply timeout [%s] ignored while reading '%s'\n",
		      run -> progname, strcmp (serversfile, "-") ? serversfile : "stdin", counter, b2, a1);
	      msecs = DEFAULT_REPLY_TIMEOUT;
	    }

	  if ((uri = splituri (a1)))
	    run -> httpargv = moreserver (run -> httpargv, mkserver (a1, n, c, r, t1, 0, 0, NULL, NULL)),
	      run -> httpargc ++;
	  else
	    printf ("%s: %s:%d: warning - syntax error while processing [%s]. ignored ...\n", run -> progname,
		    strcmp (serversfile, "-") ? serversfile : "stdin", counter, a1);
	  break;

	case 5:
	default:
	  /* Check for an optional and legal HTTP Reply timeout value */
	  if (strcmp (b2, "-") && ((t1 = atomsec (b2)) <= 0))
	    {
	      printf ("%s: %s:%d: warning - illegal HTTP Reply timeout [%s] ignored while reading '%s'\n",
		      run -> progname, strcmp (serversfile, "-") ? serversfile : "stdin", counter, b2, a1);
	      msecs = DEFAULT_REPLY_TIMEOUT;
	    }

	  if ((uri = splituri (a1)))
	    run -> httpargv = moreserver (run -> httpargv, mkserver (a1, n, c, r, t1, 0, 0, NULL, NULL)),
	      run -> httpargc ++;
	  else
	    printf ("%s: %s:%d: warning - syntax error while processing [%s]. ignored ...\n", run -> progname,
		    strcmp (serversfile, "-") ? serversfile : "stdin", counter, a1);
	  break;
	}
    }

  /* Cleanup */
  if (in != stdin)
    fclose (in);

  return 0;
}
