/* Reverse polish notation calculator.  */
/* 逆波兰记号计算器 */
/* 4 9 +   =13 */
/* 3 7 + 3 4 5 *+- = (3+7)-(3+4*5) =-13 */
/* 3 7 + 3 4 5 * + - n */
/* 3 7 + 3 4 5 * + - n
 *  =13
 *  5 6 / 4 n +
 *  =-3.166666667
 */

%{
	#define YYSTYPE double
	#include <math.h>
	#include <ctype.h>
	#include <stdio.h>

	int yylex (void);
	void yyerror (char const *);
%}

%token NUM

%% /* Grammar rules and actions follow.  */
/* 一个完整的输入己可能是一个空字符串, 也可能是一个完整输入后紧跟一个输入行 */
/* "完整输入"定义在它自己的条款中. 由于input总是出现在符号序列的最左端,
 * 我们称这种定义为左递归(left recursive). */
input:		/* empty */
	 		| input line
;

/* 第一个选择是一个换行符号; 这意味着rpcalc接受一个空白行 */
/* 第二个选择是一个表达式后紧跟着一个换行符. 这个选择使得rpcalc变得实用 */
line:		'\n'
			| exp '\n'	{ printf ("\t%.10g\n", $1); }

/* 当一个规则没有动作时,Bison会默认地将$1的值复制给$$.
 * 这就是在第一规则被(使用NUM的规则)识别时发生的事情. */
exp:		NUM				{ $$ = $1; }
   			| exp exp '+'	{ $$ = $1 + $2; }
   			| exp exp '-'	{ $$ = $1 - $2; }
   			| exp exp '*'	{ $$ = $1 * $2; }
   			| exp exp '/'	{ $$ = $1 / $2; }
   			| exp exp '^'	{ $$ = pow($1, $2); }
   			| exp 'n'		{ $$ = -$1; }
%%

int
yylex (void)
{
  int c;

  /* Skip white space.  */
  /* 处理空白. */
  while ((c = getchar ()) == ' ' || c == '\t')
    ;
  /* Process numbers.  */
  /* 处理数字 */
  if (c == '.' || isdigit (c))
    {
      ungetc (c, stdin);
      scanf ("%lf", &yylval);
      return NUM;
    }
  /* Return end-of-input.  */
  /* 返回输入结束 */
  if (c == EOF)
    return 0;
  /* Return a single char.  */
  /* 返回一个单一字符 */
  /* 任何不是数字的字符都是一个分隔记号. 注意到一个单个字符的记号是这个字符本身. */
  return c;
}

/* Called by yyparse on error.  */
void
yyerror (char const *s)
{
  fprintf (stderr, "%s\n", s);
}

int
main (void)
{
  return yyparse ();
}
