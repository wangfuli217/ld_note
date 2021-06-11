# Makefile Copyright 2008 Groetker, Holtmann, Keding, Wloka

include Makefile.include

DIRS = \
chapter03 \
chapter04 \
chapter05 \
chapter06 \
chapter07 \
chapter09 \
chapter10 \
chapter11 \
chapter12

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

