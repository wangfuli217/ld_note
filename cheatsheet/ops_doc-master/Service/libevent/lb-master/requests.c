/*
 * requests.c - Utilities to keep in memory libevent-based HTTP requests
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
 *                  (C) Copyright 2009-2016
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


/* Allocate a new request for an outgoing benchmark activity */
req_t * mkreq (struct event_base * base, server_t * server)
{
  req_t * request = calloc (sizeof (req_t), 1);

  /* Define a new connection with the HTTP server/proxy */
  if (! server -> proxyname)
    request -> evcon = evhttp_connection_base_new (base, NULL, server -> uri -> hostname, atoi (server -> uri -> port));
  else
    request -> evcon = evhttp_connection_base_new (base, NULL, server -> proxyname, server -> proxyport);

  /* Sets the timeout for events related to this connection */
  evhttp_connection_set_timeout (request -> evcon, server -> reply_tv . tv_sec);

  /* Sets the retry limit for this connection - -1 repeats indefinitely */
  evhttp_connection_set_retries (request -> evcon, server -> maxretry);

  return request;
}


/* Initialize a new request for an outgoing benchmark activity */
void initreq (req_t * request, struct event_base * base, server_t * server)
{
  char ** p;

  /* Bind the server to the request */
  request -> server = server;

  /* Creates a new request object that needs to be filled in with the request parameters */
  request -> evreq = evhttp_request_new (reply_cb, request);

  /* Unconditionally add all user-defined headers */
  p = run -> headers;
  while (p && * p)
    {
      char key [256] = "";
      char * val = strchr (* p, ':');
      strncpy (key, * p, val - * p);
      evhttp_add_header (request -> evreq -> output_headers, key, val + 1);
      p ++;
    }

  /* Conditionally add "Host:", "User-Agent:" and "Accept:" standard headers (if not overriden by the user) */
  if (! argsfind (run -> headers, "Host:"))
    {
      char address [256];
      sprintf (address, "%s:%s", server -> uri -> hostname, server -> uri -> port);
      evhttp_add_header (request -> evreq -> output_headers, "Host", address);
    }

  if (! argsfind (run -> headers, "User-Agent:"))
    evhttp_add_header (request -> evreq -> output_headers, "User-Agent", DEFAULT_USERAGENT);

  if (! argsfind (run -> headers, "Accept:"))
    evhttp_add_header (request -> evreq -> output_headers, "Accept", DEFAULT_ACCEPT);

  /* Handle keepalive connection */
  if (server -> keepalive)
    evhttp_add_header (request -> evreq -> output_headers, "Connection", "Keep-Alive");

  /* Basic Authentication */
  if (server -> uri -> userid && server -> uri -> passwd)
    {
      char auth [512] = "";
      char encoded [512] = "";

      sprintf (auth, "%s:%s", server -> uri -> userid, server -> uri -> passwd);
      ato64 (auth, encoded);

      sprintf (auth, "Basic %s", encoded);
      evhttp_add_header (request -> evreq -> output_headers, "Authorization", auth);
    }

  /* Proxy Basic Authentication */
  if (server -> authproxy)
    {
      char auth [512] = "";
      char encoded [512] = "";

      ato64 (server -> authproxy, encoded);

      sprintf (auth, "Basic %s", encoded);
      evhttp_add_header (request -> evreq -> output_headers, "Proxy-Authorization", auth);
    }

  /* Unconditionally add all user-defined cookies */
  p = run -> cookies;
  while (p && * p)
    evhttp_add_header (request -> evreq -> output_headers, "Cookie", * p ++);

  /* Set the time the request was started */
  gettimeofday (& request -> started, NULL);
}


/* Free allocated memory used to keep a HTTP request */
void rmreq (void * req)
{
  req_t * r = (req_t *) req;
  if (! r)
    return;

  /* Free the http connection */
  if (r -> evcon)
    evhttp_connection_free (r -> evcon);

  free (r);
}


/* Add an item to the array */
req_t ** morereq (req_t * argv [], req_t * item)
{
  return (req_t **) vamore ((void **) argv, item);
}


/* Remove an item from the array */
req_t ** lessreq (req_t * argv [], req_t * item, void (* rmitem) (void *))
{
  return (req_t **) valess ((void **) argv, item, rmitem);
}


/* Free the whole array */
req_t ** cleanupreq (req_t * argv [], void (* rmitem) (void *))
{
  return (req_t **) vacleanup ((void **) argv, rmitem);
}


/* Lookup for the first available item into the array */
req_t * nextreq (req_t * argv [])
{
  while (argv && * argv)
    if (! (* argv) -> server)
      return * argv;
    else
      argv ++;

  return NULL;
}
