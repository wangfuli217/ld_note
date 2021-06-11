%{
#include <stdio.h>
#include "p.tab.h"
#define YYSTYPE int;
extern YYSTYPE yylval;
%}
%%
[0-9]+                  {yylval=atoi(yytext); return NUMBER;}
heat                    return TOKHEAT;
on|off                  yylval=!strcmp(yytext,"on"); return STATE;
target                  return TOKTARGET;
temperature             return TOKTEMPERATURE;
Heater                  return HEATER;
\n                      /* ignore end of line */;
[ \t]+                  /* ignore whitespace */;
[a-zA-Z][a-zA-Z0-9]*    /* ignore words */;
%%