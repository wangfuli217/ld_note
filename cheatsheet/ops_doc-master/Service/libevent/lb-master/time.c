/*
 * time.c - Panta rhei, "everything is in a state of flux"
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


/* Operating System header file(s) */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include <ctype.h>


/* Useful defines */
#define USEC_PER_SEC   1000000
#define USEC_PER_MIN   (USEC_PER_SEC  * SECS_PER_MIN)
#define USEC_PER_HOUR  (SECS_PER_HOUR * USEC_PER_SEC)
#define MSEC_PER_SEC   1000
#define SECS_PER_MIN   60
#define SECS_PER_HOUR  (60 * SECS_PER_MIN)
#define SECS_PER_DAY   (24 * SECS_PER_HOUR)


/* Return 't' in days */
static time_t days (time_t t)
{
  return (t / (MSEC_PER_SEC * SECS_PER_DAY));
}


/* Return 't' in hours */
static time_t hours (time_t t)
{
  return (t / (MSEC_PER_SEC * SECS_PER_HOUR)) % 24;
}


/* Return 't' in minutes */
static time_t mins (time_t t)
{
  return (t / (MSEC_PER_SEC * 60)) % 60;
}


/* Return 't' in seconds */
static time_t secs (time_t t)
{
  return (t / MSEC_PER_SEC) % SECS_PER_MIN;
}


/* Return 't' in milliseconds */
static time_t msecs (time_t t)
{
  return t % MSEC_PER_SEC;
}


/* Return 't' in microseconds */
static time_t usecs (time_t t)
{
  return t % USEC_PER_SEC;
}


/* Convert a timeval to microseconds */
double tvtof (const struct timeval * tv)
{
  return (double) tv -> tv_sec * 1000000 + tv -> tv_usec;
}


/* Convert back a double to timeval (seconds and microseconds) */
struct timeval * ftotv (double usecs)
{
  static struct timeval tv;

  tv . tv_sec  = usecs / 1000000;
  tv . tv_usec = usecs - (double) tv . tv_sec * 1000000;

  return & tv;
}


/* Convert a time in microseconds to a string */
char * ftoa (double t)
{
  static char buf [20];

  struct timeval * tv = ftotv (t);

  sprintf (buf, "%ld.%ld", tv -> tv_sec, tv -> tv_usec);

  return buf;
}


/* The time since 'tv' in milliseconds */
double tvtomsecs (struct timeval * tv)
{
  return (double) tv -> tv_sec * 1000.0 + tv -> tv_usec / 1000.0;
}


/* Return a well formatted string for 'tv' at millisecond resolution */
char * tvtoa (struct timeval * tv)
{
#define VPROWS 10
#define VPCOLS 64

  static char text [VPROWS] [VPCOLS];
  static int i = 0;

  char * p = text [i];

  /* Compute tv in milliseconds */
  time_t t = tvtomsecs (tv);

  time_t d = days (t);
  time_t h = hours (t);
  time_t m = mins (t);
  time_t s = secs (t);
  time_t l = msecs (t);

  if (d)
    {
      if (l)
	sprintf (p, "%ld day%s, %02ld:%02ld:%02ld.%03ld", d, d > 1 ? "s" : "", h, m, s, l);
      else
	sprintf (p, "%ld day%s, %02ld:%02ld:%02ld", d, d > 1 ? "s" : "", h, m, s);
    }
  else if (h)
    {
      if (l)
	sprintf (p, "%02ld:%02ld:%02ld.%03ld hour%s", h, m, s, l, h > 1 ? "s" : "");
      else
	sprintf (p, "%02ld:%02ld:%02ld hour%s", h, m, s, h > 1 ? "s" : "");
    }
  else if (m)
    {
      if (l)
	sprintf (p, "%02ld:%02ld.%03ld min%s", m, s, l, m > 1 ? "s" : "");
      else
	sprintf (p, "%02ld:%02ld min%s", m, s, m > 1 ? "s" : "");
    }
  else if (s)
    {
      if (l)
	sprintf (p, "%ld.%03ld sec%s", s, l, s > 1 ? "s" : "");
      else
	sprintf (p, "%ld sec%s", s, s > 1 ? "s" : "");
    }
  else if (l)
    sprintf (p, "%ld msec%s", l, l > 1 ? "s" : "");
  else
    sprintf (p, "%ld usecs", usecs (tv -> tv_usec));

  /* Next index */
  i = (i + 1) % VPROWS;

  return p;
}


/* Return a well formatted string for 't' passed at second resolution */
char * secstoa (time_t t)
{
  struct timeval tv = { t, 0 };
  return tvtoa (& tv);
}


/* Return a well formatted string for 't' passed at millisecond resolution */
char * msecstoa (time_t t)
{
  struct timeval tv = { t / 1000, t % 1000 * 1000 };
  return tvtoa (& tv);
}


/* Return a well formatted string with time at millisecond resolution */
char * tvtodate (struct timeval * tv)
{
#define VPROWS 10
#define VPCOLS 64

  static char text [VPROWS] [VPCOLS];
  static int i = 0;

  char * p = text [i];

  time_t abst = tv -> tv_sec;

  sprintf (p, "%24.24s %ld", ctime (& abst), tv -> tv_usec);

  /* Next index */
  i = (i + 1) % VPROWS;

  return p;
}


/* The time difference in microseconds */
time_t delta_usecs (struct timeval * t2, struct timeval * t1)
{
  /* Compute delta in second and 1/1000000's second units */
  time_t delta_secs  = t2 -> tv_sec - t1 -> tv_sec;
  time_t delta_usecs = t2 -> tv_usec - t1 -> tv_usec;

  if (delta_usecs < 0)
    -- delta_secs,
      delta_usecs += 1000000;     /* manually carry a one from the seconds field */
  return delta_secs * 1000000 + delta_usecs;
}


/* The time difference in milliseconds */
time_t delta_msecs (struct timeval * t2, struct timeval * t1)
{
  /* Compute delta in second and 1/1000's second units */
  time_t delta_secs  = t2 -> tv_sec - t1 -> tv_sec;
  time_t delta_msecs = (t2 -> tv_usec - t1 -> tv_usec) / 1000;

  if (delta_msecs < 0)
    {
      -- delta_secs,
	delta_msecs += 1000;     /* manually carry a one from the seconds field */
    }
  return delta_secs * 1000 + delta_msecs;
}


/* The time difference in seconds */
time_t delta_secs (struct timeval * t2, struct timeval * t1)
{
  /* Compute delta in second */
  return t2 -> tv_sec - t1 -> tv_sec;
}


/* Time difference in days */
static int dt_days (time_t t1, time_t t2)
{
  return (t2 - t1) / SECS_PER_DAY;
}


/* Time difference in hours */
static int dt_hours (time_t t1, time_t t2)
{
  return (t2 - t1 - (dt_days (t1, t2) * SECS_PER_DAY)) / SECS_PER_HOUR;
}


/* Time difference in minutes */
static int dt_mins (time_t t1, time_t t2)
{
  return (t2 - t1 - (dt_days (t1, t2) * SECS_PER_DAY) - (dt_hours (t1, t2) * SECS_PER_HOUR)) / SECS_PER_MIN;
}


/* Time difference in seconds */
static int dt_secs (time_t t1, time_t t2)
{
  return (t2 - t1) % SECS_PER_MIN;
}


/* Tell how long the program has been running in a format suitable for best terminal rendering */
char * tvtouptime (struct timeval * tv)
{
  static char text [64];

  struct timeval now;
  gettimeofday (& now, NULL);

  /* Compute time differences at different resolution to evaluate the uptime */
  int d = dt_days (tv -> tv_sec, now . tv_sec);
  int h = dt_hours (tv -> tv_sec, now . tv_sec);
  int m = dt_mins (tv -> tv_sec, now . tv_sec);
  int s = dt_secs (tv -> tv_sec, now . tv_sec);

  if (d)
    sprintf (text, "%3d day%s, %2d:%02d:%02d", d, d > 1 ? "s" : "", h, m, s);
  else
    sprintf (text, "%2d:%02d:%02d.%06ld", h, m, s, now . tv_usec);

  return text;
}


/* Calculate in t the time difference in usec */
void tvdelta (struct timeval * t2, struct timeval * t1, struct timeval * t)
{
  t -> tv_sec  = t2 -> tv_sec - t1 -> tv_sec;
  t -> tv_usec = t2 -> tv_usec - t1 -> tv_usec;
  if (t -> tv_usec < 0)
    t -> tv_sec --,
      t -> tv_usec += 1000000;
}


/* Initialize a struct timeval by converting given minutes in seconds */
void minstotv (time_t mins, struct timeval * tv)
{
  tv -> tv_sec  = mins * 60;
  tv -> tv_usec = 0;
}


/* Initialize a struct timeval by converting given seconds */
void secstotv (time_t secs, struct timeval * tv)
{
  tv -> tv_sec  = secs;
  tv -> tv_usec = 0;
}


/* Initialize a struct timeval by converting milliseconds */
void msecstotv (time_t msecs, struct timeval * tv)
{
  tv -> tv_sec  = msecs / 1000;
  tv -> tv_usec = msecs % 1000 * 1000;
}


/* Convert a double representing a time in microseconds to back into seconds and microseconds */
void usecstotv (double usecs, struct timeval * tv)
{
  tv -> tv_sec  = usecs / 1000000;
  tv -> tv_usec = (double) (usecs / 1000000) * 1000000;
}


/* Is the string passed by 's' numeric? */
static int isnumeric (char * s)
{
  if (! s || ! * s)
    return 0;

  while (* s)
    if (! isdigit ((int) * s ++))
      return 0;

  return 1;
}


/* Check for a legal timeout string and return its value in milliseconds or -1 for errors;
 * legal syntax is:
 * value[l]  with value expressed in milliseconds
 * value     with value expressed in seconds       (default suffix specification)
 * value[s]  with value expressed in seconds
 * value[m]  with value expressed in minutes
 * value[h]  with value expressed in hours
 */
time_t atomsec (char * value)
{
  int items;
  char digits [256];
  char suffix [256];
  time_t timeout;

  /* Lookup for a valid syntax */
  items = sscanf (value, "%[0-9]%[a-z]", digits, suffix);
  if (items == 2 && strlen (suffix) == 1)
    {
      switch (* suffix)
	{
	case 'l': timeout = atoi (digits);                  break;  /* do not convert       */
	case 's': timeout = atoi (digits) * 1000;           break;  /* convert from seconds */
	case 'm': timeout = atoi (digits) * 1000 * 60;      break;  /* convert from minutes */
	case 'h': timeout = atoi (digits) * 1000 * 60 * 60; break;  /* convert from hours   */
	default:  timeout = -1; break;
	}
      /* Check for trailing characters */
      if (timeout != -1 && strlen (value) != strlen (digits) + strlen (suffix))
	timeout = -1;
    }
  else if (items == 1 && isnumeric (digits) && strlen (digits) == strlen (value))
    timeout = atoi (digits) * 1000;                                /* convert to milliseconds (default) */
  else
    timeout = -1;

  return timeout;
}
