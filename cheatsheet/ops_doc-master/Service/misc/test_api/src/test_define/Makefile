CC=g++
FLAG=-g
SOURCESCPP=${wildcard *.cpp}
SOURCES=${patsubst %.cpp, %, $(SOURCESCPP)}

all:
	@for f in $(SOURCES); do \
		$(CC) -o $$f $$f.cpp $(FLAG); \
	done
	#查看宏展开代码
	@for f in $(SOURCES); do \
		$(CC) -E -o $$f.i -c $$f.cpp; \
	done
	
clean:
	@for f in $(SOURCES); do \
		rm -rf $$f; \
	done
	