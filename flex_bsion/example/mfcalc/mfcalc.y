%{
	#include <math.h>	/* For math functions, cos(), sin(), etc.  */ /* 为了使用数学函数, cos(), sin(), 等等 */
	#include "calc.h"	/* Contains definition of `symrec'.  */ /* 包含了 `symrec'的定义 */
	#include <stdio.h>
	#include <ctype.h>
	#include <string.h>
	#include <stdlib.h>

	int yylex(void);
	void yyerror(char const *);
%}

/* 由于语义值值现在可以有多种类型,
 * 对每一个使用语义值的语法符号关联一个语义值类型是很必要的. 
 * 这些符号是NUM,VAR,FNCT,和exp.
 * 它们的在声明的时候已经指明了语义值类型(在中括号之间).*/
%union {
	double	val;	/* For returning numbers.  */ /* 返回的数值 */
	symrec	*tptr;	/* For returning symbol-table pointers.  */ /* 返回的符号表指针 */
}
%token	<val>	NUM			/* Simple double precision number.  */ /* 简单的双精度数值 */
%token	<tptr>	VAR	FNCT	/* Variable and Function.  */ /* 变量和函数 */
%type	<val>	exp
/* %type用来声明非终结符,就像%token用来声明符号类型(注:终结符)的一样.
 * 我们之前并没有%type是因为非终结符经常在定义它们的规则中隐含地声明.
 * 但是exp必须被明确地声明以便我们使用它的语义值类型. */

%right	'='
%left	'-' '+'
%left	'*' '/'
%left	NEG		/* negation--unary minus */ /* 负号 */
%right	'^'		/* exponentiation */ /* 幂 */
%%	/* The grammar follows.  */ 
input:	/* empty */
	 	| input	line
;

line:	'\n'
		| exp '\n'		{ printf("\t%.10g\n", $1); }
		| error	'\n'	{ yyerrok; }

exp:	NUM						{ $$ = $1; }
   		| VAR					{ $$ = $1->value.var; }
		| VAR '=' exp			{ $$ = $3; $1->value.var = $3; }
		| FNCT '(' exp ')'		{ $$ = (*($1->value.fnctptr))($3);}
		| exp '+' exp			{ $$ = $1 + $3; }
		| exp '-' exp			{ $$ = $1 - $3; }
		| exp '*' exp			{ $$ = $1 * $3; }
		| exp '/' exp			{ $$ = $1 / $3; }
		| '-' exp %prec NEG		{ $$ = -$2; }
		| exp '^' exp			{ $$ = pow($1, $3); }
		| '(' exp ')'			{ $$ = $2; }
/* End of grammar.  */
%%

/* Called by yyparse on error.  */
/* 出错时被yyparse调用 */
void
yyerror (char const *s)
{
	printf("%s\n", s);
}

struct init
{
	char const *fname;
	double (*fnct)(double);
};

struct init const arith_fncts[] = {
	"sin", sin,
	"cos", cos,
	"atan", atan,
	"ln", log,
	"exp", exp,
	"sqrt", sqrt,
	0, 0
};

/* The symbol table: a chain of `struct symrec'.  */
/* 符号表: `struct symrec'链表 */
symrec *sym_table;

/* Put arithmetic functions in table.  */
/* 将数学函数放入符号表(注:保留字的实现方式) */
void
init_table(void)
{
	int i;
	symrec *ptr;
	for (i=0; arith_fncts[i].fname != 0; i++)
	{
		ptr = putsym(arith_fncts[i].fname, FNCT);
		ptr->value.fnctptr = arith_fncts[i].fnct;
	}
}

int
main(void)
{
	init_table();
	return yyparse();
}

symrec *
putsym(char const *sym_name, int sym_type)
{
	symrec *ptr;
	ptr = (symrec *)malloc(sizeof(symrec));
	ptr->name = (char *)malloc(strlen(sym_name)+1);
	strcpy(ptr->name, sym_name);
	ptr->type = sym_type;
	ptr->value.var = 0;
	ptr->next = (struct symrec *)sym_table;
	sym_table = ptr;
	return ptr;
}

symrec *
getsym(char const *sym_name)
{
	symrec *ptr;
	for (ptr=sym_table; ptr != (symrec *)0; ptr=(symrec *)ptr->next)
		if (strcmp(ptr->name, sym_name) == 0)
			return ptr;
	return 0;
}

int
yylex(void)
{
	int c;
	
	/* Ignore white space, get first nonwhite character.  */
	/* 忽略空白,获取第一个非空白的字符 */
	while ((c = getchar ()) == ' ' || c == '\t');

	if (c == EOF)
		return 0;

	/* Char starts a number => parse the number.         */
	/* 以数字开头 => 分析数字 */
	if (c == '.' || isdigit(c))
	{
		ungetc(c, stdin);
		scanf("%lf", &yylval.val);
		return NUM;
	}

	/* Char starts an identifier => read the name.       */
	/* 以标识符开头 => 读取名称 */
	if (isalpha(c))
	{
		symrec *s;
		static char *symbuf = 0;
		static int length = 0;
		int i;

		/* Initially make the buffer long enough
         for a 40-character symbol name.  */
      	/* 在开始的时候使缓冲区足够容纳40字符长的符号名称*/
		if (length == 0)
			length = 40, symbuf = (char *)malloc(length+1);

		i = 0;
		do
		{
			/* If buffer is full, make it bigger.        */
          	/* 如果缓冲区已满,使它大一点 */
			if (i == length)
			{
				length *= 2;
				symbuf = (char *)realloc(symbuf, length+1);
			}
			/* Add this character to the buffer.         */
		  	/* 将这个字符加入缓冲区 */
			symbuf[i++] = c;
			/* Get another character.                    */
		  	/* 获取另外一个字符 */
			c = getchar();
		} while (isalnum(c));

		ungetc(c, stdin);
		symbuf[i] = '\0';

		s = getsym(symbuf);
		if (s == 0)
			s = putsym(symbuf, VAR);
		yylval.tptr = s;
		return s->type;
	}

	/* Any other character is a token by itself.        */
  	/* 其余的字符是自己为记号的字符 */
	return c;
}
