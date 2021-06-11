%{
/*
 * 例1-1 单词识别程序 ch1-02.l
 * 识别单词是否是动词
 */
%}
%%
[\t ]+          /*意味着空格的正闭包，忽略空白*/; 
is |
am |
are |
were |
was |
be |
being |
been |
do |
does |
did |
will |
would |
should |
can |
could |
has |
have |
had |
go		{printf("%s: is a verb\n",yytext);}
[a-zA-Z]+		{printf("%s: is not a verb\n",yytext);}
 
.|\n		{ECHO;/*通常的默认状态：输出匹配模式，复制标点或其它字符*/}
%%

int main()
{
	yyin = fopen("example.txt","r");
		yylex();
	fclose(yyin);
}
int yywrap()
{
	return 1;
}

/* 
flex  ch1-02.l      生成lex.yy.c
gcc -c lex.yy.c     生成lex.yy.o
gcc lex.yy.c -o ch1 生成ch1
./ch1
*/