cc=gcc
CFLAGS=-I. -Wall -g
BIN=shm_writer_reader
OBJS=SystemVSem.o shm_writer_reader.o
$(BIN):$(OBJS)
	$(cc) $(CFLAGS) $^ -o $@
	
clean:
	rm *.o
