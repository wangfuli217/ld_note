#include <stdio.h>	/* just for sprintf */
#include <stddef.h>
#include <time.h>

/*
 *  Time formatting function.
 *  See X3.159 Sec. 4.12.3.5 pp. 175-6
 *
 *  Any modern C implementation will of course come with an
 *  official implementation of strftime() in its library.
 *  The reasons for writing one from scratch, like this, are:
 *
 *	in case we're still stuck with an antique, pre-ANSI C library
 *
 *	so that we can have a "chapter 1" command line callable version
 *	(though that's hardly a reason, since for that we just need the
 *	little main() function at the end, not the whole strftime()
 *	reimplementation)
 *
 *	because it's at least a little tricky, and interesting,
 *	to find a clean way of implementing all the formatting options
 *
 *	so that we can eventually add all sortsa nifty extensions
 *	(also known as ghastly creeping features)...
 *
 *  I suppose it's worth saying a few words about the particular
 *  "tricky" and/or "interesting" and/or "clean way of
 *  implementing all the formatting options" which is seen here.
 *  It treads, I admit, a pretty fine line between "appropriate
 *  engineering solution" and "neat hack" and "preprocessor abuse"
 *  and "ugly kludge".
 *
 *  The Putch(), Putstr(), Putstrn(), Printf(), and Recur() macros,
 *  with their quasi function-like nature and their hidden gotos,
 *  are certainly questionable.  They do, however, rather nicely
 *  encapsulate (or at least hide) what would otherwise be a
 *  pervasive and districting complication, namely the requirement
 *  never to overflow the destination buffer.  So I feel that they're
 *  justified in this case, but if your esthetic says otherwise,
 *  I won't argue with you (although I might ask how you'd handle
 *  the overrun tests).
 *
 *  Finally, though I am offering this file up as a model of good code,
 *  I would not want to give the impression that SLM's (silly little
 *  macros) like these are always a good idea, because usually they're not.
 *
 *  Steve Summit
 *  scs@eskimo.com
 *
 *  code first written 1992-07-22;
 *  this comment updated 2003-03-02
 *
 *  See http://www.eskimo.com/~scs/src/#strftime for possible updates.
 *  You might also be interested in the `dateexpr' program at
 *  http://www.eskimo.com/~scs/src/#dateexpr , which contains an
 *  expanded version of this code incorporating quite a few of those
 *  nifty extensions / creeping features.
 *
 *  This source file is released to the Public Domain.
 */

#ifndef __STDC__
#define const
#endif

/* these should be locale-specific */
/* (also would be nice to share with ctime's) */

static const char *weekdays[] =
	{
	"Sunday",
	"Monday",
	"Tuesday",
	"Wednesday",
	"Thursday",
	"Friday",
	"Saturday",
	};

static const char *months[] =
	{
	"January",
	"February",
	"March",
	"April",
	"May",
	"June",
	"July",
	"August",
	"September",
	"October",
	"November",
	"December",
	};

size_t
strftime(s, maxsize, format, timeptr)
char *s;
size_t maxsize;
const char *format;
const struct tm *timeptr;
{
register char *fp = format;
register char *dp = s;
register size_t ret = 0;

if(format == NULL || s == NULL || maxsize <= 0)
	return 0;

#define Putch(c) (ret < maxsize ? (*dp++ = (c), ret++) : 0)

while(*fp != '\0')
	{
	char *p;
	int len;
	char tmpbuf[10];

	if(*fp != '%')
		{
		Putch(*fp++);
		continue;
		}

	fp++;

	switch(*fp)
		{

#define Putstr(str) p = str; goto dostr

#define Putstrn(str, n) p = str; len = n; goto dostrn

#define Printf(fmt, arg) sprintf(tmpbuf, fmt, arg); p = tmpbuf; goto dostr

#define Recur(fmt)	{						     \
			size_t r = strftime(dp, maxsize - ret, fmt, timeptr); \
									     \
			if(r <= 0)					     \
				return r;				     \
									     \
			dp += r;					     \
			ret += r;					     \
			}

		case 'a':	/* locale's abbreviated weekday name */
			Putstrn(weekdays[timeptr->tm_wday], 3);
			break;

		case 'A':	/* locale's full weekday name */
			Putstr(weekdays[timeptr->tm_wday]);
			break;

		case 'b':	/* locale's abbreviated month name */
			Putstrn(months[timeptr->tm_mon], 3);
			break;

		case 'B':	/* locale's full month name */
			Putstr(months[timeptr->tm_mon]);
			break;

		case 'c':	/* appropriate date and time representation */
			Recur("%X %x");		/* s.b. locale-specific */
			break;

		case 'd':	/* day of month as decimal number (01-31) */
			Printf("%02d", timeptr->tm_mday);
			break;

		case 'H':	/* hour (24-hour clock) as decimal (00-23) */
			Printf("%02d", timeptr->tm_hour);
			break;

		case 'I':	/* hour (12-hour clock) as decimal (01-12) */
			Printf("%02d", ((timeptr->tm_hour + 11) % 12) + 1);
			break;

		case 'j':	/* day of year as decimal number (001-366) */
			Printf("%03d", timeptr->tm_yday + 1);
			break;

		case 'm':	/* month as decimal number (01-12) */
			Printf("%02d", timeptr->tm_mon + 1);
			break;

		case 'M':	/* month as decimal number (00-59) */
			Printf("%02d", timeptr->tm_min);
			break;

		case 'p':	/* AM/PM designations (12-hour clock) */
			Putstr(timeptr->tm_hour < 12 ? "AM" : "PM");
						/* s.b. locale-specific */
			break;

		case 'S':	/* second as decimal number (00-61) */
			Printf("%02d", timeptr->tm_sec);
			break;

		case 'U':	/* week of year (first Sunday = 1) (00-53) */
		case 'W':	/* week of year (first Monday = 1) (00-53) */
			{
			int fudge = timeptr->tm_wday - timeptr->tm_yday % 7;
			if(*fp == 'W')
				fudge--;
			fudge = (fudge + 7) % 7;      /* +7 so not negative */
			Printf("%02d", (timeptr->tm_yday + fudge) / 7);
			break;
			}

		case 'w':	/* weekday (0-6), Sunday is 0 */
			Printf("%02d", timeptr->tm_wday);
			break;

		case 'x':	/* appropriate date representation */
			Recur("%B %d, %Y");	/* s.b. locale-specific */
			break;

		case 'X':	/* appropriate time representation */
			Recur("%H:%M:%S");	/* s.b. locale-specific */
			break;

		case 'y':	/* year without century as decimal (00-99) */
			Printf("%02d", timeptr->tm_year % 100);
			break;

		case 'Y':	/* year with century as decimal */
			Printf("%d", timeptr->tm_year + 1900);
			break;

		case 'Z':	/* time zone name or abbreviation */
			/* XXX %%% */
			break;

		case '%':
			Putch('%');
			break;

dostr:			while(*p != '\0')
				Putch(*p++);
			break;

dostrn:			while(len-- > 0)
				Putch(*p++);
			break;
		}

	fp++;
	}

if(ret >= maxsize)
	{
	s[maxsize - 1] = '\0';
	return 0;
	}

*dp = '\0';

return ret;
}

#ifdef MAIN

#include <stdlib.h>

#define FMTBUFSIZE 100

main(argc, argv)
int argc;
char *argv[];
{
int argi;
char *format;
time_t now;
struct tm *tmp;
char fmtbuf[FMTBUFSIZE];

argi = 1;

if(argi < argc && strcmp(argv[argi], "-t") == 0)
	{
	argi++;
	now = atol(argv[argi++]);
	}
else	now = time((time_t *)NULL);

if(argi < argc)
	format = argv[argi];
else	format = "%c";

tmp = localtime(&now);

strftime(fmtbuf, FMTBUFSIZE, format, tmp);

printf("%s\n", fmtbuf);

exit(0);
}

#endif
