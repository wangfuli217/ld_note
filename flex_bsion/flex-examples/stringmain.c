char string[] = "one=1;two=2";
char *yyinputptr;
char *yyinputlim;

main() {
  yyinputptr = string;
  yyinputlim = string + strlen(string);
  yylex();
  printf("\n");
}

