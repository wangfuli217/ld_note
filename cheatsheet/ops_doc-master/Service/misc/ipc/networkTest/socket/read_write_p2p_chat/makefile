cc=gcc
CFLAGS=-I. -Wall -g -lrt
BIN=cs_p2p
OBJS=cs_p2p.o client_api.o server_api.o
$(BIN):$(OBJS)
	$(cc) $(CFLAGS) $^ -o $@
	
clean:
	rm *.o $(BIN) 
