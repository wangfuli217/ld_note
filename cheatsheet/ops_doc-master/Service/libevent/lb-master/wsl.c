/*
 * wsl.c - Minimal Libevent-based web-server used to test the tool
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


/* Operating System header file(s) */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/utsname.h>
#include <sys/resource.h>
#include <signal.h>
#include <getopt.h>

/* Libevent HTTP stuff */
#include "event2/event.h"
#include "event2/http.h"
#include "event2/buffer.h"


/* MIN --- return minimum of two numbers */
#define MIN(a, b) ((a) < (b) ? (a) : (b))


#define DEFAULT_PORT 1234
#define DEFAULT_SIZE 4096    /* Size on bytes of the content */


/* Variables used to set the information to be carried in the HTTP reply */
static char * progname = NULL;
static char * nodename = NULL;
static unsigned content_size = DEFAULT_SIZE;


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

  /* Back to the full qualified domain address */
  h = gethostbyaddr ((char *) & in . sin_addr, sizeof (struct in_addr), AF_INET);

  return ! h || ! h -> h_name ? inet_ntoa (in . sin_addr) : h -> h_name;
}


/* Render the home page */
static void home_cb (struct evhttp_request * req, void * arg)
{
  struct evbuffer * buf = evbuffer_new ();
  struct evkeyvalq * headers = evhttp_request_get_output_headers (req);
  time_t now = time (NULL);
  struct tm * tm = localtime (& now);

  char * printable = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVZXYW[\\]^_`abcdefghijklmnopqrstuvzxyw{|}~";
  int length = strlen (printable);

  unsigned added = 0;
  char value [1024];

  /* Add Date: heeader value */
  strftime (value, 1024, "%a, %d %b %Y %H:%M:%S %Z", tm);
  evhttp_add_header (headers, "Date", value);

  /* Add Server: heeader value */
  sprintf (value, "%s (minimal web server based on libevent-%s)", progname, event_get_version ());
  evhttp_add_header (headers, "Server", value);

  /* Add exactly 'content_size' bytes */
  while (added < content_size)
    {
      int n = MIN (length, content_size - added);
      memcpy (value, printable, n);
      value [n] = '\0';
      added += n;
      evbuffer_add_printf (buf, "%s", value);
    }

  evhttp_send_reply (req, HTTP_OK, "OK", buf);

  evbuffer_free (buf);
}


/* Render the "Not Found!!!" page */
static void notfound_cb (struct evhttp_request * req, void * arg)
{
  struct evbuffer * buf = evbuffer_new ();

  evbuffer_add_printf (buf, "<center><h1><br>Not Found!!!<br></h1></center>");
  evhttp_send_reply (req, HTTP_NOTFOUND, "Not Found", buf);

  evbuffer_free (buf);
}


/* Display the syntax for using this program */
static void usage (char * progname)
{
  printf ("%s, a minimal libevent-based web server to measure\n", progname);
  printf ("Usage:\n");
  printf ("   -h        show this help message and exit\n");
  printf ("   -p port   define listening port (default %d)\n", DEFAULT_PORT);
  printf ("   -c size   define the content size (default %d)\n", DEFAULT_SIZE);
}


/* Create a web servers listening on a given port */
int main (int argc, char * argv [])
{
  int option;

  char * address = "0.0.0.0";
  u_short port = DEFAULT_PORT;

  /* Notice the program name */
  progname = strrchr (argv [0], '/');
  progname = ! progname ? * argv : progname + 1;

  struct utsname machine;
  struct event_base * base;
  struct evhttp * httpd;

#define OPTSTRING "hp:c:"
  while ((option = getopt (argc, argv, OPTSTRING)) != EOF)
    {
      switch (option)
        {
        default: usage (progname); return 1;

        case 'h': usage (progname);   return 0;
        case 'p': port = atoi (optarg); break;
        case 'c': content_size = atoi (optarg); break;
	}
    }

  uname (& machine);
  nodename = fqname (machine . nodename);

  signal (SIGPIPE, SIG_IGN);              /* Ignore writes to connections that have been closed at the other end */

  /* Initialize a new event base */
  base = event_base_new ();

  /* Create a new web server and bind it to the given port */
  httpd = evhttp_new (base);
  evhttp_bind_socket (httpd, address, port);

  /* Register a generic callback */
  evhttp_set_gencb (httpd, notfound_cb, NULL);

  /* Register a homepage callback */
  evhttp_set_cb (httpd, "/", home_cb, NULL);

  printf ("%s: listening on *:%d\n", progname, port);

  /* Event dispatching loop */
  event_base_dispatch (base);

  return 0;
}
