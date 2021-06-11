%x comment
%%
int line_num = 1;

"/*"         BEGIN(comment);

<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             printf("%s%d\n", yytext, ++line_num);
<comment>"*"+"/"        BEGIN(INITIAL);
