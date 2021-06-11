%%
<<EOF>> {printf("end of file\n"); return;}
%%

main() {
  yylex();
}

yywrap() {
  return 1;
}
