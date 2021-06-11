%{
#include <stdio.h>
/*
lex example1.l 
cc lex.yy.c -o example1 -ll
*/
// 你想了解这个程序是怎么运行的，因为我们没有定义 main() 函数，其实 main() 函数定义在 libl(liblf) 中，编译的时候链接进来的。
%}

%%
stop printf("Stop command received\n");
start printf("Start command received\n");
%%