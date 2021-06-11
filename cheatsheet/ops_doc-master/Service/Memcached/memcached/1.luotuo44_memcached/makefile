CFLAGS+= -g -g3 -gdwarf-2 -pthread
LDFLAGS+=-pthread
CC = gcc -std=gnu99

PROGS=10.union_arr 3.slabs_init 9.break

all:$(PROGS)

10.union_arr:10.union_arr.o
	$(CC) $(CFLAGS) -o 10.union_arr 10.union_arr.o

3.slabs_init: 3.slabs_init.o
	$(CC) $(CFLAGS) -o 3.slabs_init 3.slabs_init.o

9.break: 9.break.o
	$(CC) $(CFLAGS) -o 9.break 9.break.o

clean:
	rm -f $(PROGS) *.o a.out

