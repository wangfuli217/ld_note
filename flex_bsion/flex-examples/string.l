%{
#undef YY_INPUT
#define YY_INPUT(b,r,m) (r = yystringinput(b,m))
#define min(a,b) ((a<b)?(a):(b))
%}

%%
[0-9]+ printf("Num-");
[a-zA-Z][a-zA-Z_0-9]* printf("Id-");
[ \t]+
. printf("%c-",yytext[0]);
%%

extern char string[];
extern char *yyinputptr;
extern char *yyinputlim;

int yystringinput(char *buf, int maxsize) {
  int n = min(maxsize, yyinputlim-yyinputptr);  

  if (n > 0) {
    memcpy(buf, yyinputptr, n);
    yyinputptr += n;
  }
  return n;
}

int yywrap() { return 1; }
