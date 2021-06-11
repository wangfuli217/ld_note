%{
#include "y.tab.h"
extern int yylval;
void yyerror(char* s){
fprintf(stderr,"%s\n",s);
}
%}
%%
[0-9]+ {yylval = atoi(yytext);return NUMBER;}
[ \t] {;}
[\n] return 0;
. return yytext[0];
%%


