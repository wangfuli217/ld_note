# configure.ac - Template to generate 'lb' configuration scripts
#
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#                          _ _
#                         | | |__
#                         | | '_ \
#                         | | |_) |
#                         |_|_.__/
#
# 'lb' is a Libevent-based benchmarking tool for HTTP servers
#
#               (C) Copyright 2009-2016
#  Rocco Carbone <rocco /at/ tecsiel /dot/ it>, Pisa, Italy
#
# Released under the terms of 3-clause BSD License.
# See included LICENSE file for details.
#
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#

AC_PREREQ([2.60])
AC_INIT([lb], [0.2.6], [rocco@tecsiel.it])
AC_CONFIG_SRCDIR([lb.h])
AC_CONFIG_MACRO_DIR([m4])

AM_INIT_AUTOMAKE(AC_PACKAGE_NAME, AC_PACKAGE_VERSION)
AM_CONFIG_HEADER(site-lb.h)

# Checks for programs
AC_PROG_LIBTOOL
AC_PROG_CC

# Pretend gcc warnings by default
if test "$GCC" = yes ; then
  CFLAGS="$CFLAGS -Wall"
fi

# Checks for header files
AC_CHECK_HEADERS(getopt.h)

# Checks for libevent-2.x build directory
#
# Because I am experimenting with features available only with libevent-2.x series
# and it is not already packaged on most distributions I will check for a local copy
# with the full build tree.
#
# I expect the libevent-2.x development tree in an given directory and I will check for
#  o directory and directory/.libs existence
#  o header files usability
#  o library usability

AC_MSG_CHECKING(for libevent-2.x)
AC_ARG_WITH([libevent],
            [AS_HELP_STRING([--with-libevent=DIR],
	    [use libevent build directory @<:@default=/usr/local/src/libevent-2.0.22-stable@:>@])],
            [EVENTDIR="$withval"],
            [EVENTDIR=/usr/local/src/libevent-2.0.22-stable])

# Check for the root libevent-2.x build directory
if test ! -d "$EVENTDIR" ; then
  AC_MSG_RESULT([no])
  AC_MSG_ERROR([Missing or illegal libevent-2.x build directory "EVENTDIR"; unable to proceed.])
fi

# Check for the libevent-2.x specific include directory
if test ! -d "$EVENTDIR/include/event2" ; then
  AC_MSG_RESULT([no])
  AC_MSG_ERROR([Uhmmm, it seems the directory you have specified is not for libevent-2.x series; unable to proceed.])
fi

# Attempt to compile a very simple C program to check for libevent-2.x headers usability
OLD_CFLAGS=$CFLAGS
CFLAGS="$CFLAGS -I$EVENTDIR -I$EVENTDIR/include"

AC_TRY_COMPILE([
#include "event2/event.h"
#include "event2/event_struct.h"
#include "event2/http.h"
#include "event2/http_struct.h"],
  [ ],
  [buildable=yes],
  [buildable=no])

if test $buildable = "no"; then
  AC_MSG_RESULT([no])
  AC_MSG_ERROR([libevent-2.x headers are not usable; unable to proceed.])
fi

# Check for libtool object directory existence as a syntom of library availability
if test ! -d "$EVENTDIR/$lt_cv_objdir" ; then
  AC_MSG_RESULT([no])
  AC_MSG_ERROR([Uhmmm, it seems your libevent-2.x development tree has not yet compiled; unable to proceed.])
fi

# Attempt to link a simple program with particular libevent-2.x functions to check for library usability
OLDLIBS=$LIBS
LIBS="$LIBS -L$EVENTDIR/$lt_cv_objdir -levent_extra -levent_core"
AC_TRY_LINK([
#include <stdio.h>
#include "event2/event.h"
#include "event2/event_struct.h"
#include "event2/http.h"
#include "event2/http_struct.h"],
  [
   evtimer_assign (NULL, NULL, NULL, NULL);
   evhttp_connection_base_new (NULL, NULL, NULL, 0);
  ],
  [linkable=yes],
  [linkable=no])

if test $linkable = "no"; then
  AC_MSG_RESULT([no])
  AC_MSG_ERROR([Cannot link libevent-2.x library; unable to proceed.])
else
  AC_MSG_RESULT([yes])
fi

CFLAGS=$OLD_CFLAGS
LIBS=$OLD_LIBS

# Checks for system libraries
AC_SEARCH_LIBS([socket], [socket])
AC_SEARCH_LIBS([inet_addr], [nsl])
AC_SEARCH_LIBS([clock_gettime], [rt])

echo "#define VERSION \"$VERSION\"" > version-lb.h

AC_SUBST(PACKAGE_VERSION)
AC_SUBST(EVENTDIR)
AC_SUBST(LIBS)

AC_CONFIG_FILES([Makefile README])

AC_OUTPUT
