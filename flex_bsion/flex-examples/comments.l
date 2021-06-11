%option noyywrap
%{
int linenum = 0;
%}
%x comment
%%

"/*" BEGIN(comment); printf("comment=%d, YY_START = %d, YYSTATE = %d",comment,YY_START,YYSTATE);
<comment>\n ++linenum; /* update number of lines */
<comment>"*/" BEGIN(0);
<comment>. 

\n ECHO; linenum++;
.  ECHO;
%%
main() {
  yylex();
  printf("\n%d lines\n",linenum);
}
