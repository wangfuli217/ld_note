CUR_PWD := $(shell pwd)
INCS := $(CUR_PWD)/include
CFLAGS := -Wall -I$(INCS)
vpath %.h $(INCS)

EXEF := foo bar
.PHONY : all clean
all : $(EXEF)

foo : foo.c
foo : CFLAGS += -O2
bar : bar.c
bar : CFLAGS += -g

$(EXEF) : debug.h
	$(CC) $(CFLAGS) $(addsuffix .c,$@) -o $@

clean :
	$(RM) *.o $(EXEF)
