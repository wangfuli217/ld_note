%{
int yylineno;
%}
%%
\n {yylineno++;}
1[ \t\n]+2[ \t\n]+3[ \t\n]+ {printf("%d\n",yylineno); exit(yylineno);}
. 
%%
#include "lex.main.c"
