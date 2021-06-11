%{ 
#include <stdio.h> 
int p = 0,n=0,z=0; ;
%}
digit [0-9]
%% 
\+?{digit}+ p++;
-{digit}+ n++;
[+|-]?{digit}+.{digit}+ z++;

%%
int main()
{
printf("let's start\n");
yylex() ;
printf("number of positive %d\n",p) ;
printf("number of negative %d\n",n) ;
printf("number of fractions %d\n",z) ;

}
