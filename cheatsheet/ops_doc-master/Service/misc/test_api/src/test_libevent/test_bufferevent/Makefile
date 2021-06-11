CC=g++
FLAG=-g
EVENT_PATH=../libeventoutput
LIBS=-L $(EVENT_PATH)/lib -levent
INCLUDES=-I $(EVENT_PATH)/include -I $(EVENT_PATH)/include/event2
SOURCESCPP=${wildcard *.cpp}
SOURCES=${patsubst %.cpp, %, $(SOURCESCPP)}
#PATH=$(shell pwd)
#LIBPATH=$(PATH)/libeventoutput/lib

all:
	#echo $(LIBPATH);
	#export LD_LIBRARY_PATH=/home/ccy/PDT/TestForVCP/src/test_libevent/libeventoutput/lib
	@for f in $(SOURCES); do \
		$(CC) -o $$f $$f.cpp $(FLAG) $(LIBS) $(INCLUDES); \
	done

clean:
	@for f in $(SOURCES); do \
		rm -rf $$f; \
	done
	rm -rf *.log;
	