CC 			= gcc
CFLAGS 		= -w
CSOURCES 	= lex.yy.c awk.tab.c main.c interpreter.c customstring.c customio.c
COBJECTS 	= $(CSOURCES:.c=.o) 

LEX			= flex

YACC		= bison
YACCFLAGS	= -d

EXECUTABLE 	= hawk

all: main 

main: lex.yy.o awk.tab.o main.o interpreter.o customstring.o customio.o 
	$(CC) $(CFLAGS) $(COBJECTS) -lm -o $(EXECUTABLE) 

lexfile: awk.lex
	$(LEX) awk.lex
	
yaccfile: lexfile awk.y
	$(YACC) $(YACCFLAGS) awk.y

lex.yy.o: lexfile yaccfile
	$(CC) $(CFLAGS) -c lex.yy.c
awk.tab.o: awk.tab.c
	$(CC) $(CFLAGS) -c awk.tab.c
main.o: main.c
	$(CC) $(CFLAGS) -c main.c
interpreter.o: interpreter.c
	$(CC) $(CFLAGS) -c interpreter.c
customstring.o: customstring.c
	$(CC) $(CFLAGS) -c customstring.c
customio.o: customio.c
	$(CC) $(CFLAGS) -c customio.c


clean: 
	rm -f ./*.o $(EXECUTABLE)
