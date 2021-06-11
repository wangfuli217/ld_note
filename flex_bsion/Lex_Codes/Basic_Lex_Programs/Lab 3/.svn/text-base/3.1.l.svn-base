%{
#include<stdio.h>
#include <math.h>
int npink=0,nink=0,npin=0 ;
%}

%%

pink  {npink++; REJECT;}
ink   {nink++; REJECT;}
pin   {npin++; REJECT;}
. | \n   ;   
%%
int main(){
yylex() ;
printf("%d %d %d",npink,nink,npin);
}
