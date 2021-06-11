lex l.l 
bison -d p.y 
cc lex.yy.c p.tab.c -o fyparser
