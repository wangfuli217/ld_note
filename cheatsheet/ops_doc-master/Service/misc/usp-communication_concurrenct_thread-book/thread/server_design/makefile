# Note, you must change the port to your unique port number (between 1000 and 2^16-1) based on your Student ID
PORT = 5709
PROGRAMS = client server3A server3B server3C
S = -std=c99 -ggdb

all: ${PROGRAMS}
test_all: test3A test3B test3C
#both: server client
3A: server3A client
3B: server3B client 
3C: server3C client

#server: server.c
#	gcc $S server.c -o server
server3A: server3A.c
	gcc $S server3A.c -lpthread -o server3A 
server3B: server3B.c
	gcc $S server3B.c -lpthread -o server3B
server3C: server3C.c
	gcc $S server3C.c -lpthread -o server3C

client: client.c Timer.o
	gcc $S client.c Timer.o -lpthread -o client
Timer.o: Timer.c Timer.h
	gcc -ggdb Timer.c -c

#test: both
#	server $(PORT) &
#	echo Starting client
#	client `hostname` $(PORT)
#	ls -lr Thread_*
#	du
test3A: 3A
	server3A $(PORT) &
	echo Starting client
	client `hostname` $(PORT)
test3B: 3B
	server3B $(PORT) &
	echo Starting client
	client `hostname` $(PORT)
test3C: 3C
	server3C $(PORT) &
	echo Starting client
	client `hostname` $(PORT)
clean:
	/bin/rm -rf $(PROGRAMS) Thread_* Timer.o
