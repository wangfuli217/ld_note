
CC=gcc

CFLAGS=-std=c99 -O2

.PHONY: clean

all: selection_sort_test

clean:
	$(RM) selection_sort_test

selection_sort_test: test.c test.h file.c file.h ../selection_sort.c ../selection_sort.h selection_sort_stress.c
	$(CC) $(CFLAGS) -o selection_sort_test test.c file.c ../selection_sort.c selection_sort_stress.c 

