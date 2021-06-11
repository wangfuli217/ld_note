%{
#include "ch3-01.tab.h"
extern int yylval;
%}
 
%%
[0-9]+	{ yylval = atoi(yytext); return NUMBER; }
[ \t]	;		/* ignore white space */
\n	return 0;	/* logical EOF */
.	return yytext[0];
%%

/*
 flex ch3-01.l      # lex.yy.c
 bison -d ch3-01.y  # ch3-01.tab.h 与ch3-01.tab.c
 gcc -o ch3-01 ch3-01.tab.c lex.yy.c -lfl # ch3-01
 ./ch3-01
*/