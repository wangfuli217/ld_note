AUTOMAKE_OPTIONS = foreign

SUBDIRS = .

GENERAL_SRCS = bench-messages.c bench-log.c ssl-utils.c

noinst_HEADERS = bench-messages.h bench-log.h ssl-utils.h
client_SOURCES = bench-client.c $(GENERAL_SRCS)
server_SOURCES = bench-server.c $(GENERAL_SRCS)
client_CFLAGS = -I./compat $(LIBEVENT_CFLAGS) $(LIBEVENT_CFLAGS)
server_CFLAGS = -I./compat $(LIBEVENT_CFLAGS) $(LIBEVENT_CFLAGS)
client_LDADD = $(LIBEVENT_LIBS) $(LIBEVENT_SSL_LIBS)
server_LDADD = $(LIBEVENT_LIBS) $(LIBEVENT_SSL_LIBS)
bin_PROGRAMS = client server
