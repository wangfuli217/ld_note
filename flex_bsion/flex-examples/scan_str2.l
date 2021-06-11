%%
[0-9]+     printf("num\n");
[a-zA-Z]+  printf("Id\n");
%%
main(int argc, char ** argv) {
int i;
YY_BUFFER_STATE p;

  for(i=1;i<argc;i++) {
    p = yy_scan_string(argv[i]);
    yylex();
    yy_delete_buffer(p);
  }
}

int yywrap() { return 1; }
