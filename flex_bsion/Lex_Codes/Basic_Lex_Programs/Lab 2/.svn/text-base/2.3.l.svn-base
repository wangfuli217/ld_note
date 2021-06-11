%{ 
#include <stdio.h> 
int l= 0,w=0,c=0,b=0 ;
%}
digit [0-9]
%% 
[\n] l++;
[#|<|>|]?[a-zA-z][a-zA-z]+[.|>|]?[a-zA-z][a-zA-z]+[.|>|]? w++;
[a-zA-Z] c++;
[ ] b++;
[{|}|;|(|)|>]
%%
int main()
{
printf("let's start\n");
yyin = fopen("input.c","r") ;
yylex() ;
printf("\n");
printf("number of lines %d\n",l) ;
printf("number of words %d\n",w) ;
printf("number of chars %d\n",c) ;
printf("number of blanks %d\n",b) ;

}
