noinst_PROGRAMS = test

test_SOURCES = src/test.c
#test_INCLUDES = $(top_builddir)/tools_util/include $(top_builddir)/circle_buff/include
test_LDFLAGS = 
test_LDADD = -L$(top_builddir)/circle_buff -L$(top_builddir)/tools_util -lcircle_buff -ltools -lpthread -lrt 
test_CPPFLAGS = -Iinclude -I$(top_builddir)/tools_util/include/ -I$(top_builddir)/list/include/ -I$(top_builddir)/circle_buff/include/
