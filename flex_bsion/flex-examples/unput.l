%%
[0-9]+ {
  int i;
  char *yycopy = (char *) strdup(yytext);

  unput(')');
  for(i=strlen(yycopy)-1; i>=0; --i)
    unput(yycopy[i]);
  unput('(');
  free(yycopy); 
}
\([0-9]+\) printf("Num inside parenthesis: %s\n",yytext);
.|\n
