EXEF = foo
#override 
CFLAGS += -Wall -g

.PHONY : all debug test
all : $(EXEF)

foo : foo.c

# $(addsuffix .c,$@)
# add .c to $@
$(EXEF) : debug.h
	$(CC) $(CFLAGS) $(addsuffix .c,$@) -o $@

debug :
	@echo "$(CFLAGS) = "$(CFLAGS)

# make CFLAGS=-O2
# make CFLAGS=-O2 debug
# 去掉 override 再执行