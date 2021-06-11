%{
int count_line=0;
%}
%%
.* {count_line++;printf("%d-%s\n",count_line,yytext);}
%%
int yywrap()
{	return 1;
}
void main()
{ 
    yyin = fopen("CDLB414014.txt", "r");
    yylex();
    fclose(yyin);
}
