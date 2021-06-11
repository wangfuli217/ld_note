CFLAGS := -std=c99 \
	-Wall -Wextra -pedantic \
	-Wshadow -Wpointer-arith -Wcast-qual -Wstrict-prototypes -Wmissing-prototypes \
	-D_GNU_SOURCE \
	$(CFLAGS)

all: test
test: test.o vmalloc.o

clean:
	$(RM) repose *.o parsers/*.o

.PHONY: clean