%option main
%{
#include <unistd.h>  
%}
%%
username    printf( "%s",  getlogin());
%%
