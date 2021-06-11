TARGET=list-test rbtree-test  set-test vector-test radix-tree-test
all:$(TARGET)
%.o:%.c
	$(CC) -c $(CFLAGS) $^ -o $@
rbtree-test:rbtree-test.o
	$(CC) $^ $(LDFLAGS)  -o $@
list-test:list-test.o
	$(CC)  $^ $(LDFLAGS) -o $@
set-test:set-test.o
	$(CC) $^ $(LDFLAGS)  -o $@
vector-test:vector-test.o
	$(CC)  $^ $(LDFLAGS) -o $@
radix-tree-test:radix-tree-test.o
	$(CC)  $^ $(LDFLAGS) -o $@
clean:
	rm -rf *.o $(TARGET)
