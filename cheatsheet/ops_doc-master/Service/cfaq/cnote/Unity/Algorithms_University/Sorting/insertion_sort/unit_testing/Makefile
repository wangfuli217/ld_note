
UNITY_PATH=../../../C/Unity-master
UNITY_INCLUDE_PATH=$(UNITY_PATH)/src
UNITY_SRC=$(UNITY_PATH)/src/unity.c
UNITY_GENERATOR=ruby $(UNITY_PATH)/auto/generate_test_runner.rb
CC=gcc

CFLAGS=-I$(UNITY_INCLUDE_PATH) -std=c99

.PHONY: clean

all: insertion_sort_test

clean:
	$(RM) insertion_sort_test
	$(RM) insertion_sort_test_Runner.c

insertion_sort_test: insertion_sort_test_Runner.c ../insertion_sort.c ../insertion_sort.h insertion_sort_test.c
	$(CC) $(CFLAGS) -o insertion_sort_test insertion_sort_test_Runner.c	../insertion_sort.c insertion_sort_test.c $(UNITY_SRC)

insertion_sort_test_Runner.c:
	$(UNITY_GENERATOR) insertion_sort_test.c
