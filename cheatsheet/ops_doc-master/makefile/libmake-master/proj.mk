.SUFFIXES:

include libmake/flags.mk
include libmake/pchecks.mk
include libmake/sanitize.mk

ifeq ($(TYPE),)
$(error "No TYPE defined")
endif

ifeq ($(TYPE),prog)
else ifeq ($(TYPE),lib)
else ifeq ($(TYPE),staticlib)
else
$(error "TYPE should be prog, lib or staticlib")
endif

ifeq ($(NAME),)
$(error "No NAME defined")
else ifeq ($(TYPE),prog)
EXEC_NAME = $(NAME)
else ifeq ($(TYPE),lib)
EXEC_NAME = $(NAME).so
CFLAGS  += -shared -fPIC
LDFLAGS += -shared -fPIC
else ifeq ($(TYPE),staticlib)
EXEC_NAME = $(NAME).a
endif

ifneq ($(TYPE),prog)
ifeq ($(OBJECTS),)
$(error "No OBJECTS defined")
endif
endif

HEADERS += $(OBJECTS:.o=.h)

.PHONY: clean all install

all: $(EXEC_NAME)

.ONESHELL:
clean:
	rm -rf $(OBJECTS) $(EXEC_NAME)
ifeq ($(TYPE),prog)
	rm -rf $(NAME).o
endif

.PRECIOUS: %.o
%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

ifeq ($(TYPE),prog)
%: %.o $(OBJECTS)
	$(CC) $(LDFLAGS) $^ -o $@
endif

ifeq ($(TYPE),lib)
%.so: $(OBJECTS)
	$(CC) $(LDFLAGS) $^ -o $@
endif

ifeq ($(TYPE),staticlib)
%.a: $(OBJECTS)
	ar rcs $@ $^
endif

.ONESHELL:
install: all
ifeq ($(DESTDIR),)
	$(warning "DESTDIR is not set, will assume DESTDIR=/usr/local")
	DESTDIR=/usr/local
endif

ifeq ($(LICENSE_FILES),)
	$(warning "LICENSE_FILES is not set")
else
	mkdir -p $(DESTDIR)/share/$(NAME)
	install -m 644 $(LICENSE_FILES) $(DESTDIR)/share/$(NAME)
endif

ifeq ($(TYPE),prog)
	mkdir -p $(DESTDIR)/bin
	install -m 755 $(EXEC_NAME) $(DESTDIR)/bin
else
	mkdir -p $(DESTDIR)/lib
	install -m 755 $(EXEC_NAME) $(DESTDIR)/lib

ifneq ($(TYPE),prog)
	mkdir -p $(DESTDIR)/include/$(NAME)
	install -m 644 $(HEADERS) $(DESTDIR)/include/$(NAME)
endif
endif

include libmake/cppcheck.mk
