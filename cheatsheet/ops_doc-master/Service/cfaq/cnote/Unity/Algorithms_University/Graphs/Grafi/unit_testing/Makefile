UNITY_PATH=../../../C/Unity-master
UNITY_INCLUDE_PATH=$(UNITY_PATH)/src
UNITY_SRC=$(UNITY_PATH)/src/unity.c
UNITY_GENERATOR=ruby $(UNITY_PATH)/auto/generate_test_runner.rb

CC=gcc

CFLAGS=-I$(UNITY_INCLUDE_PATH) -std=c99 -O2

HASH_PATH=../../../Esercizio_2/Hash_table

.PHONY: clean

all: graph_test

clean:
	$(RM) graph_test
	$(RM) graph_test_Runner.c

graph_test: graph_test_Runner.c ../graph.c ../graph.h ../priority_queue.c ../priority_queue.h graph_test.c $(HASH_PATH)/hash_table.c $(HASH_PATH)/hash_table.h $(HASH_PATH)/hash_list.c $(HASH_PATH)/hash_list.h
	$(CC) $(CFLAGS) -o graph_test graph_test_Runner.c	../graph.c ../priority_queue.c graph_test.c $(HASH_PATH)/hash_table.c $(HASH_PATH)/hash_list.c $(UNITY_SRC)

graph_test_Runner.c:
	$(UNITY_GENERATOR) graph_test.c
