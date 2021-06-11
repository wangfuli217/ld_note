# 
# TARGET ... : VARIABLE-ASSIGNMENT
# TARGET ... : override VARIABLE-ASSIGNMENT
# can use =  , += , := , ?=
# make -e 

foo : CFLAGS=-g
# foo : override CFLAGS=-g
foo : foo.c
	$(CC) $(CFLAGS) $(addsuffix .c,$@) -o $@
