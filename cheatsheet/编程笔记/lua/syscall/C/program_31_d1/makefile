LUA_LIB="/usr/local/lib/liblua.a"

array.so: array.c
	gcc -fPIC -c  array.c
	gcc -shared -o array.so array.o


clean:
	rm -f array.so array.o