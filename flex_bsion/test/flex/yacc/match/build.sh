lex flex.l 
bison -d yacc.y 
cc lex.yy.c yacc.tab.c -o fyparser
cat yacc.conf | ./fyparser