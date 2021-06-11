%{
#include<stdio.h>
#include <math.h>
int cnt=0;  
%}

%%
"bits\"hyd" cnt++;
bits\  yymore() ;
"\"" yymore() ;
hyd yymore() ;
 
%%

int main(){
yylex() ; 
printf("%d\n",cnt) ;
}
