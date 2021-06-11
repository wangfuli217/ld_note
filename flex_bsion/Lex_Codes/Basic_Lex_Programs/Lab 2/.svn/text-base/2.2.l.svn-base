%{ 
#include <stdio.h> 
int p = 0,n=0,z=0; ;
%}
pos ([1-9][0-9]*) 
neg (-[1-9][0-9]*)
frac (({neg}[/]{pos})|({pos}[/]{pos})|({pos}[/]{neg})|({neg}[/]{neg}))

%% 
{pos} p++;
{neg} n++;
{frac} z++;

%%
int main()
{
printf("let's start\n");
yylex() ;
printf("number of positive %d\n",p) ;
printf("number of negative %d\n",n) ;
printf("number of fractions %d\n",z) ;

}
