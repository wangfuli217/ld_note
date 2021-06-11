CC=g++
FLAG=-g
LIBS=-lpthread
SOURCESCPP=${wildcard *.cpp}
SOURCES=${patsubst %.cpp, %, $(SOURCESCPP)}

all:
	@for f in $(SOURCES); do \
		$(CC) -o $$f $$f.cpp $(FLAG) $(LIBS); \
	done

clean:
	@for f in $(SOURCES); do \
		rm -rf $$f; \
	done
	rm -rf *.log;
	