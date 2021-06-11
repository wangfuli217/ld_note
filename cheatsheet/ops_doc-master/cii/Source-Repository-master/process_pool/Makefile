all:
	gcc -g main_server.c ./parser.c ./semi_generic_llist.c -o server -DDEBUG
	gcc -g main_client.c -o client -DDEBUG
clean:
	rm server client 
