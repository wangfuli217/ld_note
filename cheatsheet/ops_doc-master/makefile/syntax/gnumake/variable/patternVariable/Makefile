# PATTERN : VARIABLE-ASSIGNMENT
# PATTERN : override VARIABLE-ASSIGNMENT

%.o : CFLAGS+=-O

foo.o : foo.c
	echo $(CFLAGS)
	$(CC) $(CFLAGS) -c -o $@ $<


# a TEST
# i cannot understand the result of TEST2 :
# $make TEST=B TEST2=b
# $echo B A
# $B A
# $echo b b  ----------- why ?????
# $b b
#%.o : override TEST += A
#%.o : TEST2 += a
#foo.o : foo.c
#	echo $(TEST)
#	echo $(TEST2)
