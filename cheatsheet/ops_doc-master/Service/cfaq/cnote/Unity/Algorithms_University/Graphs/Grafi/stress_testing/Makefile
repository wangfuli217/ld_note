
CC=gcc

CFLAGS=-std=c99 -O2

HASH_PATH=../../../Esercizio_2/Hash_table

.PHONY: clean

all: graph_stress_test

clean:
	$(RM) graph_stress_test

graph_stress_test: test.c test.h file.c file.h ../graph.c ../graph.h ../priority_queue.c ../priority_queue.h graph_stress.c $(HASH_PATH)/hash_table.c $(HASH_PATH)/hash_table.h $(HASH_PATH)/hash_list.c $(HASH_PATH)/hash_list.h
	$(CC) $(CFLAGS) -o graph_stress_test test.c file.c ../graph.c ../priority_queue.c graph_stress.c $(HASH_PATH)/hash_table.c $(HASH_PATH)/hash_list.c
