cc=gcc
CFLAGS=-I. -lrt -Wall -g
BIN=shm_writer_reader 
OBJS=shm_writer_reader.o 
$(BIN):$(OBJS)
	$(cc) $(CFLAGS) $^ -o $@

clean:
	rm *.o
