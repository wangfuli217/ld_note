CC=g++
FLAG=-g -lpthread
SOURCESCPP=${wildcard *.cpp}
SOURCES=${patsubst %.cpp, %, $(SOURCESCPP)}

all:
	@for f in $(SOURCES); do \
		$(CC) -o $$f $$f.cpp $(FLAG); \
	done

clean:
	@for f in $(SOURCES); do \
		rm -rf $$f; \
	done
	