/*
* Grammar for Lua 5.1
* Dummy for now. Used to define token values.
*/

%{

%}

%token TK_EOF 0

%token TK_AND 257
%token TK_BREAK
%token TK_DO
%token TK_ELSE
%token TK_ELSEIF
%token TK_END
%token TK_FALSE
%token TK_FOR
%token TK_FUNCTION
%token TK_IF
%token TK_IN
%token TK_LOCAL
%token TK_NIL
%token TK_NOT
%token TK_OR
%token TK_REPEAT
%token TK_RETURN
%token TK_THEN
%token TK_TRUE
%token TK_UNTIL
%token TK_WHILE

%token TK_CONCAT
%token TK_DOTS
%token TK_EQ
%token TK_GE
%token TK_LE
%token TK_NE
%token TK_NUMBER
%token TK_NAME
%token TK_STRING

%token TK_LONGSTRING
%token TK_SHORTCOMMENT;
%token TK_LONGCOMMENT;
%token TK_WHITESPACE;
%token TK_NEWLINE;
%token TK_BADCHAR;

%%

start    :  Lua
        ;

Lua      :
        ;


%%

int yymain( int argc, char ** argv )
{
  return 0;
}