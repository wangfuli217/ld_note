%{
#define YY_DECL char *scanner(int *numcount, int *idcount)
%}

num [0-9]+
id [a-z]+
%%
{num} {(*numcount)++;}
halt  {return ((char *) strdup(yytext));}
{id}  {(*idcount)++;}
%%
main() {
  int a,b;
  char *t;

  a = 0; b = 0;
  t = scanner(&a, &b);
  printf("numcount = %d, idcount = %d, yytext = %s\n",a,b,t);
  t = scanner(&a, &b);
  printf("numcount = %d, idcount = %d, yytext = %s\n",a,b,t);
}

int yywrap() {
  return 1;
}
