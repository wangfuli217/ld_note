cc=gcc
CFLAGS=-I. -Wall -g
BIN=semtools
OBJS=SystemVSem.o semtools.o
$(BIN):$(OBJS)
	$(cc) $(CFLAGS) $^ -o $@
	
clean:
	rm *.o
