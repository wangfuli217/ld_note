#	%M%(%I%)	%U%	%E%
#
CFLAGS=		-Wall -g
CC=		gcc
#
HH_FILES=	util.h names.h symtab.h types.h check.h
CC_FILES=	util.c names.c symtab.c types.c check.c
SOURCE=		Makefile $(CC_FILES) $(HH_FILES) minic.y lex.l mct.sh
#
#
all:		minic mct
minic:		minic.tab.o lex.yy.o $(CC_FILES:%.c=%.o)
		gcc $(CFLAGS) -o $@ $^

lex.yy.c:	lex.l minic.tab.h
		flex lex.l
#
include		make_dependencies
#
#	Bison options:
#
#	-v	Generate minic.output showing states of LALR parser
#	-d	Generate minic.tab.h containing token type definitions
#
minic.tab.h\
minic.tab.c:	minic.y
		bison -v -d $^
#
clean:
		rm -f lex.yy.c minic.tab.[hc] *.o mct minic *.jasm *.class minic.output
#
tar:
		tar cvf minic.tar $(SOURCE)
source:
		@echo $(SOURCE)
#
####### creating dependencies
#
make_dependencies: lex.yy.c minic.tab.c $(CC_FILES)
		$(CC) -M $(CC_FILES) lex.yy.c minic.tab.c >make_dependencies
#
####### sccs rules
#
delta:		
		@echo "Comment: \c"; read inp; \
		for f in $(SOURCE); do\
			[ -f SCCS/p.$$f ] && \
			{ echo "#$$f:"; sccs delget -y"\"$$inp\"" $$f; } done;\
			true
edit:
		@for f in $(SOURCE); do\
			[ ! -f SCCS/p.$$f ] && \
			{ echo "#$$f:"; sccs edit $$f; } done; true
create:
		@for f in $(SOURCE); do\
			[ ! -f SCCS/s.$$f ] && \
			{ echo "#$$f:"; sccs create $$f; } done; rm -f ,*; true


