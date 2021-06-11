CFLAGS = -Wall -g 
IFLAGS += -I$(TOP)

# Everyone needs these libs

LFLAGS += -L$(TOP) -lfirebert 

LFLAGS += -L$(TOP)/jenkins-hash -ljenkinshash

IFLAGS += -I$(TOP)/format
LFLAGS += -L$(TOP)/format -lfmt

IFLAGS += -I$(TOP)/../third-party/libevent-1.0b
LFLAGS += -L$(TOP)/../third-party/libevent-1.0b -levent

LFLAGS += -lcrypto

LFLAGS += -lpcap -lm

CFLAGS += $(IFLAGS)

%.test:				%.c
				perl $(TOP)/util/checksuite.pl $(^) > .test-main.c
				$(CC) $(CFLAGS) -c $(^)
				$(CC) $(CFLAGS) -c .test-main.c
				$(CC) $(CFLAGS) -o $@ $(^:.c=.o) .test-main.o $(LFLAGS)

YFLAGS +=			-d




