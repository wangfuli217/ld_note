bin_PROGRAMS = seconds
seconds_SOURCES = main.c
seconds_CPPFLAGS = -I$(top_srcdir)/include
seconds_LDADD = ../lib/libmylib.la

clean:
	rm -f *.o Makefile.in

dist-clean:
	rm -rf *.o Makefile.in .libs .deps
