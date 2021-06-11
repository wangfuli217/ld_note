LUA_LIB="/usr/local/lib/liblua.a"

all: dir.so lxp.so

dir.so: dir.c
	gcc -fpic -c  dir.c
	gcc -shared -o dir.so dir.o

lxp.so: lxp.c
	gcc -fpic -c  lxp.c
	gcc -shared -o lxp.so lxp.o -l expat

clean:
	rm -f dir.so dir.o lxp.so lxp.o