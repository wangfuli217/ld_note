/*
 * uri.c - Parse and split a string into URI components
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
#include <regex.h>


/* HTTP resource for URI syntax is [http[s]://[userid:passwd@]]host:port[/path] */
#define URIREGEX  "^((http|https)://)?((([_a-zA-Z0-9]+):([^/:]+)@))?([^/@]+)(:([1-9]+[0-9]*))+(.*)$"

#define DEFAULT_PORT  "80"
#define DEFAULT_PATH  "/"


#define NMATCHES 20

/* This function extracts the part of a string that was matched
 * by a regular expression as indicated by the regmatch_t argument.
 * New memory is allocated for a copy of the matched substring and
 * the new copy is null terminated.
 * This function returns NULL if the regmatch_t indicates that no match was made.
 */
static char * getmatch (regmatch_t m, const char * input)
{
  char * match = NULL;
  int len;

  /* Return NULL if no match specified */
  if (m . rm_so == -1)
    return NULL;

  /* len is the length of the substring that was matched */
  len = m . rm_eo - m . rm_so;

  /* Allocate enough memory for a copy of the resulting substring */
  match = (char *) malloc (len + 1);
  if (! match)
    return NULL;

  /* Copy the substring */
  strncpy (match, input + m . rm_so, len);

  /* Null terminate the copy of the substring! */
  match [len] = 0;

  return match;
}


/* Parse and split a string into URI pieces accondingly to 'regex' */
uri_t * splituri (char * name)
{
  regmatch_t matches [NMATCHES];   /* Where we will get the offsets of all matches */
  regex_t pattern;                 /* The buffer used to store the 'compiled' regular expression */

  uri_t * uri = NULL;

  /* Compile the regular expression (POSIX extended regular expression syntax) into a form suitable for subsequent searches */
  if (regcomp (& pattern, URIREGEX, REG_EXTENDED))
    return NULL;

  /* Search for matches */
  if (regexec (& pattern, name, NMATCHES, matches, 0) != REG_NOMATCH && (uri = calloc (sizeof (uri_t), 1)))
    {
      /* Match found */
      uri -> protocol = getmatch (matches [2], name);
      uri -> userid   = getmatch (matches [5], name);
      uri -> passwd   = getmatch (matches [6], name);
      uri -> hostname = getmatch (matches [7], name);
      uri -> port     = getmatch (matches [9], name);
      uri -> path     = getmatch (matches [10], name);

      if (uri -> protocol && ! * uri -> protocol)
	uri -> protocol = safefree (uri -> protocol);
      if (uri -> userid && ! * uri -> userid)
	uri -> userid = safefree (uri -> userid);
      if (uri -> passwd && ! * uri -> passwd)
	uri -> passwd = safefree (uri -> passwd);
      if (uri -> port && ! * uri -> port)
	uri -> port = safedup (DEFAULT_PORT, uri -> port);
      if (uri -> path && ! * uri -> path)
	uri -> path = safedup (DEFAULT_PATH, uri -> path);
    }

  regfree (& pattern);
  return uri;
}


/* Release memory associated to an URI */
void freeuri (uri_t * uri)
{
  if (! uri)
    return;

  safefree (uri -> protocol);
  safefree (uri -> userid);
  safefree (uri -> passwd);
  safefree (uri -> hostname);
  safefree (uri -> port);
  safefree (uri -> path);
  free (uri);
}
