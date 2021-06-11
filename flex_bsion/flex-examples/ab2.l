%option main
%option noyywrap
%option stack
%{
#include <stdio.h>
#include  <stdlib.h>
%}
%x estado_a
%%
^a { yy_push_state(estado_a);}
<estado_a>{
a      { yy_push_state(estado_a); }
b      { yy_pop_state();  }
b[^b\n]+    {   printf ("Error\n"); 
        while (YYSTATE != INITIAL)
          yy_pop_state();
        while (input() != '\n') ;
      }
(.|\n)  {  printf ("Error\n"); 
        while (YYSTATE != INITIAL)
          yy_pop_state();
        while (input() != '\n') ;
      }
}
.      {  printf ("Error\n");
        while (input() != '\n') ;
      }
\n      { printf("Aceptar\n");}
%%

