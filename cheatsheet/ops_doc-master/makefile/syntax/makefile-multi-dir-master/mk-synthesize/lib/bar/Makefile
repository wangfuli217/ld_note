# A simple Makefile for lib(libxxx.a) 
# By Late Lee(http://www.latelee.org) 
AR = ar
ARFLAGS = cr
LIB = libbar.a
RM = -rm -rf
OBJS := bar.o common.o
all: $(LIB)
$(LIB): $(OBJS)
	$(AR) $(ARFLAGS) $@ $(OBJS)
clean:
	$(RM) $(OBJS) $(LIB) *.bak *~
.PHONY: all clean
