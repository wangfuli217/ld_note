PREFIX?=/usr/local
SBINPATH?=$(PREFIX)/sbin
MANPATH?=$(PREFIX)/man
CFLAGS+=-Wall
LDFLAGS+=
LIBS+=-lnetfilter_log -lnfnetlink
OBJS=udp-replicator.o recv_nflog.o

all: udp-replicator udp-replicator.8.gz

udp-replicator: udp-replicator.o recv_nflog.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^$> $(LIBS)

udp-replicator.8.gz: udp-replicator.8
	gzip -9 -c $^$> > $@

install:
	mkdir -p $(SBINPATH)
	mkdir -p $(MANPATH)/man8
	install -m 555 udp-replicator $(SBINPATH)/
	install -m 444 udp-replicator.8.gz $(MANPATH)/man8/

clean:
	make -C tests clean
	rm -f udp-replicator udp-replicator.8.gz $(OBJS)

test:
	make -C tests tinytest
	env sudo -E ./tests/tinytest
