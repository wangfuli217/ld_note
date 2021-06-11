CC = gcc
CFLAGS = -Wall -g

FRAME_LIBRARIES = -lsocket -lnsl

comp:			lang.tab.o lex.yy.o main.o error.o tree.o memory.o weed.o pretty.o symbol.o type.o code.o resource.o emit.o assembler.o asmutils.o
			$(CC) $(CFLAGS) lang.tab.o lex.yy.o main.o error.o tree.o memory.o weed.o pretty.o symbol.o type.o code.o resource.o emit.o assembler.o asmutils.o -o compiler -lfl

lang.tab.o:		lang.tab.c lang.tab.h
			$(CC) -c $(CFLAGS) lang.tab.c

lang.tab.c:		lang.y error.h tree.h 
			bison -d lang.y

lex.yy.o:		lex.yy.c 
			$(CC) -c $(CFLAGS) lex.yy.c

lex.yy.c:		lang.l memory.h error.h
			flex -s lang.l

main.o:			main.c *.h
			$(CC) -c $(CFLAGS) main.c

error.o:		error.c error.h
			$(CC) -c $(CFLAGS) error.c

tree.o:			tree.c tree.h memory.h error.h 
			$(CC) -c $(CFLAGS) tree.c

memory.o:		memory.c memory.h
			$(CC) -c $(CFLAGS) memory.c

weed.o:			weed.c weed.h error.h tree.h typedef.h
			$(CC) -c $(CFLAGS) weed.c

pretty.o:		pretty.c pretty.h tree.h symbol.h 
			$(CC) -c $(CFLAGS) pretty.c

symbol.o:		symbol.c symbol.h tree.h memory.h error.h
			$(CC) -c $(CFLAGS) symbol.c

type.o:			type.c type.h tree.h error.h symbol.h memory.h typedef.h  
			$(CC) -c $(CFLAGS) type.c

code.o:			code.c *.h
			$(CC) -c $(CFLAGS) code.c

resource.o:		resource.c *.h
			$(CC) -c $(CFLAGS) resource.c

emit.o:			emit.c *.h
			$(CC) -c $(CFLAGS) emit.c

assembler.o:		assembler.c *.h
			$(CC) -c $(CFLAGS) assembler.c

asmutils.o:		asmutils.c *.h
			$(CC) -c $(CFLAGS) asmutils.c

clean:
			- rm *.o lang.tab.c lang.tab.h lex.yy.c compiler.exe compiler.exe.stackdump 


