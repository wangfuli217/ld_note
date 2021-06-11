LUA_LIB="/usr/local/lib/liblua.a"

mylib.so: mylib.c
	gcc -fPIC -c  mylib.c -llua
	gcc -fPIC -c  util.c  -llua
	gcc -shared -o mylib.so mylib.o util.o 


clean:
	rm -f mylib.so mylib.o