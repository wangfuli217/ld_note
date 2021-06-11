%{
	#include "ch3-03.tab.h"
	#include <math.h>
	extern double vbltable[26];
%}
%%
([0-9]+|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?)	{
		yylval.dval = atof(yytext);
		return NUMBER;
	}
[ \t]	;		/*忽略空白*/
[a-z]	{	yylval.vblno = yytext[0] - 'a';
			return NAME;
		}
"$"		{	return 0; /*输入结束*/ }
\n		|
.		return yytext[0];
%%

/*
 flex ch3-03.l      # lex.yy.c
 bison -d ch3-03.y  # ch3-03.tab.h 与ch3-03.tab.c
 gcc -o ch3-03 ch3-03.tab.c lex.yy.c -lfl # ch3-03
 ./ch3-01
*/