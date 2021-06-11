CC:=gcc 
LINK:= -lpthread -lsqlite3
HEADER:= -I ./common/include/
DEBUG:=
CFLAGS:= -g -O0 $(HEADER) $(DEBUG)

COM_SRC_DIR:= ./common/src/
SER_SRC_DIR:= ./src_server/
CLI_SRC_DIR:= ./src_client/

COM_SRC:= debug.c
SER_SRC:=main_server.c parser_server.c thread_pool.c semi_generic_lqueue.c 
CLI_SRC:=main_client.c parser_client.c

COM_SRC_PATH:=$(addprefix $(COM_SRC_DIR),$(COM_SRC))
SER_SRC_PATH:=$(addprefix $(SER_SRC_DIR),$(SER_SRC))
CLI_SRC_PATH:=$(addprefix $(CLI_SRC_DIR),$(CLI_SRC))

TAR_DIR:=./elf/
SERVER_NAME:=server
CLIENT_NAME:=client

SER_TAR_PATH:=$(addprefix $(TAR_DIR),$(SERVER_NAME))
CLI_TAR_PATH:=$(addprefix $(TAR_DIR),$(CLIENT_NAME))


all:
	$(CC) $(CFLAGS) $(SER_SRC_PATH) $(COM_SRC_PATH) $(LINK) -o $(SER_TAR_PATH)
	$(CC) $(CFLAGS) $(CLI_SRC_PATH) $(COM_SRC_PATH) -o $(CLI_TAR_PATH)

clean:
	$(RM) $(SER_TAR_PATH) $(CLI_TAR_PATH)

