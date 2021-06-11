all:client	server
client:client.o
	gcc client.o -o client
client.o:client.c
	gcc -c	client.c
server:server.o  dao.o
	gcc server.o dao.o -o server
server.o:server.c
	gcc -c	server.c
dao.o:dao.c
	gcc -c dao.c
clean:
	rm *.o  client server  ./dao/*
