# phony target
# not good
# call subdir Makefile
#	1) $$dir 
#	2) for xx in xxx; do XXXXX; done
#	3) this is a shell call, so cannot make by parallel --
SUBDIR = foo bar hei
.PHONY : subdir
subdir :
	@for dir in $(SUBDIR); do \
		$(MAKE) -C $$dir;	\
	done
