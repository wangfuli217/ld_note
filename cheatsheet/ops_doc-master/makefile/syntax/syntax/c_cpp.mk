CC = gcc
CXX = g++

LINK = g++

LIBS = -lz -lm -lpcre

CFLAGS = $(COMPILER_FLAGS) -c -g -fPIC
CXXFLAGS = $(COMPILER_FLAGS) -c -g -fPIC

TARGET=libad.so
INCLUDES = -I. -I../../

CXX_SRCS = main.cpp\ 
../../hookmask.cpp 

CC_SRCS = cJSON.c ZipCoding.c TransferCoding.c mem_manage.c

OBJFILE = $(CC_SRCS:.c=.o) $(CXX_SRCS:.cc=.o)

all:$(TARGET)

$(TARGET): $(OBJFILE)
	$(LINK) $^ $(LIBS) -Wall -fPIC -shared -o $@

%.o:%.c
	$(CC) -o $@ $(CFLAGS) $< $(INCLUDES)

%.o:%.cc
	$(CXX) -o $@ $(CXXFLAGS) $< $(INCLUDES)

install:
	tsxs -i -o $(TARGET)

clean:
	rm -rf $(TARGET)
	rm -rf $(OBJFILE)