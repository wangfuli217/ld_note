RC      = $(wildcard *.c)
OBJ      = $(SRC:.c=.o)
LIB      = libfoobar

STATIC   = $(LIB).a
SHARED   = $(LIB).so.1.0.0
SONAME   = $(LIB).so.1
SOFILE   = $(LIB).so

CFLAGS  += -Wall -Werror -g -O2 -fPIC -I../includex
LDFLAGS += -shared -Wl,-soname,$(SONAME)

.PHONY: all clean

all: $(STATIC) $(SHARED) $(SONAME) $(SOFILE)

$(SOFILE): $(SHARED)
	ln -sf $(SHARED) $(SOFILE)

$(SONAME): $(SHARED)
	ln -sf $(SHARED) $(SONAME)

$(SHARED): $(STATIC)
	$(CC) $(LDFLAGS) -o $@ $<

$(STATIC): $(OBJ)
	$(AR) $(ARFLAGS) $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -rf *.o *.a *.so *.so.*