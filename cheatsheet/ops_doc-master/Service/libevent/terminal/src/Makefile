LIBEVENT_HOME = /usr/local/libevent
CC = gcc

CFLAGS := -I$(LIBEVENT_HOME)/include

LIBS := $(LIBS) -L$(LIBEVENT_HOME)/lib -levent -lpthread

### Complie Rules. ###
.c.o:
	$(CC) $(CFLAGS) -g -Wall -o3 -c -o $@ $< 
.cc.o:
	$(CXX) $(CFLAGS) -g -Wall -o3 -c -o $@ $<

TARGET = terminal index_create

### Objects. ###
OBJS1 = crc64.o hdict.o connection.o connection_queue.o network.o util.o terminal.o
OBJS2 = idx_create.o crc64.o util.o

all : $(TARGET)

terminal : $(OBJS1)
	$(CC) $(CFLAGS) -o $@ $(OBJS1) $(LIBS)

index_create : $(OBJS2)
	$(CC) $(CFLAGS) -o $@ $(OBJS2) $(LIBS)


### Clean. ###
clean:
	rm -f $(TARGET) *.o *.a tags
