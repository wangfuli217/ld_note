%{
#include <stdio.h>

int num_lines = 0; 
int num_chars = 0; 
int num_words = 0;

%}

%%
[^ \t\n\r\f\v]+ { ++num_words; num_chars += strlen(yytext); }
\n              { ++num_chars; ++num_lines; } 
.               { ++num_chars; }
%%

int main ()
{
  yylex();
  printf ("%8d %8d %8d\n", num_lines, num_words, num_chars);
}

int yywrap (void)
{
   return 1; 
}
