# phony target
#  make -j8 and look

SUBDIR = foo bar hei
.PHONY : subdirs $(SUBDIR)

subdirs : $(SUBDIR)
$(SUBDIR) :
	$(MAKE) -C $@
# if make's order is  needed, can set like below
#foo : bar

#################
# make -j8 
#############
#$ make -f good.mk -j8
#$make -C foo
#$make -C bar
#$make -C hei
#$Hello foo!
#$Hello bar!
#$Hello hei!

#####################
## make
#####################
#$ make -f good.mk
#$make -C foo
#$Hello foo!
#$make -C bar
#$Hello bar!
#$make -C hei
#$Hello hei!

