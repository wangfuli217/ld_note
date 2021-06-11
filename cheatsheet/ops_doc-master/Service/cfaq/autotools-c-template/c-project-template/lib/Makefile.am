lib_LTLIBRARIES = libmylib.la
libmylib_la_SOURCES = get_sec_since_epoch.c bye.c hello.c here.c
libmylib_la_CPPFLAGS = -I$(top_srcdir)/include

clean:
	rm -f *.o *.lo Makefile.in

dist-clean:
	rm -rf *.o *.lo .la  Makefile.in .deps .libs
