%%
one {printf("1\n"); return 1;}
.   {printf("First analyzer: %s\n",yytext);}
%%

int onewrap(void) {
  return 1;
}

