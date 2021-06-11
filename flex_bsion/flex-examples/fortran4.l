%array
%{
#include <string.h>
#undef YY_INPUT
#define YY_INPUT(buf,result,max) (result = my_input(buf,max))
%}
number [0-9]+
integer [+-]?{number}
float ({integer}\.{number}?|\.{number})(E{integer})?
label [A-Z0-9]+
id   [A-Z]{label}*
%%
DO/{label}={number}\, { printf("do loop\n"); }
{id} { printf("Identifier %s\n",yytext); }
{number} { printf("Num %d\n",atoi(yytext)); }
{float} { printf("Float %f\n",atof(yytext)); }
(.|\n) 
%%

int my_input(char *buf, int max)
{
  char *q1, *q2, *p = (char *) malloc(max);
  int i;
  if ('\0' != fgets(p,max,yyin)) {
    for(i=0, q1=buf, q2=p;(*q2 != '\0');q2++) {
      if (*q2 != ' ') { *q1++ = toupper(*q2); i++; };
    }
    free(p);
    return i;
  }
  else exit(0);
}


