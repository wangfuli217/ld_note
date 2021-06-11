include ../common.mk

OBJS =				recycle.o		\
				lookupa.o		\
				hashtab.o

all:				libjenkinshash.a

libjenkinshash.a:			$(OBJS)
				ar rc $@ $(OBJS)
				ranlib $@

clean:				
				rm -f *.o *.a

# DEPENDENCIES

recycle.o:			recycle.c standard.h recycle.h

lookupa.o: 			lookupa.c standard.h lookupa.h

hashtab.o: 			hashtab.c standard.h recycle.h lookupa.h hashtab.h

