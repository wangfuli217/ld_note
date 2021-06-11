cc=gcc
CFLAGS=-I. -lrt -Wall -g 
OBJECTS=mq_tools.o
BIN=mq_tools
$(BIN):$(OBJECTS)
	$(cc) $(CFLAGS) $^ -o $@

clean:
	rm *.o $(BIN) 
