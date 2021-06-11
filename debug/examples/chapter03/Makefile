# Makefile Copyright 2008 Groetker, Holtmann, Keding, Wloka

include ../Makefile.include

DIRS = \
factorial

all:
	@for i in $(DIRS);\
        do \
	cd $$i; $(MAKE); cd ..;\
	done

clean:
	@for i in $(DIRS);\
        do \
	cd $$i; $(MAKE) clean; cd ..;\
	done
	rm -rf $(CLEAN_TARGETS)
