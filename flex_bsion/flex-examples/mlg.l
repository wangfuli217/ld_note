%{
int yylineno;
%}
%%
\n {yylineno++;}
Owner[  \t\n]+and[  \t\n]+Operator[  \t\n]+Guide {exit(yylineno);}
. 
%%
#include "lex.main.c"
