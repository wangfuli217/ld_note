TEST  = subst
TEST += strip
TEST += filter
TEST += filename

all:
	@for i in $(TEST) ; do \
        make -sf Makefile.$$i ; \
    done