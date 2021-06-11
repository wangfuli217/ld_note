#	$Id: Makefile,v 1.8 2008/07/10 16:44:14 dvermeir Exp $
#
CFLAGS=		-Wall -g
CC=		gcc
#
SOURCE=		microc.sh micro.y lex.l symbol.c symbol.h Makefile *.mi
#
all:		micro microc demo
micro:		micro.tab.o lex.yy.o symbol.o
		gcc $(CFLAGS) -o $@ $^

lex.yy.c:	lex.l micro.tab.h
		flex lex.l
#
#	Bison options:
#
#	-v	Generate micro.output showing states of LALR parser
#	-d	Generate micro.tab.h containing token type definitions
#
micro.tab.h\
micro.tab.c:	micro.y
		bison -v -d $^
##
demo:		microc micro demo.mi
		./microc demo.mi
#
CFILES=	$(filter %.c, $(SOURCE)) micro.tab.c lex.yy.c
HFILES=	$(filter %.h, $(SOURCE)) micro.tab.h
include make.depend
make.depend: 	$(CFILES) $(HFILES)
		gcc -M $(CFILES) >$@

clean:
		rm -f lex.yy.c micro.tab.[hc] *.o microc micro *.jasm *.class micro.output t?.s t?
#
tar:
		tar cvf micro.tar $(SOURCE)


