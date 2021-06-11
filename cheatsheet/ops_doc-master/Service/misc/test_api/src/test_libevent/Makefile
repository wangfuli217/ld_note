CC=g++
FLAG=-g
CURRENT_PATH:=$(shell pwd)
LIBEVENT_GZ=libevent-2.0.10-stable.tar.gz
LIBEVENT_DIR=libevent-2.0.10-stable
LIBEVENT_BUILD=$(CURRENT_PATH)/libeventoutput
LIBS=-L $(LIBEVENT_BUILD)/lib -levent
INCLUDES=-I $(LIBEVENT_BUILD)/include -I $(LIBEVENT_BUILD)/include/event2
SOURCESCPP=${wildcard *.cpp}
SOURCES=${patsubst %.cpp, %, $(SOURCESCPP)}
#PATH=$(shell pwd)
#LIBPATH=$(PATH)/libeventoutput/lib

all:
	#echo $(LIBPATH);
	#export LD_LIBRARY_PATH=$(LIBPATH)
	@for f in $(SOURCES); do \
		$(CC) -o $$f $$f.cpp $(FLAG) $(LIBS) $(INCLUDES); \
	done

clean:
	@for f in $(SOURCES); do \
		rm -rf $$f; \
	done
	rm -rf *.log;
	
libevent:
	rm $(LIBEVENT_DIR) $(LIBEVENT_BUILD) -rf
	tar -xvf $(LIBEVENT_GZ)
	cd libevent-2.0.10-stable;./configure --prefix=$(LIBEVENT_BUILD);make;make install