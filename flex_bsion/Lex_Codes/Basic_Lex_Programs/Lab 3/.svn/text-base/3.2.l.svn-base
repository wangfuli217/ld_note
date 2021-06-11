%{
#include<stdio.h>
#include <math.h>
int flag=0;
%}

%%

B[^B]* { if (flag == 0) {
flag = 1;
yymore();
}
else{
flag = 0; printf("%s%d\n",yytext,yyleng);
} 
}
%%

int main(){
yylex() ; 
return 0;
}
