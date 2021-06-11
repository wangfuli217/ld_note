SUBDIRS = lib src

clean: 
	cd lib; make clean
	cd src; make clean

mostlyclean:
	cd lib;	make clean
	cd src;	make clean
	rm -rf compile config.* depcomp install-sh ltmain.sh libtool stamp-h1 main.sh autom4te.cache Makefile.in missing aclocal.m4 Automake.am

dist-clean:
	cd lib; make dist-clean
	cd src; make dist-clean
	rm -rf compile config.* depcomp install-sh ltmain.sh libtool stamp-h1 main.sh autom4te.cache Makefile.in missing aclocal.m4 Makefile configure Automake.am
