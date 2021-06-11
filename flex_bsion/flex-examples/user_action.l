%array
%{
#include <string.h>

int ctrl[YY_NUM_RULES];
#undef YY_USER_ACTION
#define YY_USER_ACTION { ++ctrl[yy_act]; }
%}
number [0-9]+
id   [a-zA-Z_]+[a-zA-Z0-9_]*
whites [ \t\n]+
%%
{id} 
{number} 
{whites}
. 
%%

int yywrap() {
  int i;

  for(i=1;i<YY_NUM_RULES;i++)
    printf("Rule %d: %d occurrences\n",i,ctrl[i]);
}
  

