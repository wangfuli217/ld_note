%{ 
#include <stdio.h> 
%}
oct (0[0-7]+) 
hex ([x|X][0-9A-Fa-f]+) 
%% 
{oct} printf("octa\n");
{hex} printf("hexa\n");
[\n] return ;
%%
int main()
{
printf("let's start\n");
yylex() ;
}
