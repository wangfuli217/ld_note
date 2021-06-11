/* Infix notation calculator.  */
/* 中缀符号计算器 */

%{
	#define YYSTYPE double
	#include <math.h>
	#include <ctype.h>
	#include <stdio.h>

	int yylex (void);
	void yyerror (char const *);
%}

/* Bison declarations.  */
%token NUM
%left '-' '+'
%left '*' '/'
%left NEG     /* negation--unary minus */ /* 负号 */
%right '^'    /* exponentiation */ /* 幂运算 */

%% /* The grammar follows.  */ /*　下面是语法 */
input:    /* empty */
        | input line
;

line:     '\n'
        | exp '\n'  		{ printf ("\t%.10g\n", $1); }
		| error '\n'		{ yyerrok; }
;

/*
 操作符优先级是由声明所在行的顺序决定的.
 行号越大的操作符(在一页或者屏幕底端)具有越高的优先级.
 因此,幂运算具有最高优先级,负号(NEG)其次, 接这是`*'和`/'等等.

另外一个重要的特征是在语法部分的负号操作符中使用了%prec.
语法中的%prec只是简单的告诉Bison规则'| '-' exp与NEG有相同的优先级
 * */
exp:      NUM                { $$ = $1;         }
        | exp '+' exp        { $$ = $1 + $3;    }
        | exp '-' exp        { $$ = $1 - $3;    }
        | exp '*' exp        { $$ = $1 * $3;    }
        | exp '/' exp        { 
								if ($3) 
									$$ = $1 / $3;    
								else {
									$$ = $1;
									fprintf(stderr, "%d.%d-%d.%d: division by zero",
											@3.first_line, @3.first_column,
											@3.last_line, @3.last_column
											);
								}
							}
        | '-' exp  %prec NEG { $$ = -$2;        }
        | exp '^' exp        { $$ = pow ($1, $3); }
        | '(' exp ')'        { $$ = $2;         }
;
%%

int
yylex (void)
{
	int c;

	/* Skip white space.  */
	/* 处理空白. */
 	while ((c = getchar ()) == ' ' || c == '\t')
    	++yylloc.last_column;

	/* Step. */
	yylloc.first_line = yylloc.last_line;
	yylloc.first_column = yylloc.last_column;

  	/* Process numbers.  */
  	/* 处理数字 */
  	if (c == '.' || isdigit (c))
    {
		yylval = c - '0';
		++yylloc.last_column;
		while (isdigit (c = getchar()))
		{
			++yylloc.last_column;
			yylval = yylval * 10 + c - '0';
		}
    	ungetc (c, stdin);
      	return NUM;
    }
  	/* Return end-of-input.  */
  	/* 返回输入结束 */
  	if (c == EOF)
    	return 0;
  	/* Return a single char, and update location.  */
  	/* 返回一个单一字符,并且更新位置 */
	if (c == '\n')
	{
		++yylloc.last_line;
		yylloc.last_column = 0;
	} else {
		++yylloc.last_column;
	}
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
	yylloc.first_line = yylloc.last_line = 1;
	yylloc.first_column = yylloc.last_column = 0;
  	return yyparse ();
}
