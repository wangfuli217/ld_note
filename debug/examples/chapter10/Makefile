# Makefile Copyright 2008 Groetker, Holtmann, Keding, Wloka

include ../Makefile.include

DIRS = \
answer \
attach_debugger \
break_str \
break_template \
capitalize \
exception_catcher \
nodebug \
overload \
signal_catcher \
static_conflict

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
