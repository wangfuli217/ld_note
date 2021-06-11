%{
// 3- count no of characters,lines and words in input string
int count_c=0;// no of characters
int count_l=0;// no of lines
int count_w=0;// no of words
%}
%%
[a-zA-Z]+ {count_w++;count_c+=strlen(yytext);};
. count_c++;
\n {count_c++;count_l++;};
\.$ printf("\n\nNumber of lines,words,characters are:%d,%d,%d\n\n",count_l+1,count_w,count_c+2);
%%

