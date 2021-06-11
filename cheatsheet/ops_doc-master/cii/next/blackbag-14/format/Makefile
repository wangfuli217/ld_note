TOP = ..

include ../common.mk

OBJS =				fmt.o		\
				fmt-time.o	\
				build.o

all:				libfmt.a

libfmt.a:			$(OBJS)
				ar rc $@ $(OBJS)
				ranlib $@

clean:				
				rm -f *.o *.a

