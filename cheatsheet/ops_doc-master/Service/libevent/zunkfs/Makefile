FUSE_CFLAGS=$(shell pkg-config fuse --cflags)
FUSE_LIBS=$(shell pkg-config fuse --libs) 

ifndef LIBEVENT_PREFIX
LIBEVENT_PREFIX=.
endif

LDFLAGS=-lssl -lsqlite3 $(FUSE_LIBS) -L$(LIBEVENT_PREFIX)/lib -levent
CFLAGS=-g -Wall $(FUSE_CFLAGS) -DZUNKFS_OS=$(OS) -I$(LIBEVENT_PREFIX)/include \
       -Werror
OS=$(shell /usr/bin/env uname)

ifdef CHUNK_SIZE
CFLAGS+=-DCHUNK_SIZE=$(CHUNK_SIZE)
endif

ifeq ("$(OS)","Darwin")
LDFLAGS+=-lcrypto
LDFLAGS+=-framework CoreFoundation
endif

ifeq ("$(OS)","Linux")
FUSE_CFLAGS+=-D_FILE_OFFSET_BITS=64
CFLAGS+=-DHAVE_POSIX_FADVISE
endif

CORE_OBJS=chunk-tree.o \
	  chunk-db.o \
	  dir.o \
	  file.o \
	  utils.o \
	  mutex.o \
	  base64.o \
	  digest.o

DBTYPES=chunk-db-local.o \
	chunk-db-cmd.o \
	chunk-db-map.o \
	chunk-db-sqlite.o \
	chunk-db-mem.o \
	chunk-db-zdb.o \
	chunk-db-file.o

UNIT_TEST_OBJS=$(CORE_OBJS) \
	       unit-test-utils.o \
	       chunk-db-mem.o

FINAL_OBJS=zunkfs \
	   ctree-unit-test \
	   dir-unit-test \
	   file-unit-test \
	   zunkfs-list-ddents \
	   zunkfs-add-ddent \
	   zunkdb \
	   chunk-db-unit-test

all: ${FINAL_OBJS}

tests: ctree-unit-test dir-unit-test file-unit-test base64-test

cscope:
	find . -name '*.[ch]' > cscope.files
	cscope -b -i cscope.files

zunkfs: $(CORE_OBJS) $(DBTYPES) fuse.o
	$(CC) -o $@ $^ $(LDFLAGS)

ctree-unit-test: $(UNIT_TEST_OBJS) ctree-unit-test.o
	$(CC) $(CFLAGS) -o $@ $^  $(LDFLAGS)

dir-unit-test: $(UNIT_TEST_OBJS) dir-unit-test.o
	$(CC) $(CFLAGS) -o $@ $^  $(LDFLAGS)

file-unit-test: $(UNIT_TEST_OBJS) file-unit-test.o
	$(CC) $(CFLAGS) -o $@ $^  $(LDFLAGS)

zunkfs-list-ddents: $(CORE_OBJS) $(DBTYPES) zunkfs-list-ddents.o 
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

zunkfs-add-ddent: $(CORE_OBJS) $(DBTYPES) zunkfs-add-ddent.o 
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

zunkdb: $(CORE_OBJS) $(DBTYPES) zunkdb.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

chunk-db-unit-test: $(CORE_OBJS) $(DBTYPES) chunk-db-unit-test.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

base64-test: base64-test.o base64.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

clean:
	@rm -f $(FINAL_OBJS) *.o *.out *.log core cscope.*

