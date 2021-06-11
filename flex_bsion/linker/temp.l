%{
/*
1. 我们 include 头文件 y.tab.h；
2. 我们不再打印输出，而是返回标示(token)。
有这些变化主要是因为我们会将值传给 YACC，而不关心我们把什么输出到屏幕。y.tab.h 中定义了这些标示(token)。
*/

#include <stdio.h>
#include "y.tab.h"
%}
%%
[0-9]+          return NUMBER;           // return printf("NUMBER;         ");
Heater|heat     return TOKHEAT;          // return printf("TOKHEAT;        ");
on|off          return STATE;            // return printf("STATE;          ");
target          return TOKTARGET;        // return printf("TOKTARGET;      ");
temperature     return TOKTEMPERATURE;   // return printf("TOKTEMPERATURE; ");
\n              /* ignore end of line */ //printf("\n");
[ \t]+          /* ignore whitespace */
%%