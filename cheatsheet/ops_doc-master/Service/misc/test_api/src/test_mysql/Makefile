CC=g++
FLAG=-g 
LIBS=-L  -lsqlite3
INCLUDES=-I ../sqlite-complie/build/include/
SOURCESCPP=${wildcard *.cpp}
SOURCES=${patsubst %.cpp, %, $(SOURCESCPP)}

all:
	@for f in $(SOURCES); do \
		$(CC) -o $$f $$f.cpp $(FLAG) $(INCLUDES) $(LIBS); \
	done

clean:
	@for f in $(SOURCES); do \
		rm -rf $$f; \
	done
	