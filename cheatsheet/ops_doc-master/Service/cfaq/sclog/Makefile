CC = gcc
DEBUG = -Wall -ggdb2
LIB = -lpthread
RUN = $(CC) $(DEBUG) -o $@ $^
RUO = $(CC) -c -o $@ $^

# create main.out run file
main.out:main.o sclog.o schead.o
	$(RUN) $(LIB)

# create object file
%.o:%.c
	$(RUO)

# clean file
clean:
	rm -rf *.o *.i *.s *.out *~ __* logs ; ls -la
