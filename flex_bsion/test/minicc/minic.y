%{
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

char finalSource[16384];
%}

%define parse.error verbose

%token INCLUDE
%token <source> IDENTIFIER CONSTANT STRING_LITERAL
%token LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP

%token VOID CHAR INT FLOAT DOUBLE

%token IF ELSE WHILE

%union {
    char source[4096];
}

%type <source> translation_unit external_declaration
%type <source> include
%type <source> declaration declaration_specifier type_specifier init_declarator declarator
%type <source> initializer expression assignment_expression conditional_expression
%type <source> logical_or_expression logical_and_expression inclusive_or_expression exclusive_or_expression
%type <source> and_expression equality_expression relational_expression shift_expression
%type <source> additive_expression multiplicative_expression cast_expression unary_expression
%type <source> postfix_expression primary_expression argument_expression_list
%type <source> function_definition declaration_list statement compound_statement statement_list
%type <source> expression_statement selection_statement iteration_statement

%start start

%%

start
    : translation_unit                          {strcpy(finalSource, $1);}

translation_unit
	: external_declaration                      {strcpy($$, $1);}
	| translation_unit external_declaration     {strcpy($$, $1);strcat($$, $2);}
	;

external_declaration
    : include                                   {strcpy($$, $1);}
    | declaration                               {strcpy($$, $1);}
    | function_definition                       {strcpy($$, $1);}
	;

include
    : INCLUDE STRING_LITERAL                    {strcpy($$, "#include ");strcat($$, $2);strcat($$, "\n");}
    ;

declaration
	: declaration_specifier ';'                 {strcpy($$, $1);strcat($$, ";");}
	;
declaration_specifier
    : type_specifier init_declarator            {strcpy($$, $1);strcat($$, $2);}
    | init_declarator                           {strcpy($$, $1);}
    ;

type_specifier
	: VOID                                      {strcpy($$, "void ");}
	| CHAR                                      {strcpy($$, "char ");}
	| INT                                       {strcpy($$, "int ");}
	| FLOAT                                     {strcpy($$, "float ");}
	| DOUBLE                                    {strcpy($$, "double ");}
	;

init_declarator
	: declarator                                {strcpy($$, $1);}
	| declarator '=' initializer                {strcpy($$, $1);strcat($$, "=");strcat($$, $3);}
	;

declarator
	: IDENTIFIER                                {strcpy($$, $1);}
	;

initializer
	: assignment_expression                     {strcpy($$, $1);}
	;

expression
	: assignment_expression                     {strcpy($$, $1);}
	| expression ',' assignment_expression      {strcpy($$, $1);strcat($$, ",");strcat($$, $3);}
	;

assignment_expression
	: conditional_expression                    {strcpy($$, $1);}
	;
conditional_expression
	: logical_or_expression                     {strcpy($$, $1);}
	;
logical_or_expression
	: logical_and_expression                    {strcpy($$, $1);}
	| logical_or_expression OR_OP logical_and_expression    {strcpy($$, $1);strcat($$, "||");strcat($$, $3);}
	;
logical_and_expression
	: inclusive_or_expression                   {strcpy($$, $1);}
	| logical_and_expression AND_OP inclusive_or_expression {strcpy($$, $1);strcat($$, "&&");strcat($$, $3);}
	;
inclusive_or_expression
	: exclusive_or_expression                   {strcpy($$, $1);}
	| inclusive_or_expression '|' exclusive_or_expression   {strcpy($$, $1);strcat($$, "|");strcat($$, $3);}
	;
exclusive_or_expression
	: and_expression                            {strcpy($$, $1);}
	| exclusive_or_expression '^' and_expression            {strcpy($$, $1);strcat($$, "^");strcat($$, $3);}
	;
and_expression
	: equality_expression                       {strcpy($$, $1);}
	| and_expression '&' equality_expression                {strcpy($$, $1);strcat($$, "&");strcat($$, $3);}
	;
equality_expression
	: relational_expression                     {strcpy($$, $1);}
	| equality_expression EQ_OP relational_expression       {strcpy($$, $1);strcat($$, "==");strcat($$, $3);}
	| equality_expression NE_OP relational_expression       {strcpy($$, $1);strcat($$, "!=");strcat($$, $3);}
	;
relational_expression
	: shift_expression                          {strcpy($$, $1);}
	| relational_expression '<' shift_expression            {strcpy($$, $1);strcat($$, "<");strcat($$, $3);}
	| relational_expression '>' shift_expression            {strcpy($$, $1);strcat($$, ">");strcat($$, $3);}
	| relational_expression LE_OP shift_expression          {strcpy($$, $1);strcat($$, "<=");strcat($$, $3);}
	| relational_expression GE_OP shift_expression          {strcpy($$, $1);strcat($$, ">=");strcat($$, $3);}
	;
shift_expression
	: additive_expression                       {strcpy($$, $1);}
	;
additive_expression
	: multiplicative_expression                 {strcpy($$, $1);}
	| additive_expression '+' multiplicative_expression     {strcpy($$, $1);strcat($$, "+");strcat($$, $3);}
	| additive_expression '-' multiplicative_expression     {strcpy($$, $1);strcat($$, "-");strcat($$, $3);}
	;
multiplicative_expression
	: cast_expression                           {strcpy($$, $1);}
	| multiplicative_expression '*' cast_expression         {strcpy($$, $1);strcat($$, "*");strcat($$, $3);}
	| multiplicative_expression '/' cast_expression         {strcpy($$, $1);strcat($$, "/");strcat($$, $3);}
	| multiplicative_expression '%' cast_expression         {strcpy($$, $1);strcat($$, "%");strcat($$, $3);}
	;
cast_expression
	: unary_expression                          {strcpy($$, $1);}
	;
unary_expression
	: postfix_expression                        {strcpy($$, $1);}
	;
postfix_expression
	: primary_expression                        {strcpy($$, $1);}
	| postfix_expression '[' expression ']'                 {strcpy($$, $1);strcat($$, "[");strcat($$, $3);strcat($$, "]");}
	| postfix_expression '(' ')'                            {strcpy($$, $1);strcat($$, "(");strcat($$, ")");}
	| postfix_expression '(' argument_expression_list ')'   {strcpy($$, $1);strcat($$, "(");strcat($$, $3);strcat($$, ")");}
	;
primary_expression
	: IDENTIFIER                                {strcpy($$, $1);}
	| CONSTANT                                  {strcpy($$, $1);}
	| STRING_LITERAL                            {strcpy($$, $1);}
	| '(' expression ')'                        {strcpy($$, "(");strcat($$, $2);strcat($$, ")");}
	;
argument_expression_list
	: assignment_expression                     {strcpy($$, $1);}
	| argument_expression_list ',' assignment_expression    {strcpy($$, $1);strcat($$, ",");strcat($$, $3);}
	;


function_definition
    : declaration_specifier '(' declaration_list ')' compound_statement {strcpy($$, $1);strcat($$, "(");strcat($$, $3);strcat($$, ")");strcat($$, $5);}
    | declaration_specifier '(' ')' compound_statement                  {strcpy($$, $1);strcat($$, "(");strcat($$, ")");strcat($$, $4);}
	;
declaration_list
	: declaration_specifier                     {strcpy($$, $1);}
	| declaration_list ',' declaration_specifier            {strcpy($$, $1);strcat($$, ",");strcat($$, $3);}
	;

statement
	: compound_statement                        {strcpy($$, $1);}
	| expression_statement                      {strcpy($$, $1);}
	| selection_statement                       {strcpy($$, $1);}
	| iteration_statement                       {strcpy($$, $1);}
	;
compound_statement
	: '{' '}'                                   {strcpy($$, "{");strcat($$, "}");}
	| '{' statement_list '}'                    {strcpy($$, "{");strcat($$, $2);strcat($$, "}");}
	;
statement_list
	: statement                                 {strcpy($$, $1);}
	| statement_list statement                  {strcpy($$, $1);strcat($$, $2);}
	;
expression_statement
	: ';'                                       {strcpy($$, ";");}
    | declaration                               {strcpy($$, $1);}
	| expression ';'                            {strcpy($$, $1);strcat($$, ";");}
	;
selection_statement
	: IF '(' expression ')' statement           {strcpy($$, "if");strcat($$, "(");strcat($$, $3);strcat($$, ")");strcat($$, $5);}
	| IF '(' expression ')' statement ELSE statement    {strcpy($$, "if");strcat($$, "(");strcat($$, $3);strcat($$, ")");strcat($$, $5);strcat($$, "else");strcat($$, $7);}
	;
iteration_statement
	: WHILE '(' expression ')' statement        {strcpy($$, "while");strcat($$, "(");strcat($$, $3);strcat($$, ")");strcat($$, $5);}
	;

%%

int main (void) {
	int result = yyparse();

    printf("%s", finalSource);

    return result;
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 