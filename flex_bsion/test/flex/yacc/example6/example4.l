%{
#include <stdio.h>
#include "example4.tab.h"
%}
%%
[0-9]+                  return NUMBER;
heat                    return TOKHEAT;
on|off                  return STATE;
target                  return TOKTARGET;
temperature             return TOKTEMPERATURE;
\n                      /* ignore linebreak */;
[ \t]+                  /* ignore tab */;
%%