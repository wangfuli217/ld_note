%{
// 2-count no of characters ,lines & words in a file
#include<stdio.h>
int count_c=0;// no of characters
int count_l=0;// no of lines
int count_w=0;// no of words
%}
%%
\t {count_w++;count_c++;};
" " {count_w++;count_c++;};
\n {count_c++;count_l++;count_w++;};
. count_c++;


%%
void main()
{
yyin=fopen("text.txt","r");
yylex();
printf("\n\nNumber of lines are:%d\n\n",count_l);
printf("\n\nNumber of words are:%d\n\n",count_w);
printf("\n\nNumber of characters are:%d\n\n",count_c);
}
