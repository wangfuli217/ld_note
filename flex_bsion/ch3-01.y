%token NAME NUMBER
%%
statement:	NAME '=' expression
	|	expression		{ printf("= %d\n", $1); }
	;
 
expression:	expression '+' NUMBER	{ $$ = $1 + $3; }
	|	expression '-' NUMBER	{ $$ = $1 - $3; }
	|	NUMBER			{ $$ = $1; }
	;
%%
int main()
{
	yyparse();
	return 0;
}
 
int yyerror(char *s)
{
	printf("%s/n",s);
	return 0;
}