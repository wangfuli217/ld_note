cc=gcc
CFLAGS=-I. -Wall -g
objs=shm_writer_reader.o SystemVSem.o
BIN=shm_writer_reader 
$(BIN):$(objs)
	$(cc) $(CFLAGS)  $^ -o $@

clean:
	rm -f *.o 
