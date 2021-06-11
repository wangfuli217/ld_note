/*
 * varrays.c - Utilities to handle vectors of pointers to void objects
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


/* Operating System header file(s) */
#include <stdlib.h>
#include <string.h>


/* Check and free a pointer */
void * safefree (void * a)
{
  if (a) free (a);
  return NULL;
}


/* Check, free and duplicate a pointer */
void * safedup (void * a, void * b)
{
  safefree (b);
  return a ? strdup (a) : a;
}


/* Return the # of items in the array */
int valen (void * argv [])
{
  int argc = 0; while (argv && * argv ++) argc ++; return argc;
}


/* Add an item to the array */
void ** vamore (void * argv [], void * item)
{
  if (item)
    {
      int argc = valen (argv);
      argv = realloc (argv, (1 + argc + 1) * sizeof (void **));
      if (! argv)
	return NULL;
      argv [argc ++] = item;
      argv [argc]    = NULL;         /* make the array NULL terminated */
    }
  return argv;
}


/* Lookup by reference for an item into the array */
int valookup (void * argv [], void * item)
{
  int found = 0;

  while (argv && * argv)
    if (* argv ++ == item)
      return found;
    else
      found ++;

  return -1;
}


/* Remove an item from the array */
void ** valess (void * argv [], void * item, void (* rmitem) (void *))
{
  int i;
  int j;
  int argc = valen (argv);

  if ((i = valookup (argv, item)) != -1)
    {
      if (rmitem)
	rmitem (argv [i]);               /* free the descriptor */
      for (j = i; j < argc - 1; j ++)    /* move pointers back one position */
        argv [j] = argv [j + 1];

      argv [j] = NULL;                   /* terminate the array */

      if (argc > 1)
        argv = realloc (argv, argc * sizeof (void *));
      else
        free (argv);
    }

  return argc > 1 ? argv : NULL;
}


/* Cleanup the array */
void ** vacleanup (void * argv [], void (* rmitem) (void *))
{
  void ** r = argv;
  while (r && * r)
    {
      if (rmitem)
	rmitem (* r);
      r ++;
    }
  safefree (argv);
  return NULL;
}


/* Duplicate the NULL terminated array 'argv' */
void ** vadup (void * argv [], int size)
{
  void ** dup = NULL;
  while (argv && * argv)
    {
      void * more = calloc (size, 1);
      memcpy (more, * argv ++, size);
      dup = vamore (dup, more);
    }

  return dup;
}


/* Add an item to the array */
char ** argsadd (char * argv [], char * item)
{
  return (char **) vamore ((void **) argv, item);
}


/* Free the whole array */
char ** argsfree (char * argv [])
{
  return (char **) vacleanup ((void **) argv, NULL);
}


/* Lookup for an item in the array */
char * argsfind (char * argv [], char * item)
{
  while (argv && * argv)
    if (! strncmp (item, * argv ++, strlen (item)))
      return -- * argv;
  return NULL;
}
