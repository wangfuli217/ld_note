cc=gcc
CFLAGS=-I. -Wall -g -lrt
BIN=thread_pool_test
OBJS=thread_pool_test.o thread_pool.o condition.o
$(BIN):$(OBJS)
	$(cc) $(CFLAGS) $^ -o $@
	
clean:
	rm *.o $(BIN) 
