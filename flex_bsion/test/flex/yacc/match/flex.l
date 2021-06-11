%{
#include <stdio.h>
#include "yacc.tab.h"
%}
%%
[0-9]+			return NUMBER;
heat 			return TOKHEAT;
on|off			return STATE;
target 			return TOKTARGET;
temperature		return TOKTEMPERATURE;
\n			;
[ \t]+			;
%%