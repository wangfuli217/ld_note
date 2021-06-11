/*
 * utils.c - common functions used by 'lb'
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

/* Operating System header file(s) */
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/utsname.h>


/* Return the full qualified system hostname */
static char * fqname (char * name)
{
  struct sockaddr_in in;

  /* Attempt to resolve hostname into the Internet address */
  struct hostent * h = gethostbyname (name);

  if (h)
    memcpy (& in . sin_addr, h -> h_addr_list [0], h -> h_length);
  else
    in . sin_addr . s_addr = inet_addr (name);

  /* Back to the full qualified domain name */
  h = gethostbyaddr ((char *) & in . sin_addr, sizeof (struct in_addr), AF_INET);

  return ! h || ! h -> h_name ? inet_ntoa (in . sin_addr) : h -> h_name;
}


/* Initialize the run-time variable to hold its default values
 * (both -1 and NULL mean absent).
 *
 * Each parameter is set to a reasonable value and could be
 * overridden by the corresponding configuration value,
 * if one specified, or command line options.
 */
runtime_t * defaultrun (char * progname)
{
  struct utsname machine;
  char * p = strrchr (progname, '/');

  runtime_t * rc = calloc (sizeof (runtime_t), 1);
  if (! rc)
    return NULL;

  uname (& machine);

   /* Notice the program name, the time it was started and the process identifier */
  gettimeofday (& rc -> started, NULL);
  rc -> progname    = strdup (! p ? progname : p + 1);
  rc -> nodename    = strdup (fqname (machine . nodename));      /* Attempt to resolve nodename in fqdn */
  rc -> pid         = getpid ();

  /* Apply local convention to files parameters */
  rc -> serversfile = ! strcmp (DEFAULT_SERVERS_FILE, "*") ? NULL : strdup (DEFAULT_SERVERS_FILE);

  /* Application limits */
  rc -> todo        = DEFAULT_REQUESTS;
  rc -> concurrency = DEFAULT_CONCURRENCY;
  rc -> maxretry    = DEFAULT_MAX_RETRY;

  /* Protocol and application timeouts in milliseconds (unless otherwise specified) */
  rc -> reply       = DEFAULT_REPLY_TIMEOUT;
  msecstotv (DEFAULT_INITIAL_TIMEOUT, & rc -> initial_tv);
  msecstotv (DEFAULT_DURATION_TIMEOUT, & rc -> duration_tv);

  return rc;
}


/* Free the memory used to save run-time parameters */
void nomorerun (runtime_t * rc)
{
  if (! rc)
    return;

  safefree (rc -> progname);
  safefree (rc -> nodename);

  safefree (rc -> serversfile);

  safefree (rc -> proxy);
  safefree (rc -> authproxy);

  cleanupserver (rc -> httpargv, rmserver);

  argsfree (rc -> headers);
  argsfree (rc -> cookies);

  free (rc);
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


/* The 64-character alphabet */
static unsigned char base64 [] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";


/* Convert a string from ASCII to base64 alphabet */
void ato64 (char * s, char * d)
{
  switch (s ? strlen (s) : 0)
    {
    case 0:
      * d = '\0';
      break;

    case 1:
      * d ++ = base64 [(s [0] >> 2) & 0x3f];
      * d ++ = base64 [((s [0] & 0x3) << 4) | (s [1] & 0xf0) >> 4];
      * d ++ = '=';
      * d ++ = '=';
      break;

    case 2:
      * d ++ = base64 [(s [0] >> 2) & 0x3f];
      * d ++ = base64 [((s [0] & 0x3) << 4) | (s [1] & 0xf0) >> 4];
      * d ++ = base64 [(s [1] & 0xf) << 2];
      * d ++ = '=';
      break;

    default:
      ato64 (s + 3, d + 4);
      * d ++ = base64 [(s [0] >> 2) & 0x3f];
      * d ++ = base64 [((s [0] & 0x3) << 4) | (s [1] & 0xf0) >> 4];
      * d ++ = base64 [((s [1] & 0xf) << 2) | (s [2] & 0xc0) >> 6];
      * d ++ = base64 [s [2] & 0x3f];
      break;
    }
}
