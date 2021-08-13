
UNITY_PATH=../../../C/Unity-master
UNITY_INCLUDE_PATH=$(UNITY_PATH)/src
UNITY_SRC=$(UNITY_PATH)/src/unity.c
UNITY_GENERATOR=ruby $(UNITY_PATH)/auto/generate_test_runner.rb
CC=gcc

CFLAGS=-I$(UNITY_INCLUDE_PATH) -std=c99

.PHONY: clean

all: hash_test

clean:
	$(RM) hash_test
	$(RM) hash_test_Runner.c

hash_test: hash_test_Runner.c ../hash_table.c ../hash_table.h ../hash_list.c ../hash_list.h hash_test.c
	$(CC) $(CFLAGS) -o hash_test hash_test_Runner.c	../hash_table.c ../hash_list.c hash_test.c $(UNITY_SRC)

hash_test_Runner.c:
	$(UNITY_GENERATOR) hash_test.c
