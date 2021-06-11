
main(argc,argv)
int argc;
char **argv;
{
      yylex();
      return 0;
}
int yywrap()
{
      return 1;
}