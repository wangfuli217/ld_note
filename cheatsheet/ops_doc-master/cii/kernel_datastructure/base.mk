export
BASE_DIR=$(shell pwd)
DEBUG=y
LIBRARY_NAME=libdatastruct.a
INC=$(BASE_DIR)/inc
TEST=$(BASE_DIR)/test
LIB =$(BASE_DIR)/lib
CFLAGS=-I$(INC) -Wall 
LDFLAGS=-L$(LIB) -ldatastruct
ifeq ($(strip $(DEBUG)),y)
   CFLAGS += -g -DDEBUG
endif

CROSS_COMPILE=
CC=$(CROSS_COMPILE)gcc
