# A simple Makefile for lib(libxxx.a) 
# By Late Lee(http://www.latelee.org) 
AR = ar
ARFLAGS = cr
LIB = libfoo.a
RM = -rm -rf
OBJS := foo.o common.o
all: $(LIB)
$(LIB): $(OBJS)
	$(AR) $(ARFLAGS) $@ $(OBJS)
clean:
	$(RM) $(OBJS) $(LIB) *.bak *~
.PHONY: all clean
