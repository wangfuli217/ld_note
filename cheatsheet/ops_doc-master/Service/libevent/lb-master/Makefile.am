#
# Build everything related to the 'lb' benchmarking tool
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
#         Rocco Carbone <rocco /at/ tecsiel /dot/ it>
#
# Released under the terms of 3-clause BSD License.
# See included LICENSE file for details.
#
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#

VERSION=@PACKAGE_VERSION@

# This option allows to distribute the LICENSE file instead of COPYING
AUTOMAKE_OPTIONS = foreign
ACLOCAL_AMFLAGS  = -I m4

MAINTAINERCLEANFILES = Makefile.in aclocal.m4 \
                       config.guess config.h.in \
                       config.sub configure compile \
                       depcomp install-sh \
                       ltconfig ltmain.sh \
                       missing libtool.m4 m4 \
                       site-lb.h.in version-lb.h

EXTRA_DIST       = AUTHORS Autogen.sh ChangeLog FEATURES \
                   INSTALL LICENSE MANIFEST Makefile.am \
                   NEWS README SAMPLE-OUTPUT TODO \
                   autogen.sh aclocal.m4 bench-lb.sh \
                   configure.ac lb.8 lb.servers site-lb.h.in

# Where the Libevent has been compiled
EVENTDIR         = @EVENTDIR@
EVENTINC         = -I${EVENTDIR} -I${EVENTDIR}/include
EVENTLIB         = ${EVENTDIR}/libevent_extra.la ${EVENTDIR}/libevent_core.la

# C compiler flags
AM_CFLAGS        = ${EVENTINC}

# Required Operating System libraries
LIBS             = @LIBS@

noinst_HEADERS   = lb.h
noinst_PROGRAMS  = lb wsl nb cb

# The 'lb' benchmark tool
lb_SOURCES       = lb.c callbacks.c requests.c servers.c slurp.c uri.c utils.c time.c varrays.c
lb_DEPENDENCIES  = ${EVENTLIB}
lb_LDADD         = ${EVENTLIB} ${LIBS}
lb_LDFLAGS       = -static

# The minimal web server for testing
wsl_SOURCES      = wsl.c
wsl_DEPENDENCIES = ${EVENTLIB}
wsl_LDADD        = ${EVENTLIB} ${LIBS}
wsl_LDFLAGS      = -static

# A very fast HTTP client - libevent-2.0.22-stable/test/bench_httpclient.c
nb_SOURCES       = nb.c time.c
nb_DEPENDENCIES  = ${EVENTLIB}
nb_LDADD         = ${EVENTLIB} ${LIBS}
nb_LDFLAGS       = -static

# The ab program modified by Adrian Chadd - http://code.google.com/p/apachebench-adrian
cb_SOURCES       = cb.c
cb_DEPENDENCIES  = ${EVENTLIB}
cb_LDADD         = ${EVENTLIB} ${LIBS} -lm
cb_LDFLAGS       = -static

DISTCLEANFILES   = ${MAINTAINERCLEANFILES} *~ bench-lb.log

distrib:
	@make -k distclean > /dev/null
	@rm -rf autom4te.cache version-lb.h
	@(cd ../ && \
          rm -f lb-${VERSION} && \
          ln -s lb lb-${VERSION} && \
          tar chfz lb-${VERSION}.tar.gz lb-${VERSION} && \
          rm -f lb-${VERSION} && \
          mv lb-${VERSION}.tar.gz lb/)
