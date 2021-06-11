ALL: parser server 
CC = gcc
CFLAGS = -Wall -g 

SDIR = src
ODIR = obj
TDIR = util

IDIR = -I$(SDIR) -I$(ODIR) -I$(TDIR)
LDIR = -Llib
LIBS = -lpthread -levent

SRCS = $(wildcard $(SDIR)/*.c)
OBJS = $(patsubst $(SDIR)/%.c,$(ODIR)/%.o,$(wildcard $(SDIR)/*.c))


parser:
	bison --defines=$(ODIR)/parser.h $(TDIR)/parser.y -o $(ODIR)/parser.tab.c
	flex --outfile=$(ODIR)/parser.lex.c $(TDIR)/parser.l

PARSER_OBJ = $(ODIR)/parser.lex.c $(ODIR)/parser.tab.c


$(ODIR)/%.o:$(SDIR)/%.c
	$(CC) -o $@ -c $(CFLAGS) $< $(IDIR)


server: $(OBJS)
	$(CC) -o server $(CFLAGS) $(OBJS) $(IDIR) $(PARSER_OBJ) \
	$(LIBS)


clean:
	rm -rf $(ODIR)/*
	rm -rf server

