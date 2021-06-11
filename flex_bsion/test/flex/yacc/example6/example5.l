%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "example5.tab.h"
%}
%%
[0-9]+                  yylval=atoi(yytext); return NUMBER;
heat                    return TOKHEAT;
on|off                  yylval=!strcmp(yytext, "on"); return STATE;
target                  return TOKTARGET;
temperature             return TOKTEMPERATURE;
\n                      /* ignore linebreak */;
[ \t]+                  /* ignore tab */;
%%