   
/* === flex definitions and directives === */

%%

   /* === flex rules === */

%%

/* === user code === */

int main ()
{
  return yylex();
}

int yywrap (void)
{
   return 1;
}
