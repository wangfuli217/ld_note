################################################################# 
# A demo Makefile 
# By xbb (http://xnzaa.github.io) 
# bugs: 
#   1. 需要显式指定各个编译目录的位置； 
################################################################# 
CC=gcc
DEBUG = y
RM = rm -rf
MAKE = make

DIR_INC = ./include
DIR_SRC_BAR = ./bar
DIR_SRC_FOO = ./foo
DIR_BIN = ./bin

SRC = $(wildcard ${DIR_SRC_BAR}/*.c)  
SRC += $(wildcard ${DIR_SRC_FOO}/*.c)  
OBJ = $(patsubst %.c,${DIR_BIN}/%.o,$(notdir ${SRC})) 

TARGET = main
BIN_TARGET = ${DIR_BIN}/${TARGET}

CFLAGS = -Wall -I${DIR_INC}
ifeq ($(DEBUG), y)
CFLAGS += -g
else
CFLAGS += -O2
endif

.PHONY:all clean

all:${BIN_TARGET}

#${BIN_TARGET}:${SRC} main.c
#	$(CC) $^ -o $@ -I${DIR_INC} 

${BIN_TARGET}:${OBJ} main.o
	$(CC) $^ -o $@ 

${DIR_BIN}/%.o:$(DIR_SRC_BAR)/%.c
	$(CC) $(CFLAGS) -c $^ -o $@ 

${DIR_BIN}/%.o:$(DIR_SRC_FOO)/%.c
	$(CC) $(CFLAGS) -c $^ -o $@ 

main.o:main.c
	$(CC) $(CFLAGS) -c $^ -o $@ 
clean:
	find ${DIR_BIN} . -name '*.o' -exec $(RM) '{}' \;
#	find ${DIR_BIN} -name '*.o' | xargs rm -rf
	$(RM) ${BIN_TARGET}
