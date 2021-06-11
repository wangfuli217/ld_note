#CC=gcc
CC=clang
#CFLAGS=-w
#CFLAGS=-w -g -O1 -D_FORTIFY_SOURCE=2
#CFLAGS=-w -g -fmudflap -lmudflap
CFLAGS=-w -g -fsanitize=address -fno-omit-frame-pointer
#CFLAGS=-w -g -fsanitize=memory -fPIE -pie -fno-omit-frame-pointer

SRC=$(wildcard tests/*.c)
OBJ=$(patsubst tests/%.c,bin/%,$(SRC))

bin/%: tests/%.c
	$(CC) $(CFLAGS) -o $@ $^

all: bin $(OBJ)

bin:
	mkdir -p bin

clean:
	rm -rf bin pico1 pico2

