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

exp:      NUM                { $$ = $1;         }
        | exp '+' exp        { $$ = $1 + $3;    }
        | exp '-' exp        { $$ = $1 - $3;    }
        | exp '*' exp        { $$ = $1 * $3;    }
        | exp '/' exp        { $$ = $1 / $3;    }
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
