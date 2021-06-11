%left '-''+'
%left '*''/'
%nonassoc UMINUS
%token NAME NUMBER
%%
statement: NAME'='NUMBER|expression
{printf("= %d\n",$1);};
expression :expression'+'expression {$$=$1+$3;}
|expression'-'expression {$$=$1-$3;}
|expression'*'expression {$$=$1*$3;}
|expression'/'expression {$$=$1/$3;}
|'(' expression ')' {$$=$2;}
|'-' expression %prec UMINUS {$$=-$2;}
|NUMBER {$$=$1;};
%%
