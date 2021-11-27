SONAME   = libfoobar.so.1
SHARED   = libfoobar.so.1.0.0
SOFILE   = libfoobar.so

CFLAGS  += -Wall -g -O2 -Werror -fPIC -I../includey
LDFLAGS += -shared -Wl,-soname,$(SONAME)

SRC      = $(wildcard *.c)
OBJ      = $(SRC:.c=.o)

.PHONY: all clean

all: $(SHARED) $(OBJ)

$(SHARED): $(OBJ)
	$(CC) $(LDFLAGS) -o $@ $^
	ln -sf $(SHARED) $(SONAME)
	ln -sf $(SHARED) $(SOFILE)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf *.o *.so.* *.a *.so