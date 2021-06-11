LUA_LIB="/usr/local/lib/liblua.a"

all: window

util.o: util.c
	gcc -c util.c -ldl -lm -llua

window.o: window.c
	gcc -c window.c -ldl -lm -llua
    
window: util.o window.o
	gcc window.o util.o -ldl -lm -llua -o window

clean:
	rm -f window window.o util.o