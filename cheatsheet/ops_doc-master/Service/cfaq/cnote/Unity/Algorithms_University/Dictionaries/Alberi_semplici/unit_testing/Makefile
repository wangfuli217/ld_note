
UNITY_PATH=../../../C/Unity-master
UNITY_INCLUDE_PATH=$(UNITY_PATH)/src
UNITY_SRC=$(UNITY_PATH)/src/unity.c
UNITY_GENERATOR=ruby $(UNITY_PATH)/auto/generate_test_runner.rb
CC=gcc

CFLAGS=-I$(UNITY_INCLUDE_PATH) -std=c99

.PHONY: clean

all: tree_test

clean:
	$(RM) tree_test
	$(RM) tree_test_Runner.c

tree_test: tree_test_Runner.c ../alberi_semplici.c ../alberi_semplici.h tree_test.c
	$(CC) $(CFLAGS) -o tree_test tree_test_Runner.c	../alberi_semplici.c tree_test.c $(UNITY_SRC) -lm

tree_test_Runner.c:
	$(UNITY_GENERATOR) tree_test.c
