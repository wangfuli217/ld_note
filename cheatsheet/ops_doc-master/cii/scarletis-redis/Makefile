CC= gcc-5
CFLAGS= -std=c99

all: server

#server
server: srv log session cmd db 
	$(CC) $(CFLAGS) -o scar-srv $(SRVOBJS)

SRVOBJS= obj/server.o\
		 obj/log.o\
		 obj/session.o\
		 obj/cmd.o\
		 obj/db.o\
		 obj/cmds.o\
		 obj/list.o\
		 obj/table.o\
		 obj/hash.o

srv:
	$(CC) $(CFLAGS) -o obj/server.o -c src/server.c

session: log cmd
	$(CC) $(CFLAGS) -o obj/session.o -c src/session.c

cmd: cmds
	$(CC) $(CFLAGS) -o obj/cmd.o -c src/cmd.c

cmds: db
	$(CC) $(CFLAGS) -o obj/cmds.o -c src/cmds.c

#utils
log:
	$(CC) $(CFLAGS) -o obj/log.o -c src/log.c

hash:
	$(CC) $(CFLAGS) -o obj/hash.o -c src/hash.c

#data structures
db: hash table list sds
	$(CC) $(CFLAGS) -o obj/db.o -c src/db.c

list:
	$(CC) $(CFLAGS) -o obj/list.o -c src/list.c

table:
	$(CC) $(CFLAGS) -o obj/table.o -c src/table.c

sds:
	$(CC) $(CFLAGS) -o obj/sds.o -c src/sds.c

#cleanup
clean:
	rm -R *~ src/*~ scar-srv *.dSYM
