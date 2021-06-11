%{
#include <stdio.h>
#include "y.tab.h"
int yylval;
%}

%%

[0-9]+      yylval = atoi(yytext); return NUMBER;
heat|Heater        return TOKHEAT;
on|off      yylval = !strcmp(yytext, "on"); return STATE;
target      return TOKTARGET;
temperature return TOKTEMPERATURE;
\n          /* ignore */
[ \t]+      /* ignore whitespace */

%%
