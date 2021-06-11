#CFLAGS+=-Wall -Wpedantic -I..
CFLAGS+=-I..
LDFLAGS+=
LIBS+=-lnetfilter_log -lnfnetlink
OBJS=check_blackbox.o check_recv_nflog.o tests.o tinytest.o ../recv_nflog.o

tinytest: $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^$> $(LIBS)

clean:
	rm -f $(OBJS) tinytest
