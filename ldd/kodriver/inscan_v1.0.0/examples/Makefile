# Make some example applications using advcan device driver

CC=gcc

CFLAGS = -I../can4linux

CTAGS =	ctags --c-types=dtvf
CTAGS =	elvtags -tsevl
LDFLAG=-lrt 

BINS=baud  acceptance receive-block transmit-block \
   receive-nonblock transmit-nonblock \
   receive-select send-ioctl selfreception \
   singlefilter transmit-select showstat\

all: $(BINS)

$(BINS): % : %.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAG)

clean:
		-@rm -f acceptance baud  \
		transmit-block  \
		transmit-nonblock \
		send-ioctl \
		transmit-select \
		receive-block \
		receive-nonblock \
		receive-select \
		singlefilter \
		selfreception \
		showstat \
		*~


