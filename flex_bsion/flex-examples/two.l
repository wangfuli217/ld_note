%%
two {printf("2\n"); return 2;}
.   {printf("Second analyzer: %s\n",yytext);}
%%
int twowrap(void) {
  return 1;
}
