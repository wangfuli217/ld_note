TEST  = automatic
TEST += standard
TEST += expand
TEST += substitute


# set environment variables
FOO = "FOO from shell"
BAR = "BAR from shell"
export FOO BAR

all:
	@for i in $(TEST) ; do \
        if test $$i = expand ; then \
            make -sf Makefile.$$i all SIMPLY=0 FOO="FOO from argument" ; \
            make -sf Makefile.$$i all SIMPLY=1 ; \
        else \
            make -sf Makefile.$$i all ; \
        fi ; \
    done

