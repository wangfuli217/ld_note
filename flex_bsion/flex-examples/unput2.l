%array
%%
[a-z] {unput(toupper(yytext[0]));}
[A-Z] ECHO;
%%
