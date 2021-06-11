%{
#include<stdio.h>
#include <math.h>
%}
%s expect
%%
expect-floats  BEGIN(expect) ;
<expect>[0-9]+"."[0-9]+ {
printf( "found a float, = %f\n",atof( yytext ));}
<expect>\n    {BEGIN(INITIAL);}
[0-9]+ {printf( "found an integer, = %d\n",atoi( yytext ) );}
"." {printf( "found a dot\n" );}
%%
int main(){
yylex() ;
}
