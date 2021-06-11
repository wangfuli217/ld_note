%%
[0-9]+     printf("num\n");
[a-zA-Z]+  printf("Id\n");
%%
main(int argc, char ** argv) {
int i;

  for(i=1;i<argc;i++) {
    yy_scan_string(argv[i]);
    yylex();
    yy_delete_buffer(YY_CURRENT_BUFFER);
  }
}

int yywrap() { return 1; }
