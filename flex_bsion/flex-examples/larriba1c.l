%%
poco {printf("%s",yytext); yymore(); }
.* {printf("%s",yytext); }
%%
