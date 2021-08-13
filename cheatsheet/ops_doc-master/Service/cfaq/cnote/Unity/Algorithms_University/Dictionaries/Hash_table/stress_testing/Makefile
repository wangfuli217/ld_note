
CC=gcc

CFLAGS=-std=c99 -O2

.PHONY: clean

all: hash_stress_test

clean:
	$(RM) hash_stress_test

hash_stress_test: test.c test.h file.c file.h ../hash_table.c ../hash_table.h ../hash_list.c ../hash_list.h hash_stress.c
	$(CC) $(CFLAGS) -o hash_stress_test test.c file.c ../hash_table.c ../hash_list.c hash_stress.c
