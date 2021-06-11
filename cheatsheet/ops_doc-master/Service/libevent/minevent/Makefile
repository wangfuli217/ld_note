CFLAGS = -Wall -g -O0

all:
	gcc ${CFLAGS} -I ./include -c src/event.c
	gcc ${CFLAGS} -I ./include -c src/epoll.c
	mkdir ./lib 2> /dev/null
	ar rcs ./lib/libminevent.a event.o epoll.o

clean:
	rm -rf *.o *.fifo ./lib/*.a ./lib
