%{  
int count_c=0,count_l=0,count_w=0;
%}
%%
\t {count_w++;count_c++;};
" " {count_w++;count_c++;};
\n {count_c++;count_l++;count_w++;};
. count_c++;
%%
int yywrap()
{	return 1;
}
void main()
{ 
    yyin = fopen("a.txt", "r");
    yylex();
    fclose(yyin);
  
    yyin = fopen("b.txt", "r");
    yylex();
    fclose(yyin);

    yyin = fopen("c.txt", "r");
    yylex();
    fclose(yyin);

    yyin = fopen("d.txt", "r");
    yylex();
    fclose(yyin);

    yyin = fopen("e.txt", "r");
    yylex();
    fclose(yyin);
 
    yyin = fopen("f.txt", "r");
    yylex();
    fclose(yyin);

    yyin = fopen("g.txt", "r");
    yylex();
    fclose(yyin);

    yyin = fopen("h.txt", "r");
    yylex();
    fclose(yyin);

    yyin = fopen("i.txt", "r");
    yylex();
    fclose(yyin);

    yyin = fopen("j.txt", "r");
    yylex();
    fclose(yyin);

    printf("\n\nThere are:-\n\n%d:characters\n\n%d:lines\n\n%d:words\n\nin 10 files\n\n",count_c,count_l,count_w);
}
