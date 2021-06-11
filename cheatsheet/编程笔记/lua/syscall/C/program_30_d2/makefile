CC = gcc 
LUA_INC := lua/src 
LIB_INC := lua/src/liblua.a
CFLAGS := -g -Wall -lm -I$(LUA_INC)
SHARED :=  -fPIC -shared

all : test testupvalue.so registrytest.so

test: test1.c
	$(CC) $(CFLAGS) $^ -o $@ $(LIB_INC) -ldl

testupvalue.so: lua-testupvalue.c  
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@  $(LIB_INC) -ldl

registrytest.so: lua-testregistry.c
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@  $(LIB_INC) -ldl

clean:
	-rm -f test
	-rm -f *.so