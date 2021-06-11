
LIB_SRCS=${wildcard *.c}
LIB_OBJS=${patsubst %.c,%.o,$(LIB_SRCS)}

%.o:%.c
	$(CC) -c $(CFLAGS) $< -o $@
lib:$(LIB_OBJS)
	ar -cr $(LIBRARY_NAME) $^
clean:
	rm -rf *.o *.a 
