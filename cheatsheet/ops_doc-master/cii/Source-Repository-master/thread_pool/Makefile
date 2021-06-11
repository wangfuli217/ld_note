all:
	gcc -g ./src/main_server.c \
		./src/parser.c \
		./src/thread_pool.c \
		./src/semi_generic_llist.c \
		./src/semi_generic_lqueue.c \
		-lpthread -DDEBUG -I ./include/ -o ./elf/server
	gcc -g ./src/main_client.c \
		-DDEBUG -I ./include/ -o ./elf/client
clean:
	rm ./elf/client ./elf/server ./elf/database
