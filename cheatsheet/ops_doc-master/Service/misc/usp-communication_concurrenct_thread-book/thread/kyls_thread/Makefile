#!/bin/sh

#OPT=-O3
DEBUG=-g 

CFLAGS=-Wall -Wno-format -fPIC $(OPT) $(DEBUG) 

CC=gcc
LIBS =
INCLUDE_PATH = -I./include/
LIB_PATH = 

SRCDIR := src
LIBDIR := lib

OBJS := $(addprefix $(SRCDIR)/, kyls_thread.o)
OBJTEST1 := $(addprefix $(SRCDIR)/, test1.o)
OBJECHO_SERVER := $(addprefix $(SRCDIR)/, echo_server.o)

LIBOUTPUT = $(LIBDIR)/libkyls.a $(LIBDIR)/libkyls.so

all: test1 echo_server $(LIBOUTPUT)

test1 : $(OBJTEST1) $(LIBOUTPUT)
	$(CC) $(INCLUDE_PATH) -o $@ $^
	
echo_server: $(OBJECHO_SERVER) $(LIBOUTPUT)
	$(CC) $(INCLUDE_PATH) -o $@ $^

$(LIBDIR)/libkyls.a : $(OBJS)
	mkdir -p $(LIBDIR) 
	ar cqs $@ $^

$(LIBDIR)/libkyls.so : $(OBJS)
	mkdir -p $(LIBDIR) 
	$(CC) -shared -o $@ $^

$(SRCDIR)/%.o: $(SRCDIR)/%.c
	$(CC) $(INCLUDE_PATH) -c $(CFLAGS) -o $@ $^

clean:
	rm -f $(SRCDIR)/*.o $(LIBDIR)/* test1

rebuild: clean all


