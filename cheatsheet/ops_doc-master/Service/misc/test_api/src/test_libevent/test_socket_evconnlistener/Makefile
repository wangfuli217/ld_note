CC=g++
FLAG=-g
LIBEVENT_BUILD=/root/libevent
LIBS=-L $(LIBEVENT_BUILD)/lib -levent
INCLUDES=-I $(LIBEVENT_BUILD)/include -I $(LIBEVENT_BUILD)/include/event2
SOURCESCPP=${wildcard *.cpp}
SOURCES=${patsubst %.cpp, %, $(SOURCESCPP)}

all:
	#export LD_LIBRARY_PATH=/root/libevent/lib
	@for f in $(SOURCES); do \
		$(CC) -o $$f $$f.cpp $(FLAG) $(LIBS) $(INCLUDES); \
	done

clean:
	@for f in $(SOURCES); do \
		rm -rf $$f; \
	done
	rm -rf *.log;
	