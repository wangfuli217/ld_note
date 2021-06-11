%
#typedef char* string; /* to specify token types as char* */
#define YYSTYPE string /* a Yacc variable which has the value of returned token */
%}
%token NAME EQ AGE
%%

Yacc 语法规则具有以下一般格式：
result: components   { /* action to be taken in C */ }
 ;
result 是规则描述的非终端符号。
components 是根据规则放在一起的不同的终端和非终端符号。
例如：
param : NAME EQ NAME {
 printf("\tName:%s\tValue(name):%s\n", $1,$3);}
     | NAME EQ VALUE{
     printf("\tName:%s\tValue(value):%s\n",$1,$3);}
;

lexer 通过 Yacc 的变量 yylval 返回这些值
char [A-Za-z]
name {char}+
%%
{name} { yylval = strdup(yytext);
return NAME; }


文件解析的语法
file : record file
 | record
 ;
 record: NAME EQ AGE {
 printf("%s is now %s years old!!!", $1, $3);}
 ;
 %%