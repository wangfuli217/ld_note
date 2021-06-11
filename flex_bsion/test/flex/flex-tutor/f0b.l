
/* No need to write our own yywrap() with this option */
%option noyywrap 

%%
   /* These rules do the same as the default empty one from f0.l  */
\n  |
.   ECHO;
%%

int main ()
{
  return yylex();
}
