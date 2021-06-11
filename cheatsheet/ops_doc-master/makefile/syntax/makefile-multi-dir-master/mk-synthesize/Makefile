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
DIR_SRC = ./user
DIR_BIN = ./bin
DIR_LIB = ./lib

SRC = $(wildcard ${DIR_SRC}/*.c)  
OBJ = $(patsubst %.c,${DIR_BIN}/%.o,$(notdir ${SRC})) 

TARGET = main
BIN_TARGET = ${DIR_BIN}/${TARGET}
LIBS := lib/bar/libbar.a lib/foo/libfoo.a
LDFLAGS = $(LIBS)

CFLAGS = -Wall -I${DIR_INC}
ifeq ($(DEBUG), y)
CFLAGS += -g
else
CFLAGS += -O2
endif

.PHONY:all clean

all:${BIN_TARGET}

${BIN_TARGET}:${OBJ}# $(TARGET).o
	for dir in $(DIR_LIB);do $(MAKE) -C $$dir all || exit 1; done
	$(CC) $^ -o $@ $(LDFLAGS)

${DIR_BIN}/%.o:$(DIR_SRC)/%.c
	$(CC) $(CFLAGS) -c $^ -o $@ 

#$(TARGET).o: $(TARGET).c
#	$(CC) $(CFLAGS) -c $^ -o $@

clean:
	find ${DIR_BIN} -name '*.o' | xargs rm -rf
	for dir in $(DIR_LIB);do $(MAKE) -C $$dir clean || exit 1; done
	$(RM) ${BIN_TARGET}
